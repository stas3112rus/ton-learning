pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract Queue {

    uint32 public timestamp;
    string[] public namesInQueue;

    
    constructor() public {
       
        require(tvm.pubkey() != 0, 101);       
        require(msg.pubkey() == tvm.pubkey(), 102);        
        tvm.accept();
        timestamp = now;
    }

    function inQueue (string Name) public {
        namesInQueue.push(Name);
        tvm.accept();
    }

    function deQueue()public{
        
        uint256 lengthQueue = namesInQueue.length;
        //Check that namesInQueue isn't empty        
        require( lengthQueue> 0, 101);

        string[] newQueue = new string[](lengthQueue-1);

        for (uint32 i = 1; i<lengthQueue; i++){
            newQueue[i-1] = namesInQueue[i];
        }

        namesInQueue = newQueue;
        tvm.accept();        
    }
    
}
