local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Wqawa/myscripts/refs/heads/main/windUI%20main.lua"))()

local scriptVersion = "v 0.31 rework p1"
local scriptDate = "2026/7/15"

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if tostring(game.PlaceId) == "16991287194" then

--载入功能
local selectedEmote = "KontonBoogie" --你怎么知道我最喜欢的是混沌布吉？？(占位符)

--按钮路径
local touchButtonPaths = {
{ path = {"TouchGui", "TouchControlFrame", "JumpButton"}, name = "JumpButton" },
{ path = {"TouchCore", "TouchControls", "AltUseButton"}, name = "AltUseButton" },
{ path = {"TouchCore", "TouchControls", "LockButton"}, name = "LockButton" },
{ path = {"TouchCore", "TouchControls", "EmoteButton"}, name = "EmoteButton" },
{ path = {"TouchCore", "TouchControls", "SprintButton"}, name = "SprintButton" },
{ path = {"TouchCore", "TouchControls", "UseButton"}, name = "UseButton" },
}

--背包内容黑名单
local LIMB_NAMES = {
"Head", "Torso", "Left Arm", "Right Arm",
"Left Leg", "Right Leg", "HumanoidRootPart",
"CharacterLengthBox",
"Sleigh", "broom", "Model", "JeepCar", "boombox",
"Stuff", "Recorder", "Potion", "Props", "prop", "skeleton"
}

--================================================================================================================================
--音效模块
--================================================================================================================================

local function playSound(v)
local Sound = Instance.new("Sound")
Sound.SoundId = "rbxassetid://4590662766"
Sound.Parent = game:GetService("SoundService")
Sound.Volume = v
Sound:Play()
Sound.Ended:Wait()
Sound:Destroy()
end

--================================================================================================================================
--解析模块(下属传送模块,fog灾难查找需要)
--================================================================================================================================

local function getModelCFrame(model)
if model:IsA("BasePart") then
return model.CFrame
end
if model:IsA("Model") then
if model.PrimaryPart then
return model.PrimaryPart.CFrame
end
for _, child in ipairs(model:GetDescendants()) do
if child:IsA("BasePart") then
return child.CFrame
end
end
end
return nil
end

local function getAllFogLamps()
local mapObjects = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Objects")
if not mapObjects then return {} end

local lamps = {}
for _, child in ipairs(mapObjects:GetChildren()) do
if child.Name:find("FogLamp") then
table.insert(lamps, child)
end
end
return lamps
end

--================================================================================================================================
--翻译模块(BY yore)
--================================================================================================================================
-- 翻译加载器：每次注入对比远程与本地，不同则自动更新，并用 WindUI 通知状态
local function loadTranslation(url, cacheFileName)
local localContent = nil
local hasLocal = pcall(function() localContent = readfile("SEWH Script/" .. cacheFileName) end)
local localStr = hasLocal and localContent or nil

local function notify(msg, icon)
icon = icon or "info"
WindUI:Notify({
Title = "翻译缓存",
Content = msg,
Duration = 2.5,
Icon = icon,
})
playSound(5)
end

local networkOk, remoteContent = pcall(game.HttpGet, game, url)
if networkOk and remoteContent and remoteContent ~= "" then
if localStr == remoteContent then
-- 内容一致，直接加载本地
print("[SEWH 翻译] 远程与本地一致，加载本地缓存:", cacheFileName)
notify("远程与本地一致，加载本地缓存: " .. cacheFileName, "check")
local ok, result = pcall(loadstring, localStr)
if ok and result then
return result()
else
print("[SEWH 翻译 报错] 本地缓存解析失败，尝试加载远程")
notify("本地缓存损坏，尝试加载远程", "warning")
local ok2, result2 = pcall(loadstring, remoteContent)
if ok2 and result2 then
pcall(function() writefile("SEWH Script/" .. cacheFileName, remoteContent) end)
return result2()
end
end
else
-- 内容不一致，自动下载覆盖
print("[SEWH 翻译] 远程内容已更新，下载并覆盖缓存:", cacheFileName)
notify("远程内容已更新，自动下载: " .. cacheFileName, "download")
pcall(function()
makefolder("SEWH Script")
writefile("SEWH Script/" .. cacheFileName, remoteContent)
end)
local ok, result = pcall(loadstring, remoteContent)
if ok and result then
return result()
else
print("[SEWH 翻译 报错] 远程内容解析失败，尝试本地缓存")
notify("远程内容解析失败，尝试本地缓存", "error")
end
end
else
print("[SEWH 翻译] 网络请求失败，尝试读取本地缓存")
notify("网络请求失败，尝试读取本地缓存", "warning")
end

-- 网络失败或远程不可用，使用本地缓存
if localStr and localStr ~= "" then
local ok, result = pcall(loadstring, localStr)
if ok and result then
print("[SEWH 翻译] 加载本地缓存成功:", cacheFileName)
notify("加载本地缓存成功: " .. cacheFileName, "check")
return result()
else
print("[SEWH 翻译 报错] 本地缓存解析失败")
notify("本地缓存解析失败", "error")
end
end

print("[SEWH 翻译] 无法加载翻译，使用空表")
notify("无法加载翻译，将显示原始名称", "error")
return {}
end

itemTranslations = loadTranslation(
"https://raw.githubusercontent.com/Yore-Clouds/SEWH_Translation/refs/heads/main/items_translation.lua",
"items_translation.lua"
)

emoteTranslations = loadTranslation(
"https://raw.githubusercontent.com/Yore-Clouds/SEWH_Translation/refs/heads/main/emotes_translation.lua",
"emotes_translation.lua"
)

