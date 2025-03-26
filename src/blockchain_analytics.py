import requests
import time

RPC_ENDPOINT = "http://localhost:8545"

# Function to fetch block details
def fetch_block_details(block_number):
    payload = {
        "jsonrpc": "2.0",
        "method": "eth_getBlockByNumber",
        "params": [hex(block_number), True],
        "id": 1
    }
    response = requests.post(RPC_ENDPOINT, json=payload)
    return response.json()

# Function to calculate transaction throughput
def calculate_throughput(start_block, end_block):
    total_transactions = 0
    for block_number in range(start_block, end_block + 1):
        block_details = fetch_block_details(block_number)
        total_transactions += len(block_details.get("result", {}).get("transactions", []))
    return total_transactions / (end_block - start_block + 1)

# Function to calculate average block time
def calculate_block_time(start_block, end_block):
    start_block_details = fetch_block_details(start_block)
    end_block_details = fetch_block_details(end_block)

    start_time = int(start_block_details.get("result", {}).get("timestamp", "0"), 16)
    end_time = int(end_block_details.get("result", {}).get("timestamp", "0"), 16)

    return (end_time - start_time) / (end_block - start_block)

if __name__ == "__main__":
    start_block = int(input("Enter the start block number: "))
    end_block = int(input("Enter the end block number: "))

    throughput = calculate_throughput(start_block, end_block)
    block_time = calculate_block_time(start_block, end_block)

    print(f"Transaction Throughput: {throughput} transactions per block")
    print(f"Average Block Time: {block_time} seconds")