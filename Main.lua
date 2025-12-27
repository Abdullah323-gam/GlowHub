-- [ إضافة المتغيرات الجديدة في بداية السكربت ]
local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- (نفس كود الواجهة والسحب السابق...)
-- [ سأركز هنا على إضافة القدرات الجديدة داخل الـ Scroll ]

-- 1. الرجوع من الموت (Backtrack / Life Saver)
-- يحفظ مكانك إذا قل دمك عن 25% ويرجعك له بعد 5 ثوانٍ
createToggle("💀 الرجوع من الموت", 220, function(state)
    _G.AntiDeath = state
    task.spawn(function()
        local lastSafePos = nil
        while _G.AntiDeath do
            local char = Player.Character
            local hum = char and char:FindFirstChild("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if hum and hrp then
                -- إذا كان الدم منخفضاً (أقل من 30) ولم يتم حفظ الموقع بعد
                if hum.Health > 0 and hum.Health < 30 and not lastSafePos then
                    lastSafePos = hrp.CFrame
                    print("تم حفظ الموقع! العودة بعد 5 ثوانٍ...")
                    task.wait(5)
                    if hrp and _G.AntiDeath then
                        hrp.CFrame = lastSafePos
                        lastSafePos = nil -- إعادة التعيين
                    end
                end
            end
            task.wait(0.5)
        end
    end)
end)

-- 2. ESP الخطوط (Outline ESP)
-- يرسم خطاً حول جسد اللاعب (أفضل من المربع)
createToggle("🌈 ESP خطوط الجسم", 260, function(state)
    _G.ESPHighlight = state
    local function applyESP(p)
        if p ~= Player then
            p.CharacterAdded:Connect(function(char)
                if _G.ESPHighlight then
                    local h = Instance.new("Highlight", char)
                    h.FillTransparency = 1 -- شفاف من الداخل
                    h.OutlineColor = Color3.fromRGB(0, 255, 150) -- لون الخط
                    h.OutlineTransparency = 0
                end
            end)
            if p.Character and _G.ESPHighlight then
                local h = Instance.new("Highlight", p.Character)
                h.FillTransparency = 1
                h.OutlineColor = Color3.fromRGB(0, 255, 150)
            end
        end
    end

    if state then
        for _, v in pairs(game.Players:GetPlayers()) do applyESP(v) end
    else
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character:FindFirstChildOfClass("Highlight") then
                v.Character:FindFirstChildOfClass("Highlight"):Destroy()
            end
        end
    end
end)

-- 3. ESP Noob (كاشف المختفين والاتجاه)
-- يصنع جسد نوب وهمي فوق اللاعب لتعرف مكان نظره
createToggle("🤖 ESP نوب (كاشف الاتجاه)", 300, function(state)
    _G.NoobESP = state
    task.spawn(function()
        while _G.NoobESP do
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= Player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local head = v.Character:FindFirstChild("Head")
                    if head and not v.Character:FindFirstChild("DirectionNoob") then
                        -- إنشاء جسد نوب صغير للتوضيح
                        local noob = Instance.new("Part", v.Character)
                        noob.Name = "DirectionNoob"
                        noob.Size = Vector3.new(2, 2, 1)
                        noob.Transparency = 0.5
                        noob.Color = Color3.new(1, 1, 0)
                        noob.CanCollide = false
                        noob.Massless = true
                        local mesh = Instance.new("SpecialMesh", noob)
                        mesh.MeshId = "rbxassetid://430260431" -- شكل رأس نوب
                        mesh.Scale = Vector3.new(1.2, 1.2, 1.2)
                    elseif v.Character:FindFirstChild("DirectionNoob") then
                        v.Character.DirectionNoob.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 4, 0)
                    end
                end
            end
            task.wait()
        end
        -- تنظيف عند الإغلاق
        if not state then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("DirectionNoob") then
                    v.Character.DirectionNoob:Destroy()
                end
            end
        end
    end)
end)

-- تحديث حجم التمرير ليتناسب مع القدرات الجديدة
Scroll.CanvasSize = UDim2.new(0, 0, 0, 450)