--================================================================================================================================
--背包内容模块
--================================================================================================================================
local itemColorRules = {

{ keywords = {"Banana Peel", "Beartrap", "Bloxilicious Bubblegum", "Body Swap Potion", "Car Keys", "Crowbar", "Detonator", "Dynamite", "Exploding Pie" ,"Gear Suppressor", "Molotov", "RAIG Table", "Shrink Ray", "Slap Hand", "Snowball", "Stroller", "Stun Gun", "Subspace Tripmine", "Superball", "Timebomb", "Triple Kunai", "Vine Staff", "Water Balloon", "Witches Brew", "Wooden Sword","Breath of Ice","Excalibur", "Excalibur Jr", "Knife"}, color = Color3.new(1, 0, 0) },

{ keywords = {"Celestial Staff", "Epic Brew", "Teddy Bloxpin", "Deck O\' Cards", "Gravity Pad", "Speed Pad", "Crowbar"}, color = Color3.new(1, 0.85, 0) },

{ keywords = {"Beast Scythe", "Bugle of Inspiration", "Epic Mine Pwner", "Fire Extinguisher", "Necrobloxicon", "Staff of Healing", "Stratobloxxer", "Teapot Turret", "Trowel", "Candy Bucket", "Golden Egg", "Midas Spork"}, color = Color3.new(0, 1, 0) },

{ keywords = {"Revolver"}, color = Color3.new(0, 0, 1) }
}


local function getItemColor(itemName)
for _, rule in ipairs(itemColorRules) do
for _, keyword in ipairs(rule.keywords) do
if string.find(itemName, keyword, 1, true) then
return rule.color
end
end
end
return Color3.new(1, 1, 1)
end


local function translateItemName(name)
return itemTranslations[name] or name
end

local function isExcluded(item)
for _, name in ipairs(LIMB_NAMES) do
if item.Name == name then return true end
end
return false
end

local function getAttachPart(item)
if item:IsA("BasePart") then return item end
if item:IsA("Model") then
local primary = item.PrimaryPart
if primary then return primary end
for _, child in ipairs(item:GetChildren()) do
if child:IsA("BasePart") then return child end
end
end
return nil
end

local function createItemTag(item, targetPlayer)
if targetPlayer == player then return nil end
if isExcluded(item) then return nil end
local part = getAttachPart(item)
if not part then return nil end
if part:FindFirstChild("ItemNameTag") then return nil end

local tag = Instance.new("BillboardGui")
tag.Name = "ItemNameTag"
tag.Size = UDim2.new(0, 120, 0, 24)
tag.StudsOffset = Vector3.new(0, 1.5, 0)
tag.AlwaysOnTop = true

local label = Instance.new("TextLabel")
label.Name = "Label"
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.TextScaled = true
label.TextColor3 = getItemColor(item.Name)
label.TextStrokeTransparency = 0.5
label.Text = translateItemName(item.Name)
label.Parent = tag

tag.Parent = part
return tag
end

local function removeItemTag(item)
local part = getAttachPart(item)
if part then
local tag = part:FindFirstChild("ItemNameTag")
if tag then tag:Destroy() end
end
end

local function updateHeadSummary(targetPlayer)
if targetPlayer == player then return end
local char = targetPlayer.Character
if not char then return end
local head = char:FindFirstChild("Head")
if not head then return end


local oldTag = head:FindFirstChild("BackpackSummary")
if oldTag then oldTag:Destroy() end

local items = targetPlayer.Backpack:GetChildren()
if #items == 0 then return end


local tag = Instance.new("BillboardGui")
tag.Name = "BackpackSummary"
tag.Size = UDim2.new(0, 150, 0, 30)
tag.StudsOffset = Vector3.new(0, 6, 0)
tag.AlwaysOnTop = true
tag.Parent = head

local bg = Instance.new("Frame")
bg.Name = "Background"
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.new(0, 0, 0)
bg.BackgroundTransparency = 0.5
bg.BorderSizePixel = 0
bg.Parent = tag

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.Padding = UDim.new(0, 2)
layout.Parent = bg

for _, item in ipairs(items) do
local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0, 16)
label.BackgroundTransparency = 1
label.TextScaled = true
label.TextColor3 = getItemColor(item.Name)
label.TextStrokeTransparency = 0.5
label.Text = translateItemName(item.Name)
label.Parent = bg
end


local totalHeight = 4 + #items * 18
tag.Size = UDim2.new(0, 150, 0, totalHeight)
end

local function refreshWorkspaceTags(targetPlayer)
if targetPlayer == player then return end
local container = workspace:FindFirstChild(targetPlayer.Name)
if not container then return end
for _, child in ipairs(container:GetChildren()) do
createItemTag(child, targetPlayer)
end
end

local allConnections = {}
local enabled = false
local loopRunning = false
local loopThread = nil

local function trackConnection(conn)
table.insert(allConnections, conn)
return conn
end

local function cleanupAllTags()
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= player then
local char = plr.Character
if char then
local head = char:FindFirstChild("Head")
if head then
local tag = head:FindFirstChild("BackpackSummary")
if tag then tag:Destroy() end
end
end
end
end
for _, container in ipairs(workspace:GetChildren()) do
if container:IsA("Model") then
for _, child in ipairs(container:GetDescendants()) do
if child.Name == "ItemNameTag" then
child:Destroy()
end
end
end
end
end

local function startLoop()
if loopRunning then return end
loopRunning = true
loopThread = task.spawn(function()
while loopRunning do
task.wait(0.1)
if not enabled then break end
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= player then
updateHeadSummary(plr)
refreshWorkspaceTags(plr)
end
end
end
loopRunning = false
loopThread = nil
end)
end

local function stopLoop()
if loopThread then
loopRunning = false
task.cancel(loopThread)
loopThread = nil
end
end

local function setupPlayer(targetPlayer)
if targetPlayer == player then
trackConnection(targetPlayer.Backpack.ChildAdded:Connect(function() end))
trackConnection(targetPlayer.Backpack.ChildRemoved:Connect(function() end))
return
end

local containerConns = {}
local function watchWorkspace()
for _, c in ipairs(containerConns) do
c:Disconnect()
for i = #allConnections, 1, -1 do
if allConnections[i] == c then table.remove(allConnections, i) end
end
end
containerConns = {}
local container = workspace:FindFirstChild(targetPlayer.Name)
if not container then return end

