pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "GameObjectInterface.sol";


contract   GameObject is GameObjectInterface{

    
    struct extrmums{
        int min;
        int max;
    }
    
    extrmums internal lifeValue;
    int internal amountOfLife; 


    modifier checkOwnerAndAccept {
        // Check that inbound message was signed with owner's public key.
        require(msg.pubkey() == tvm.pubkey(), 100);
        tvm.accept();
        _;
	}

    function takeAttacke(int powerAttack) virtual public override {
       tvm.accept();
       address opponent = msg.sender;

       amountOfLife -= int(powerAttack);

       if (isObjectDied()){
           desroyObject(opponent);
       }
   }
    
    function isObjectDied() private returns(bool){
       return (getAmounOfLife() <= 0);
    }

    function getAmounOfLife() virtual public returns (int){
        return amountOfLife;
    }

    function makeRndValue(int min, int max) internal returns(int){
        return rnd.next(max-min) + min; 
    }   

    function desroyObject(address opponent) virtual public checkOwnerAndAccept{
        tvm.accept();

        checkPossibilityDestoy();
        removeObjInParents();
        destroyChildsUnits(opponent);
        sendAllAndDestoy(opponent);
    }

    function checkPossibilityDestoy() virtual internal{
        // Check that inbound message was signed with owner's public key.
        require(msg.pubkey() == tvm.pubkey(), 100); 
    }

    function sendAllAndDestoy(address dest) internal{

        tvm.accept();
        uint16 flagSendAllCrystal = 128;
        uint16 flagDestroyContract = 32;

        dest.transfer(1, true, flagSendAllCrystal+flagDestroyContract);        
    }

    function removeObjInParents() virtual internal{
        
    }

    function destroyChildsUnits(address dest) virtual internal{
        
    }


}
