--[[
    Roblox GUI Script - GlowHub V4 (Mobile Optimized)
    مصمم خصيصاً للهواتف مع واجهة لمس
--]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local GuiService = game:GetService("GuiService")

-- الكشف عن نوع الجهاز
local IS_MOBILE = UserInputService.TouchEnabled
local IS_TABLET = GuiService:GetScreenResolution().Y > 1200

-- إعدادات الواجهة للهاتف
local MainColor = Color3.fromRGB(0, 120, 215)
local BackgroundColor = Color3.fromRGB(20, 20, 20)
local TextColor = Color3.fromRGB(255, 255, 255)

-- أحجام متجاوبة للهاتف
local SCREEN_WIDTH = GuiService:GetScreenResolution().X
local SCREEN_HEIGHT = GuiService:GetScreenResolution().Y

-- أحجام ديناميكية تعتمد على حجم الشاشة
local function GetResponsiveSize()
    if IS_TABLET then
        return {
            ButtonSize = 60,
            FrameWidth = math.min(300, SCREEN_WIDTH * 0.8),
            FrameHeight = math.min(500, SCREEN_HEIGHT * 0.7),
            FontSize = 18,
            TitleSize = 20
        }
    elseif IS_MOBILE then
        return {
            ButtonSize = 50,
            FrameWidth = math.min(280, SCREEN_WIDTH * 0.85),
            FrameHeight = math.min(450, SCREEN_HEIGHT * 0.75),
            FontSize = 16,
            TitleSize = 18
        }
    else
        return {
            ButtonSize = 45,
            FrameWidth = 240,
            FrameHeight = 400,
            FontSize = 14,
            TitleSize = 16
        }
    end
end

local Sizes = GetResponsiveSize()

-- إنشاء الواجهة الرئيسية
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GlowHubV4_Mobile"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true  -- مهم للهواتف

-- الزر العائم الكبير للهاتف
local FloatingButton = Instance.new("ImageButton")  -- استخدام ImageButton للاستجابة الأفضل
FloatingButton.Name = "FloatingButton"
FloatingButton.Size = UDim2.new(0, Sizes.ButtonSize, 0, Sizes.ButtonSize)
FloatingButton.Position = UDim2.new(1, -Sizes.ButtonSize - 20, 1, -Sizes.ButtonSize - 20)  -- الزاوية اليمنى السفلية
FloatingButton.BackgroundColor3 = MainColor
FloatingButton.Image = ""  -- يمكن إضافة أيقونة
FloatingButton.ScaleType = Enum.ScaleType.Crop
FloatingButton.BorderSizePixel = 0
FloatingButton.ZIndex = 1000
FloatingButton.Active = true
FloatingButton.Selectable = true

-- جعل الزر دائري مع ظل
local UICorner1 = Instance.new("UICorner")
UICorner1.CornerRadius = UDim.new(1, 0)
UICorner1.Parent = FloatingButton

-- إضافة تأثير ظل للزر
local UIStroke1 = Instance.new("UIStroke")
UIStroke1.Color = Color3.fromRGB(255, 255, 255)
UIStroke1.Thickness = 3
UIStroke1.Parent = FloatingButton

-- إضافة أيقونة داخل الزر
local IconLabel = Instance.new("TextLabel")
IconLabel.Name = "Icon"
IconLabel.Size = UDim2.new(1, 0, 1, 0)
IconLabel.Position = UDim2.new(0, 0, 0, 0)
IconLabel.BackgroundTransparency = 1
IconLabel.TextColor3 = TextColor
IconLabel.Text = "G"
IconLabel.Font = Enum.Font.GothamBold
IconLabel.TextSize = Sizes.FontSize + 8
IconLabel.Parent = FloatingButton

-- تأثير اللمس للزر
local TouchEffect = Instance.new("Frame")
TouchEffect.Name = "TouchEffect"
TouchEffect.Size = UDim2.new(1, 0, 1, 0)
TouchEffect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TouchEffect.BackgroundTransparency = 0.7
TouchEffect.BorderSizePixel = 0
TouchEffect.Visible = false
TouchEffect.Parent = FloatingButton

local UICornerEffect = Instance.new("UICorner")
UICornerEffect.CornerRadius = UDim.new(1, 0)
UICornerEffect.Parent = TouchEffect

-- اللوحة الرئيسية متجاوبة
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, Sizes.FrameWidth, 0, Sizes.FrameHeight)
MainFrame.Position = UDim2.new(0.5, -Sizes.FrameWidth/2, 1, 20)  -- تبدأ من أسفل الشاشة
MainFrame.BackgroundColor3 = BackgroundColor
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ZIndex = 5
MainFrame.ClipsDescendants = true