local c1 = container.ChildAdded:Connect(function(child)
createItemTag(child, targetPlayer)
end)
local c2 = container.ChildRemoved:Connect(function(child)
removeItemTag(child)
end)
table.insert(containerConns, c1)
table.insert(containerConns, c2)
trackConnection(c1)
trackConnection(c2)
refreshWorkspaceTags(targetPlayer)
end

local wsAdded = workspace.ChildAdded:Connect(function(child)
if child.Name == targetPlayer.Name then watchWorkspace() end
end)
trackConnection(wsAdded)

watchWorkspace()
for _, c in ipairs(containerConns) do trackConnection(c) end

local c3 = targetPlayer.Backpack.ChildAdded:Connect(function()
updateHeadSummary(targetPlayer)
end)
local c4 = targetPlayer.Backpack.ChildRemoved:Connect(function()
updateHeadSummary(targetPlayer)
end)
trackConnection(c3)
trackConnection(c4)

local c5 = targetPlayer.CharacterAdded:Connect(function(char)
task.spawn(function()
local head = char:WaitForChild("Head", 3)
local humanoid = char:WaitForChild("Humanoid", 3)
if head and humanoid then
task.wait(0.1)
updateHeadSummary(targetPlayer)
refreshWorkspaceTags(targetPlayer)
end
end)
end)
trackConnection(c5)

task.spawn(updateHeadSummary, targetPlayer)
end

function initBackpackDisplay(enable)
if enable == enabled then return end
enabled = enable
if enable then
for _, plr in ipairs(Players:GetPlayers()) do setupPlayer(plr) end
local paConn = Players.PlayerAdded:Connect(function(plr) setupPlayer(plr) end)
trackConnection(paConn)
startLoop()
else
for _, conn in ipairs(allConnections) do conn:Disconnect() end
allConnections = {}
stopLoop()
cleanupAllTags()
end
end

--================================================================================================================================
--表情模块
--================================================================================================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EmoteStorage = require(ReplicatedStorage.Resources.Information.Shop.EmoteStorage)
local allEmotes = EmoteStorage.getAllEmotes()

local allEmoteIds = {}
for id, _ in pairs(allEmotes) do
table.insert(allEmoteIds, id)
end
table.sort(allEmoteIds)

local displayNames = {}
local displayToId = {} 
for _, id in ipairs(allEmoteIds) do
local display = emoteTranslations[id] or id 
table.insert(displayNames, display)
displayToId[display] = id
end

table.sort(displayNames)

local EmoteHandler = require(ReplicatedStorage.Resources.Client.EmoteHandler)


--================================================================================================================================
--反布娃娃模块
--================================================================================================================================

local function initAntiRagdoll()
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

local function waitForModules()
local bodyTrauma, ragdollClient = nil, nil
local startTime = tick()
repeat
task.wait(0.2)
local resources = replicatedStorage:FindFirstChild("Resources")
if resources then
local client = resources:FindFirstChild("Client")
if client then
local bt = client:FindFirstChild("BodyTrauma")
if bt then
local rc = bt:FindFirstChild("RagdollClient")
if rc then
bodyTrauma = require(bt)
ragdollClient = require(rc)
end
end
end
end
until (bodyTrauma and ragdollClient) or (tick() - startTime > 10)
return bodyTrauma, ragdollClient
end

local bodyTrauma, ragdollClient = waitForModules()
if not bodyTrauma or not ragdollClient then
return { setEnabled = function() end }
end

if not _G._antiRagdoll_original then
_G._antiRagdoll_original = {
ragdoll = bodyTrauma.Ragdoll,
unragdoll = bodyTrauma.Unragdoll,
bounce = bodyTrauma.Bounce,
}
end

local noop = function() end
local enabled = false
local heartbeatConn = nil

local function forceUnragdoll()
if ragdollClient.ragdolled then
local char = player.Character
if char then
local humanoid = char:FindFirstChild("Humanoid")
if humanoid and humanoid.Health > 0 then
humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
local movementHandler = require(replicatedStorage.Resources.Client.MovementHandler)
if movementHandler then
pcall(movementHandler.RemoveDisabler, "RagdolledNoSprint")
pcall(movementHandler.RemoveDisabler, "RagdolledNoSit")
pcall(movementHandler.RemoveDisabler, "RagdolledNoSwim")
end
local visual = require(replicatedStorage.Resources.Client.BodyTrauma.RagdollInfluenceVisual)
if visual then pcall(visual.Disconnect) end
ragdollClient.ragdolled = false
if ragdollClient.ragdollSignal then
ragdollClient.ragdollSignal:Fire(false)
end
end
end
end
end

local function clearSemiStun()
if not enabled then return end
game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("Packets"):WaitForChild("Packet"):WaitForChild("RemoteEvent"):FireServer(buffer.fromstring("\000\000"))
end

local function setEnabled(state)
enabled = state
if enabled then
bodyTrauma.Ragdoll = noop
bodyTrauma.Unragdoll = noop
bodyTrauma.Bounce = noop
forceUnragdoll()
if heartbeatConn then heartbeatConn:Disconnect() end
heartbeatConn = runService.Heartbeat:Connect(clearSemiStun)
else
local orig = _G._antiRagdoll_original
bodyTrauma.Ragdoll = orig.ragdoll
bodyTrauma.Unragdoll = orig.unragdoll
bodyTrauma.Bounce = orig.bounce
if heartbeatConn then heartbeatConn:Disconnect(); heartbeatConn = nil end
end
end

return { setEnabled = setEnabled }
end

local function initAntiFall()
local replicatedStorage = game:GetService("ReplicatedStorage")

local function waitForBodyTrauma()
local bodyTrauma = nil
local startTime = tick()
repeat
task.wait(0.2)
local resources = replicatedStorage:FindFirstChild("Resources")
if resources then
local client = resources:FindFirstChild("Client")
if client then
local bt = client:FindFirstChild("BodyTrauma")
if bt then
bodyTrauma = require(bt)
end
end
end
until bodyTrauma or (tick() - startTime > 10)
return bodyTrauma
end

