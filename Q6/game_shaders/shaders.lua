--[[
    I grabbed the game_shaders module found here: https://github.com/mehah/otclient/tree/main/modules/game_shaders
    And cleaned the file to contain only what is necessary for the tests, making it simpler to visualize the changes.
]]
MAP_SHADERS = { 
    {
        name = 'Dash',
        frag = 'shaders/fragment/dash.frag',
        player = true --This is a new property that I added to indicate that the shader should receive the player's outfit texture as one of its parameters.
    },
}

shadersPanel = nil

-- onUpdateShader will get the shader by name from g_shaders and setup it
function onUpdateShader(shaderName)
    local shader = g_shaders.getShader(shaderName)
    if not shader then return end
    if shader then shader:addPlayerOutfitMultiTexture() end -- new function that will update player outfit texture for the shader
end

-- attachMapShader will get the shader and set it to the map
function attachMapShader(shaderName) 
    local map = modules.game_interface.getMapPanel() --Get the map view panel from game_interface module
    local shader = g_shaders.getShader(shaderName) --Get the shader from global g_shaders
    map:setMapShader(shader) -- Set it to the map
end

-- Setup and set shader to map by name
function setMapShader(shaderName)
    onUpdateShader(shaderName)
    attachMapShader(shaderName)
end


function init()
	local registerMapShader = function(opts)
        local fragmentShaderPath = resolvepath(opts.frag)

        if fragmentShaderPath ~= nil then
            local shader = g_shaders.createMapShader(opts.name, opts.frag)

            if opts.tex1 then
                shader:addMultiTexture(opts.tex1)
            end
            if opts.tex2 then
                shader:addMultiTexture(opts.tex2)
            end
        end
    end
	
	for _, opts in pairs(MAP_SHADERS) do
        registerMapShader(opts)
    end
end

function terminate()
    disconnect(g_game, {
        onGameStart = attachShaders
    })
end

function toggle()
    shadersPanel:setVisible(not shadersPanel:isVisible())
end
