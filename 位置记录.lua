-- 位置记录与循环传送工具 v5 (修复最小化 + 布局微调)
-- 可拖拽半透明窗口

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WaypointTool"
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- 主窗口
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BackgroundTransparency = 0.5
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 6)
frameCorner.Parent = mainFrame
mainFrame.Parent = screenGui

-- 标题栏
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 24)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "位置记录循环"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = titleBar

-- 最小化按钮
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 24, 1, -4)
minimizeBtn.Position = UDim2.new(1, -48, 0, 2)
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

-- 关闭按钮
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 1, -4)
closeBtn.Position = UDim2.new(1, -24, 0, 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.BorderSizePixel = 0
local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 3)
closeCorner.Parent = closeBtn
closeBtn.Parent = titleBar

-- 左侧控制区
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0, 150, 1, 0)
leftPanel.Position = UDim2.new(0, 0, 0, 24)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = mainFrame

local recordBtn = Instance.new("TextButton")
recordBtn.Size = UDim2.new(0, 130, 0, 30)
recordBtn.Position = UDim2.new(0, 10, 0, 10)
recordBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
recordBtn.Text = "记录位置"
recordBtn.TextColor3 = Color3.new(1,1,1)
recordBtn.Font = Enum.Font.GothamSemibold
recordBtn.TextScaled = true
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 4)
btnCorner.Parent = recordBtn
recordBtn.Parent = leftPanel

local intervalBox = Instance.new("TextBox")
intervalBox.Size = UDim2.new(0, 80, 0, 24)
intervalBox.Position = UDim2.new(0, 10, 0, 50)
intervalBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
intervalBox.Text = "0.5"
intervalBox.PlaceholderText = "间隔"
intervalBox.TextColor3 = Color3.new(1,1,1)
intervalBox.Font = Enum.Font.Gotham
intervalBox.TextScaled = true
intervalBox.Parent = leftPanel

local intervalLabel = Instance.new("TextLabel")
intervalLabel.Size = UDim2.new(0, 30, 0, 24)
intervalLabel.Position = UDim2.new(0, 95, 0, 50)
intervalLabel.BackgroundTransparency = 1
intervalLabel.Text = "秒"
intervalLabel.TextColor3 = Color3.fromRGB(200,200,200)
intervalLabel.Font = Enum.Font.Gotham
intervalLabel.TextSize = 12
intervalLabel.Parent = leftPanel

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(0, 130, 0, 24)
nameBox.Position = UDim2.new(0, 10, 0, 85)
nameBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
nameBox.Text = "位置"
nameBox.PlaceholderText = "名字"
nameBox.TextColor3 = Color3.new(1,1,1)
nameBox.Font = Enum.Font.Gotham
nameBox.TextScaled = true
nameBox.Parent = leftPanel

local loopBtn = Instance.new("TextButton")
loopBtn.Size = UDim2.new(0, 130, 0, 30)
loopBtn.Position = UDim2.new(0, 10, 0, 120)
loopBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
loopBtn.Text = "循环: 关"
loopBtn.TextColor3 = Color3.new(1,1,1)
loopBtn.Font = Enum.Font.GothamSemibold
loopBtn.TextScaled = true
local loopCorner = Instance.new("UICorner")
loopCorner.CornerRadius = UDim.new(0, 4)
loopCorner.Parent = loopBtn
loopBtn.Parent = leftPanel

local clearAllBtn = Instance.new("TextButton")
clearAllBtn.Size = UDim2.new(0, 130, 0, 30)
clearAllBtn.Position = UDim2.new(0, 10, 0, 165)
clearAllBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
clearAllBtn.Text = "一键删除"
clearAllBtn.TextColor3 = Color3.new(1,1,1)
clearAllBtn.Font = Enum.Font.GothamSemibold
clearAllBtn.TextScaled = true
local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 4)
clearCorner.Parent = clearAllBtn
clearAllBtn.Parent = leftPanel

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0, 130, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 1, -30)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255,200,100)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 10
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = leftPanel

-- 右侧列表
local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(1, -160, 1, -30)
listFrame.Position = UDim2.new(0, 150, 0, 30)
listFrame.BackgroundTransparency = 1
listFrame.BorderSizePixel = 0
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.ScrollBarThickness = 6
listFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = listFrame

-- 数据
local records = {}

-- 辅助函数
local function showStatus(msg, duration)
    statusLabel.Text = msg
    task.delay(duration or 1.5, function()
        if statusLabel.Text == msg then statusLabel.Text = "" end
    end)
end

local function getCurrentPosition()
    local char = localPlayer.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    return root and root.Position
end

