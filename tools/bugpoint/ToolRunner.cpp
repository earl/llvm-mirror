//===-- ToolRunner.cpp ----------------------------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the interfaces described in the ToolRunner.h file.
//
//===----------------------------------------------------------------------===//

#define DEBUG_TYPE "toolrunner"
#include "ToolRunner.h"
#include "llvm/Config/config.h"   // for HAVE_LINK_R
#include "llvm/System/Program.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/FileUtilities.h"
#include <fstream>
#include <sstream>
#include <iostream>
using namespace llvm;

namespace {
  cl::opt<std::string>
  RemoteClient("remote-client",
               cl::desc("Remote execution client (rsh/ssh)"));

  cl::opt<std::string>
  RemoteHost("remote-host",
             cl::desc("Remote execution (rsh/ssh) host"));

  cl::opt<std::string>
  RemotePort("remote-port",
             cl::desc("Remote execution (rsh/ssh) port"));

  cl::opt<std::string>
  RemoteUser("remote-user",
             cl::desc("Remote execution (rsh/ssh) user id"));

  cl::opt<std::string>
  RemoteExtra("remote-extra-options",
          cl::desc("Remote execution (rsh/ssh) extra options"));
}

ToolExecutionError::~ToolExecutionError() throw() { }

/// RunProgramWithTimeout - This function provides an alternate interface to the
/// sys::Program::ExecuteAndWait interface.
/// @see sys:Program::ExecuteAndWait
static int RunProgramWithTimeout(const sys::Path &ProgramPath,
                                 const char **Args,
                                 const sys::Path &StdInFile,
                                 const sys::Path &StdOutFile,
                                 const sys::Path &StdErrFile,
                                 unsigned NumSeconds = 0,
                                 unsigned MemoryLimit = 0) {
  const sys::Path* redirects[3];
  redirects[0] = &StdInFile;
  redirects[1] = &StdOutFile;
  redirects[2] = &StdErrFile;
                                   
  if (0) {
    std::cerr << "RUN:";
    for (unsigned i = 0; Args[i]; ++i)
      std::cerr << " " << Args[i];
    std::cerr << "\n";
  }

  return
    sys::Program::ExecuteAndWait(ProgramPath, Args, 0, redirects,
                                 NumSeconds, MemoryLimit);
}



static void ProcessFailure(sys::Path ProgPath, const char** Args) {
  std::ostringstream OS;
  OS << "\nError running tool:\n ";
  for (const char **Arg = Args; *Arg; ++Arg)
    OS << " " << *Arg;
  OS << "\n";

  // Rerun the compiler, capturing any error messages to print them.
  sys::Path ErrorFilename("bugpoint.program_error_messages");
  std::string ErrMsg;
  if (ErrorFilename.makeUnique(true, &ErrMsg)) {
    std::cerr << "Error making unique filename: " << ErrMsg << "\n";
    exit(1);
  }
  RunProgramWithTimeout(ProgPath, Args, sys::Path(""), ErrorFilename,
                        ErrorFilename); // FIXME: check return code ?

  // Print out the error messages generated by GCC if possible...
  std::ifstream ErrorFile(ErrorFilename.c_str());
  if (ErrorFile) {
    std::copy(std::istreambuf_iterator<char>(ErrorFile),
              std::istreambuf_iterator<char>(),
              std::ostreambuf_iterator<char>(OS));
    ErrorFile.close();
  }

  ErrorFilename.eraseFromDisk();
  throw ToolExecutionError(OS.str());
}

//===---------------------------------------------------------------------===//
// LLI Implementation of AbstractIntepreter interface
//
namespace {
  class LLI : public AbstractInterpreter {
    std::string LLIPath;          // The path to the LLI executable
    std::vector<std::string> ToolArgs; // Args to pass to LLI
  public:
    LLI(const std::string &Path, const std::vector<std::string> *Args)
      : LLIPath(Path) {
      ToolArgs.clear ();
      if (Args) { ToolArgs = *Args; }
    }

    virtual int ExecuteProgram(const std::string &Bitcode,
                               const std::vector<std::string> &Args,
                               const std::string &InputFile,
                               const std::string &OutputFile,
                               const std::vector<std::string> &GCCArgs,
                               const std::vector<std::string> &SharedLibs =
                               std::vector<std::string>(),
                               unsigned Timeout = 0,
                               unsigned MemoryLimit = 0);
  };
}

