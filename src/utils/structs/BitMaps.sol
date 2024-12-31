// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

library BitMaps {
    struct BitMap {
        mapping(uint256 bucketIndex => uint256 slots) buckets;
    }

    uint256 private constant MAX_BUCKET_SIZE = 256;

    function get(BitMap storage bitmap, uint256 index) internal view returns (bool) {
        (uint256 bucketIndex, uint256 bucketSlotIndex) = _getSlotPosition(index);
        uint256 slots = bitmap.buckets[bucketIndex];
        return _getSlotValue(slots, bucketSlotIndex);
    }

    function setTo(BitMap storage bitmap, uint256 index, bool value) internal {
        (uint256 bucketIndex, uint256 bucketSlotIndex) = _getSlotPosition(index);
        uint256 slots = bitmap.buckets[bucketIndex];

        bool slotValue = _getSlotValue(slots, bucketSlotIndex);
        if (slotValue == value) return;

        uint256 mask = 1 << bucketSlotIndex;
        if (value) {
            bitmap.buckets[bucketIndex] = slots | mask;
        } else {
            bitmap.buckets[bucketIndex] = slots & (~mask);
        }
    }

    function set(BitMap storage bitmap, uint256 index) internal {
        setTo(bitmap, index, true);
    }

    function unset(BitMap storage bitmap, uint256 index) internal {
        setTo(bitmap, index, false);
    }

    function _getSlotPosition(uint256 index) private pure returns (uint256 bucketIndex, uint256 bucketSlotIndex) {
        bucketIndex = index >> 8; // index / MAX_BUCKET_SIZE 
        bucketSlotIndex = index & 0xff; // index - bucketIndex * MAX_BUCKET_SIZE 
    }

    function _getSlotValue(uint256 slots, uint256 slotIndex) private pure returns (bool) {
        uint256 slotVal = (slots >> slotIndex) & 1;
        return slotVal == 1;
    }
}
