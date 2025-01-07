// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

library Checkpoints {
    error CheckpointUnorderedInsertion();

    struct Checkpoint224 {
        uint32 _key;
        uint224 _value;
    }

    struct Trace224 {
        Checkpoint224[] _checkpoints;
    }

    function push(
        Trace224 storage self,
        uint32 key,
        uint224 value
    ) internal returns (uint224, uint224) {
        (, uint32 latestKey, uint224 latestValue) = latestCheckpoint(self);
        if (key <= latestKey) revert CheckpointUnorderedInsertion();

        self._checkpoints.push(Checkpoint224(key, value));

        return (latestValue, value);
    }

    function lowerLookup(
        Trace224 storage self,
        uint32 key
    ) internal view returns (uint224) {
        uint256 len = length(self);
        for (uint256 i = 0; i < len; i += 1) {
            Checkpoint224 memory point = self._checkpoints[i];
            if (key <= point._key) return point._value;
        }
        return 0;
    }

    function upperLookup(
        Trace224 storage self,
        uint32 key
    ) internal view returns (uint224) {
        uint256 len = length(self);
        for (uint256 i = len; i > 0; i -= 1) {
            uint256 index = i - 1;
            Checkpoint224 memory point = self._checkpoints[index];
            if (key >= point._key) return point._value;
        }
        return 0;
    }

    function latest(Trace224 storage self) internal view returns (uint224) {
        (,, uint224 value) = latestCheckpoint(self);
        return value;
    }

    function latestCheckpoint(Trace224 storage self) internal view returns (bool, uint32, uint224) {
        uint256 len = length(self);
        if (len == 0) return (false, 0 , 0);
        Checkpoint224 memory point = self._checkpoints[len - 1];
        return (true, point._key, point._value);
    }

    function length(Trace224 storage self) internal view returns (uint256) {
        return self._checkpoints.length;
    }

    function at(Trace224 storage self, uint32 pos) internal view returns (Checkpoint224 memory) {
        return self._checkpoints[pos];
    }
}
