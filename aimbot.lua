-- =============================================================================
-- DELTA PRISON (Working Hitbox Godmode)
-- =============================================================================

if game.CoreGui:FindFirstChild("DeltaAimbotMenu") then
    game.CoreGui.DeltaAimbotMenu:Destroy()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local _G = getgenv and getgenv() or _G

-- Globals
_G.Aimbot = false
_G.TeamCheck = false
_G.WallCheck = false
_G.AimFov = 150
_G.AimSmooth = 25
_G.AimPart = "Head"
_G.ShowFov = true
_G.ShowCrosshair = true
_G.SpeedValue = 16
_G.JumpValue = 50
_G.InfJump = false
_G.Sprint = false
_G.ESP = false
_G.AutoArrest = false
_G.AutoPunch = false
_G.Godmode = false
_G.GodOffset = 15 

local FullbrightOn = false
local originalLighting = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness
}

-- =============================================================================
-- UI CREATION
-- =============================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaAimbotMenu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 260) 
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Active = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local stroke = Instance.new("UIStroke", MainFrame)
stroke.Color = Color3.fromRGB(0, 245, 255)
stroke.Thickness = 1.5

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DELTA PRISON"
Title.TextColor3 = Color3.fromRGB(0, 245, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 20, 0, 20)
MinBtn.Position = UDim2.new(1, -25, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
MinBtn.Parent = Header
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 4)

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -10, 1, -35)
Container.Position = UDim2.new(0, 5, 0, 35)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 245, 255)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.Parent = MainFrame
local layout = Instance.new("UIListLayout", Container)
layout.Padding = UDim.new(0, 4)

-- =============================================================================
-- UI COMPONENTS
-- =============================================================================

local function AddSection(titleText)
    local sec = Instance.new("TextLabel")
    sec.Size = UDim2.new(1, 0, 0, 16)
    sec.BackgroundTransparency = 1
    sec.Text = string.upper(titleText)
    sec.TextColor3 = Color3.fromRGB(0, 245, 255)
    sec.TextXAlignment = Enum.TextXAlignment.Left
    sec.Font = Enum.Font.GothamBold
    sec.TextSize = 10
    sec.Parent = Container
end

local function AddToggle(text, varName)
    local item = Instance.new("Frame")
    item.Size = UDim2.new(1, 0, 0, 28)
    item.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    item.Parent = Container
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -45, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 10
    lbl.Parent = item

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 35, 0, 18)
    btn.Position = UDim2.new(1, -40, 0, 5)
    btn.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 50, 50)
    btn.Text = _G[varName] and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    btn.Parent = item
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        btn.Text = _G[varName] and "ON" or "OFF"
        btn.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 50, 50)
    end)
end

local function AddTextbox(text, varName)
    local item = Instance.new("Frame")
    item.Size = UDim2.new(1, 0, 0, 28)
    item.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    item.Parent = Container
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 10
    lbl.Parent = item

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 45, 0, 18)
    box.Position = UDim2.new(1, -50, 0, 5)
    box.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    box.Text = tostring(_G[varName])
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.GothamBold
    box.TextSize = 10
    box.Parent = item
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
    local boxStroke = Instance.new("UIStroke", box)
    boxStroke.Color = Color3.fromRGB(0, 245, 255)
    boxStroke.Thickness = 1

    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then _G[varName] = val else box.Text = tostring(_G[varName]) end
    end)
end

-- =============================================================================
-- POPULATE UI
-- =============================================================================

AddSection("Aimbot")
AddToggle("Enable Aimbot", "Aimbot")
AddToggle("Show FOV Circle", "ShowFov")
AddToggle("Show Crosshair", "ShowCrosshair")
AddToggle("Team Check", "TeamCheck")
AddToggle("Wall Check", "WallCheck")
AddTextbox("FOV Radius", "AimFov")
AddTextbox("Smoothing (0-100)", "AimSmooth")

local partRow = Instance.new("Frame")
partRow.Size = UDim2.new(1, 0, 0, 28)
partRow.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
partRow.Parent = Container
Instance.new("UICorner", partRow).CornerRadius = UDim.new(0, 6)

