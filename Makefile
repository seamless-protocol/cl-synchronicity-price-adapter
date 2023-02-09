
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

deploy-wstETH-arbitrum :;  forge script scripts/DeployWstETH.s.sol:DeployWstETHArbitrum --rpc-url arbitrum --broadcast --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv
deploy-wstETH-optimism :;  forge script scripts/DeployWstETH.s.sol:DeployWstETHOptimism --rpc-url optimism --broadcast --ledger --mnemonic-indexes ${MNEMONIC_INDEX} --sender ${LEDGER_SENDER} --verify -vvvv
