//===- Minidump.cpp - Minidump object file implementation -----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/Object/Minidump.h"
#include "llvm/Object/Error.h"

using namespace llvm;
using namespace llvm::object;
using namespace llvm::minidump;

Optional<ArrayRef<uint8_t>>
MinidumpFile::getRawStream(minidump::StreamType Type) const {
  auto It = StreamMap.find(Type);
  if (It != StreamMap.end())
    return getRawStream(Streams[It->second]);
  return None;
}

Expected<ArrayRef<uint8_t>>
MinidumpFile::getDataSlice(ArrayRef<uint8_t> Data, size_t Offset, size_t Size) {
  // Check for overflow.
  if (Offset + Size < Offset || Offset + Size < Size ||
      Offset + Size > Data.size())
    return createEOFError();
  return Data.slice(Offset, Size);
}

Expected<std::unique_ptr<MinidumpFile>>
MinidumpFile::create(MemoryBufferRef Source) {
  ArrayRef<uint8_t> Data = arrayRefFromStringRef(Source.getBuffer());
  auto ExpectedHeader = getDataSliceAs<minidump::Header>(Data, 0, 1);
  if (!ExpectedHeader)
    return ExpectedHeader.takeError();

  const minidump::Header &Hdr = (*ExpectedHeader)[0];
  if (Hdr.Signature != Header::MagicSignature)
    return createError("Invalid signature");
  if ((Hdr.Version & 0xffff) != Header::MagicVersion)
    return createError("Invalid version");

  auto ExpectedStreams = getDataSliceAs<Directory>(Data, Hdr.StreamDirectoryRVA,
                                                   Hdr.NumberOfStreams);
  if (!ExpectedStreams)
    return ExpectedStreams.takeError();

  DenseMap<StreamType, std::size_t> StreamMap;
  for (const auto &Stream : llvm::enumerate(*ExpectedStreams)) {
    StreamType Type = Stream.value().Type;
    const LocationDescriptor &Loc = Stream.value().Location;

    auto ExpectedStream = getDataSlice(Data, Loc.RVA, Loc.DataSize);
    if (!ExpectedStream)
      return ExpectedStream.takeError();

    if (Type == StreamType::Unused && Loc.DataSize == 0) {
      // Ignore dummy streams. This is technically ill-formed, but a number of
      // existing minidumps seem to contain such streams.
      continue;
    }

    if (Type == DenseMapInfo<StreamType>::getEmptyKey() ||
        Type == DenseMapInfo<StreamType>::getTombstoneKey())
      return createError("Cannot handle one of the minidump streams");

    // Update the directory map, checking for duplicate stream types.
    if (!StreamMap.try_emplace(Type, Stream.index()).second)
      return createError("Duplicate stream type");
  }

  return std::unique_ptr<MinidumpFile>(
      new MinidumpFile(Source, Hdr, *ExpectedStreams, std::move(StreamMap)));
}
