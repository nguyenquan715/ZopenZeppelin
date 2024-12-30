// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

library EnumerableSet {
    struct GenericSet {
        mapping(bytes32 key => uint256 index) indexes;
        bytes32[] values;
    }

    function _add(
        GenericSet storage set,
        bytes32 value
    ) private returns (bool) {
        if (_contains(set, value)) return false;

        uint256 index = set.values.length;
        set.values.push(value);
        set.indexes[value] = index + 1;
        return true;
    }

    function _remove(
        GenericSet storage set,
        bytes32 value
    ) private returns (bool) {
        if (!_contains(set, value)) return false;

        uint256 index = set.indexes[value] - 1;
        bytes32 lastElement = set.values[_length(set) - 1];

        // Delete in the array
        set.values[index] = lastElement;
        set.values.pop();

        // Update index
        set.indexes[lastElement] = index;
        delete set.indexes[value];

        return true;
    }

    function _contains(
        GenericSet storage set,
        bytes32 value
    ) private view returns (bool) {
        return set.indexes[value] != 0;
    }

    function _length(GenericSet storage set) private view returns (uint256) {
        return set.values.length;
    }

    function _at(
        GenericSet storage set,
        uint256 index
    ) private view returns (bytes32) {
        return set.values[index];
    }

    function _values(
        GenericSet storage set
    ) private view returns (bytes32[] memory) {
        return set.values;
    }

    /* Address set */
    struct AddressSet {
        GenericSet inner;
    }

    function _addressToBytes32(address value) private pure returns (bytes32) {
        return bytes32(uint256(uint160(value)));
    }

    function _bytes32ToAddress(bytes32 value) private pure returns (address) {
        return address(uint160(uint256(value)));
    }

    function add(
        AddressSet storage set,
        address value
    ) internal returns (bool) {
        return _add(set.inner, _addressToBytes32(value));
    }

    function remove(
        AddressSet storage set,
        address value
    ) internal returns (bool) {
        return _remove(set.inner, _addressToBytes32(value));
    }

    function contains(
        AddressSet storage set,
        address value
    ) internal view returns (bool) {
        return _contains(set.inner, _addressToBytes32(value));
    }

    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set.inner);
    }

    function at(
        AddressSet storage set,
        uint256 index
    ) internal view returns (address) {
        return _bytes32ToAddress(_at(set.inner, index));
    }

    function values(
        AddressSet storage set
    ) internal view returns (address[] memory result) {
        bytes32[] memory setValues = _values(set.inner);
        assembly ("memory-safe") {
            result := setValues
        }
        return result;
    }
}
