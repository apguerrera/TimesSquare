
from brownie import accounts, web3, Wei, rpc
from brownie.network.transaction import TransactionReceipt
from brownie.convert import to_address
import pytest
from brownie import Contract
from settings import *

######################################
# Deploy Contracts
######################################



@pytest.fixture(scope='module', autouse=True)
def fake_mana(FAKEMana):
    fake_mana = FAKEMana.deploy({"from": accounts[0]})
    fake_mana.setBalance(accounts[0], OWNER_TOKENS)
    return fake_mana

@pytest.fixture(scope='module', autouse=True)
def times_square(TimesSquare, fake_mana):
    times_square = TimesSquare.deploy(fake_mana, {"from": accounts[0]})
    return times_square

