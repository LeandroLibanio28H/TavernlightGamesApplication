-- Question
--[[
    Q3 - Fix or improve the name and the implementation of the below method

    function do_sth_with_PlayerParty(playerId, membername)
        player = Player(playerId)
        local party = player:getParty()

        for k,v in pairs(party:getMembers()) do 
            if v == Player(membername) then 
                party:removeMember(Player(membername))
            end
        end
    end
]]

-- Solution
--[[
    This function allows a player to remove a member from their party. I decided to name it 'removeMemberFromPlayerParty'.
]]
function removeMemberFromPlayerParty(playerId, membername)
    callingPlayer = Player(playerId) -- Get the player that is calling the function by id
    playerToRemove = Player(membername) -- Get the player to be removed using the alternative constructor Player(name or wildcard) -- https://github.com/otland/forgottenserver/wiki/Metatable:Player
    -- Check if both players were found
    if not callingPlayer or not playerToRemove then return end

    -- Check if player has a party and get the party metatable if it is
    local party = callingPlayer:getParty()
    if not party then return end
    
    -- Call party:removeMember method passing the playerToRemove id
    --[[
        The C++ code already performs all the necessary validations such as checking if the player to be removed is actually in the party, 
        transferring leadership, and disbanding the party. There is no need to validate this informations again.
        -- https://github.com/otland/forgottenserver/blob/master/src/party.cpp#L59
    ]]
    party:removeMember(playerToRemove:getId())
end