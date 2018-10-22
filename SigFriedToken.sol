pragma solidity ^0.4.24;

import "./ERC20/ERC20.sol";
import "./EthPriceDependent.sol";

contract SigFriedToken is ERC20, EthPriceDependent {

    string public constant name = "SigFriedToken";
    string public constant symbol = "SFT";
    uint8 public constant decimals = 9;

    uint256 public constant INITIAL_SUPPLY = 24 * (10 ** uint256(decimals));

    event TokensBought(address saver, uint tokens, uint amountInETH);
    event TokensPercents(address saver, uint tokens);
    event TokensSell(address saver, uint tokens, uint amountInETH);

    constructor() public {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function setTokenPriceInCents(uint _price) external onlyOwner {
        c_tokenPriceInCents = _price;
    }

    function setTokenDayPercentThousands(uint _percentThousands) external onlyOwner {
        c_tokenDayPercentThousands = _percentThousands;
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

    /// @notice token day percent thousands
    uint public c_tokenDayPercentThousands = 666; // 0.666%

    /// @notice current amount of tokens sold
    uint public m_currentTokensSold;
}
