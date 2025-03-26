import requests
import time
import threading

# Configuration
RPC_ENDPOINT = "http://localhost:8545"
REQUESTS_PER_SECOND = 10
DURATION_SECONDS = 60

# Function to send a single RPC request
def send_rpc_request():
    payload = {
        "jsonrpc": "2.0",
        "method": "eth_blockNumber",
        "params": [],
        "id": 1
    }
    try:
        response = requests.post(RPC_ENDPOINT, json=payload)
        if response.status_code == 200:
            print(f"Response: {response.json()}")
        else:
            print(f"Error: {response.status_code}")
    except requests.exceptions.RequestException as e:
        print(f"Request failed: {e}")

# Function to perform load testing
def load_test():
    end_time = time.time() + DURATION_SECONDS
    while time.time() < end_time:
        threads = []
        for _ in range(REQUESTS_PER_SECOND):
            thread = threading.Thread(target=send_rpc_request)
            threads.append(thread)
            thread.start()
        for thread in threads:
            thread.join()
        time.sleep(1)

if __name__ == "__main__":
    print("Starting load test...")
    load_test()
    print("Load test completed.")