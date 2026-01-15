local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Lista de tools permitidas
local allowedTools = {
    "MiniGun",
    "SuperFoodZooka",
    "ClassicBaton",
    "Katana",
    "IceBaton",
    "FairyBaton",
    "Grapple",
    "GravityCola",
    "SpeedCola",
    "GhostMode",
    "TeleTool",
    "FoodZooka"
}

-- Tabla para recordar solo las tools que elegiste
local chosenTools = {}

-- Función para buscar recursivamente en ReplicatedStorage
local function findToolInReplicatedStorage(toolName)
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("Tool") and obj.Name == toolName then
            return obj
        end
    end
    return nil
end

-- Función para dar solo una tool específica
local function giveTool(toolName)
    if chosenTools[toolName] then
        print("Ya tienes esta tool:", toolName)
        return
    end

    local toolInStorage = findToolInReplicatedStorage(toolName)
    if toolInStorage then
        local clone = toolInStorage:Clone()
        clone.Parent = player:WaitForChild("Backpack")
        chosenTools[toolName] = true
        print("Tool añadida:", toolName)
    else
        warn("No se encontró la tool en ReplicatedStorage:", toolName)
    end
end

-- Cada vez que reaparezca tu personaje, volver a dar las tools que elegiste
player.CharacterAdded:Connect(function(char)
    local backpack = player:WaitForChild("Backpack")
    for toolName, _ in pairs(chosenTools) do
        local toolInStorage = findToolInReplicatedStorage(toolName)
        if toolInStorage then
            local clone = toolInStorage:Clone()
            clone.Parent = backpack
        end
    end
end)

-- CREAR GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ToolGUI"
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 480)
Frame.Position = UDim2.new(0.5, -150, 0.5, -225)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Title.Text = "OBTENER TOOL"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextScaled = true
Title.Parent = Frame

-- Botón de cerrar
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextScaled = true
CloseButton.Parent = Frame

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Crear botones para cada tool
for i, toolName in ipairs(allowedTools) do
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 260, 0, 30)
    Button.Position = UDim2.new(0, 20, 0, 50 + (i-1)*35)
    Button.Text = "Dar " .. toolName
    Button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSans
    Button.TextScaled = true
    Button.Parent = Frame

    Button.MouseButton1Click:Connect(function()
        giveTool(toolName)
    end)
end

-- Hacer toda la GUI movible
local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