int LLI::ExecuteProgram(const std::string &Bitcode,
                        const std::vector<std::string> &Args,
                        const std::string &InputFile,
                        const std::string &OutputFile,
                        const std::vector<std::string> &GCCArgs,
                        const std::vector<std::string> &SharedLibs,
                        unsigned Timeout,
                        unsigned MemoryLimit) {
  if (!SharedLibs.empty())
    throw ToolExecutionError("LLI currently does not support "
                             "loading shared libraries.");

  std::vector<const char*> LLIArgs;
  LLIArgs.push_back(LLIPath.c_str());
  LLIArgs.push_back("-force-interpreter=true");

  // Add any extra LLI args.
  for (unsigned i = 0, e = ToolArgs.size(); i != e; ++i)
    LLIArgs.push_back(ToolArgs[i].c_str());

  LLIArgs.push_back(Bitcode.c_str());
  // Add optional parameters to the running program from Argv
  for (unsigned i=0, e = Args.size(); i != e; ++i)
    LLIArgs.push_back(Args[i].c_str());
  LLIArgs.push_back(0);

  std::cout << "<lli>" << std::flush;
  DEBUG(std::cerr << "\nAbout to run:\t";
        for (unsigned i=0, e = LLIArgs.size()-1; i != e; ++i)
          std::cerr << " " << LLIArgs[i];
        std::cerr << "\n";
        );
  return RunProgramWithTimeout(sys::Path(LLIPath), &LLIArgs[0],
      sys::Path(InputFile), sys::Path(OutputFile), sys::Path(OutputFile),
      Timeout, MemoryLimit);
}

// LLI create method - Try to find the LLI executable
AbstractInterpreter *AbstractInterpreter::createLLI(const std::string &ProgPath,
                                                    std::string &Message,
                                     const std::vector<std::string> *ToolArgs) {
  std::string LLIPath = FindExecutable("lli", ProgPath).toString();
  if (!LLIPath.empty()) {
    Message = "Found lli: " + LLIPath + "\n";
    return new LLI(LLIPath, ToolArgs);
  }

  Message = "Cannot find `lli' in executable directory or PATH!\n";
  return 0;
}

//===---------------------------------------------------------------------===//
// Custom execution command implementation of AbstractIntepreter interface
//
// Allows using a custom command for executing the bitcode, thus allows,
// for example, to invoke a cross compiler for code generation followed by 
// a simulator that executes the generated binary.
namespace {
  class CustomExecutor : public AbstractInterpreter {
    std::string ExecutionCommand;
    std::vector<std::string> ExecutorArgs;
  public:
    CustomExecutor(
      const std::string &ExecutionCmd, std::vector<std::string> ExecArgs) :
      ExecutionCommand(ExecutionCmd), ExecutorArgs(ExecArgs) {}

    virtual int ExecuteProgram(const std::string &Bitcode,
                               const std::vector<std::string> &Args,
                               const std::string &InputFile,
                               const std::string &OutputFile,
                               const std::vector<std::string> &GCCArgs,
                               const std::vector<std::string> &SharedLibs =
                               std::vector<std::string>(),
                               unsigned Timeout = 0,
                               unsigned MemoryLimit = 0);
  };
}

int CustomExecutor::ExecuteProgram(const std::string &Bitcode,
                        const std::vector<std::string> &Args,
                        const std::string &InputFile,
                        const std::string &OutputFile,
                        const std::vector<std::string> &GCCArgs,
                        const std::vector<std::string> &SharedLibs,
                        unsigned Timeout,
                        unsigned MemoryLimit) {

  std::vector<const char*> ProgramArgs;
  ProgramArgs.push_back(ExecutionCommand.c_str());

  for (std::size_t i = 0; i < ExecutorArgs.size(); ++i)
    ProgramArgs.push_back(ExecutorArgs.at(i).c_str());
  ProgramArgs.push_back(Bitcode.c_str());
  ProgramArgs.push_back(0);

  // Add optional parameters to the running program from Argv
  for (unsigned i=0, e = Args.size(); i != e; ++i)
    ProgramArgs.push_back(Args[i].c_str());

  return RunProgramWithTimeout(
    sys::Path(ExecutionCommand),
    &ProgramArgs[0], sys::Path(InputFile), sys::Path(OutputFile), 
    sys::Path(OutputFile), Timeout, MemoryLimit);
}

