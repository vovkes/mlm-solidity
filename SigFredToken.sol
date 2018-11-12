pragma solidity ^0.4.24;

import "./ownership/Ownable.sol";
import "./ERC20/ERC20.sol";
//import "./EthPriceDependent.sol";
import "./EthPriceDependentTest.sol";

contract SigFredToken is ERC20, Ownable, EthPriceDependentTest {

    string public constant name = "SigFredToken";
    string public constant symbol = "SGF";
    uint8 public constant decimals = 0;

    uint256 public constant INITIAL_SUPPLY = 24 * (10 ** 9) * (10 ** uint256(decimals));

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

    function setTokenOneTimeReferralReward (uint _percent) external onlyOwner {
        c_tokenOneTimeReferralReward = _percent;
    }

    function ether2tokens(uint _ether) public view returns (uint) {
        return _ether.mul(m_ETHPriceInCents).div(1 ether).div(c_tokenPriceInCents);
    }

    function tokens2ether(uint _tokens) public view returns (uint) {
        return _tokens.mul(c_tokenPayOutPriceInCentsDecimals).div(10).mul(1 ether).div(m_ETHPriceInCents);
    }

    /// @notice minimum investment in cents
    uint public constant c_MinInvestmentInCents = 500; // EUR5

    /// @notice minimum payOut in cents
    uint public constant c_MinPayOutInCents = 1000; // EUR10

    /// @notice token price in cents
    uint public c_tokenPriceInCents = 1; // EUR0.01

    /// @notice token price in cents decimals
    uint public c_tokenPayOutPriceInCentsDecimals = 5; // EUR0.05

    /// @notice token day percent thousands
    uint public c_tokenDayPercentThousands = 666; // 0.666%

    /// @notice current amount of tokens sold
    uint public m_currentTokensSold;

    /// @notice token one time referral reward in percents
    uint public c_tokenOneTimeReferralReward = 5; // 5%

}
