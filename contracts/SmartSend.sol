pragma solidity ^0.8.7;

contract SmartSend {

    address private owner;

    //uint private balance;

    // event for EVM logging
    event OwnerSet(address indexed oldOwner, address indexed newOwner);

    // modifier to check if caller is owner
    modifier isOwner() {
        // If the first argument of 'require' evaluates to 'false', execution terminates and all
        // changes to the state and to Ether balances are reverted.
        // This used to consume all gas in old EVM versions, but not anymore.
        // It is often a good idea to use 'require' to check if functions are called correctly.
        // As a second argument, you can also provide an explanation about what went wrong.
        require(msg.sender == owner, "Caller is not owner");
        _;
    }

    /**
     * @dev Set contract deployer as owner
     */
    constructor() {
        owner = msg.sender; // 'msg.sender' is sender of current call, contract deployer for a constructor
        emit OwnerSet(address(0), owner);
    }

    /**
     * @dev Change owner
     * @param newOwner address of new owner
     */
    function changeOwner(address newOwner) public isOwner {
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }

    /**
     * @dev Return owner address
     * @return address of owner
     */
    function getOwner() external view returns (address) {
        return owner;
    }


    // Errors allow you to provide information about
    // why an operation failed. They are returned
    // to the caller of the function.
    //error InsufficientBalance(uint requested, uint available);
    //error SendFailed(string reason);

    function send(address to, uint amount) public isOwner {

        if (amount > getBalance())
        //if (amount > balance)
        //revert InsufficientBalance({
        //    requested: amount,
        //    available: balance
        //});
            revert("Insuficient Funds");

        (bool sent, ) = to.call{value: amount}("");
        if(!sent){
            //revert SendFailed("network error");
            revert("Network Error");
        }
        //else {
        //    balance -= amount;
        //}
    }


    //function getBalance() external view returns (uint) {
    //    return balance;
    //}
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    //function addBalance() external payable{
    //balance += msg.value;
    //}

    receive() external payable {
        // this function enables the contract to receive funds
    }

}