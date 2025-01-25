# Tornoirdo Mixer
This project re-builds Tornado Cash for educational purposes. This project focuses on replacing Circom with Noir as the language for writing circuits. It has been rebuilt from the ground up with a modern technology stack, including ZK-friendly hash function, while retaining the original Tornado Cash workflow as much as possible.

## Why Noir ?
While Circom has been widely used in many production-ready projects due to its performance, power, and flexibility, it comes with a steep learning curve. We need a cryptography brain to understand how circuits (or proof systems) work at a low-level, if not, you’re going to run into trouble.

Noir is a Rust-based domain specific language (DSL) for creating and verifying zero-knowledge proofs. It’s the easiest way to write zk applications in simply and familiar syntax while retaining all the power and flexibility.

## Disclaimer
Tornoirdo Mixer is an experimental project created for educational purposes only. This project is not intended for use in production environments, nor is it designed for real-world deployment.

By using this project, you acknowledge and agree that:
-	The authors and contributors of Tornoirdo Mixer are not responsible for any incidents, damages, or legal issues arising from the use, misuse, or modification of this project.
-	The code is provided “as-is,” without any warranties or guarantees of security, privacy, or functionality.
-	This project is strictly intended for research and learning purposes. Any use of this project for illegal or unethical activities is strictly prohibited.

## Getting started (Local machine)
### Noir installation
follow these simple steps to work on your own machine:

Install [noirup](https://noir-lang.org/docs/getting_started/installation/#installing-noirup) with

1. Install [noirup](https://noir-lang.org/docs/getting_started/installation/#installing-noirup):

   ```bash
   curl -L https://raw.githubusercontent.com/noir-lang/noirup/main/install | bash
   ```

2. Install Nargo:

   ```bash
   noirup -v 0.36.0 # compatible with bb 0.58.0
   ```

3. Install foundryup and follow the instructions on screen. You should then have all the foundry
   tools like `forge`, `cast`, `anvil` and `chisel`.

   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   ```

4. Install the correct version of the
   [Barretenberg](https://github.com/AztecProtocol/aztec-packages/tree/master/barretenberg/cpp/src/barretenberg/bb#version-compatibility-with-noir)
   proving backend for Noir (bb).

   ```bash
   curl -L https://raw.githubusercontent.com/AztecProtocol/aztec-packages/master/barretenberg/bbup/install | bash
   ```

   then

   ```bash
   bbup -v 0.58.0 # compatible with nargo 0.36.0
   ```

### Installation
1. Clone this repository
   ```bash
   git clone https://github.com/jokerstudio/tornoirdo-mixer.git
   ```

2. Install dependencies:

   ```bash
   forge install
   ```
   ```bash
   yarn
      ```

### Compiling Noir circuits

This command do these tasks for you:

1. Compile circuits
2. Generate verifier key
3. Generate verifier Solidity smart contract

   These three steps are written as bash commands in the [makefile](https://github.com/jokerstudio/tornoirdo-mixer/blob/main/makefile). Run the following to perform these steps:

   ```bash
   make
   ```

   This will create circuit artifacts that needed to run tests.

### Running tests

There are two test scripts `/test/ETHTornado.t.sol` and `/test/ERC20Tornado.t.sol` for Native mixer and ERC20 mixer respectively.

   Run the following command to run tests:

   ```bash
   forge test
   ```
   Please note that, these tests may take a minute for proving computation.


## Getting started (Docker)
### Installation

1. Install [docker](https://docs.docker.com/engine/install/)
2. Install [Visual Studio Code](https://code.visualstudio.com/download) and the [devcontainer extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
3. Checkout this repository:    
   ```bash
   git clone https://github.com/jokerstudio/tornoirdo-mixer.git
   ```
4. Open the folder with VS Code: 
   ```bash
   code ./tornoirdo-mixer
   ```
   Once VS Code started, it will offer you to "Reopen in Container".

### Compiling Noir circuits

This command do these tasks for you:

1. Compile circuits
2. Generate verifier key
3. Generate verifier Solidity smart contract

   These three steps are written as bash commands in the [makefile](https://github.com/jokerstudio/tornoirdo-mixer/blob/main/makefile). Run the following to perform these steps:

   ```bash
   make

### Running tests
   After building the images, now you are ready to run test within Visual Studio Code Terminal.
   ```bash
   forge test
   ```

