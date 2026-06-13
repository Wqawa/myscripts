-- 身后/身前传送器（内置拖拽 + 最小化 + 半透明）
-- 本地脚本，置于 StarterPlayerScripts

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BehindTeleporterUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- 主窗口（Draggable = true 实现拖拽）
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 160, 0, 180)
mainFrame.Position = UDim2.new(0.5, -80, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BackgroundTransparency = 0.5
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true          -- 参考原脚本，启用内置拖拽
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 6)
frameCorner.Parent = mainFrame
mainFrame.Parent = screenGui

-- 标题栏（仅用于最小化按钮和标题文字）
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 24)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -24, 1, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "传送器"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 24, 1, -4)
minimizeBtn.Position = UDim2.new(1, -24, 0, 2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextScaled = true
minimizeBtn.BorderSizePixel = 0
local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 3)
minCorner.Parent = minimizeBtn
minimizeBtn.Parent = titleBar

-- 内容容器（最小化时隐藏）
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, 0, 1, -24)
contentContainer.Position = UDim2.new(0, 0, 0, 24)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

-- 开关按钮
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 80, 0, 28)
toggleBtn.Position = UDim2.new(0.5, -40, 0, 6)
toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
toggleBtn.Text = "关闭"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.GothamSemibold
toggleBtn.TextScaled = true
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = toggleBtn
toggleBtn.Parent = contentContainer

-- 间隔输入框
local intervalBox = Instance.new("TextBox")
intervalBox.Size = UDim2.new(0, 60, 0, 20)
intervalBox.Position = UDim2.new(0.5, -50, 0, 40)
intervalBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
intervalBox.Text = "0.2"
intervalBox.PlaceholderText = "间隔"
intervalBox.TextColor3 = Color3.new(1,1,1)
intervalBox.Font = Enum.Font.Gotham
intervalBox.TextScaled = true
local intervalCorner = Instance.new("UICorner")
intervalCorner.CornerRadius = UDim.new(0, 4)
intervalCorner.Parent = intervalBox
intervalBox.Parent = contentContainer

local intervalLabel = Instance.new("TextLabel")
intervalLabel.Size = UDim2.new(0, 20, 0, 20)
intervalLabel.Position = UDim2.new(0.5, 15, 0, 40)
intervalLabel.BackgroundTransparency = 1
intervalLabel.Text = "s"
intervalLabel.TextColor3 = Color3.fromRGB(200,200,200)
intervalLabel.Font = Enum.Font.Gotham
intervalLabel.TextSize = 10
intervalLabel.Parent = contentContainer

-- 距离输入框（支持负数）
local distBox = Instance.new("TextBox")
distBox.Size = UDim2.new(0, 60, 0, 20)
distBox.Position = UDim2.new(0.5, -50, 0, 65)
distBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
distBox.Text = "3.5"
distBox.PlaceholderText = "距离"
distBox.TextColor3 = Color3.new(1,1,1)
distBox.Font = Enum.Font.Gotham
distBox.TextScaled = true
local distCorner = Instance.new("UICorner")
distCorner.CornerRadius = UDim.new(0, 4)
distCorner.Parent = distBox
distBox.Parent = contentContainer

local distLabel = Instance.new("TextLabel")
distLabel.Size = UDim2.new(0, 20, 0, 20)
distLabel.Position = UDim2.new(0.5, 15, 0, 65)
distLabel.BackgroundTransparency = 1
distLabel.Text = "st"
distLabel.TextColor3 = Color3.fromRGB(200,200,200)
distLabel.Font = Enum.Font.Gotham
distLabel.TextSize = 10
distLabel.Parent = contentContainer

-- 当前目标标签
local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, -10, 0, 20)
targetLabel.Position = UDim2.new(0, 5, 0, 92)
targetLabel.BackgroundTransparency = 1
targetLabel.Text = "目标: 无"
targetLabel.TextColor3 = Color3.fromRGB(200,200,200)
targetLabel.Font = Enum.Font.Gotham
targetLabel.TextSize = 10
targetLabel.TextWrapped = true
targetLabel.Parent = contentContainer

-- 最近玩家按钮
local nearestBtn = Instance.new("TextButton")
nearestBtn.Size = UDim2.new(0, 70, 0, 22)
nearestBtn.Position = UDim2.new(0, 5, 1, -28)
nearestBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
nearestBtn.Text = "最近"
nearestBtn.TextColor3 = Color3.new(1,1,1)
nearestBtn.Font = Enum.Font.Gotham
nearestBtn.TextScaled = true
nearestBtn.Parent = contentContainer

-- 选择玩家按钮
local selectBtn = Instance.new("TextButton")
selectBtn.Size = UDim2.new(0, 70, 0, 22)
selectBtn.Position = UDim2.new(1, -75, 1, -28)
selectBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
selectBtn.Text = "选择"
selectBtn.TextColor3 = Color3.new(1,1,1)
selectBtn.Font = Enum.Font.Gotham
selectBtn.TextScaled = true
selectBtn.Parent = contentContainer

-- 玩家列表窗口
local listFrame = Instance.new("Frame")
listFrame.Size = UDim2.new(0, 200, 0, 300)
listFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
listFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
listFrame.BackgroundTransparency = 0.3
listFrame.BorderSizePixel = 0
listFrame.Visible = false
local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 6)
listCorner.Parent = listFrame
listFrame.Parent = screenGui

local listTitle = Instance.new("TextLabel")
listTitle.Size = UDim2.new(1, 0, 0, 24)
listTitle.BackgroundTransparency = 1
listTitle.Text = "选择玩家"
listTitle.TextColor3 = Color3.new(1,1,1)
listTitle.Font = Enum.Font.GothamBold
listTitle.TextScaled = true
listTitle.Parent = listFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -24, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.BorderSizePixel = 0
closeBtn.Parent = listFrame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -24)
scroll.Position = UDim2.new(0, 0, 0, 24)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 6
scroll.Parent = listFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.Name
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = scroll

