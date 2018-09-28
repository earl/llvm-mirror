#!/usr/bin/env python2.7

"""A test case update script.

This script is a utility to update LLVM 'llvm-mca' based test cases with new
FileCheck patterns.
"""

import argparse
from collections import defaultdict
import glob
import os
import sys
import warnings

from UpdateTestChecks import common


COMMENT_CHAR = '#'
ADVERT_PREFIX = '{} NOTE: Assertions have been autogenerated by '.format(
    COMMENT_CHAR)
ADVERT = '{}utils/{}'.format(ADVERT_PREFIX, os.path.basename(__file__))


class Error(Exception):
  """ Generic Error that can be raised without printing a traceback.
  """
  pass


def _warn(msg):
  """ Log a user warning to stderr.
  """
  warnings.warn(msg, Warning, stacklevel=2)


def _configure_warnings(args):
  warnings.resetwarnings()
  if args.w:
    warnings.simplefilter('ignore')
  if args.Werror:
    warnings.simplefilter('error')


def _showwarning(message, category, filename, lineno, file=None, line=None):
  """ Version of warnings.showwarning that won't attempt to print out the
      line at the location of the warning if the line text is not explicitly
      specified.
  """
  if file is None:
    file = sys.stderr
  if line is None:
    line = ''
  file.write(warnings.formatwarning(message, category, filename, lineno, line))


def _parse_args():
  parser = argparse.ArgumentParser(description=__doc__)
  parser.add_argument('-v', '--verbose',
                      action='store_true',
                      help='show verbose output')
  parser.add_argument('-w',
                      action='store_true',
                      help='suppress warnings')
  parser.add_argument('-Werror',
                      action='store_true',
                      help='promote warnings to errors')
  parser.add_argument('--llvm-mca-binary',
                      metavar='<path>',
                      default='llvm-mca',
                      help='the binary to use to generate the test case '
                           '(default: llvm-mca)')
  parser.add_argument('tests',
                      metavar='<test-path>',
                      nargs='+')
  args = parser.parse_args()

  _configure_warnings(args)

  if not args.llvm_mca_binary:
    raise Error('--llvm-mca-binary value cannot be empty string')

  if os.path.basename(args.llvm_mca_binary) != 'llvm-mca':
    _warn('unexpected binary name: {}'.format(args.llvm_mca_binary))

  return args


def _find_run_lines(input_lines, args):
  raw_lines = [m.group(1)
               for m in [common.RUN_LINE_RE.match(l) for l in input_lines]
               if m]
  run_lines = [raw_lines[0]] if len(raw_lines) > 0 else []
  for l in raw_lines[1:]:
    if run_lines[-1].endswith(r'\\'):
      run_lines[-1] = run_lines[-1].rstrip('\\') + ' ' + l
    else:
      run_lines.append(l)

  if args.verbose:
    sys.stderr.write('Found {} RUN line{}:\n'.format(
        len(run_lines), '' if len(run_lines) == 1 else 's'))
    for line in run_lines:
      sys.stderr.write('  RUN: {}\n'.format(line))

  return run_lines


def _get_run_infos(run_lines, args):
  run_infos = []
  for run_line in run_lines:
    try:
      (tool_cmd, filecheck_cmd) = tuple([cmd.strip()
                                        for cmd in run_line.split('|', 1)])
    except ValueError:
      _warn('could not split tool and filecheck commands: {}'.format(run_line))
      continue

    tool_basename = os.path.basename(args.llvm_mca_binary)

    if not tool_cmd.startswith(tool_basename + ' '):
      _warn('skipping non-{} RUN line: {}'.format(tool_basename, run_line))
      continue

    if not filecheck_cmd.startswith('FileCheck '):
      _warn('skipping non-FileCheck RUN line: {}'.format(run_line))
      continue

    tool_cmd_args = tool_cmd[len(tool_basename):].strip()
    tool_cmd_args = tool_cmd_args.replace('< %s', '').replace('%s', '').strip()

    check_prefixes = [item
                      for m in common.CHECK_PREFIX_RE.finditer(filecheck_cmd)
                      for item in m.group(1).split(',')]
    if not check_prefixes:
      check_prefixes = ['CHECK']

    run_infos.append((check_prefixes, tool_cmd_args))

  return run_infos


