pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "BasicStation.sol";
import "WarUnit.sol";

contract Archer is WarUnit{

    constructor(BasicStation basicStation) WarUnit(basicStation) public {
        tvm.accept();

        // Warrior`s amountOfLife can be from 10 to 25
        amountOfLife = int(rnd.next(15)) + 10;

        // Warrior`s amountOfLife can be from 5 to 15
        powerAttacke = rnd.next(10) + 5;
    }
}
