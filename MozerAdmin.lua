-- Roblox Professional Chess Engine (AI vs Human)
-- Developed for Delta Executor (Mobile Friendly)

local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- تدمير أي نسخة سابقة
if PlayerGui:FindFirstChild("ProChess") then PlayerGui.ProChess:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "ProChess"
sg.Parent = PlayerGui

-- المتغيرات الأساسية
local SelectedDifficulty = "Normal"
local UserColor = "W"
local EngineDepth = 2
local GameActive = false
local CurrentTurn = "W"
local SelectedSq = nil

local PieceValues = {p = 100, n = 320, b = 330, r = 500, q = 900, k = 20000}
local PieceIcons = {
    r = "♜", n = "♞", b = "♝", q = "♛", k = "♚", p = "♟",
    R = "♖", N = "♘", B = "♗", Q = "♕", K = "♔", P = "♙"
}

-- لوحة الشطرنج الافتراضية
local Board = {
    {"r","n","b","q","k","b","n","r"},
    {"p","p","p","p","p","p","p","p"},
    {".",".",".",".",".",".",".","."},
    {".",".",".",".",".",".",".","."},
    {".",".",".",".",".",".",".","."},
    {".",".",".",".",".",".",".","."},
    {"P","P","P","P","P","P","P","P"},
    {"R","N","B","Q","K","B","N","R"}
}

-- [1] إنشاء القائمة الرئيسية (Main Menu)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = sg

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "CHESS ENGINE AI"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 24
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-- أزرار الصعوبة
local function CreateButton(name, pos, color, parent)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 140, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    return btn
end

local DiffLabel = Instance.new("TextLabel")
DiffLabel.Text = "Select Difficulty:"
DiffLabel.Size = UDim2.new(1,0,0,30)
DiffLabel.Position = UDim2.new(0,0,0,60)
DiffLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
DiffLabel.BackgroundTransparency = 1
DiffLabel.Parent = MainFrame

local EasyBtn = CreateButton("EASY", UDim2.new(0, 20, 0, 90), Color3.fromRGB(46, 204, 113), MainFrame)
local NormalBtn = CreateButton("NORMAL", UDim2.new(0, 180, 0, 90), Color3.fromRGB(52, 152, 219), MainFrame)
local HardBtn = CreateButton("HARD", UDim2.new(0, 20, 0, 140), Color3.fromRGB(230, 126, 34), MainFrame)
local NightmareBtn = CreateButton("NIGHTMARE", UDim2.new(0, 180, 0, 140), Color3.fromRGB(192, 57, 43), MainFrame)

local ColorLabel = Instance.new("TextLabel")
ColorLabel.Text = "Play As:"
ColorLabel.Size = UDim2.new(1,0,0,30)
ColorLabel.Position = UDim2.new(0,0,0,200)
ColorLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
ColorLabel.BackgroundTransparency = 1
ColorLabel.Parent = MainFrame

local WhiteBtn = CreateButton("WHITE", UDim2.new(0, 20, 0, 230), Color3.fromRGB(200, 200, 200), MainFrame)
WhiteBtn.TextColor3 = Color3.new(0,0,0)
local BlackBtn = CreateButton("BLACK", UDim2.new(0, 180, 0, 230), Color3.fromRGB(0, 0, 0), MainFrame)

local StartBtn = CreateButton("SELECT & START", UDim2.new(0.5, -100, 0, 320), Color3.fromRGB(241, 196, 15), MainFrame)
StartBtn.TextColor3 = Color3.new(0,0,0)
StartBtn.TextSize = 18

-- منطق الاختيار
EasyBtn.MouseButton1Click:Connect(function() SelectedDifficulty = "Easy" EngineDepth = 1 print("Selected Easy") end)
NormalBtn.MouseButton1Click:Connect(function() SelectedDifficulty = "Normal" EngineDepth = 2 print("Selected Normal") end)
HardBtn.MouseButton1Click:Connect(function() SelectedDifficulty = "Hard" EngineDepth = 3 print("Selected Hard") end)
NightmareBtn.MouseButton1Click:Connect(function() SelectedDifficulty = "Nightmare" EngineDepth = 4 print("Selected Nightmare") end)

WhiteBtn.MouseButton1Click:Connect(function() UserColor = "W" print("Color: White") end)
BlackBtn.MouseButton1Click:Connect(function() UserColor = "B" print("Color: Black") end)