// Custom execution environment create method, takes the execution command
// as arguments
AbstractInterpreter *AbstractInterpreter::createCustom(
                    const std::string &ProgramPath,
                    std::string &Message,
                    const std::string &ExecCommandLine) {

  std::string Command = "";
  std::vector<std::string> Args;
  std::string delimiters = " ";

  // Tokenize the ExecCommandLine to the command and the args to allow
  // defining a full command line as the command instead of just the
  // executed program. We cannot just pass the whole string after the command
  // as a single argument because then program sees only a single
  // command line argument (with spaces in it: "foo bar" instead 
  // of "foo" and "bar").

  // code borrowed from: 
  // http://oopweb.com/CPP/Documents/CPPHOWTO/Volume/C++Programming-HOWTO-7.html
  std::string::size_type lastPos = 
    ExecCommandLine.find_first_not_of(delimiters, 0);
  std::string::size_type pos = 
    ExecCommandLine.find_first_of(delimiters, lastPos);

  while (std::string::npos != pos || std::string::npos != lastPos) {
    std::string token = ExecCommandLine.substr(lastPos, pos - lastPos);
    if (Command == "")
       Command = token;
    else
       Args.push_back(token);
    // Skip delimiters.  Note the "not_of"
    lastPos = ExecCommandLine.find_first_not_of(delimiters, pos);
    // Find next "non-delimiter"
    pos = ExecCommandLine.find_first_of(delimiters, lastPos);
  }

  std::string CmdPath = FindExecutable(Command, ProgramPath).toString();
  if (CmdPath.empty()) {
    Message = 
      std::string("Cannot find '") + Command + 
      "' in executable directory or PATH!\n";
    return 0;
  }

  Message = "Found command in: " + CmdPath + "\n";

  return new CustomExecutor(CmdPath, Args);
}

//===----------------------------------------------------------------------===//
// LLC Implementation of AbstractIntepreter interface
//
GCC::FileType LLC::OutputCode(const std::string &Bitcode, 
                              sys::Path &OutputAsmFile) {
  sys::Path uniqueFile(Bitcode+".llc.s");
  std::string ErrMsg;
  if (uniqueFile.makeUnique(true, &ErrMsg)) {
    std::cerr << "Error making unique filename: " << ErrMsg << "\n";
    exit(1);
  }
  OutputAsmFile = uniqueFile;
  std::vector<const char *> LLCArgs;
  LLCArgs.push_back (LLCPath.c_str());

  // Add any extra LLC args.
  for (unsigned i = 0, e = ToolArgs.size(); i != e; ++i)
    LLCArgs.push_back(ToolArgs[i].c_str());

  LLCArgs.push_back ("-o");
  LLCArgs.push_back (OutputAsmFile.c_str()); // Output to the Asm file
  LLCArgs.push_back ("-f");                  // Overwrite as necessary...
  LLCArgs.push_back (Bitcode.c_str());      // This is the input bitcode
  LLCArgs.push_back (0);

  std::cout << "<llc>" << std::flush;
  DEBUG(std::cerr << "\nAbout to run:\t";
        for (unsigned i=0, e = LLCArgs.size()-1; i != e; ++i)
          std::cerr << " " << LLCArgs[i];
        std::cerr << "\n";
        );
  if (RunProgramWithTimeout(sys::Path(LLCPath), &LLCArgs[0],
                            sys::Path(), sys::Path(), sys::Path()))
    ProcessFailure(sys::Path(LLCPath), &LLCArgs[0]);

  return GCC::AsmFile;                              
}

void LLC::compileProgram(const std::string &Bitcode) {
  sys::Path OutputAsmFile;
  OutputCode(Bitcode, OutputAsmFile);
  OutputAsmFile.eraseFromDisk();
}

int LLC::ExecuteProgram(const std::string &Bitcode,
                        const std::vector<std::string> &Args,
                        const std::string &InputFile,
                        const std::string &OutputFile,
                        const std::vector<std::string> &ArgsForGCC,
                        const std::vector<std::string> &SharedLibs,
                        unsigned Timeout,
                        unsigned MemoryLimit) {

  sys::Path OutputAsmFile;
  OutputCode(Bitcode, OutputAsmFile);
  FileRemover OutFileRemover(OutputAsmFile);

  std::vector<std::string> GCCArgs(ArgsForGCC);
  GCCArgs.insert(GCCArgs.end(), SharedLibs.begin(), SharedLibs.end());
  GCCArgs.insert(GCCArgs.end(), gccArgs.begin(), gccArgs.end());

  // Assuming LLC worked, compile the result with GCC and run it.
  return gcc->ExecuteProgram(OutputAsmFile.toString(), Args, GCC::AsmFile,
                             InputFile, OutputFile, GCCArgs,
                             Timeout, MemoryLimit);
}

