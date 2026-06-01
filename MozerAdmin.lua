-- Mozer Admin v2 - Professional Edition
-- Optimized for Mobile (Delta Executor)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- UI Elements
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local LeftSidebar = Instance.new("Frame")
local RightContent = Instance.new("Frame")
local MinimizedFrame = Instance.new("TextButton")
local Title = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")
local TabContainer = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")

-- Configuration ScreenGui
ScreenGui.Name = "MozerAdmin_v2"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- [1. Welcome Intro]
local function ShowWelcome()
    local WelcomeGui = Instance.new("ScreenGui", game.CoreGui)
    local MozerLabel = Instance.new("TextLabel", WelcomeGui)
    MozerLabel.Size = UDim2.new(1, 0, 0.1, 0)
    MozerLabel.Position = UDim2.new(0, 0, 0.4, 0)
    MozerLabel.BackgroundTransparency = 1
    MozerLabel.Text = "Mozer Admin"
    MozerLabel.TextSize = 60
    MozerLabel.Font = Enum.Font.FredokaOne
    
    task.spawn(function()
        local h = 0
        while WelcomeGui.Parent do
            MozerLabel.TextColor3 = Color3.fromHSV(h, 1, 1)
            h = (h + 0.01) % 1
            task.wait()
        end
    end)
    task.wait(2)
    WelcomeGui:Destroy()
end

-- [2. Main UI Design]
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

LeftSidebar.Name = "Sidebar"
LeftSidebar.Parent = MainFrame
LeftSidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
LeftSidebar.Size = UDim2.new(0, 140, 1, 0)
Instance.new("UICorner", LeftSidebar).CornerRadius = UDim.new(0, 12)

Title.Parent = LeftSidebar
Title.Text = "BE MOZER"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1

CloseBtn.Parent = MainFrame
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextSize = 20

TabContainer.Parent = LeftSidebar
TabContainer.Position = UDim2.new(0, 10, 0, 60)
TabContainer.Size = UDim2.new(1, -20, 1, -120)
TabContainer.BackgroundTransparency = 1
UIListLayout.Parent = TabContainer
UIListLayout.Padding = UDim.new(0, 5)

RightContent.Name = "Content"
RightContent.Parent = MainFrame
RightContent.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
RightContent.Position = UDim2.new(0, 150, 0, 10)
RightContent.Size = UDim2.new(1, -160, 1, -20)
Instance.new("UICorner", RightContent).CornerRadius = UDim.new(0, 10)

-- [3. Tab System]
local Pages = {}
local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", RightContent)
    Page.Size = UDim2.new(1, -10, 1, -10)
    Page.Position = UDim2.new(0, 5, 0, 5)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = 2
    Page.CanvasSize = UDim2.new(0,0,2,0)
    
    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.Text = name
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)
    
    Pages[name] = Page
    return Page
end

-- Pages Initialization
local PageAdmin = CreatePage("Admin")
local PageSpy = CreatePage("Path Spy")
local PageMop = CreatePage("Tool Mop")
local PageItems = CreatePage("Items Info")
local PageClick = CreatePage("Click Inspect")

-----------------------------------------------------------
-- [4. Page Admin: Speed & Fly]
-----------------------------------------------------------
local speedVal = 16
local flySpeed = 50
local flying = false

local function CreateAdminControls()
    -- Speed UI
    local SpeedLabel = Instance.new("TextLabel", PageAdmin)
    SpeedLabel.Size = UDim2.new(1, 0, 0, 30)
    SpeedLabel.Text = "WalkSpeed: " .. speedVal
    SpeedLabel.TextColor3 = Color3.new(1,1,1)
    SpeedLabel.BackgroundTransparency = 1
    
    local SpeedPlus = Instance.new("TextButton", PageAdmin)
    SpeedPlus.Size = UDim2.new(0.4, 0, 0, 30)
    SpeedPlus.Position = UDim2.new(0.5, 5, 0, 35)
    SpeedPlus.Text = "+10"
    SpeedPlus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SpeedPlus.TextColor3 = Color3.new(1,1,1)

    local SpeedMinus = Instance.new("TextButton", PageAdmin)
    SpeedMinus.Size = UDim2.new(0.4, 0, 0, 30)
    SpeedMinus.Position = UDim2.new(0.1, -5, 0, 35)
    SpeedMinus.Text = "-10"
    SpeedMinus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SpeedMinus.TextColor3 = Color3.new(1,1,1)

    SpeedPlus.MouseButton1Click:Connect(function() speedVal = speedVal + 10 SpeedLabel.Text = "WalkSpeed: " .. speedVal end)
    SpeedMinus.MouseButton1Click:Connect(function() speedVal = math.max(0, speedVal - 10) SpeedLabel.Text = "WalkSpeed: " .. speedVal end)

    -- Fly UI
    local FlyToggle = Instance.new("TextButton", PageAdmin)
    FlyToggle.Size = UDim2.new(0.9, 0, 0, 40)
    FlyToggle.Position = UDim2.new(0, 0, 0, 80)
    FlyToggle.Text = "FLY: OFF"
    FlyToggle.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    FlyToggle.TextColor3 = Color3.new(1,1,1)

    FlyToggle.MouseButton1Click:Connect(function()
        flying = not flying
        FlyToggle.Text = flying and "FLY: ON" or "FLY: OFF"
        FlyToggle.BackgroundColor3 = flying and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    end)

    RunService.RenderStepped:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = speedVal
            if flying then
                local cam = workspace.CurrentCamera
                local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Velocity = Vector3.new(0, 0.1, 0) -- Anti Gravity
                    -- Mobile Fly Logic could be added here
                end
            end
        end
    end)
