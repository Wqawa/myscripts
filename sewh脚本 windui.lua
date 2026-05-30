local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Wqawa/myscripts/refs/heads/main/windUI%20main.lua"))()

local s_v = "v 0.3 demo2"
local s_data = "2026/5/29"

local time = 0.05

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 删除并持续监听指定对象的生成
local map = workspace:FindFirstChild("Map")

if not map then
warn("workspace.Map 不存在")
return
end

-- 辅助函数：等待父级出现，然后监听指定名称的子对象
local function watchChild(parentPath, childName)
-- parentPath 是一个表，表示从 workspace.Map 开始的路径，例如 {"Constant"} 或 {"Environment", "Ocean"}
local function findParent()
local current = map
for _, part in ipairs(parentPath) do
current = current and current:FindFirstChild(part)
if not current then break end
end
return current
end

-- 先尝试获取已存在的父级
local parent = findParent()
if not parent then
-- 如果父级不存在，等待它出现
local conn
conn = map.ChildAdded:Connect(function(child)
if child.Name == parentPath[1] then
-- 第一级出现，继续向下查找完整路径
    local fullParent = findParent()
if fullParent then
            conn:Disconnect()
    parent = fullParent
    -- 建立监听
    parent.ChildAdded:Connect(function(grandChild)
        if grandChild.Name == childName then
                    grandChild:Destroy()
            print("已删除重新生成的 " .. childName)
        end
    end)
    -- 同时删除可能已存在但未处理的（例如删除时如果父级刚出现但子已存在）
        local existing = parent:FindFirstChild(childName)
    if existing then existing:Destroy() end
end
end
end)
-- 设置超时，避免永久等待（可选）
task.wait(10)
if conn then conn:Disconnect() end
else
-- 父级已存在，建立监听
parent.ChildAdded:Connect(function(child)
if child.Name == childName then
child:Destroy()
print("已删除重新生成的 " .. childName)
end
end)
-- 删除已存在的对象
local existing = parent:FindFirstChild(childName)
if existing then existing:Destroy() end
end
end

-- 1. 监听 workspace.Map.Constant.StopFall
watchChild({"Constant"}, "StopFall")

-- 2. 监听 workspace.Map.TopHeight（直接子级）
watchChild({}, "TopHeight")  -- 空表表示 map 本身

-- 3. 监听 workspace.Map.Environment.Ocean.FallReigons
watchChild({"Environment", "Ocean"}, "FallReigons")


local function TeleportTo(Map , x, y, z)
local character = player.Character
if not character or not character.Parent then
character = player.CharacterAdded:Wait()
end

local rootPart = character:FindFirstChild("HumanoidRootPart")
if not rootPart then
return false
end

local currentPos = rootPart.Position
local targetX = (x ~= nil) and x or currentPos.X
local targetY = (y ~= nil) and y or currentPos.Y
local targetZ = (z ~= nil) and z or currentPos.Z

local targetCFrame = CFrame.new(targetX, targetY, targetZ) * CFrame.Angles(0, rootPart.Orientation.Y, 0)

if Map == 'the_height' then
local TheHeight = workspace:FindFirstChild("Map")
and workspace.Map:FindFirstChild("Other")
and workspace.Map.Other:FindFirstChild("MapTerrain")
and workspace.Map.Other.MapTerrain:FindFirstChild("Map")
and workspace.Map.Other.MapTerrain.Map:FindFirstChild("Column")

if TheHeight then
rootPart.CFrame = targetCFrame
end
end

if Map == 'excalibur' then
local targetPart = workspace:FindFirstChild("SwordSpot") and workspace.SwordSpot:FindFirstChild("PromptPart")

if not targetPart then
return
end

local targetPosition = targetPart.Position + Vector3.new(0, 3, 0)
targetCFrame = CFrame.new(targetPosition)

rootPart.CFrame = targetCFrame
end

if Map == 'excalibur_jr' then
local targetPart = workspace:FindFirstChild("Map")
and workspace.Map:FindFirstChild("Objects")
and workspace.Map.Objects:FindFirstChild("SwordSpot")
and workspace.Map.Objects.SwordSpot:FindFirstChild("PromptPart")

if not targetPart then
return
end

local targetPosition = targetPart.Position + Vector3.new(0, 3, 0)
targetCFrame = CFrame.new(targetPosition)

rootPart.CFrame = targetCFrame
end

