--[[
    MOZER ADMIN V2 - THE MONSTER EDITION
    Developed for: Delta Executor (Mobile)
    Features: Advanced Anatomy, Remote Spy, Model Scanner, Item Info
]]

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Mozer_Monster_V2"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [ Utility Functions ]
local function MakeDraggable(obj)
    local dragging, dragInput, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    obj.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- [ UI Construction - The Monster Frame ]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 15)
MakeDraggable(MainFrame)

-- Sidebar
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 160, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 15)

local Title = Instance.new("TextLabel", Sidebar)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "MOZER ADMIN"
Title.Font = Enum.Font.FredokaOne
Title.TextSize = 22
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1

-- Pages Container
local Container = Instance.new("Frame", MainFrame)
Container.Position = UDim2.new(0, 170, 0, 10)
Container.Size = UDim2.new(1, -180, 1, -20)
Container.BackgroundTransparency = 1

local Pages = {}
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 5, 0)
    Page.ScrollBarThickness = 3
    
    local UIList = Instance.new("UIListLayout", Page)
    UIList.Padding = UDim.new(0, 10)
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(0.9, 0, 0, 40)
    TabBtn.Position = UDim2.new(0.05, 0, 0, 60 + (#Sidebar:GetChildren()*45))
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.new(1,1,1)
    TabBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", TabBtn)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
    
    Pages[name] = Page
    return Page
end

-- [ PAGE 1: ADMIN CONTROL ]
local AdminPage = CreatePage("Admin Settings")

local function AddCounter(parent, title, default, step, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, 0, 0, 60)
    Frame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 0, 20)
    Label.Text = title .. ": " .. default
    Label.TextColor3 = Color3.new(1,1,1)
    Label.BackgroundTransparency = 1
    
    local Plus = Instance.new("TextButton", Frame)
    Plus.Size = UDim2.new(0.3, 0, 0, 30)
    Plus.Position = UDim2.new(0.6, 0, 0, 25)
    Plus.Text = "+" .. step
    Plus.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
    Plus.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", Plus)
    
    local Minus = Instance.new("TextButton", Frame)
    Minus.Size = UDim2.new(0.3, 0, 0, 30)
    Minus.Position = UDim2.new(0.1, 0, 0, 25)
    Minus.Text = "-" .. step
    Minus.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
    Minus.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", Minus)
    
    local val = default
    Plus.MouseButton1Click:Connect(function() val = val + step Label.Text = title .. ": " .. val callback(val) end)
    Minus.MouseButton1Click:Connect(function() val = math.max(0, val - step) Label.Text = title .. ": " .. val callback(val) end)
end

AddCounter(AdminPage, "WalkSpeed", 16, 10, function(v) LocalPlayer.Character.Humanoid.WalkSpeed = v end)

-- Fly Toggle
local flyOn = false
local flySpeed = 50
local FlyBtn = Instance.new("TextButton", AdminPage)
FlyBtn.Size = UDim2.new(1, 0, 0, 40)
FlyBtn.Text = "Fly: OFF"
FlyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", FlyBtn)

FlyBtn.MouseButton1Click:Connect(function()
    flyOn = not flyOn
    FlyBtn.Text = "Fly: " .. (flyOn and "ON" or "OFF")
    FlyBtn.BackgroundColor3 = flyOn and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(50, 50, 50)
end)

AddCounter(AdminPage, "Fly Speed", 50, 5, function(v) flySpeed = v end)

-- [ PAGE 2: PATH SPY (THE BEAST) ]
local SpyPage = CreatePage("Path Spy")
local SpyActive = false
local SpyLogs = {}

local SpyControls = Instance.new("Frame", SpyPage)
SpyControls.Size = UDim2.new(1, 0, 0, 80)
SpyControls.BackgroundTransparency = 1

local StartSpy = Instance.new("TextButton", SpyControls)
StartSpy.Size = UDim2.new(0.45, 0, 0, 35)
StartSpy.Text = "Monitor ON/OFF"
StartSpy.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
StartSpy.TextColor3 = Color3.new(1,1,1)

StartSpy.MouseButton1Click:Connect(function()
    SpyActive = not SpyActive
    StartSpy.BackgroundColor3 = SpyActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
end)

local LogContainer = Instance.new("Frame", SpyPage)
LogContainer.Size = UDim2.new(1, 0, 0, 1000)
LogContainer.Position = UDim2.new(0, 0, 0, 90)
LogContainer.BackgroundTransparency = 1
Instance.new("UIListLayout", LogContainer).Padding = UDim.new(0, 5)

local function AddSpyLog(path, type)
    if not SpyActive then return end
    if SpyLogs[path] then
        SpyLogs[path].Count = SpyLogs[path].Count + 1
        SpyLogs[path].UI.CountLabel.Text = "x" .. SpyLogs[path].Count
        return
    end
    
    local LogFrame = Instance.new("Frame", LogContainer)
    LogFrame.Size = UDim2.new(1, 0, 0, 40)
    LogFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    
    local PathTxt = Instance.new("TextBox", LogFrame)
    PathTxt.Size = UDim2.new(0.7, 0, 1, 0)
    PathTxt.Text = "[" .. type .. "] " .. path
    PathTxt.ClearTextOnFocus = false
    PathTxt.TextColor3 = Color3.new(1,1,1)
    PathTxt.TextSize = 10
    PathTxt.BackgroundTransparency = 1
    PathTxt.TextXAlignment = Enum.TextXAlignment.Left

    local CopyBtn = Instance.new("TextButton", LogFrame)
    CopyBtn.Size = UDim2.new(0.15, 0, 0.8, 0)
    CopyBtn.Position = UDim2.new(0.7, 5, 0.1, 0)
    CopyBtn.Text = "Copy"
    CopyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    
    local CountLabel = Instance.new("TextLabel", LogFrame)
    CountLabel.Size = UDim2.new(0.1, 0, 1, 0)
    CountLabel.Position = UDim2.new(0.85, 5, 0, 0)
    CountLabel.Text = "x1"
    CountLabel.TextColor3 = Color3.new(0, 1, 0)
    CountLabel.BackgroundTransparency = 1

    CopyBtn.MouseButton1Click:Connect(function() setclipboard(path) end)
    
    SpyLogs[path] = {Count = 1, UI = {CountLabel = CountLabel}}
end

-- Hooking Engine
local oldNC
oldNC = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if SpyActive and (method == "FireServer" or method == "InvokeServer") then
        AddSpyLog(self:GetFullName(), "REMOTE")
    end
    return oldNC(self, ...)
end)

