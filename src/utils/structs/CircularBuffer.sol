// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

library CircularBuffer {
  error BufferInvalidSize();
  error BufferOutOfBounds();

  struct Bytes32CircularBuffer {
    mapping(uint256 index => bytes32 value) values;
    uint256 size;
    uint256 count;
  }

  function clear(Bytes32CircularBuffer storage buffer) internal {
    buffer.count = 0;
  }

  function setup(Bytes32CircularBuffer storage buffer, uint256 size) internal {
    if (size == 0) revert BufferInvalidSize();
    clear(buffer);
    buffer.size = size;
  }

  function push(Bytes32CircularBuffer storage buffer, bytes32 value) internal {
    uint256 size = buffer.size;
    buffer.values[buffer.count % size] = value;
    if (buffer.count < size) {
      buffer.count += 1;
    }
  }

  function count(Bytes32CircularBuffer storage buffer) internal view returns (uint256) {
    return buffer.count;
  }

  function length(Bytes32CircularBuffer storage buffer) internal view returns (uint256) {
    return buffer.size;
  }

  function last(Bytes32CircularBuffer storage buffer, uint256 i) internal view returns (bytes32) {
    uint256 actualIndex = buffer.size - i - 1;
    if (actualIndex >= count(buffer)) revert BufferOutOfBounds();

    return buffer.values[actualIndex];
  }

  function includes(Bytes32CircularBuffer storage buffer, bytes32 value) internal view returns (bool) {
    uint256 counted = count(buffer);
    for (uint256 i = 0; i < counted; i += 1) {
      if (buffer.values[i] == value) return true;
    }
    return false;
  }
}