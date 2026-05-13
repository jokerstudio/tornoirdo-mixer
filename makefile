# Variables
CIRCUIT_DIR = circuits/withdraw

# Generate vk and verifier contract
gen_verifier:
	cd $(CIRCUIT_DIR) && \
	nargo compile && \
	bb write_vk --scheme ultra_honk --verifier_target evm -b ./target/withdraw.json -o ./target && \
	bb write_solidity_verifier --scheme ultra_honk --verifier_target evm -o ../../contract/HonkVerifier.sol