from solcx import compile_standard, install_solc
from web3 import Web3
import json
import os
from dotenv import load_dotenv

load_dotenv()


with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()

install_solc("0.8.0")

compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
            }
        },
    },
    solc_version="0.8.0",
)


with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)


bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]


# get abi
abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]

# Connecting to web3
w3 = Web3(
    Web3.HTTPProvider("https://rinkeby.infura.io/v3/69568ed3b48c477db13e90d4fca7f32a")
)
chain_id = 4
my_address = "0xd498081D47675AF0453e2204ED0Aed3FD136642f`"
# private_key = os.getenv("PRIVATE_KEY")

# Creating a contract in python
SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)

# Build ---> Sign ---> Send

nonce = w3.eth.getTransactionCount(my_address)
print(nonce)

# Creating a transaction object
transaction = SimpleStorage.constructor().buildTransaction(
    {
        "gasPrice": w3.eth.gas_price,
        "chainId": chain_id,
        "from": my_address,
        "nonce": nonce,
    }
)

signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)

# sending the signed transaction to the blockchain

txn_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)

tx_recipt = w3.eth.wait_for_transaction_receipt(txn_hash)

simple_storage = w3.eth.contract(address=tx_recipt.contractAddress, abi=abi)

print(simple_storage.functions.retrieve().call())
store_transaction = simple_storage.functions.store(15).buildTransaction(
    {
        "gasPrice": w3.eth.gas_price,
        "chainId": chain_id,
        "from": my_address,
        "nonce": nonce + 1,
    }
)
signed_store_txn = w3.eth.account.sign_transaction(
    store_transaction, private_key=private_key
)

send_store_txn = w3.eth.send_raw_transaction(signed_store_txn.rawTransaction)
store_receipt = w3.eth.wait_for_transaction_receipt(send_store_txn)

print(simple_storage.functions.retrieve().call())