-- جعل الحواف دائرية
local UICorner2 = Instance.new("UICorner")
UICorner2.CornerRadius = UDim.new(0.05, 0)
UICorner2.Parent = MainFrame

-- شريط العنوان للهاتف
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)  -- أعلى للهاتف
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = MainColor
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 6

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = TextColor
Title.Text = "🎮 GlowHub V4"
Title.Font = Enum.Font.GothamBold
Title.TextSize = Sizes.TitleSize
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 7
Title.Parent = TopBar

-- زر إغلاق للهاتف
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0.5, -15)
CloseButton.BackgroundTransparency = 1
CloseButton.TextColor3 = TextColor
CloseButton.Text = "✕"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 20
CloseButton.ZIndex = 7
CloseButton.Parent = TopBar

-- منطقة التمرير المعدلة للهاتف
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Name = "CommandsFrame"
ScrollingFrame.Size = UDim2.new(1, 0, 1, -45)  -- مساحة أكبر
ScrollingFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 8  -- أسمك للهاتف
ScrollingFrame.ScrollBarImageColor3 = MainColor
ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
ScrollingFrame.ZIndex = 6
ScrollingFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left  -- أفضل للهواتف اليمنى

-- تحسين التمرير للهاتف
ScrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Always
ScrollingFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
ScrollingFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"

-- قائمة UI للمحتوى
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)  -- تباعد أكبر للهاتف
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollingFrame

-- دعم السحب للهاتف
local function MakeDraggable(frame, handle)
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input == dragInput) then
            update(input)
        end
    end)
end

-- جعل العناصر قابلة للسحب
MakeDraggable(MainFrame, TopBar)
MakeDraggable(FloatingButton, FloatingButton)

-- إضافة العناصر
TopBar.Parent = MainFrame
ScrollingFrame.Parent = MainFrame
MainFrame.Parent = ScreenGui
FloatingButton.Parent = ScreenGui
ScreenGui.Parent = game.CoreGui or LocalPlayer:WaitForChild("PlayerGui")

-- تأثيرات اللمس للزر
FloatingButton.MouseButton1Down:Connect(function()
    TouchEffect.Visible = true
    TweenService:Create(TouchEffect, TweenInfo.new(0.2), {BackgroundTransparency = 0.9}):Play()
end)

