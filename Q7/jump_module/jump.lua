jumpWindow = nil
jumpButton = nil
buttonTick = nil
buttonYOffset = 0
buttonTooltip = 'Click to jump'
buttonMoveSpeed = 50 -- In pixels per second
shouldResetX = false

local UPDATE_TICK = 1000 / 60 -- For smooth movement


function init()
  jumpPanelButton = modules.client_topmenu.addRightGameToggleButton('jumpPanelButton', tr('Jump!'), '/images/topbuttons/particles', toggle) -- Add the button to the top panel
  jumpPanelButton:setOn(false) -- Starts disabled
  
  jumpWindow = g_ui.loadUI('jump', modules.game_interface.getRightPanel()) -- Get the window widget
  jumpButton = jumpWindow:recursiveGetChildById('jumpbutton') -- Get the button from it
  jumpButton:setTooltip(buttonTooltip) -- Set the button tooltip

  jumpWindow:setup()
  jumpWindow:hide()
end

function terminate()
  jumpWindow:destroy()
  jumpPanelButton:destroy()
end

function toggle()
  -- If the window is up, close it and toggle the panel button state
  if jumpPanelButton:isOn() then
    jumpWindow:close()
    jumpPanelButton:setOn(false)
  else
    -- Else, we open the window, toggle the panel button state and set a periodical Event to move the button
    jumpWindow:open()
    jumpPanelButton:setOn(true)
    buttonTick = periodicalEvent(update, nil, UPDATE_TICK)
    setButtonStartPosition() -- Set the button start position
  end
end

function onJumpClick()
  -- Get window and button positions and heights
  local wPos, bPos = getWindowAndButtonPositions()
  local bHeight = jumpButton:getHeight()
  local wHeight = jumpWindow:getHeight()

  -- set the button to a random position
  buttonYOffset = math.random(bHeight, wHeight - bHeight)
  -- since the periodical event is always ticking, really setting the button position may not work, set a flag to make it on the event
  shouldResetX = true
end

-- tick callbakc
function update()
  -- Get window and button positions
  local wPos, bPos = getWindowAndButtonPositions()
  -- If shouldResetX is set true, we need to reset the button x position
  if shouldResetX then 
    bPos.x = getButtonStartXPosition()
    shouldResetX = false
  else
    bPos.x = bPos.x - (buttonMoveSpeed * UPDATE_TICK / 1000) -- Update the button position, we use the UPDATE_TICK / 1000 here so it's a smooth movement and buttonMoveSpeed is represented on a pixels per second unit
  end
  bPos.y = wPos.y + buttonYOffset -- This way, if we move the window, the button moves together
  
  -- if the button reaches the limit of the window, reset it's x and y position calling onJumpClick
  if bPos.x <= wPos.x then onJumpClick() end

  jumpButton:setPosition(bPos)
end

-- Get the reseted x position of the button (the right side of the window)
function getButtonStartXPosition()
  local wPos, bPos = getWindowAndButtonPositions()
  local wWidth = jumpWindow:getWidth()
  local bWidth = jumpButton:getWidth()

  return wPos.x + wWidth - bWidth
end

-- Set the button position at the start (it will always start at the bottom right corner of the window)
function setButtonStartPosition()
  local wPos, bPos = getWindowAndButtonPositions()
  local wHeight = jumpWindow:getHeight()
  local bHeight = jumpButton:getHeight()

  bPos.x = getButtonStartXPosition()
  buttonYOffset = wHeight - bHeight
  bPos.y = wPos.y + buttonYOffset
  jumpButton:setPosition(bPos)
end

function getWindowAndButtonPositions()
  local wPos = jumpWindow:getPosition()
  local bPos = jumpButton:getPosition()

  return wPos, bPos
end

-- when the window is closed, we should enable the top panel button
function onMiniWindowClose()
  jumpPanelButton:setOn(false)
end