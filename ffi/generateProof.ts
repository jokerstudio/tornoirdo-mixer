import { Barretenberg, UltraHonkBackend } from "@aztec/bb.js";
import { Noir } from "@noir-lang/noir_js";
import { ethers, hexlify } from "ethers";
import { poseidonMerkleTree } from "./utils/poseidonMerkleTree";
import { hexToBigint, bigintToHex } from "./utils/bigint";
import { poseidon2Hash } from "@zkpassport/poseidon2";
import os from "node:os";
import { readFileSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

// Suppress console.log to avoid breaking vm.ffi
const originalLog = console.log;
console.log = () => {};

// Load circuit JSON
const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const circuitPath = join(
  __dirname,
  "..",
  "circuits",
  "withdraw",
  "target",
  "withdraw.json",
);
const circuit = JSON.parse(readFileSync(circuitPath, "utf-8"));

async function main() {
  const barretenbergAPI = await Barretenberg.new({
    threads: os.cpus().length,
  });
  const backend = new UltraHonkBackend(circuit.bytecode, barretenbergAPI);
  const noir = new Noir(circuit);

  const inputs = process.argv.slice(2, process.argv.length);
  const secret = inputs[0];
  const nullifier = inputs[1];
  const nullifierHash = bigintToHex(poseidon2Hash([hexToBigint(nullifier)]));
  const commitment = poseidon2Hash([
    hexToBigint(nullifier),
    hexToBigint(secret),
  ]);

  const leaves = inputs.slice(2, inputs.length).map((l) => hexToBigint(l));
  const tree = await poseidonMerkleTree(leaves);
  const index = tree.indexOf(commitment);
  const merkleProof = tree.proof(commitment);

  const input = {
    index: index,
    root: bigintToHex(merkleProof.pathRoot),
    proof: merkleProof.pathElements.map((x: any) => bigintToHex(x)),
    secret: secret,
    nullifier: nullifier,
    nullifierHash: nullifierHash,
  };

  const { witness } = await noir.execute(input);
  const proofData = await backend.generateProof(witness, {
    verifierTarget: "evm",
  });

  const res = ethers.AbiCoder.defaultAbiCoder().encode(
    ["bytes", "bytes32[]"],
    [hexlify(proofData.proof), proofData.publicInputs],
  );

  process.stdout.write(res);
  process.exit(0);
}

main().catch((err) => {
  originalLog(err);
  process.exit(1);
});
