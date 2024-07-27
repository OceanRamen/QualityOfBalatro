utf8 = require("utf8")
local nativefs = require("nativefs")

-- Command class definition
Command = {}
Command.__index = Command

function Command:new(name, description, execute)
  local cmd = {
    name = name,
    description = description,
    execute = execute,
  }
  setmetatable(cmd, Command)
  return cmd
end

function Command:execute(args)
  print(inspectDepth(args))
  if self.execute then
    self.execute(args)
  end
end
-- CommandRegistry class definition
CommandRegistry = {}
function CommandRegistry:new()
  local registry = {
    commands = {},
  }
  setmetatable(registry, { __index = CommandRegistry })
  return registry
end

function CommandRegistry:register(command)
  self.commands[command.name] = command
end

function CommandRegistry:execute(commandName, args)
  print("cr:e"..inspectDepth(args))
  local command = self.commands[commandName]
  if command then
    command.execute(args)
  else
    table.insert(console.output, "Unknown command: " .. commandName)
  end
end


local registry = CommandRegistry:new()

-- Register built-in commands
registry:register(Command:new("help", "Show available commands", function(args)
  local commandsList = "Available commands: "
  for name, _ in pairs(registry.commands) do
    commandsList = commandsList .. name .. ", "
  end
  table.insert(console.output, commandsList:sub(1, -3))
end))

registry:register(Command:new("clear", "Clear the console output", function(args)
  console.output = {}
end))

local game_start_up_ref = Game.start_up
function Game:start_up()
  game_start_up_ref(self)
  console = {
    isOpen = false,
    input = "",
    history = {},
    output = {},
    maxHistory = 100,
    font = love.graphics.newFont(12),
    selectionStart = 1,
    selectionEnd = 1,
    isSelecting = false,
  }

  console.height = love.graphics.getHeight() / 3
end

function Saturn.key_press_update(key)
  if key == "`" then -- Toggle console with the ` key
    console.isOpen = not console.isOpen
    return -- Ignore further processing of this key
  end

  if console.isOpen then
    if key == "return" then
      if console.input ~= "" then
        table.insert(console.history, console.input)
        executeCommand(console.input)
        console.input = ""
        console.selectionStart = 1
        console.selectionEnd = 1
        console.isSelecting = false
      end

      -- Trim history if it exceeds maxHistory
      if #console.history > console.maxHistory then
        table.remove(console.history, 1)
      end
    elseif key == "backspace" then
      handleBackspace()
    elseif love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
      handleCtrlShortcuts(key)
    else
      console.isSelecting = false
    end
  end
end

function love.textinput(t)
  if console.isOpen then
    if t == "`" then
      return
    end -- Ignore backtick key input

    if console.isSelecting and console.selectionStart ~= console.selectionEnd then
      local selectionStart = math.min(console.selectionStart, console.selectionEnd)
      local selectionEnd = math.max(console.selectionStart, console.selectionEnd)
      console.input = console.input:sub(1, selectionStart - 1) .. t .. console.input:sub(selectionEnd)
      console.selectionStart = selectionStart + #t
      console.selectionEnd = console.selectionStart
      console.isSelecting = false
    else
      console.input = console.input .. t
      console.selectionStart = #console.input + 1
      console.selectionEnd = #console.input + 1
      console.isSelecting = false
    end
  end
end

