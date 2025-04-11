-- notify.lua
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local NotificationService = {}
NotificationService.__index = NotificationService

NotificationService.Colors = {
    DEFAULT = { Background=Color3.fromRGB(60,60,60), Text=Color3.fromRGB(230,230,230), ProgressBar=Color3.fromRGB(150,150,150) },
    SUCCESS = { Background=Color3.fromRGB(40,180,40), Text=Color3.fromRGB(255,255,255), ProgressBar=Color3.fromRGB(100,255,100) },
    WARNING = { Background=Color3.fromRGB(255,160,0), Text=Color3.fromRGB(255,255,255), ProgressBar=Color3.fromRGB(255,220,100) },
    ERROR   = { Background=Color3.fromRGB(230,50,50), Text=Color3.fromRGB(255,255,255), ProgressBar=Color3.fromRGB(255,150,150) },
    INFO    = { Background=Color3.fromRGB(50,140,255), Text=Color3.fromRGB(255,255,255), ProgressBar=Color3.fromRGB(150,200,255) },
}

function NotificationService.new(config)
    local self = setmetatable({}, NotificationService)
    self.Config = {
        MaxNotifications    = (config and config.MaxNotifications) or 5,
        Width               = (config and config.Width) or 300,
        Position            = (config and config.Position) or UDim2.new(1,-20,0,20),
        NotificationHeight  = (config and config.NotificationHeight) or 50,
        Spacing             = (config and config.Spacing) or 10,
    }

    local player = Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    screenGui.Name = "UltimateNotify"
    screenGui.ResetOnSpawn = false

    local container = Instance.new("Frame", screenGui)
    container.Name = "NotificationContainer"
    container.AnchorPoint = Vector2.new(1, 0)
    container.Position = self.Config.Position
    container.Size = UDim2.new(0, self.Config.Width, 0, 0)
    container.BackgroundTransparency = 1
    container.ClipsDescendants = true
    container.AutomaticSize = Enum.AutomaticSize.Y

    self.Container = container
    self.ActiveNotifications = {}
    return self
end

function NotificationService:CreateNotification(params)
    local text = params.text or "Notification"
    local t = string.upper(params.type or "DEFAULT")
    local dur = params.duration or 3
    local scheme = self.Colors[t] or self.Colors.DEFAULT

    if #self.ActiveNotifications >= self.Config.MaxNotifications then
        table.remove(self.ActiveNotifications,1):Destroy()
    end

    local frame = Instance.new("Frame", self.Container)
    frame.AnchorPoint = Vector2.new(1, 0)
    frame.Size = UDim2.new(1, 0, 0, self.Config.NotificationHeight)
    frame.Position = UDim2.new(1, 0, 0, #self.ActiveNotifications*(self.Config.NotificationHeight+self.Config.Spacing))
    frame.BackgroundColor3 = scheme.Background
    frame.BackgroundTransparency = 0.2
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

    local progBg = Instance.new("Frame", frame)
    progBg.Size = UDim2.new(1,0,0,5)
    progBg.Position = UDim2.new(0,0,1,-5)
    progBg.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Instance.new("UICorner", progBg).CornerRadius = UDim.new(1,0)
    local prog = Instance.new("Frame", progBg)
    prog.Size = UDim2.new(1,0,1,0)
    prog.BackgroundColor3 = scheme.ProgressBar
    Instance.new("UICorner", prog).CornerRadius = UDim.new(1,0)

    local lbl = Instance.new("TextLabel", frame)
    lbl.Text = text
    lbl.Font = Enum.Font.GothamBold
    lbl.TextColor3 = scheme.Text
    lbl.TextSize = 16
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1,-20,1,0)
    lbl.Position = UDim2.new(0,10,0,0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    table.insert(self.ActiveNotifications, frame)

    local start = tick()
    local conn
    conn = RunService.Heartbeat:Connect(function()
        local p = math.min((tick()-start)/dur,1)
        prog.Size = UDim2.new(1-p,0,1,0)
        if p>=1 then
            conn:Disconnect()
            TweenService:Create(frame, TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.In),
                {Position=UDim2.new(1,0,0,frame.Position.Y.Offset)}
            ):Play()
            for i,f in ipairs(self.ActiveNotifications) do
                if f==frame then table.remove(self.ActiveNotifications,i); break end
            end
        end
    end)

    TweenService:Create(frame, TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
        {Position=UDim2.new(0,0,0,frame.Position.Y.Offset)}
    ):Play()

    return frame
end

-- สำหรับ loadstring: return ฟังก์ชัน notify
return function(config)
    local svc = NotificationService.new(config)
    local function notify(p)
        if type(p)=="string" then p={text=p} end
        svc:CreateNotification(p)
    end
    _G.notify = notify
    return notify
end
