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

    // Checkout a car
    function rentCar(address walletAddress) public {
        require(
            renters[walletAddress].due == 0,
            "You have a pending balance, please pay it."
        );
        require(
            renters[walletAddress].canRent == true,
            "You cannot rent at this time."
        );
        renters[walletAddress].active = true;
        renters[walletAddress].start = block.timestamp;
        renters[walletAddress].canRent = false;
    }

    // Check in a car
    function returnCar(address walletAddress) public {
        require(
            renters[walletAddress].active == true,
            "Please rent a car first."
        );
        renters[walletAddress].active = false;
        renters[walletAddress].end = block.timestamp;

        //Set rent amount due
        setDue(walletAddress);
    }

    function getRentDuration(address walletAddress) public view returns (uint256){
        require(
            renters[walletAddress].active == false,
            "Car is currently checked out (rented)."
        );
        //uint timespan = renterTimeSpan(renters[walletAddress].start, renters [walletAddress].end);
        //uint timespanInMin = timespan / 60;
        //return timespanInMin;
        return 60;
    }

    // Check if can rent
    function canRent(address walletAddress) public view returns (bool) {
        return renters[walletAddress].canRent;
    }

    // Deposit to current balance
    function deposit(address walletAddress) public payable {
        renters[walletAddress].balance += msg.value;
    }

    // Set due amount (0.13 Ether/day, 0.0054 Ether/hour, 0.00009027777 Ether/min)
    function setDue(address walletAddress) internal {
        uint256 timespanMinutes = getRentDuration(walletAddress);
        renters[walletAddress].due = timespanMinutes * 130000000000000000;
    }
}
