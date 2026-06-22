local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Tworzenie GUI
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "AutoFarmGUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
frame.Draggable = true
frame.Active = true

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Text = "Status: Idle"
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local startButton = Instance.new("TextButton", frame)
startButton.Size = UDim2.new(0.8, 0, 0.4, 0)
startButton.Position = UDim2.new(0.1, 0, 0.4, 0)
startButton.Text = "Start Auto Loop"
startButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

local running = false

local function firePrompt(actionName)
    local found = false
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.ActionText == actionName then
            local parent = obj.Parent
            local pos = (parent:IsA("BasePart") and parent.Position) or (parent:IsA("Model") and parent:GetPrimaryPartCFrame().Position)
            
            if pos and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 2, 0))
                task.wait(0.3)
                fireproximityprompt(obj)
                found = true
                break -- Przejdź do następnego kroku po znalezieniu i kliknięciu
            end
        end
    end
    return found
end

startButton.MouseButton1Click:Connect(function()
    running = not running
    if running then
        startButton.Text = "Stop"
        while running do
            statusLabel.Text = "Status: Harvesting..."
            firePrompt("Harvest")
            task.wait(1)
            
            statusLabel.Text = "Status: Selling..."
            firePrompt("Sell inventory")
            task.wait(1)
        end
    else
        startButton.Text = "Start Auto Loop"
        statusLabel.Text = "Status: Idle"
    end
end)