if Map == 'wipeout' then
local ramp = workspace:FindFirstChild("Map")
and workspace.Map:FindFirstChild("Other")
and workspace.Map.Other:FindFirstChild("MapTerrain")
and workspace.Map.Other.MapTerrain:FindFirstChild("Ramp")

if not ramp then
return
end

local children = ramp:GetChildren()
local targetPart = children[13]

if not targetPart then
return
end

local targetPosition = targetPart.Position + Vector3.new(0, 90, 10)
targetCFrame = CFrame.new(targetPosition)

rootPart.CFrame = targetCFrame
end

if Map == 'landslide' then
local mapTerrain = workspace:FindFirstChild("Map")
and workspace.Map:FindFirstChild("Other")
and workspace.Map.Other:FindFirstChild("MapTerrain")

if not mapTerrain then
return
end

local children = mapTerrain:GetChildren()
local targetPart = children[11]

if not targetPart then
return
end

local targetPosition = targetPart.Position + Vector3.new(0, 485, 0)
targetCFrame = CFrame.new(targetPosition)

rootPart.CFrame = targetCFrame
end

if Map == 'watergang' then
local objectsFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Objects")

if not objectsFolder then
return
end

local cauldronPositions = {}

for _, child in ipairs(objectsFolder:GetChildren()) do
if child.Name and string.find(child.Name, "Cauldron") then
local pos = nil

if child:IsA("BasePart") then
pos = child.Position
elseif child:IsA("Model") then
local primary = child.PrimaryPart
if primary then
pos = primary.Position
else
for _, part in ipairs(child:GetDescendants()) do
if part:IsA("BasePart") then
pos = part.Position
break
end
end
end
end

if pos then
table.insert(cauldronPositions, {
Name = child.Name,
Position = pos
})
end
end
end

if #cauldronPositions == 0 then
return
end

local randomIndex = math.random(1, #cauldronPositions)
local selected = cauldronPositions[randomIndex]

local targetPos = selected.Position + Vector3.new(0, 3, 0)
rootPart.CFrame = CFrame.new(targetPos)
end

if Map == 'chair' then
local objectsFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Objects")

if not objectsFolder then
return
end

local playerPos = rootPart.Position

local chairs = {}

for _, child in ipairs(objectsFolder:GetChildren()) do
if child.Name and string.find(child.Name, "Chair") then
local pos = nil

if child:IsA("BasePart") then
pos = child.Position
elseif child:IsA("Model") then
local primary = child.PrimaryPart
if primary then
pos = primary.Position
else
for _, part in ipairs(child:GetDescendants()) do
if part:IsA("BasePart") then
pos = part.Position
break
end
end
end
end

if pos then
local distance = (playerPos - pos).Magnitude
table.insert(chairs, {
Object = child,
Name = child.Name,
Position = pos,
Distance = distance
})
end
end
end

if #chairs == 0 then
return
end

table.sort(chairs, function(a, b)
return a.Distance < b.Distance
end)

local closest = chairs[1]
local targetPos = closest.Position + Vector3.new(0, 3, 0)
rootPart.CFrame = CFrame.new(targetPos)
end

if Map == nil then
rootPart.CFrame = targetCFrame
end

return true
end


local CrosshairGui = Instance.new("ScreenGui")
CrosshairGui.Name = "CrosshairGui"
CrosshairGui.Parent = playerGui
CrosshairGui.ResetOnSpawn = false
CrosshairGui.IgnoreGuiInset = true

local CrosshairFrame = Instance.new("Frame")
CrosshairFrame.Name = "Crosshair"
CrosshairFrame.Parent = CrosshairGui
CrosshairFrame.Size = UDim2.new(0, 30, 0, 30)
CrosshairFrame.Position = UDim2.new(0.5, -15, 0.5, -15)
CrosshairFrame.BackgroundTransparency = 1
CrosshairFrame.Visible = false

local hLine = Instance.new("Frame")
hLine.Parent = CrosshairFrame
hLine.Size = UDim2.new(1, 0, 0, 2)
hLine.Position = UDim2.new(0, 0, 0.5, -1)
hLine.BackgroundColor3 = Color3.new(1,1,1)
hLine.BorderSizePixel = 0

local vLine = Instance.new("Frame")
vLine.Parent = CrosshairFrame
vLine.Size = UDim2.new(0, 2, 1, 0)
vLine.Position = UDim2.new(0.5, -1, 0, 0)
vLine.BackgroundColor3 = Color3.new(1,1,1)
vLine.BorderSizePixel = 0

local dot = Instance.new("Frame")
dot.Parent = CrosshairFrame
dot.Size = UDim2.new(0, 6, 0, 6)
dot.Position = UDim2.new(0.5, -3, 0.5, -3)
dot.BackgroundColor3 = Color3.new(1,1,1)
dot.BorderSizePixel = 0
local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1,0)
dotCorner.Parent = dot
















