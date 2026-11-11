-- =============================================================================
-- DELTA Aimbot Standalone
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
_G.Aimbot = false
_G.TeamCheck = false
_G.WallCheck = false
_G.AimFov = 200
_G.AimSmooth = 0.25
_G.AimPart = "Head"

-- =============================================================================
-- UI CREATION
-- =============================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaAimbotMenu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "AIMBOT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = Header

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -20, 1, -45)
Container.Position = UDim2.new(0, 10, 0, 40)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame
local layout = Instance.new("UIListLayout", Container)
layout.Padding = UDim.new(0, 8)

-- =============================================================================
-- UI COMPONENTS
-- =============================================================================

local function AddToggle(text, varName, callback)
    local item = Instance.new("Frame")
    item.Size = UDim2.new(1, 0, 0, 30)
    item.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
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
    lbl.TextSize = 12
    lbl.Parent = item

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -45, 0, 5)
    btn.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 60)
    btn.Text = _G[varName] and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.Parent = item
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]
        btn.Text = _G[varName] and "ON" or "OFF"
        btn.BackgroundColor3 = _G[varName] and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 60)
        if callback then callback(_G[varName]) end
    end)
end

local function AddInput(text, default, callback)
    local item = Instance.new("Frame")
    item.Size = UDim2.new(1, 0, 0, 30)
    item.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    item.Parent = Container
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(240, 240, 240)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 12
    lbl.Parent = item

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0, 40, 0, 20)
    box.Position = UDim2.new(1, -45, 0, 5)
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    box.Text = tostring(default)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.GothamBold
    box.TextSize = 11
    box.Parent = item
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)

    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then callback(val) else box.Text = tostring(default) end
    end)
end

-- Add UI Components
AddToggle("Enable Aimbot", "Aimbot")
AddToggle("Team Check", "TeamCheck")
AddToggle("Wall Check", "WallCheck")
AddInput("FOV Radius", 200, function(val) _G.AimFov = val end)
AddInput("Smoothing (0-1)", 0.25, function(val) _G.AimSmooth = val end)

-- Part Selector
local partRow = Instance.new("Frame")
partRow.Size = UDim2.new(1, 0, 0, 30)
partRow.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
partRow.Parent = Container
Instance.new("UICorner", partRow).CornerRadius = UDim.new(0, 6)

local partLbl = Instance.new("TextLabel")
partLbl.Size = UDim2.new(0.4, 0, 1, 0)
partLbl.Position = UDim2.new(0, 10, 0, 0)
partLbl.BackgroundTransparency = 1
partLbl.Text = "Aim Part:"
partLbl.TextColor3 = Color3.fromRGB(240, 240, 240)
partLbl.TextXAlignment = Enum.TextXAlignment.Left
partLbl.Font = Enum.Font.GothamMedium
partLbl.TextSize = 12
partLbl.Parent = partRow

local holder = Instance.new("Frame")
holder.Size = UDim2.new(0.55, -10, 0, 22)
holder.Position = UDim2.new(0.42, 0, 0, 4)
holder.BackgroundTransparency = 1
holder.Parent = partRow
local hl = Instance.new("UIListLayout", holder)
hl.FillDirection = Enum.FillDirection.Horizontal
hl.Padding = UDim.new(0, 4)

for _, part in ipairs({"Head", "Torso", "HumanoidRootPart"}) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.3, 0, 1, 0)
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
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

-- Make UI Draggable
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

-- =============================================================================
-- AIMBOT LOGIC
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

-- Render Loop with Smoothing
RunService.RenderStepped:Connect(function()
    if _G.Aimbot then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(_G.AimPart) then
            local targetPos = target.Character[_G.AimPart].Position
            local currentCFrame = Camera.CFrame
            
            -- Create the target CFrame looking at the player
            local goalCFrame = CFrame.new(currentCFrame.Position, targetPos)
            
            -- Smoothly interpolate (Lerp) towards the target
            -- If Smooth is 1, it snaps instantly. If 0.1, it's very slow.
            if _G.AimSmooth > 0 then
                Camera.CFrame = currentCFrame:Lerp(goalCFrame, _G.AimSmooth)
            end
        end
    end
end)