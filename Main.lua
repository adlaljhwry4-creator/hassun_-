local player = game.Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Name = "LoadingScreen"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(10,10,10)
bg.Parent = gui

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(15,15,15)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(120,0,255))
}
gradient.Rotation = 45
gradient.Parent = bg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0.1,0)
title.Position = UDim2.new(0,0,0.3,0)
title.BackgroundTransparency = 1
title.Text = "Loading... 0%"
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.Parent = bg

local barBack = Instance.new("Frame")
barBack.Size = UDim2.new(0.5,0,0.03,0)
barBack.Position = UDim2.new(0.25,0,0.5,0)
barBack.BackgroundColor3 = Color3.fromRGB(35,35,35)
barBack.BorderSizePixel = 0
barBack.Parent = bg

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,8)
corner.Parent = barBack

local bar = Instance.new("Frame")
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(170,0,255)
bar.BorderSizePixel = 0
bar.Parent = barBack

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0,8)
barCorner.Parent = bar

for i = 1,100 do
	title.Text = "Loading... "..i.."%"
	bar.Size = UDim2.new(i/100,0,1,0)
	task.wait(3) -- 3 ثواني × 100 = 300 ثانية = 5 دقائق
end

title.Text = "Welcome!"
task.wait(2)

gui:Destroy()