end
CreateAdminControls()

-----------------------------------------------------------
-- [5. Page Spy: Path Monitor]
-----------------------------------------------------------
local spyActive = false
local function CreateSpyControls()
    local ToggleSpy = Instance.new("TextButton", PageSpy)
    ToggleSpy.Size = UDim2.new(1, 0, 0, 40)
    ToggleSpy.Text = "Start Monitoring"
    ToggleSpy.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleSpy.TextColor3 = Color3.new(1,1,1)

    local LogFrame = Instance.new("Frame", PageSpy)
    LogFrame.Size = UDim2.new(1, 0, 1, -50)
    LogFrame.Position = UDim2.new(0, 0, 0, 50)
    LogFrame.BackgroundTransparency = 1
    local LogList = Instance.new("UIListLayout", LogFrame)

    ToggleSpy.MouseButton1Click:Connect(function()
        spyActive = not spyActive
        ToggleSpy.Text = spyActive and "Stop Monitoring" or "Start Monitoring"
    end)

    -- Hook Remotes
    local function LogAction(path)
        if not spyActive then return end
        local LogItem = Instance.new("TextBox", LogFrame)
        LogItem.Size = UDim2.new(1, 0, 0, 25)
        LogItem.Text = path
        LogItem.ClearTextOnFocus = false
        LogItem.TextScaled = true
        LogItem.BackgroundColor3 = Color3.fromRGB(20,20,20)
        LogItem.TextColor3 = Color3.new(1,1,1)
    end

    -- Example Spy (Log RemoteEvents)
    local oldNC
    oldNC = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if (method == "FireServer" or method == "InvokeServer") and spyActive then
            LogAction(self:GetFullName())
        end
        return oldNC(self, ...)
    end)
end
CreateSpyControls()

-----------------------------------------------------------
-- [6. Page Mop & Click Inspect]
-----------------------------------------------------------
local function SetupSelection(page, isFullModel)
    local SelectBtn = Instance.new("TextButton", page)
    SelectBtn.Size = UDim2.new(1, 0, 0, 40)
    SelectBtn.Text = "Tap to Select Object"
    SelectBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 40)
    
    local InfoBox = Instance.new("TextBox", page)
    InfoBox.Size = UDim2.new(1, 0, 0, 150)
    InfoBox.Position = UDim2.new(0, 0, 0, 50)
    InfoBox.MultiLine = true
    InfoBox.Text = "Details will appear here..."
    InfoBox.TextColor3 = Color3.new(1,1,1)
    InfoBox.BackgroundColor3 = Color3.new(0,0,0)

    SelectBtn.MouseButton1Click:Connect(function()
        local connection
        connection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                local pos = input.Position
                local ray = workspace.CurrentCamera:ViewportPointToRay(pos.X, pos.Y)
                local hit = workspace:FindPartOnRay(ray)
                
                if hit then
                    local target = hit
                    if isFullModel then
                        target = hit:FindFirstAncestorOfClass("Model") or hit
                    end
                    
                    InfoBox.Text = "Name: " .. target.Name .. "\nPath: " .. target:GetFullName() .. "\nClass: " .. target.ClassName
                    if target:IsA("MeshPart") or target:IsA("SpecialMesh") then
                        InfoBox.Text = InfoBox.Text .. "\nAssetID: " .. (target.MeshId or "None")
                    end
                end
                connection:Disconnect()
            end
        end)
    end)
end

SetupSelection(PageMop, true)
SetupSelection(PageClick, false)

-----------------------------------------------------------
-- [7. Drag & Minimize]
-----------------------------------------------------------
local function MakeDraggable(frame)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    frame.InputEnded:Connect(function(input)
        dragging = false
    end)
end

MakeDraggable(MainFrame)

MinimizedFrame.Name = "Minimized"
MinimizedFrame.Parent = ScreenGui
MinimizedFrame.Size = UDim2.new(0, 50, 0, 50)
MinimizedFrame.Position = UDim2.new(0.1, 0, 0.5, 0)
MinimizedFrame.Text = "M"
MinimizedFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MinimizedFrame.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", MinimizedFrame).CornerRadius = UDim.new(1, 0)
MakeDraggable(MinimizedFrame)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedFrame.Visible = true
end)

MinimizedFrame.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinimizedFrame.Visible = false
end)

-- Start
ShowWelcome()
MainFrame.Visible = true
MinimizedFrame.Visible = false
