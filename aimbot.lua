-- =============================================================================
-- DELTA Aimbot + Movement + Teleport Escape (Prison Life)
-- =============================================================================

if game.CoreGui:FindFirstChild("DeltaAimbotMenu") then
    game.CoreGui.DeltaAimbotMenu:Destroy()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local _G = getgenv and getgenv() or _G

-- Aimbot Globals
_G.Aimbot = false
_G.TeamCheck = false
_G.WallCheck = false
_G.AimFov = 150
_G.AimSmooth = 25
_G.AimPart = "Head"
_G.ShowFov = true
_G.ShowCrosshair = true

-- Movement Globals
_G.SpeedValue = 16
_G.JumpValue = 50
_G.InfJump = false
_G.Sprint = false -- Added sprint toggle

-- Auto Escape Globals
_G.AutoEscape = false
_G.EscapeStuds = 15

-- =============================================================================
-- UI CREATION
-- =============================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaAimbotMenu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 400)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Active = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local stroke = Instance.new("UIStroke", MainFrame)
stroke.Color = Color3.fromRGB(0, 245, 255)
stroke.Thickness = 1.5

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DELTA PRISON"
Title.TextColor3 = Color3.fromRGB(0, 245, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -30, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.Parent = Header
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 4)

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -45)
Container.Position = UDim2.new(0, 10, 0, 40)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 3
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 245, 255)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.Parent = MainFrame
local layout = Instance.new("UIListLayout", Container)
layout.Padding = UDim.new(0, 6)

-- =============================================================================
-- UI COMPONENTS
-- =============================================================================

local function AddSection(titleText)
    local sec = Instance.new("TextLabel")
    sec.Size = UDim2.new(1, 0, 0, 20)
    sec.BackgroundTransparency = 1
    sec.Text = string.upper(titleText)
    sec.TextColor3 = Color3.fromRGB(0, 245, 255)
    sec.TextXAlignment = Enum.TextXAlignment.Left
    sec.Font = Enum.Font.GothamBold
    sec.TextSize = 11
    sec.Parent = Container
end

local function AddToggle(text, varName)
    local item = Instance.new("Frame")
    item.Size = UDim2.new(1, 0, 0, 32)
    item.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    item.Parent = Container
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.Parent = item

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -45, 0, 6)
    btn.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(50, 50, 50)
    btn.Text = _G[varName] and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
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
    item.Size = UDim2.new(1, 0, 0, 32)
    item.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    item.Parent = Container
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.Parent = item

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 50, 0, 20)
    box.Position = UDim2.new(1, -60, 0, 6)
    box.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    box.Text = tostring(_G[varName])
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.GothamBold
    box.TextSize = 11
    box.Parent = item
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
    local boxStroke = Instance.new("UIStroke", box)
    boxStroke.Color = Color3.fromRGB(0, 245, 255)
    boxStroke.Thickness = 1

    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then
            _G[varName] = val
        else
            box.Text = tostring(_G[varName])
        end
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
partRow.Size = UDim2.new(1, 0, 0, 35)
partRow.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
partRow.Parent = Container
Instance.new("UICorner", partRow).CornerRadius = UDim.new(0, 6)

local partLbl = Instance.new("TextLabel")
partLbl.Size = UDim2.new(0.4, 0, 1, 0)
partLbl.Position = UDim2.new(0, 10, 0, 0)
partLbl.BackgroundTransparency = 1
partLbl.Text = "Aim Part:"
partLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
partLbl.TextXAlignment = Enum.TextXAlignment.Left
partLbl.Font = Enum.Font.GothamMedium
partLbl.TextSize = 11
partLbl.Parent = partRow

local holder = Instance.new("Frame")
holder.Size = UDim2.new(0.55, -10, 0, 25)
holder.Position = UDim2.new(0.42, 0, 0, 5)
holder.BackgroundTransparency = 1
holder.Parent = partRow
local hl = Instance.new("UIListLayout", holder)
hl.FillDirection = Enum.FillDirection.Horizontal
hl.Padding = UDim.new(0, 4)

for _, part in ipairs({"Head", "Torso", "HumanoidRootPart"}) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.32, 0, 1, 0)
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    b.Text = (part == "HumanoidRootPart" and "HRP") or part
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    b.Parent = holder
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function()
        _G.AimPart = part
    end)
end

AddSection("Movement")
AddToggle("Infinite Jump", "InfJump")
AddToggle("Sprint (Hold LShift)", "Sprint")
AddTextbox("Speed", "SpeedValue")
AddTextbox("Jump Power", "JumpValue")

AddSection("Prison Life")
AddToggle("Auto Escape (TP)", "AutoEscape")
AddTextbox("Escape Studs", "EscapeStuds")

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
        MainFrame.Size = UDim2.new(0, 280, 0, 35)
        MinBtn.Text = "+"
        Container.Visible = false
    else
        MainFrame.Size = UDim2.new(0, 280, 0, 400)
        MinBtn.Text = "-"
        Container.Visible = true
    end
end)

-- =============================================================================
-- LOGIC (AIMBOT, MOVEMENT, AUTO ESCAPE)
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

-- Render Loop
RunService.RenderStepped:Connect(function()
    if FovCircle then
        FovCircle.Visible = _G.ShowFov
        FovCircle.Size = UDim2.new(0, _G.AimFov * 2, 0, _G.AimFov * 2)
        FovCircle.Position = UDim2.new(0.5, -_G.AimFov, 0.5, -_G.AimFov)
    end
    if Crosshair then
        Crosshair.Visible = _G.ShowCrosshair
    end

    if _G.Aimbot then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(_G.AimPart) then
            local targetPos = target.Character[_G.AimPart].Position
            local currentCFrame = Camera.CFrame
            local goalCFrame = CFrame.new(currentCFrame.Position, targetPos)
            
            local smoothFactor = _G.AimSmooth / 100
            if smoothFactor > 0 then
                Camera.CFrame = currentCFrame:Lerp(goalCFrame, smoothFactor)
            end
        end
    end
end)

-- Physics & Auto Escape Loop
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and hrp then
            
            -- EXACT IDK.LUA SPEED LOGIC
            local spd = _G.SpeedValue
            if _G.Sprint and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then 
                spd = spd * 2 
            end

            if humanoid.MoveDirection.Magnitude > 0 and spd > 16 then
                local velocityVector = humanoid.MoveDirection * spd
                hrp.AssemblyLinearVelocity = Vector3.new(velocityVector.X, hrp.AssemblyLinearVelocity.Y, velocityVector.Z)
            else
                humanoid.WalkSpeed = spd
            end
            -- END SPEED LOGIC

            if humanoid.UseJumpPower then
                humanoid.JumpPower = _G.JumpValue
            else
                humanoid.JumpHeight = _G.JumpValue / 7
            end
        end

        -- PRISON LIFE CUSTOM TELEPORT ESCAPE
        if _G.AutoEscape and hrp then
            local lookDir = Camera.CFrame.LookVector
            hrp.CFrame = hrp.CFrame + (lookDir * _G.EscapeStuds)
        end
    end
end)

-- Infinite Jump Logic
UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Draggable UI
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