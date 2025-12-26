-- GlowHub V4 Mobile FIXED
-- UI حلو + استخدام فعلي بدون إزعاج

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

-- DEVICE
local IS_MOBILE = UIS.TouchEnabled
local Camera = workspace.CurrentCamera
local ScreenSize = Camera.ViewportSize

-- COLORS
local MAIN = Color3.fromRGB(0,120,215)
local BG = Color3.fromRGB(20,20,20)
local TEXT = Color3.fromRGB(255,255,255)

-- LAYOUT ORDER FIX
local layoutIndex = 0
local function nextOrder()
	layoutIndex += 1
	return layoutIndex
end

-- GUI ROOT
local Gui = Instance.new("ScreenGui")
Gui.Name = "GlowHubV4"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

-- FLOATING G BUTTON (NOT OVER JUMP)
local GButton = Instance.new("TextButton")
GButton.Size = UDim2.fromOffset(48,48)
GButton.Position = UDim2.fromScale(0.85,0.55) -- بعيد عن زر القفز
GButton.Text = "G"
GButton.Font = Enum.Font.GothamBold
GButton.TextSize = 20
GButton.TextColor3 = TEXT
GButton.BackgroundColor3 = MAIN
GButton.Parent = Gui

Instance.new("UICorner",GButton).CornerRadius = UDim.new(1,0)

-- MAIN FRAME
local Frame = Instance.new("Frame")
Frame.Size = UDim2.fromOffset(300,460)
Frame.Position = UDim2.fromScale(0.5,1.2)
Frame.AnchorPoint = Vector2.new(0.5,0.5)
Frame.BackgroundColor3 = BG
Frame.Visible = false
Frame.Parent = Gui
Instance.new("UICorner",Frame).CornerRadius = UDim.new(0.05,0)

-- TOP BAR
local Top = Instance.new("TextLabel")
Top.Size = UDim2.new(1,0,0,40)
Top.Text = "🎮 GlowHub V4"
Top.TextColor3 = TEXT
Top.Font = Enum.Font.GothamBold
Top.TextSize = 18
Top.BackgroundColor3 = MAIN
Top.Parent = Frame

-- SCROLL
local Scroll = Instance.new("ScrollingFrame")
Scroll.Position = UDim2.fromOffset(0,40)
Scroll.Size = UDim2.new(1,0,1,-40)
Scroll.CanvasSize = UDim2.new()
Scroll.ScrollBarThickness = 6
Scroll.BackgroundTransparency = 1
Scroll.Parent = Frame

local List = Instance.new("UIListLayout",Scroll)
List.Padding = UDim.new(0,8)

-- AUTO CANVAS
List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Scroll.CanvasSize = UDim2.fromOffset(0,List.AbsoluteContentSize.Y + 10)
end)

-- UI BUILDERS
local function Section(txt)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(1,-20,0,40)
	f.BackgroundColor3 = Color3.fromRGB(30,30,30)
	f.LayoutOrder = nextOrder()
	Instance.new("UICorner",f).CornerRadius = UDim.new(0.2,0)

	local t = Instance.new("TextLabel",f)
	t.Size = UDim2.new(1,0,1,0)
	t.BackgroundTransparency = 1
	t.Text = txt
	t.TextColor3 = TEXT
	t.Font = Enum.Font.GothamBold
	t.TextSize = 16

	f.Parent = Scroll
end

local function Button(txt,cb)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-20,0,42)
	b.Text = txt
	b.TextColor3 = TEXT
	b.Font = Enum.Font.Gotham
	b.TextSize = 15
	b.BackgroundColor3 = Color3.fromRGB(45,45,45)
	b.LayoutOrder = nextOrder()
	Instance.new("UICorner",b).CornerRadius = UDim.new(0.15,0)

	b.MouseButton1Click:Connect(cb)
	b.Parent = Scroll
	return b
end

local function Toggle(txt,cb)
	local state = false
	local b = Button(txt.." ❌",function()
		state = not state
		b.Text = txt .. (state and " ✅" or " ❌")
		cb(state)
	end)
	return b
end

-- CHARACTER
local Char = LP.Character or LP.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local HRP = Char:WaitForChild("HumanoidRootPart")

-- MOVEMENT
Section("🏃 الحركة")

local speed = Hum.WalkSpeed

Button("➕ زيادة السرعة",function()
	speed = math.clamp(speed+5,5,200)
	Hum.WalkSpeed = speed
end)

Button("➖ تقليل السرعة",function()
	speed = math.clamp(speed-5,5,200)
	Hum.WalkSpeed = speed
end)

-- INFINITE JUMP
local jumpConn
Toggle("♾️ قفز لانهائي",function(on)
	if on then
		jumpConn = UIS.JumpRequest:Connect(function()
			Hum:ChangeState(Enum.HumanoidStateType.Jumping)
		end)
	else
		if jumpConn then jumpConn:Disconnect() jumpConn=nil end
	end
end)

-- NOCLIP
local noclipConn
Toggle("👻 نوكلب",function(on)
	if on then
		noclipConn = RunService.Stepped:Connect(function()
			for _,v in pairs(Char:GetDescendants()) do
				if v:IsA("BasePart") then v.CanCollide=false end
			end
		end)
	else
		if noclipConn then noclipConn:Disconnect() end
		for _,v in pairs(Char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide=true end
		end
	end
end)

-- FLY (MOBILE REAL)
local flyBV,flyBG,flyConn
Toggle("✈️ طيران",function(on)
	if on then
		flyBV = Instance.new("BodyVelocity",HRP)
		flyBG = Instance.new("BodyGyro",HRP)
		flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
		flyBG.MaxTorque = Vector3.new(1e5,1e5,1e5)

		flyConn = RunService.RenderStepped:Connect(function()
			flyBG.CFrame = Camera.CFrame
			flyBV.Velocity = Hum.MoveDirection*60 + Vector3.new(0,30,0)
		end)
	else
		if flyConn then flyConn:Disconnect() end
		if flyBV then flyBV:Destroy() end
		if flyBG then flyBG:Destroy() end
	end
end)

-- QUICK MENU
local quickOpen=false
Button("⚡ خيارات سريعة",function()
	StarterGui:SetCore("SendNotification",{
		Title="GlowHub",
		Text="الخيارات السريعة مدموجة بالأزرار فوق 😏",
		Duration=3
	})
end)

-- OPEN / CLOSE
local open=false
GButton.MouseButton1Click:Connect(function()
	open=not open
	Frame.Visible=true
	TweenService:Create(Frame,TweenInfo.new(0.35,Enum.EasingStyle.Back),{
		Position=open and UDim2.fromScale(0.5,0.5) or UDim2.fromScale(0.5,1.2)
	}):Play()
	if not open then
		task.delay(0.35,function() Frame.Visible=false end)
	end
end)

-- DONE
StarterGui:SetCore("SendNotification",{
	Title="GlowHub V4",
	Text="Loaded ✔️ موبايل بدون إزعاج",
	Duration=4
})