-- [2] إنشاء اللوحة اللعب
local GameFrame = Instance.new("Frame")
GameFrame.Size = UDim2.new(0, 360, 0, 420)
GameFrame.Position = UDim2.new(0.5, -180, 0.5, -210)
GameFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
GameFrame.Visible = false
GameFrame.Active = true
GameFrame.Draggable = true
GameFrame.Parent = sg
Instance.new("UICorner", GameFrame).CornerRadius = UDim.new(0, 10)

local BoardGrid = Instance.new("Frame")
BoardGrid.Size = UDim2.new(0, 320, 0, 320)
BoardGrid.Position = UDim2.new(0.5, -160, 0, 20)
BoardGrid.Parent = GameFrame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 40)
StatusLabel.Position = UDim2.new(0, 0, 1, -40)
StatusLabel.TextColor3 = Color3.new(1, 1, 1)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Your Turn"
StatusLabel.Parent = GameFrame

local SquaresUI = {}

function BuildBoardUI()
    for r = 1, 8 do
        SquaresUI[r] = {}
        for c = 1, 8 do
            local sq = Instance.new("TextButton")
            sq.Size = UDim2.new(0, 40, 0, 40)
            sq.Position = UDim2.new(0, (c-1)*40, 0, (r-1)*40)
            sq.BackgroundColor3 = (r+c)%2 == 0 and Color3.fromRGB(240, 217, 181) or Color3.fromRGB(181, 136, 99)
            sq.Text = ""
            sq.TextSize = 30
            sq.Font = Enum.Font.Gotham
            sq.Parent = BoardGrid
            SquaresUI[r][c] = sq
            
            sq.MouseButton1Click:Connect(function()
                if CurrentTurn == UserColor then
                    OnSquareSelected(r, c)
                end
            end)
        end
    end
end

function RefreshUI()
    for r = 1, 8 do
        for c = 1, 8 do
            local p = Board[r][c]
            SquaresUI[r][c].Text = PieceIcons[p] or ""
            SquaresUI[r][c].TextColor3 = (p:upper() == p and p ~= ".") and Color3.new(1,1,1) or Color3.new(0,0,0)
            -- ظل للقطع البيضاء
            if p:upper() == p and p ~= "." then
               SquaresUI[r][c].TextStrokeTransparency = 0.5
            else
               SquaresUI[r][c].TextStrokeTransparency = 1
            end
        end
    end
end

-- [3] محرك الشطرنج (AI Logic)
function IsValidMove(sr, sc, tr, tc, b)
    local p = b[sr][sc]:lower()
    if p == "." then return false end
    local isWhite = b[sr][sc] == b[sr][sc]:upper()
    local target = b[tr][tc]
    if target ~= "." and (target == target:upper()) == isWhite then return false end
    
    local dr, dc = tr - sr, tc - sc
    if p == "p" then
        local dir = isWhite and -1 or 1
        if dc == 0 and target == "." then
            if dr == dir then return true end
            if dr == 2*dir and (isWhite and sr==7 or sr==2) and b[sr+dir][sc] == "." then return true end
        elseif math.abs(dc) == 1 and dr == dir and target ~= "." then return true end
    elseif p == "n" then return (math.abs(dr)==2 and math.abs(dc)==1) or (math.abs(dr)==1 and math.abs(dc)==2)
    elseif p == "b" then return math.abs(dr) == math.abs(dc) and IsPathClear(sr,sc,tr,tc,b)
    elseif p == "r" then return (sr==tr or sc==tc) and IsPathClear(sr,sc,tr,tc,b)
    elseif p == "q" then return (math.abs(dr)==math.abs(dc) or sr==tr or sc==tc) and IsPathClear(sr,sc,tr,tc,b)
    elseif p == "k" then return math.abs(dr) <= 1 and math.abs(dc) <= 1 end
    return false
end

function IsPathClear(sr, sc, tr, tc, b)
    local dr, dc = math.sign(tr-sr), math.sign(tc-sc)
    local r, c = sr+dr, sc+dc
    while r ~= tr or c ~= tc do
        if b[r][c] ~= "." then return false end
        r, c = r+dr, c+dc
    end
    return true
end

