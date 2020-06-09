from brownie import accounts, web3, Wei, reverts, rpc
from brownie.network.transaction import TransactionReceipt
from brownie.convert import to_address
import pytest
from brownie import Contract
from settings import *


# reset the chain after every test case
@pytest.fixture(autouse=True)
def isolation(fn_isolation):
    pass


def test_init_times_square(times_square):
    assert times_square.timeRemaining() == INITIAL_BUMP

def test_times_square_time_remaining(times_square):    
    assert times_square.timeRemaining() == INITIAL_BUMP
    rpc.sleep(INITIAL_BUMP + BUMP )
    rpc.mine()
    assert times_square.timeRemaining() == 0



def test_times_square_commit_tokens(times_square, fake_mana):
    amount = 10 * TENPOW18
    fake_mana.approve(times_square, amount, {"from": accounts[0]})
    with reverts("Not enough tokens"):
        tx = times_square.commitTokens("0.01 ether", {"from": accounts[0]})
    tx = times_square.commitTokens(amount, {"from": accounts[0]})
    assert tx.events['NewLeader']['amount'] == amount
    assert times_square.prizeValue( {"from": accounts[0]}) == amount * 0.9


def test_times_square_claim_prize(times_square, fake_mana):
    amount = 10 * TENPOW18
    fake_mana.approve(times_square, amount, {"from": accounts[0]})
    tx = times_square.commitTokens(amount, {"from": accounts[0]})
    with reverts("Game has not yet ended"):
        tx = times_square.claimPrize({"from": accounts[0]})

    rpc.sleep(INITIAL_BUMP + BUMP + 10)
    rpc.mine()
    assert times_square.timeRemaining() == 0
    tx = times_square.claimPrize({"from": accounts[0]})
    assert 'NewGame' in tx.events