/// createLLC - Try to find the LLC executable
///
LLC *AbstractInterpreter::createLLC(const std::string &ProgramPath,
                                    std::string &Message,
                                    const std::vector<std::string> *Args,
                                    const std::vector<std::string> *GCCArgs) {
  std::string LLCPath = FindExecutable("llc", ProgramPath).toString();
  if (LLCPath.empty()) {
    Message = "Cannot find `llc' in executable directory or PATH!\n";
    return 0;
  }

  Message = "Found llc: " + LLCPath + "\n";
  GCC *gcc = GCC::create(ProgramPath, Message, GCCArgs);
  if (!gcc) {
    std::cerr << Message << "\n";
    exit(1);
  }
  return new LLC(LLCPath, gcc, Args, GCCArgs);
}

//===---------------------------------------------------------------------===//
// JIT Implementation of AbstractIntepreter interface
//
namespace {
  class JIT : public AbstractInterpreter {
    std::string LLIPath;          // The path to the LLI executable
    std::vector<std::string> ToolArgs; // Args to pass to LLI
  public:
    JIT(const std::string &Path, const std::vector<std::string> *Args)
      : LLIPath(Path) {
      ToolArgs.clear ();
      if (Args) { ToolArgs = *Args; }
    }

    virtual int ExecuteProgram(const std::string &Bitcode,
                               const std::vector<std::string> &Args,
                               const std::string &InputFile,
                               const std::string &OutputFile,
                               const std::vector<std::string> &GCCArgs =
                                 std::vector<std::string>(),
                               const std::vector<std::string> &SharedLibs =
                                 std::vector<std::string>(), 
                               unsigned Timeout =0,
                               unsigned MemoryLimit =0);
  };
}

int JIT::ExecuteProgram(const std::string &Bitcode,
                        const std::vector<std::string> &Args,
                        const std::string &InputFile,
                        const std::string &OutputFile,
                        const std::vector<std::string> &GCCArgs,
                        const std::vector<std::string> &SharedLibs,
                        unsigned Timeout,
                        unsigned MemoryLimit) {
  // Construct a vector of parameters, incorporating those from the command-line
  std::vector<const char*> JITArgs;
  JITArgs.push_back(LLIPath.c_str());
  JITArgs.push_back("-force-interpreter=false");

  // Add any extra LLI args.
  for (unsigned i = 0, e = ToolArgs.size(); i != e; ++i)
    JITArgs.push_back(ToolArgs[i].c_str());

  for (unsigned i = 0, e = SharedLibs.size(); i != e; ++i) {
    JITArgs.push_back("-load");
    JITArgs.push_back(SharedLibs[i].c_str());
  }
  JITArgs.push_back(Bitcode.c_str());
  // Add optional parameters to the running program from Argv
  for (unsigned i=0, e = Args.size(); i != e; ++i)
    JITArgs.push_back(Args[i].c_str());
  JITArgs.push_back(0);

  std::cout << "<jit>" << std::flush;
  DEBUG(std::cerr << "\nAbout to run:\t";
        for (unsigned i=0, e = JITArgs.size()-1; i != e; ++i)
          std::cerr << " " << JITArgs[i];
        std::cerr << "\n";
        );
  DEBUG(std::cerr << "\nSending output to " << OutputFile << "\n");
  return RunProgramWithTimeout(sys::Path(LLIPath), &JITArgs[0],
      sys::Path(InputFile), sys::Path(OutputFile), sys::Path(OutputFile),
      Timeout, MemoryLimit);
}

/// createJIT - Try to find the LLI executable
///
AbstractInterpreter *AbstractInterpreter::createJIT(const std::string &ProgPath,
                   std::string &Message, const std::vector<std::string> *Args) {
  std::string LLIPath = FindExecutable("lli", ProgPath).toString();
  if (!LLIPath.empty()) {
    Message = "Found lli: " + LLIPath + "\n";
    return new JIT(LLIPath, Args);
  }

  Message = "Cannot find `lli' in executable directory or PATH!\n";
  return 0;
}

