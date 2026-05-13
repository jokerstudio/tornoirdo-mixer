import { MerkleTree } from "fixed-merkle-tree";
import { hexToBigint } from "./bigint";
import { poseidon2Hash } from "@zkpassport/poseidon2";

// Constants from MerkleTreeWithHistory.sol
const MERKLE_TREE_HEIGHT = 20;

// This matches the zeros function in MerkleTreeWithHistory.sol
export const ZERO_VALUES = hexToBigint(
  "0x2fe54c60d3acabf3343a35b6eba15db4821b340f76e741e2249685ed4899af6c",
);

// Creates a fixed height merkle-tree with Poseidon hash function (just like MerkleTreeWithHistory.sol)
export async function poseidonMerkleTree(leaves: bigint[] = []) {
  const poseidonHash = (left: bigint, right: bigint): bigint =>
    poseidon2Hash([left, right]);

  return new MerkleTree(
    MERKLE_TREE_HEIGHT,
    leaves as any,
    {
      hashFunction: poseidonHash,
      zeroElement: ZERO_VALUES,
    } as any,
  ) as any;
}
