// SPDX-License-Identifier: MIR
pragma solidity ^0.8.0;

import "poseidon2/Poseidon2.sol";

contract Poseidon2Helper {
    using Field for *;
    using Poseidon2Lib for *;

    Poseidon2 private poseidon2;

    constructor() {
        poseidon2 = new Poseidon2();
    }

    function hash2(uint256 left, uint256 right) external view returns (uint) {
        return poseidon2.hash_2(left.toField(),right.toField()).toUint256();
    }
}