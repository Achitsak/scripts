-- Roblox Notification System
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Notification Module
local NotificationModule = {}

-- Configuration
NotificationModule.Config = {
    MaxNotifications = 5,
    NotificationLifetime = 5,
    BaseWidth = 250,
    BaseHeight = 60,
    Padding = 10,
    ScreenPadding = 20,
    Ease = Enum.EasingDirection.Out,
    EaseStyle = Enum.EasingStyle.Quad
}

-- Create Notification Container
function NotificationModule:CreateNotificationContainer(player)
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Check if container already exists
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

-- Create individual notification
function NotificationModule:CreateNotification(container, message, notificationType)
    -- Notification types with colors
    local notificationColors = {
        Default = Color3.fromRGB(50, 50, 50),
        Success = Color3.fromRGB(0, 200, 0),
        Warning = Color3.fromRGB(255, 165, 0),
        Error = Color3.fromRGB(255, 0, 0),
        Info = Color3.fromRGB(0, 125, 255)
    }
    
    -- Create notification frame
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, self.Config.BaseWidth, 0, self.Config.BaseHeight)
    notification.BackgroundColor3 = notificationColors[notificationType] or notificationColors.Default
    notification.BackgroundTransparency = 0.2
    notification.BorderSizePixel = 0
    notification.Position = UDim2.new(0, self.Config.ScreenPadding, 1, self.Config.ScreenPadding)
    
    -- Create text label
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 1, -10)
    textLabel.Position = UDim2.new(0, 10, 0, 5)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextScaled = true
    textLabel.TextWrapped = true
    textLabel.Text = message
    textLabel.Parent = notification
    
    -- Create close button
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -30, 0, 10)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.Parent = notification
    
    -- Adjust existing notifications
    local existingNotifications = container:GetChildren()
    for i, existingNotif in ipairs(existingNotifications) do
        if existingNotif:IsA("Frame") then
            local targetY = existingNotif.Position.Y.Offset - (self.Config.BaseHeight + self.Config.Padding)
            existingNotif:TweenPosition(
                UDim2.new(0, self.Config.ScreenPadding, 0, targetY), 
                self.Config.Ease, 
                self.Config.EaseStyle, 
                0.3
            )
        end
    end
    
    -- Remove if too many notifications
    if #existingNotifications >= self.Config.MaxNotifications then
        existingNotifications[1]:Destroy()
    end
    
    -- Animate entrance
    notification.Parent = container
    notification:TweenPosition(
        UDim2.new(0, self.Config.ScreenPadding, 1, -self.Config.BaseHeight - self.Config.ScreenPadding), 
        self.Config.Ease, 
        self.Config.EaseStyle, 
        0.3
    )
    
    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        notification:TweenPosition(
            UDim2.new(0, self.Config.ScreenPadding, 1, self.Config.ScreenPadding), 
            self.Config.Ease, 
            self.Config.EaseStyle, 
            0.3
        )
        game.Debris:AddItem(notification, 0.3)
    end)
    
    -- Auto remove after lifetime
    game.Debris:AddItem(notification, self.Config.NotificationLifetime)
end

-- Send notification to a specific player
function NotificationModule:Notify(player, message, notificationType)
    local container = self:CreateNotificationContainer(player)
    self:CreateNotification(container, message, notificationType)
end

-- Server-side remote event for notifications
local NotificationRemote = Instance.new("RemoteEvent")
NotificationRemote.Name = "NotificationRemote"
NotificationRemote.Parent = ReplicatedStorage

-- Client-side script to handle notifications
local function setupClientNotifications()
    local player = Players.LocalPlayer
    
    NotificationRemote.OnClientEvent:Connect(function(message, notificationType)
        NotificationModule:Notify(player, message, notificationType)
    end)
end

-- Server-side function to send notifications
function NotificationModule:SendServerNotification(player, message, notificationType)
    NotificationRemote:FireClient(player, message, notificationType)
end

-- Example usage in a server script:
-- NotificationModule:SendServerNotification(player, "Welcome to the game!", "Success")

-- Setup for local player
if Players.LocalPlayer then
    setupClientNotifications()
else
    Players.PlayerAdded:Connect(setupClientNotifications)
end

return NotificationModule