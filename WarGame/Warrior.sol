
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "BasicStation.sol";
import "WarUnit.sol";

contract Warrior is WarUnit{
  
    constructor(BasicStation basicStation) WarUnit(basicStation) public {
        tvm.accept();

        lifeValue.min = 30;
        lifeValue.max = 50;
        
        amountOfLife = makeRndValue(lifeValue.min, lifeValue.max);

        powerValue.min = 30;
        powerValue.max = 50;
        
        powerAttacke = makeRndValue(lifeValue.min, lifeValue.max); 
    }    
}
