const { ethers } = require("ethers");
const { poseidon2Hash } = require("@zkpassport/poseidon2");
const { rbigint, bigintToHex } = require("./utils/bigint.js");


const FIELD_SIZE = BigInt(21888242871839275222246405745257275088548364400416034343698204186575808495617);

// 1. Generate random nullifier and secret within FIELD_SIZE
const nullifier = rbigint(31) % FIELD_SIZE;
const secret = rbigint(31) % FIELD_SIZE;

// 2. Get commitment
const commitment = poseidon2Hash([nullifier, secret]);

// 3. Return abi encoded nullifier, secret, commitment
const res = ethers.AbiCoder.defaultAbiCoder().encode(
  ["bytes32", "bytes32", "bytes32"],
  [
    bigintToHex(commitment), 
    bigintToHex(nullifier),
    bigintToHex(secret)]
);

process.stdout.write(res);
process.exit(0);
