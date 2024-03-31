local distance = 6;

function init()
    g_keyboard.bindKeyDown("F1", clientDash) -- Bind F1 key to the client side dash effect
    g_keyboard.bindKeyDown("F2", spellDash) -- Bind F2 key to the server side dash effect (spell)
end
  
function terminate()
    g_keyboard.unbindKeyDown("F1")
    g_keyboard.unbindKeyDown("F2")
end
  
  
function clientDash()
    local player = g_game.getLocalPlayer() -- Get the player and check if it was found
    if not player then return end

    local finalPosition, movementTime = getFinalPositionAndTime(player) -- Get final position from current tile and the time it takes to get there
    modules.game_shaders.setMapShader('Dash') -- Activate the dash shader using the game_shaders module
    player:autoWalk(finalPosition) -- Make the player move

    -- Set an event to move stop moving the player after the time get before
    onFinishClientWalk = scheduleEvent(function()
        modules.game_shaders.setMapShader('default')
    end, movementTime)
end

function spellDash()
    local player = g_game.getLocalPlayer() -- Get the player and check if it was found
    if not player then return end

    g_game.talk("utani dash hur"); -- Make the player text the spell (Activate dash spell)
    modules.game_shaders.setMapShader('Dash') -- Activate shaders

    onFinishSpellWalk = scheduleEvent(function()
        modules.game_shaders.setMapShader('default')
    end, player:getStepDuration(true, player:getDirection()) * 6) -- utani dash hur moves 6 tiles
end


-- Returns final position and the time it takes to get there
function getFinalPositionAndTime(player)
    local playerPosition = player:getPosition()
    local playerDirection = player:getDirection()
    local movementTime = player:getStepDuration(true, playerDirection) * distance

    if playerDirection == North then
        playerPosition.y = playerPosition.y - distance
    elseif playerDirection == East then
        playerPosition.x = playerPosition.x + distance
    elseif playerDirection == South then
        playerPosition.y = playerPosition.y + distance
    elseif playerDirection == West then
        playerPosition.x = playerPosition.x - distance
    end

    return playerPosition, movementTime
end