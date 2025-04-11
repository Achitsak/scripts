return function(config)
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")

    -- Color Palette
    local Colors = {
        DEFAULT = Color3.fromRGB(60, 60, 60),
        SUCCESS = Color3.fromRGB(40, 180, 40),
        WARNING = Color3.fromRGB(255, 160, 0),
        ERROR = Color3.fromRGB(230, 50, 50),
        INFO = Color3.fromRGB(50, 140, 255)
    }

    -- Notification Function
    local function Notify(text, type)
        type = type or "DEFAULT"
        local color = Colors[string.upper(type)] or Colors.DEFAULT

        -- Create ScreenGui
        local player = Players.LocalPlayer
        local playerGui = player:WaitForChild("PlayerGui")
        
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "Notification"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = playerGui

        -- Notification Frame
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 250, 0, 50)
        frame.Position = UDim2.new(1, 10, 1, -100)
        frame.BackgroundColor3 = color
        frame.BackgroundTransparency = 0.2
        frame.BorderSizePixel = 0
        frame.Parent = screenGui

        -- Rounded Corners
        local corner = Instance.new("UICorner", frame)
        corner.CornerRadius = UDim.new(0, 10)

        -- Text Label
        local textLabel = Instance.new("TextLabel")
        textLabel.Text = text
        textLabel.Font = Enum.Font.GothamBold
        textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        textLabel.TextSize = 16
        textLabel.BackgroundTransparency = 1
        textLabel.Size = UDim2.new(1, -20, 1, 0)
        textLabel.Position = UDim2.new(0, 10, 0, 0)
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.Parent = frame

        -- Progress Bar
        local progressBar = Instance.new("Frame")
        progressBar.Size = UDim2.new(1, 0, 0, 3)
        progressBar.Position = UDim2.new(0, 0, 1, -3)
        progressBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        progressBar.BorderSizePixel = 0
        progressBar.Parent = frame

        -- Tween In
        local tweenIn = TweenService:Create(frame, 
            TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Position = UDim2.new(1, -270, 1, -100)}
        )
        tweenIn:Play()

        -- Progress Bar Animation
        local startTime = tick()
        local duration = 3
        local connection
        connection = RunService.Heartbeat:Connect(function()
            local elapsedTime = tick() - startTime
            local progress = math.min(elapsedTime / duration, 1)
            
            progressBar.Size = UDim2.new(1 - progress, 0, 0, 3)
            
            if progress >= 1 then
                connection:Disconnect()
                
                -- Tween Out
                local tweenOut = TweenService:Create(frame, 
                    TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                    {Position = UDim2.new(1, 10, 1, -100)}
                )
                tweenOut:Play()
                
                -- Destroy
                tweenOut.Completed:Connect(function()
                    screenGui:Destroy()
                end)
            end
        end)

        return frame
    end

    return Notify
end