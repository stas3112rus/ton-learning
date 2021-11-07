pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

interface Transactable  {
    function sendTransaction(address dest, uint128 value, bool bounce, uint16 flag) external;
}