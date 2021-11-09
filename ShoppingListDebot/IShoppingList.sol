pragma ton-solidity >=0.35.0;
pragma AbiHeader expire;
pragma AbiHeader time;
pragma AbiHeader pubkey;

import "StructShoppingList.sol";

interface IShoppingList {
    function getShoppingStatistis() external returns (summary);
    function setBuyingInList(string nameBuying, uint32 quantity) external;
    function deleteBuyingFromList(uint32 id) external;
    function makeBuying(uint32 id, uint32 totalPrice) external;
    function getMapIdBuying() external returns(mapping (uint32=>Buying));
}
