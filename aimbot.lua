-- =============================================================================
-- DELTA Aimbot — FOV, Crosshair, Smoothing & Minimize
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
_G.AimFov = 150
_G.AimSmooth = 0.25
_G.AimPart = "Head"
_G.ShowFov = true
_G.ShowCrosshair = true

-- =============================================================================
-- UI CREATION
-- =============================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaAimbotMenu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 380)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Active = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local stroke = Instance.new("UIStroke", MainFrame)
stroke.Color = Color3.fromRGB(0, 245, 255)
stroke.Thickness = 1.5

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DELTA AIMBOT"
Title.TextColor3 = Color3.fromRGB(0, 245, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -30, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.Parent = Header
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 4)

-- Container for scrolling
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -45)
Container.Position = UDim2.new(0, 10, 0, 40)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 0
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.Parent = MainFrame
local layout = Instance.new("UIListLayout", Container)
layout.Padding = UDim.new(0, 6)

-- =============================================================================
-- UI COMPONENTS
-- =============================================================================

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

local function AddSlider(text, min, max, default, varName)
    local item = Instance.new("Frame")
    item.Size = UDim2.new(1, 0, 0, 45)
    item.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    item.Parent = Container
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 20)
    lbl.Position = UDim2.new(0, 10, 0, 4)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. tostring(_G[varName])
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 11
    lbl.Parent = item

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, -20, 0, 6)
    bar.Position = UDim2.new(0, 10, 0, 28)
    bar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    bar.Parent = item
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((_G[varName] - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 245, 255)
    fill.Parent = bar
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local function updateSlider(x)
        local percent = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * percent)
        _G[varName] = val
        fill.Size = UDim2.new(percent, 0, 1, 0)
        lbl.Text = text .. ": " .. tostring(val)
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            updateSlider(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
            updateSlider(input.Position.X)
        end
    end)
end

-- Populate UI
AddToggle("Enable Aimbot", "Aimbot")
AddToggle("Show FOV Circle", "ShowFov")
AddToggle("Show Crosshair", "ShowCrosshair")
AddToggle("Team Check", "TeamCheck")
AddToggle("Wall Check", "WallCheck")
AddSlider("FOV Radius", 50, 500, 150, "AimFov")
AddSlider("Smoothing (0=Slow, 100=Snap)", 0, 100, 25, "AimSmooth")

-- Part Selector
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

-- =============================================================================
-- VISUALS (FOV & CROSSHAIR)
-- =============================================================================

-- Crosshair
local Crosshair = Instance.new("Frame")
Crosshair.Size = UDim2.new(0, 4, 0, 4)
Crosshair.Position = UDim2.new(0.5, -2, 0.5, -2)
Crosshair.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Crosshair.Parent = ScreenGui
Instance.new("UICorner", Crosshair).CornerRadius = UDim.new(1, 0)

-- FOV Circle (Dynamically updates size based on slider)
local FovCircle = Instance.new("Frame")
FovCircle.Size = UDim2.new(0, _G.AimFov * 2, 0, _G.AimFov * 2)
FovCircle.Position = UDim2.new(0.5, -_G.AimFov, 0.5, -_G.AimFov)
FovCircle.BackgroundTransparency = 1
FovCircle.Parent = ScreenGui
local fovCorner = Instance.new("UICorner", FovCircle)
fovCorner.CornerRadius = UDim.new(1, 0)
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
        MainFrame.Size = UDim2.new(0, 320, 0, 35)
        MinBtn.Text = "+"
        Container.Visible = false
    else
        MainFrame.Size = UDim2.new(0, 320, 0, 380)
        MinBtn.Text = "-"
        Container.Visible = true
    end
end)

-- =============================================================================
-- LOGIC (AIMBOT, VISUALS)
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
                    -- Check against the FOV slider
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
    -- 1. Handle FOV & Crosshair Visibility
    if FovCircle then
        FovCircle.Visible = _G.ShowFov
        -- Update FOV size dynamically
        FovCircle.Size = UDim2.new(0, _G.AimFov * 2, 0, _G.AimFov * 2)
        FovCircle.Position = UDim2.new(0.5, -_G.AimFov, 0.5, -_G.AimFov)
    end
    if Crosshair then
        Crosshair.Visible = _G.ShowCrosshair
    end

    -- 2. Handle Aimbot Camera
    if _G.Aimbot then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild(_G.AimPart) then
            local targetPos = target.Character[_G.AimPart].Position
            local currentCFrame = Camera.CFrame
            local goalCFrame = CFrame.new(currentCFrame.Position, targetPos)
            
            -- Math to turn slider 0-100 into Lerp 0.01-1.0
            local smoothFactor = _G.AimSmooth / 100
            
            if smoothFactor > 0 then
                Camera.CFrame = currentCFrame:Lerp(goalCFrame, smoothFactor)
            end
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