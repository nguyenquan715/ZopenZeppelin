// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {EnumerableSet} from "./EnumerableSet.sol";

library EnumerableMap {
    using EnumerableSet for EnumerableSet.Bytes32Set;

    struct Bytes32ToBytes32Map {
        EnumerableSet.Bytes32Set keys;
        mapping(bytes32 key => bytes32 value) values;
    }

    function set(
        Bytes32ToBytes32Map storage map,
        bytes32 key,
        bytes32 value
    ) internal returns (bool) {
        map.values[key] = value;
        return map.keys.add(key);
    }

    function remove(
        Bytes32ToBytes32Map storage map,
        bytes32 key
    ) internal returns (bool) {
        delete map.values[key];
        return map.keys.remove(key);
    }

    function contains(
        Bytes32ToBytes32Map storage map,
        bytes32 key
    ) internal view returns (bool) {
        return map.keys.contains(key);
    }

    function length(
        Bytes32ToBytes32Map storage map
    ) internal view returns (uint256) {
        return map.keys.length();
    }

    function at(
        Bytes32ToBytes32Map storage map,
        uint256 index
    ) internal view returns (bytes32, bytes32) {
        bytes32 key = map.keys.at(index);
        return (key, map.values[key]);
    }

    function tryGet(
        Bytes32ToBytes32Map storage map,
        bytes32 key
    ) internal view returns (bool existed, bytes32 value) {
        existed = contains(map, key);
        value = map.values[key];
    }

    function get(
        Bytes32ToBytes32Map storage map,
        bytes32 key
    ) internal view returns (bytes32 value) {
        require(contains(map, key), "Key is not existed");
        return map.values[key];
    }

    function keys(
        Bytes32ToBytes32Map storage map
    ) internal view returns (bytes32[] memory) {
        return map.keys.values();
    }

    /* Address enumerable map */
    struct AddressToUint256Map {
        Bytes32ToBytes32Map inner;
    }

    function _addressToBytes32(address value) private pure returns (bytes32) {
        return bytes32(uint256(uint160(value)));
    }

    function _bytes32ToAddress(bytes32 value) private pure returns (address) {
        return address(uint160(uint256(value)));
    }

    function set(
        AddressToUint256Map storage map,
        address key,
        uint256 value
    ) internal returns (bool) {
        return set(map.inner, _addressToBytes32(key), bytes32(value));
    }

    function remove(
        AddressToUint256Map storage map,
        address key
    ) internal returns (bool) {
        return remove(map.inner, _addressToBytes32(key));
    }

    function contains(
        AddressToUint256Map storage map,
        address key
    ) internal view returns (bool) {
        return contains(map.inner, _addressToBytes32(key));
    }

    function length(
        AddressToUint256Map storage map
    ) internal view returns (uint256) {
        return length(map.inner);
    }

    function at(
        AddressToUint256Map storage map,
        uint256 index
    ) internal view returns (address, uint256) {
        (bytes32 key, bytes32 value) = at(map.inner, index);
        return (_bytes32ToAddress(key), uint256(value));
    }

    function tryGet(
        AddressToUint256Map storage map,
        address key
    ) internal view returns (bool, uint256) {
        (bool existed, bytes32 bytes32Val) = tryGet(
            map.inner,
            _addressToBytes32(key)
        );
        return (existed, uint256(bytes32Val));
    }

    function get(
        AddressToUint256Map storage map,
        address key
    ) internal view returns (uint256 value) {
        return uint256(get(map.inner, _addressToBytes32(key)));
    }

    function keys(
        AddressToUint256Map storage map
    ) internal view returns (address[] memory result) {
        bytes32[] memory store = keys(map.inner);
        assembly ("memory-safe") {
            result := store
        }
        return result;
    }
}
