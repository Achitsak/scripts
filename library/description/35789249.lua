repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players")
repeat task.wait() until game:GetService("Players").LocalPlayer.leaderstats

local Request = http_request or request or (syn and syn.request) or (fluxus and fluxus.request) or (getgenv and getgenv().request)
local Player = game:GetService("Players").LocalPladyer

getgenv().value = function(n)
    local formatted = tostring(n)
    local k
    while true do
        formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
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
        local data = Player.leaderstats:FindFirstChild('Sheckles').Value 
        if data then
            money = getgenv().value(data)
            getgenv().Description(string.format("Money: %s $", money))
        end
        task.wait(5)
    end
end)
