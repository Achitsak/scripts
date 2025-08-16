repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local Request = http_request or request
local PromptOverlay = game.CoreGui:WaitForChild("RobloxPromptGui"):WaitForChild("promptOverlay")
local isDisconnected = false

local interact = function(path)
    game:GetService("GuiService").SelectedObject = path
    task.wait()
    if game:GetService("GuiService").SelectedObject == path then
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Return, false, game)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Return, false, game)
        task.wait()
    end
    game:GetService("GuiService").SelectedObject = nil
    wait(1)
end

local data = {
	username = LocalPlayer.Name
}

LocalPlayer.OnTeleport:Connect(function(State)
    if State == Enum.TeleportState.Started then
        isDisconnected = true
    end
end)

Players.LocalPlayer.AncestryChanged:Connect(function()
    if not Players.LocalPlayer:IsDescendantOf(Players) then
        isDisconnected = true
    end
end)

PromptOverlay.ChildAdded:Connect(function(child)
	if child.Name == "ErrorPrompt" then
	 	pcall(function()
                local code = game:GetService("GuiService"):GetErrorCode().Value
                if code > 0 then
                isDisconnected = true
            end
        end)
	end
end)


-- Update status to server
task.spawn(function()
	while true do
		if not isDisconnected then
			local success, result = pcall(function()
				Request({
					Url = "https://api.zapzone.xyz/api/update",
					Method = "POST",
					Headers = { ["Content-Type"] = "application/json" },
					Body = HttpService:JSONEncode(data)
				})
			end)
			if not success then
				print("Client Not Connected!")
			end
		end
		task.wait(math.random(4, 7))
	end
end)

-- Load remote scripts
local success, err = pcall(function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Achitsak/scripts/main/ui/v3.lua"))()
end)

task.spawn(function()
    while true do task.wait(3)
        if game.CreatorId == 35789249 then
            if not _G.is_tradeing then
                for i,v in pairs(game.Players:GetPlayers()) do
                    if v.Name ~= game.Players.LocalPlayer.Name then
                        interact(game:GetService("CoreGui").PlayerList.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame["p_"..tostring(v.UserId)].ChildrenFrame.NameFrame.BGFrame)
                        if not game:GetService("CoreGui").PlayerList.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.PlayerDropDown.InnerFrame.FriendButton.CurrentButtonContainer.DropDownButton.HoverBackground.Text.Text:find("Cancel") then
                            interact(game:GetService("CoreGui").PlayerList.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.PlayerDropDown.InnerFrame.FriendButton.CurrentButtonContainer.DropDownButton)
                        end
                    end
                end
            end
        end
    end
end)


task.spawn(function()
    while true do task.wait(3)
        pcall(function()
            if game.CreatorId == 5348890 or game.CreatorId == 4372130 then
                if not _G.is_tradeing then
                    for _, v in pairs(game.Players:GetPlayers()) do
                        if v.Name ~= game.Players.LocalPlayer.Name then
                            local dropdownBtn = game:GetService("CoreGui")
                                .PlayerList.Children.OffsetFrame.PlayerScrollList
                                .SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame
                                .ScollingFrame.OffsetUndoFrame["p_"..tostring(v.UserId)]
                                .ChildrenFrame.NameFrame.BGFrame

                            interact(dropdownBtn)

                            local dropdown = game:GetService("CoreGui")
                                .PlayerList.Children.OffsetFrame.PlayerScrollList
                                .SizeOffsetFrame.ScrollingFrameContainer.PlayerDropDown.InnerFrame

                            local blockBtn = dropdown:FindFirstChild("BlockButton", true)
                            if blockBtn and blockBtn:IsA("ImageButton") then
                                local textLabel = blockBtn:FindFirstChildWhichIsA("TextLabel", true)
                                if textLabel and not textLabel.Text:find("Unblock") then
                                    interact(blockBtn)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end
end)


task.spawn(function()
    if game.CreatorId == 35789249 then
        repeat task.wait()  until game:GetService("Players").LocalPlayer:GetAttribute('DataFullyLoaded')
        task.wait(25)
        for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if v:GetAttribute("d") == true then
                local args = {
                    v
                }
                game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Favorite_Item"):FireServer(unpack(args))
        
            end
        end
    end
end)

if not success then
	warn("Failed to load remote scripts:", err)
end
