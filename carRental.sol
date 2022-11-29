// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract CarRental {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    // Add a customer as a car renter
    struct Renter {
        address payable walletAddress;
        string firstName;
        string lastName;
        bool canRent;
        bool active;
        uint256 balance;
        uint256 due;
        uint256 start;
        uint256 end;
    }

    // Map to store renters data
    mapping(address => Renter) public renters;

    // Add a renter to the map
    function addRenter(
        address payable walletAddress,
        string memory firstName,
        string memory lastName,
        bool canRent,
        bool active,
        uint256 balance,
        uint256 due,
        uint256 start,
        uint256 end
    ) public {
        renters[walletAddress] = Renter(
            walletAddress,
            firstName,
            lastName,
            canRent,
            active,
            balance,
            due,
            start,
            end
        );
    }
}