FloatingButton.MouseButton1Up:Connect(function()
    TweenService:Create(TouchEffect, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    task.wait(0.2)
    TouchEffect.Visible = false
end)

-- حالة القائمة
local isMenuOpen = false
local isAnimating = false

-- أنيميشن القائمة للهاتف
local function OpenMenu()
    if isMenuOpen or isAnimating then return end
    
    isAnimating = true
    isMenuOpen = true
    
    MainFrame.Visible = true
    MainFrame.Position = UDim2.new(0.5, -Sizes.FrameWidth/2, 1, 20)
    
    -- حساب الموضع النهائي (منتصف الشاشة)
    local targetPosition = UDim2.new(
        0.5, -Sizes.FrameWidth/2,
        0.5, -Sizes.FrameHeight/2
    )
    
    local tweenInfo = TweenInfo.new(
        0.4, 
        Enum.EasingStyle.Back, 
        Enum.EasingDirection.Out,
        0, 
        false, 
        0
    )
    
    local tween = TweenService:Create(MainFrame, tweenInfo, {Position = targetPosition})
    
    tween.Completed:Connect(function()
        isAnimating = false
    end)
    
    tween:Play()
    
    -- تحريك الزر إلى الزاوية
    TweenService:Create(FloatingButton, TweenInfo.new(0.3), {
        Position = UDim2.new(1, -Sizes.ButtonSize - 10, 0, 10)
    }):Play()
end

local function CloseMenu()
    if not isMenuOpen or isAnimating then return end
    
    isAnimating = true
    isMenuOpen = false
    
    local tweenInfo = TweenInfo.new(
        0.3, 
        Enum.EasingStyle.Quad, 
        Enum.EasingDirection.In,
        0, 
        false, 
        0
    )
    
    local tween = TweenService:Create(MainFrame, tweenInfo, {
        Position = UDim2.new(0.5, -Sizes.FrameWidth/2, 1, 20)
    })
    
    tween.Completed:Connect(function()
        MainFrame.Visible = false
        isAnimating = false
    end)
    
    tween:Play()
    
    -- إرجاع الزر لمكانه
    TweenService:Create(FloatingButton, TweenInfo.new(0.3), {
        Position = UDim2.new(1, -Sizes.ButtonSize - 20, 1, -Sizes.ButtonSize - 20)
    }):Play()
end

-- تحكم بالزر العائم
FloatingButton.MouseButton1Click:Connect(function()
    if isMenuOpen then
        CloseMenu()
    else
        OpenMenu()
    end
end)

CloseButton.MouseButton1Click:Connect(CloseMenu)

-- إغلاق عند النقر خارج النافذة (لللمس)
local function SetupTouchOutsideClose()
    local touchConnections = {}
    
    local function handleTouchBegan(input)
        if isMenuOpen and input.UserInputType == Enum.UserInputType.Touch then
            local touchPos = input.Position
            local framePos = MainFrame.AbsolutePosition
            local frameSize = MainFrame.AbsoluteSize
            
            -- التحقق إذا كان اللمس خارج النافذة
            if touchPos.X < framePos.X or 
               touchPos.X > framePos.X + frameSize.X or
               touchPos.Y < framePos.Y or 
               touchPos.Y > framePos.Y + frameSize.Y then
                CloseMenu()
            end
        end
    end
    
    UserInputService.TouchStarted:Connect(handleTouchBegan)
    
    -- أيضًا للماوس (إذا كان الجهاز يدعمه)
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            handleTouchBegan(input)
        end
    end)
end

SetupTouchOutsideClose()

-- وظائف إنشاء عناصر الواجهة المعدلة للهاتف
local function CreateSection(title)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = title .. "Section"
    SectionFrame.Size = UDim2.new(1, -20, 0, 40)  -- أوسع للهاتف
    SectionFrame.Position = UDim2.new(0, 10, 0, 0)
    SectionFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SectionFrame.BorderSizePixel = 0
    SectionFrame.LayoutOrder = #ScrollingFrame:GetChildren()
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.15, 0)  -- حواف أكثر استدارة
    UICorner.Parent = SectionFrame
    
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Name = "Title"
    SectionTitle.Size = UDim2.new(1, -20, 1, 0)
    SectionTitle.Position = UDim2.new(0, 10, 0, 0)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.TextColor3 = TextColor
    SectionTitle.Text = "📱 " .. title  -- إضافة أيقونة
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextSize = Sizes.FontSize + 2
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.Parent = SectionFrame
    
    return SectionFrame
end

