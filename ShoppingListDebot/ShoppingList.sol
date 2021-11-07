
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "HasConstructorWithPubKey.sol";
import "IShoppingList.sol";

contract ShoppingList is IShoppingList, HasConstructorWithPubKey{

    modifier onlyOwner() {
        //available only to the owner 
        require(msg.pubkey() == m_ownerPubkey, 403);
        _;
    }

    modifier idInMap(uint32 id) {
        //Id should be in List of Buying, you can use function getArrayIdBuyings
        require(mapIdBuying.exists(id), 404);
        _;
    }

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

    uint32 private countOfBuying = 0;
    uint32 private lastId = 0;

    summary public summaryShopping;
    mapping (uint32=>Buying) public mapIdBuying;

    constructor(uint256 pubkey) HasConstructorWithPubKey(pubkey) public{
        summaryShopping.totalSumBuyings = 0;
    }

    function getShoppingStatistis() external override returns (string) {
        if (countOfBuying == 0){
            return string("List of buyings is empty");
        }

        return string(format("You have {}/{}/{} (items isn't payed/ items is payed /total Sum) un your list of Buying", 
        summaryShopping.itemsIsNotPayed,
        summaryShopping.itemsIsPayed,
        summaryShopping.totalSumBuyings
        ));
     }

    function setBuyingInList(string nameBuying, uint32 quantity) override external onlyOwner{  
             
        lastId++;
        countOfBuying++;

        mapIdBuying[lastId] = Buying(lastId, nameBuying, quantity, now, false, 0);
        
        summaryShopping.itemsIsNotPayed +=quantity;

        tvm.accept();
    }

    function deleteBuyingFromList(uint32 id) override external onlyOwner idInMap(id){
        tvm.accept();
        countOfBuying--;

        updateSummaryAfterDelete(id);        
        delete mapIdBuying[id];
    }

    function updateSummaryAfterDelete(uint32 id) private{
       
       tvm.accept();
       bool isBuyingMade = mapIdBuying[id].isBuying;

       if (isBuyingMade){
           summaryShopping.totalSumBuyings -= mapIdBuying[id].totalPrice;
           summaryShopping.itemsIsPayed -= mapIdBuying[id].quantity; 
       } else {
           summaryShopping.itemsIsNotPayed -= mapIdBuying[id].quantity;
       }
    }

    function makeBuying(uint32 id, uint32 totalPrice) override external onlyOwner idInMap(id){
        tvm.accept();
        updateBuyingsAfterPaying(id, totalPrice);
        updateSummaryAfterPaying(id, totalPrice);
    }

    function updateBuyingsAfterPaying(uint32 id, uint32 totalPrice) private{
        tvm.accept();
        mapIdBuying[id].isBuying = true;
        mapIdBuying[id].totalPrice = totalPrice;
    }

    function updateSummaryAfterPaying(uint32 id, uint32 totalPrice) private{
        tvm.accept();
        uint32 quantity = mapIdBuying[id].quantity;

        summaryShopping.itemsIsNotPayed -= quantity;
        summaryShopping.itemsIsPayed += quantity;
        summaryShopping.totalSumBuyings += totalPrice;
    }

    function getArrayIdBuyings() public onlyOwner returns(uint32[]){
        uint32[] result;

        for((uint32 id, Buying value) : mapIdBuying){
            result.push(id);
        }

        return result;
    }
}

// some commit

// pubkey 0x2ada2e65ab8eeab09490e3521415f45b6e42df9c760a639bcf53957550b25a16
