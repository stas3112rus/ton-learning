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

    let indexOfCarrying = carryingArmy / sumResourcesInVillage;

    setPoportionately(resourcesInVillage, indexOfCarrying);
    
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

function setPoportionately(resources, index){  
    resources.forEach(resource =>{
        resourcesСapturedArmy.push(Math.round(resource * index));
    });  
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

// If army can't carry
console.log(attackTheVilage([5,6,7], 0));

// If in village is nothing
console.log(attackTheVilage([], 10));


// If army can carry more then are in the village
console.log(attackTheVilage([5,6,7], 20));

// calculate poportionately
console.log(attackTheVilage([5,6,7], 15));

// calculate poportionately
console.log(attackTheVilage([8,1,1], 9));

// calculate poportionately
console.log(attackTheVilage([100,300,200], 120));