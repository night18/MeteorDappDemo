pragma solidity ^0.4.0;

contract payontime{
	SchedulerInterface constant scheduler = SchedulerInterface(0x26416b12610d26fd31d227456e9009270574038f);
	address public remitter;
	address private remittee;
	uint lockedUntil;
	uint value;
	string reply = "false";

	/*Only owner can use these function*/
	modifier onlyOwner(){
		if(msg.sender != remitter) throw;
		_;
	}

	/*Initialize the owner*/
	function payontime(address receiver, uint numblock) payable{
//		remitter = msg.sender;
//		value = msg.value;
		lockedUntil = block.number + numblock;
		remittee = receiver;
		
		uint[5] memory uintArgs = [
			0,//callValue
			10,//The block number the call should be executed on. This must be at least 10 blocks in the future.
			200000,      // requiredGas
            0,           // The base amount in wei that will be used to calculate the amount paid to the executor of the call.
            0 // The base amount in wei that will be used to calculate the amount donated to the creator of the service.
		];



	}

	function(){
		if(this.balance > 0){
			wakeUp();
		}
	}

	function wakeUp() public returns (bool){
		if (now < lockedUntil) return false;

        return remittee.call.value(this.balance)();
	}

	/*Get the remittee*/
	function getRemitee() public returns(address){
		return remittee;
	}
}

contract SchedulerInterface {
    //params-
    //contractAddress - The address of the contract that the call should be called on
    //abiSignature - The 4 byte ABI signature of the function to be called.
    //callData - If the abiSignature argument was specified then this should not include 
    //			 the 4-byte function signature. Otherwise the call will be double prefixed 
    //			 with the function signature which is likely not what you want.


    function scheduleCall(address contractAddress,
                      bytes4 abiSignature,
                      bytes callData,
                      uint16 requiredStackDepth,
                      uint8 gracePeriod,
                      uint[5] args) public returns (address);
}