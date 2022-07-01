from audioop import add
from ctypes import addressof
from solcx import compile_standard,install_solc
import json
from web3 import Web3
import os
from dotenv import load_dotenv
load_dotenv()

with open("./SimpleStorage.sol","r") as file:
    simple_storage_file=file.read()
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

with open("compiled_code2.json","w") as file:
    json.dump(compiled_sol,file)

bytecode=compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"]["bytecode"]["object"]

abi=compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]

w3=Web3(Web3.HTTPProvider("https://rinkeby.infura.io/v3/49c0bcdd523d4f48a5796c0b312edf04"))
chain_id=4
my_address="0xd498081D47675AF0453e2204ED0Aed3FD136642f"


private_key=os.getenv("PRIVATE_KEY")

SimpleStorage=w3.eth.contract(abi=abi,bytecode=bytecode)

nonce=w3.eth.getTransactionCount(my_address)

# 1. Build a transaction 
# 2. Sign a transaction
# 3. Send a signed transaction


transaction=SimpleStorage.constructor().buildTransaction({"gasPrice": w3.eth.gas_price,"chainId":chain_id,"from":my_address,"nonce":nonce})

# if following along with the video we need to add the "gasPrice" parameter which is not included

signed_txn=w3.eth.account.sign_transaction(transaction,private_key=private_key)

txn_hash=w3.eth.send_raw_transaction(signed_txn.rawTransaction)
txn_recipt=w3.eth.wait_for_transaction_receipt(txn_hash)

# While working with a contract we will always need:
# 1. Contract Address
# 2. Contract ABI

simple_storage=w3.eth.contract(address=txn_recipt.contractAddress,abi=abi)

# Initial Value of favourite number
print(simple_storage.functions.retrieve().call())

store_transaction=simple_storage.functions.store(15).buildTransaction({
    "gasPrice": w3.eth.gas_price,"chainId":chain_id,"from":my_address,"nonce":nonce+1
})

signed_store_txn=w3.eth.account.sign_transaction(store_transaction,private_key=private_key)

txn_hash_simpleStorage=w3.eth.send_raw_transaction(signed_store_txn.rawTransaction)

txn_recipt_simpleStorage=w3.eth.wait_for_transaction_receipt(txn_hash_simpleStorage)

print(simple_storage.functions.retrieve().call())