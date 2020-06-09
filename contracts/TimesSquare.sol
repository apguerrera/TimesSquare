pragma solidity ^0.6.9;


interface IERC20 {
    function balanceOf(address owner) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}


contract TimesSquare {

    uint public constant INITIAL_BUMP = 100000;
    uint public constant BUMP = 100;

    IERC20 public paymentCurrency;
    address public developer;
    address public lastContributor;
    uint public expiryTime;
    uint public minimumAmount = 0.1 ether;

    event NewGame(uint256 start);
    event NewLeader(address leader, uint256 amount, uint256 expiryTime);

    constructor (IERC20 _paymentCurrency) public {
        developer = msg.sender;
        paymentCurrency = _paymentCurrency;
        startGame();
    }

    function startGame() internal {
        expiryTime = now + INITIAL_BUMP;
        emit NewGame(now);
    }


    // ----------------------------------------------------------------------------
    /// @dev Getter functions
    // ----------------------------------------------------------------------------

    function prizeValue() public view returns (uint256) {
        uint256 amount = paymentCurrency.balanceOf(address(this));
        return amount * 90 / 100;
    }

    function timeRemaining() public view returns (uint256) {
        if (now <= expiryTime) {
            return expiryTime - now;
        }
        return 0;
    }

    // ----------------------------------------------------------------------------
    /// @dev Commit Tokens
    // ----------------------------------------------------------------------------

    /// @dev Commit pre approved ERC20 tokens
    function commitTokens (uint256 _amount) public {
        commitTokensFrom(msg.sender, _amount);
    }

    /// @dev User must approve contract to spend prior to committing tokens
    function commitTokensFrom (address _from, uint256 _amount) public {
        lastContributor = _from;
        require(now <= expiryTime, "Game has ended");
        require(_amount> minimumAmount, "Not enough tokens");
        require(paymentCurrency.transferFrom(_from, address(this), _amount), "Token payment failed");
        minimumAmount = _amount * 110 / 100;
        expiryTime += BUMP;
        emit NewLeader(_from,_amount,expiryTime);
    }

    // ----------------------------------------------------------------------------
    /// @dev Claim Prize
    // ----------------------------------------------------------------------------

    /// @dev Commit approved ERC20 tokens to buy tokens on sale
    function claimPrize() public {
        require(now > expiryTime, "Game has not yet ended");
        uint256 amount = paymentCurrency.balanceOf(address(this));
        require(paymentCurrency.transfer(address(uint160(developer)), amount * 5 / 100));
        require(paymentCurrency.transfer(address(uint160(lastContributor)), amount * 90 / 100));
        startGame();
    }

}
