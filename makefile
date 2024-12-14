# Variables
CIRCUIT_DIR = circuits

# Generate vk and verifier contract
gen_verifier:
	cd $(CIRCUIT_DIR) && \
	nargo compile && \
	bb write_vk -b ./target/tornado.json && \
	bb contract -o ./target/UltraVerifier.sol