pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Product2 {
    uint public productResult = 1;
    
    constructor() public {
       
		require(tvm.pubkey() != 0, 101);
		
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
    }

    	modifier checkOwnerAndAccept {
		// Check that message was signed with contracts key.
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

    function multiply(uint value) public checkOwnerAndAccept{
        
		//Value should be from 10 to 10
        require(value >=1 && value<=10, 123);
        productResult=value*productResult;
    }
}