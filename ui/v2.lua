local Notify = {}

Notify.Show = function(title, message)
	local TweenService = game:GetService("TweenService")
	local Players = game:GetService("Players")
	local player = Players.LocalPlayer

	if not player:FindFirstChild("PlayerGui"):FindFirstChild("CleanNotifyMini") then
		-- 👇 สร้าง GUI Holder หนเดียว
		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = "CleanNotifyMini"
		screenGui.ResetOnSpawn = false
		screenGui.IgnoreGuiInset = true
		screenGui.Parent = player:WaitForChild("PlayerGui")

		local holder = Instance.new("Frame")
		holder.Name = "NotifyHolder"
		holder.Size = UDim2.new(0, 300, 1, -100)
		holder.Position = UDim2.new(1, -320, 1, -100)
		holder.AnchorPoint = Vector2.new(0, 1)
		holder.BackgroundTransparency = 1
		holder.ClipsDescendants = false
		holder.Parent = screenGui

		local layout = Instance.new("UIListLayout", holder)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Padding = UDim.new(0, 8)
		layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	end

	local holder = player.PlayerGui.CleanNotifyMini.NotifyHolder

	local box = Instance.new("Frame")
	box.Size = UDim2.new(1, 0, 0, 70)
	box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	box.BackgroundTransparency = 0.03
	box.BorderSizePixel = 0
	box.LayoutOrder = -tick()
	box.ZIndex = 10
	box.Parent = holder

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Color3.fromRGB(70, 70, 70)
	stroke.Transparency = 0.82
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = box

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 2)
	corner.Parent = box

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Text = title
	titleLabel.Font = Enum.Font.GothamSemibold
	titleLabel.TextSize = 15
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Position = UDim2.new(0, 12, 0, 8)
	titleLabel.Size = UDim2.new(1, -24, 0, 18)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 11
	titleLabel.Parent = box

	local messageLabel = Instance.new("TextLabel")
	messageLabel.Text = message
	messageLabel.Font = Enum.Font.Gotham
	messageLabel.TextSize = 13
	messageLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
	messageLabel.BackgroundTransparency = 1
	messageLabel.Position = UDim2.new(0, 12, 0, 28)
	messageLabel.Size = UDim2.new(1, -24, 1, -36)
	messageLabel.TextWrapped = true
	messageLabel.TextXAlignment = Enum.TextXAlignment.Left
	messageLabel.TextYAlignment = Enum.TextYAlignment.Top
	messageLabel.ZIndex = 11
	messageLabel.Parent = box

	box.Position = UDim2.new(1, 300, 0, 0)
	box.BackgroundTransparency = 1
	titleLabel.TextTransparency = 1
	messageLabel.TextTransparency = 1
	stroke.Transparency = 1

	local tweenIn = TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	TweenService:Create(box, tweenIn, {BackgroundTransparency = 0.03, Position = UDim2.new(0, 0, 0, 0)}):Play()
	TweenService:Create(titleLabel, tweenIn, {TextTransparency = 0}):Play()
	TweenService:Create(messageLabel, tweenIn, {TextTransparency = 0}):Play()
	TweenService:Create(stroke, tweenIn, {Transparency = 0.82}):Play()

	task.delay(4, function()
		local tweenOut = TweenInfo.new(0.35, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
		TweenService:Create(box, tweenOut, {BackgroundTransparency = 1, Position = UDim2.new(1, 300, 0, 0)}):Play()
		TweenService:Create(titleLabel, tweenOut, {TextTransparency = 1}):Play()
		TweenService:Create(messageLabel, tweenOut, {TextTransparency = 1}):Play()
		TweenService:Create(stroke, tweenOut, {Transparency = 1}):Play()
		task.wait(0.4)
		box:Destroy()
	end)
end

return Notify