-- LocalScript: 触控按钮选择器 + 拖动/缩放（修复版）

local UserInputService = game:GetService("UserInputService")


local playerGui = player:WaitForChild("PlayerGui")

-- ====== 1. 目标按钮路径 ======
local buttonPaths = {
{ path = {"TouchGui", "TouchControlFrame", "JumpButton"}, name = "JumpButton" },
{ path = {"TouchCore", "TouchControls", "AltUseButton"}, name = "AltUseButton" },
{ path = {"TouchCore", "TouchControls", "LockButton"}, name = "LockButton" },
{ path = {"TouchCore", "TouchControls", "EmoteButton"}, name = "EmoteButton" },
{ path = {"TouchCore", "TouchControls", "SprintButton"}, name = "SprintButton" },
{ path = {"TouchCore", "TouchControls", "UseButton"}, name = "UseButton" },
}

-- ====== 2. 一次性记录按钮原始数据（位置、大小、颜色等） ======
local buttonData = {}
local currentSelected = nil
local originalRecorded = false   -- 确保只记录一次

local function recordOriginalButtonData()
if originalRecorded then return end

for _, info in ipairs(buttonPaths) do
local obj = playerGui
local found = true
for _, childName in ipairs(info.path) do
obj = obj:FindFirstChild(childName)
if not obj then found = false break end
end
if found and obj:IsA("GuiObject") then
local isImage = obj:IsA("ImageButton") or obj:IsA("ImageLabel")
local origColor, origTrans
if isImage then
origColor = obj.ImageColor3
origTrans = obj.ImageTransparency
else
origColor = obj.BackgroundColor3
origTrans = obj.BackgroundTransparency
end
local origActive = true
if obj:IsA("GuiButton") then origActive = obj.Active end

-- ★ 关键：记录原始位置和大小（一次性的）
local originalPosition = obj.Position
local originalSize = obj.Size

buttonData[info.name] = {
object = obj,
isImageButton = isImage,
originalColor = origColor,
originalTransparency = origTrans,
originalActive = origActive,
originalPosition = originalPosition,
originalSize = originalSize,
}
print("已记录按钮:", info.name, "位置:", originalPosition, "大小:", originalSize)
else
warn("Button not found:", info.name)
end
end
originalRecorded = true
end

-- ====== 3. 按钮高亮/交互控制 ======
local function setButtonHighlight(name, enable)
local data = buttonData[name]
if not data then return end
local btn = data.object
if data.isImageButton then
btn.ImageColor3 = enable and Color3.new(1, 0, 0) or data.originalColor
btn.ImageTransparency = enable and 0.5 or data.originalTransparency
else
btn.BackgroundColor3 = enable and Color3.new(1, 0, 0) or data.originalColor
btn.BackgroundTransparency = enable and 0.5 or data.originalTransparency
end
end

local function setButtonActive(name, active)
local data = buttonData[name]
if data and data.object:IsA("GuiButton") then
data.object.Active = active
end
end

local function clearAllHighlights()
if currentSelected then
setButtonHighlight(currentSelected, false)
currentSelected = nil
end
end



-- 调整选中按钮大小
function scaleSelectedButton(factor)
if not currentSelected then return end
local data = buttonData[currentSelected]
if not data then return end
local btn = data.object
local curSizeX = btn.Size.X.Offset
local curSizeY = btn.Size.Y.Offset
-- 最小尺寸限制
local newX = math.max(10, curSizeX * factor)
local newY = math.max(10, curSizeY * factor)
btn.Size = UDim2.new(btn.Size.X.Scale, newX, btn.Size.Y.Scale, newY)
end

-- ====== 5. 模式状态 ======
local isSelectionMode = false


local function enterSelectionMode()
isSelectionMode = true
clearAllHighlights()
for name, _ in pairs(buttonData) do
setButtonActive(name, false)
end

end

