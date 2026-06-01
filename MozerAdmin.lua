--[[
    █▀▄▀█ █▀▀█ ▀█▀​ █▀▀ █▀▀█ 　 █▀▀█ █▀▀▄ █▀▄▀█ ▀█▀ █▀▀▄
    █░▀░█ █░░█ ░█░ █▀▀ █▄▄▀ 　 █▄▄█ █░░█ █░▀░█ ░█░ █░░█
    ▀░░░▀ ▀▀▀▀ ▀▀▀ ▀▀▀ ▀░▀▀ 　 ▀░░▀ ▀▀▀░ ▀░░░▀ ▀▀▀ ▀░░▀
    V3 - THE ARCHITECT EDITION (ULTIMATE ANATOMY TOOL)
    Optimized for Delta / Mobile / Extreme Precision
]]

local MozerHub = {
    Version = "3.0.0",
    SelectedObject = nil,
    SpyActive = false,
    XrayActive = false,
    FreezeMap = false,
    SavedRemotes = {}
}

-- [ الخدمات الأساسية ]
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local RS = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Mouse = LP:GetMouse()

-- [ نظام الواجهة المتطور ]
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "Mozer_Architect"
ScreenGui.ResetOnSpawn = false

-- إنشاء الإطار الرئيسي بنظام Modular
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 650, 0, 420)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- إضافة لمعان (Glow) خلفي
local Shadow = Instance.new("ImageLabel", MainFrame)
Shadow.Size = UDim2.new(1, 40, 1, 40)
Shadow.Position = UDim2.new(0, -20, 0, -20)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217" -- Shadow Asset
Shadow.ImageColor3 = Color3.fromRGB(0, 255, 150)
Shadow.ZIndex = 0

-- [ نظام السحب المتطور للجوال ]
local function MakeDraggable(UI)
    local Dragging, DragInput, DragStart, StartPos
    UI.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true; DragStart = input.Position; StartPos = UI.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then Dragging = false end end)
        end
    end)
    UI.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then DragInput = input end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            UI.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
end
MakeDraggable(MainFrame)

-- [ أجزاء الواجهة ]
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 170, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Instance.new("UICorner", Sidebar)

local ContentArea = Instance.new("Frame", MainFrame)
ContentArea.Position = UDim2.new(0, 180, 0, 10)
ContentArea.Size = UDim2.new(1, -190, 1, -20)
ContentArea.BackgroundTransparency = 1

local TabContainer = Instance.new("ScrollingFrame", Sidebar)
TabContainer.Size = UDim2.new(1, -10, 1, -100)
TabContainer.Position = UDim2.new(0, 5, 0, 60)
TabContainer.BackgroundTransparency = 1
TabContainer.CanvasSize = UDim2.new(0, 0, 1.5, 0)
TabContainer.ScrollBarThickness = 0
Instance.new("UIListLayout", TabContainer).Padding = UDim.new(0, 5)

-- [ وظائف إنشاء الأزرار والصفحات ]
local Pages = {}
local function NewTab(name, icon)
    local Page = Instance.new("ScrollingFrame", ContentArea)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = false
    Page.BackgroundTransparency = 1
    Page.CanvasSize = UDim2.new(0,0,3,0)
    Page.ScrollBarThickness = 2
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)
    
    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(1, 0, 0, 38)
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TabBtn.Text = "  " .. name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", TabBtn)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
        TS:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 255, 150), TextColor3 = Color3.new(0,0,0)}):Play()
        for _, btn in pairs(TabContainer:GetChildren()) do
            if btn:IsA("TextButton") and btn ~= TabBtn then
                TS:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(25, 25, 30), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            end
        end
    end)
    Pages[name] = Page
    return Page
end

-- [ الصفحات العملاقة ]
local MainTab = NewTab("Control Center", "")
local AnatomyTab = NewTab("Map Anatomy", "")
local SpyTab = NewTab("Remote Engine", "")
local VisualsTab = NewTab("World Visuals", "")
local ToolTab = NewTab("Tool Laboratory", "")

