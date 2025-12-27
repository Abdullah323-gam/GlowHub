-- [[ Professional Expert Script - 2025 Update ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- إنشاء الواجهة بنظام 2025
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ExpertHub_2025"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 320)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- 
-- وظيفة التحريك اليدوي (بديل Draggable المحذوف)
local dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragStart = nil end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragStart then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- نظام الأزرار المتطور
local function AddFeature(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Text = name .. " [OFF]"
    btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    btn.Parent = MainFrame
    -- تنسيق بسيط للأزرار
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.Text = active and name .. " [ON ✓]" or name .. " [OFF X]"
        btn.BackgroundColor3 = active and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(180, 50, 50)
        callback(active)
    end)
    -- وضع تلقائي للأزرار تحت بعضها
    local UIList = MainFrame:FindFirstChild("UIList") or Instance.new("UIListLayout", MainFrame)
    UIList.Padding = UDim.new(0, 5)
    UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
end

---------------------------------------
-- تنفيذ الميزات بمعايير 2025
---------------------------------------

-- 1. ميزة WalkFling (استخدام AssemblyLinearVelocity)
local flingPart
AddFeature("WalkFling", function(state)
    if state then
        flingPart = RunService.Heartbeat:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(1000000, 1000000, 1000000)
                task.wait(0.1)
                char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        if flingPart then flingPart:Disconnect() end
    end
end)

-- 2. ميزة الطيران (بسيطة ومستقرة)
local flyState = false
AddFeature("Fly Mode", function(state)
    flyState = state
    task.spawn(function()
        local char = LocalPlayer.Character
        local hrp = char:WaitForChild("HumanoidRootPart")
        while flyState do
            hrp.AssemblyLinearVelocity = workspace.CurrentCamera.CFrame.LookVector * 100
            task.wait()
        end
    end)
end)

-- 3. ميزة نسخ الملابس (Character Swap)
AddFeature("Copy Clothes", function()
    local targetName = "PlayerNameHere" -- يمكنك تعديل هذا ليأخذ اسم لاعب محدد
    for _, target in pairs(Players:GetPlayers()) do
        if target ~= LocalPlayer and target.Character then
            -- مسح الحالي
            for _, v in pairs(LocalPlayer.Character:GetChildren()) do
                if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") then v:Destroy() end
            end
            -- نسخ الجديد
            for _, v in pairs(target.Character:GetChildren()) do
                if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") then v:Clone().Parent = LocalPlayer.Character end
            end
            break
        end
    end
end)

print("تم تحديث السكربت لمعايير 2025!")
