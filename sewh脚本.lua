local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ChinaQY/-/Main/UI"))()

local s_v = "v 0.2"
local s_data = "2026/5/16"

local saftplanformenable = false
local radollenable = false
local time = 0.05




local function TeleportTo(Value , x, y, z)
  local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    if not character or not character.Parent then
        -- 如果角色不存在，等待角色加载
        character = player.CharacterAdded:Wait()
    end
    
    -- 获取 HumanoidRootPart
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        return false
    end
    
    -- 处理参数：如果传入 nil，则使用当前位置
    local currentPos = rootPart.Position
    local targetX = (x ~= nil) and x or currentPos.X
    local targetY = (y ~= nil) and y or currentPos.Y
    local targetZ = (z ~= nil) and z or currentPos.Z
    
    -- 保持原朝向不变
    local targetCFrame = CFrame.new(targetX, targetY, targetZ) * CFrame.Angles(0, rootPart.Orientation.Y, 0)
  
  

local targetPath = workspace:FindFirstChild("Map")
    and workspace.Map:FindFirstChild("Other")
    and workspace.Map.Other:FindFirstChild("MapTerrain")
    and workspace.Map.Other.MapTerrain:FindFirstChild("Map")
    and workspace.Map.Other.MapTerrain.Map:FindFirstChild("Column")

if targetPath or Value then
rootPart.CFrame = targetCFrame
end
    
    
    
    return true
end
   




OrionLib:MakeNotification({
    Name = "SEWH脚本 " .. s_v,
    Content = "脚本启动中",
    Time = 2.5 })

local Sound = Instance.new("Sound")
    Sound.SoundId = "rbxassetid://4590662766"
    Sound.Parent = game:GetService("SoundService")
    Sound.Volume = 5
    Sound:Play()
    Sound.Ended:Wait()
    Sound:Destroy()

local Window = OrionLib:MakeWindow({Name = "SEWH", HidePremium = false, SaveConfig = false, IntroText = "Something Evil Will Happen", ConfigFolder = "SEWH"})

local Tab = Window:MakeTab({
    Name = "公告",
    Icon = "rbxassetid://14250466898",
    PremiumOnly = false
})

Tab:AddParagraph("作者","wq_furry  &  Deepseek")
Tab:AddLabel("你懂的,我需要ui,所以改过来的")
Tab:AddLabel("此脚本完全免费(废话,不能收费啊)")
Tab:AddLabel("版本号 :" ..s_v.. " 日期 ：" ..s_data)

local Tab = Window:MakeTab({
    Name = "主要功能",
    Icon = "rbxassetid://14250466898",
    PremiumOnly = false
})

