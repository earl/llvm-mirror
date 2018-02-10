import re
import sys

from . import common

if sys.version_info[0] > 2:
  class string:
    expandtabs = str.expandtabs
else:
  import string

# RegEx: this is where the magic happens.

##### Assembly parser

ASM_FUNCTION_X86_RE = re.compile(
    r'^_?(?P<func>[^:]+):[ \t]*#+[ \t]*@(?P=func)\n[^:]*?'
    r'(?P<body>^##?[ \t]+[^:]+:.*?)\s*'
    r'^\s*(?:[^:\n]+?:\s*\n\s*\.size|\.cfi_endproc|\.globl|\.comm|\.(?:sub)?section|#+ -- End function)',
    flags=(re.M | re.S))

ASM_FUNCTION_ARM_RE = re.compile(
        r'^(?P<func>[0-9a-zA-Z_]+):\n' # f: (name of function)
        r'\s+\.fnstart\n' # .fnstart
        r'(?P<body>.*?)\n' # (body of the function)
        r'.Lfunc_end[0-9]+:', # .Lfunc_end0: or # -- End function
        flags=(re.M | re.S))

ASM_FUNCTION_AARCH64_RE = re.compile(
     r'^_?(?P<func>[^:]+):[ \t]*\/\/[ \t]*@(?P=func)\n'
     r'[ \t]+.cfi_startproc\n'
     r'(?P<body>.*?)\n'
     # This list is incomplete
     r'.Lfunc_end[0-9]+:\n',
     flags=(re.M | re.S))

ASM_FUNCTION_MIPS_RE = re.compile(
    r'^_?(?P<func>[^:]+):[ \t]*#+[ \t]*@(?P=func)\n[^:]*?' # f: (name of func)
    r'(?:^[ \t]+\.(frame|f?mask|set).*?\n)+'  # Mips+LLVM standard asm prologue
    r'(?P<body>.*?)\n'                        # (body of the function)
    r'(?:^[ \t]+\.(set|end).*?\n)+'           # Mips+LLVM standard asm epilogue
    r'(\$|\.L)func_end[0-9]+:\n',             # $func_end0: (mips32 - O32) or
                                              # .Lfunc_end0: (mips64 - NewABI)
    flags=(re.M | re.S))

ASM_FUNCTION_PPC_RE = re.compile(
    r'^_?(?P<func>[^:]+):[ \t]*#+[ \t]*@(?P=func)\n'
    r'\.Lfunc_begin[0-9]+:\n'
    r'(?:[ \t]+.cfi_startproc\n)?'
    r'(?:\.Lfunc_[gl]ep[0-9]+:\n(?:[ \t]+.*?\n)*)*'
    r'(?P<body>.*?)\n'
    # This list is incomplete
    r'(?:^[ \t]*(?:\.long[ \t]+[^\n]+|\.quad[ \t]+[^\n]+)\n)*'
    r'.Lfunc_end[0-9]+:\n',
    flags=(re.M | re.S))

ASM_FUNCTION_RISCV_RE = re.compile(
    r'^_?(?P<func>[^:]+):[ \t]*#+[ \t]*@(?P=func)\n[^:]*?'
    r'(?P<body>^##?[ \t]+[^:]+:.*?)\s*'
    r'.Lfunc_end[0-9]+:\n',
    flags=(re.M | re.S))

ASM_FUNCTION_SYSTEMZ_RE = re.compile(
    r'^_?(?P<func>[^:]+):[ \t]*#+[ \t]*@(?P=func)\n'
    r'[ \t]+.cfi_startproc\n'
    r'(?P<body>.*?)\n'
    r'.Lfunc_end[0-9]+:\n',
    flags=(re.M | re.S))


SCRUB_LOOP_COMMENT_RE = re.compile(
    r'# =>This Inner Loop Header:.*|# in Loop:.*', flags=re.M)

