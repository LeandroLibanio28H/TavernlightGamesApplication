-- Question
--[[
    Q2 - Fix or improve the implementation of the below method

    function printSmallGuildNames(memberCount)
        -- this method is supposed to print names of all guilds that have less than memberCount max members
        local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
        local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
        local guildName = result.getString("name")
        print(guildName)
    end
]]

-- Solution
--[[
    I always find it better to keep the code that queries data separate from the code that handles the data. 
    This way, changes in the data source or the rule for querying it only affect the methods responsible for the query, 
    keeping the business logic intact.
]]
function getSmallGuildNames(memberCount)
    -- Since there is no concept of a 'Maximum number of members in a guild,' I have changed the method to search for guilds with a total number of members less than the parameterized value.
    local selectGuildQuery = "SELECT g.name FROM guilds g JOIN guild_membership gm ON gm.guild_id = g.id GROUP BY g.id HAVING COUNT(gm.player_id) < %d;"
    local query = db.storeQuery(string.format(selectGuildQuery, memberCount))

    -- Check if the query has returned any value
    if not query then return end

    -- Since it did, I iterate through all the results and add the value to a table that will be returned.
    local queryResult = {}
    repeat
        local guildName = result.getDataString(query, "name")
        table.insert(queryResult, guildName)
    until not result.next(query)

    -- release the queryResult so it's not handled by global 'result' anymore.
    result.free(queryResult)

    return queryResult
end

function printSmallGuildNames(memberCount)
    -- Check if 'memberCount' is a valid number
    if type(memberCount) ~= 'number' then
        print("Member count should be a valid number!")
        return
    end

    -- Get the guildNames calling the data access method
    local guildNames = getSmallGuildNames(memberCount)

    -- If 'guildNames' is nil, then the query did not return any guild.
    if not guildNames then
        print(string.format("There are no guilds with less than %d members", memberCount))
        return
    end

    -- Iterate through all the results and print the value
    for _, v in ipairs(guildNames) do
        print(v)
    end
end