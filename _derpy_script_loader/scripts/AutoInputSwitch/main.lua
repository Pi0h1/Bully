--[[
Main script

Runs right after the game's script manager is setup, and before the game's
main.lur starts. Happens again when the game restarts.
]]

-- -------------------------------------------------------------------------- --
-- Header                                                                     --
-- -------------------------------------------------------------------------- --

RequireSystemAccess()
RequireLoaderVersion(10)

-- -------------------------------------------------------------------------- --
-- Load Package / Library                                                     --
-- -------------------------------------------------------------------------- --

local lib, err = loadlib(GetPackageFilePath('MainMenu.dll'), 'MainMenu')
if type(lib) ~= 'function' then error(err) end
lib()

-- -------------------------------------------------------------------------- --
-- Load Scripts                                                               --
-- -------------------------------------------------------------------------- --

LoadScript('core/init.lua')
LoadScript('core/setup.lua')
LoadScript('API.lua')

-- -------------------------------------------------------------------------- --
-- Import                                                                     --
-- -------------------------------------------------------------------------- --

local ais = AUTO_INPUT_SWITCH

-- -------------------------------------------------------------------------- --
-- Start                                                                      --
-- -------------------------------------------------------------------------- --
-- Immediately run the script once in main menu
-- Not inside `main()` function, as this function starts immediately 'after'
-- main menu, not while in main menu.

ais.Thread.Main = CreateSystemThread(function()
  local autoInputSwitch = ais.GetSingleton()
  while true do
    Wait(0)
    autoInputSwitch:MainLogic()
  end
end)

-- -------------------------------------------------------------------------- --
-- On Script Shutdown                                                         --
-- -------------------------------------------------------------------------- --

function MissionCleanup()
  -- ------------------------------------------------------------------------ --
  -- Terminate Thread                                                         --
  -- ------------------------------------------------------------------------ --

  if ais.Thread.Init then TerminateThread(ais.Thread.Init) end
  if ais.Thread.Main then TerminateThread(ais.Thread.Main) end

  -- ------------------------------------------------------------------------ --
  -- Clear Global Variable                                                    --
  -- ------------------------------------------------------------------------ --

  _G.AUTO_INPUT_SWITCH = nil
end
