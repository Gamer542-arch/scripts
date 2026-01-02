local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- ======================
-- MODUŁ GUI
-- ======================
local TeleportGui = {}

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 200)
frame.Position = UDim2.new(0.5, -160, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Parent = screenGui

-- Layout
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = frame

-- Padding
local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 15)
padding.Parent = frame

-- ======================
-- DRAGGABLE FRAME
-- ======================
local dragging, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ======================
-- FUNKCJA PUBLICZNA
-- ======================
function TeleportGui:ButtonCreate(NazwaTP, Kordy)
    assert(typeof(NazwaTP) == "string", "NazwaTP musi być stringiem")
    assert(typeof(Kordy) == "Vector3", "Kordy muszą być Vector3")

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -30, 0, 40)
    button.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Text = NazwaTP
    button.Parent = frame

    button.MouseButton1Click:Connect(function()
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(Kordy)
    end)
end

-- ======================
-- PRZYKŁADOWE UŻYCIE
-- ======================
TeleportGui:ButtonCreate("END  (Not working all maps this script is optionaly)", Vector3.new(-9, 500, 45))
