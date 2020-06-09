pragma solidity ^0.6.9;

contract TimesSquareEth {

    uint public constant INITIALEXPIRYBLOCKS = 10000;
    uint public constant BUMP = 10;

    address public lastContributor;
    uint public expiryBlock;
    uint public minimumAmount = 0.1 ether;

    constructor () public {
        expiryBlock = block.number + INITIALEXPIRYBLOCKS;
    }

    receive () payable external {
        lastContributor = msg.sender;
        require(msg.value > minimumAmount);
        require(block.number <= expiryBlock);
        minimumAmount = msg.value * 110 / 100;
        expiryBlock += BUMP;
    }

    function claim() public {
        require(block.number > expiryBlock);
        address(uint160(lastContributor)).transfer(address(this).balance);
    }

}
