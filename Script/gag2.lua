local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. Tworzenie GUI
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "AutoHarvestGUI"
screenGui.ResetOnSpawn = false -- Nie usuwa się po śmierci

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true -- Umożliwia przenoszenie myszką

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Auto Harvest Script"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextSize = 14

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.8, 0, 0.4, 0)
button.Position = UDim2.new(0.1, 0, 0.45, 0)
button.Text = "Start Collect (104x)"
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.new(1, 1, 1)

-- 2. Logika zbierania
local function runAutoHarvest()
    local character = player.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local prompts = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.ActionText:find("Harvest") then
            table.insert(prompts, obj)
        end
    end

    local collectedCount = 0
    for _, prompt in pairs(prompts) do
        if collectedCount >= 104 then break end
        
        local parent = prompt.Parent
        local pos = (parent:IsA("BasePart") and parent.Position) 
                 or (parent:IsA("Model") and parent:GetPrimaryPartCFrame().Position)
        
        if pos then
            rootPart.CFrame = CFrame.new(pos + Vector3.new(0, 2, 0))
            task.wait(0.2)
            fireproximityprompt(prompt)
            collectedCount += 1
            button.Text = "Zbieranie: " .. collectedCount
            task.wait(0.3)
        end
    end
    button.Text = "Zakończono!"
    task.wait(2)
    button.Text = "Start Collect (104x)"
end

-- 3. Aktywacja przycisku
button.MouseButton1Click:Connect(runAutoHarvest)
