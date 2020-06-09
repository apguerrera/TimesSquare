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
    assert times_square.blocksRemaining() == 10000

def test_times_square_sleep(times_square):    
    assert times_square.blocksRemaining() == 10000
    rpc.sleep(100)
    rpc.mine(10)
    assert times_square.blocksRemaining() == 9990