local love_draw_ref = love.draw
function love.draw()
  love_draw_ref(self)
  if console.isOpen then
    love.graphics.setFont(console.font)
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), console.height)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print("> " .. console.input, 10, 10)

    -- Draw selection
    if console.isSelecting and console.selectionStart ~= console.selectionEnd then
      local selectionStart = math.min(console.selectionStart, console.selectionEnd)
      local selectionEnd = math.max(console.selectionStart, console.selectionEnd)
      local preSelection = console.input:sub(1, selectionStart - 1)
      local selectedText = console.input:sub(selectionStart, selectionEnd - 1)

      local x = 10 + love.graphics.getFont():getWidth("> " .. preSelection)
      local y = 10
      local width = love.graphics.getFont():getWidth(selectedText)
      local height = love.graphics.getFont():getHeight()

      love.graphics.setColor(0, 40, 255, 0.26)
      love.graphics.rectangle("fill", x, y, width, height)
      love.graphics.setColor(255, 255, 255, 255)
    end

    -- Calculate the number of lines that can be displayed
    local lineHeight = love.graphics.getFont():getHeight()
    local maxLines = math.floor((console.height - 20) / lineHeight) -- Leave some padding at the top

    -- Get the lines to display
    local linesToDisplay = {}
    local startY = 30
    local outputLines = #console.output
    local firstLine = math.max(1, outputLines - maxLines + 1)

    for i = firstLine, outputLines do
      table.insert(linesToDisplay, console.output[i])
    end

    -- Draw the lines
    for i = #linesToDisplay, 1, -1 do
      love.graphics.print(linesToDisplay[i], 10, startY + (#linesToDisplay - i) * lineHeight)
    end
  end
end

function executeCommand(command)
  local args = {}
  -- Split the command string into words
  for word in string.gmatch(command, "%S+") do
    table.insert(args, word)
  end

  -- Extract the command name and arguments
  local cmdName = args[1]
  table.remove(args, 1) -- Remove the command name from args

  -- Execute the command with arguments
  print(cmdName..inspectDepth(args))
  registry:execute(cmdName, args)
end


function handleBackspace()
  if console.isSelecting and console.selectionStart ~= console.selectionEnd then
    local selectionStart = math.min(console.selectionStart, console.selectionEnd)
    local selectionEnd = math.max(console.selectionStart, console.selectionEnd)
    console.input = console.input:sub(1, selectionStart - 1) .. console.input:sub(selectionEnd)
    console.selectionStart = selectionStart
    console.selectionEnd = selectionStart
    console.isSelecting = false
  else
    local byteoffset = utf8.offset(console.input, -1)
    if byteoffset then
      console.input = string.sub(console.input, 1, byteoffset - 1)
      console.selectionStart = #console.input + 1
      console.selectionEnd = #console.input + 1
      console.isSelecting = false
    end
  end
end

function handleCtrlShortcuts(key)
  if key == "a" then -- Select all
    console.selectionStart = 1
    console.selectionEnd = #console.input + 1
    console.isSelecting = true
  elseif key == "c" then -- Copy
    if console.isSelecting then
      love.system.setClipboardText(console.input:sub(console.selectionStart, console.selectionEnd - 1))
    else
      love.system.setClipboardText(console.input)
    end
  elseif key == "v" then -- Paste
    local clipboardText = love.system.getClipboardText()
    if console.isSelecting and console.selectionStart ~= console.selectionEnd then
      local selectionStart = math.min(console.selectionStart, console.selectionEnd)
      local selectionEnd = math.max(console.selectionStart, console.selectionEnd)
      console.input = console.input:sub(1, selectionStart - 1) .. clipboardText .. console.input:sub(selectionEnd)
      console.selectionStart = selectionStart + #clipboardText
      console.selectionEnd = console.selectionStart
    else
      console.input = console.input .. clipboardText
      console.selectionStart = #console.input + 1
      console.selectionEnd = #console.input + 1
    end
    console.isSelecting = false
  elseif key == "x" then -- Cut
    if console.isSelecting then
      love.system.setClipboardText(console.input:sub(console.selectionStart, console.selectionEnd - 1))
      local selectionStart = math.min(console.selectionStart, console.selectionEnd)
      local selectionEnd = math.max(console.selectionStart, console.selectionEnd)
      console.input = console.input:sub(1, selectionStart - 1) .. console.input:sub(selectionEnd)
      console.selectionStart = selectionStart
      console.selectionEnd = selectionStart
      console.isSelecting = false
    else
      love.system.setClipboardText(console.input)
      console.input = ""
      console.selectionStart = 1
      console.selectionEnd = 1
      console.isSelecting = false
    end
  end
end

local function greetCommand(args)
  if #args > 0 then
    table.insert(console.output, "Hello, " .. table.concat(args, " ") .. "!")
  else
    table.insert(console.output, "Hello, world!")
  end
end

local greet = Command:new("greet", "Outputs a greeting message", greetCommand)

registry:register(greet)

-- Define the printTable command logic
local function printTableCommand(args)
  print(inspectDepth(args))
  local function serializeTable(val, name, depth)
    local res = {}
    local function serialize(val, name, depth)
      depth = depth or 0
      local padding = string.rep("  ", depth)
      if type(val) == "table" then
        table.insert(res, padding .. (name or "") .. " = {")
        for k, v in pairs(val) do
          serialize(v, k, depth + 1)
        end
        table.insert(res, padding .. "}")
      else
        local formattedVal = (type(val) == "string") and string.format("%q", val) or tostring(val)
        table.insert(res, padding .. (name or "") .. " = " .. formattedVal)
      end
    end
    serialize(val, name, depth)
    return table.concat(res, "\n")
  end

  -- Check if args is not empty and has a table name
  if #args < 1 then
    table.insert(console.output, "Usage: printTable <tableName>")
    return
  end

  local tableName = args[1] -- First argument is the table name

  -- Ensure tableName is a string
  if type(tableName) ~= "string" then
    table.insert(console.output, "Invalid table name. Expected a string.")
    return
  end

  local tbl = _G[tableName]
  if type(tbl) == "table" then
    local result = serializeTable(tbl, tableName)
    for line in string.gmatch(result, "[^\n]+") do
      table.insert(console.output, line)
    end
  else
    table.insert(console.output, tableName .. " is not a valid table.")
  end
end

-- Create and register the printTable command
-- local printTable = Command:new("printTable", "Prints the contents of a given Lua table", printTableCommand)
-- registry:register(printTable)

-- Define the echo command logic
local function echoCommand(args)
  if #args == 0 then
    table.insert(console.output, "Usage: echo <message>")
    return
  end
  -- Concatenate all arguments into a single string
  local message = table.concat(args, " ")
  -- Print the message to the console output
  table.insert(console.output, message)
end

-- Create and register the echo command
local echo = Command:new("echo", "Echoes back the input arguments", echoCommand)
registry:register(echo)

