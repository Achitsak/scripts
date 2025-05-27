repeat task.wait() until game:Loaded()

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui")

screenGui.Name = "ImageDisplayGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- สร้าง ImageLabel
local imageLabel = Instance.new("ImageLabel")
imageLabel.Size = UDim2.new(1, 0, 0.6, 0) -- ขนาดเทียบกับจอ
imageLabel.Position = UDim2.new(0.5, 0, 0.5, 0) -- กลางจอ
imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
imageLabel.BackgroundTransparency = 1
imageLabel.Image = "rbxassetid://101427454514001" -- AssetId รูป
imageLabel.ScaleType = Enum.ScaleType.Fit -- ป้องกันภาพขยายเกินกรอบ
imageLabel.Parent = screenGui

-- เพิ่ม UIAspectRatioConstraint เพื่อรักษาอัตราส่วนของภาพ
local aspect = Instance.new("UIAspectRatioConstraint")
aspect.AspectRatio = 1 -- ปรับเป็น 1:1 หรือเปลี่ยนตามภาพจริง (เช่น 16/9)
aspect.Parent = imageLabel

-- ลบหลังจาก 2.5 วิ
task.delay(3, function()
	screenGui:Destroy()
end)
