// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "forge-std/Test.sol";

contract ProofTestHelper is Test {
   function _genCommitment() internal returns (bytes32 commitment, bytes32 nullifier, bytes32 secret) {
        string[] memory inputs = new string[](2);
        inputs[0] = "bun";
        inputs[1] = "ffi/generateCommitment.js";
        bytes memory result = vm.ffi(inputs);
        (commitment, nullifier, secret) = abi.decode(result, (bytes32, bytes32, bytes32));
    }

    function _genProof(
        bytes32 nullifier,
        bytes32 secret,
        bytes32[] memory leaves
    ) internal returns (bytes memory proof, bytes32[] memory publicInputs) {
        string[] memory inputs = new string[](4 + leaves.length);
        inputs[0] = "bun";
        inputs[1] = "ffi/generateProof.js";
        inputs[2] = vm.toString(secret);
        inputs[3] = vm.toString(nullifier);
        // leaves
        for (uint256 i = 0; i < leaves.length; i++) {
            inputs[4 + i] = vm.toString(leaves[i]);
        }
       
        bytes memory result =  vm.ffi(inputs);
        (proof, publicInputs) = abi.decode(result, (bytes, bytes32[]));
    }
}