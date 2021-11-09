pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;



abstract contract HasConstructorWithPubKey {

    constructor(uint256 pubkey) public {
        require(pubkey != 0, 120); 
    }
}
