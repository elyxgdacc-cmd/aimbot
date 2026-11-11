-- =============================================================================
-- PRISON LIFE - CAR BRINGER
-- =============================================================================

if game.CoreGui:FindFirstChild("DeltaCarMenu") then
    game.CoreGui.DeltaCarMenu:Destroy()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaCarMenu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 300) 
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Active = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local stroke = Instance.new("UIStroke", MainFrame)
stroke.Color = Color3.fromRGB(255, 165, 0) -- Orange theme
stroke.Thickness = 1.5

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "CAR BRINGER"
Title.TextColor3 = Color3.fromRGB(255, 165, 0)
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

-- Scroll List
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -10, 1, -35)
Container.Position = UDim2.new(0, 5, 0, 35)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(255, 165, 0)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.AutomaticCanvasSize = Enum.AutomaticSize.Y
Container.Parent = MainFrame
local layout = Instance.new("UIListLayout", Container)
layout.Padding = UDim.new(0, 4)

-- Add Refresh Button
local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(1, 0, 0, 30)
refreshBtn.BackgroundColor3 = Color3.fromRGB(40, 60, 80)
refreshBtn.Text = "🔄 Refresh Car List"
refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshBtn.Font = Enum.Font.GothamBold
refreshBtn.TextSize = 11
refreshBtn.Parent = Container
Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 6)

-- Function to create a car button
local function CreateCarButton(carModel)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = carModel.Name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 10
    btn.Parent = Container
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(0, 60, 0, 20)
    tpBtn.Position = UDim2.new(1, -65, 0, 6)
    tpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    tpBtn.Text = "TP to Car"
    tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpBtn.Font = Enum.Font.GothamBold
    tpBtn.TextSize = 9
    tpBtn.Parent = btn
    Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 4)

    -- Teleport to Car
    tpBtn.MouseButton1Click:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local seat = carModel:FindFirstChildWhichIsA("VehicleSeat")
            local hrp = carModel.PrimaryPart or carModel:FindFirstChildWhichIsA("BasePart")
            
            if seat then
                LocalPlayer.Character.HumanoidRootPart.CFrame = seat.CFrame + Vector3.new(0, 3, 0)
            elseif hrp then
                LocalPlayer.Character.HumanoidRootPart.CFrame = hrp.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end)
    
    -- Bring Car to You
    btn.MouseButton1Click:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local carRoot = carModel.PrimaryPart or carModel:FindFirstChildWhichIsA("BasePart")
            if carRoot then
                -- Teleports the car to you
                carModel:PivotTo(hrp.CFrame * CFrame.new(0, 0, -10)) 
            end
        end
    end)
end

-- Scan function
local function RefreshCars()
    for _, child in ipairs(Container:GetChildren()) do
        if child:IsA("TextButton") and child ~= refreshBtn then
            child:Destroy()
        end
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        -- Prison Life cars are usually Models with VehicleSeats
        if obj:IsA("Model") and obj:FindFirstChildWhichIsA("VehicleSeat") then
            -- Filter out the hacker's cars if they are too high in the sky (optional safety)
            local root = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
            if root and root.Position.Y < 500 then 
                CreateCarButton(obj)
            end
        end
    end
end

refreshBtn.MouseButton1Click:Connect(RefreshCars)

-- Initialize
task.spawn(RefreshCars)

-- Minimize Logic
local isMinimized = false
MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame.Size = UDim2.new(0, 220, 0, 30)
        MinBtn.Text = "+"
        Container.Visible = false
    else
        MainFrame.Size = UDim2.new(0, 220, 0, 300)
        MinBtn.Text = "-"
        Container.Visible = true
    end
end)

-- Dragging
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