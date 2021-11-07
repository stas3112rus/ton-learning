pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

interface IShoppingList {
    function getShoppingStatistis() external returns (string);
    function setBuyingInList(string nameBuying, uint32 quantity) external;
    function deleteBuyingFromList(uint32 id) external;
    function makeBuying(uint32 id, uint32 totalPrice) external;
}
