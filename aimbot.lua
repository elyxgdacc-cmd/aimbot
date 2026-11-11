-- =============================================================================
-- PRISON LIFE - AUTO 100X FIRE (TOGGLE)
-- =============================================================================

if game.CoreGui:FindFirstChild("DeltaGunMenu") then
    game.CoreGui.DeltaGunMenu:Destroy()
end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")

local isEnabled = false
local isFiring = false -- Prevents crashing if you click too fast
local connection = nil

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaGunMenu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 130) 
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -65)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Active = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local stroke = Instance.new("UIStroke", MainFrame)
stroke.Color = Color3.fromRGB(255, 50, 50) 
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
Title.Text = "AUTO 100X FIRE"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, -20, 0, 35)
toggleBtn.Position = UDim2.new(0, 10, 0, 45)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.Text = "🔫 100x Fire: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 12
toggleBtn.Parent = MainFrame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

local stat = Instance.new("TextLabel")
stat.Size = UDim2.new(1, -20, 0, 20)
stat.Position = UDim2.new(0, 10, 0, 90)
stat.BackgroundTransparency = 1
stat.Text = "Ready."
stat.TextColor3 = Color3.fromRGB(200, 200, 200)
stat.Font = Enum.Font.GothamMedium
stat.TextSize = 10
stat.TextXAlignment = Enum.TextXAlignment.Left
stat.Parent = MainFrame

-- Toggle Logic
toggleBtn.MouseButton1Click:Connect(function()
    isEnabled = not isEnabled
    
    if isEnabled then
        toggleBtn.Text = "🔫 100x Fire: ON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        stat.Text = "Equip a gun and click."
        
        -- Hook into mouse click
        connection = UIS.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed or isFiring then return end
            
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local char = LocalPlayer.Character
                local tool = char and char:FindFirstChildWhichIsA("Tool")
                
                -- Make sure we have a gun and the ShootEvent
                if tool and RS:FindFirstChild("ShootEvent", true) then
                    isFiring = true
                    local shootEvent = RS:FindFirstChild("ShootEvent", true)
                    local camera = workspace.CurrentCamera
                    local mouse = LocalPlayer:GetMouse()
                    
                    -- Get aim direction
                    local targetPos = mouse.Hit.Position
                    local origin = camera.CFrame.Position
                    local direction = (targetPos - origin).Unit
                    
                    -- Fire 100 times instantly
                    for i = 1, 100 do
                        pcall(function()
                            shootEvent:FireServer(origin, direction)
                        end)
                    end
                    
                    -- Wait a tiny bit before allowing another shot to prevent crashing
                    task.wait(0.3)
                    isFiring = false
                end
            end
        end)
        
    else
        toggleBtn.Text = "🔫 100x Fire: OFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        stat.Text = "Disabled."
        
        -- Disconnect the click hook
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end)

-- Draggable
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
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)