-- [ PAGE 3: TOOL MOP (ANATOMY) ]
local MopPage = CreatePage("Tool Mop")
local SelectedObject = nil

local MopInfo = Instance.new("TextBox", MopPage)
MopInfo.Size = UDim2.new(1, 0, 0, 120)
MopInfo.MultiLine = true
MopInfo.Text = "Select an object to analyze..."
MopInfo.BackgroundColor3 = Color3.new(0,0,0)
MopInfo.TextColor3 = Color3.new(0, 1, 0)
MopInfo.ClearTextOnFocus = false

local PickBtn = Instance.new("TextButton", MopPage)
PickBtn.Size = UDim2.new(1, 0, 0, 40)
PickBtn.Text = "CLICK TO SELECT (MODEL)"
PickBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 150)

PickBtn.MouseButton1Click:Connect(function()
    local conn
    conn = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- UI Protection
            if UserInputService:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)[1] == nil or 
               not UserInputService:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)[1]:IsDescendantOf(ScreenGui) then
                
                local ray = workspace.CurrentCamera:ViewportPointToRay(input.Position.X, input.Position.Y)
                local hit = workspace:FindPartOnRay(ray)
                if hit then
                    SelectedObject = hit:FindFirstAncestorOfClass("Model") or hit
                    MopInfo.Text = "NAME: "..SelectedObject.Name.."\nPATH: "..SelectedObject:GetFullName().."\nCLASS: "..SelectedObject.ClassName
                    
                    -- Highlight
                    local h = Instance.new("Highlight", SelectedObject)
                    h.FillColor = Color3.new(1, 0, 0)
                    task.wait(2)
                    h:Destroy()
                end
            end
            conn:Disconnect()
        end
    end)
end)

local TeleportBtn = Instance.new("TextButton", MopPage)
TeleportBtn.Size = UDim2.new(1, 0, 0, 40)
TeleportBtn.Text = "Teleport to Similar Objects"
TeleportBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 150)

TeleportBtn.MouseButton1Click:Connect(function()
    if SelectedObject then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == SelectedObject.Name and obj ~= SelectedObject then
                LocalPlayer.Character:MoveTo(obj:GetPivot().Position)
                break
            end
        end
    end
end)

-- [ PAGE 4: ITEM & TOOL INFO ]
local ItemPage = CreatePage("Item & Tool")
local ItemDetails = Instance.new("TextBox", ItemPage)
ItemDetails.Size = UDim2.new(1, 0, 0, 200)
ItemDetails.MultiLine = true
ItemDetails.BackgroundColor3 = Color3.new(0,0,0)
ItemDetails.TextColor3 = Color3.new(1, 0.8, 0)

local ScanItemBtn = Instance.new("TextButton", ItemPage)
ScanItemBtn.Size = UDim2.new(1, 0, 0, 40)
ScanItemBtn.Text = "Scan Held Item"
ScanItemBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 0)

ScanItemBtn.MouseButton1Click:Connect(function()
    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    if tool then
        local data = "Tool Name: "..tool.Name.."\n"
        data = data .. "Path: "..tool:GetFullName().."\n"
        for _, child in pairs(tool:GetDescendants()) do
            if child:IsA("RemoteEvent") then
                data = data .. "[RemoteFound]: "..child.Name.."\n"
            elseif child:IsA("Script") or child:IsA("LocalScript") then
                data = data .. "[ScriptFound]: "..child.Name.." (Size: "..#child:GetFullName()..")\n"
            end
        end
        ItemDetails.Text = data
    else
        ItemDetails.Text = "Equip an item first!"
    end
end)

-- [ Close / Open System ]
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.TextColor3 = Color3.new(1,1,1)

local MinBtn = Instance.new("TextButton", ScreenGui)
MinBtn.Size = UDim2.new(0, 60, 0, 60)
MinBtn.Position = UDim2.new(0, 10, 0.5, 0)
MinBtn.Text = "MOZER"
MinBtn.Visible = false
MinBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MinBtn.TextColor3 = Color3.new(0, 1, 0)
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(1, 0)
MakeDraggable(MinBtn)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinBtn.Visible = true
end)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinBtn.Visible = false
end)

-- Fly Logic
RunService.Stepped:Connect(function()
    if flyOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        root.Velocity = Vector3.new(0, 0.1, 0)
        
        -- Basic Mobile Fly
        local cam = workspace.CurrentCamera
        local moveDir = LocalPlayer.Character.Humanoid.MoveDirection
        root.CFrame = root.CFrame + (moveDir * flySpeed/10)
    end
end)

-- [ Welcome Message ]
print("MOZER ADMIN V2 LOADED SUCCESSFULLY")