local function exitSelectionMode()
isSelectionMode = false
clearAllHighlights()
for name, data in pairs(buttonData) do
if data.object:IsA("GuiButton") then
data.object.Active = data.originalActive
end
end
resetGestureState()

end

-- ====== 6. 触摸命中检测 ======
local function isInside(guiObject, position)
local absPos = guiObject.AbsolutePosition
local absSize = guiObject.AbsoluteSize
return position.X >= absPos.X and position.X <= absPos.X + absSize.X
and position.Y >= absPos.Y and position.Y <= absPos.Y + absSize.Y
end

local function getButtonUnderPosition(pos)
for name, data in pairs(buttonData) do
if isInside(data.object, pos) then
return name
end
end
return nil
end

-- 安全转换为 Vector2
local function toVector2(vec3)
return Vector2.new(vec3.X, vec3.Y)
end

-- ====== 7. 手势变量 ======
local draggingTouch = nil
local dragStartPos = nil       -- Vector2
local dragStartOffset = nil    -- Vector2

local pinchTouches = {}        -- [touchId] = Vector2 位置
local pinchInitialDist = nil
local pinchButtonStartSize = nil
local pinchButtonStartPos = nil

function resetGestureState()
draggingTouch = nil
dragStartPos = nil
dragStartOffset = nil
pinchTouches = {}
pinchInitialDist = nil
pinchButtonStartSize = nil
pinchButtonStartPos = nil
end

-- ====== 重置所有按钮为原始位置/大小 ======
local function resetAllButtonPositions()
for name, data in pairs(buttonData) do
local btn = data.object
if btn then
btn.Position = data.originalPosition
btn.Size = data.originalSize
end
end
-- 清除当前选中和高亮
if currentSelected then
setButtonHighlight(currentSelected, false)
currentSelected = nil
end
WindUI:Notify({
Title = "按键重置",
Content = "所有按钮已恢复原始位置和大小",
Duration = 2,
Icon = "check",
})
end

local function startDrag(touchId, touchPos)
local btn = buttonData[currentSelected].object
draggingTouch = touchId
dragStartPos = toVector2(touchPos)
dragStartOffset = Vector2.new(btn.Position.X.Offset, btn.Position.Y.Offset)
-- 清空缩放状态
pinchTouches = {}
pinchInitialDist = nil
end

local function startPinch(t1, t2, pos1, pos2)
local btn = buttonData[currentSelected].object
pinchTouches[t1] = toVector2(pos1)
pinchTouches[t2] = toVector2(pos2)
pinchInitialDist = (toVector2(pos1) - toVector2(pos2)).Magnitude
pinchButtonStartSize = Vector2.new(btn.Size.X.Offset, btn.Size.Y.Offset)
pinchButtonStartPos = Vector2.new(btn.Position.X.Offset, btn.Position.Y.Offset)
-- 清空拖动状态
draggingTouch = nil
dragStartPos = nil
end

local function updateDrag(touchPos)
local btn = buttonData[currentSelected].object
local delta = toVector2(touchPos) - dragStartPos
local newX = dragStartOffset.X + delta.X
local newY = dragStartOffset.Y + delta.Y
btn.Position = UDim2.new(btn.Position.X.Scale, newX, btn.Position.Y.Scale, newY)
end

local function updatePinch(pos1, pos2)
local btn = buttonData[currentSelected].object
local p1 = toVector2(pos1)
local p2 = toVector2(pos2)
local currentDist = (p1 - p2).Magnitude
if pinchInitialDist <= 0 then return end
local scale = currentDist / pinchInitialDist

local newSizeX = math.max(10, pinchButtonStartSize.X * scale)
local newSizeY = math.max(10, pinchButtonStartSize.Y * scale)

local parentAbsPos = btn.Parent.AbsolutePosition
local center = (p1 + p2) / 2 - Vector2.new(parentAbsPos.X, parentAbsPos.Y)

local newOffsetX = center.X - newSizeX / 2
local newOffsetY = center.Y - newSizeY / 2

btn.Size = UDim2.new(btn.Size.X.Scale, newSizeX, btn.Size.Y.Scale, newSizeY)
btn.Position = UDim2.new(btn.Position.X.Scale, newOffsetX, btn.Position.Y.Scale, newOffsetY)
end

