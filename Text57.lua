local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

local TOOL_NAME = "TeleTool"

local function searchAndClone(container)
    for _, obj in ipairs(container:GetDescendants()) do
        if obj:IsA("Tool") and obj.Name == TOOL_NAME then
            local clone = obj:Clone()
            clone.Parent = backpack
            warn("TeleTool encontrada y clonada desde:", container.Name)
            return true
        end
    end
    return false
end

-- Buscar en Character
if player.Character then
    if searchAndClone(player.Character) then return end
end

-- Buscar en Backpack
if searchAndClone(backpack) then return end

-- Buscar en Workspace
if searchAndClone(workspace) then return end

-- Buscar en ReplicatedStorage
if searchAndClone(ReplicatedStorage) then return end

warn("❌ TeleTool NO existe en contenedores accesibles al cliente")
