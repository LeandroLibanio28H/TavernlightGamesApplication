-- Question
--[[
    Q1 - Fix or improve the implementation of the below methods

    local function releaseStorage(player)
        player:setStorageValue(1000, -1)
    end

    function onLogout(player)
        if player:getStorageValue(1000) == 1 then
            addEvent(releaseStorage, 1000, player)
        end
        return true
    end
]]

-- Solution
--[[
    I added a new parameter to the releaseStorage, making it more generic so that it's easy to add new keys to release whenever necessary. 
    Additionally, the function now returns a boolean value representing success.
]]
local function releaseStorage(player, storageKey) 
    -- Check if player is valid
    if not player then return false end
    -- Moving the validation from the 'onLogout' function to the 'releaseStorage' function helps to maintain the responsibility of the 'onLogout' function within its scope.
    if player:getStorageValue(storageKey) == 1 then
        player:setStorageValue(storageKey, -1)
    end

    return true
end
    
function onLogout(player)
    --[[
        I don't think it's necessary for this function call to be delayed, and I believe this could cause issues, 
        as the player in question would already be logged out when the 'releaseStorage' 
        function is called. Additionally, the previous version always returned true, whereas now it returns the return value of the 'releaseStorage' function.
    ]]
    return releaseStorage(player, 1000)
end