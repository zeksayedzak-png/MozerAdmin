--[[
    ░█▀▄▀█ █▀▀█ ▀█▀ █▀▀ █▀▀█ 　 ░█▀▀█ ░█▀▄▀█ ░█▄─░█ ▀█▀ ░█▀▀▀█ ░█▀▀█ ▀█▀ █▀▀ █▀▀▄ ▀▀█▀▀ 
    ░█░█░█ █░░█ ░█─ █▀▀ █▄▄▀ 　 ░█──█ ░█░█░█ ░█░█░█ ░█─ ─▀▀▀▄▄ ░█─── ░█─ █▀▀ █░░█ ──█── 
    ░█──░█ ▀▀▀▀ ▄█▄ ▀▀▀ ▀░▀▀ 　 ░█▄▄█ ░█──░█ ░█──▀█ ▄█▄ ░█▄▄▄█ ░█▄▄█ ▄█▄ ▀▀▀ ▀░░▀ ──█──
    
    THE SINGULARITY - VERSION 4.0 (ULTIMATE ADM-EXPLORER)
    FOR DELTA EXECUTOR | MOBILE OPTIMIZED | UNRESTRICTED ACCESS
]]

local MozerV4 = {
    SpyActive = false,
    Selected = nil,
    Noclip = false,
    Xray = false,
    StealMode = false
}

-- [ CORE SERVICES ]
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local LP = game:GetService("Players").LocalPlayer
local Mouse = LP:GetMouse()

-- [ UI CONSTRUCTION - DARK NEON THEME ]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "MOZER_OMNISCIENT_V4"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 680, 0, 440)
MainFrame.Position = UDim2.new(0.5, -340, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)

-- Glowing Border
local Border = Instance.new("Frame", MainFrame)
Border.Size = UDim2.new(1, 4, 1, 4)
Border.Position = UDim2.new(0, -2, 0, -2)
Border.BackgroundColor3 = Color3.fromRGB(255, 0, 50) -- Dangerous Red
Border.ZIndex = -1
Instance.new("UICorner", Border).CornerRadius = UDim.new(0, 15)

-- [ DRAGGABLE SYSTEM ]
local function Drag(frame)
    local dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragStart = nil end end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
Drag(MainFrame)

-- [ SIDEBAR & TABS ]
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 180, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", Sidebar)

local Content = Instance.new("Frame", MainFrame)
Content.Position = UDim2.new(0, 190, 0, 10)
Content.Size = UDim2.new(1, -200, 1, -20)
Content.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", Sidebar)
Layout.Padding = UDim.new(0, 5)
Layout.HorizontalAlignment = "Center"

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 60)
Title.Text = "MOZER V4"
Title.TextColor3 = Color3.fromRGB(255, 0, 50)
Title.Font = Enum.Font.FredokaOne
Title.TextSize = 28

local Pages = {}
local function CreateTab(name)
    local Page = Instance.new("ScrollingFrame", Content)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.Visible = false
    Page.BackgroundTransparency = 1
    Page.CanvasSize = UDim2.new(0, 0, 5, 0)
    Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 10)
    
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.Size = UDim2.new(0.9, 0, 0, 40)
    Btn.Text = name
    Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Btn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", Btn)
    
    Btn.MouseButton1Click:Connect(function()
        for _, v in pairs(Pages) do v.Visible = false end
        Page.Visible = true
    end)
    Pages[name] = Page
    return Page
end

-- [ TAB 1: OMNIPOTENCE (SPEED/FLY/NOCLIP) ]
local OmniTab = CreateTab("Omnipotence")

local function CreateSlider(parent, text, min, max, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 60); Frame.BackgroundTransparency = 1
    local Lbl = Instance.new("TextLabel", Frame); Lbl.Size = UDim2.new(1, 0, 0, 20); Lbl.Text = text; Lbl.TextColor3 = Color3.new(1,1,1); Lbl.BackgroundTransparency = 1
    local Bar = Instance.new("Frame", Frame); Bar.Size = UDim2.new(0.9, 0, 0, 10); Bar.Position = UDim2.new(0.05, 0, 0, 35); Bar.BackgroundColor3 = Color3.fromRGB(40,40,40)
    local Fill = Instance.new("Frame", Bar); Fill.Size = UDim2.new(0.1, 0, 1, 0); Fill.BackgroundColor3 = Color3.fromRGB(255, 0, 50)
    
    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local function Update()
                local percent = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                Fill.Size = UDim2.new(percent, 0, 1, 0)
                local val = math.floor(min + (percent * (max - min)))
                callback(val)
            end
            Update()
            local move = UIS.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then Update() end end)
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then move:Disconnect() end end)
        end
    end)
end

CreateSlider(OmniTab, "Speed Multiplier", 16, 1000, function(v) LP.Character.Humanoid.WalkSpeed = v end)
CreateSlider(OmniTab, "Jump Power", 50, 2000, function(v) LP.Character.Humanoid.JumpPower = v; LP.Character.Humanoid.UseJumpPower = true end)

-- [ TAB 2: ANATOMY ENGINE (DEEP SCAN) ]
local AnatomyTab = CreateTab("Anatomy Engine")
local InfoText = Instance.new("TextBox", AnatomyTab)
InfoText.Size = UDim2.new(1, 0, 0, 200); InfoText.MultiLine = true; InfoText.Text = "SYSTEM IDLE..."; InfoText.ClearTextOnFocus = false; InfoText.BackgroundColor3 = Color3.new(0,0,0); InfoText.TextColor3 = Color3.fromRGB(255, 0, 50); InfoText.Font = Enum.Font.Code