local function CreateButton(text, callback, icon)
    local Button = Instance.new("TextButton")
    Button.Name = text .. "Button"
    Button.Size = UDim2.new(1, -20, 0, 45)  -- أطول للهاتف
    Button.Position = UDim2.new(0, 10, 0, 0)
    Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    Button.BorderSizePixel = 0
    Button.TextColor3 = TextColor
    Button.Text = (icon or "🔘") .. " " .. text  -- إضافة أيقونة
    Button.Font = Enum.Font.Gotham
    Button.TextSize = Sizes.FontSize
    Button.TextXAlignment = Enum.TextXAlignment.Left
    Button.LayoutOrder = #ScrollingFrame:GetChildren()
    Button.AutoButtonColor = false  -- لمنع التغيير التلقائي للون
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.1, 0)
    UICorner.Parent = Button
    
    -- تأثير اللمس للزر
    local TouchOverlay = Instance.new("Frame")
    TouchOverlay.Name = "TouchOverlay"
    TouchOverlay.Size = UDim2.new(1, 0, 1, 0)
    TouchOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TouchOverlay.BackgroundTransparency = 1
    TouchOverlay.BorderSizePixel = 0
    TouchOverlay.ZIndex = 2
    TouchOverlay.Parent = Button
    
    local UICornerOverlay = Instance.new("UICorner")
    UICornerOverlay.CornerRadius = UDim.new(0.1, 0)
    UICornerOverlay.Parent = TouchOverlay
    
    -- تفاعلات اللمس
    Button.MouseButton1Down:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
        TweenService:Create(TouchOverlay, TweenInfo.new(0.1), {BackgroundTransparency = 0.8}):Play()
    end)
    
    Button.MouseButton1Up:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        TweenService:Create(TouchOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        callback()
    end)
    
    Button.MouseEnter:Connect(function()
        if not UserInputService.TouchEnabled then
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
        end
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
        TweenService:Create(TouchOverlay, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    end)
    
    return Button
end

local function CreateToggle(name, defaultValue, callback, icon)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "ToggleFrame"
    ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
    ToggleFrame.Position = UDim2.new(0, 10, 0, 0)
    ToggleFrame.BackgroundTransparency = 1
    ToggleFrame.LayoutOrder = #ScrollingFrame:GetChildren()
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0, 0, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.TextColor3 = TextColor
    TitleLabel.Text = (icon or "⚙️") .. " " .. name
    TitleLabel.Font = Enum.Font.Gotham
    TitleLabel.TextSize = Sizes.FontSize
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "ToggleButton"
    ToggleButton.Size = UDim2.new(0, 60, 0, 30)  -- أكبر للهاتف
    ToggleButton.Position = UDim2.new(1, -60, 0.5, -15)
    ToggleButton.BackgroundColor3 = defaultValue and MainColor or Color3.fromRGB(60, 60, 60)
    ToggleButton.Text = ""
    ToggleButton.BorderSizePixel = 0
    ToggleButton.AutoButtonColor = false
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.5, 0)
    UICorner.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Name = "ToggleCircle"
    ToggleCircle.Size = UDim2.new(0, 24, 0, 24)  -- أكبر للهاتف
    ToggleCircle.Position = defaultValue and UDim2.new(1, -27, 0.5, -12) or UDim2.new(0, 3, 0.5, -12)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleCircle.BorderSizePixel = 0
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0.5, 0)
    UICorner2.Parent = ToggleCircle
    
    ToggleCircle.Parent = ToggleButton
    ToggleButton.Parent = ToggleFrame
    
    local toggled = defaultValue
    
    -- تأثير اللمس للتبديل
    ToggleButton.MouseButton1Down:Connect(function()
        TweenService:Create(ToggleButton, TweenInfo.new(0.1), {
            BackgroundColor3 = toggled and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(0, 100, 180)
        }):Play()
    end)
    
    ToggleButton.MouseButton1Up:Connect(function()
        toggled = not toggled
        
        if toggled then
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = MainColor}):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -27, 0.5, -12)}):Play()
        else
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -12)}):Play()
        end
        
        callback(toggled)
    end)
    
    return ToggleFrame
end

-- ======== إضافة الميزات ========

-- انتظر تحميل الشخصية
repeat task.wait() until LocalPlayer.Character
local Character = LocalPlayer.Character
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- قسم الحركة
local MovementSection = CreateSection("الحركة")
MovementSection.Parent = ScrollingFrame

-- سرعة الحركة (مبسطة للهاتف)
local walkSpeed = Humanoid.WalkSpeed
local SpeedButton = CreateButton("السرعة: " .. walkSpeed, function()
    walkSpeed = walkSpeed + 10
    if walkSpeed > 200 then walkSpeed = 16 end
    Humanoid.WalkSpeed = walkSpeed
    SpeedButton.Text = "🏃‍♂️ السرعة: " .. walkSpeed
end, "🏃‍♂️")
SpeedButton.Parent = ScrollingFrame

-- قوة القفز
local jumpPower = Humanoid.JumpPower
local JumpButton = CreateButton("القفز: " .. jumpPower, function()
    jumpPower = jumpPower + 10
    if jumpPower > 200 then jumpPower = 50 end
    Humanoid.JumpPower = jumpPower
    JumpButton.Text = "🦘 القفز: " .. jumpPower
end, "🦘")
JumpButton.Parent = ScrollingFrame

-- تحديث مستمر للقيم
RunService.RenderStepped:Connect(function()
    if Humanoid then
        Humanoid.WalkSpeed = walkSpeed
        Humanoid.JumpPower = jumpPower
    end
end)