local function getMinUnusedId(name)
    local used = {}
    for _, r in ipairs(records) do
        if r.name == name then used[r.id] = true end
    end
    local id = 1
    while used[id] do id = id + 1 end
    return id
end

-- 循环传送逻辑
local isLooping = false
local loopThread = nil
local currentIndex = 1

local function getInterval()
    local val = tonumber(intervalBox.Text)
    if not val or val < 0.001 then val = 0.5 end
    return val
end

local function teleportToRecord(rec)
    local char = localPlayer.Character
    if not char then 
        showStatus("角色不存在", 0.8)
        return 
    end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(rec.x, rec.y, rec.z)
    else
        showStatus("传送失败", 0.8)
    end
end

local function loopStep()
    if #records == 0 then
        isLooping = false
        loopBtn.Text = "循环: 关"
        loopBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        if loopThread then task.cancel(loopThread); loopThread = nil end
        return
    end
    if currentIndex > #records then currentIndex = 1 end
    teleportToRecord(records[currentIndex])
    currentIndex = currentIndex + 1
end

local function startLoop()
    if loopThread then task.cancel(loopThread) end
    loopThread = task.spawn(function()
        while isLooping do
            loopStep()
            task.wait(getInterval())
        end
    end)
end

local function restartLoop()
    if isLooping then
        currentIndex = 1
        if loopThread then task.cancel(loopThread); loopThread = nil end
        startLoop()
    end
end

-- 重建列表 (条目高度35，XYZ左移10)
local function rebuildListUI()
    for _, child in ipairs(listFrame:GetChildren()) do
        if child:IsA("Frame") and child.Name == "Item" then
            child:Destroy()
        end
    end
    table.sort(records, function(a,b)
        if a.name == b.name then return a.id < b.id end
        return a.name < b.name
    end)
    for idx, rec in ipairs(records) do
        local item = Instance.new("Frame")
        item.Name = "Item"
        item.Size = UDim2.new(1, -8, 0, 35)
        item.BackgroundColor3 = Color3.fromRGB(50,50,50)
        item.BackgroundTransparency = 0.3
        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 4)
        itemCorner.Parent = item
        item.LayoutOrder = idx
        item.Parent = listFrame

        -- 名字+编号
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0, 60, 0, 15)
        nameLabel.Position = UDim2.new(0, 4, 0, 2)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = rec.name .. "#" .. rec.id
        nameLabel.TextColor3 = Color3.fromRGB(255,255,100)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 10
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = item

        -- X 标签和输入框 (左移10)
        local xLabel = Instance.new("TextLabel")
        xLabel.Size = UDim2.new(0, 12, 0, 15)
        xLabel.Position = UDim2.new(0, 38, 0, 2)   -- 原68->58
        xLabel.BackgroundTransparency = 1
        xLabel.Text = "X:"
        xLabel.TextColor3 = Color3.fromRGB(255,150,150)
        xLabel.Font = Enum.Font.GothamBold
        xLabel.TextSize = 9
        xLabel.Parent = item

        local xBox = Instance.new("TextBox")
        xBox.Size = UDim2.new(0, 40, 0, 18)
        xBox.Position = UDim2.new(0, 52, 0, 1)    -- 原82->72
        xBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
        xBox.Text = string.format("%.1f", rec.x)
        xBox.TextColor3 = Color3.new(1,1,1)
        xBox.Font = Enum.Font.Gotham
        xBox.TextScaled = true
        xBox.Parent = item
        xBox:GetPropertyChangedSignal("Text"):Connect(function()
            local v = tonumber(xBox.Text)
            if v then rec.x = v end
        end)

        -- Y 标签和输入框
        local yLabel = Instance.new("TextLabel")
        yLabel.Size = UDim2.new(0, 12, 0, 15)
        yLabel.Position = UDim2.new(0, 98, 0, 2)  -- 原128->118
        yLabel.BackgroundTransparency = 1
        yLabel.Text = "Y:"
        yLabel.TextColor3 = Color3.fromRGB(150,255,150)
        yLabel.Font = Enum.Font.GothamBold
        yLabel.TextSize = 9
        yLabel.Parent = item

        local yBox = Instance.new("TextBox")
        yBox.Size = UDim2.new(0, 40, 0, 18)
        yBox.Position = UDim2.new(0, 112, 0, 1)   -- 原142->132
        yBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
        yBox.Text = string.format("%.1f", rec.y)
        yBox.TextColor3 = Color3.new(1,1,1)
        yBox.Font = Enum.Font.Gotham
        yBox.TextScaled = true
        yBox.Parent = item
        yBox:GetPropertyChangedSignal("Text"):Connect(function()
            local v = tonumber(yBox.Text)
            if v then rec.y = v end
        end)

        -- Z 标签和输入框
        local zLabel = Instance.new("TextLabel")
        zLabel.Size = UDim2.new(0, 12, 0, 15)
        zLabel.Position = UDim2.new(0, 158, 0, 2)  -- 原188->178
        zLabel.BackgroundTransparency = 1
        zLabel.Text = "Z:"
        zLabel.TextColor3 = Color3.fromRGB(150,150,255)
        zLabel.Font = Enum.Font.GothamBold
        zLabel.TextSize = 9
        zLabel.Parent = item

        local zBox = Instance.new("TextBox")
        zBox.Size = UDim2.new(0, 40, 0, 18)
        zBox.Position = UDim2.new(0, 172, 0, 1)   -- 原202->192
        zBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
        zBox.Text = string.format("%.1f", rec.z)
        zBox.TextColor3 = Color3.new(1,1,1)
        zBox.Font = Enum.Font.Gotham
        zBox.TextScaled = true
        zBox.Parent = item
        zBox:GetPropertyChangedSignal("Text"):Connect(function()
            local v = tonumber(zBox.Text)
            if v then rec.z = v end
        end)

        -- 传送按钮 (垂直居中，不重叠)
        local tpBtn = Instance.new("TextButton")
        tpBtn.Size = UDim2.new(0, 30, 0, 10)
        tpBtn.Position = UDim2.new(1, -86, 0, 20)   -- X -36, Y=7
        tpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        tpBtn.Text = "传"
        tpBtn.TextColor3 = Color3.new(1,1,1)
        tpBtn.Font = Enum.Font.Gotham
        tpBtn.TextScaled = true
        tpBtn.Parent = item
        tpBtn.MouseButton1Click:Connect(function()
            teleportToRecord(rec)
        end)

        -- 删除按钮 (紧挨传送按钮右侧)
        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0, 24, 0, 10)
        delBtn.Position = UDim2.new(1, -44, 0, 20)   -- X -24, Y=7
        delBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        delBtn.Text = "删"
        delBtn.TextColor3 = Color3.new(1,1,1)
        delBtn.Font = Enum.Font.Gotham
        delBtn.TextScaled = true
        delBtn.Parent = item
        delBtn.MouseButton1Click:Connect(function()
            table.remove(records, table.find(records, rec))
            rebuildListUI()
            if isLooping then restartLoop() end
        end)
    end
    local count = #records
    listFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(0, count * 39))
    if isLooping then restartLoop() end
