pragma solidity ^0.6.9;

contract TimesSquareEth {

    uint public constant INITIALEXPIRYBLOCKS = 10000;
    uint public constant BUMP = 10;

    address public lastContributor;
    address public developer;
    uint public expiryBlock;
    uint public minimumAmount = 0.1 ether;

    constructor () public {
        developer = msg.sender;
        startGame();
    }

    function startGame() internal {
        expiryBlock = block.number + INITIALEXPIRYBLOCKS;
    }

    function prizeValue() public returns (uint256) {
        return address(this).balance * 90 / 100;
    }
    function blocksRemaining() public view returns (uint256) {
        if (block.number <= expiryBlock) {
            return expiryBlock - block.number;
        }
        return 0;
    }

    receive () payable external {
        lastContributor = msg.sender;
        require(msg.value > minimumAmount);
        require(block.number <= expiryBlock);
        minimumAmount = msg.value * 110 / 100;
        expiryBlock += BUMP;
    }

    /// @dev Commit approved ERC20 tokens to buy tokens on sale
    function claimPrize() public {
        require(block.number > expiryBlock, "Game has not yet ended");
        uint256 amount = address(this).balance;
        address(uint160(developer)).transfer(amount * 5 / 100);
        address(uint160(lastContributor)).transfer(amount * 90 / 100);
        startGame();
    }

}
