// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PredictionMarket {
    enum BetType {
        UP,
        DOWN
    }

    struct Bet {
        address user;
        BetType betType;
        uint256 amount;
    }

    Bet[] public bets;
    mapping(address => uint256) public winnings;

    address public reactiveContract;
    uint256 public endTime;
    uint256 public finalPrice;

    constructor(address _reactiveContract, uint256 _duration) {
        reactiveContract = _reactiveContract;
        endTime = block.timestamp + _duration;
    }

    function placeBet(BetType betType) external payable {
        require(block.timestamp < endTime, "Betting period has ended");
        require(msg.value > 0, "Must send ETH to place bet");

        bets.push(Bet(msg.sender, betType, msg.value));
    }

    function setFinalPrice(uint256 _finalPrice) external {
        require(
            msg.sender == reactiveContract,
            "Only the reactive contract can set the final price"
        );
        require(block.timestamp >= endTime, "Prediction period has not ended");

        finalPrice = _finalPrice;
        distributeWinnings();
    }

    function distributeWinnings() internal {
        uint256 totalUp = 0;
        uint256 totalDown = 0;

        for (uint256 i = 0; i < bets.length; i++) {
            if (bets[i].betType == BetType.UP) {
                totalUp += bets[i].amount;
            } else {
                totalDown += bets[i].amount;
            }
        }

        for (uint256 i = 0; i < bets.length; i++) {
            if (
                (finalPrice > bets[0].amount &&
                    bets[i].betType == BetType.UP) ||
                (finalPrice <= bets[0].amount &&
                    bets[i].betType == BetType.DOWN)
            ) {
                winnings[bets[i].user] +=
                    bets[i].amount +
                    ((bets[i].amount / (totalUp + totalDown)) *
                        (totalUp + totalDown));
            }
        }
    }

    function withdrawWinnings() external {
        uint256 amount = winnings[msg.sender];
        require(amount > 0, "No winnings to withdraw");

        winnings[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