-----------------------------------------------------------
-- [ 1. CONTROL CENTER: Advanced Movement ]
-----------------------------------------------------------
local function CreateSlider(parent, title, min, max, default, callback)
    local SFrame = Instance.new("Frame", parent)
    SFrame.Size = UDim2.new(1, 0, 0, 60)
    SFrame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel", SFrame)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = title .. ": " .. default
    Label.TextColor3 = Color3.new(1,1,1)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.GothamBold

    local SliderBack = Instance.new("Frame", SFrame)
    SliderBack.Size = UDim2.new(0.9, 0, 0, 10)
    SliderBack.Position = UDim2.new(0.05, 0, 0, 35)
    SliderBack.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    
    local SliderMain = Instance.new("Frame", SliderBack)
    SliderMain.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    SliderMain.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    
    -- نظام تحكم السلايدر للجوال
    SliderBack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local function Update()
                local Pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                SliderMain.Size = UDim2.new(Pos, 0, 1, 0)
                local Val = math.floor(min + (Pos * (max-min)))
                Label.Text = title .. ": " .. Val
                callback(Val)
            end
            Update()
            local Move = UIS.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then Update() end
            end)
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then Move:Disconnect() end end)
        end
    end)
end

CreateSlider(MainTab, "Hyper Speed", 16, 1000, 16, function(v) LP.Character.Humanoid.WalkSpeed = v end)
CreateSlider(MainTab, "Jump Power", 50, 1000, 50, function(v) LP.Character.Humanoid.JumpPower = v; LP.Character.Humanoid.UseJumpPower = true end)

-----------------------------------------------------------
-- [ 2. MAP ANATOMY: The Surgeon ]
-----------------------------------------------------------
local AnatomyLog = Instance.new("TextBox", AnatomyTab)
AnatomyLog.Size = UDim2.new(1, 0, 0, 180)
AnatomyLog.MultiLine = true
AnatomyLog.Text = "--- Anatomy Report ---\nSelect an object to deconstruct..."
AnatomyLog.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
AnatomyLog.TextColor3 = Color3.fromRGB(0, 255, 150)
AnatomyLog.Font = Enum.Font.Code
AnatomyLog.ClearTextOnFocus = false
AnatomyLog.TextXAlignment = Enum.TextXAlignment.Left

local SelectBtn = Instance.new("TextButton", AnatomyTab)
SelectBtn.Size = UDim2.new(1, 0, 0, 45)
SelectBtn.Text = "🔬 START SURGERY (Click Any Part)"
SelectBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
SelectBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", SelectBtn)

SelectBtn.MouseButton1Click:Connect(function()
    SelectBtn.Text = "WAITING FOR CLICK..."
    local Conn; Conn = UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if not UIS:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)[1] then
                local Ray = workspace.CurrentCamera:ViewportPointToRay(input.Position.X, input.Position.Y)
                local Hit = workspace:FindPartOnRay(Ray)
                if Hit then
                    local Target = Hit:FindFirstAncestorOfClass("Model") or Hit
                    MozerHub.SelectedObject = Target
                    local Data = "OBJECT: " .. Target.Name .. "\n"
                    Data = Data .. "CLASS: " .. Target.ClassName .. "\n"
                    Data = Data .. "PATH: " .. Target:GetFullName() .. "\n"
                    Data = Data .. "SIZE: " .. tostring(Target:GetExtentsSize()) .. "\n"
                    if Target:IsA("MeshPart") then Data = Data .. "MESH ID: " .. Target.MeshId end
                    AnatomyLog.Text = Data
                    
                    -- Highlight Effect
                    local High = Instance.new("Highlight", Target)
                    High.FillColor = Color3.fromRGB(0, 255, 150)
                    task.wait(1); High:Destroy()
                end
                SelectBtn.Text = "🔬 START SURGERY (Click Any Part)"
                Conn:Disconnect()
            end
        end
    end)
end)

-----------------------------------------------------------
-- [ 3. REMOTE ENGINE: Deep Interceptor ]
-----------------------------------------------------------
local SpyBox = Instance.new("ScrollingFrame", SpyTab)
SpyBox.Size = UDim2.new(1, 0, 0, 250)
SpyBox.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
Instance.new("UIListLayout", SpyBox)

