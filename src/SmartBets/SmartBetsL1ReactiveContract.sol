// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPriceFeed {
    function getPrice() external view returns (uint256);
}

interface IPredictionMarket {
    function setFinalPrice(uint256 _finalPrice) external;
}

contract ReactiveContract {
    address public predictionMarket;
    IPriceFeed public priceFeed;
    uint256 public endTime;
    address public oracle;

    event FinalPriceSet(uint256 price);

    modifier onlyOracle() {
        require(msg.sender == oracle, "Only the oracle can call this method");
        _;
    }

    constructor(
        address _predictionMarket,
        address _priceFeed,
        uint256 _endTime,
        address _oracle
    ) {
        predictionMarket = _predictionMarket;
        priceFeed = IPriceFeed(_priceFeed);
        endTime = _endTime;
        oracle = _oracle;
    }

    function setFinalPrice(uint256 _finalPrice) external onlyOracle {
        require(block.timestamp >= endTime, "Prediction period has not ended");

        IPredictionMarket(predictionMarket).setFinalPrice(_finalPrice);
        emit FinalPriceSet(_finalPrice);
    }

    function checkAndSettle() external {
        require(block.timestamp >= endTime, "Prediction period has not ended");

        uint256 finalPrice = priceFeed.getPrice();
        IPredictionMarket(predictionMarket).setFinalPrice(finalPrice);

        emit FinalPriceSet(finalPrice);
    }
}
