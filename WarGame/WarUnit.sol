
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "GameObject.sol";
import "BasicStation.sol";


 contract WarUnit is GameObject{

    BasicStation myBasicStation;
    uint internal powerAttacke;
    
    function makeAttacke (GameObjectInterface obj) public checkOwnerAndAccept{
        obj.takeAttacke(powerAttacke);
    }

    function getPowerAttacke() public returns(uint){
        return powerAttacke;
    }   
    
    function checkPossibilityDestoy() virtual internal override{
        // Add destroy, when station call destroy signal
        require(msg.pubkey() == tvm.pubkey() || address(myBasicStation) == msg.sender, 100);        
    }
    
    function removeObjInParents() virtual internal override{
        myBasicStation.removeUnitInStation(this);
    }
 }