def _break_down_block(block_info, common_prefix):
  """ Given a block_info, see if we can analyze it further to let us break it
      down by prefix per-line rather than per-block.
  """
  texts = block_info.keys()
  prefixes = list(block_info.values())
  # Split the lines from each of the incoming block_texts and zip them so that
  # each element contains the corresponding lines from each text.  E.g.
  #
  # block_text_1: A   # line 1
  #               B   # line 2
  #
  # block_text_2: A   # line 1
  #               C   # line 2
  #
  # would become:
  #
  # [(A, A),   # line 1
  #  (B, C)]   # line 2
  #
  line_tuples = list(zip(*list((text.splitlines() for text in texts))))

  # To simplify output, we'll only proceed if the very first line of the block
  # texts is common to each of them.
  if len(set(line_tuples[0])) != 1:
    return []

  result = []
  lresult = defaultdict(list)
  for i, line in enumerate(line_tuples):
    if len(set(line)) == 1:
      # We're about to output a line with the common prefix.  This is a sync
      # point so flush any batched-up lines one prefix at a time to the output
      # first.
      for prefix in sorted(lresult):
        result.extend(lresult[prefix])
      lresult = defaultdict(list)

      # The line is common to each block so output with the common prefix.
      result.append((common_prefix, line[0]))
    else:
      # The line is not common to each block, or we don't have a common prefix.
      # If there are no prefixes available, warn and bail out.
      if not prefixes[0]:
        _warn('multiple lines not disambiguated by prefixes:\n{}\n'
              'Some blocks may be skipped entirely as a result.'.format(
                  '\n'.join('  - {}'.format(l) for l in line)))
        return []

      # Iterate through the line from each of the blocks and add the line with
      # the corresponding prefix to the current batch of results so that we can
      # later output them per-prefix.
      for i, l in enumerate(line):
        for prefix in prefixes[i]:
          lresult[prefix].append((prefix, l))

  # Flush any remaining batched-up lines one prefix at a time to the output.
  for prefix in sorted(lresult):
    result.extend(lresult[prefix])
  return result


def _get_useful_prefix_info(run_infos):
  """ Given the run_infos, calculate any prefixes that are common to every one,
      and the length of the longest prefix string.
  """
  try:
    all_sets = [set(s) for s in list(zip(*run_infos))[0]]
    common_to_all = set.intersection(*all_sets)
    longest_prefix_len = max(len(p) for p in set.union(*all_sets))
  except IndexError:
    common_to_all = []
    longest_prefix_len = 0
  else:
    if len(common_to_all) > 1:
      _warn('Multiple prefixes common to all RUN lines: {}'.format(
          common_to_all))
    if common_to_all:
      common_to_all = sorted(common_to_all)[0]
  return common_to_all, longest_prefix_len


def _align_matching_blocks(all_blocks, farthest_indexes):
  """ Some sub-sequences of blocks may be common to multiple lists of blocks,
      but at different indexes in each one.

      For example, in the following case, A,B,E,F, and H are common to both
      sets, but only A and B would be identified as such due to the indexes
      matching:

      index | 0 1 2 3 4 5 6
      ------+--------------
      setA  | A B C D E F H
      setB  | A B E F G H

      This function attempts to align the indexes of matching blocks by
      inserting empty blocks into the block list. With this approach, A, B, E,
      F, and H would now be able to be identified as matching blocks:

      index | 0 1 2 3 4 5 6 7
      ------+----------------
      setA  | A B C D E F   H
      setB  | A B     E F G H
  """

  # "Farthest block analysis": essentially, iterate over all blocks and find
  # the highest index into a block list for the first instance of each block.
  # This is relatively expensive, but we're dealing with small numbers of
  # blocks so it doesn't make a perceivable difference to user time.
  for blocks in all_blocks.values():
    for block in blocks:
      if not block:
        continue

      index = blocks.index(block)

      if index > farthest_indexes[block]:
        farthest_indexes[block] = index

  # Use the results of the above analysis to identify any blocks that can be
  # shunted along to match the farthest index value.
  for blocks in all_blocks.values():
    for index, block in enumerate(blocks):
      if not block:
        continue

      changed = False
      while(index < farthest_indexes[block]):
        blocks.insert(index, '')
        index += 1
        changed = True

      if changed:
        # Bail out.  We'll need to re-do the farthest block analysis now that
        # we've inserted some blocks.
        return True

  return False


