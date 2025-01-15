// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

library Heap {
  error HeapEmpty();

  struct Uint256Heap {
    uint256[] nodes;
  }

  function peek(Uint256Heap storage heap) internal view returns (uint256) {
    return heap.nodes[0];
  }

  function pop(Uint256Heap storage heap) internal returns (uint256 root) {
    uint256 size = length(heap);
    require(size > 0, HeapEmpty());

    root = peek(heap);
    uint256 lastValue = heap.nodes[size - 1];

    heap.nodes[0] = lastValue;
    heap.nodes.pop();
    _maxHeapify(heap, size - 1, 0, lastValue);
  }

  function insert(Uint256Heap storage heap, uint256 value) internal {
    heap.nodes.push(value);
    uint256 index = length(heap) - 1;
    uint256 parentIndex;
    while (index > 0) {
      parentIndex = _getParentIndex(index);
      uint256 parentValue = heap.nodes[parentIndex];
      if (value <= parentValue) break;

      heap.nodes[index] = parentValue;
      heap.nodes[parentIndex] = value;
      index = parentIndex;
    }
  }

  function replace(Uint256Heap storage heap, uint256 value) internal returns (uint256 root) {
    uint256 size = length(heap);
    require(size > 0, HeapEmpty());

    root = heap.nodes[0];
    heap.nodes[0] = value;
    _maxHeapify(heap, size, 0, value);
  }

  function length(Uint256Heap storage heap) internal view returns (uint256) {
    return heap.nodes.length;
  }

  function clear(Uint256Heap storage heap) internal {
    delete heap.nodes;
  }

  function _getParentIndex(uint256 childIndex) private pure returns (uint256) {
    return (childIndex - 1) / 2;
  }

  function _getLeftChildIndex(uint256 parentIndex) private pure returns (uint256) {
    return 2 * parentIndex + 1;
  }

  function _getRightChildIndex(uint256 parentIndex) private pure returns (uint256) {
    return 2 * parentIndex + 2;
  }

  function _maxHeapify(Uint256Heap storage heap, uint256 heapSize, uint256 index, uint256 value) private {
    uint256 leftChildIndex = _getLeftChildIndex(index);
    uint256 rightChildIndex = _getRightChildIndex(index);
    uint256 maxIndex = index;
    uint256 maxValue = value;

    if (leftChildIndex < heapSize ) {
      uint256 leftValue = heap.nodes[leftChildIndex];
      if (leftValue > maxValue) {
        maxValue = leftValue;
        maxIndex = leftChildIndex;
      }
    }

    if (rightChildIndex < heapSize ) {
      uint256 rightValue = heap.nodes[rightChildIndex];
      if (rightValue > maxValue) {
        maxValue = rightValue;
        maxIndex = rightChildIndex;
      }
    }

    if (maxIndex == index) return;
    
    heap.nodes[index] = maxValue;
    heap.nodes[maxIndex] = value;
    _maxHeapify(heap, heapSize, maxIndex, value);
  }
}