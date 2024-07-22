// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;

interface IDestinationChainContract {
    function performAction(address memecoin, uint256 price) external;
}

contract ReactiveContract {
    address public originChainContract;
    address public destinationChainContract;

    event ActionTriggered(address indexed memecoin, uint256 price);

    constructor(
        address _originChainContract,
        address _destinationChainContract
    ) {
        originChainContract = _originChainContract;
        destinationChainContract = _destinationChainContract;
    }

    function handleKingOfTheHill(address memecoin, uint256 price) external {
        require(msg.sender == originChainContract, "Unauthorized sender");

        IDestinationChainContract(destinationChainContract).performAction(
            memecoin,
            price
        );
        emit ActionTriggered(memecoin, price);
    }
}