-- القفز اللانهائي
local infiniteJumpActive = false
local InfiniteJumpToggle = CreateToggle("القفز اللانهائي", false, function(toggled)
    infiniteJumpActive = toggled
    if toggled then
        UserInputService.JumpRequest:Connect(function()
            if Humanoid and infiniteJumpActive then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end, "♾️")
InfiniteJumpToggle.Parent = ScrollingFrame

-- قسم المهارات
local SkillsSection = CreateSection("المهارات")
SkillsSection.Parent = ScrollingFrame

-- Noclip
local noclipActive = false
local noclipConnection
local NoclipToggle = CreateToggle("النوكلب", false, function(toggled)
    noclipActive = toggled
    if toggled then
        noclipConnection = RunService.Stepped:Connect(function()
            if Character and noclipActive then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
end, "👻")
NoclipToggle.Parent = ScrollingFrame

-- الطيران (مبسط للهاتف)
local flyActive = false
local flyBodyGyro, flyBodyVelocity
local FlyToggle = CreateToggle("الطيران", false, function(toggled)
    flyActive = toggled
    
    if toggled then
        flyBodyGyro = Instance.new("BodyGyro")
        flyBodyVelocity = Instance.new("BodyVelocity")
        
        flyBodyGyro.P = 10000
        flyBodyGyro.D = 1000
        flyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        
        if HumanoidRootPart then
            flyBodyGyro.Parent = HumanoidRootPart
            flyBodyVelocity.Parent = HumanoidRootPart
        end
        
        -- تحكم مبسط للهاتف
        RunService.RenderStepped:Connect(function()
            if not flyActive or not HumanoidRootPart then return end
            
            local camera = workspace.CurrentCamera
            if camera then
                flyBodyGyro.CFrame = camera.CFrame
                
                -- حركة مبسطة
                local move = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    move = move + camera.CFrame.LookVector * 50
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    move = move - camera.CFrame.LookVector * 50
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    move = move + Vector3.new(0, 50, 0)
                end
                
                flyBodyVelocity.Velocity = move
            end
        end)
    else
        if flyBodyGyro then flyBodyGyro:Destroy() end
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
    end
end, "✈️")
FlyToggle.Parent = ScrollingFrame

-- قسم اللاعبين
local PlayersSection = CreateSection("اللاعبين")
PlayersSection.Parent = ScrollingFrame

-- قائمة مبسطة للهاتف
local selectedPlayer = nil
local function CreatePlayerButton(player)
    local PlayerButton = Instance.new("TextButton")
    PlayerButton.Name = player.Name .. "Btn"
    PlayerButton.Size = UDim2.new(1, -20, 0, 40)
    PlayerButton.Position = UDim2.new(0, 10, 0, 0)
    PlayerButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    PlayerButton.TextColor3 = TextColor
    PlayerButton.Text = "👤 " .. player.Name
    PlayerButton.Font = Enum.Font.Gotham
    PlayerButton.TextSize = Sizes.FontSize
    PlayerButton.TextXAlignment = Enum.TextXAlignment.Left
    PlayerButton.AutoButtonColor = false
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0.1, 0)
    UICorner.Parent = PlayerButton
    
    PlayerButton.MouseButton1Click:Connect(function()
        selectedPlayer = player
        -- إلغاء تحديد الكل
        for _, btn in pairs(ScrollingFrame:GetChildren()) do
            if btn:IsA("TextButton") and btn.Name:find("Btn") then
                TweenService:Create(btn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                }):Play()
            end
        end
        -- تحديد الزر الحالي
        TweenService:Create(PlayerButton, TweenInfo.new(0.2), {
            BackgroundColor3 = MainColor
        }):Play()
    end)
    
    return PlayerButton
end

-- تحديث قائمة اللاعبين
local function UpdatePlayersList()
    for _, child in pairs(ScrollingFrame:GetChildren()) do
        if child.Name:find("Btn") then
            child:Destroy()
        end
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = CreatePlayerButton(player)
            btn.LayoutOrder = #ScrollingFrame:GetChildren()
            btn.Parent = ScrollingFrame
        end
    end
end

Players.PlayerAdded:Connect(UpdatePlayersList)
Players.PlayerRemoving:Connect(UpdatePlayersList)
UpdatePlayersList()

-- تيليبورت للاعب
local TeleportButton = CreateButton("تيليبورت للاعب", function()
    if selectedPlayer and selectedPlayer.Character then
        local target = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        if target and HumanoidRootPart then
            HumanoidRootPart.CFrame = target.CFrame
            StarterGui:SetCore("SendNotification", {
                Title = "GlowHub",
                Text = "تم التليبيورت إلى " .. selectedPlayer.Name,
                Duration = 3
            })
        end
    end
end, "📍")
TeleportButton.Parent = ScrollingFrame

