path = 'Resources/Server/Storage/bans.txt'
adminpath = 'Resources/Server/Storage/admins.txt'
bantimerpath = 'Resources/Server/Storage/bantimers.txt'
-- bans = io.open(path .. 'bans.txt', "w")
-- bans:write("File system not complete\nThis is the second line")
-- bans:close()    

-- fileread = io.open(path .. 'bans.txt', "r")
-- print("The contents in the file are:\n")
-- print(fileread:read())
-- fileread:close()
 

----------------------------------------------
-- FUNCTIONS TO MAKE LUA PROGRAMMING EASIER --
--                                          --


function append(table, value)
    table[#table+1] = value
end

function len(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function split(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then 
            return true
        end
    end
    return false
end

function file_exists(file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
  end
  

function lines_from(file)
    if not file_exists(file) then return {} end
    local lines = {}
    for line in io.lines(file) do 
      lines[#lines + 1] = line
    end
    return lines
  end

function file_len(file)
    local filelines = lines_from(file)
    return len(filelines)
    -- print(file_len(bans))
end


function addEntry(inputFile, name, banreason)
    local formattedEntry = (name .. '_##_' .. banreason) 
    local file = io.open(inputFile, 'r')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)

    fileContent[file_len(path) + 1] = formattedEntry

    file = io.open(inputFile, 'w')
    for index, value in ipairs(fileContent) do
        file:write(value..'\n')
    end
    io.close(file)
end

function checkForUser(username)
    for index, value in ipairs(lines_from(path)) do
        value = split(value, '_##_')
        if value[1] == username:lower() then
            print(username .. ' is in ban records for ' .. value[2])
            return true
        end
    end
    return false
end

function isAdmin(username)
    for index, value in ipairs(lines_from(adminpath)) do
        if username == value then
            return true
        end
    end
    return false
end

function checkBanTimers()
    while true do
        print('hello')
    end
end

--                                          --
-- FUNCTIONS TO MAKE LUA PROGRAMMING EASIER --
----------------------------------------------
function test()
    print('Test function has been called')
end

MP.CreateThread('test', 10)
 




function onChatMessage(playerID, name, message)
    print('\n[TZN] New chat message!: ' .. '\nPlayerID: ' .. playerID .. '\nName: ' .. name .. '\nMessage: ' .. message)
    if split(message, ' ')[1] == '!ban' then
        message = split(message, ' ')
        name = message[2]

        local reason = ''
        table.remove(message, 1)
        table.remove(message, 1)
        for _, value in ipairs(message) do reason = reason .. ' ' .. value end 
        reason = reason:sub(2) 
        ban(playerID, name, reason)
            -- yes I know I could have used a substring this is my first lua project give me a break lol

            -- though I would like to note that sometimes my really stupid method is more reliable because it doesn't soley rely on index, 
            -- which can be messed up by users more easily

        
    elseif split(message, ' ')[1] == '!tempban' then
        message = split(message, ' ')
        name = message[2]

        print(message)
        local reason = ''
        table.remove(message, 1)
        table.remove(message, 1)
        table.remove(message, 1)
        for _, value in ipairs(message) do reason = reason .. ' ' .. value end 
        reason = reason:sub(2) -- remove initial space
        ban(playerID, name, time, reason)        
    
    end
end


function onPlayerConnecting(playerID) 
    print('\n[TZN] Player Connecting {' .. MP.GetPlayerName(playerID) .. '}')
    if checkForUser(MP.GetPlayerName(playerID)) then
        print('\n[TZN] Player ' .. MP.GetPlayerName(playerID) .. ' tried to connect but is banned.')
        MP.DropPlayer(playerID, 'You are banned on this server!')

    end

end

function ban(playerID, name, reason) 
    if isAdmin(MP.GetPlayerName(playerID)) then
        MP.DropPlayer(playerID, 'You are banned on this server!')
        addEntry(path, name, reason)
    end
end

function tempban(playerID, name, time, reason) 
    if isAdmin(MP.GetPlayerName(playerID)) then
        MP.DropPlayer(playerID, 'You are banned on this server!')
        addEntry(path, name, reason)
    end
end

function kick(playerID, name, reason) 
    if isAdmin(MP.GetPlayerName(playerID)) then
        MP.DropPlayer(playerID, 'You have been kicked from the server. Reason: ' .. reason)
    end
end







MP.RegisterEvent("onChatMessage","onChatMessage")
MP.RegisterEvent("onPlayerConnecting","onPlayerConnecting")