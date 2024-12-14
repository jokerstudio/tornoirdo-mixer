// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../contract/ERC20Tornado.sol";
import "../contract/Tornado.sol";
import "../contract/utils/Poseidon.sol";
import "../contract/UltraVerifier.sol";
import "./mocks/ERC20Mock.sol";

contract ERC20TornadoTest is Test {
    uint256 public constant FIELD_SIZE = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    ERC20Tornado public mixer;
    UltraVerifier public verifier;
    ERC20Mock public token;
    address public recipient = makeAddr("anonymous");
    address public relayer = makeAddr("relayer");

    function setUp() public {
        // Deploy UltraPlonk verifier contract.
        verifier = new UltraVerifier();
        // Deploy Poseidon hasher contract.
        Poseidon hasher = new Poseidon();

        token = new ERC20Mock(recipient);

        /**
         * Deploy Tornado Cash mixer
         *
         * - verifier: UltraPlonk verifier
         * - hasher: Poseidon
         * - denomination: 1 WETH
         * - merkleTreeHeight: 20
         */
        mixer = new ERC20Tornado(IVerifier(address(verifier)), IHasher(address(hasher)), 1 ether, 20, IERC20(address(token)));
    }

    function test_single_deposit() public {
        bytes32[] memory leaves = new bytes32[](1);
        // Generate commitment
        (bytes32 commitment, bytes32 nullifier, bytes32 secret) = _genCommitment();

        token.approve(address(mixer), 1 ether);
        mixer.deposit(commitment);
        leaves[0] = commitment;
        
        (bytes memory proof, bytes32[] memory publicInputs) = 
            _genProof(nullifier, secret, leaves);

        bytes32 nullifierHash = publicInputs[0];
        bytes32 merkleRoot = publicInputs[1];
        mixer.withdraw(proof, merkleRoot, nullifierHash, recipient, relayer, 0, 0);

        assertEq(token.balanceOf(recipient), 1 ether);
    }

    function test_many_deposit() public {
        bytes32[] memory leaves = new bytes32[](100);

        // Generate commitment
        (bytes32 commitment, bytes32 nullifier, bytes32 secret) = _genCommitment();

        // 1. Make many deposits with random commitments -- this will let us test with a non-empty merkle tree
        for (uint256 i = 0; i < 50; i++) {
            bytes32 leaf = bytes32(uint256(keccak256(abi.encode(i))) % FIELD_SIZE);

            token.approve(address(mixer), 1 ether);
            mixer.deposit(leaf);
            leaves[i] = leaf;
        }

        // 2. Generate commitment and deposit.
        token.approve(address(mixer), 1 ether);
        mixer.deposit(commitment);
        leaves[50] = commitment;

        // 3. Make more deposits.
        for (uint256 i = 51; i < 100; i++) {
            bytes32 leaf = bytes32(uint256(keccak256(abi.encode(i))) % FIELD_SIZE);

            token.approve(address(mixer), 1 ether);
            mixer.deposit(leaf);
            leaves[i] = leaf;
        }

        (bytes memory proof, bytes32[] memory publicInputs) = 
            _genProof(nullifier, secret, leaves);

        bytes32 nullifierHash = publicInputs[0];
        bytes32 merkleRoot = publicInputs[1];
        mixer.withdraw(proof, merkleRoot, nullifierHash, recipient, relayer, 0, 0);

        assertEq(token.balanceOf(recipient), 1 ether);
    }

    function test_withdraw_fee() public {
        bytes32[] memory leaves = new bytes32[](1);
        // Generate commitment
        (bytes32 commitment, bytes32 nullifier, bytes32 secret) = _genCommitment();

        token.approve(address(mixer), 1 ether);
        mixer.deposit(commitment);
        leaves[0] = commitment;
        
        (bytes memory proof, bytes32[] memory publicInputs) = 
            _genProof(nullifier, secret, leaves);

        bytes32 nullifierHash = publicInputs[0];
        bytes32 merkleRoot = publicInputs[1];
        mixer.withdraw(proof, merkleRoot, nullifierHash, recipient, relayer, 0.1 ether, 0);

        assert(token.balanceOf(recipient) == 0.9 ether);
    }

    function test_revert_when_double_spending() public {
        bytes32[] memory leaves = new bytes32[](100);

        // Generate commitment
        (bytes32 commitment, bytes32 nullifier, bytes32 secret) = _genCommitment();

        // 1. Make many deposits with random commitments -- this will let us test with a non-empty merkle tree
        for (uint256 i = 0; i < 50; i++) {
            bytes32 leaf = bytes32(uint256(keccak256(abi.encode(i))) % FIELD_SIZE);

            token.approve(address(mixer), 1 ether);
            mixer.deposit(leaf);
            leaves[i] = leaf;
        }

        // 2. Generate commitment and deposit.
        token.approve(address(mixer), 1 ether);
        mixer.deposit(commitment);
        leaves[50] = commitment;

        // 3. Make more deposits.
        for (uint256 i = 51; i < 100; i++) {
            bytes32 leaf = bytes32(uint256(keccak256(abi.encode(i))) % FIELD_SIZE);

            token.approve(address(mixer), 1 ether);
            mixer.deposit(leaf);
            leaves[i] = leaf;
        }

        (bytes memory proof1, bytes32[] memory publicInputs1) = 
            _genProof(nullifier, secret, leaves);
        (bytes memory proof2, bytes32[] memory publicInputs2) = 
            _genProof(nullifier, secret, leaves);

        mixer.withdraw(proof1,  publicInputs1[1],  publicInputs1[0], recipient, relayer, 0, 0);

        vm.expectRevert(bytes("The note has been already spent"));
        mixer.withdraw(proof2,  publicInputs2[1],  publicInputs2[0], recipient, relayer, 0, 0);
    }

    function _genCommitment() internal returns (bytes32 commitment, bytes32 nullifier, bytes32 secret) {
        string[] memory inputs = new string[](2);
        inputs[0] = "node";
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
        inputs[0] = "node";
        inputs[1] = "ffi/generateProof.js";
        inputs[2] = _toHexString(secret);
        inputs[3] = _toHexString(nullifier);
        // leaves
           for (uint256 i = 0; i < leaves.length; i++) {
            inputs[4 + i] = vm.toString(leaves[i]);
        }
       
        bytes memory result =  vm.ffi(inputs);
        (proof, publicInputs) = abi.decode(result, (bytes, bytes32[]));
    }

    function _toHexString(bytes32 data) internal pure returns (string memory) {
        bytes memory hexChars = "0123456789abcdef";
        bytes memory result = new bytes(64); // Each byte will be represented by 2 hex characters

        for (uint i = 0; i < 32; i++) {
            uint8 byteValue = uint8(data[i]);
            result[i * 2] = hexChars[byteValue >> 4]; // Higher nibble
            result[i * 2 + 1] = hexChars[byteValue & 0x0f]; // Lower nibble
        }

        return string.concat("0x", string(result));
    }
}
