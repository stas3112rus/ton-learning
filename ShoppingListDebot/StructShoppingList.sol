pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

struct Buying {
    uint32 id;
    string nameBuying;
    uint32 quantity;
    uint64 createdAt;
    bool isBuying;
    uint32 totalPrice;
}

struct summary {
    uint32 itemsIsNotPayed;
    uint32 itemsIsPayed;
    uint32 totalSumBuyings;
}