local partLbl = Instance.new("TextLabel")
partLbl.Size = UDim2.new(0.4, 0, 1, 0)
partLbl.Position = UDim2.new(0, 8, 0, 0)
partLbl.BackgroundTransparency = 1
partLbl.Text = "Aim Part:"
partLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
partLbl.TextXAlignment = Enum.TextXAlignment.Left
partLbl.Font = Enum.Font.GothamMedium
partLbl.TextSize = 10
partLbl.Parent = partRow

local holder = Instance.new("Frame")
holder.Size = UDim2.new(0.55, -10, 0, 20)
holder.Position = UDim2.new(0.42, 0, 0, 4)
holder.BackgroundTransparency = 1
holder.Parent = partRow
local hl = Instance.new("UIListLayout", holder)
hl.FillDirection = Enum.FillDirection.Horizontal
hl.Padding = UDim.new(0, 2)

for _, part in ipairs({"Head", "Torso", "HRP"}) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.3, 0, 1, 0)
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    b.Text = part
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 9
    b.Parent = holder
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 3)
    b.MouseButton1Click:Connect(function()
        _G.AimPart = (part == "HRP" and "HumanoidRootPart") or part
    end)
end

AddSection("Combat Mods")
AddToggle("Hitbox Godmode", "Godmode")
AddTextbox("God Offset", "GodOffset")
AddToggle("Auto-Arrest", "AutoArrest")
AddToggle("Auto-Punch", "AutoPunch")

AddSection("Visuals & Performance")
AddToggle("Team ESP", "ESP")

local btnRow = Instance.new("Frame")
btnRow.Size = UDim2.new(1, 0, 0, 28)
btnRow.BackgroundTransparency = 1
btnRow.Parent = Container
local btnLayout = Instance.new("UIListLayout", btnRow)
btnLayout.FillDirection = Enum.FillDirection.Horizontal
btnLayout.Padding = UDim.new(0, 4)

local optBtn = Instance.new("TextButton")
optBtn.Size = UDim2.new(0.5, -2, 1, 0)
optBtn.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
optBtn.Text = "⚡ Optimize"
optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
optBtn.Font = Enum.Font.GothamBold
optBtn.TextSize = 10
optBtn.Parent = btnRow
Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)

local fbBtn = Instance.new("TextButton")
fbBtn.Size = UDim2.new(0.5, -2, 1, 0)
fbBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
fbBtn.Text = "☀️ Fullbright"
fbBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
fbBtn.Font = Enum.Font.GothamBold
fbBtn.TextSize = 10
fbBtn.Parent = btnRow
Instance.new("UICorner", fbBtn).CornerRadius = UDim.new(0, 4)

AddSection("Movement")
AddToggle("Infinite Jump", "InfJump")
AddToggle("Sprint (LShift)", "Sprint")
AddTextbox("Speed", "SpeedValue")
AddTextbox("Jump Power", "JumpValue")

AddSection("Teleport")
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(1, 0, 0, 30)
tpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
tpBtn.Text = "⚡ Teleport Forward"
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 11
tpBtn.Parent = Container
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)

tpBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local lookDir = Camera.CFrame.LookVector
        hrp.CFrame = hrp.CFrame + (lookDir * 15)
    end
end)

-- =============================================================================
-- VISUALS (FOV & CROSSHAIR)
-- =============================================================================

local Crosshair = Instance.new("Frame")
Crosshair.Size = UDim2.new(0, 4, 0, 4)
Crosshair.Position = UDim2.new(0.5, -2, 0.5, -2)
Crosshair.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Crosshair.Parent = ScreenGui
Instance.new("UICorner", Crosshair).CornerRadius = UDim.new(1, 0)

local FovCircle = Instance.new("Frame")
FovCircle.Size = UDim2.new(0, _G.AimFov * 2, 0, _G.AimFov * 2)
FovCircle.Position = UDim2.new(0.5, -_G.AimFov, 0.5, -_G.AimFov)
FovCircle.BackgroundTransparency = 1
FovCircle.Active = false 
FovCircle.Parent = ScreenGui
Instance.new("UICorner", FovCircle).CornerRadius = UDim.new(1, 0)
local fovStroke = Instance.new("UIStroke", FovCircle)
fovStroke.Color = Color3.fromRGB(0, 245, 255)
fovStroke.Thickness = 1.5
fovStroke.Transparency = 0.3

