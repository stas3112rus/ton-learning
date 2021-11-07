pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;



abstract contract HasConstructorWithPubKey {

    uint256 public m_ownerPubkey;
    
    constructor(uint256 pubkey) public {
        require(pubkey != 0, 120);
        tvm.accept();
        m_ownerPubkey = pubkey;
    }
}
