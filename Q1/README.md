# Question

### Q1 - Fix or improve the implementation of the below methods
```
local function releaseStorage(player)
    player:setStorageValue(1000, -1)
end

function onLogout(player)
    if player:getStorageValue(1000) == 1 then
        addEvent(releaseStorage, 1000, player)
    end
    return true
end
```

## Solution
I added a new parameter to the releaseStorage, making it more generic so that it's easy to add new keys to release whenever necessary. 
Additionally, the function now returns a boolean value representing success.
