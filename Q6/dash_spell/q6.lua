-- Detect if the tile is walkable
local function isWalkable(pos, creature, proj, pz)
	if getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid == 0 then return false end
	if getTopCreature(pos).uid > 0 and creature then return false end
	if getTileInfo(pos).protection and pz then return false end
	local n = not proj and 2 or 2
	for i = 0, 255 do
		pos.stackpos = i
		local tile = getTileThingByPos(pos)
		if tile.itemid ~= 0 and not isCreature(tile.uid) then
			if hasProperty(tile.uid, n) or hasProperty(tile.uid, 7) then
				return false
			end
		end
	end
	return true
end

-- When the spell is cast
local function onDash(cid)
	-- Get the player
    local player = Player(cid)
	if not player then return false end

	-- Get the tile right next to player position based on it's look direction
	local poslook = player:getPosition()
    poslook:getNextPosition(player:getDirection())
	poslook.stackpos = STACKPOS_TOP_MOVEABLE_ITEM_OR_CREATURE
	if isWalkable(poslook) then
		-- Move the player if the tile is walkable
		doMoveCreature(cid, player:getDirection())
		return true
	end
	return true
end


function onCastSpell(player, var)
	local distance = 5
	for i = 0, distance do
		-- Add the event to move the player every 50ms
		addEvent(onDash,50*i,player:getId())
	end
	return true
end 