Tab:AddToggle({
    Name = "反布娃娃",
    Default = false,
    Callback = function(Value)
    radollenable = Value
if radollenable then
    
    while radollenable do
local args = {buffer.fromstring("\000\000")}  



game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("Packets"):WaitForChild("Packet"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
 

wait(time)
end
end
end})

Tab:AddToggle({
    Name = "自动脱险",
    Default = false,
    Callback = function(Value)

saftplanformenable=Value

if saftplanformenable then

local stopFall = workspace:FindFirstChild("Map")
if stopFall then
    stopFall = stopFall:FindFirstChild("Constant")
    if stopFall then
        stopFall = stopFall:FindFirstChild("StopFall")
        if stopFall then
            stopFall:Destroy()
        end
    end
end

local parent = workspace.Map.Constant.Doomspire.Doomspire:GetChildren()[9]
if parent then
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("BasePart") then
            child.Transparency = 0.8
        end
    end
end


local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- 平台设置
local PLATFORM_POSITION = Vector3.new(-33, 55, -465)
local PLATFORM_SIZE = Vector3.new(50, 1.5, 50)
local PLATFORM_COLOR = Color3.fromRGB(255, 0, 0)
local PLATFORM_TRANSPARENCY = 0.8
local TELEPORT_OFFSET = Vector3.new(0, 3, 0)

-- 传送相关变量
local isInReturnProcess = false
local originalCFrame = nil
local originalCameraCFrame = nil
local monitoringThread = nil

-- 创建或获取平台
local platformPart = workspace:FindFirstChild("SafePlatform")
if not platformPart then
	platformPart = Instance.new("Part")
	platformPart.Name = "SafePlatform"
	platformPart.Size = PLATFORM_SIZE
	platformPart.Anchored = true
	platformPart.CanCollide = true
	platformPart.Color = PLATFORM_COLOR
	platformPart.Transparency = PLATFORM_TRANSPARENCY
	platformPart.Position = PLATFORM_POSITION
	platformPart.Parent = workspace
else
	platformPart.Position = PLATFORM_POSITION
	platformPart.Size = PLATFORM_SIZE
	platformPart.Color = PLATFORM_COLOR
	platformPart.Transparency = PLATFORM_TRANSPARENCY
end

-- 重置玩家惯性等动量
local function resetVelocity(character)
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChild("Humanoid")
	
	if rootPart then
		rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		rootPart.Velocity = Vector3.new(0, 0, 0)
		rootPart.RotVelocity = Vector3.new(0, 0, 0)
	end
	
	if humanoid then
		humanoid.Jump = false
		humanoid.Sit = false
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end

-- 获取当前摄像机角度
local function getCameraCFrame()
	local camera = workspace.CurrentCamera
	if camera then
		return camera.CFrame
	end
	return CFrame.new()
end

-- 设置摄像机角度
local function setCameraCFrame(cframe)
	local camera = workspace.CurrentCamera
	if camera and cframe then
		camera.CFrame = cframe
	end
end

-- 处理角色
local function onCharacterAdded(character)
	local humanoid = character:WaitForChild("Humanoid")
	local rootPart = character:WaitForChild("HumanoidRootPart")
	
	local maxHealth = humanoid.MaxHealth
	
	-- 重置传送状态（新角色重生后重置）
	isInReturnProcess = false
	originalCFrame = nil
	originalCameraCFrame = nil
	
	-- 停止之前的监控线程
	if monitoringThread then
		task.cancel(monitoringThread)
		monitoringThread = nil
	end
	
	-- 启动 while 循环监控血量
	monitoringThread = task.spawn(function()
		while character and character.Parent and humanoid and humanoid.Parent and saftplanformenable do
			local health = humanoid.Health
			
			-- 角色死亡，重置所有状态并停止监控
			if health <= 0 then
				if isInReturnProcess then
					-- 死亡时清空记录，不再传送回去
					isInReturnProcess = false
					originalCFrame = nil
					originalCameraCFrame = nil
					print("角色死亡，取消返回流程")
				end
				break  -- 退出循环，停止监控
			end
			
			-- 血量低于等于33% 且 未在返回流程中
			if health > 0 and health / maxHealth <= 0.33 and not isInReturnProcess then
				isInReturnProcess = true
				
				-- 记录当前位置和摄像机角度
				originalCFrame = rootPart.CFrame
				originalCameraCFrame = getCameraCFrame()
				print("血量低于等于33%，记录位置和角度")
				
				-- 重置玩家惯性等动量
				resetVelocity(character)
				
				-- 传送到平台中心向上偏移3的位置
				local targetCFrame = CFrame.new(platformPart.Position + TELEPORT_OFFSET)
				rootPart.CFrame = targetCFrame
				print("已传送到安全平台")
			end
			
			-- 血量大于66% 且 正在返回流程中（且角色未死亡）
			if health > 0 and health / maxHealth > 0.66 and isInReturnProcess then
				-- 确认角色和部件仍然存在
				if character and character.Parent and rootPart and rootPart.Parent then
					rootPart.CFrame = originalCFrame
					setCameraCFrame(originalCameraCFrame)
					print("已返回原始位置和角度")
				else
					print("角色已不存在，取消返回")
				end
				
				-- 重置标记
				isInReturnProcess = false
				originalCFrame = nil
				originalCameraCFrame = nil
			end
			
			task.wait(time)
		end
		
		monitoringThread = nil
	end)
	
	-- 角色销毁时清理线程
	local connection
	connection = character.AncestryChanged:Connect(function()
		if not character.Parent then
			if monitoringThread then
				task.cancel(monitoringThread)
				monitoringThread = nil
			end
			connection:Disconnect()
		end
	end)
end

-- 如果角色已经存在，直接处理
if localPlayer.Character then
	onCharacterAdded(localPlayer.Character)
end

-- 监听角色重生
localPlayer.CharacterAdded:Connect(onCharacterAdded)

else

local parent = workspace.Map.Constant.Doomspire.Doomspire:GetChildren()[9]
if parent then
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("BasePart") then
            child.Transparency = 0
        end
    end
end
local platformPart = workspace:FindFirstChild("SafePlatform")
if platformPart then
platformPart:Destroy()
end

end


end})

Tab:AddLabel("我来给你解释:当你的血量低于33%时会被传送到一个安全的地方,回血到66%时传送回去")


Tab:AddButton({
    Name = "无限体力(暂不可用)",
    Callback = function()
loadstring(game:HttpGet("https://rawscripts.net/raw/UPD-something-evil-will-happen-Inf-stamina-57438"))()

end})

local Tab = Window:MakeTab({
    Name = "快捷传送",
    Icon = "rbxassetid://14250466898",
    PremiumOnly = false
})

Tab:AddLabel("圣剑特殊回合")

Tab:AddButton({
    Name = "圣剑位置",
    Callback = function()
-- 传送到 SwordSpot.PromptPart 上方3格处

local player = game:GetService("Players").LocalPlayer

-- 获取目标部件
local targetPart = workspace:FindFirstChild("SwordSpot") and workspace.SwordSpot:FindFirstChild("PromptPart")

if not targetPart then
    warn("找不到 workspace.SwordSpot.PromptPart，请检查路径是否正确")
    return
end

-- 获取角色
local character = player.Character
if not character or not character.Parent then
    character = player.CharacterAdded:Wait()
end

-- 获取 HumanoidRootPart
local rootPart = character:FindFirstChild("HumanoidRootPart")
if not rootPart then
    return
end

-- 计算目标位置：PromptPart 上方3格
local targetPosition = targetPart.Position + Vector3.new(0, 3, 0)
local targetCFrame = CFrame.new(targetPosition)

-- 执行传送
rootPart.CFrame = targetCFrame

end})

Tab:AddLabel("高地特殊回合")

Tab:AddButton({
    Name = "光明剑位置",
    Callback = function()
TeleportTo(false ,-260, 120, -81)
end})

Tab:AddButton({
    Name = "黑暗剑位置",
    Callback = function()
TeleportTo(false ,-250, 50, 60)
end})

Tab:AddButton({
    Name = "风剑位置",
    Callback = function()
TeleportTo(false ,20, 162, -339)
end})

Tab:AddButton({
    Name = "幽灵剑位置",
    Callback = function()
TeleportTo(false ,240, 65, -160)
end})

Tab:AddButton({
    Name = "毒剑位置",
    Callback = function()
TeleportTo(false ,104, 39, -79)
end})

Tab:AddButton({
    Name = "烈焰剑位置",
    Callback = function()
TeleportTo(false ,-150, 73, -150)
end})

Tab:AddButton({
    Name = "冰剑位置",
    Callback = function()
TeleportTo(false ,-45, 61, 43)
end})

Tab:AddLabel("淘汰特殊回合(跑酷)")

Tab:AddButton({
    Name = "终点",
    Callback = function()
-- 传送到 Ramp 的第13个子物体上方

local player = game:GetService("Players").LocalPlayer

-- 获取 Ramp 及其子物体
local ramp = workspace:FindFirstChild("Map")
    and workspace.Map:FindFirstChild("Other")
    and workspace.Map.Other:FindFirstChild("MapTerrain")
    and workspace.Map.Other.MapTerrain:FindFirstChild("Ramp")

if not ramp then
    return
end

local children = ramp:GetChildren()
local targetPart = children[13]  -- 第13个子物体（索引从1开始）

if not targetPart then
    return
end

-- 获取角色
local character = player.Character
if not character or not character.Parent then
    character = player.CharacterAdded:Wait()
end

local rootPart = character:FindFirstChild("HumanoidRootPart")
if not rootPart then
    return
end

-- 计算目标位置：传送到该物体上方3格处（可调整）
local targetPosition = targetPart.Position + Vector3.new(0, 90, 10)
local targetCFrame = CFrame.new(targetPosition)

-- 执行传送
rootPart.CFrame = targetCFrame

end})

Tab:AddButton({
    Name = "回高塔(出生点,办法1)",
    Callback = function()
    
local args = {
	buffer.fromstring("`\003")
}
game:GetService("ReplicatedStorage"):WaitForChild("Communication"):WaitForChild("Packets"):WaitForChild("Packet"):WaitForChild("RemoteEvent"):FireServer(unpack(args))

end})

Tab:AddButton({
    Name = "回高塔(出生点,办法2)",
    Callback = function()

TeleportTo(true ,-35, 100, -442)

end})

local Tab = Window:MakeTab({
    Name = "其他功能",
    Icon = "rbxassetid://14250466898",
    PremiumOnly = false
})

Tab:AddButton({
    Name = "踏空行走",
    Callback = function()
    
-- 半透明红色移动平台 (Gemini UI 风格)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- 平台参数
local PLATFORM_SIZE = Vector3.new(20, 1, 20)
local PLATFORM_COLOR = Color3.fromRGB(255, 0, 0)
local PLATFORM_TRANSPARENCY = 0.9

-- 平台状态
local isPlatformActive = false
local platformPart = nil
local fixedY = 0
local heartBeatConnection = nil

-- ========== 创建 GUI ==========
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "PlatformGUI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Name = "Main"
mainFrame.Size = UDim2.new(0, 130, 0, 80)
mainFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BackgroundTransparency = 0.5
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 20)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.new(1, 1, 1)
stroke.Transparency = 0.8
stroke.Thickness = 1.2

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 2)
title.BackgroundTransparency = 1
title.Text = "移动平台"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextTransparency = 0.2

local btn = Instance.new("TextButton", mainFrame)
btn.Name = "Toggle"
btn.Size = UDim2.new(0.8, 0, 0, 32)
btn.Position = UDim2.new(0.1, 0, 0.48, 0)
btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
btn.Text = "平台：关"
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 12
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

-- 果冻拖拽效果
local function setupGelly()
    local dragging = false
    local dragStart, startPos

    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 145, 0, 90),
                BackgroundTransparency = 0.4
            }):Play()
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 130, 0, 80),
                BackgroundTransparency = 0.5
            }):Play()
        end
    end)