GCC::FileType CBE::OutputCode(const std::string &Bitcode,
                              sys::Path &OutputCFile) {
  sys::Path uniqueFile(Bitcode+".cbe.c");
  std::string ErrMsg;
  if (uniqueFile.makeUnique(true, &ErrMsg)) {
    std::cerr << "Error making unique filename: " << ErrMsg << "\n";
    exit(1);
  }
  OutputCFile = uniqueFile;
  std::vector<const char *> LLCArgs;
  LLCArgs.push_back (LLCPath.c_str());

  // Add any extra LLC args.
  for (unsigned i = 0, e = ToolArgs.size(); i != e; ++i)
    LLCArgs.push_back(ToolArgs[i].c_str());

  LLCArgs.push_back ("-o");
  LLCArgs.push_back (OutputCFile.c_str());   // Output to the C file
  LLCArgs.push_back ("-march=c");            // Output C language
  LLCArgs.push_back ("-f");                  // Overwrite as necessary...
  LLCArgs.push_back (Bitcode.c_str());      // This is the input bitcode
  LLCArgs.push_back (0);

  std::cout << "<cbe>" << std::flush;
  DEBUG(std::cerr << "\nAbout to run:\t";
        for (unsigned i=0, e = LLCArgs.size()-1; i != e; ++i)
          std::cerr << " " << LLCArgs[i];
        std::cerr << "\n";
        );
  if (RunProgramWithTimeout(LLCPath, &LLCArgs[0], sys::Path(), sys::Path(),
                            sys::Path()))
    ProcessFailure(LLCPath, &LLCArgs[0]);
  return GCC::CFile;
}

void CBE::compileProgram(const std::string &Bitcode) {
  sys::Path OutputCFile;
  OutputCode(Bitcode, OutputCFile);
  OutputCFile.eraseFromDisk();
}

int CBE::ExecuteProgram(const std::string &Bitcode,
                        const std::vector<std::string> &Args,
                        const std::string &InputFile,
                        const std::string &OutputFile,
                        const std::vector<std::string> &ArgsForGCC,
                        const std::vector<std::string> &SharedLibs,
                        unsigned Timeout,
                        unsigned MemoryLimit) {
  sys::Path OutputCFile;
  OutputCode(Bitcode, OutputCFile);

  FileRemover CFileRemove(OutputCFile);

  std::vector<std::string> GCCArgs(ArgsForGCC);
  GCCArgs.insert(GCCArgs.end(), SharedLibs.begin(), SharedLibs.end());

  return gcc->ExecuteProgram(OutputCFile.toString(), Args, GCC::CFile,
                             InputFile, OutputFile, GCCArgs,
                             Timeout, MemoryLimit);
}

/// createCBE - Try to find the 'llc' executable
///
CBE *AbstractInterpreter::createCBE(const std::string &ProgramPath,
                                    std::string &Message,
                                    const std::vector<std::string> *Args,
                                    const std::vector<std::string> *GCCArgs) {
  sys::Path LLCPath = FindExecutable("llc", ProgramPath);
  if (LLCPath.isEmpty()) {
    Message =
      "Cannot find `llc' in executable directory or PATH!\n";
    return 0;
  }

  Message = "Found llc: " + LLCPath.toString() + "\n";
  GCC *gcc = GCC::create(ProgramPath, Message, GCCArgs);
  if (!gcc) {
    std::cerr << Message << "\n";
    exit(1);
  }
  return new CBE(LLCPath, gcc, Args);
}

//===---------------------------------------------------------------------===//
// GCC abstraction
//

#ifdef __APPLE__
static bool
IsARMArchitecture(std::vector<std::string> Args)
{
  for (std::vector<std::string>::const_iterator
         I = Args.begin(), E = Args.end(); I != E; ++I) {
    if (!strcasecmp(I->c_str(), "-arch")) {
      ++I;
      if ((I != E) && !strncasecmp(I->c_str(), "arm", strlen("arm"))) {
        return true;
      }
    }
  }

  return false;
}
#endif

