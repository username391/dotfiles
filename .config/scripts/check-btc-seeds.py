#!/bin/python
import os
import sys
import time

import bitcoin
import mnemonic
import requests
from tqdm import tqdm
from tqdm.contrib.concurrent import thread_map

total = int(sys.argv[-1])
good_results_file = "/home/me/btc"

TIMEOUT = 5
USER_AGENT = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
    "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36"
)


def write_good_result(data: dict, secret_phrase: str, address: str):
    balance = data["confirmed"]
    transactions = data["txs"]
    tqdm.write(f"Checking address: {address}")
    tqdm.write(f"Balance: {balance}")
    tqdm.write(f"Number of transactions: {transactions}")

    if balance > 0 or transactions > 0:
        with open(good_results_file, "a") as f:
            f.write(address + " : " + secret_phrase)
            # message = address + ' : ' + secret_phrase

            os.system('notify-send.sh "Найден кошелек с балансом!"')
            return True
    return False


def generate_and_check_mnemo(_):
    # Generate a random mnemonic phrase
    mnemo = mnemonic.Mnemonic("english")
    secret_phrase = mnemo.generate(strength=256)

    # Convert the mnemonic phrase to a seed
    seed = mnemonic.Mnemonic.to_seed(secret_phrase)

    # Generate the private key from seed
    priv = bitcoin.sha256(seed)

    # Generate the public key from private key
    pub = bitcoin.privtopub(priv)

    # Generate the address from public key
    address = bitcoin.pubtoaddr(pub)

    # check balance and number of transactions
    response = requests.get(
        # f"https://blockchain.info/rawaddr/{address}",
        f"https://api.blockchain.info/haskoin-store/btc/address/{address}/balance",
        headers={
            "User-Agent": USER_AGENT,
        },
    )
    if response.status_code == 200:
        return write_good_result(response.json(), secret_phrase, address)

    elif response.status_code == 404:
        tqdm.write(f"Address {address} not found")
    else:
        os.system(f'notify-send.sh "Request failed with {response.status_code}"')
        tqdm.write(f"Request failed with status code {response.status_code}")

    return False


def main():
    results = thread_map(generate_and_check_mnemo, range(total), max_workers=2)
    found = any(results)
    # for _ in tqdm(range(total)):
    #     found = generate_and_check_mnemo()
    #     time.sleep(TIMEOUT)

    if found:
        os.system(f'notify-send.sh "Найден кошелек, проверь {good_results_file}"')
    else:
        os.system(
            f'notify-send.sh "Проверили {total} случайных сид фраз, кошельков с балансом не найдено😢"'
        )


if __name__ == "__main__":
    main()