end
setupGelly()

-- ========== 平台逻辑 ==========
local function destroyPlatform()
    if platformPart then
        platformPart:Destroy()
        platformPart = nil
    end
    if heartBeatConnection then
        heartBeatConnection:Disconnect()
        heartBeatConnection = nil
    end
end

local function createPlatform()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return false
    end

    local rootPart = character.HumanoidRootPart
    fixedY = rootPart.Position.Y - rootPart.Size.Y / 2 - 3   -- 脚底高度

    platformPart = Instance.new("Part")
    platformPart.Name = "LocalPlatform"
    platformPart.Size = PLATFORM_SIZE
    platformPart.Anchored = true
    platformPart.CanCollide = true
    platformPart.Color = PLATFORM_COLOR
    platformPart.Transparency = PLATFORM_TRANSPARENCY
    platformPart.Parent = workspace
    platformPart.CFrame = CFrame.new(rootPart.Position.X, fixedY, rootPart.Position.Z)

    heartBeatConnection = RunService.Heartbeat:Connect(function()
        if not platformPart then return end
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            platformPart.CFrame = CFrame.new(hrp.Position.X, fixedY, hrp.Position.Z)
        end
    end)

    return true
end

local function updateButton()
    if isPlatformActive then
        btn.Text = "平台：开"
        btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    else
        btn.Text = "平台：关"
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end

