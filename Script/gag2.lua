local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Konfiguracja
local PROMPT_NAME = "Harvest" -- Zmień, jeśli prompt nazywa się inaczej
local MAX_COLLECT = 104
local DELAY_TIME = 0.1 -- Czas między zebraniami, aby uniknąć błędów

local function getHarvestPrompts()
    local prompts = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and obj.ActionText:find(PROMPT_NAME) then
            table.insert(prompts, obj)
        end
    end
    return prompts
end

local collectedCount = 0

task.wait(2) -- Czas na załadowanie świata

local prompts = getHarvestPrompts()

for _, prompt in pairs(prompts) do
    if collectedCount >= MAX_COLLECT then break end
    
    local parent = prompt.Parent
    -- Zakładamy, że prompt jest wewnątrz części (BasePart) lub modelu z PrimaryPart
    local targetPosition = (parent:IsA("BasePart") and parent.Position) or (parent:IsA("Model") and parent:GetPrimaryPartCFrame().Position)
    
    if targetPosition then
        -- Teleportacja
        rootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 2, 0))
        task.wait(0.2)
        
        -- Aktywacja prompta
        fireproximityprompt(prompt)
        collectedCount += 1
        
        print("Zebrano: " .. collectedCount)
        task.wait(DELAY_TIME)
    end
end

warn("Zakończono zbieranie lub osiągnięto limit 104 sztuk.")