-- [[ RAYFIELD COIN FARMER SCRIPT ]] --

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

local speed = 25
local farming = false
local coinName = "Coin" 

local userId = player.UserId
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size150x150
local profileAssetId, isReady = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
if not isReady then
    profileAssetId = "rbxassetid://0"
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Sleep for UGC | Coin Farmer",
   LoadingTitle = "Loading System...",
   LoadingSubtitle = "by EZLOL1112",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local MainTab = Window:CreateTab("Farmer Controls", 4483362458)

local ProfileImage = MainTab:CreateImage({
   Name = player.DisplayName or player.Name,
   Image = profileAssetId,
   ImageSize = Vector2.new(100, 100),
   Description = "Active User Profile"
})

local function getClosestCoin()
    local closestCoin = nil
    local shortestDistance = math.huge
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == coinName and obj:IsA("BasePart") then
            local distance = (rootPart.Position - obj.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestCoin = obj
            end
        end
    end
    return closestCoin
end

local Toggle = MainTab:CreateToggle({
   Name = "Auto Farm Coins",
   CurrentValue = false,
   Flag = "CoinToggle",
   Callback = function(Value) farming = Value end,
})

local Slider = MainTab:CreateSlider({
   Name = "Tween Speed Multiplier",
   Min = 1,
   Max = 50,
   CurrentValue = 25,
   Increment = 1,
   ValueName = "Speed",
   Callback = function(Value) speed = Value end,
})

task.spawn(function()
    while true do
        task.wait(0.1)
        if farming then
            character = player.Character or player.CharacterAdded:Wait()
            rootPart = character:WaitForChild("HumanoidRootPart")
            local targetCoin = getClosestCoin()
            if targetCoin then
                local distance = (rootPart.Position - targetCoin.Position).Magnitude
                local duration = distance / speed
                local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
                local tween = TweenService:Create(rootPart, tweenInfo, {CFrame = targetCoin.CFrame})
                tween:Play()
                local completed = false
                local connection
                connection = tween.Completed:Connect(function()
                    completed = true
                    connection:Disconnect()
                end)
                while not completed and farming do task.wait(0.05) end
                if not farming then tween:Cancel() end
            end
        end
    end
end)

Rayfield:Notify({
   Title = "Script Status",
   Content = "Successfully Executed!",
   Duration = 4,
   Image = 4483362458,
})