local function togglePlatform()
    if isPlatformActive then
        isPlatformActive = false
        destroyPlatform()
    else
        isPlatformActive = true
        createPlatform()
    end
    updateButton()
end

-- 处理重生自动重建
local function onCharacterAdded(character)
    if isPlatformActive and not platformPart then
        local hrp = character:WaitForChild("HumanoidRootPart", 10)
        if hrp then
            if fixedY == 0 then
                fixedY = hrp.Position.Y - hrp.Size.Y / 2 -3
            end
            platformPart = Instance.new("Part")
            platformPart.Name = "LocalPlatform"
            platformPart.Size = PLATFORM_SIZE
            platformPart.Anchored = true
            platformPart.CanCollide = true
            platformPart.Color = PLATFORM_COLOR
            platformPart.Transparency = PLATFORM_TRANSPARENCY
            platformPart.Parent = workspace
            platformPart.CFrame = CFrame.new(hrp.Position.X, fixedY, hrp.Position.Z)

            heartBeatConnection = RunService.Heartbeat:Connect(function()
                if not platformPart then return end
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local newHrp = char.HumanoidRootPart
                    platformPart.CFrame = CFrame.new(newHrp.Position.X, fixedY, newHrp.Position.Z)
                end
            end)
        end
    end
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then
    onCharacterAdded(player.Character)
end

btn.MouseButton1Click:Connect(togglePlatform)



end})

Tab:AddTextbox({
    Name = "跳跃高度(暂不可用)",
    Default = "",
    TextDisappear = true,
    Callback = function(Value)
game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
end})

OrionLib:Init()