
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "BasicStation.sol";
import "WarUnit.sol";

contract Warrior is WarUnit{
  
    constructor(BasicStation basicStation) WarUnit(basicStation) public {
        tvm.accept();
        
        // Warrior`s amountOfLife can be from 30 to 50
        amountOfLife = rnd.next(21) + 30;

        // Warrior`s amountOfLife can be from 30 to 50
        powerAttacke = rnd.next(21) + 30;
    }    
}
