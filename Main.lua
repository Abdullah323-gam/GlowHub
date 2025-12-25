local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("GlowHubUltra") then PlayerGui.GlowHubUltra:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "GlowHubUltra"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 200, 0, 320)
Main.Position = UDim2.new(0.1, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "Glow Hub - Full"
Title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Title.TextColor3 = Color3.new(1, 1, 1)

local Speed = Instance.new("TextBox", Main)
Speed.Size = UDim2.new(0.9, 0, 0, 30)
Speed.Position = UDim2.new(0.05, 0, 0.15, 0)
Speed.PlaceholderText = "Speed"
Speed.FocusLost:Connect(function() Player.Character.Humanoid.WalkSpeed = tonumber(Speed.Text) or 16 end)

local FlyBtn = Instance.new("TextButton", Main)
FlyBtn.Size = UDim2.new(0.9, 0, 0, 35)
FlyBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
FlyBtn.Text = "Fly"
FlyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlyBtn.TextColor3 = Color3.new(1, 1, 1)
FlyBtn.MouseButton1Click:Connect(function() 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.lua"))() 
end)

local EspBtn = Instance.new("TextButton", Main)
EspBtn.Size = UDim2.new(0.9, 0, 0, 35)
EspBtn.Position = UDim2.new(0.05, 0, 0.45, 0)
EspBtn.Text = "ESP"
EspBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
EspBtn.TextColor3 = Color3.new(1, 1, 1)
EspBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ic3w0lf22/UnnamedESP/master/Source.lua'))()
end)

local FlingBtn = Instance.new("TextButton", Main)
FlingBtn.Size = UDim2.new(0.9, 0, 0, 35)
FlingBtn.Position = UDim2.new(0.05, 0, 0.6, 0)
FlingBtn.Text = "Walk Fling"
FlingBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
FlingBtn.TextColor3 = Color3.new(1, 1, 1)
FlingBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/0866/Fling/main/Fling.lua"))()
end)

local IyBtn = Instance.new("TextButton", Main)
IyBtn.Size = UDim2.new(0.9, 0, 0, 35)
IyBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
IyBtn.Text = "Infinite Yield"
IyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
IyBtn.TextColor3 = Color3.new(1, 1, 1)
IyBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source"))()
end)
