--[[
    DELTA EXECUTOR SCRIPT
    Fly + Noclip + Anti-Detected System
    UI Simpel & Bersih
]]

-- Variables
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Anti-Detected System (Basic)
local antiDetected = {
    enabled = true,
    fakeWalkSpeed = 16,
    fakeJumpPower = 50,
    lastPosition = rootPart.Position
}

-- Fly System
local fly = {
    enabled = false,
    speed = 50,
    verticalSpeed = 0,
    bodyGyro = nil,
    bodyVelocity = nil
}

-- Noclip System
local noclip = {
    enabled = false,
    connection = nil
}

-- UI Library (Custom Simple)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaFlyUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 200)
MainFrame.Position = UDim2.new(0, 10, 0.5, -100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

-- Title Bar
local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.Text = "Delta Script - Fly & Noclip"
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 14
TitleBar.Parent = MainFrame

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.Parent = MainFrame
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Fly Toggle Button
local FlyButton = Instance.new("TextButton")
FlyButton.Size = UDim2.new(0.9, 0, 0, 35)
FlyButton.Position = UDim2.new(0.05, 0, 0, 40)
FlyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FlyButton.Text = "Fly: OFF"
FlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyButton.Font = Enum.Font.Gotham
FlyButton.TextSize = 14
FlyButton.Parent = MainFrame

-- Noclip Toggle Button
local NoclipButton = Instance.new("TextButton")
NoclipButton.Size = UDim2.new(0.9, 0, 0, 35)
NoclipButton.Position = UDim2.new(0.05, 0, 0, 85)
NoclipButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
NoclipButton.Text = "Noclip: OFF"
NoclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipButton.Font = Enum.Font.Gotham
NoclipButton.TextSize = 14
NoclipButton.Parent = MainFrame

-- Anti-Detected Toggle Button
local AntiDetectedButton = Instance.new("TextButton")
AntiDetectedButton.Size = UDim2.new(0.9, 0, 0, 35)
AntiDetectedButton.Position = UDim2.new(0.05, 0, 0, 130)
AntiDetectedButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
AntiDetectedButton.Text = "Anti-Detected: ON"
AntiDetectedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiDetectedButton.Font = Enum.Font.Gotham
AntiDetectedButton.TextSize = 14
AntiDetectedButton.Parent = MainFrame

-- Speed Slider Label
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.9, 0, 0, 20)
SpeedLabel.Position = UDim2.new(0.05, 0, 0, 175)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Fly Speed: 50"
SpeedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 12
SpeedLabel.Parent = MainFrame

-- Fly Function
local function toggleFly()
    fly.enabled = not fly.enabled
    
    if fly.enabled then
        -- Create BodyGyro
        fly.bodyGyro = Instance.new("BodyGyro")
        fly.bodyGyro.MaxTorque = Vector3.new(0, 0, 0)
        fly.bodyGyro.D = 100
        fly.bodyGyro.P = 10000
        fly.bodyGyro.Parent = rootPart
        
        -- Create BodyVelocity
        fly.bodyVelocity = Instance.new("BodyVelocity")
        fly.bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        fly.bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        fly.bodyVelocity.Parent = rootPart
        
        -- Set humanoid properties
        humanoid.PlatformStand = true
        humanoid.WalkSpeed = 0
        
        FlyButton.Text = "Fly: ON"
        FlyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        -- Remove body objects
        if fly.bodyGyro then fly.bodyGyro:Destroy() end
        if fly.bodyVelocity then fly.bodyVelocity:Destroy() end
        
        -- Reset humanoid
        humanoid.PlatformStand = false
        humanoid.WalkSpeed = 16
        
        FlyButton.Text = "Fly: OFF"
        FlyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end

-- Noclip Function
local function toggleNoclip()
    noclip.enabled = not noclip.enabled
    
    if noclip.enabled then
        noclip.connection = game:GetService("RunService").Stepped:Connect(function()
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
        
        NoclipButton.Text = "Noclip: ON"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        if noclip.connection then
            noclip.connection:Disconnect()
            noclip.connection = nil
        end
        
        NoclipButton.Text = "Noclip: OFF"
        NoclipButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end

-- Anti-Detected Function
local function toggleAntiDetected()
    antiDetected.enabled = not antiDetected.enabled
    
    if antiDetected.enabled then
        AntiDetectedButton.Text = "Anti-Detected: ON"
        AntiDetectedButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    else
        AntiDetectedButton.Text = "Anti-Detected: OFF"
        AntiDetectedButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end

-- Button Connections
FlyButton.MouseButton1Click:Connect(toggleFly)
NoclipButton.MouseButton1Click:Connect(toggleNoclip)
AntiDetectedButton.MouseButton1Click:Connect(toggleAntiDetected)

-- Fly Control Loop
game:GetService("RunService").RenderStepped:Connect(function()
    if fly.enabled and rootPart then
        -- Get input direction
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new(
            camera.CFrame.RightVector.X * (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) and 1 or 0) + 
            camera.CFrame.RightVector.X * (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) and -1 or 0) +
            camera.CFrame.LookVector.X * (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) and 1 or 0) +
            camera.CFrame.LookVector.X * (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) and -1 or 0),
            0,
            camera.CFrame.RightVector.Z * (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) and 1 or 0) + 
            camera.CFrame.RightVector.Z * (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) and -1 or 0) +
            camera.CFrame.LookVector.Z * (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) and 1 or 0) +
            camera.CFrame.LookVector.Z * (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) and -1 or 0)
        )
        
        -- Vertical movement
        local vertical = 0
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
            vertical = 1
        elseif game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
            vertical = -1
        end
        
        -- Apply velocity
        if fly.bodyVelocity then
            fly.bodyVelocity.Velocity = (moveDirection * fly.speed) + Vector3.new(0, vertical * fly.speed, 0)
        end
        
        -- Update speed label
        SpeedLabel.Text = "Fly Speed: " .. math.floor(fly.speed)
    end
    
    -- Anti-Detected System
    if antiDetected.enabled then
        -- Reset humanoid stats to look normal
        if humanoid.WalkSpeed ~= 16 and not fly.enabled then
            humanoid.WalkSpeed = 16
        end
        if humanoid.JumpPower ~= 50 then
            humanoid.JumpPower = 50
        end
        
        -- Fake position if needed (advanced anti-detection)
        -- This is basic, can be expanded
    end
end)

-- Speed Adjustment (Hold E to increase, Q to decrease)
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E and fly.enabled then
        fly.speed = math.min(fly.speed + 10, 200)
    elseif input.KeyCode == Enum.KeyCode.Q and fly.enabled then
        fly.speed = math.max(fly.speed - 10, 10)
    end
end)

-- Character Respawn Handling
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Reapply fly if enabled
    if fly.enabled then
        fly.enabled = false
        toggleFly()
    end
    
    -- Reapply noclip if enabled
    if noclip.enabled then
        noclip.enabled = false
        toggleNoclip()
    end
end)

-- Notification
game.StarterGui:SetCore("SendNotification", {
    Title = "Delta Script Loaded",
    Text = "Fly & Noclip script ready!",
    Duration = 3
})
