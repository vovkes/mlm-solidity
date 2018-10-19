pragma solidity ^0.4.24;

import "./ERC20/ERC20.sol";
import "./EthPriceDependent.sol";

contract SigFriedToken is ERC20, EthPriceDependent {

    string public constant name = "SigFriedToken";
    string public constant symbol = "SFT";
    uint8 public constant decimals = 9;

    uint256 public constant INITIAL_SUPPLY = 24 * (10 ** uint256(decimals));

    event TokensBought(address saver, uint tokens, uint amountInETH);
    event TokensSell(address saver, uint tokens, uint amountInETH);

    constructor() public {
        _mint(msg.sender, INITIAL_SUPPLY);
    }




    function internalBuy(address client, uint payment) internal {
        require( !priceExpired() );
        require((payment.mul(m_ETHPriceInCents)).div(1 ether) >= c_MinInvestmentInCents);

        uint tokens = ether2tokens(payment);

        // change investment stats
        m_currentTokensSold = m_currentTokensSold.add(tokens);

        // send bought tokens to the client
        _transfer(owner(), client, tokens);

        emit TokensBought(client, tokens, payment);
    }

    function internalSell(address _client, uint _tokens) internal {
        require( !priceExpired() );
        require(_tokens.mul(1000).mul(c_tokenPayOutPriceInCentsDecimals) >= c_MinPayOutInCents);

        // change investment stats
        m_currentTokensSold = m_currentTokensSold.sub(_tokens);

        uint amountInETH = tokens2ether(_tokens);
        _transfer(_client, owner(), _tokens);

        _client.transfer(amountInETH);

        emit TokensSell(_client, _tokens, amountInETH);
    }

    function setTokenPriceInCents(uint _price) external onlyOwner {
        c_tokenPriceInCents = _price;
    }

    function setTokenPayOutPriceInCentsDecimals(uint _price) external onlyOwner {
        c_tokenPayOutPriceInCentsDecimals = _price;
    }

    function ether2tokens(uint ether_) public view returns (uint) {
        return ether_.mul(m_ETHPriceInCents).div(c_tokenPriceInCents).div(100);
    }

    function tokens2ether(uint tokens) public view returns (uint) {
        return tokens.mul(1000).mul(c_tokenPayOutPriceInCentsDecimals).div(m_ETHPriceInCents);
    }

    /// @notice minimum investment in cents
    uint public constant c_MinInvestmentInCents = 500; // EUR5

    /// @notice minimum payOut in cents
    uint public constant c_MinPayOutInCents = 1000; // EUR10

    /// @notice token price in cents
    uint public c_tokenPriceInCents = 1; // EUR0.01

    /// @notice token price in cents decimals
    uint public c_tokenPayOutPriceInCentsDecimals = 10; // EUR0.01

    /// @notice current amount of tokens sold
    uint public m_currentTokensSold;
}
