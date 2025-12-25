local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("AbdullahGlow") then PlayerGui.AbdullahGlow:Destroy() end

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.Name = "AbdullahGlow"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 180, 0, 220)
Main.Position = UDim2.new(0.1, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "Glow Hub - عبدالله"
Title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Title.TextColor3 = Color3.new(1, 1, 1)

local Speed = Instance.new("TextBox", Main)
Speed.Size = UDim2.new(0.8, 0, 0, 30)
Speed.Position = UDim2.new(0.1, 0, 0.25, 0)
Speed.PlaceholderText = "السرعة"
Speed.FocusLost:Connect(function() 
    if Player.Character then Player.Character.Humanoid.WalkSpeed = tonumber(Speed.Text) or 16 end 
end)

local Scan = Instance.new("TextButton", Main)
Scan.Size = UDim2.new(0.8, 0, 0, 40)
Scan.Position = UDim2.new(0.1, 0, 0.55, 0)
Scan.Text = "كشف حقائب اللاعبين"
Scan.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Scan.TextColor3 = Color3.new(1, 1, 1)

Scan.MouseButton1Click:Connect(function()
    local msg = "الأغراض:\n"
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= Player then
            msg = msg .. "[" .. p.DisplayName .. "]: "
            local items = {}
            for _, i in pairs(p.Backpack:GetChildren()) do table.insert(items, i.Name) end
            msg = msg .. (#items > 0 and table.concat(items, ", ") or "فارغ") .. "\n"
        end
    end
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "كاشف الحقيبة", Text = msg, Duration = 6})
end)
