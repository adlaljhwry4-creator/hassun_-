local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local function createCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = parent
	return corner
end

local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingScreen"
loadingGui.ResetOnSpawn = false
loadingGui.IgnoreGuiInset = true
loadingGui.Parent = playerGui

local background = Instance.new("Frame")
background.Size = UDim2.fromScale(1, 1)
background.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
background.BorderSizePixel = 0
background.Parent = loadingGui

local backgroundGradient = Instance.new("UIGradient")
backgroundGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
	ColorSequenceKeypoint.new(0.55, Color3.fromRGB(40, 0, 74)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 0, 255))
})
backgroundGradient.Rotation = 45
backgroundGradient.Parent = background

local container = Instance.new("Frame")
container.Size = UDim2.fromScale(1, 1)
container.BackgroundTransparency = 1
container.Parent = loadingGui

local logo = Instance.new("TextLabel")
logo.Size = UDim2.fromOffset(220, 220)
logo.Position = UDim2.new(0.5, 0, 0.32, 0)
logo.AnchorPoint = Vector2.new(0.5, 0.5)
logo.BackgroundTransparency = 1
logo.Font = Enum.Font.GothamBlack
logo.Text = "✦"
logo.TextScaled = true
logo.TextColor3 = Color3.fromRGB(225, 150, 255)
logo.TextStrokeTransparency = 1
logo.TextTransparency = 1
logo.Parent = container

local logoGradient = Instance.new("UIGradient")
logoGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 185, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 15, 255))
})
logoGradient.Parent = logo

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = Color3.fromRGB(180, 0, 255)
logoStroke.Transparency = 1
logoStroke.Thickness = 5
logoStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
logoStroke.Parent = logo

local welcomeLabel = Instance.new("TextLabel")
welcomeLabel.Size = UDim2.new(0.6, 0, 0.09, 0)
welcomeLabel.Position = UDim2.new(0.5, 0, 0.75, 0)
welcomeLabel.AnchorPoint = Vector2.new(0.5, 0.5)
welcomeLabel.BackgroundTransparency = 1
welcomeLabel.Text = "Welcome to My Game"
welcomeLabel.Font = Enum.Font.GothamBold
welcomeLabel.TextScaled = true
welcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
welcomeLabel.TextTransparency = 1
welcomeLabel.Parent = container

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(0.45, 0, 0.06, 0)
loadingText.Position = UDim2.new(0.5, 0, 0.57, 0)
loadingText.AnchorPoint = Vector2.new(0.5, 0.5)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading."
loadingText.Font = Enum.Font.GothamBold
loadingText.TextScaled = true
loadingText.TextColor3 = Color3.fromRGB(240, 240, 240)
loadingText.TextTransparency = 1
loadingText.Parent = container

local progressText = Instance.new("TextLabel")
progressText.Size = UDim2.new(0.55, 0, 0.05, 0)
progressText.Position = UDim2.new(0.5, 0, 0.63, 0)
progressText.AnchorPoint = Vector2.new(0.5, 0.5)
progressText.BackgroundTransparency = 1
progressText.Text = "Loading... 0%"
progressText.Font = Enum.Font.GothamBold
progressText.TextScaled = true
progressText.TextColor3 = Color3.fromRGB(200, 200, 200)
progressText.TextTransparency = 1
progressText.Parent = container

local barBackground = Instance.new("Frame")
barBackground.Size = UDim2.new(0.4, 0, 0.03, 0)
barBackground.Position = UDim2.new(0.5, 0, 0.68, 0)
barBackground.AnchorPoint = Vector2.new(0.5, 0.5)
barBackground.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
barBackground.BorderSizePixel = 0
barBackground.BackgroundTransparency = 1
barBackground.Parent = container
createCorner(barBackground, 12)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(173, 39, 255)
barFill.BorderSizePixel = 0
barFill.BackgroundTransparency = 1
barFill.Parent = barBackground
createCorner(barFill, 12)

local barGlow = Instance.new("UIStroke")
barGlow.Color = Color3.fromRGB(210, 125, 255)
barGlow.Transparency = 1
barGlow.Thickness = 2
barGlow.Parent = barFill

local function fadeElements(elements, targetTransparency, transitionTime)
	for _, element in ipairs(elements) do
		if element:IsA("TextLabel") then
			TweenService:Create(element, TweenInfo.new(transitionTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				TextTransparency = targetTransparency
			}):Play()
		elseif element:IsA("Frame") then
			TweenService:Create(element, TweenInfo.new(transitionTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				BackgroundTransparency = targetTransparency
			}):Play()
		elseif element:IsA("UIStroke") then
			TweenService:Create(element, TweenInfo.new(transitionTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				Transparency = targetTransparency
			}):Play()
		end
	end
end

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local originalWalkSpeed = humanoid.WalkSpeed
local originalJumpPower = humanoid.JumpPower
local originalGravity = workspace.Gravity

humanoid.WalkSpeed = 0
humanoid.JumpPower = 0
humanoid.AutoRotate = false
workspace.Gravity = 0

if rootPart then
	rootPart.AssemblyLinearVelocity = Vector3.zero
	rootPart.AssemblyAngularVelocity = Vector3.zero
end

local fadeInElements = {
	logo,
	logoStroke,
	loadingText,
	progressText,
	barBackground,
	barFill,
	barGlow,
	welcomeLabel
}

fadeElements(fadeInElements, 0, 1.2)

local pulseTween = TweenService:Create(
	logo,
	TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
	{Size = UDim2.fromOffset(230, 230)}
)
pulseTween:Play()

local dots = {".", "..", "..."}
for i = 1, 100 do
	loadingText.Text = "Loading" .. dots[((i - 1) % 3) + 1]
	progressText.Text = string.format("Loading... %d%%", i)

	local sizeTween = TweenService:Create(barFill, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
		Size = UDim2.new(i / 100, 0, 1, 0)
	})
	sizeTween:Play()
	sizeTween.Completed:Wait()
	task.wait(3)
end

progressText.Text = "Loading... 100%"
loadingText.Text = "Loading complete"
welcomeLabel.TextTransparency = 0
welcomeLabel.Text = "Welcome to My Game"

local fadeOutElements = {
	logo,
	logoStroke,
	loadingText,
	progressText,
	barBackground,
	barFill,
	barGlow,
	welcomeLabel
}

fadeElements(fadeOutElements, 1, 1.3)

task.wait(1.4)

humanoid.WalkSpeed = originalWalkSpeed
humanoid.JumpPower = originalJumpPower
humanoid.AutoRotate = true
workspace.Gravity = originalGravity

loadingGui:Destroy()