-- =============================================================================
-- MINIMIZE LOGIC
-- =============================================================================

local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 260, 0, 30)
        MinBtn.Text = "+"
        Container.Visible = false
    else
        MainFrame.Size = UDim2.new(0, 260, 0, 260)
        MinBtn.Text = "-"
        Container.Visible = true
    end
end)

-- =============================================================================
-- BUTTON LOGIC (OPTIMIZE & FULLBRIGHT)
-- =============================================================================

optBtn.MouseButton1Click:Connect(function()
    optBtn.Text = "Optimizing..."
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    Lighting.FogEnd = 999999 
    Lighting.GlobalShadows = false 
    
    for _, obj in ipairs(Lighting:GetDescendants()) do 
        if obj:IsA("Atmosphere") or obj:IsA("Sky") then obj:Destroy() 
        elseif obj:IsA("PostEffect") then obj:Enabled = false end
    end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Transparency < 1 then
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") then
            obj.Enabled = false
        end
    end
    task.wait(1)
    optBtn.Text = "⚡ Optimized!"
    optBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
end)

fbBtn.MouseButton1Click:Connect(function()
    FullbrightOn = not FullbrightOn
    if FullbrightOn then
        local ambientBrightness = (originalLighting.Ambient.R + originalLighting.Ambient.G + originalLighting.Ambient.B) / 3
        local outdoorBrightness = (originalLighting.OutdoorAmbient.R + originalLighting.OutdoorAmbient.G + originalLighting.OutdoorAmbient.B) / 3
        local generalDarkness = (ambientBrightness + outdoorBrightness) / 2
        
        if generalDarkness < 0.1 then
            Lighting.Ambient = Color3.fromRGB(180, 180, 180)
            Lighting.OutdoorAmbient = Color3.fromRGB(180, 180, 180)
            Lighting.Brightness = 3.5
        elseif generalDarkness < 0.4 then
            Lighting.Ambient = Color3.fromRGB(140, 140, 140)
            Lighting.OutdoorAmbient = Color3.fromRGB(140, 140, 140)
            Lighting.Brightness = 2.5
        else
            Lighting.Ambient = Color3.fromRGB(110, 110, 110)
            Lighting.OutdoorAmbient = Color3.fromRGB(110, 110, 110)
            Lighting.Brightness = 1.2
        end
        
        fbBtn.Text = "☀️ ON"
        fbBtn.TextColor3 = Color3.fromRGB(100, 255, 100)
        fbBtn.BackgroundColor3 = Color3.fromRGB(30, 80, 30)
    else
        Lighting.Ambient = originalLighting.Ambient
        Lighting.OutdoorAmbient = originalLighting.OutdoorAmbient
        Lighting.Brightness = originalLighting.Brightness
        fbBtn.Text = "☀️ Fullbright"
        fbBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        fbBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
    end
end)

-- =============================================================================
-- LOGIC (AIMBOT, MOVEMENT, ESP, GODMODE)
-- =============================================================================

local function isWallBlocking(targetPart)
    local origin = Camera.CFrame.Position
    local dir = targetPart.Position - origin
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(origin, dir, rayParams)
    return result ~= nil
end

local function getClosestPlayer()
    local target, bestDist = nil, math.huge
    local screenSize = Camera.ViewportSize
    local center = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local aimPart = p.Character:FindFirstChild(_G.AimPart)
            if hum and hum.Health > 0 and aimPart then
                if _G.TeamCheck and p.Team == LocalPlayer.Team then continue end
                if _G.WallCheck and isWallBlocking(aimPart) then continue end
                
                local pos, onScreen = Camera:WorldToViewportPoint(aimPart.Position)
                if onScreen then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist <= _G.AimFov and dist < bestDist then 
                        target = p
                        bestDist = dist 
                    end
                end
            end
        end
    end
    return target
end

local espCache = {}