def _get_block_infos(run_infos, test_path, args, common_prefix):  # noqa
  """ For each run line, run the tool with the specified args and collect the
      output. We use the concept of 'blocks' for uniquing, where a block is
      a series of lines of text with no more than one newline character between
      each one.  For example:

      This
      is
      one
      block

      This is
      another block

      This is yet another block

      We then build up a 'block_infos' structure containing a dict where the
      text of each block is the key and a list of the sets of prefixes that may
      generate that particular block.  This then goes through a series of
      transformations to minimise the amount of CHECK lines that need to be
      written by taking advantage of common prefixes.
  """

  def _block_key(tool_args, prefixes):
    """ Get a hashable key based on the current tool_args and prefixes.
    """
    return ' '.join([tool_args] + prefixes)

  all_blocks = {}
  max_block_len = 0

  # A cache of the furthest-back position in any block list of the first
  # instance of each block, indexed by the block itself.
  farthest_indexes = defaultdict(int)

  # Run the tool for each run line to generate all of the blocks.
  for prefixes, tool_args in run_infos:
    key = _block_key(tool_args, prefixes)
    raw_tool_output = common.invoke_tool(args.llvm_mca_binary,
                                         tool_args,
                                         test_path)

    # Replace any lines consisting of purely whitespace with empty lines.
    raw_tool_output = '\n'.join(line if line.strip() else ''
                                for line in raw_tool_output.splitlines())

    # Split blocks, stripping all trailing whitespace, but keeping preceding
    # whitespace except for newlines so that columns will line up visually.
    all_blocks[key] = [b.lstrip('\n').rstrip()
                       for b in raw_tool_output.split('\n\n')]
    max_block_len = max(max_block_len, len(all_blocks[key]))

    # Attempt to align matching blocks until no more changes can be made.
    made_changes = True
    while made_changes:
      made_changes = _align_matching_blocks(all_blocks, farthest_indexes)

  # If necessary, pad the lists of blocks with empty blocks so that they are
  # all the same length.
  for key in all_blocks:
    len_to_pad = max_block_len - len(all_blocks[key])
    all_blocks[key] += [''] * len_to_pad

  # Create the block_infos structure where it is a nested dict in the form of:
  # block number -> block text -> list of prefix sets
  block_infos = defaultdict(lambda: defaultdict(list))
  for prefixes, tool_args in run_infos:
    key = _block_key(tool_args, prefixes)
    for block_num, block_text in enumerate(all_blocks[key]):
      block_infos[block_num][block_text].append(set(prefixes))

  # Now go through the block_infos structure and attempt to smartly prune the
  # number of prefixes per block to the minimal set possible to output.
  for block_num in range(len(block_infos)):
    # When there are multiple block texts for a block num, remove any
    # prefixes that are common to more than one of them.
    # E.g. [ [{ALL,FOO}] , [{ALL,BAR}] ] -> [ [{FOO}] , [{BAR}] ]
    all_sets = [s for s in block_infos[block_num].values()]
    pruned_sets = []

    for i, setlist in enumerate(all_sets):
      other_set_values = set([elem for j, setlist2 in enumerate(all_sets)
                              for set_ in setlist2 for elem in set_
                              if i != j])
      pruned_sets.append([s - other_set_values for s in setlist])

    for i, block_text in enumerate(block_infos[block_num]):

      # When a block text matches multiple sets of prefixes, try removing any
      # prefixes that aren't common to all of them.
      # E.g. [ {ALL,FOO} , {ALL,BAR} ] -> [{ALL}]
      common_values = set.intersection(*pruned_sets[i])
      if common_values:
        pruned_sets[i] = [common_values]

      # Everything should be uniqued as much as possible by now.  Apply the
      # newly pruned sets to the block_infos structure.
      # If there are any blocks of text that still match multiple prefixes,
      # output a warning.
      current_set = set()
      for s in pruned_sets[i]:
        s = sorted(list(s))
        if s:
          current_set.add(s[0])
          if len(s) > 1:
            _warn('Multiple prefixes generating same output: {} '
                  '(discarding {})'.format(','.join(s), ','.join(s[1:])))

      block_infos[block_num][block_text] = sorted(list(current_set))

    # If we have multiple block_texts, try to break them down further to avoid
    # the case where we have very similar block_texts repeated after each
    # other.
    if common_prefix and len(block_infos[block_num]) > 1:
      # We'll only attempt this if each of the block_texts have the same number
      # of lines as each other.
      same_num_Lines = (len(set(len(k.splitlines())
                                for k in block_infos[block_num].keys())) == 1)
      if same_num_Lines:
        breakdown = _break_down_block(block_infos[block_num], common_prefix)
        if breakdown:
          block_infos[block_num] = breakdown

  return block_infos


