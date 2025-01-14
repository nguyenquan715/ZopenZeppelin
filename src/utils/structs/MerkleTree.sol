// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

library MerkleTree {
    struct Bytes32MerkleTree {
        bytes32 root;
        uint256 nextIndex;
        bytes32[] zeros;
        bytes32[] lefts;
    }

    function setup(
        Bytes32MerkleTree storage self,
        uint8 treeDepth,
        bytes32 zero,
        function(bytes32, bytes32) view returns (bytes32) fnHash
    ) internal returns (bytes32 initialRoot) {
        self.zeros = new bytes32[](treeDepth);
        self.lefts = new bytes32[](treeDepth);

        initialRoot = zero;
        for (uint8 i; i < treeDepth; i += 1) {
            self.zeros[i] = initialRoot;
            initialRoot = fnHash(initialRoot, initialRoot);
        }
        self.root = initialRoot;
    }

    function push(
        Bytes32MerkleTree storage self,
        bytes32 leaf,
        function(bytes32, bytes32) view returns (bytes32) fnHash
    ) internal returns (uint256 index, bytes32 newRoot) {
        index = self.nextIndex;
        uint256 treeDepth = depth(self);
        require(index < 2 ** treeDepth, "Tree filled");

        uint256 currIndex = index;
        newRoot = leaf;
        for (uint256 i; i < treeDepth; i += 1) {
            bool isLeft = currIndex % 2 == 0;
            currIndex = currIndex / 2;
            if (isLeft) {
                self.lefts[i] = newRoot;
                newRoot = fnHash(newRoot, self.zeros[i]);
            } else {
                newRoot = fnHash(self.lefts[i], newRoot);
            }
        }
        

        self.nextIndex += 1;
        self.root = newRoot;
    }

    function depth(Bytes32MerkleTree storage self) internal view returns (uint256) {
        return self.zeros.length;
    }
}
