# Variables
CIRCUIT_DIR = circuits/withdraw

# Generate vk and verifier contract
gen_verifier:
	cd $(CIRCUIT_DIR) && \
	nargo compile && \
	bb write_vk -b ./target/withdraw.json -o ./target/vk && \
	bb contract -o ../../contract/UltraVerifier.sol