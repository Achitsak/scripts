repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players")
repeat task.wait() until game:GetService("Players").LocalPlayer.Backpack
repeat task.wait() until game:GetService("Players").LocalPlayer.leaderstats

local Request = http_request or request or (syn and syn.request) or (fluxus and fluxus.request) or (getgenv and getgenv().request)

local Player = game:GetService("Players").LocalPlayer
local Leaderstats = Player:WaitForChild('leaderstats')
local Backpack = Player:WaitForChild('Backpack')


if not _G.Settings then
    _G.Settings = {['Pet'] = {}}
end

function getcount()
    local ListPet = {}
    for _, tool in pairs(Backpack:GetChildren()) do
        if tool:IsA('Tool') and tool:GetAttribute("ItemType") == "Pet" then
            local sub = string.gsub(tool.Name, " %[%d+%.?%d* KG%] %[Age %d+%]", "")
            for _, petName in ipairs(_G.Settings.Pet) do
                if sub == petName then
                    ListPet[sub] = (ListPet[sub] or 0) + 1
                end
            end
        end
    end
    local resultList = {}
    for name, count in pairs(ListPet) do
        table.insert(resultList, name .. " x" .. count)
    end
    if #resultList == 0 then
        table.insert(resultList, "None")
    end
    return table.concat(resultList, ", ")
end

getgenv().value = function(n)
    local formatted = tostring(n)
    local k
    while true do
        formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

getgenv().Alias = function(Alias)
	local SetAlias = Request({
	    Url = 'http://localhost:7963/SetAlias?Account='..Player.Name,
	    Body = tostring(Alias),
	    Method = "POST"
	})
	return SetAlias
end

getgenv().Description = function(Description)
	local SetDescription = Request({
	    Url = 'http://localhost:7963/SetDescription?Account='..Player.Name,
	    Body = tostring(Description),
	    Method = "POST"
	})
	return SetDescription
end

task.spawn(function()
    while true do task.wait()
        local data = Leaderstats:FindFirstChild('Sheckles').Value 
        if data then
            money = getgenv().value(data)
            getgenv().Alias(string.format("Money: %s $", money))
            getgenv().Description('[ '..getcount()..' ]')
        end
        task.wait(5)
    end
end)
