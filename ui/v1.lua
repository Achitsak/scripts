-- Roblox Notification System
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local NotificationUI = {}

-- Configuration
NotificationUI.Config = {
    MaxNotifications = 5,
    NotificationLifetime = 5,
    Width = 250,
    Height = 60,
    Padding = 10,
    ScreenPadding = 20,
    Offset = UDim2.new(0, 20, 0, 20)
}

-- Create Notification Container
function NotificationUI:CreateContainer()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Check if container exists
    local existingContainer = playerGui:FindFirstChild("NotificationContainer")
    if existingContainer then
        return existingContainer
    end
    
    -- Create container
    local container = Instance.new("ScreenGui")
    container.Name = "NotificationContainer"
    container.ResetOnSpawn = false
    container.Parent = playerGui
    
    return container
end

-- Notification Color Palette
local NotificationColors = {
    Default = {
        Background = Color3.fromRGB(50, 50, 50),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Success = {
        Background = Color3.fromRGB(76, 175, 80),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Warning = {
        Background = Color3.fromRGB(255, 152, 0),
        Text = Color3.fromRGB(0, 0, 0)
    },
    Error = {
        Background = Color3.fromRGB(244, 67, 54),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Info = {
        Background = Color3.fromRGB(33, 150, 243),
        Text = Color3.fromRGB(255, 255, 255)
    }
}

-- Create Notification
function NotificationUI:CreateNotification(container, message, notificationType)
    -- Get color scheme
    local colors = NotificationColors[notificationType] or NotificationColors.Default
    
    -- Create notification frame
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, self.Config.Width, 0, self.Config.Height)
    notification.BackgroundColor3 = colors.Background
    notification.BackgroundTransparency = 0.2
    notification.BorderSizePixel = 0
    notification.Position = UDim2.new(1, -self.Config.Width - self.Config.ScreenPadding, 1, self.Config.ScreenPadding)
    
    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notification
    
    -- Message label
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -40, 1, -20)
    messageLabel.Position = UDim2.new(0, 20, 0, 10)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Font = Enum.Font.GothamSemibold
    messageLabel.TextColor3 = colors.Text
    messageLabel.TextScaled = true
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.Text = message
    messageLabel.Parent = notification
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 15)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "✕"
    closeButton.TextColor3 = colors.Text
    closeButton.TextScaled = true
    closeButton.Parent = notification
    
    -- Adjust existing notifications
    local existingNotifications = container:GetChildren()
    for i, existingNotif in ipairs(existingNotifications) do
        if existingNotif:IsA("Frame") then
            local targetY = existingNotif.Position.Y.Offset - (self.Config.Height + self.Config.Padding)
            
            local tweenInfo = TweenInfo.new(
                0.3, 
                Enum.EasingStyle.Quad, 
                Enum.EasingDirection.Out
            )
            
            local tween = TweenService:Create(existingNotif, tweenInfo, {
                Position = UDim2.new(1, -self.Config.Width - self.Config.ScreenPadding, 0, targetY)
            })
            tween:Play()
        end
    end
    
    -- Remove if too many notifications
    if #existingNotifications >= self.Config.MaxNotifications then
        existingNotifications[1]:Destroy()
    end
    
    -- Animate entrance
    notification.Parent = container
    
    local tweenInfo = TweenInfo.new(
        0.3, 
        Enum.EasingStyle.Quad, 
        Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(notification, tweenInfo, {
        Position = UDim2.new(1, -self.Config.Width - self.Config.ScreenPadding, 0, self.Config.ScreenPadding)
    })
    tween:Play()
    
    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        local closeTween = TweenService:Create(notification, tweenInfo, {
            Position = UDim2.new(1, self.Config.Width, 0, notification.Position.Y.Offset)
        })
        closeTween:Play()
        
        closeTween.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
    
    -- Auto remove after lifetime
    task.delay(self.Config.NotificationLifetime, function()
        if notification and notification.Parent then
            local closeTween = TweenService:Create(notification, tweenInfo, {
                Position = UDim2.new(1, self.Config.Width, 0, notification.Position.Y.Offset)
            })
            closeTween:Play()
            
            closeTween.Completed:Connect(function()
                notification:Destroy()
            end)
        end
    end)
end

-- Send notification
function NotificationUI:Notify(message, notificationType)
    local container = self:CreateContainer()
    self:CreateNotification(container, message, notificationType)
end

-- Example usage
local function setupNotificationDemo()
    local player = Players.LocalPlayer
    
    -- Demonstration of different notification types
    task.wait(2)
    NotificationUI:Notify("Welcome to the game!", "Success")
    
    task.wait(2)
    NotificationUI:Notify("New item acquired!", "Info")
    
    task.wait(2)
    NotificationUI:Notify("Low health warning!", "Warning")
    
    task.wait(2)
    NotificationUI:Notify("Connection error!", "Error")
end

-- Run demo when player joins
Players.PlayerAdded:Connect(function(player)
    if player == Players.LocalPlayer then
        setupNotificationDemo()
    end
end)

return NotificationUI