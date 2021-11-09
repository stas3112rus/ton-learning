
pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "HasConstructorWithPubKey.sol";
import "IShoppingList.sol";
import "StructShoppingList.sol";

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

    uint256 public m_ownerPubkey;

    uint32 private countOfBuying = 0;
    uint32 private lastId = 0;

    summary private summaryShopping;
    mapping (uint32=>Buying) private mapIdBuying;

    constructor(uint256 pubkey) HasConstructorWithPubKey(pubkey) public{
        summaryShopping.totalSumBuyings = 0;
        m_ownerPubkey = pubkey;
        tvm.accept();
    }

    function getShoppingStatistis() external override returns (summary) {
        if (countOfBuying == 0){
            return summary(0, 0, 0);
        }

        return summaryShopping;
     }

    function setBuyingInList(string nameBuying, uint32 quantity) override external onlyOwner{  
        tvm.accept();     
        lastId++;
        countOfBuying++;

        mapIdBuying[lastId] = Buying(lastId, nameBuying, quantity, now, false, 0);
        
        summaryShopping.itemsIsNotPayed +=quantity;        
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
    function getMapIdBuying() public override returns(mapping (uint32=>Buying) shopList){
        return mapIdBuying;
    }
}

