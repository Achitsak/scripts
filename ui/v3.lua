repeat task.wait() until game:IsLoaded()

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")

screenGui.Name = "ImageDisplayGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.new(1, 0, 0.6, 0) 
imageLabel.Position = UDim2.new(0.5, 0, 0.5, 0) 
imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
imageLabel.BackgroundTransparency = 1
imageLabel.Image = "rbxassetid://101427454514001" 
imageLabel.ScaleType = Enum.ScaleType.Fit
imageLabel.Parent = screenGui

local aspect = Instance.new("UIAspectRatioConstraint")
aspect.AspectRatio = 1
aspect.Parent = imageLabel

task.delay(3, function()
	screenGui:Destroy()
end)
