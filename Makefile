
# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

# deps
update:; forge update

# Build & test
build  :; forge build --sizes

test   :; forge test -vvv

deploy-cbETH :;  forge script scripts/DeploycbETHAdapter.s.sol:DeploycbETH --rpc-url mainnet --broadcast --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv
deploy-rETH :;  forge script scripts/DeployrETHAdapter.s.sol:DeploycbETH --rpc-url mainnet --broadcast --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv

deploy-stETH :;  forge script scripts/DeployWstETH.s.sol:DeployStETHMainnetV2 --rpc-url mainnet --broadcast --ledger --mnemonics a --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv
deploy-wstETH :;  forge script scripts/DeployWstETH.s.sol:DeployWstETHMainnetV3 --rpc-url mainnet --broadcast --ledger --mnemonics a --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv
deploy-wstETH-arbitrum :;  forge script scripts/DeployWstETH.s.sol:DeployWstETHArbitrum --rpc-url arbitrum --broadcast --ledger --mnemonics a --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv
deploy-wstETH-optimism :;  forge script scripts/DeployWstETH.s.sol:DeployWstETHOptimism --rpc-url optimism --broadcast --ledger --mnemonics a --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv
deploy-wstETH-polygon :;  forge script scripts/DeployWstETH.s.sol:DeployWstETHPolygon --rpc-url polygon --broadcast --ledger --mnemonics a --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --legacy --verify -vvvv

deploy-LDOETH :; forge script scripts/DeployLDOAdapter.s.sol:DeployLDOMainnet --rpc-url mainnet --broadcast --private-key ${PRIVATE_KEY} --verify --etherscan-api-key ${ETHERSCAN_API_KEY} -vvvv

deploy-maticx-polygon :; forge script scripts/DeployMaticAdapterPolygon.s.sol:DeployMaticXAdapterPolygon --rpc-url polygon --broadcast --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv
deploy-stmatic-polygon :; forge script scripts/DeployMaticAdapterPolygon.s.sol:DeployStMaticAdapterPolygon --rpc-url polygon --broadcast --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv

deploy-rETH-arbitrum :; forge script scripts/DeployrETHAdapterArbitrum.s.sol:DeployrETHArbitrum --rpc-url arbitrum --broadcast --private-key ${PRIVATE_KEY} --verify --etherscan-api-key ${ETHERSCAN_API_KEY_ARBITRUM} -vvvv
deploy-rETH-optimism :; forge script scripts/DeployrETHAdapterOptimism.s.sol:DeployrETHOptimism --rpc-url optimism --broadcast --private-key ${PRIVATE_KEY} --verify --etherscan-api-key ${ETHERSCAN_API_KEY_OPTIMISM} -vvvv