-- ====== 8. 触摸事件处理 ======
UserInputService.TouchStarted:Connect(function(touch, gameProcessed)
if not isSelectionMode then return end

local btnName = getButtonUnderPosition(touch.Position)

if btnName then
if btnName == currentSelected then
-- 已选中，尝试开始手势
if not draggingTouch and next(pinchTouches) == nil then
startDrag(touch, touch.Position)
end
else
-- 选中新按钮
clearAllHighlights()
currentSelected = btnName
setButtonHighlight(btnName, true)

resetGestureState()
startDrag(touch, touch.Position)
end
else

return
end

-- 双指缩放检查
if currentSelected and draggingTouch and btnName == currentSelected then
if touch ~= draggingTouch and isInside(buttonData[currentSelected].object, touch.Position) then
-- 准备转为缩放，记录第二个触摸位置
pinchTouches[touch] = toVector2(touch.Position)
if pinchTouches[draggingTouch] then
startPinch(draggingTouch, touch, pinchTouches[draggingTouch], touch.Position)
end
end
end
end)

UserInputService.TouchMoved:Connect(function(touch, gameProcessed)
if not isSelectionMode or not currentSelected then return end

-- 更新双指记录
if pinchTouches[touch] then
pinchTouches[touch] = toVector2(touch.Position)
end

-- 拖动处理
if draggingTouch == touch then
if next(pinchTouches) then
-- 有第二个手指，转为缩放
local otherTouch = nil
for tid, pos in pairs(pinchTouches) do
if tid ~= touch then otherTouch = tid; break end
end
if otherTouch and isInside(buttonData[currentSelected].object, touch.Position) and isInside(buttonData[currentSelected].object, pinchTouches[otherTouch]) then
startPinch(touch, otherTouch, touch.Position, pinchTouches[otherTouch])
return
end
end
updateDrag(touch.Position)
end

-- 缩放处理
if pinchTouches[touch] and next(pinchTouches) then
local ids = {}
for tid, pos in pairs(pinchTouches) do
table.insert(ids, tid)
end
if #ids == 2 then
updatePinch(pinchTouches[ids[1]], pinchTouches[ids[2]])
end
end
end)

UserInputService.TouchEnded:Connect(function(touch, gameProcessed)
if not isSelectionMode then return end

if draggingTouch == touch then
draggingTouch = nil
dragStartPos = nil
end
if pinchTouches[touch] then
pinchTouches[touch] = nil
if next(pinchTouches) == nil then
pinchInitialDist = nil
else
for tid, pos in pairs(pinchTouches) do
startDrag(tid, pos)
break
end
end
end
end)