end

-- 记录位置
local function recordPosition()
    local pos = getCurrentPosition()
    if not pos then
        showStatus("无法获取角色位置", 1)
        return
    end
    local name = nameBox.Text
    if name == "" then name = "位置" end
    local newId = getMinUnusedId(name)
    table.insert(records, {
        name = name,
        id = newId,
        x = pos.X,
        y = pos.Y,
        z = pos.Z
    })
    rebuildListUI()
    showStatus("已记录 " .. name .. "#" .. newId, 1)
end

recordBtn.MouseButton1Click:Connect(recordPosition)

clearAllBtn.MouseButton1Click:Connect(function()
    records = {}
    rebuildListUI()
    showStatus("已删除所有记录", 1)
end)

loopBtn.MouseButton1Click:Connect(function()
    isLooping = not isLooping
    if isLooping then
        if #records == 0 then
            isLooping = false
            loopBtn.Text = "循环: 关"
            loopBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
            showStatus("无记录点", 1)
            return
        end
        loopBtn.Text = "循环: 开"
        loopBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        currentIndex = 1
        startLoop()
    else
        loopBtn.Text = "循环: 关"
        loopBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        if loopThread then task.cancel(loopThread); loopThread = nil end
    end
end)

-- ========== 最小化功能 (修复第一次点击报错) ==========
local isMinimized = false
local fullSize, fullPos

local function applyMinimize()
    if not isMinimized then
        -- 最小化：保存状态并缩小窗口
        fullSize = mainFrame.Size
        fullPos = mainFrame.Position
        leftPanel.Visible = false
        listFrame.Visible = false
        mainFrame.Size = UDim2.new(fullSize.X.Scale, fullSize.X.Offset, 0, 28)
        minimizeBtn.Text = "□"
    else
        -- 恢复
        mainFrame.Size = fullSize
        mainFrame.Position = fullPos
        leftPanel.Visible = true
        listFrame.Visible = true
        minimizeBtn.Text = "—"
    end
end

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    applyMinimize()
end)

-- 关闭按钮
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- 初始化
rebuildListUI()