def _write_block(output, block, not_prefix_set, common_prefix, prefix_pad):
  """ Write an individual block, with correct padding on the prefixes.
  """
  end_prefix = ':     '
  previous_prefix = None
  num_lines_of_prefix = 0

  for prefix, line in block:
    if prefix in not_prefix_set:
      _warn('not writing for prefix {0} due to presence of "{0}-NOT:" '
            'in input file.'.format(prefix))
      continue

    # If the previous line isn't already blank and we're writing more than one
    # line for the current prefix output a blank line first, unless either the
    # current of previous prefix is common to all.
    num_lines_of_prefix += 1
    if prefix != previous_prefix:
      if output and output[-1]:
        if num_lines_of_prefix > 1 or any(p == common_prefix
                                          for p in (prefix, previous_prefix)):
          output.append('')
      num_lines_of_prefix = 0
      previous_prefix = prefix

    output.append(
        '{} {}{}{} {}'.format(COMMENT_CHAR,
                              prefix,
                              end_prefix,
                              ' ' * (prefix_pad - len(prefix)),
                              line).rstrip())
    end_prefix = '-NEXT:'

  output.append('')


def _write_output(test_path, input_lines, prefix_list, block_infos,  # noqa
                  args, common_prefix, prefix_pad):
  prefix_set = set([prefix for prefixes, _ in prefix_list
                    for prefix in prefixes])
  not_prefix_set = set()

  output_lines = []
  for input_line in input_lines:
    if input_line.startswith(ADVERT_PREFIX):
      continue

    if input_line.startswith(COMMENT_CHAR):
      m = common.CHECK_RE.match(input_line)
      try:
        prefix = m.group(1)
      except AttributeError:
        prefix = None

      if '{}-NOT:'.format(prefix) in input_line:
        not_prefix_set.add(prefix)

      if prefix not in prefix_set or prefix in not_prefix_set:
        output_lines.append(input_line)
        continue

    if common.should_add_line_to_output(input_line, prefix_set):
      # This input line of the function body will go as-is into the output.
      # Except make leading whitespace uniform: 2 spaces.
      input_line = common.SCRUB_LEADING_WHITESPACE_RE.sub(r'  ', input_line)

      # Skip empty lines if the previous output line is also empty.
      if input_line or output_lines[-1]:
        output_lines.append(input_line)
    else:
      continue

  # Add a blank line before the new checks if required.
  if len(output_lines) > 0 and output_lines[-1]:
    output_lines.append('')

  output_check_lines = []
  for block_num in range(len(block_infos)):
    for block_text in sorted(block_infos[block_num]):
      if not block_text:
        continue

      if type(block_infos[block_num]) is list:
        # The block is of the type output from _break_down_block().
        _write_block(output_check_lines,
                     block_infos[block_num],
                     not_prefix_set,
                     common_prefix,
                     prefix_pad)
        break
      elif block_infos[block_num][block_text]:
        # _break_down_block() was unable to do do anything so output the block
        # as-is.
        lines = block_text.split('\n')
        for prefix in block_infos[block_num][block_text]:
          _write_block(output_check_lines,
                       [(prefix, line) for line in lines],
                       not_prefix_set,
                       common_prefix,
                       prefix_pad)

  if output_check_lines:
    output_lines.insert(0, ADVERT)
    output_lines.extend(output_check_lines)

  # The file should not end with two newlines. It creates unnecessary churn.
  while len(output_lines) > 0 and output_lines[-1] == '':
    output_lines.pop()

  if input_lines == output_lines:
    sys.stderr.write('            [unchanged]\n')
    return
  sys.stderr.write('      [{} lines total]\n'.format(len(output_lines)))

  if args.verbose:
    sys.stderr.write(
        'Writing {} lines to {}...\n\n'.format(len(output_lines), test_path))

  with open(test_path, 'wb') as f:
    f.writelines(['{}\n'.format(l).encode() for l in output_lines])

def main():
  args = _parse_args()
  test_paths = [test for pattern in args.tests for test in glob.glob(pattern)]
  for test_path in test_paths:
    sys.stderr.write('Test: {}\n'.format(test_path))

    # Call this per test. By default each warning will only be written once
    # per source location. Reset the warning filter so that now each warning
    # will be written once per source location per test.
    _configure_warnings(args)

    if args.verbose:
      sys.stderr.write(
          'Scanning for RUN lines in test file: {}\n'.format(test_path))

    if not os.path.isfile(test_path):
      raise Error('could not find test file: {}'.format(test_path))

    with open(test_path) as f:
      input_lines = [l.rstrip() for l in f]

    run_lines = _find_run_lines(input_lines, args)
    run_infos = _get_run_infos(run_lines, args)
    common_prefix, prefix_pad = _get_useful_prefix_info(run_infos)
    block_infos = _get_block_infos(run_infos, test_path, args, common_prefix)
    _write_output(test_path,
                  input_lines,
                  run_infos,
                  block_infos,
                  args,
                  common_prefix,
                  prefix_pad)

  return 0


if __name__ == '__main__':
  try:
    warnings.showwarning = _showwarning
    sys.exit(main())
  except Error as e:
    sys.stdout.write('error: {}\n'.format(e))
    sys.exit(1)
