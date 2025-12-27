-- 1. إعداد الواجهة (GUI)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MiniSpy"
screenGui.Parent = game.CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 300)
mainFrame.Position = UDim2.new(0.5, -125, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = true -- لجعلها قابلة للسحب في الهاتف
mainFrame.Parent = screenGui

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 0.9, 0)
scroll.Position = UDim2.new(0, 0, 0.1, 0)
scroll.CanvasSize = UDim2.new(0, 0, 5, 0)
scroll.Parent = mainFrame

local layout = Instance.new("UIListLayout")
layout.Parent = scroll

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0.1, 0)
title.Text = "جاسوس الأوامر - اضغط واسحب"
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.new(1, 1, 1)
title.Parent = mainFrame

-- 2. دالة لإضافة أمر جديد للقائمة
local function addLog(remoteName, remotePath)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 0.5
    frame.Parent = scroll

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Text = remoteName
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextScaled = true
    label.Parent = frame

    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0.3, 0, 1, 0)
    copyBtn.Position = UDim2.new(0.7, 0, 0, 0)
    copyBtn.Text = "Copy"
    copyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    copyBtn.Parent = frame

    -- ميزة النسخ
    copyBtn.MouseButton1Click:Connect(function()
        setclipboard(remotePath) -- أمر النسخ الخاص بأرسيوس
        copyBtn.Text = "Copied!"
        wait(1)
        copyBtn.Text = "Copy"
    end)

    -- ميزة الاختفاء بعد 10 ثوانٍ
    game:GetService("Debris"):AddItem(frame, 10)
end

-- 3. المحرك (الجاسوس)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" or method == "InvokeServer" then
        -- إضافة الأمر للقائمة
        addLog(self.Name, "game." .. self:GetFullName() .. ":FireServer()")
    end
    return oldNamecall(self, ...)
end)
