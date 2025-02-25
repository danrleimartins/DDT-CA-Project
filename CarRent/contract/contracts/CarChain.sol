// SPDX-License-Identifier: MIT

pragma solidity ^npm;

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
        uint balance,
        uint due,
        uint start,
        uint end
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
        require(renters[walletAddress].due == 0, "You have a pending balance, please pay it.");
        require(renters[walletAddress].canRent == true, "You cannot rent at this time.");
        renters[walletAddress].active = true;
        renters[walletAddress].start = block.timestamp;
        renters[walletAddress].canRent = false;
    }

    // Check in a car
    function returnCar(address walletAddress) public {
        require(renters[walletAddress].active == true, "Please rent a car first.");
        renters[walletAddress].active = false;
        renters[walletAddress].end = block.timestamp;
        //TODO: Set rent amount due
        setDue(walletAddress);
    }

    // Get total time of car rent period
    function renterTimeSpan(uint256 start, uint256 end) internal pure returns (uint256){
        return end - start;
    }

    function getTotalDuration(address walletAddress) public view returns (uint256) {
        if (renters[walletAddress].start == 0 || renters[walletAddress].end == 0){
            return 0;
        }else{
            //uint timespan = renterTimeSpan(renters[walletAddress].start, renters [walletAddress].end);
            //uint timespanInMin = timespan / 60;
            //return timespanInMin;
            return 60;
        }
        
    }

    // Get Contract balance
    function balanceOf() view public returns (uint){
        return address(this).balance;
    }

    // Get Renter's balance
    function balanceOfRenter(address walletAddress) public view returns (uint){
        return renters[walletAddress].balance;
    }

    // Set due amount (0.13 Ether/day, 0.0054 Ether/hour, 0.00009027777 Ether/min)
    function setDue(address walletAddress) internal {
        uint timespanMinutes = getTotalDuration(walletAddress);
        renters[walletAddress].due = timespanMinutes * 130000000000000000;
    }

    // Check if can rent
    function canRent (address walletAddress) public view returns(bool){
        return renters[walletAddress].canRent;
    }

    // Deposit to current balance
    function deposit(address walletAddress) payable public {
        renters[walletAddress].balance += msg.value;
    }
    
    // Make payment out of balance and reset other variables
    function pay(address walletAddress) payable public {
        require(renters[walletAddress].due > 0, "You do not have anything due to pay.");
        require(renters[walletAddress].balance > msg.value, "You do not have enough funds to pay. Please make a deposit.");
        renters[walletAddress].balance -= msg.value;
        renters[walletAddress].canRent = true;
        renters[walletAddress].due = 0;
        renters[walletAddress].start = 0;
        renters[walletAddress].end = 0;
    }

    function getDue(address walletAddress) public view returns(uint){
        return renters[walletAddress].due;
    }

    //add this prop to the renters

    function getRenter (address walletAddress) public view returns(string memory firstName, string memory lastName, bool canRent, bool active) {
        firstName = renters[walletAddress].firstName;
        lastName = renters[walletAddress].lastName;
        canRent = renters[walletAddress].canRent;
        active = renters[walletAddress].active;
        
    }
    function renterExits(address walletAddress) public view returns(bool){
        if (renters[walletAddress].walletAddress != address (0)){
            return true;
        }
        return false;
    }

}