SCRUB_X86_SHUFFLES_RE = (
    re.compile(
        r'^(\s*\w+) [^#\n]+#+ ((?:[xyz]mm\d+|mem)( \{%k\d+\}( \{z\})?)? = .*)$',
        flags=re.M))
SCRUB_X86_SP_RE = re.compile(r'\d+\(%(esp|rsp)\)')
SCRUB_X86_RIP_RE = re.compile(r'[.\w]+\(%rip\)')
SCRUB_X86_LCP_RE = re.compile(r'\.LCPI[0-9]+_[0-9]+')
SCRUB_X86_RET_RE = re.compile(r'ret[l|q]')

def scrub_asm_x86(asm, args):
  # Scrub runs of whitespace out of the assembly, but leave the leading
  # whitespace in place.
  asm = common.SCRUB_WHITESPACE_RE.sub(r' ', asm)
  # Expand the tabs used for indentation.
  asm = string.expandtabs(asm, 2)
  # Detect shuffle asm comments and hide the operands in favor of the comments.
  asm = SCRUB_X86_SHUFFLES_RE.sub(r'\1 {{.*#+}} \2', asm)
  # Generically match the stack offset of a memory operand.
  asm = SCRUB_X86_SP_RE.sub(r'{{[0-9]+}}(%\1)', asm)
  # Generically match a RIP-relative memory operand.
  asm = SCRUB_X86_RIP_RE.sub(r'{{.*}}(%rip)', asm)
  # Generically match a LCP symbol.
  asm = SCRUB_X86_LCP_RE.sub(r'{{\.LCPI.*}}', asm)
  if args.x86_extra_scrub:
    # Avoid generating different checks for 32- and 64-bit because of 'retl' vs 'retq'.
    asm = SCRUB_X86_RET_RE.sub(r'ret{{[l|q]}}', asm)
  # Strip kill operands inserted into the asm.
  asm = common.SCRUB_KILL_COMMENT_RE.sub('', asm)
  # Strip trailing whitespace.
  asm = common.SCRUB_TRAILING_WHITESPACE_RE.sub(r'', asm)
  return asm

def scrub_asm_arm_eabi(asm, args):
  # Scrub runs of whitespace out of the assembly, but leave the leading
  # whitespace in place.
  asm = common.SCRUB_WHITESPACE_RE.sub(r' ', asm)
  # Expand the tabs used for indentation.
  asm = string.expandtabs(asm, 2)
  # Strip kill operands inserted into the asm.
  asm = common.SCRUB_KILL_COMMENT_RE.sub('', asm)
  # Strip trailing whitespace.
  asm = common.SCRUB_TRAILING_WHITESPACE_RE.sub(r'', asm)
  return asm

def scrub_asm_powerpc64(asm, args):
  # Scrub runs of whitespace out of the assembly, but leave the leading
  # whitespace in place.
  asm = common.SCRUB_WHITESPACE_RE.sub(r' ', asm)
  # Expand the tabs used for indentation.
  asm = string.expandtabs(asm, 2)
  # Stripe unimportant comments
  asm = SCRUB_LOOP_COMMENT_RE.sub(r'', asm)
  # Strip trailing whitespace.
  asm = common.SCRUB_TRAILING_WHITESPACE_RE.sub(r'', asm)
  return asm

def scrub_asm_mips(asm, args):
  # Scrub runs of whitespace out of the assembly, but leave the leading
  # whitespace in place.
  asm = common.SCRUB_WHITESPACE_RE.sub(r' ', asm)
  # Expand the tabs used for indentation.
  asm = string.expandtabs(asm, 2)
  # Strip trailing whitespace.
  asm = common.SCRUB_TRAILING_WHITESPACE_RE.sub(r'', asm)
  return asm

def scrub_asm_riscv(asm, args):
  # Scrub runs of whitespace out of the assembly, but leave the leading
  # whitespace in place.
  asm = common.SCRUB_WHITESPACE_RE.sub(r' ', asm)
  # Expand the tabs used for indentation.
  asm = string.expandtabs(asm, 2)
  # Strip trailing whitespace.
  asm = common.SCRUB_TRAILING_WHITESPACE_RE.sub(r'', asm)
  return asm

