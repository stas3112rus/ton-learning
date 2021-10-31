
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "GameObject.sol";

contract BasicStation is GameObject{    
 
    mapping (GameObject=>bool) private unitInStation ;
         
    constructor() public {
        tvm.accept();
        //BasicStation`s amountOfLife can be from 50 to 250
        
        lifeValue.min = 50;
        lifeValue.max = 250;
        
        amountOfLife = makeRndValue(lifeValue.min, lifeValue.max);
    }

    function addUnitInStation (GameObject unit) public {
        tvm.accept();
 
        unitInStation[unit] = true;
    }

    function removeUnitInStation (GameObject unit) public {
        tvm.accept();

        //Check, that unit is in the station
        require(unitInStation.exists(unit), 101);

        // Check, that function call owner or Unit 
        require(msg.pubkey() == tvm.pubkey() || msg.sender == address(unit), 102);

        delete unitInStation[unit];
    }

    function getArrUnitInBase () public returns(GameObject[]){
        GameObject[] units;

        for((GameObject unit, bool isInBse) : unitInStation){
            units.push(unit);
        }

        return units;
    }

    function destroyChildsUnits(address dest) virtual internal override{
        for((GameObject unit, bool isInBase) : unitInStation){
            unit.desroyObject(dest);
        }
    }
}
