pragma solidity ^0.6.9;


interface IERC20 {
    function balanceOf(address owner) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}


contract TimesSquare {

    uint public constant INITIALEXPIRYBLOCKS = 10000;
    uint public constant BUMP = 10;

    IERC20 public paymentCurrency;
    address public developer;
    address public lastContributor;
    uint public expiryBlock;
    uint public minimumAmount = 0.1 ether;

    constructor (IERC20 _paymentCurrency) public {
        developer = msg.sender;
        paymentCurrency = _paymentCurrency;
        startGame();
    }

    function startGame() internal {
        expiryBlock = block.number + INITIALEXPIRYBLOCKS;
    }

    /// @dev Commit approved ERC20 token
    function commitTokens (uint256 _amount) public {
        commitTokensFrom(msg.sender, _amount);
    }

    /// @dev Users must approve contract prior to committing tokens
    function commitTokensFrom (address _from, uint256 _amount) public {
        lastContributor = _from;
        require(block.number <= expiryBlock, "Game has ended");
        require(_amount> minimumAmount, "Not enough tokens");
        require(paymentCurrency.transferFrom(_from, address(this), _amount), "Token payment failed");
        minimumAmount = _amount * 110 / 100;
        expiryBlock += BUMP;
    }

    function prizeValue() public returns (uint256) {
        uint256 amount = paymentCurrency.balanceOf(address(this));
        return amount * 90 / 100;
    }

    /// @dev Commit approved ERC20 tokens to buy tokens on sale
    function claimPrize() public {
        require(block.number > expiryBlock, "Game has not yet ended");
        uint256 amount = paymentCurrency.balanceOf(address(this));
        require(paymentCurrency.transfer(address(uint160(developer)), amount * 5 / 100));
        require(paymentCurrency.transfer(address(uint160(lastContributor)), amount * 90 / 100));
        startGame();
    }

    function blocksRemaining() public view returns (uint256) {
        if (block.number <= expiryBlock) {
            return expiryBlock - block.number;
        }
        return 0;
    }

}
