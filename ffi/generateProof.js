const { UltraHonkBackend } = require('@aztec/bb.js');
const { Noir } = require('@noir-lang/noir_js');
const circuit = require('../circuits/withdraw/target/withdraw.json');
const { ethers, hexlify } = require('ethers');
const { poseidonMerkleTree } = require('./utils/poseidonMerkleTree.js');
const { hexToBigint, bigintToHex, leBufferToBigint } = require('./utils/bigint.js');
const { poseidon2Hash } = require("@zkpassport/poseidon2");
const os = require('os');

const backend = new UltraHonkBackend(circuit.bytecode, {threads: os.cpus().length});
const noir = new Noir(circuit);

const inputs = process.argv.slice(2, process.argv.length);
const secret = inputs[0];
const nullifier = inputs[1];
const nullifierHash = bigintToHex(poseidon2Hash([hexToBigint(nullifier)]));
const commitment = poseidon2Hash([hexToBigint(nullifier), hexToBigint(secret)]);

const leaves = inputs.slice(2, inputs.length).map(l => hexToBigint(l));
const tree = await poseidonMerkleTree(leaves);
const index = tree.indexOf(commitment);
const merkleProof = tree.proof(commitment);

const input = {
  index: index,
  root: bigintToHex(merkleProof.pathRoot),
  proof: merkleProof.pathElements.map(x => bigintToHex(x)),
  secret: secret,
  nullifier: nullifier,
  nullifierHash: nullifierHash,
};

const { witness } = await noir.execute(input);
const proofData = await backend.generateProof(witness, {keccak:  true});
const res = ethers.AbiCoder.defaultAbiCoder().encode(
  ['bytes', 'bytes32[]'],
  [hexlify(proofData.proof), proofData.publicInputs],
);

// const ret = await backend.verifyProof(proofData, {keccak:  true});
// console.log(ret);

process.stdout.write(res);
process.exit(0);