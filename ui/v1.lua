return function(text: string, duration: number)
    local TweenService = game:GetService("TweenService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

    -- UI Setup
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SimpleNotify"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    local container = Instance.new("Frame")
    container.AnchorPoint = Vector2.new(1, 0)
    container.Position = UDim2.new(1, -20, 0, 20)
    container.Size = UDim2.new(0, 300, 1, -40)
    container.BackgroundTransparency = 1
    container.Name = "NotifyContainer"
    container.Parent = screenGui

    -- Notify Function
    local function notify(text: string, duration: number)
        duration = duration or 3

        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 40)
        frame.Position = UDim2.new(0, 0, 0, 0)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        frame.BackgroundTransparency = 0.1
        frame.BorderSizePixel = 0
        frame.ClipsDescendants = true
        frame.AutomaticSize = Enum.AutomaticSize.Y
        frame.Parent = container
        frame.AnchorPoint = Vector2.new(0, 0)

        local corner = Instance.new("UICorner", frame)
        corner.CornerRadius = UDim.new(0, 8)

        local stroke = Instance.new("UIStroke", frame)
        stroke.Color = Color3.fromRGB(80, 80, 80)
        stroke.Thickness = 1

        local label = Instance.new("TextLabel")
        label.Text = text
        label.Font = Enum.Font.Gotham
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextWrapped = true
        label.TextSize = 16
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, -20, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        -- Slide In Animation
        TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, 0)
        }):Play()

        -- Push down other notifications
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Frame") and child ~= frame then
                child:TweenPosition(child.Position + UDim2.new(0, 0, 0, 50), "Out", "Quad", 0.3, true)
            end
        end

        -- Auto-remove after duration
        task.delay(duration, function()
            local tweenOut = TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1,
                Position = frame.Position - UDim2.new(0, 0, 0, 50)
            })

            local textFade = TweenService:Create(label, TweenInfo.new(0.4), {
                TextTransparency = 1
            })

            local strokeFade = TweenService:Create(stroke, TweenInfo.new(0.4), {
                Transparency = 1
            })

            tweenOut:Play()
            textFade:Play()
            strokeFade:Play()

            tweenOut.Completed:Wait()
            frame:Destroy()
        end)
    end

    -- Call the notification
    notify(text, duration)
end