WindUI:Popup({
Title = "注意!!",
Icon = "info",
Content = "这个脚本由Deepseek编写主要代码, wq_furry(我)整理,WindUI提供库支持 如果在脚本使用过程中出现被举报等情况概不负责",
Buttons = {
{
Title = "还是算了吧",
Callback = function() end,
Variant = "Tertiary",
},
{
Title = "我同意",
Icon = "arrow-right",
Callback = function() 
WindUI:Notify({
Title = "SEWH脚本 " .. s_v,
Content = "脚本启动中……",
Duration = 2.5,
Icon = "bird",
})

local Sound = Instance.new("Sound")
Sound.SoundId = "rbxassetid://4590662766"
Sound.Parent = game:GetService("SoundService")
Sound.Volume = 5
Sound:Play()
Sound.Ended:Wait()
Sound:Destroy()

local Window = WindUI:CreateWindow({
Title = "SEWH Script",
Icon = "door-open", -- lucide icon
Author = "By wq_fury",

-- ↓ This all is Optional. You can remove it.
Size = UDim2.fromOffset(580, 460),
MinSize = Vector2.new(50, 30),
MaxSize = Vector2.new(950, 560),
ToggleKey = Enum.KeyCode.LeftShift,
Transparent = true,
Theme = "Dark",
Resizable = true,
SideBarWidth = 200,
BackgroundImageTransparency = 0.72,
HideSearchBar = false,
ScrollBarEnabled = true,

Background = "rbxassetid://84946325310689", -- rbxassetid


-- ↓ Optional. You can remove it.
User = {
Enabled = true,
Anonymous = false,
Callback = function()
print("clicked")
end,
},
})

Window:Tag({
Title = s_v,
Icon = "github",
Color = Color3.fromHex("#30ff6a"),
Radius = 0, -- from 0 to 13
})

Window:Tag({
Title = s_data,
Icon = "history",
Color = Color3.fromHex("#30ff6a"),
Radius = 0, -- from 0 to 13
})

local Tab = Window:Tab({
Title = "公告",
Icon = "bookmark", -- optional
Locked = false,
})

local Code = Tab:Code({
Title = "如果你不喜欢这个版本的ui,欢迎使用另一个ui库的版本(废弃的旧版)",
Code = [[loadstring(game:HttpGet('https://raw.githubusercontent.com/Wqawa/myscripts/refs/heads/main/sewh%E8%84%9A%E6%9C%AC.lua'))()]]
})

local Paragraph = Tab:Paragraph({
Title = "作者 : wq_furry",
Desc = "此脚本完全免费",
Image = "",
ImageSize = 30,
Thumbnail = "",
ThumbnailSize = 80,
Locked = false,
})
local Tab = Window:Tab({Title = "主要功能",Icon = "monitor-check", Locked = false,})

local Toggle = Tab:Toggle({
Title = "反布娃娃",
Desc = "尽可能的不让你进入布娃娃状态，但是很吵…",
Icon = "check",
Type = "Checkbox",
Value = false, -- default value
Callback = function(state) 
local anit_ragroll = nil

if state then
anit_ragroll = task.spawn(function()
while state do
game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("Packets"):WaitForChild("Packet"):WaitForChild("RemoteEvent"):FireServer(buffer.fromstring("\000\000"))
wait(time)
end
end)
else
if anit_ragroll then
task.cancel(anit_ragroll)
anit_ragroll = nil
end
end

end
})


local Button = Tab:Button({
Title = "无限体力(暂不可用)",
Desc = "暂时不知道为什么,可能SEWH修改了",
Locked = false,
Callback = function()
loadstring(game:HttpGet("https://rawscripts.net/raw/UPD-something-evil-will-happen-Inf-stamina-57438"))()
end
})

local Tab = Window:Tab({Title = "键位调整",Icon = "app-window", Locked = false,})

local Button_record = Tab:Button({Title = "查找全部按钮",Desc = "确保全部按钮都出现,仅记录一次",Locked = false,Callback = function()    recordOriginalButtonData() Button_record:Destroy()  end})

local Toggle = Tab:Toggle({
Title = "按键编辑器",
Desc = "控制按钮位置,大小,确保你已经记录过了",
Icon = "check",
Type = "Checkbox",
Value = false, -- default value
Callback = function(state) 
if not state then
exitSelectionMode()
else
enterSelectionMode()
end
end
})

local Button = Tab:Button({Title = "放大20%",Desc = "",Locked = false,Callback = function()    scaleSelectedButton(1.2) end})

local Button = Tab:Button({Title = "缩小20%",Desc = "",Locked = false,Callback = function()    scaleSelectedButton(1/1.2) end})

local Button = Tab:Button({
Title = "重置所有按钮位置/大小",
Desc = "恢复为原始位置",
Locked = false,
Callback = function()
resetAllButtonPositions()
-- 如果编辑模式开启，刷新一下状态
if isSelectionMode then
exitSelectionMode()
enterSelectionMode()
end
end
})


local Tab = Window:Tab({Title = "Esp",Icon = "eye",Locked = true,})



local Tab = Window:Tab({Title = "快捷传送",Icon = "bird",Locked = false,})

local Button = Tab:Button({Title = "圣剑位置",Desc = "圣剑特殊回合",Locked = false,Callback = function() TeleportTo('excalibur') end})
local Button = Tab:Button({Title = "小圣剑位置",Desc = "修饰符回合",Locked = false,Callback = function() TeleportTo('excalibur_jr') end})

Tab:Divider()

local Button = Tab:Button({Title = "随机水缸",Desc = "修饰符回合",Locked = false,Callback = function() TeleportTo('watergang') end})
local Button = Tab:Button({Title = "最近的椅子",Desc = "修饰符回合",Locked = false,Callback = function() TeleportTo('chair') end })

Tab:Divider()

local Button = Tab:Button({Title = "中场",Desc = "高地特殊回合",Locked = false,Callback = function() TeleportTo('the_height' ,-45, 53, -161) end})
local Button = Tab:Button({Title = "光明剑位置",Desc = "高地特殊回合",Locked = false,Callback = function() TeleportTo('the_height' ,-260, 120, -81) end})
local Button = Tab:Button({Title = "黑暗剑位置",Desc = "高地特殊回合",Locked = false,
Callback = function() TeleportTo('the_height' ,-250, 50, 60) end})
local Button = Tab:Button({Title = "风剑位置",Desc = "高地特殊回合",Locked = false,Callback = function() TeleportTo('the_height' ,20, 162, -339) end})
local Button = Tab:Button({Title = "幽灵剑位置",Desc = "高地特殊回合",Locked = false,Callback = function() TeleportTo('the_height' ,240, 65, -160) end})
local Button = Tab:Button({Title = "毒剑位置",Desc = "高地特殊回合",Locked = false,
Callback = function() TeleportTo('the_height' ,104, 39, -79) end})
local Button = Tab:Button({Title = "烈焰剑位置",Desc = "高地特殊回合",Locked = false,Callback = function() TeleportTo('the_height' ,-150, 73, -150) end})
local Button = Tab:Button({Title = "冰剑位置",Desc = "高地特殊回合",Locked = false,Callback = function() TeleportTo('the_height' ,-45, 61, 43) end})

Tab:Divider()

local Button = Tab:Button({Title = "终点",Desc = "淘汰特殊回合(跑酷)",Locked = false,Callback = function() TeleportTo('wipeout') end})

Tab:Divider()

local Button = Tab:Button({Title = "终点",Desc = "滑坡特殊回合",Locked = false,Callback = function() TeleportTo('landslide') end})

Tab:Divider()

local Button = Tab:Button({Title = "回高塔(出生点,办法1)",Desc = "利用客户端函数重置玩家返回",Locked = false,Callback = function() game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("Packets"):WaitForChild("Packet"):WaitForChild("RemoteEvent"):FireServer(buffer.fromstring("`\003")) end})
local Button = Tab:Button({Title = "回高塔(出生点,办法2)",Desc = "传送",Locked = false,Callback = function() TeleportTo(nil ,-35, 100, -442) end})
local Button = Tab:Button({Title = "高塔负二层",Desc = "传送",Locked = false,Callback = function() TeleportTo(nil ,-35, 88, -442) end})


local Tab = Window:Tab({Title = "其他功能",Icon = "cross", Locked = false,})

local Toggle = Tab:Toggle({
Title = "准星",
Desc = "",
Icon = "check",
Type = "Checkbox",
Value = false, -- default value
Callback = function(state) 
CrosshairFrame.Visible = state
end
})

local Button = Tab:Button({
Title = "踏空行走",
Desc = "(额外代码)",
Locked = false,
Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Wqawa/myscripts/refs/heads/main/%E8%B8%8F%E7%A9%BA%E5%B9%B3%E5%8F%B0"))()
end
})
local Input = Tab:Input({
Title = "跳跃高度",
Desc = "顾名思义,就是调你的跳跃高度,但是太大会进入布娃娃,并且地图上方也有销毁哦",
Value = "",
InputIcon = "bird",
Type = "Input", -- or "Textarea"
Placeholder = "输入数字 …",
Callback = function(input) 
game.Players.LocalPlayer.Character.Humanoid.JumpPower = input
end
})

local Tab = Window:Tab({Title = "活动限定",Icon = "bell", Locked = true,})

local Tab = Window:Tab({Title = "敬请期待",Icon = "clock", Locked = true,})


wait(0.1)
game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("Packets"):WaitForChild("Packet"):WaitForChild("RemoteEvent"):FireServer(buffer.fromstring("`\003"))



local VirtualInputManager = game:GetService("VirtualInputManager")

-- 等待按钮路径完全加载
local playButton = playerGui:WaitForChild("TitleScreen")
playButton = playButton:WaitForChild("Screens")
playButton = playButton:WaitForChild("Main")
playButton = playButton:WaitForChild("MainArea")
playButton = playButton:WaitForChild("MainButtons")
playButton = playButton:WaitForChild("PlayButton")

-- 确保按钮已渲染（有时 AbsolutePosition 在下一帧才更新）
wait(0.5)

local absPos = playButton.AbsolutePosition
local absSize = playButton.AbsoluteSize

-- 计算按钮中心坐标
local centerX = absPos.X + absSize.X / 2
local centerY = absPos.Y + absSize.Y / 2

-- 模拟鼠标左键按下和释放
VirtualInputManager:SendMouseButtonEvent(centerX, centerY+50, 0, true, nil, 0)   -- 按下
wait(0.05)
VirtualInputManager:SendMouseButtonEvent(centerX, centerY+50, 0, false, nil, 0)  -- 释放



end,
Variant = "Primary",
}
}


})