int GCC::ExecuteProgram(const std::string &ProgramFile,
                        const std::vector<std::string> &Args,
                        FileType fileType,
                        const std::string &InputFile,
                        const std::string &OutputFile,
                        const std::vector<std::string> &ArgsForGCC,
                        unsigned Timeout,
                        unsigned MemoryLimit) {
  std::vector<const char*> GCCArgs;

  GCCArgs.push_back(GCCPath.c_str());

  for (std::vector<std::string>::const_iterator
         I = gccArgs.begin(), E = gccArgs.end(); I != E; ++I)
    GCCArgs.push_back(I->c_str());

  // Specify -x explicitly in case the extension is wonky
  GCCArgs.push_back("-x");
  if (fileType == CFile) {
    GCCArgs.push_back("c");
    GCCArgs.push_back("-fno-strict-aliasing");
  } else {
    GCCArgs.push_back("assembler");
#ifdef __APPLE__
    // For ARM architectures we don't want this flag. bugpoint isn't
    // explicitly told what architecture it is working on, so we get
    // it from gcc flags
    if (!IsARMArchitecture(ArgsForGCC))
      GCCArgs.push_back("-force_cpusubtype_ALL");
#endif
  }
  GCCArgs.push_back(ProgramFile.c_str());  // Specify the input filename...
  GCCArgs.push_back("-x");
  GCCArgs.push_back("none");
  GCCArgs.push_back("-o");
  sys::Path OutputBinary (ProgramFile+".gcc.exe");
  std::string ErrMsg;
  if (OutputBinary.makeUnique(true, &ErrMsg)) {
    std::cerr << "Error making unique filename: " << ErrMsg << "\n";
    exit(1);
  }
  GCCArgs.push_back(OutputBinary.c_str()); // Output to the right file...

  // Add any arguments intended for GCC. We locate them here because this is
  // most likely -L and -l options that need to come before other libraries but
  // after the source. Other options won't be sensitive to placement on the
  // command line, so this should be safe.
  for (unsigned i = 0, e = ArgsForGCC.size(); i != e; ++i)
    GCCArgs.push_back(ArgsForGCC[i].c_str());

  GCCArgs.push_back("-lm");                // Hard-code the math library...
  GCCArgs.push_back("-O2");                // Optimize the program a bit...
#if defined (HAVE_LINK_R)
  GCCArgs.push_back("-Wl,-R.");            // Search this dir for .so files
#endif
#ifdef __sparc__
  GCCArgs.push_back("-mcpu=v9");
#endif
  GCCArgs.push_back(0);                    // NULL terminator

  std::cout << "<gcc>" << std::flush;
  DEBUG(std::cerr << "\nAbout to run:\t";
        for (unsigned i=0, e = GCCArgs.size()-1; i != e; ++i)
          std::cerr << " " << GCCArgs[i];
        std::cerr << "\n";
        );
  if (RunProgramWithTimeout(GCCPath, &GCCArgs[0], sys::Path(), sys::Path(),
        sys::Path())) {
    ProcessFailure(GCCPath, &GCCArgs[0]);
    exit(1);
  }

  std::vector<const char*> ProgramArgs;

  if (RemoteClientPath.isEmpty())
    ProgramArgs.push_back(OutputBinary.c_str());
  else {
    ProgramArgs.push_back(RemoteClientPath.c_str());
    ProgramArgs.push_back(RemoteHost.c_str());
    ProgramArgs.push_back("-l");
    ProgramArgs.push_back(RemoteUser.c_str());
    if (!RemotePort.empty()) {
      ProgramArgs.push_back("-p");
      ProgramArgs.push_back(RemotePort.c_str());
    }
    if (!RemoteExtra.empty()) {
      ProgramArgs.push_back(RemoteExtra.c_str());
    }

    char* env_pwd = getenv("PWD");
    std::string Exec = "cd ";
    Exec += env_pwd;
    Exec += "; ./";
    Exec += OutputBinary.c_str();
    ProgramArgs.push_back(Exec.c_str());
  }

  // Add optional parameters to the running program from Argv
  for (unsigned i=0, e = Args.size(); i != e; ++i)
    ProgramArgs.push_back(Args[i].c_str());
  ProgramArgs.push_back(0);                // NULL terminator

  // Now that we have a binary, run it!
  std::cout << "<program>" << std::flush;
  DEBUG(std::cerr << "\nAbout to run:\t";
        for (unsigned i=0, e = ProgramArgs.size()-1; i != e; ++i)
          std::cerr << " " << ProgramArgs[i];
        std::cerr << "\n";
        );

  FileRemover OutputBinaryRemover(OutputBinary);

  if (RemoteClientPath.isEmpty())
    return RunProgramWithTimeout(OutputBinary, &ProgramArgs[0],
        sys::Path(InputFile), sys::Path(OutputFile), sys::Path(OutputFile),
        Timeout, MemoryLimit);
  else
    return RunProgramWithTimeout(sys::Path(RemoteClientPath), &ProgramArgs[0],
        sys::Path(InputFile), sys::Path(OutputFile), sys::Path(OutputFile),
        Timeout, MemoryLimit);
}