function GetPossibleMoves(color, b)
    local moves = {}
    for r=1,8 do for c=1,8 do
        local p = b[r][c]
        if p ~= "." and ((color == "W" and p == p:upper()) or (color == "B" and p == p:lower())) then
            for tr=1,8 do for tc=1,8 do
                if IsValidMove(r,c,tr,tc,b) then table.insert(moves, {sr=r, sc=c, tr=tr, tc=tc}) end
            end end
        end
    end end
    return moves
end

function Evaluate(b)
    local score = 0
    for r=1,8 do for c=1,8 do
        local p = b[r][c]
        if p ~= "." then
            local val = PieceValues[p:lower()] or 0
            score = score + (p == p:upper() and val or -val)
        end
    end end
    return score
end

function Minimax(b, depth, alpha, beta, isMax)
    if depth == 0 then return Evaluate(b) end
    local moves = GetPossibleMoves(isMax and "W" or "B", b)
    if #moves == 0 then return isMax and -99999 or 99999 end
    
    if isMax then
        local maxEval = -1000000
        for _, m in pairs(moves) do
            local nb = {} for i=1,8 do nb[i] = {unpack(b[i])} end
            nb[m.tr][m.tc] = nb[m.sr][m.sc]
            nb[m.sr][m.sc] = "."
            local ev = Minimax(nb, depth-1, alpha, beta, false)
            maxEval = math.max(maxEval, ev)
            alpha = math.max(alpha, ev)
            if beta <= alpha then break end
        end
        return maxEval
    else
        local minEval = 1000000
        for _, m in pairs(moves) do
            local nb = {} for i=1,8 do nb[i] = {unpack(b[i])} end
            nb[m.tr][m.tc] = nb[m.sr][m.sc]
            nb[m.sr][m.sc] = "."
            local ev = Minimax(nb, depth-1, alpha, beta, true)
            minEval = math.min(minEval, ev)
            beta = math.min(beta, ev)
            if beta <= alpha then break end
        end
        return minEval
    end
end

function AIMove()
    StatusLabel.Text = "AI is Thinking (Nightmare Mode)..."
    task.wait(0.1)
    local moves = GetPossibleMoves(UserColor == "W" and "B" or "W", Board)
    local bestMove = nil
    local bestVal = (UserColor == "W") and 1000000 or -1000000
    
    for _, m in pairs(moves) do
        local nb = {} for i=1,8 do nb[i] = {unpack(Board[i])} end
        nb[m.tr][m.tc] = nb[m.sr][m.sc]
        nb[m.sr][m.sc] = "."
        local val = Minimax(nb, EngineDepth - 1, -1000000, 1000000, UserColor == "B")
        
        if (UserColor == "W" and val < bestVal) or (UserColor == "B" and val > bestVal) then
            bestVal = val
            bestMove = m
        end
    end
    
    if bestMove then
        Board[bestMove.tr][bestMove.tc] = Board[bestMove.sr][bestMove.sc]
        Board[bestMove.sr][bestMove.sc] = "."
        CurrentTurn = UserColor
        RefreshUI()
        StatusLabel.Text = "Your Turn"
    end
end

-- [4] تشغيل اللعبة
function OnSquareSelected(r, c)
    local p = Board[r][c]
    if p ~= "." and ((UserColor == "W" and p == p:upper()) or (UserColor == "B" and p == p:lower())) then
        if SelectedSq then SquaresUI[SelectedSq.r][SelectedSq.c].BorderSizePixel = 1 end
        SelectedSq = {r=r, c=c}
        SquaresUI[r][c].BorderSizePixel = 3
        SquaresUI[r][c].BorderColor3 = Color3.new(1,1,0)
    elseif SelectedSq then
        if IsValidMove(SelectedSq.r, SelectedSq.c, r, c, Board) then
            Board[r][c] = Board[SelectedSq.r][SelectedSq.c]
            Board[SelectedSq.r][SelectedSq.c] = "."
            SquaresUI[SelectedSq.r][SelectedSq.c].BorderSizePixel = 1
            SelectedSq = nil
            RefreshUI()
            CurrentTurn = (UserColor == "W") and "B" or "W"
            AIMove()
        end
    end
end

StartBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    GameFrame.Visible = true
    BuildBoardUI()
    RefreshUI()
    if UserColor == "B" then
        CurrentTurn = "W"
        AIMove()
    else
        CurrentTurn = "W"
    end
end)

print("Chess Engine Loaded! Mode: " .. SelectedDifficulty)
