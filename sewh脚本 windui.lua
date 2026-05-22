local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local s_v = "v 0.3 demo"
local s_data = "2026/5/22"

local time = 0.05



local function TeleportTo(Map , x, y, z)
local player = game:GetService("Players").LocalPlayer
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
BackgroundImageTransparency = 0.42,
HideSearchBar = true,
ScrollBarEnabled = false,

-- ↓ Optional. You can remove it.
--[[ You can set 'rbxassetid://' or video to Background.
    'rbxassetid://':
        Background = "rbxassetid://", -- rbxassetid
    Video:
Background = "video:YOUR-RAW-LINK-TO-VIDEO.webm", -- video 
--]]

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
local Tab = Window:Tab({
Title = "主要功能",
Icon = "monitor-check", -- optional
Locked = false,
})

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

local Toggle = Tab:Toggle({
Title = "自动脱险(废弃)",
Desc = "我来给你解释:当你的血量低于33%时会被传送到一个安全的地方,回血到66%时传送回去",
Icon = "check",
Type = "Checkbox",
Value = false, -- default value
Callback = function(state) 
    
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

local Tab = Window:Tab({
Title = "Esp",
Icon = "eye", -- optional
Locked = false,
})



local Tab = Window:Tab({
Title = "快捷传送",
Icon = "bird", -- optional
Locked = false,
})

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


local Tab = Window:Tab({
Title = "其他功能",
Icon = "cross", -- optional
Locked = false,
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

local Tab = Window:Tab({
Title = "活动限定",
Icon = "bell", -- optional
Locked = true,
})

local Tab = Window:Tab({
Title = "敬请期待",
Icon = "clock", -- optional
Locked = true,
})
game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("Packets"):WaitForChild("Packet"):WaitForChild("RemoteEvent"):FireServer(buffer.fromstring("`\003"))
end,
Variant = "Primary",
}
}


})