local ScanBtn = Instance.new("TextButton", AnatomyTab)
ScanBtn.Size = UDim2.new(1, 0, 0, 50); ScanBtn.Text = "🔬 INITIATE SCAN"; ScanBtn.BackgroundColor3 = Color3.fromRGB(30, 0, 0); ScanBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", ScanBtn)

ScanBtn.MouseButton1Click:Connect(function()
    ScanBtn.Text = "SELECT TARGET IN WORLD..."
    local conn; conn = UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            if not UIS:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)[1] then
                local Ray = workspace.CurrentCamera:ViewportPointToRay(input.Position.X, input.Position.Y)
                local Hit = workspace:FindPartOnRay(Ray)
                if Hit then
                    local model = Hit:FindFirstAncestorOfClass("Model") or Hit
                    local data = "[[ ANATOMY REPORT ]]\n"
                    data = data.."NAME: "..model.Name.."\nPATH: "..model:GetFullName().."\nCLASS: "..model.ClassName.."\n"
                    if model:IsA("BasePart") then data = data.."MATERIAL: "..tostring(model.Material).."\nSIZE: "..tostring(model.Size) end
                    InfoText.Text = data
                    local Highlight = Instance.new("Highlight", model); Highlight.FillColor = Color3.new(1,0,0); task.wait(1.5); Highlight:Destroy()
                end
                ScanBtn.Text = "🔬 INITIATE SCAN"; conn:Disconnect()
            end
        end
    end)
end)

-- [ TAB 3: NETWORK INTERCEPTOR (SPY) ]
local NetworkTab = CreateTab("Network Spy")
local SpyActive = false
local LogFrame = Instance.new("ScrollingFrame", NetworkTab)
LogFrame.Size = UDim2.new(1, 0, 0, 300); LogFrame.BackgroundTransparency = 0.9; LogFrame.CanvasSize = UDim2.new(0,0,10,0)
Instance.new("UIListLayout", LogFrame)

local function NewRemoteLog(remote, args)
    local L = Instance.new("TextBox", LogFrame)
    L.Size = UDim2.new(1, 0, 0, 30); L.Text = "Remote: "..remote.Name.." | Args: "..#args; L.ClearTextOnFocus = false; L.TextColor3 = Color3.new(1,1,1); L.BackgroundColor3 = Color3.fromRGB(20,0,0)
end

local OldNC; OldNC = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if SpyActive and (method == "FireServer" or method == "InvokeServer") then
        NewRemoteLog(self, {...})
    end
    return OldNC(self, ...)
end)

local ToggleSpy = Instance.new("TextButton", NetworkTab)
ToggleSpy.Size = UDim2.new(1, 0, 0, 40); ToggleSpy.Text = "ACTIVATE SPY: OFF"; ToggleSpy.BackgroundColor3 = Color3.fromRGB(40,40,40)
ToggleSpy.MouseButton1Click:Connect(function()
    SpyActive = not SpyActive
    ToggleSpy.Text = SpyActive and "ACTIVATE SPY: ON" or "ACTIVATE SPY: OFF"
    ToggleSpy.BackgroundColor3 = SpyActive and Color3.fromRGB(150,0,0) or Color3.fromRGB(40,40,40)
end)

-- [ TAB 4: WORLD DECONSTRUCTION ]
local WorldTab = CreateTab("World Decon")

local Xray = Instance.new("TextButton", WorldTab)
Xray.Size = UDim2.new(1, 0, 0, 40); Xray.Text = "X-RAY VISION"; Xray.BackgroundColor3 = Color3.fromRGB(50,50,50)
Xray.MouseButton1Click:Connect(function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then v.Transparency = v.Transparency == 0 and 0.5 or 0 end
    end
end)

local DelInvis = Instance.new("TextButton", WorldTab)
DelInvis.Size = UDim2.new(1, 0, 0, 40); DelInvis.Text = "EXPOSE INVISIBLE WALLS"; DelInvis.BackgroundColor3 = Color3.fromRGB(50,50,50)
DelInvis.MouseButton1Click:Connect(function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Transparency > 0.8 then v.Transparency = 0.5; v.Color = Color3.new(1,0,0) end
    end
end)

-- [ MINIMIZE SYSTEM ]
local Mini = Instance.new("TextButton", ScreenGui)
Mini.Size = UDim2.new(0, 50, 0, 50); Mini.Position = UDim2.new(0, 10, 0.4, 0); Mini.Text = "MZ"; Mini.BackgroundColor3 = Color3.new(1,0,0); Mini.Visible = false; Instance.new("UICorner", Mini).CornerRadius = UDim.new(1,0)
Drag(Mini)

local Close = Instance.new("TextButton", MainFrame)
Close.Size = UDim2.new(0, 30, 0, 30); Close.Position = UDim2.new(1, -35, 0, 5); Close.Text = "X"; Close.BackgroundTransparency = 1; Close.TextColor3 = Color3.new(1,1,1)
Close.MouseButton1Click:Connect(function() MainFrame.Visible = false; Mini.Visible = true end)
Mini.MouseButton1Click:Connect(function() MainFrame.Visible = true; Mini.Visible = false end)

-- [ THE AWAKENING ]
print("MOZER OMNISCIENT V4: INITIALIZED")
local Sound = Instance.new("Sound", game.Workspace); Sound.SoundId = "rbxassetid://138097048"; Sound:Play()
