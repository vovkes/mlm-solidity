pragma solidity ^0.4.24;

contract EthPriceDependentTest {

    function priceExpired() public pure returns (bool) {
        return false;
    }

    function setETHPriceUpperBound(uint _price) external  {
        m_ETHPriceUpperBound = _price;
    }

    function setETHPriceLowerBound(uint _price) external  {
        m_ETHPriceLowerBound = _price;
    }

    function setETHPriceManually(uint _price) external {
        m_ETHPriceInCents = _price;
    }

    function setOraclizeGasPrice() external  {

    }

    function setOraclizeGasLimit(uint _callbackGas) external  {
        m_callbackGas = _callbackGas;
    }

    function setOraclizeUpdateInterval(uint _seconds) external  {
        require(_seconds >= 1 hours);
        m_ETHPriceUpdateInterval = _seconds;
    }

    /// @notice EUR price of ETH in cents, retrieved using oraclize
    uint public m_ETHPriceInCents = 20000;
    /// @notice unix timestamp of last update
    uint public m_ETHPriceLastUpdate;
    /// @notice unix timestamp of last update request,
    ///         don't allow requesting more than once per update interval
    uint public m_ETHPriceLastUpdateRequest;

    /// @notice lower bound of the ETH price in cents
    uint public m_ETHPriceLowerBound = 100;
    /// @notice upper bound of the ETH price in cents
    uint public m_ETHPriceUpperBound = 100000000;

    /// @dev Update ETH price in cents every 1 hour
    uint public m_ETHPriceUpdateInterval = 1 days;

    /// @dev offset time inaccuracy when checking update expiration date
    uint public m_leeway = 900; // 15 minutes is the limit for miners

    /// @dev set just enough gas because the rest is not refunded
    uint public m_callbackGas = 200000;
}