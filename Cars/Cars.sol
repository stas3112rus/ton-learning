
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract Cars {  

   struct Car{
       string stateNumber;
       string brand;     
       uint owner;
       bool isInSale;
       uint salePrice;
   }

   mapping (string=>Car) dataOfCars;

   function createCar(string stateNumber, string brand) public{
        //Check, that stateNumber is unical
        require(!isCarInDataOfCars(stateNumber), 100);       
        
        tvm.accept();
        
        Car newCar = Car (stateNumber, brand, msg.pubkey(), false, 0);
        dataOfCars[stateNumber] = newCar;
   }

    function sellCar(string stateNumber, uint price) public{
        //Car is exist
        require(isCarInDataOfCars(stateNumber), 102);
        isSellerOwner(stateNumber);

        tvm.accept();

        dataOfCars[stateNumber].isInSale = true;
        dataOfCars[stateNumber].salePrice = price;
   }

    function isSellerOwner(string stateNumber) private {      
        require(msg.pubkey() == dataOfCars[stateNumber].owner, 101); 
   }

   function isCarInDataOfCars(string stateNumber) private returns(bool){
        return dataOfCars.exists(stateNumber);
   }
}
