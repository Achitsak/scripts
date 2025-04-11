local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Advanced Notification System
local NotificationService = {}
NotificationService.__index = NotificationService

-- Comprehensive Color Palette
NotificationService.Colors = {
    DEFAULT = {
        Background = Color3.fromRGB(50, 50, 50),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(100, 100, 100)
    },
    SUCCESS = {
        Background = Color3.fromRGB(0, 170, 0),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(50, 220, 50)
    },
    WARNING = {
        Background = Color3.fromRGB(255, 128, 0),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(255, 170, 50)
    },
    ERROR = {
        Background = Color3.fromRGB(255, 50, 50),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(255, 100, 100)
    },
    INFO = {
        Background = Color3.fromRGB(40, 120, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(100, 160, 255)
    }
}

-- Sound Effects
NotificationService.Sounds = {
    DEFAULT = "rbxassetid://6958054266",
    SUCCESS = "rbxassetid://6958054482",
    WARNING = "rbxassetid://6958054103",
    ERROR = "rbxassetid://6958053963",
    INFO = "rbxassetid://6958054266"
}

-- Create Notification UI
function NotificationService.new()
    local self = setmetatable({}, NotificationService)
    
    -- Create ScreenGui
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AdvancedNotify"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    local container = Instance.new("Frame")
    container.Name = "NotificationContainer"
    container.AnchorPoint = Vector2.new(1, 0)
    container.Position = UDim2.new(1, -20, 0, 20)
    container.Size = UDim2.new(0, 300, 0, 0)
    container.BackgroundTransparency = 1
    container.Parent = screenGui
    
    self.Container = container
    self.ActiveNotifications = {}
    
    return self
end

-- Play Sound Effect
function NotificationService:PlaySound(notifyType)
    local sound = Instance.new("Sound")
    sound.SoundId = self.Sounds[string.upper(notifyType)] or self.Sounds.DEFAULT
    sound.Volume = 0.5
    sound.Parent = workspace
    sound:Play()
    game.Debris:AddItem(sound, 2)
end

-- Create Single Notification
function NotificationService:CreateNotification(text, notifyType, duration)
    notifyType = string.upper(notifyType or "DEFAULT")
    duration = duration or 3
    
    local colorScheme = self.Colors[notifyType] or self.Colors.DEFAULT
    
    -- Create Notification Frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = colorScheme.Background
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    
    -- Rounded Corners
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 10)
    
    -- Subtle Gradient
    local gradient = Instance.new("UIGradient", frame)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(1, colorScheme.Background)
    })
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(1, 1)
    })
    
    -- Border Accent
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = colorScheme.Accent
    stroke.Thickness = 1.5
    stroke.Transparency = 0.5
    
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
    
    -- Progress Bar
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 0, 3)
    progressBar.Position = UDim2.new(0, 0, 1, -3)
    progressBar.BackgroundColor3 = colorScheme.Accent
    progressBar.BorderSizePixel = 0
    progressBar.Parent = frame
    
    -- Positioning
    local yOffset = #self.ActiveNotifications * 60
    frame.Position = UDim2.new(1, 0, 0, yOffset)
    frame.Parent = self.Container
    
    -- Play Sound
    self:PlaySound(notifyType)
    
    -- Tween In
    local tweenIn = TweenService:Create(frame, 
        TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Position = UDim2.new(0, 0, 0, yOffset)}
    )
    tweenIn:Play()
    
    -- Progress Bar Animation
    local progressTween = TweenService:Create(progressBar, 
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        {Size = UDim2.new(0, 0, 0, 3)}
    )
    progressTween:Play()
    
    -- Store Active Notification
    table.insert(self.ActiveNotifications, frame)
    
    -- Auto Remove
    task.delay(duration, function()
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
                    {Position = UDim2.new(0, 0, 0, (i-1) * 60)}
                )
                newPos:Play()
            end
            
            -- Destroy Frame
            frame:Destroy()
        end)
    end)
end

-- Global Notify Function
local NotifySystem = NotificationService.new()
local function notify(text, notifyType, duration)
    NotifySystem:CreateNotification(text, notifyType, duration)
end

-- Advanced Notification Methods
function NotifySystem:Queue(notifications)
    for _, notif in ipairs(notifications) do
        task.wait(0.5)
        self:CreateNotification(notif.text, notif.type, notif.duration)
    end
end

function NotifySystem:Clear()
    for _, notification in ipairs(self.ActiveNotifications) do
        notification:Destroy()
    end
    self.ActiveNotifications = {}
end

-- Expose globally
_G.notify = notify
_G.NotificationSystem = NotifySystem

return NotificationSystem