local function LogRemote(remote, args)
    local Frame = Instance.new("Frame", SpyBox)
    Frame.Size = UDim2.new(1, 0, 0, 35)
    Frame.BackgroundTransparency = 1
    
    local Txt = Instance.new("TextBox", Frame)
    Txt.Size = UDim2.new(0.8, 0, 1, 0)
    Txt.Text = "Remote: " .. remote.Name .. " | Args: " .. #args
    Txt.TextColor3 = Color3.new(1,1,1)
    Txt.BackgroundTransparency = 1
    Txt.ClearTextOnFocus = false
    
    local FireBtn = Instance.new("TextButton", Frame)
    FireBtn.Size = UDim2.new(0.2, 0, 1, 0)
    FireBtn.Position = UDim2.new(0.8, 0, 0, 0)
    FireBtn.Text = "RE-FIRE"
    FireBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 0)
    
    FireBtn.MouseButton1Click:Connect(function()
        if remote:IsA("RemoteEvent") then remote:FireServer(unpack(args))
        elseif remote:IsA("RemoteFunction") then remote:InvokeServer(unpack(args)) end
    end)
end

-- Metatable Hooking (The Core)
local OldNC
OldNC = hookmetamethod(game, "__namecall", function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}
    if MozerHub.SpyActive and (Method == "FireServer" or Method == "InvokeServer") then
        LogRemote(self, Args)
    end
    return OldNC(self, ...)
end)

local SpyToggle = Instance.new("TextButton", SpyTab)
SpyToggle.Size = UDim2.new(1, 0, 0, 45)
SpyToggle.Text = "REMOTE SPY: OFF"
SpyToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpyToggle.MouseButton1Click:Connect(function()
    MozerHub.SpyActive = not MozerHub.SpyActive
    SpyToggle.Text = "REMOTE SPY: " .. (MozerHub.SpyActive and "ON" or "OFF")
    SpyToggle.BackgroundColor3 = MozerHub.SpyActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
end)

-----------------------------------------------------------
-- [ 4. WORLD VISUALS: X-RAY & DEBUG ]
-----------------------------------------------------------
local XrayBtn = Instance.new("TextButton", VisualsTab)
XrayBtn.Size = UDim2.new(1, 0, 0, 45)
XrayBtn.Text = "X-RAY VISION: OFF"
XrayBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

XrayBtn.MouseButton1Click:Connect(function()
    MozerHub.XrayActive = not MozerHub.XrayActive
    XrayBtn.Text = "X-RAY VISION: " .. (MozerHub.XrayActive and "ON" or "OFF")
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(LP.Character) then
            if MozerHub.XrayActive then
                if obj.Transparency < 0.5 then obj.Transparency = 0.5 end
            else
                obj.Transparency = 0
            end
        end
    end
end)

local FullBright = Instance.new("TextButton", VisualsTab)
FullBright.Size = UDim2.new(1, 0, 0, 45)
FullBright.Text = "REMOVE FOG & NIGHT"
FullBright.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FullBright.MouseButton1Click:Connect(function()
    game.Lighting.Brightness = 2
    game.Lighting.ClockTime = 14
    game.Lighting.FogEnd = 100000
    game.Lighting.GlobalShadows = false
end)

-----------------------------------------------------------
-- [ نظام التصغير والدخول ]
-----------------------------------------------------------
local MiniBtn = Instance.new("TextButton", ScreenGui)
MiniBtn.Size = UDim2.new(0, 60, 0, 60)
MiniBtn.Position = UDim2.new(0, 10, 0.4, 0)
MiniBtn.Text = "MOZER"
MiniBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
MiniBtn.TextColor3 = Color3.fromRGB(0,0,0)
MiniBtn.Font = Enum.Font.FredokaOne
MiniBtn.Visible = false
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(1, 0)
MakeDraggable(MiniBtn)

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.BackgroundTransparency = 1
CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; MiniBtn.Visible = true end)
MiniBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; MiniBtn.Visible = false end)

-- [ الترحيب والتشغيل ]
local WelcomeFrame = Instance.new("Frame", ScreenGui)
WelcomeFrame.Size = UDim2.new(1, 0, 1, 0)
WelcomeFrame.BackgroundColor3 = Color3.new(0,0,0)
WelcomeFrame.ZIndex = 100

local WelcText = Instance.new("TextLabel", WelcomeFrame)
WelcText.Size = UDim2.new(1, 0, 1, 0)
WelcText.Text = "MOZER ARCHITECT V3\nInitializing Systems..."
WelcText.Font = Enum.Font.FredokaOne
WelcText.TextSize = 40
WelcText.TextColor3 = Color3.fromRGB(0, 255, 150)

task.wait(1.5)
TS:Create(WelcomeFrame, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
TS:Create(WelcText, TweenInfo.new(1), {TextTransparency = 1}):Play()
task.wait(1)
WelcomeFrame:Destroy()

print("MOZER V3: SYSTEM ONLINE")
