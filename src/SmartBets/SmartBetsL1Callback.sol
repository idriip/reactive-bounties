// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMemecoinCallback {
    function callback(address sender) external;
}

contract ReactiveContract {
    address public memecoinCallback;
    uint256 public endTime;
    address public oracle;

    event FinalPriceSet(uint256 price);

    modifier onlyOracle() {
        require(msg.sender == oracle, "Only the oracle can call this method");
        _;
    }

    constructor(address _memecoinCallback, uint256 _endTime, address _oracle) {
        memecoinCallback = _memecoinCallback;
        endTime = _endTime;
        oracle = _oracle;
    }

    function setFinalPrice(uint256 _finalPrice) external onlyOracle {
        require(block.timestamp >= endTime, "Prediction period has not ended");

        IMemecoinCallback(memecoinCallback).callback(msg.sender);
        emit FinalPriceSet(_finalPrice);
    }

    function checkAndSettle(uint256 _finalPrice) external {
        require(block.timestamp >= endTime, "Prediction period has not ended");

        IMemecoinCallback(memecoinCallback).callback(msg.sender);
        emit FinalPriceSet(_finalPrice);
    }
}
