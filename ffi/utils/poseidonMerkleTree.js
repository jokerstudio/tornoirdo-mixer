const { MerkleTree } = require("fixed-merkle-tree");

const { hexToBigint } = require("./bigint.js");
const { poseidon2 } = require('poseidon-lite');

// Constants from MerkleTreeWithHistory.sol
const MERKLE_TREE_HEIGHT = 20;

// This matches the zeros function in MerkleTreeWithHistory.sol
const ZERO_VALUES = hexToBigint("0x2fe54c60d3acabf3343a35b6eba15db4821b340f76e741e2249685ed4899af6c");

// Creates a fixed height merkle-tree with MiMC hash function (just like MerkleTreeWithHistory.sol)
async function poseidonMerkleTree(leaves = []) {
  const poseidonHash = (left, right) =>
    poseidon2([left, right]);

  return new MerkleTree(MERKLE_TREE_HEIGHT, leaves, {
    hashFunction: poseidonHash,
    zeroElement: ZERO_VALUES,
  });
}

module.exports = {
  poseidonMerkleTree,
  ZERO_VALUES,
};