-- نسخ المظهر
local CopySkinButton = CreateButton("نسخ المظهر", function()
    if selectedPlayer and selectedPlayer.Character then
        -- نسخ بسيط للمظهر
        local targetChar = selectedPlayer.Character
        for _, item in pairs(targetChar:GetChildren()) do
            if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") then
                local clone = item:Clone()
                clone.Parent = Character
            end
        end
        StarterGui:SetCore("SendNotification", {
            Title = "GlowHub",
            Text = "تم نسخ مظهر " .. selectedPlayer.Name,
            Duration = 3
        })
    end
end, "👕")
CopySkinButton.Parent = ScrollingFrame

-- قسم الـ ESP
local ESPSection = CreateSection("الرؤية")
ESPSection.Parent = ScrollingFrame

-- ESP مبسط للهاتف
local espActive = false
local espHighlights = {}
local ESPToggle = CreateToggle("رؤية الجميع (ESP)", false, function(toggled)
    espActive = toggled
    
    if toggled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESP_" .. player.Name
                highlight.FillColor = Color3.fromRGB(255, 50, 50)
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.OutlineTransparency = 0
                highlight.Adornee = player.Character
                highlight.Parent = player.Character
                
                espHighlights[player] = highlight
                
                -- إضافة اسم
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "Name_" .. player.Name
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Adornee = player.Character:WaitForChild("Head")
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = player.Name .. " 👁️"
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
                label.Font = Enum.Font.GothamBold
                label.TextSize = 14
                label.TextStrokeTransparency = 0
                label.Parent = billboard
                
                billboard.Parent = player.Character
            end
        end
    else
        -- إزالة الـ ESP
        for player, highlight in pairs(espHighlights) do
            if highlight then highlight:Destroy() end
            if player.Character then
                local billboard = player.Character:FindFirstChild("Name_" .. player.Name)
                if billboard then billboard:Destroy() end
            end
        end
        espHighlights = {}
    end
end, "👁️")
ESPToggle.Parent = ScrollingFrame

-- زر تنظيف الـ ESP
local ClearESPButton = CreateButton("إزالة الـ ESP", function()
    espActive = false
    for player, highlight in pairs(espHighlights) do
        if highlight then highlight:Destroy() end
    end
    espHighlights = {}
    
    -- إزالة من جميع الشخصيات
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            for _, obj in pairs(player.Character:GetChildren()) do
                if obj.Name:find("ESP_") or obj.Name:find("Name_") then
                    obj:Destroy()
                end
            end
        end
    end
    
    StarterGui:SetCore("SendNotification", {
        Title = "GlowHub",
        Text = "تم إزالة جميع تأثيرات ESP",
        Duration = 3
    })
end, "🗑️")
ClearESPButton.Parent = ScrollingFrame

-- قسم الأدوات
local ToolsSection = CreateSection("الأدوات")
ToolsSection.Parent = ScrollingFrame

-- أدوات سريعة
local fastToolsActive = false
local FastToolsToggle = CreateToggle("أدوات سريعة", false, function(toggled)
    fastToolsActive = toggled
    if toggled then
        -- جعل جميع الأدوات سريعة
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.RequiresHandle = false
            end
        end
        StarterGui:SetCore("SendNotification", {
            Title = "GlowHub",
            Text = "تم تفعيل الأدوات السريعة",
            Duration = 3
        })
    end
end, "⚡")
FastToolsToggle.Parent = ScrollingFrame

-- زر إغلاق السكربت
local CloseScriptButton = CreateButton("إغلاق السكربت", function()
    ScreenGui:Destroy()
    StarterGui:SetCore("SendNotification", {
        Title = "GlowHub",
        Text = "تم إغلاق السكربت",
        Duration = 3
    })
end, "❌")
CloseScriptButton.Parent = ScrollingFrame

