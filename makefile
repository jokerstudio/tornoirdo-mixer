# Variables
CIRCUIT_DIR = circuits/withdraw

# Generate vk and verifier contract
gen_verifier:
	cd $(CIRCUIT_DIR) && \
	nargo compile && \
	bb write_vk --scheme ultra_honk --oracle_hash keccak -b ./target/withdraw.json -o ./target && \
	bb write_solidity_verifier --scheme ultra_honk -o ../../contract/HonkVerifier.sol