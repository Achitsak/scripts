repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players")
repeat task.wait() until game:GetService("Players").LocalPlayer.Backpack
repeat task.wait() until game:GetService("Players").LocalPlayer.leaderstats

_G.MasterpConfigLog = {
    ['EggGarden'] = {
        ['Bee Egg'] = 'Bee Egg',
        ['Premium Anti Bee Egg'] = 'Anti Egg'
    },
    ['EggSelf'] = {
        ['Bee Egg'] = 'Bee Egg',
        ['Premium Anti Bee Egg'] = 'Anti Egg'
    },
    ['Pet'] = {
        'Queen Bee', 
        'Disco Bee', 
        'Dragonfly', 
        'Raccoon', 
        'Butterfly'
    },
    ['Seed'] = {'Carrot'},
    ['Settings'] = {
        ['NgrokHttp'] = 'https://64cb-2403-6200-8814-30c9-7d4a-c610-cf15-644c.ngrok-free.app'
    }
}

task.wait(.5)

local Player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local Leaderstats = Player:WaitForChild('leaderstats')
local Backpack = Player:WaitForChild('Backpack')
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataService = require(ReplicatedStorage.Modules.DataService)
local Request = http_request or request or (syn and syn.request) or (fluxus and fluxus.request) or (getgenv and getgenv().request)

getgenv().Alias = function(Alias)
	local SetAlias = Request({
	    Url = `{_G.MasterpConfigLog.Settings.NgrokHttp}/SetAlias?Account={game.Players.LocalPlayer.Name}`,
	    Body = tostring(Alias),
	    Method = "POST"
	})
	return SetAlias
end

getgenv().Description = function(Description)
	local SetDescription = Request({
	    Url = `{_G.MasterpConfigLog.Settings.NgrokHttp}/SetDescription?Account={game.Players.LocalPlayer.Name}`,
	    Body = tostring(Description),
	    Method = "POST"
	})
	return SetDescription
end

function getEggGarden() -- Check Egg In Garden
    local egg = {}
    for i, v in pairs(DataService:GetData()['SavedObjects']) do
        if v.ObjectType == 'PetEgg' then
            for eggName, modify in pairs(_G.MasterpConfigLog.EggGarden) do
                if v.Data.EggName == eggName then
                    egg[modify] = (egg[modify] or 0) + 1
                end
            end
        end
    end
    local resultTable = {}
    for name, count in pairs(egg) do
        table.insert(resultTable, name .. " x" .. count)
    end

    return table.concat(resultTable, ", ")
end 

function getEgg()
    local eggsession = {}
    for i, v in pairs(DataService:GetData().InventoryData) do
        if v.ItemType == 'PetEgg' then
            for eggName, modify in pairs(_G.MasterpConfigLog.EggSelf) do
                if v.ItemData['EggName'] == eggName then
                    table.insert(eggsession, tostring(modify .. ' x' .. v.ItemData['Uses']))
                end
            end
        end
    end
    return table.concat(eggsession, ", ")
end

function getSeed()
    local seedsession = {}
    for i, v in pairs(DataService:GetData().InventoryData) do
        if v.ItemType == 'Seed' then
            for _, seedName in pairs(_G.MasterpConfigLog.Seed) do
                if v.ItemData['ItemName'] == seedName then
                    table.insert(seedsession, tostring(seedName .. ' x' .. v.ItemData['Quantity']))
                end
            end
        end
    end
    return table.concat(seedsession, ", ")
end

function getPet()
    local petsession = {}
    for petId, petInfo in pairs(DataService:GetData().PetsData['PetInventory']['Data']) do
        for _, petName in ipairs(_G.MasterpConfigLog.Pet) do
            if petInfo.PetType == petName then
                petsession[petName] = (petsession[petName] or 0) + 1
            end
        end
    end
    local resultSession = {}
    for name, count in pairs(petsession) do
        table.insert(resultSession, name .. " x" .. count)
    end
    if #resultSession == 0 then
        return "None"
    end
    return table.concat(resultSession, ", ")
end


task.spawn(function()
    while true do task.wait() 
        x, p = pcall(function()
            getgenv().Alias(string.format('%s', getPet()))   
            getgenv().Description(string.format('%s / %s ', getEggGarden(), getEgg()))
        end)

        if not x then
            warn(tostring(p))
        end

        task.wait(1.1)
    end
end)

print('Hello World.')
