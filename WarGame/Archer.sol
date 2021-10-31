pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "BasicStation.sol";
import "WarUnit.sol";

contract Archer is WarUnit{

    constructor(BasicStation basicStation) WarUnit(basicStation) public {
        tvm.accept();
       
        lifeValue.min = 10;
        lifeValue.max = 15;
        
        amountOfLife = makeRndValue(lifeValue.min, lifeValue.max);

        powerValue.min = 5;
        powerValue.max = 10;
        
        powerAttacke = makeRndValue(lifeValue.min, lifeValue.max);
    }
}
