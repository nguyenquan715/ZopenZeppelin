// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

library DoubleEndedQueue {
    error DequeFull();
    error DequeEmpty();
    error DequeOutOfBounds();

    struct Bytes32Deque {
        uint128 _front;
        uint128 _back;
        mapping(uint128 index => bytes32 value) _values;
    }

    function pushBack(Bytes32Deque storage deque, bytes32 value) internal {
        unchecked {
            uint128 backIndex = deque._back;
            if (backIndex + 1 == deque._front) revert DequeFull();
            deque._values[backIndex] = value;
            deque._back = backIndex + 1;
        }
    }

    function pushFront(Bytes32Deque storage deque, bytes32 value) internal {
        unchecked {
            uint128 frontIndex = deque._front - 1;
            if (frontIndex == deque._back) revert DequeFull();
            deque._values[frontIndex] = value;
            deque._front = frontIndex;
        }
    }

    function popBack(
        Bytes32Deque storage deque
    ) internal returns (bytes32 value) {
        if (empty(deque)) revert DequeEmpty();
        unchecked {
            uint128 backIndex = deque._back - 1;
            value = deque._values[backIndex];

            delete deque._values[backIndex];
            deque._back = backIndex;
        }
    }

    function popFront(
        Bytes32Deque storage deque
    ) internal returns (bytes32 value) {
        if (empty(deque)) revert DequeEmpty();
        unchecked {
            uint128 frontIndex = deque._front;
            value = deque._values[frontIndex];

            delete deque._values[frontIndex];
            deque._front = frontIndex + 1;
        }
    }

    function front(
        Bytes32Deque storage deque
    ) internal view returns (bytes32 value) {
        if (empty(deque)) revert DequeEmpty();
        return deque._values[deque._front];
    }

    function back(
        Bytes32Deque storage deque
    ) internal view returns (bytes32 value) {
        if (empty(deque)) revert DequeEmpty();
        unchecked {
            return deque._values[deque._back - 1];
        }
    }

    function at(
        Bytes32Deque storage deque,
        uint256 index
    ) internal view returns (bytes32 value) {
        if (index >= length(deque)) revert DequeOutOfBounds();
        unchecked {
            uint128 actualIndex = deque._front + uint128(index);
            value = deque._values[actualIndex];
        }
    }

    function clear(Bytes32Deque storage deque) internal {
        deque._back = 0;
        deque._front = 0;
    }

    function length(
        Bytes32Deque storage deque
    ) internal view returns (uint256 len) {
        unchecked {
            return uint256(deque._back - deque._front);
        }
    }

    function empty(Bytes32Deque storage deque) internal view returns (bool) {
        return deque._back == deque._front;
    }
}