RunService.RenderStepped:Connect(function()
    if FovCircle then
        FovCircle.Visible = _G.ShowFov
        FovCircle.Size = UDim2.new(0, _G.AimFov * 2, 0, _G.AimFov * 2)
        FovCircle.Position = UDim2.new(0.5, -_G.AimFov, 0.5, -_G.AimFov)
    end
    if Crosshair then Crosshair.Visible = _G.ShowCrosshair end

    if _G.Aimbot then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(_G.AimPart) then
            local targetPos = target.Character[_G.AimPart].Position
            local currentCFrame = Camera.CFrame
            local goalCFrame = CFrame.new(currentCFrame.Position, targetPos)
            local smoothFactor = _G.AimSmooth / 100
            if smoothFactor > 0 then Camera.CFrame = currentCFrame:Lerp(goalCFrame, smoothFactor) end
        end
    end

    -- ESP Logic
    if _G.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                
                if hum and hrp and hum.Health > 0 then
                    local box = espCache[p]
                    if not box then
                        box = Instance.new("BoxHandleAdornment")
                        box.Name = "DeltaESP"
                        box.Adornee = hrp
                        box.Size = Vector3.new(4, 6, 4)
                        box.AlwaysOnTop = true
                        box.ZIndex = 10
                        box.Transparency = 0.5
                        box.Parent = p.Character
                        espCache[p] = box
                    end
                    if p.Team then box.Color3 = p.Team.TeamColor.Color else box.Color3 = Color3.fromRGB(0, 245, 255) end
                else
                    if espCache[p] then
                        espCache[p]:Destroy()
                        espCache[p] = nil
                    end
                end
            end
        end
    else
        for p, box in pairs(espCache) do
            if box then box:Destroy() end
            espCache[p] = nil
        end
    end
end)

-- Main Heartbeat Loop
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and hrp then
            local spd = _G.SpeedValue
            if _G.Sprint and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then spd = spd * 2 end

            if humanoid.MoveDirection.Magnitude > 0 and spd > 16 then
                local velocityVector = humanoid.MoveDirection * spd
                hrp.AssemblyLinearVelocity = Vector3.new(velocityVector.X, hrp.AssemblyLinearVelocity.Y, velocityVector.Z)
            else
                humanoid.WalkSpeed = spd
            end

            if humanoid.UseJumpPower then humanoid.JumpPower = _G.JumpValue else humanoid.JumpHeight = _G.JumpValue / 7 end

            -- WORKING HITBOX GODMODE
            if _G.Godmode then
                humanoid.Health = math.huge
                humanoid.MaxHealth = math.huge
                
                -- Disable the game's Health script
                local healthScript = LocalPlayer.Character:FindFirstChild("Health")
                if healthScript and healthScript:IsA("LocalScript") then
                    healthScript.Disabled = true
                end

                -- Move the Torso and Head underground using Velocity so we don't break the script
                local torso = LocalPlayer.Character:FindFirstChild("Torso")
                local head = LocalPlayer.Character:FindFirstChild("Head")
                
                if torso then 
                    torso.CanCollide = false
                    torso.Velocity = Vector3.new(0, -_G.GodOffset * 10, 0)
                end
                if head then 
                    head.CanCollide = false 
                    head.Velocity = Vector3.new(0, -_G.GodOffset * 10, 0)
                end
            end
        end
    end
end)

-- COMBAT MODS LOGIC (Auto-Arrest & Auto-Punch)
task.spawn(function()
    while true do
        task.wait(0.1)
        if LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                if _G.AutoArrest then
                    local tool = LocalPlayer.Character:FindFirstChild("Arrest")
                    if tool then
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                local dist = (hrp.Position - p.Character.HumanoidRootPart.Position).Magnitude
                                if dist < 8 and p.Team ~= LocalPlayer.Team then
                                    tool:Activate()
                                end
                            end
                        end
                    end
                end
                
                if _G.AutoPunch then
                    local tool = LocalPlayer.Character:FindFirstChildWhichIsA("Tool")
                    if tool and (tool.Name == "Fist" or tool.Name == "Punch") then
                        for _, p in pairs(Players:GetPlayers()) do
                            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                local dist = (hrp.Position - p.Character.HumanoidRootPart.Position).Magnitude
                                if dist < 8 and p.Team ~= LocalPlayer.Team then
                                    tool:Activate()
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)