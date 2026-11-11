-- =============================================================================
-- PRISON LIFE - ONE-CLICK OP GUN
-- =============================================================================

if game.CoreGui:FindFirstChild("OPGunMenu") then
    game.CoreGui.OPGunMenu:Destroy()
end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "OPGunMenu"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 120) 
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -60)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.Active = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local stroke = Instance.new("UIStroke", MainFrame)
stroke.Color = Color3.fromRGB(0, 255, 100) 
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
Title.Text = "OP GUN MODIFIER"
Title.TextColor3 = Color3.fromRGB(0, 255, 100)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- The One Button to Rule Them All
local forceBtn = Instance.new("TextButton")
forceBtn.Size = UDim2.new(1, -20, 0, 40)
forceBtn.Position = UDim2.new(0, 10, 0, 45)
forceBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
forceBtn.Text = "💥 Make Equipped Gun OP"
forceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
forceBtn.Font = Enum.Font.GothamBold
forceBtn.TextSize = 12
forceBtn.Parent = MainFrame
Instance.new("UICorner", forceBtn).CornerRadius = UDim.new(0, 6)

local stat = Instance.new("TextLabel")
stat.Size = UDim2.new(1, -20, 0, 20)
stat.Position = UDim2.new(0, 10, 0, 90)
stat.BackgroundTransparency = 1
stat.Text = "Equip a gun and click."
stat.TextColor3 = Color3.fromRGB(200, 200, 200)
stat.Font = Enum.Font.GothamMedium
stat.TextSize = 10
stat.TextXAlignment = Enum.TextXAlignment.Left
stat.Parent = MainFrame

forceBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    local tool = char and char:FindFirstChildWhichIsA("Tool")
    
    if tool then
        stat.Text = "Modding " .. tool.Name .. "..."
        forceBtn.Text = "Working..."
        
        -- 1. Delete the LocalScripts inside the gun
        local deleted = 0
        for _, child in ipairs(tool:GetDescendants()) do
            if child:IsA("LocalScript") or child:IsA("ModuleScript") then
                child:Destroy()
                deleted = deleted + 1
            end
        end
        
        -- 2. Wipe the memory tables (Cooldown + Reload)
        local wiped = 0
        pcall(function()
            for _, obj in pairs(getgc(true)) do
                if type(obj) == "table" then
                    -- Find all variations of cooldown and reload
                    if rawget(obj, "FireRate") then rawset(obj, "FireRate", 0) wiped = wiped + 1 end
                    if rawget(obj, "Cooldown") then rawset(obj, "Cooldown", 0) wiped = wiped + 1 end
                    if rawget(obj, "ReloadTime") then rawset(obj, "ReloadTime", 0) wiped = wiped + 1 end
                    if rawget(obj, "LastShot") then rawset(obj, "LastShot", 0) wiped = wiped + 1 end
                    if rawget(obj, "Debounce") then rawset(obj, "Debounce", 0) wiped = wiped + 1 end
                    if rawget(obj, "Ammo") then rawset(obj, "Ammo", 999) wiped = wiped + 1 end
                    if rawget(obj, "Mag") then rawset(obj, "Mag", 999) wiped = wiped + 1 end
                end
            end
        end)
        
        stat.Text = "✅ OP! Deleted " .. deleted .. " scripts, wiped " .. wiped .. " timers."
        forceBtn.Text = "✅ Gun is OP"
        
        task.wait(3)
        forceBtn.Text = "💥 Make Equipped Gun OP"
        stat.Text = "Equip a gun and click."
    else
        stat.Text = "❌ Equip a gun first!"
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