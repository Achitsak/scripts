local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Advanced Notification System
local NotificationService = {}
NotificationService.__index = NotificationService

-- Comprehensive Color Palette
NotificationService.Colors = {
    DEFAULT = {
        Background = Color3.fromRGB(60, 60, 60),
        Text = Color3.fromRGB(230, 230, 230),
        Accent = Color3.fromRGB(120, 120, 120),
        ProgressBar = Color3.fromRGB(150, 150, 150)
    },
    SUCCESS = {
        Background = Color3.fromRGB(40, 180, 40),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(70, 220, 70),
        ProgressBar = Color3.fromRGB(100, 255, 100)
    },
    WARNING = {
        Background = Color3.fromRGB(255, 160, 0),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(255, 200, 50),
        ProgressBar = Color3.fromRGB(255, 220, 100)
    },
    ERROR = {
        Background = Color3.fromRGB(230, 50, 50),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(255, 120, 120),
        ProgressBar = Color3.fromRGB(255, 150, 150)
    },
    INFO = {
        Background = Color3.fromRGB(50, 140, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(130, 180, 255),
        ProgressBar = Color3.fromRGB(150, 200, 255)
    }
}

-- Create Notification UI
function NotificationService.new(config)
    local self = setmetatable({}, NotificationService)
    
    -- Default Configuration
    self.Config = {
        MaxNotifications = config and config.MaxNotifications or 5,
        Width = config and config.Width or 300,
        Position = config and config.Position or UDim2.new(1, -20, 0, 20),
        NotificationHeight = config and config.NotificationHeight or 50,
        Spacing = config and config.Spacing or 10
    }
    
    -- Create ScreenGui
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UltimateNotify"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    local container = Instance.new("Frame")
    container.Name = "NotificationContainer"
    container.AnchorPoint = Vector2.new(1, 0)
    container.Position = self.Config.Position
    container.Size = UDim2.new(0, self.Config.Width, 0, 0)
    container.BackgroundTransparency = 1
    container.Parent = screenGui
    
    self.Container = container
    self.ActiveNotifications = {}
    
    return self
end

-- Create Single Notification with Advanced Progress Bar
function NotificationService:CreateNotification(params)
    local text = params.text or "Notification"
    local notifyType = string.upper(params.type or "DEFAULT")
    local duration = params.duration or 3
    
    local colorScheme = self.Colors[notifyType] or self.Colors.DEFAULT
    
    -- Limit Notifications
    if #self.ActiveNotifications >= self.Config.MaxNotifications then
        table.remove(self.ActiveNotifications, 1):Destroy()
    end
    
    -- Create Notification Frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, self.Config.NotificationHeight)
    frame.BackgroundColor3 = colorScheme.Background
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    
    -- Rounded Corners
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 12)
    
    -- Progress Bar Container
    local progressContainer = Instance.new("Frame")
    progressContainer.Size = UDim2.new(1, 0, 0, 5)
    progressContainer.Position = UDim2.new(0, 0, 1, -5)
    progressContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    progressContainer.BorderSizePixel = 0
    progressContainer.Parent = frame
    
    local progressCorner = Instance.new("UICorner", progressContainer)
    progressCorner.CornerRadius = UDim.new(1, 0)
    
    -- Progress Bar 
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = colorScheme.ProgressBar
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressContainer
    
    local progressBarCorner = Instance.new("UICorner", progressBar)
    progressBarCorner.CornerRadius = UDim.new(1, 0)
    
    -- Text Label
    local textLabel = Instance.new("TextLabel")
    textLabel.Text = text
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextColor3 = colorScheme.Text
    textLabel.TextSize = 16
    textLabel.BackgroundTransparency = 1
    textLabel.Size = UDim2.new(1, -20, 1, 0)
    textLabel.Position = UDim2.new(0, 10, 0, 0)
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = frame
    
    -- Positioning
    local yOffset = (#self.ActiveNotifications * (self.Config.NotificationHeight + self.Config.Spacing))
    frame.Position = UDim2.new(1, 0, 0, yOffset)
    frame.Parent = self.Container
    
    -- Progress Bar Animation
    local startTime = tick()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        local elapsedTime = tick() - startTime
        local progress = math.min(elapsedTime / duration, 1)
        
        progressBar.Size = UDim2.new(1 - progress, 0, 1, 0)
        
        if progress >= 1 then
            connection:Disconnect()
            
            -- Remove from active notifications
            for i, notif in ipairs(self.ActiveNotifications) do
                if notif == frame then
                    table.remove(self.ActiveNotifications, i)
                    break
                end
            end
            
            -- Tween Out
            local tweenOut = TweenService:Create(frame, 
                TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In),
                {Position = UDim2.new(1, 0, 0, frame.Position.Y.Offset)}
            )
            tweenOut:Play()
            
            -- Reposition Remaining Notifications
            tweenOut.Completed:Connect(function()
                for i, notification in ipairs(self.ActiveNotifications) do
                    local newPos = TweenService:Create(notification, 
                        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {Position = UDim2.new(0, 0, 0, (i-1) * (self.Config.NotificationHeight + self.Config.Spacing))}
                    )
                    newPos:Play()
                end
                
                -- Destroy Frame
                frame:Destroy()
            end)
        end
    end)
    
    -- Tween In
    local tweenIn = TweenService:Create(frame, 
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0, 0, 0, yOffset)}
    )
    tweenIn:Play()
    
    -- Store Active Notification
    table.insert(self.ActiveNotifications, frame)
    
    return frame
end

-- Global Notify Function
local NotifySystem = NotificationService.new({
    MaxNotifications = 5,
    Width = 350,
    Position = UDim2.new(1, -20, 0, 20)
})

local function notify(params)
    if type(params) == "string" then
        params = {text = params}
    end
    return NotifySystem:CreateNotification(params)
end

-- Expose globally
_G.notify = notify
_G.NotificationSystem = NotifySystem

return NotificationService