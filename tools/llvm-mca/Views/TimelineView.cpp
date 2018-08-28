//===--------------------- TimelineView.cpp ---------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \brief
///
/// This file implements the TimelineView interface.
///
//===----------------------------------------------------------------------===//

#include "Views/TimelineView.h"

using namespace llvm;

namespace mca {

TimelineView::TimelineView(const MCSubtargetInfo &sti, MCInstPrinter &Printer,
                           const SourceMgr &S, unsigned MaxIterations,
                           unsigned Cycles)
    : STI(sti), MCIP(Printer), AsmSequence(S), CurrentCycle(0),
      MaxCycle(Cycles == 0 ? 80 : Cycles), LastCycle(0), WaitTime(S.size()),
      UsedBuffer(S.size()) {
  unsigned NumInstructions = AsmSequence.size();
  if (!MaxIterations)
    MaxIterations = DEFAULT_ITERATIONS;
  NumInstructions *= std::min(MaxIterations, AsmSequence.getNumIterations());
  Timeline.resize(NumInstructions);

  WaitTimeEntry NullWTEntry = {0, 0, 0};
  std::fill(WaitTime.begin(), WaitTime.end(), NullWTEntry);
}

void TimelineView::onReservedBuffers(const InstRef &IR,
                                     ArrayRef<unsigned> Buffers) {
  if (IR.getSourceIndex() >= AsmSequence.size())
    return;

  const MCSchedModel &SM = STI.getSchedModel();
  std::pair<unsigned, unsigned> BufferInfo = {0, 0};
  for (const unsigned Buffer : Buffers) {
    const MCProcResourceDesc &MCDesc = *SM.getProcResource(Buffer);
    if (MCDesc.BufferSize <= 0)
      continue;
    unsigned OtherSize = static_cast<unsigned>(MCDesc.BufferSize);
    if (!BufferInfo.first || BufferInfo.second > OtherSize) {
      BufferInfo.first = Buffer;
      BufferInfo.second = OtherSize;
    }
  }

  UsedBuffer[IR.getSourceIndex()] = BufferInfo;
}

void TimelineView::onEvent(const HWInstructionEvent &Event) {
  const unsigned Index = Event.IR.getSourceIndex();
  if (Index >= Timeline.size())
    return;

  switch (Event.Type) {
  case HWInstructionEvent::Retired: {
    TimelineViewEntry &TVEntry = Timeline[Index];
    if (CurrentCycle < MaxCycle)
      TVEntry.CycleRetired = CurrentCycle;

    // Update the WaitTime entry which corresponds to this Index.
    WaitTimeEntry &WTEntry = WaitTime[Index % AsmSequence.size()];
    WTEntry.CyclesSpentInSchedulerQueue +=
        TVEntry.CycleIssued - TVEntry.CycleDispatched;
    assert(TVEntry.CycleDispatched <= TVEntry.CycleReady);
    WTEntry.CyclesSpentInSQWhileReady +=
        TVEntry.CycleIssued - TVEntry.CycleReady;
    WTEntry.CyclesSpentAfterWBAndBeforeRetire +=
        (CurrentCycle - 1) - TVEntry.CycleExecuted;
    break;
  }
  case HWInstructionEvent::Ready:
    Timeline[Index].CycleReady = CurrentCycle;
    break;
  case HWInstructionEvent::Issued:
    Timeline[Index].CycleIssued = CurrentCycle;
    break;
  case HWInstructionEvent::Executed:
    Timeline[Index].CycleExecuted = CurrentCycle;
    break;
  case HWInstructionEvent::Dispatched:
    Timeline[Index].CycleDispatched = CurrentCycle;
    break;
  default:
    return;
  }
  if (CurrentCycle < MaxCycle)
    LastCycle = std::max(LastCycle, CurrentCycle);
}

static raw_ostream::Colors chooseColor(unsigned CumulativeCycles,
                                       unsigned Executions,
                                       unsigned BufferSize) {
  if (CumulativeCycles && BufferSize == 0)
    return raw_ostream::MAGENTA;
  if (CumulativeCycles >= (BufferSize * Executions))
    return raw_ostream::RED;
  if ((CumulativeCycles * 2) >= (BufferSize * Executions))
    return raw_ostream::YELLOW;
  return raw_ostream::SAVEDCOLOR;
}

static void tryChangeColor(raw_ostream &OS, unsigned Cycles,
                           unsigned Executions, unsigned BufferSize) {
  if (!OS.has_colors())
    return;

  raw_ostream::Colors Color = chooseColor(Cycles, Executions, BufferSize);
  if (Color == raw_ostream::SAVEDCOLOR) {
    OS.resetColor();
    return;
  }
  OS.changeColor(Color, /* bold */ true, /* BG */ false);
}

void TimelineView::printWaitTimeEntry(formatted_raw_ostream &OS,
                                      const WaitTimeEntry &Entry,
                                      unsigned SourceIndex,
                                      unsigned Executions) const {
  OS << SourceIndex << '.';
  OS.PadToColumn(7);

  double AverageTime1, AverageTime2, AverageTime3;
  AverageTime1 = (double)Entry.CyclesSpentInSchedulerQueue / Executions;
  AverageTime2 = (double)Entry.CyclesSpentInSQWhileReady / Executions;
  AverageTime3 = (double)Entry.CyclesSpentAfterWBAndBeforeRetire / Executions;

  OS << Executions;
  OS.PadToColumn(13);
  unsigned BufferSize = UsedBuffer[SourceIndex].second;
  tryChangeColor(OS, Entry.CyclesSpentInSchedulerQueue, Executions, BufferSize);
  OS << format("%.1f", floor((AverageTime1 * 10) + 0.5) / 10);
  OS.PadToColumn(20);
  tryChangeColor(OS, Entry.CyclesSpentInSQWhileReady, Executions, BufferSize);
  OS << format("%.1f", floor((AverageTime2 * 10) + 0.5) / 10);
  OS.PadToColumn(27);
  tryChangeColor(OS, Entry.CyclesSpentAfterWBAndBeforeRetire, Executions,
                 STI.getSchedModel().MicroOpBufferSize);
  OS << format("%.1f", floor((AverageTime3 * 10) + 0.5) / 10);

  if (OS.has_colors())
    OS.resetColor();
  OS.PadToColumn(34);
}

void TimelineView::printAverageWaitTimes(raw_ostream &OS) const {
  std::string Header =
      "\n\nAverage Wait times (based on the timeline view):\n"
      "[0]: Executions\n"
      "[1]: Average time spent waiting in a scheduler's queue\n"
      "[2]: Average time spent waiting in a scheduler's queue while ready\n"
      "[3]: Average time elapsed from WB until retire stage\n\n"
      "      [0]    [1]    [2]    [3]\n";
  OS << Header;

  // Use a different string stream for printing instructions.
  std::string Instruction;
  raw_string_ostream InstrStream(Instruction);

  formatted_raw_ostream FOS(OS);
  unsigned Executions = Timeline.size() / AsmSequence.size();
  for (unsigned I = 0, E = WaitTime.size(); I < E; ++I) {
    printWaitTimeEntry(FOS, WaitTime[I], I, Executions);
    // Append the instruction info at the end of the line.
    const MCInst &Inst = AsmSequence.getMCInstFromIndex(I);

    MCIP.printInst(&Inst, InstrStream, "", STI);
    InstrStream.flush();

    // Consume any tabs or spaces at the beginning of the string.
    StringRef Str(Instruction);
    Str = Str.ltrim();
    FOS << "   " << Str << '\n';
    FOS.flush();
    Instruction = "";
  }
}

void TimelineView::printTimelineViewEntry(formatted_raw_ostream &OS,
                                          const TimelineViewEntry &Entry,
                                          unsigned Iteration,
                                          unsigned SourceIndex) const {
  if (Iteration == 0 && SourceIndex == 0)
    OS << '\n';
  OS << '[' << Iteration << ',' << SourceIndex << ']';
  OS.PadToColumn(10);
  for (unsigned I = 0, E = Entry.CycleDispatched; I < E; ++I)
    OS << ((I % 5 == 0) ? '.' : ' ');
  OS << TimelineView::DisplayChar::Dispatched;
  if (Entry.CycleDispatched != Entry.CycleExecuted) {
    // Zero latency instructions have the same value for CycleDispatched,
    // CycleIssued and CycleExecuted.
    for (unsigned I = Entry.CycleDispatched + 1, E = Entry.CycleIssued; I < E;
         ++I)
      OS << TimelineView::DisplayChar::Waiting;
    if (Entry.CycleIssued == Entry.CycleExecuted)
      OS << TimelineView::DisplayChar::DisplayChar::Executed;
    else {
      if (Entry.CycleDispatched != Entry.CycleIssued)
        OS << TimelineView::DisplayChar::Executing;
      for (unsigned I = Entry.CycleIssued + 1, E = Entry.CycleExecuted; I < E;
           ++I)
        OS << TimelineView::DisplayChar::Executing;
      OS << TimelineView::DisplayChar::Executed;
    }
  }

  for (unsigned I = Entry.CycleExecuted + 1, E = Entry.CycleRetired; I < E; ++I)
    OS << TimelineView::DisplayChar::RetireLag;
  OS << TimelineView::DisplayChar::Retired;

  // Skip other columns.
  for (unsigned I = Entry.CycleRetired + 1, E = LastCycle; I <= E; ++I)
    OS << ((I % 5 == 0 || I == LastCycle) ? '.' : ' ');
}

static void printTimelineHeader(formatted_raw_ostream &OS, unsigned Cycles) {
  OS << "\n\nTimeline view:\n";
  if (Cycles >= 10) {
    OS.PadToColumn(10);
    for (unsigned I = 0; I <= Cycles; ++I) {
      if (((I / 10) & 1) == 0)
        OS << ' ';
      else
        OS << I % 10;
    }
    OS << '\n';
  }

  OS << "Index";
  OS.PadToColumn(10);
  for (unsigned I = 0; I <= Cycles; ++I) {
    if (((I / 10) & 1) == 0)
      OS << I % 10;
    else
      OS << ' ';
  }
  OS << '\n';
}

void TimelineView::printTimeline(raw_ostream &OS) const {
  formatted_raw_ostream FOS(OS);
  printTimelineHeader(FOS, LastCycle);
  FOS.flush();

  // Use a different string stream for the instruction.
  std::string Instruction;
  raw_string_ostream InstrStream(Instruction);

  for (unsigned I = 0, E = Timeline.size(); I < E; ++I) {
    const TimelineViewEntry &Entry = Timeline[I];
    if (Entry.CycleRetired == 0)
      return;

    unsigned Iteration = I / AsmSequence.size();
    unsigned SourceIndex = I % AsmSequence.size();
    printTimelineViewEntry(FOS, Entry, Iteration, SourceIndex);
    // Append the instruction info at the end of the line.
    const MCInst &Inst = AsmSequence.getMCInstFromIndex(I);
    MCIP.printInst(&Inst, InstrStream, "", STI);
    InstrStream.flush();

    // Consume any tabs or spaces at the beginning of the string.
    StringRef Str(Instruction);
    Str = Str.ltrim();
    FOS << "   " << Str << '\n';
    FOS.flush();
    Instruction = "";
  }
}
} // namespace mca