def scrub_asm_systemz(asm, args):
  # Scrub runs of whitespace out of the assembly, but leave the leading
  # whitespace in place.
  asm = common.SCRUB_WHITESPACE_RE.sub(r' ', asm)
  # Expand the tabs used for indentation.
  asm = string.expandtabs(asm, 2)
  # Strip trailing whitespace.
  asm = common.SCRUB_TRAILING_WHITESPACE_RE.sub(r'', asm)
  return asm


def build_function_body_dictionary_for_triple(args, raw_tool_output, triple, prefixes, func_dict):
  target_handlers = {
      'x86_64': (scrub_asm_x86, ASM_FUNCTION_X86_RE),
      'i686': (scrub_asm_x86, ASM_FUNCTION_X86_RE),
      'x86': (scrub_asm_x86, ASM_FUNCTION_X86_RE),
      'i386': (scrub_asm_x86, ASM_FUNCTION_X86_RE),
      'aarch64': (scrub_asm_arm_eabi, ASM_FUNCTION_AARCH64_RE),
      'arm-eabi': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'thumb-eabi': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'thumbv6': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'thumbv6-eabi': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'thumbv6t2': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'thumbv6t2-eabi': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'thumbv6m': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'thumbv6m-eabi': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'thumbv7': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'thumbv7-eabi': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'thumbv7m': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'thumbv7m-eabi': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'thumbv8-eabi': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'thumbv8m.base': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'thumbv8m.main': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'armv6': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'armv7': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'armv7-eabi': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'armeb-eabi': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'armv7eb-eabi': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'armv7eb': (scrub_asm_arm_eabi, ASM_FUNCTION_ARM_RE),
      'mips': (scrub_asm_mips, ASM_FUNCTION_MIPS_RE),
      'powerpc64': (scrub_asm_powerpc64, ASM_FUNCTION_PPC_RE),
      'powerpc64le': (scrub_asm_powerpc64, ASM_FUNCTION_PPC_RE),
      'riscv32': (scrub_asm_riscv, ASM_FUNCTION_RISCV_RE),
      'riscv64': (scrub_asm_riscv, ASM_FUNCTION_RISCV_RE),
      's390x': (scrub_asm_systemz, ASM_FUNCTION_SYSTEMZ_RE),
  }
  handlers = None
  for prefix, s in target_handlers.items():
    if triple.startswith(prefix):
      handlers = s
      break
  else:
    raise KeyError('Triple %r is not supported' % (triple))

  scrubber, function_re = handlers
  common.build_function_body_dictionary(
          function_re, scrubber, [args], raw_tool_output, prefixes,
          func_dict, args.verbose)

##### Generator of assembly CHECK lines

def add_asm_checks(output_lines, comment_marker, run_list, func_dict, func_name):
  printed_prefixes = []
  for p in run_list:
    checkprefixes = p[0]
    for checkprefix in checkprefixes:
      if checkprefix in printed_prefixes:
        break
      # TODO func_dict[checkprefix] may be None, '' or not exist.
      # Fix the call sites.
      if func_name not in func_dict[checkprefix] or not func_dict[checkprefix][func_name]:
        continue
      # Add some space between different check prefixes.
      if len(printed_prefixes) != 0:
        output_lines.append(comment_marker)
      printed_prefixes.append(checkprefix)
      output_lines.append('%s %s-LABEL: %s:' % (comment_marker, checkprefix, func_name))
      func_body = func_dict[checkprefix][func_name].splitlines()
      output_lines.append('%s %s:       %s' % (comment_marker, checkprefix, func_body[0]))
      for func_line in func_body[1:]:
        output_lines.append('%s %s-NEXT:  %s' % (comment_marker, checkprefix, func_line))
      # Add space between different check prefixes and the first line of code.
      # output_lines.append(';')
      break
