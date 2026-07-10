local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "LoadingScreen"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(15,15,15)
bg.Parent = gui

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15,15,15)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(120,0,255))
}
gradient.Parent = bg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0.1,0)
title.Position = UDim2.new(0,0,0.35,0)
title.BackgroundTransparency = 1
title.Text = "Loading... 0%"
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.new(1,1,1)
title.Parent = bg

local barBack = Instance.new("Frame")
barBack.Size = UDim2.new(0.5,0,0.03,0)
barBack.Position = UDim2.new(0.25,0,0.5,0)
barBack.BackgroundColor3 = Color3.fromRGB(40,40,40)
barBack.BorderSizePixel = 0
barBack.Parent = bg

local bar = Instance.new("Frame")
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(170,0,255)
bar.BorderSizePixel = 0
bar.Parent = barBack

for i = 1,100 do
	title.Text = "Loading... "..i.."%"
	bar.Size = UDim2.new(i/100,0,1,0)
	task.wait(0.03)
end

title.Text = "Welcome!"
task.wait(1)

gui:Destroy()