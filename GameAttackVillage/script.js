"use strict";

let resourcesСapturedArmy;

function attackTheVilage(resourcesInVillage, carryingArmy){
    let  sumResourcesInVillage = getSumAllResources (resourcesInVillage),
         sumResourcesInArmy = 0;
    resourcesСapturedArmy = [];
         
    if (carryingArmy < 0){
        carryingArmy = 0;
    }
    
    if (sumResourcesInVillage <= carryingArmy){
        resourcesСapturedArmy = resourcesInVillage;
        
        return resourcesСapturedArmy;
    }

    let multiplyOfCarrying = carryingArmy / sumResourcesInVillage;

    setPoportionately(resourcesInVillage, multiplyOfCarrying, carryingArmy);
    
    sumResourcesInArmy = getSumAllResources(resourcesСapturedArmy);
    
    let difference = carryingArmy - sumResourcesInArmy;    
    
    if (difference > 0){
        setMoreResources(difference);
    }

    return resourcesСapturedArmy;
}

function getSumAllResources (resources){
    let result = 0;
    
    resources.forEach(resource => (result += resource));
    
    return result;
}

function setPoportionately(resources, multiply, carrying){  
   
    for (let i= 0; i<resources.length; i++){
        
        let indexOfMax = getIndexMaxValue(resources);
        let add = (Math.round(resources[indexOfMax] * multiply));
      
        resources[indexOfMax] = -1;
        if (carrying - add >= 0){
            resourcesСapturedArmy[indexOfMax] = add;
            carrying -= add;
        } else {
            resourcesСapturedArmy[indexOfMax] = carrying;
            carrying = 0;
            multiply = 0;
        }    
    }  
}

function setMoreResources(difference){
    for (let i = 0; i<resourcesСapturedArmy.length; i++){
        resourcesСapturedArmy[i] = resourcesСapturedArmy[i]++;
        difference--;
        if (difference<=0){
            break;
        }
    }
}

function getIndexMaxValue(arr){
    let indexOfMax = 0,
        maxValue = arr[indexOfMax];

    arr.forEach ( (value, index) => {
        if (value > maxValue){
            indexOfMax = index;
            maxValue = value;
        }
    });

    return indexOfMax;
}

// // If army can't carry
console.log(attackTheVilage([5,6,7], 0));

// // If in village is nothing
console.log(attackTheVilage([], 10));


// // If army can carry more then are in the village
console.log(attackTheVilage([5,6,7], 20));

// // calculate poportionately
console.log(attackTheVilage([5,6,7], 15));

// // calculate poportionately
console.log(attackTheVilage([8,1,1], 9));

// // calculate poportionately
console.log(attackTheVilage([100,300,200], 120));

// // calculate poportionately
console.log(attackTheVilage([2,2,2], 5));

// calculate poportionately
console.log(attackTheVilage([1,1,1], 2));

// calculate poportionately
console.log(attackTheVilage([100,100,100,100], 2));

// calculate poportionately
console.log(attackTheVilage([1,1,1,1,1,1,1,2], 6));