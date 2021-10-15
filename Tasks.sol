
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract Tasks {

    struct Task {
        string nameOfTask;
        uint32 timeCreated;
        bool inWork;        
    }
    
    int8 lastKey;
    uint countTasksInWork;

    mapping(int8=>Task) allTasks; 
    
    constructor() public {
        
        require(tvm.pubkey() != 0, 101);       
        require(msg.pubkey() == tvm.pubkey(), 102);        
        tvm.accept();       
    }

    function addTask(string nameTask) public { 

        lastKey++;
        countTasksInWork++;
        allTasks[lastKey] = Task(nameTask, now, true);
        tvm.accept();        
    }

    function getCountTasksInWork() public returns (uint){

        return countTasksInWork;
    }   
   
    function getArrayTasks() public returns(Task[]) {

         Task[] result;
         for((int8 key, Task value) : allTasks){
             result.push(value);
         }

         return result;
    }    
    
    function deleteTaskByKey(int8 key) public{
        
        //Check is key in  allTasks       
        require(isTaskByKey(key), 301);
        
        if (allTasks[key].inWork)        
            countTasksInWork--;
        
        delete allTasks[key];

        tvm.accept();
    }

    function isTaskByKey(int8 keyTofind) private returns(bool){
            
        for((int8 key, Task value) : allTasks){
            if (keyTofind == key)
                return true;
         }
         return false;
    }
    
    function closeTask(int8 key) public{
        
        //Check is key in  allTasks       
        require(isTaskByKey(key), 301);

        //Check is Task in work
        require(allTasks[key].inWork, 302);

        countTasksInWork--;
        allTasks[key].inWork = false;
        
        tvm.accept();
    } 
}
