-- Question
--[[
    Implementation of a spell, a video was provided for reference of how it should work
]]


-- Solution
--[[
I have never worked with an OTserver or similar before, so it was certainly a very interesting experience that led me to understand a lot about the functioning of TFS and OtClient. 
To accomplish this task, I needed to fix a bug I found in the rendering of effects configured with PatternX: 2 and PatternY: 2. The fix for this rendering issue can be seen in the PR I sent to the GitHub repository:
https://github.com/edubart/otclient/pull/1216
I will still take some time to understand why the GitHub checks were not successful, but I can assure you that the solution works on all platforms and for all available special effects.
Meanwhile, the fix is available on the master branch of my forked project:
https://github.com/LeandroLibanio28H/otclient
]]
local animationDelay = 250 -- the time between spell effect iterations
local combats = {}

-- Although the spell animations are only present on certain tiles, the total sum of the areas I created forms a complete diamond shape, causing the spell to damage all tiles within its area of effect.
local areas = {
    {
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 1, 1, 0, 0, 0, 0},
        {1, 1, 0, 2, 0, 1, 1},
        {0, 1, 1, 0, 0, 0, 0},
        {0, 0, 1, 1, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
    },
    {
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 1, 1, 1, 0, 0},
        {0, 0, 1, 0, 1, 1, 0},
        {0, 0, 0, 2, 0, 1, 0},
        {0, 0, 1, 1, 1, 1, 0},
        {0, 0, 1, 1, 1, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
    },
    {
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 1, 0, 1, 0, 0},
        {0, 1, 1, 2, 1, 1, 0},
        {0, 0, 1, 0, 1, 0, 0},
        {0, 0, 0, 0, 1, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
    },
    {
        {0, 0, 0, 1, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
        {0, 0, 1, 1, 1, 0, 0},
        {0, 0, 0, 2, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
    }
}

-- The complete animation of the spell will consist of cycling through all 4 effects 3 times in sequence.
for i = 1, #areas * 3 do
    -- You cannot use the same combat damage function twice, so I recreate the function inside the loop.
    function getWinterStormDamage(player, level, magiclevel)
        local min = (level / 5) + (magiclevel * 5.5) + 25
        local max = (level / 5) + (magiclevel * 11) + 50
        return -min, -max
    end

    combats[i] = Combat()
    combats[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE) -- Set the damage type to Ice
    combats[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO) -- Set the spell effect to ICETORNADO (The animation of Eternal Winter)
    combats[i]:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "getWinterStormDamage") -- Set the callback to setup spell damage
end

-- Setting the designated combat areas
for x, _ in ipairs(areas) do
    combats[x]:setArea(createCombatArea(areas[x]))
    combats[x + #areas]:setArea(createCombatArea(areas[x]))
    combats[x + #areas * 2]:setArea(createCombatArea(areas[x]))
end

function executeNewSpellCast(playerId, combat, var)
    local player = Player(playerId)
    if not player then
        return false
    end

    combat:execute(player, var)
end

-- Called when the spell is cast
function onCastSpell(player, var)
    combats[1]:execute(player, var) -- Execute the first combat
    for i = 2, #areas * 3 do -- Iterate through the other combats and execute one after the other separated by animation delay
        addEvent(executeNewSpellCast, (animationDelay * i) - animationDelay, player:getId(), combats[i], var)
    end
    return true
end