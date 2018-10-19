pragma solidity ^0.4.24;

import "./ERC20/ERC20.sol";
import "./EthPriceDependent.sol";

contract SigFriedToken is ERC20, EthPriceDependent {

    string public constant name = "SigFriedToken";
    string public constant symbol = "SFT";
    uint8 public constant decimals = 9;

    uint256 public constant INITIAL_SUPPLY = 24 * (10 ** uint256(decimals));

    event FundTransfer(address saver, uint amount);
    event TokensBought(address saver, uint tokens);

    constructor() public {
        _mint(msg.sender, INITIAL_SUPPLY);
    }


    function buyTokens() public payable {
        internalBuy(msg.sender, msg.value);
    }

    function internalBuy(address client, uint payment) internal {
        require( !priceExpired() );
        require((payment.mul(m_ETHPriceInCents)).div(1 ether) >= c_MinInvestmentInCents);

        uint tokens = ether2tokens(payment);

        // change ICO investment stats
        m_currentTokensSold = m_currentTokensSold.add(tokens);

        // send bought tokens to the client
        _transfer(owner(), client, tokens);

        emit FundTransfer(client, payment);
        emit TokensBought(client, tokens);
    }


    function setTokenPriceInCents(uint _price) external onlyOwner {
        c_tokenPriceInCents = _price;
    }

    function ether2tokens(uint ether_) public view returns (uint) {
        return ether_.mul(m_ETHPriceInCents).div(c_tokenPriceInCents).div(100);
    }

    function tokens2ether(uint tokens) public view returns (uint) {
        return tokens.mul(100).mul(c_tokenPriceInCents).div(m_ETHPriceInCents);
    }



    /// @notice minimum investment in cents
    uint public constant c_MinInvestmentInCents = 500; // EUR5

    /// @notice token price in cents
    uint public c_tokenPriceInCents = 1; // EUR0.01

    /// @notice current amount of tokens sold
    uint public m_currentTokensSold;
}