local bodyTrauma = waitForBodyTrauma()
if not bodyTrauma then
return { setEnabled = function() end }
end

if not _G._antiFall_original then
_G._antiFall_original = bodyTrauma.Fall
end

local noop = function() end
local enabled = false

local function setEnabled(state)
enabled = state
if enabled then
bodyTrauma.Fall = noop
else
bodyTrauma.Fall = _G._antiFall_original
end
end

return { setEnabled = setEnabled }
end

local antiRagdollHandler = initAntiRagdoll()
local antiFallHandler = initAntiFall()




--================================================================================================================================
--传送模块
--================================================================================================================================

local function teleportTo(Map , x, y, z)
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

if Map == 'fog' then
local lamps = getAllFogLamps()
if #lamps == 0 then
return
end

local target = lamps[math.random(1, #lamps)]
local targetCF = getModelCFrame(target)
if not targetCF then
return
end

local char = player.Character
if char then
local root = char:FindFirstChild("HumanoidRootPart")
if root then
root.CFrame = targetCF
end
end
end

if Map == nil then
rootPart.CFrame = targetCFrame
end

return true
end


--================================================================================================================================
--自定义按键模块
--================================================================================================================================

local UserInputService = game:GetService("UserInputService")


local touchButtonData = {}
local selectedButtonName = nil
local originalDataRecorded = false

local function recordOriginalButtonData()
if originalDataRecorded then return end

for _, info in ipairs(touchButtonPaths) do
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

local originalPosition = obj.Position
local originalSize = obj.Size

touchButtonData[info.name] = {
object = obj,
isImageButton = isImage,
originalColor = origColor,
originalTransparency = origTrans,
originalActive = origActive,
originalPosition = originalPosition,
originalSize = originalSize,
}
else
end
end
originalDataRecorded = true
end

local function setButtonHighlight(name, enable)
local data = touchButtonData[name]
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
local data = touchButtonData[name]
if data and data.object:IsA("GuiButton") then
data.object.Active = active
end
end

local function clearAllHighlights()
if selectedButtonName then
setButtonHighlight(selectedButtonName, false)
selectedButtonName = nil
end
end



function scaleSelectedButton(factor)
if not selectedButtonName then return end
local data = touchButtonData[selectedButtonName]
if not data then return end
local btn = data.object
local curSizeX = btn.Size.X.Offset
local curSizeY = btn.Size.Y.Offset
local newX = math.max(10, curSizeX * factor)
local newY = math.max(10, curSizeY * factor)
btn.Size = UDim2.new(btn.Size.X.Scale, newX, btn.Size.Y.Scale, newY)
end

local selectionModeActive = false


local function enterSelectionMode()
selectionModeActive = true
clearAllHighlights()
for name, _ in pairs(touchButtonData) do
setButtonActive(name, false)
end

end

local function exitSelectionMode()
selectionModeActive = false
clearAllHighlights()
for name, data in pairs(touchButtonData) do
if data.object:IsA("GuiButton") then
data.object.Active = data.originalActive
end
end
resetGestureState()

end

local function isInside(guiObject, position)
local absPos = guiObject.AbsolutePosition
local absSize = guiObject.AbsoluteSize
return position.X >= absPos.X and position.X <= absPos.X + absSize.X
and position.Y >= absPos.Y and position.Y <= absPos.Y + absSize.Y
end

local function getButtonUnderPosition(pos)
for name, data in pairs(touchButtonData) do
if isInside(data.object, pos) then
return name
end
end
return nil
end

local function toVector2(vec3)
return Vector2.new(vec3.X, vec3.Y)
end

local dragTouchId = nil
local dragStartPosition = nil
local dragStartOffset = nil

local pinchTouchMap = {}
local pinchInitialDistance = nil
local pinchStartSize = nil
local pinchStartPosition = nil

function resetGestureState()
dragTouchId = nil
dragStartPosition = nil
dragStartOffset = nil
pinchTouchMap = {}
pinchInitialDistance = nil
pinchStartSize = nil
pinchStartPosition = nil
end

local function resetAllButtonPositions()
for name, data in pairs(touchButtonData) do
local btn = data.object
if btn then
btn.Position = data.originalPosition
btn.Size = data.originalSize
end
end
if selectedButtonName then
setButtonHighlight(selectedButtonName, false)
selectedButtonName = nil
end
WindUI:Notify({
Title = "按键重置",
Content = "所有按钮已恢复原始位置和大小",
Duration = 2,
Icon = "check",
})
end

local function startDrag(touchId, touchPos)
local btn = touchButtonData[selectedButtonName].object
dragTouchId = touchId
dragStartPosition = toVector2(touchPos)
dragStartOffset = Vector2.new(btn.Position.X.Offset, btn.Position.Y.Offset)
pinchTouchMap = {}
pinchInitialDistance = nil
end

local function startPinch(t1, t2, pos1, pos2)
local btn = touchButtonData[selectedButtonName].object
pinchTouchMap[t1] = toVector2(pos1)
pinchTouchMap[t2] = toVector2(pos2)
pinchInitialDistance = (toVector2(pos1) - toVector2(pos2)).Magnitude
pinchStartSize = Vector2.new(btn.Size.X.Offset, btn.Size.Y.Offset)
pinchStartPosition = Vector2.new(btn.Position.X.Offset, btn.Position.Y.Offset)
dragTouchId = nil
dragStartPosition = nil
end

local function updateDrag(touchPos)
local btn = touchButtonData[selectedButtonName].object
local delta = toVector2(touchPos) - dragStartPosition
local newX = dragStartOffset.X + delta.X
local newY = dragStartOffset.Y + delta.Y
btn.Position = UDim2.new(btn.Position.X.Scale, newX, btn.Position.Y.Scale, newY)
end

local function updatePinch(pos1, pos2)
local btn = touchButtonData[selectedButtonName].object
local p1 = toVector2(pos1)
local p2 = toVector2(pos2)
local currentDist = (p1 - p2).Magnitude
if pinchInitialDistance <= 0 then return end
local scale = currentDist / pinchInitialDistance

local newSizeX = math.max(10, pinchStartSize.X * scale)
local newSizeY = math.max(10, pinchStartSize.Y * scale)

local parentAbsPos = btn.Parent.AbsolutePosition
local center = (p1 + p2) / 2 - Vector2.new(parentAbsPos.X, parentAbsPos.Y)

local newOffsetX = center.X - newSizeX / 2
local newOffsetY = center.Y - newSizeY / 2

btn.Size = UDim2.new(btn.Size.X.Scale, newSizeX, btn.Size.Y.Scale, newSizeY)
btn.Position = UDim2.new(btn.Position.X.Scale, newOffsetX, btn.Position.Y.Scale, newOffsetY)
end

UserInputService.TouchStarted:Connect(function(touch, gameProcessed)
if not selectionModeActive then return end

local btnName = getButtonUnderPosition(touch.Position)

if btnName then
if btnName == selectedButtonName then
if not dragTouchId and next(pinchTouchMap) == nil then
startDrag(touch, touch.Position)
end
else
clearAllHighlights()
selectedButtonName = btnName
setButtonHighlight(btnName, true)

resetGestureState()
startDrag(touch, touch.Position)
end
else

return
end

if selectedButtonName and dragTouchId and btnName == selectedButtonName then
if touch ~= dragTouchId and isInside(touchButtonData[selectedButtonName].object, touch.Position) then
pinchTouchMap[touch] = toVector2(touch.Position)
if pinchTouchMap[dragTouchId] then
startPinch(dragTouchId, touch, pinchTouchMap[dragTouchId], touch.Position)
end
end
end
end)

UserInputService.TouchMoved:Connect(function(touch, gameProcessed)
if not selectionModeActive or not selectedButtonName then return end

if pinchTouchMap[touch] then
pinchTouchMap[touch] = toVector2(touch.Position)
end

if dragTouchId == touch then
if next(pinchTouchMap) then
local otherTouch = nil
for tid, pos in pairs(pinchTouchMap) do
if tid ~= touch then otherTouch = tid; break end
end
if otherTouch and isInside(touchButtonData[selectedButtonName].object, touch.Position) and isInside(touchButtonData[selectedButtonName].object, pinchTouchMap[otherTouch]) then
startPinch(touch, otherTouch, touch.Position, pinchTouchMap[otherTouch])
return
end
end
updateDrag(touch.Position)
end

if pinchTouchMap[touch] and next(pinchTouchMap) then
local ids = {}
for tid, pos in pairs(pinchTouchMap) do
table.insert(ids, tid)
end
if #ids == 2 then
updatePinch(pinchTouchMap[ids[1]], pinchTouchMap[ids[2]])
end
end
end)

UserInputService.TouchEnded:Connect(function(touch, gameProcessed)
if not selectionModeActive then return end

if dragTouchId == touch then
dragTouchId = nil
dragStartPosition = nil
end
if pinchTouchMap[touch] then
pinchTouchMap[touch] = nil
if next(pinchTouchMap) == nil then
pinchInitialDistance = nil
else
for tid, pos in pairs(pinchTouchMap) do
startDrag(tid, pos)
break
end
end
end
end)

--================================================================================================================================
--透视模块
--================================================================================================================================
local function initPerspective()
local RunService = game:GetService("RunService")
local enabled = false
local highlights = {}
local loopThread = nil

local function hasWeapon(plr, name)
local lower = name:lower()
local bp = plr:FindFirstChild("Backpack")
local char = plr.Character
if bp then
for _, c in ipairs(bp:GetChildren()) do
if c.Name:lower() == lower then return true end
end
end
if char then
for _, c in ipairs(char:GetChildren()) do
if c.Name:lower() == lower then return true end
end
end
return false
end

local function addHighlight(plr)
local char = plr.Character
if not char or not char.Parent then return end
if highlights[plr] then return end
local h = Instance.new("Highlight")
h.OutlineTransparency = 1
h.Parent = char
highlights[plr] = h
end

local function removeHighlight(plr)
local h = highlights[plr]
if h then h:Destroy(); highlights[plr] = nil end
end

local function clearAll()
for plr, _ in pairs(highlights) do removeHighlight(plr) end
end

local function applyAll()
for _, plr in ipairs(Players:GetPlayers()) do addHighlight(plr) end
end

local function updateColors()
if not enabled then return end
for plr, h in pairs(highlights) do
if hasWeapon(plr, "knife") then
h.FillColor = Color3.new(1, 0, 0)
elseif hasWeapon(plr, "excalibur") or hasWeapon(plr, "excalibur jr.") then
h.FillColor = Color3.new(1, 0.84, 0) 
elseif hasWeapon(plr, "revolver") then
h.FillColor = Color3.new(0, 0, 1)
else
h.FillColor = Color3.new(0, 1, 0)
end
end
end

local function startLoop()
if loopThread then return end
loopThread = task.spawn(function()
while enabled do
task.wait(0.1)
if enabled then updateColors() end
end
loopThread = nil
end)
end

local function stopLoop()
if loopThread then task.cancel(loopThread); loopThread = nil end
end

local function setEnabled(state)
enabled = state
if enabled then
clearAll()
applyAll()
startLoop()
else
stopLoop()
clearAll()
end
end

local function onPlayerAdded(plr)
plr.CharacterAdded:Connect(function(char)
if enabled then
removeHighlight(plr)
addHighlight(plr)
end
end)
if enabled and plr.Character then addHighlight(plr) end
end

for _, plr in ipairs(Players:GetPlayers()) do onPlayerAdded(plr) end
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(removeHighlight)

player.CharacterAdded:Connect(function(char)
if enabled then
removeHighlight(player)
addHighlight(player)
end
end)

return { setEnabled = setEnabled }
end

local perspectiveHandler = initPerspective()

local tripmineLocator = (function()
local TAG_NAME = "TripmineLocator"
local TAG_TEXT = "⚠ 子空间地雷"
local TEXT_COLOR = Color3.new(0.7, 0.2, 1)
local TEXT_TRANSPARENCY = 0.5
local OFFSET = Vector3.new(0, 3, 0)

local enabled = false
local activeTags = {}
local connections = {}

local function createTag(part)
if not part or not part:IsA("BasePart") then return end
if part:FindFirstChild(TAG_NAME) then return end

local billboard = Instance.new("BillboardGui")
billboard.Name = TAG_NAME
billboard.Size = UDim2.new(0, 80, 0, 16)
billboard.StudsOffset = OFFSET
billboard.AlwaysOnTop = true
billboard.Adornee = part
billboard.Parent = part

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = TAG_TEXT
label.TextColor3 = TEXT_COLOR
label.TextTransparency = TEXT_TRANSPARENCY
label.TextScaled = false
label.TextSize = 12
label.TextStrokeTransparency = 0.3
label.TextStrokeColor3 = Color3.new(0, 0, 0)
label.Font = Enum.Font.GothamBold
label.Parent = billboard

table.insert(activeTags, billboard)
return billboard
end

local function removeTag(part)
local tag = part:FindFirstChild(TAG_NAME)
if tag then
tag:Destroy()
for i = #activeTags, 1, -1 do
if activeTags[i] == tag then
table.remove(activeTags, i)
break
end
end
end
end

local function clearAllTags()
for _, tag in ipairs(activeTags) do
tag:Destroy()
end
activeTags = {}
end

local function getAllTripmines(container)
local results = {}
if not container then return results end

for _, child in ipairs(container:GetChildren()) do
if child.Name == "Tripmine" and child:IsA("BasePart") then
table.insert(results, child)
end
if child:IsA("Model") then
for _, sub in ipairs(child:GetDescendants()) do
if sub.Name == "Tripmine" and sub:IsA("BasePart") then
table.insert(results, sub)
end
end
end
end
return results
end

local function scanAndApply()
local placeables = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Placeables")
if not placeables then return end

local tripmines = getAllTripmines(placeables)
for _, part in ipairs(tripmines) do
createTag(part)
end
end

local function watchTripmines()
local placeables = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Placeables")
if not placeables then return end

local conn = placeables.ChildAdded:Connect(function(child)
if not enabled then return end

if child:IsA("BasePart") and child.Name == "Tripmine" then
createTag(child)
return
end

if child:IsA("Model") then
for _, sub in ipairs(child:GetDescendants()) do
if sub.Name == "Tripmine" and sub:IsA("BasePart") then
createTag(sub)
end
end
local descConn = child.DescendantAdded:Connect(function(sub)
if enabled and sub.Name == "Tripmine" and sub:IsA("BasePart") then
createTag(sub)
end
end)
table.insert(connections, descConn)
end
end)
table.insert(connections, conn)

for _, child in ipairs(placeables:GetChildren()) do
if child:IsA("Model") then
local descConn = child.DescendantAdded:Connect(function(sub)
if enabled and sub.Name == "Tripmine" and sub:IsA("BasePart") then
createTag(sub)
end
end)
table.insert(connections, descConn)
end
end
end

local function setEnabled(state)
if state == enabled then return end
enabled = state

if enabled then
scanAndApply()
watchTripmines()
else
for _, conn in ipairs(connections) do
conn:Disconnect()
end
connections = {}
clearAllTags()
end
end

local function onMapReset()
if enabled then
for _, conn in ipairs(connections) do
conn:Disconnect()
end
connections = {}
clearAllTags()
scanAndApply()
watchTripmines()
end
end

local function watchPlaceables()
local map = workspace:FindFirstChild("Map")
if not map then return end

local conn = map.ChildAdded:Connect(function(child)
if child.Name == "Placeables" then
onMapReset()
end
end)
table.insert(connections, conn)

local conn2 = map.ChildRemoved:Connect(function(child)
if child.Name == "Placeables" and enabled then
clearAllTags()
for _, c in ipairs(connections) do
c:Disconnect()
end
connections = {}
end
end)
table.insert(connections, conn2)
end

watchPlaceables()

return { setEnabled = setEnabled }
end)()


--================================================================================================================================
--其他模块
--================================================================================================================================

local crosshairGui = Instance.new("ScreenGui")
crosshairGui.Name = "CrosshairGui"
crosshairGui.Parent = playerGui
crosshairGui.ResetOnSpawn = false
crosshairGui.IgnoreGuiInset = true

local crosshairFrame = Instance.new("Frame")
crosshairFrame.Name = "Crosshair"
crosshairFrame.Parent = crosshairGui
crosshairFrame.Size = UDim2.new(0, 30, 0, 30)
crosshairFrame.Position = UDim2.new(0.5, -15, 0.5, -15)
crosshairFrame.BackgroundTransparency = 1
crosshairFrame.Visible = false

local horizontalLine = Instance.new("Frame")
horizontalLine.Parent = crosshairFrame
horizontalLine.Size = UDim2.new(1, 0, 0, 2)
horizontalLine.Position = UDim2.new(0, 0, 0.5, -1)
horizontalLine.BackgroundColor3 = Color3.new(1,1,1)
horizontalLine.BorderSizePixel = 0

local verticalLine = Instance.new("Frame")
verticalLine.Parent = crosshairFrame
verticalLine.Size = UDim2.new(0, 2, 1, 0)
verticalLine.Position = UDim2.new(0.5, -1, 0, 0)
verticalLine.BackgroundColor3 = Color3.new(1,1,1)
verticalLine.BorderSizePixel = 0

local dotFrame = Instance.new("Frame")
dotFrame.Parent = crosshairFrame
dotFrame.Size = UDim2.new(0, 6, 0, 6)
dotFrame.Position = UDim2.new(0.5, -3, 0.5, -3)
dotFrame.BackgroundColor3 = Color3.new(1,1,1)
dotFrame.BorderSizePixel = 0
local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1,0)
dotCorner.Parent = dotFrame







--加载UI

WindUI:Popup({
Title = "注意!!",
Icon = "info",
Content = "这个脚本由Deepseek编写主要代码, wq整理, WindUI提供库支持; 如果在脚本使用过程中出现被举报封号等情况, 我概不负责",
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
Title = "SEWH脚本 " .. scriptVersion,
Content = "脚本启动中……",
Duration = 2.5,
Icon = "bird",
})

playSound(5)

local Window = WindUI:CreateWindow({
Title = "SEWH Script",
Icon = "door-open",
Author = "By wq",

Size = UDim2.fromOffset(580, 300),
MinSize = Vector2.new(50, 30),
MaxSize = Vector2.new(950, 560),
ToggleKey = Enum.KeyCode.LeftShift,
Transparent = true,
Theme = "Dark",
Resizable = true,
SideBarWidth = 200,
BackgroundImageTransparency = 0.85,
HideSearchBar = false,
ScrollBarEnabled = true,

Background = "rbxassetid://84946325310689", -- rbxassetid


User = {
Enabled = true,
Anonymous = false,
Callback = function()
print("clicked")
end,
},
})

Window:EditOpenButton({
Title = "SEWH Script",
Icon = "monitor",
CornerRadius = UDim.new(0,16),
StrokeThickness = 2,
Color = ColorSequence.new( 
Color3.fromHex("FF2200"), 
Color3.fromHex("00FF9E")
),
OnlyMobile = false,
Enabled = true,
Draggable = true,
})

Window:Tag({
Title = scriptVersion,
Icon = "github",
Color = Color3.fromHex("#30ff6a"),
Radius = 0, 
})

Window:Tag({
Title = scriptDate,
Icon = "history",
Color = Color3.fromHex("#30ff6a"),
Radius = 0, 
})

local Tab = Window:Tab({
Title = "公告",
Icon = "bookmark", 
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

local Paragraph = Tab:Paragraph({
Title = "动作&物品 译: Yore",
Desc = "可能含有多种奇葩翻译",
Image = "",
ImageSize = 30,
Thumbnail = "",
ThumbnailSize = 80,
Locked = false,
})

local Tab = Window:Tab({Title = "主要功能",Icon = "monitor-check", Locked = false,})

local Button = Tab:Button({
Title = "取消互动cd",
Desc = "",
Locked = false,
Callback = function()
local function zeroPrompt(prompt)
if prompt:IsA("ProximityPrompt") then
prompt.HoldDuration = 0
end
end

local function scanAll()
for _, obj in ipairs(workspace:GetDescendants()) do
zeroPrompt(obj)
end
end

scanAll()

workspace.DescendantAdded:Connect(function(child)
zeroPrompt(child)
if child:IsA("Model") then
for _, sub in ipairs(child:GetDescendants()) do
zeroPrompt(sub)
end
end
end)
end})


local Toggle = Tab:Toggle({
Title = "反布娃娃",
Desc = "*那个人不会晕怎么玩啊……",
Icon = "check",
Type = "Checkbox",
Value = false,
Callback = function(state)
antiRagdollHandler.setEnabled(state)
end
})

local Toggle = Tab:Toggle({
Title = "反边界",
Desc = "禁止高处坠落死亡或掉落伤害",
Icon = "check",
Type = "Checkbox",
Value = false,
Callback = function(state)
antiFallHandler.setEnabled(state)
end
})

local staminaThread = nil
local staminaActive = false

local Toggle = Tab:Toggle({
Title = "无限体力",
Desc = "强势回归",
Icon = "check",
Type = "Checkbox",
Value = false,
Callback = function(state)
staminaActive = state
if staminaActive then
if staminaThread then task.cancel(staminaThread) end
staminaThread = task.spawn(function()
local rs = game:GetService("ReplicatedStorage")
local stamina = require(rs.Resources.Client.MovementHandler.Stamina)
local cd = false
while staminaActive do
task.wait(0.1)
if stamina.Get() <= 100 and not cd then
cd = true
stamina.DrainStamina(-100, 0, true)
stamina.DestroyDrainer("BaseDrain")
task.wait(0.1)
cd = false
end
end
end)
else
if staminaThread then
task.cancel(staminaThread)
staminaThread = nil
end
end
end
})

local Tab = Window:Tab({Title = "表情",Icon = "smile", Locked = false,})

local Dropdown = Tab:Dropdown({
Title = "表情选择",
Desc = "从所有可用表情中选择一个",
Values = displayNames,
Value = displayNames[1] or "",
Callback = function(option)
selectedEmote = displayToId[option] or option 
end
})

local Button = Tab:Button({Title = "做表情",Desc = "",Locked = false,Callback = function()EmoteHandler.doEmote(selectedEmote) end})

local Tab = Window:Tab({Title = "键位调整",Icon = "app-window", Locked = false,})

local Button_record = Tab:Button({Title = "查找全部按钮",Desc = "确保全部按钮都出现,仅记录一次",Locked = false,Callback = function()recordOriginalButtonData() Button_record:Destroy()end})

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

local Button = Tab:Button({Title = "放大20%",Desc = "",Locked = false,Callback = function()scaleSelectedButton(1.2) end})

local Button = Tab:Button({Title = "缩小20%",Desc = "",Locked = false,Callback = function()scaleSelectedButton(1/1.2) end})

local Button = Tab:Button({
Title = "重置所有按钮位置/大小",
Desc = "恢复为原始位置",
Locked = false,
Callback = function()
resetAllButtonPositions()
if selectionModeActive then
exitSelectionMode()
enterSelectionMode()
end
end
})


local Tab = Window:Tab({Title = "Esp",Icon = "eye",Locked = false,})

local Toggle = Tab:Toggle({
Title = "背包物品显示",
Desc = "现在别人的背包将没有任何秘密",
Icon = "check",
Type = "Checkbox",
Value = false,
Callback = function(state)
initBackpackDisplay(state)
end
})

local Toggle = Tab:Toggle({
Title = "玩家透视",
Desc = "显示所有玩家(或者他的阵营)",
Icon = "check",
Type = "Checkbox",
Value = false,
Callback = function(state)
perspectiveHandler.setEnabled(state)
end
})

local Toggle = Tab:Toggle({
Title = "子空间地雷定位",
Desc = "以文字显示",
Icon = "check",
Type = "Checkbox",
Value = false,
Callback = function(state)
tripmineLocator.setEnabled(state)
end
})

local Tab = Window:Tab({Title = "快捷传送",Icon = "bird",Locked = false,})

local Button = Tab:Button({Title = "圣剑位置",Desc = "圣剑特殊回合",Locked = false,Callback = function() teleportTo('excalibur') end})
local Button = Tab:Button({Title = "小圣剑位置",Desc = "修饰符回合",Locked = false,Callback = function() teleportTo('excalibur_jr') end})

Tab:Divider()

local Button = Tab:Button({Title = "随机水缸",Desc = "修饰符回合",Locked = false,Callback = function() teleportTo('watergang') end})
local Button = Tab:Button({Title = "最近的椅子",Desc = "修饰符回合",Locked = false,Callback = function() teleportTo('chair') end })
local Button = Tab:Button({Title = "随机路灯",Desc = "灾难回合",Locked = false,Callback = function() teleportTo('fog') end })
Tab:Divider()

local Button = Tab:Button({Title = "中场",Desc = "高地特殊回合",Locked = false,Callback = function() teleportTo('the_height' ,-45, 53, -161) end})
local Button = Tab:Button({Title = "光明剑位置",Desc = "高地特殊回合",Locked = false,Callback = function() teleportTo('the_height' ,-260, 120, -81) end})
local Button = Tab:Button({Title = "黑暗剑位置",Desc = "高地特殊回合",Locked = false,
Callback = function() teleportTo('the_height' ,-250, 50, 60) end})
local Button = Tab:Button({Title = "风剑位置",Desc = "高地特殊回合",Locked = false,Callback = function() teleportTo('the_height' ,20, 162, -339) end})
local Button = Tab:Button({Title = "幽灵剑位置",Desc = "高地特殊回合",Locked = false,Callback = function() teleportTo('the_height' ,240, 65, -160) end})
local Button = Tab:Button({Title = "毒剑位置",Desc = "高地特殊回合",Locked = false,
Callback = function() teleportTo('the_height' ,104, 39, -79) end})
local Button = Tab:Button({Title = "烈焰剑位置",Desc = "高地特殊回合",Locked = false,Callback = function() teleportTo('the_height' ,-150, 73, -150) end})
local Button = Tab:Button({Title = "冰剑位置",Desc = "高地特殊回合",Locked = false,Callback = function() teleportTo('the_height' ,-45, 61, 43) end})

Tab:Divider()

local Button = Tab:Button({Title = "终点",Desc = "淘汰特殊回合(跑酷)",Locked = false,Callback = function() teleportTo('wipeout') end})

Tab:Divider()

local Button = Tab:Button({Title = "终点",Desc = "滑坡特殊回合",Locked = false,Callback = function() teleportTo('landslide') end})

Tab:Divider()

local Button = Tab:Button({Title = "回高塔(出生点,办法1)",Desc = "利用客户端函数重置玩家返回",Locked = false,Callback = function() game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("Packets"):WaitForChild("Packet"):WaitForChild("RemoteEvent"):FireServer(buffer.fromstring("`\003")) end})
local Button = Tab:Button({Title = "回高塔(出生点,办法2)",Desc = "传送",Locked = false,Callback = function() teleportTo(nil ,-35, 100, -442) end})
local Button = Tab:Button({Title = "高塔负二层",Desc = "传送",Locked = false,Callback = function() teleportTo(nil ,-35, 88, -442) end})


local Tab = Window:Tab({Title = "其他功能",Icon = "cross", Locked = false,})

local Toggle = Tab:Toggle({
Title = "准星",
Desc = "",
Icon = "check",
Type = "Checkbox",
Value = false, -- default value
Callback = function(state) 
crosshairFrame.Visible = state
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

local Button = Tab:Button({
Title = "位置记录器",
Desc = "(额外代码)",
Locked = false,
Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Wqawa/myscripts/refs/heads/main/%E4%BD%8D%E7%BD%AE%E8%AE%B0%E5%BD%95.lua"))()
end
})

local Button = Tab:Button({
Title = "玩家传送器",
Desc = "(额外代码)",
Locked = false,
Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Wqawa/myscripts/refs/heads/main/%E8%BA%AB%E5%90%8E%E4%BC%A0%E9%80%81%E5%99%A8.lua"))()
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

local Tab = Window:Tab({Title = "设置",Icon = "settings", Locked = false,})

local Keybind = Tab:Keybind({
Title = "ui快捷键",
Desc = "",
Value = "G",
Callback = function(v)
Window:SetToggleKey(Enum.KeyCode[v])
end
})

wait(0.1)
game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("Packets"):WaitForChild("Packet"):WaitForChild("RemoteEvent"):FireServer(buffer.fromstring("`\003"))



local VirtualInputManager = game:GetService("VirtualInputManager")

local playButton = playerGui:WaitForChild("TitleScreen")
playButton = playButton:WaitForChild("Screens")
playButton = playButton:WaitForChild("Main")
playButton = playButton:WaitForChild("MainArea")
playButton = playButton:WaitForChild("MainButtons")
playButton = playButton:WaitForChild("PlayButton")

wait(0.5)

local absPos = playButton.AbsolutePosition
local absSize = playButton.AbsoluteSize

local centerX = absPos.X + absSize.X / 2
local centerY = absPos.Y + absSize.Y / 2

VirtualInputManager:SendMouseButtonEvent(centerX, centerY+50, 0, true, nil, 0)
wait(0.05)
VirtualInputManager:SendMouseButtonEvent(centerX, centerY+50, 0, false, nil, 0)

end,
Variant = "Primary",
}
}

})

else
WindUI:Notify({Title = "Bro你在干什么?!",Content = "你大爷的给我干哪来了!这里还是SEWH吗?",Duration = 5,Icon = "x",})

playSound(5)
end