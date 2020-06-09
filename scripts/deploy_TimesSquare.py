from brownie import *


def deploy_times_square(payment_address):
    times_square = TimesSquare.deploy(payment_address,{"from": accounts[0]})
    return times_square

def main():
    # add accounts if active network is ropsten
    if network.show_active() == 'ropsten':
        # 0x2A40019ABd4A61d71aBB73968BaB068ab389a636
        accounts.add('4ca89ec18e37683efa18e0434cd9a28c82d461189c477f5622dae974b43baebf')
        # 0x1F3389Fc75Bf55275b03347E4283f24916F402f7
        accounts.add('fa3c06c67426b848e6cef377a2dbd2d832d3718999fbe377236676c9216d8ec0')
        # Ropsten Decentraland MANA 
        payment_address = web3.toChecksumAddress(0x2a8Fd99c19271F4F04B1B7b9c4f7cF264b626eDB)


    times_square =  deploy_times_square(payment_address)

 