-- تحديث حجم منطقة التمرير تلقائياً
local function UpdateScrollingSize()
    local totalHeight = 0
    for _, child in pairs(ScrollingFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextButton") then
            totalHeight = totalHeight + child.AbsoluteSize.Y + 8
        end
    end
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
end

UpdateScrollingSize()
ScrollingFrame.ChildAdded:Connect(UpdateScrollingSize)
ScrollingFrame.ChildRemoved:Connect(UpdateScrollingSize)

-- تحسين للأجهزة المختلفة
if IS_MOBILE then
    -- إضافة زر شريط الأدوات للهاتف
    local ToolbarButton = Instance.new("TextButton")
    ToolbarButton.Name = "ToolbarToggle"
    ToolbarButton.Size = UDim2.new(0, 100, 0, 30)
    ToolbarButton.Position = UDim2.new(0.5, -50, 1, -40)
    ToolbarButton.BackgroundColor3 = MainColor
    ToolbarButton.TextColor3 = TextColor
    ToolbarButton.Text = "🔧 أدوات سريعة"
    ToolbarButton.Font = Enum.Font.GothamBold
    ToolbarButton.TextSize = 12
    ToolbarButton.BorderSizePixel = 0
    ToolbarButton.ZIndex = 999
    
    local UICornerTB = Instance.new("UICorner")
    UICornerTB.CornerRadius = UDim.new(0.2, 0)
    UICornerTB.Parent = ToolbarButton
    
    ToolbarButton.MouseButton1Click:Connect(function()
        -- فتح قائمة مختصرة
        local quickMenu = Instance.new("Frame")
        quickMenu.Name = "QuickMenu"
        quickMenu.Size = UDim2.new(0, 150, 0, 200)
        quickMenu.Position = UDim2.new(0, 10, 1, -210)
        quickMenu.BackgroundColor3 = BackgroundColor
        quickMenu.BorderSizePixel = 0
        quickMenu.ZIndex = 1000
        
        local UICornerQM = Instance.new("UICorner")
        UICornerQM.CornerRadius = UDim.new(0.1, 0)
        UICornerQM.Parent = quickMenu
        
        -- إضافة أزرار سريعة
        local quickButtons = {
            {"النوكلب", function() 
                noclipActive = not noclipActive
                StarterGui:SetCore("SendNotification", {
                    Title = "GlowHub",
                    Text = "النوكلب: " .. (noclipActive and "مفعل" or "معطل"),
                    Duration = 2
                })
            end},
            {"الطيران", function() 
                flyActive = not flyActive
                StarterGui:SetCore("SendNotification", {
                    Title = "GlowHub",
                    Text = "الطيران: " .. (flyActive and "مفعل" or "معطل"),
                    Duration = 2
                })
            end},
            {"ESP", function()
                espActive = not espActive
                StarterGui:SetCore("SendNotification", {
                    Title = "GlowHub",
                    Text = "ESP: " .. (espActive and "مفعل" or "معطل"),
                    Duration = 2
                })
            end}
        }
        
        local yPos = 10
        for _, btnData in pairs(quickButtons) do
            local qBtn = Instance.new("TextButton")
            qBtn.Size = UDim2.new(1, -20, 0, 40)
            qBtn.Position = UDim2.new(0, 10, 0, yPos)
            qBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            qBtn.TextColor3 = TextColor
            qBtn.Text = btnData[1]
            qBtn.Font = Enum.Font.Gotham
            qBtn.TextSize = 14
            qBtn.Parent = quickMenu
            
            qBtn.MouseButton1Click:Connect(function()
                btnData[2]()
                quickMenu:Destroy()
            end)
            
            yPos = yPos + 50
        end
        
        quickMenu.Parent = ScreenGui
        
        -- إغلاق التلقائي
        task.delay(5, function()
            if quickMenu and quickMenu.Parent then
                quickMenu:Destroy()
            end
        end)
    end)
    
    ToolbarButton.Parent = ScreenGui
end

-- رسالة بدء التشغيل
task.wait(1)
StarterGui:SetCore("SendNotification", {
    Title = "🎮 GlowHub V4 Mobile",
    Text = IS_MOBILE and "تم التحميل للهاتف! اضغط على الزر الأزرق" or "تم التحميل! اضغط على زر G",
    Duration = 5,
    Icon = "rbxassetid://3926305904",
    Button1 = "حسناً"
})

print("✅ GlowHub V4 Mobile Loaded Successfully!")
print("📱 Device Type:", IS_MOBILE and "Mobile/Touch" or "Desktop")
print("📐 Screen Size:", SCREEN_WIDTH, "x", SCREEN_HEIGHT)
