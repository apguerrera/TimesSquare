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


def test_init_fake_mana(fake_mana):
    assert fake_mana.name() == "Decentraland MANA"

def test_fake_mana_mint(fake_mana):
    assert fake_mana.balanceOf(accounts[0], {"from": accounts[0]}) == OWNER_TOKENS