-- ========== 最小化逻辑 ==========
local isMinimized = false
local fullSize, fullPos

local function applyMinimize()
    if isMinimized then
        mainFrame.Size = fullSize
        mainFrame.Position = fullPos
        contentContainer.Visible = true
        minimizeBtn.Text = "—"
    else
        fullSize = mainFrame.Size
        fullPos = mainFrame.Position
        contentContainer.Visible = false
        mainFrame.Size = UDim2.new(fullSize.X.Scale, fullSize.X.Offset, 0, 28)
        minimizeBtn.Text = "□"
    end
end

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    applyMinimize()
end)

-- ========== 传送逻辑 ==========
local enabled = false
local currentTarget = nil
local teleportThread = nil

local function getInterval()
    local val = tonumber(intervalBox.Text)
    if not val or val < 0.001 then val = 0.001 end
    return val
end

local function getDistance()
    local d = tonumber(distBox.Text)
    if not d then d = 3.5 end
    if d < -10 then d = -10 end
    if d > 10 then d = 10 end
    return d
end

local function getOffsetCFrame(targetPlayer)
    local char = targetPlayer.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local forward = root.CFrame.LookVector
    local offset = getDistance()
    local pos = root.Position - forward * offset
    return CFrame.new(pos)
end

local function teleport()
    if not currentTarget then return end
    local targetCF = getOffsetCFrame(currentTarget)
    if not targetCF then return end
    local myChar = localPlayer.Character
    if myChar then
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if myRoot then
            myRoot.CFrame = targetCF
        end
    end
end

local function startTeleportLoop()
    if teleportThread then task.cancel(teleportThread) end
    teleportThread = task.spawn(function()
        while enabled and currentTarget do
            if currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
                teleport()
            else
                enabled = false
                toggleBtn.Text = "关闭"
                toggleBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
                targetLabel.Text = "目标: 玩家离开"
                currentTarget = nil
                task.wait(1)
                if targetLabel.Text == "目标: 玩家离开" then
                    targetLabel.Text = "目标: 无"
                end
                break
            end
            task.wait(getInterval())
        end
        teleportThread = nil
    end)
end

toggleBtn.MouseButton1Click:Connect(function()
    if not currentTarget then
        targetLabel.Text = "目标: 请先选择"
        task.wait(1.5)
        if targetLabel.Text == "目标: 请先选择" then
            targetLabel.Text = "目标: 无"
        end
        return
    end
    enabled = not enabled
    if enabled then
        toggleBtn.Text = "开启"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        startTeleportLoop()
    else
        toggleBtn.Text = "关闭"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        if teleportThread then task.cancel(teleportThread); teleportThread = nil end
    end
end)

local function getNearestPlayer()
    local myChar = localPlayer.Character
    if not myChar then return nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local myPos = myRoot.Position
    local nearest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= localPlayer then
            local char = plr.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    local dist = (root.Position - myPos).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearest = plr
                    end
                end
            end
        end
    end
    return nearest
end

nearestBtn.MouseButton1Click:Connect(function()
    local nearest = getNearestPlayer()
    if nearest then
        currentTarget = nearest
        targetLabel.Text = "目标: " .. nearest.Name
        if enabled then
            enabled = false
            toggleBtn.Text = "关闭"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
            if teleportThread then task.cancel(teleportThread); teleportThread = nil end
            enabled = true
            toggleBtn.Text = "开启"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
            startTeleportLoop()
        end
    else
        targetLabel.Text = "目标: 无有效玩家"
        task.wait(1.5)
        if targetLabel.Text == "目标: 无有效玩家" then
            targetLabel.Text = "目标: 无"
        end
    end
end)

local function rebuildPlayerList()
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= localPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -8, 0, 28)
            btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
            btn.Text = plr.Name
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Font = Enum.Font.Gotham
            btn.TextScaled = true
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 4)
            btnCorner.Parent = btn
            btn.Parent = scroll
            btn.MouseButton1Click:Connect(function()
                currentTarget = plr
                targetLabel.Text = "目标: " .. plr.Name
                listFrame.Visible = false
                if enabled then
                    enabled = false
                    toggleBtn.Text = "关闭"
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
                    if teleportThread then task.cancel(teleportThread); teleportThread = nil end
                    enabled = true
                    toggleBtn.Text = "开启"
                    toggleBtn.BackgroundColor3 = Color3.fromRGB(0,200,0)
                    startTeleportLoop()
                end
            end)
        end
    end
    local count = #scroll:GetChildren()
    scroll.CanvasSize = UDim2.new(0, 0, 0, math.max(0, count * 32))
end

Players.PlayerAdded:Connect(rebuildPlayerList)
Players.PlayerRemoving:Connect(rebuildPlayerList)

selectBtn.MouseButton1Click:Connect(function()
    rebuildPlayerList()
    listFrame.Visible = true
end)

closeBtn.MouseButton1Click:Connect(function()
    listFrame.Visible = false
end)

mouse.Button1Down:Connect(function()
    if listFrame.Visible then
        local mp = Vector2.new(mouse.X, mouse.Y)
        local pos, size = listFrame.AbsolutePosition, listFrame.AbsoluteSize
        if not (mp.X >= pos.X and mp.X <= pos.X+size.X and mp.Y >= pos.Y and mp.Y <= pos.Y+size.Y) then
            listFrame.Visible = false
        end
    end
end)

rebuildPlayerList()