int GCC::MakeSharedObject(const std::string &InputFile, FileType fileType,
                          std::string &OutputFile,
                          const std::vector<std::string> &ArgsForGCC) {
  sys::Path uniqueFilename(InputFile+LTDL_SHLIB_EXT);
  std::string ErrMsg;
  if (uniqueFilename.makeUnique(true, &ErrMsg)) {
    std::cerr << "Error making unique filename: " << ErrMsg << "\n";
    exit(1);
  }
  OutputFile = uniqueFilename.toString();

  std::vector<const char*> GCCArgs;
  
  GCCArgs.push_back(GCCPath.c_str());

  for (std::vector<std::string>::const_iterator
         I = gccArgs.begin(), E = gccArgs.end(); I != E; ++I)
    GCCArgs.push_back(I->c_str());

  // Compile the C/asm file into a shared object
  GCCArgs.push_back("-x");
  GCCArgs.push_back(fileType == AsmFile ? "assembler" : "c");
  GCCArgs.push_back("-fno-strict-aliasing");
  GCCArgs.push_back(InputFile.c_str());   // Specify the input filename.
  GCCArgs.push_back("-x");
  GCCArgs.push_back("none");
#if defined(sparc) || defined(__sparc__) || defined(__sparcv9)
  GCCArgs.push_back("-G");       // Compile a shared library, `-G' for Sparc
#elif defined(__APPLE__)
  // link all source files into a single module in data segment, rather than
  // generating blocks. dynamic_lookup requires that you set 
  // MACOSX_DEPLOYMENT_TARGET=10.3 in your env.  FIXME: it would be better for
  // bugpoint to just pass that in the environment of GCC.
  GCCArgs.push_back("-single_module");
  GCCArgs.push_back("-dynamiclib");   // `-dynamiclib' for MacOS X/PowerPC
  GCCArgs.push_back("-undefined");
  GCCArgs.push_back("dynamic_lookup");
#else
  GCCArgs.push_back("-shared");  // `-shared' for Linux/X86, maybe others
#endif

#if defined(__ia64__) || defined(__alpha__) || defined(__amd64__)
  GCCArgs.push_back("-fPIC");   // Requires shared objs to contain PIC
#endif
#ifdef __sparc__
  GCCArgs.push_back("-mcpu=v9");
#endif
  GCCArgs.push_back("-o");
  GCCArgs.push_back(OutputFile.c_str()); // Output to the right filename.
  GCCArgs.push_back("-O2");              // Optimize the program a bit.

  
  
  // Add any arguments intended for GCC. We locate them here because this is
  // most likely -L and -l options that need to come before other libraries but
  // after the source. Other options won't be sensitive to placement on the
  // command line, so this should be safe.
  for (unsigned i = 0, e = ArgsForGCC.size(); i != e; ++i)
    GCCArgs.push_back(ArgsForGCC[i].c_str());
  GCCArgs.push_back(0);                    // NULL terminator

  

  std::cout << "<gcc>" << std::flush;
  DEBUG(std::cerr << "\nAbout to run:\t";
        for (unsigned i=0, e = GCCArgs.size()-1; i != e; ++i)
          std::cerr << " " << GCCArgs[i];
        std::cerr << "\n";
        );
  if (RunProgramWithTimeout(GCCPath, &GCCArgs[0], sys::Path(), sys::Path(),
                            sys::Path())) {
    ProcessFailure(GCCPath, &GCCArgs[0]);
    return 1;
  }
  return 0;
}

/// create - Try to find the `gcc' executable
///
GCC *GCC::create(const std::string &ProgramPath, std::string &Message,
                 const std::vector<std::string> *Args) {
  sys::Path GCCPath = FindExecutable("gcc", ProgramPath);
  if (GCCPath.isEmpty()) {
    Message = "Cannot find `gcc' in executable directory or PATH!\n";
    return 0;
  }

  sys::Path RemoteClientPath;
  if (!RemoteClient.empty())
    RemoteClientPath = FindExecutable(RemoteClient.c_str(), ProgramPath);

  Message = "Found gcc: " + GCCPath.toString() + "\n";
  return new GCC(GCCPath, RemoteClientPath, Args);
}
