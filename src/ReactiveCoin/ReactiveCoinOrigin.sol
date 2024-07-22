// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;

contract OriginChainContract {
    event KingOfTheHill(address indexed memecoin, uint256 price);

    function emitKingOfTheHillEvent(address memecoin, uint256 price) external {
        emit KingOfTheHill(memecoin, price);
    }
}
