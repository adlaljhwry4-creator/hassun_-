local Players = game:GetService("Players")

local MAILBOX_OWNER = "dsdogs1312"
local MAX_SAFE_VALUE = 999999999

local function ensureMailbox()
	local mailbox = workspace:FindFirstChild("Mailbox")
	if mailbox then
		return mailbox
	end

	mailbox = Instance.new("Part")
	mailbox.Name = "Mailbox"
	mailbox.Size = Vector3.new(6, 6, 6)
	mailbox.Anchored = true
	mailbox.CanCollide = false
	mailbox.Color = Color3.fromRGB(149, 82, 255)
	mailbox.Material = Enum.Material.Neon
	mailbox.Position = Vector3.new(0, 4, 0)
	mailbox.Parent = workspace
	mailbox:SetAttribute("OwnerName", MAILBOX_OWNER)

	local sendPrompt = Instance.new("ProximityPrompt")
	sendPrompt.Name = "Send"
	sendPrompt.ActionText = "Send"
	sendPrompt.ObjectText = "Mailbox"
	sendPrompt.RequiresLineOfSight = false
	sendPrompt.MaxActivationDistance = 12
	sendPrompt.Parent = mailbox

	local ownerValue = Instance.new("StringValue")
	ownerValue.Name = "OwnerName"
	ownerValue.Value = MAILBOX_OWNER
	ownerValue.Parent = mailbox

	return mailbox
end

local function ensureLeaderstats(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if leaderstats then
		return leaderstats
	end

	leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	return leaderstats
end

local function ensureStat(player, statName)
	local leaderstats = ensureLeaderstats(player)
	local stat = leaderstats:FindFirstChild(statName)
	if stat then
		return stat
	end

	stat = Instance.new("IntValue")
	stat.Name = statName
	stat.Value = 0
	stat.Parent = leaderstats
	return stat
end

local function secureMailboxCheck(player)
	ensureLeaderstats(player)

	local petsStat = ensureStat(player, "Pets")
	local jewelsStat = ensureStat(player, "Jewels")

	local pets = petsStat.Value
	local jewels = jewelsStat.Value
	local verified = pets >= 0 and jewels >= 0 and pets <= MAX_SAFE_VALUE and jewels <= MAX_SAFE_VALUE

	player:SetAttribute("MailboxOwner", MAILBOX_OWNER)
	player:SetAttribute("MailboxVerified", verified)
	player:SetAttribute("MailboxStatus", verified and "Verified" or "Suspicious")

	if not verified then
		petsStat.Value = 0
		jewelsStat.Value = 0
	end

	return verified
end

local mailbox = ensureMailbox()
local sendPrompt = mailbox:FindFirstChild("Send")

if sendPrompt then
	sendPrompt.Triggered:Connect(function(player)
		local character = player.Character
		local rootPart = character and character:FindFirstChild("HumanoidRootPart")
		if rootPart then
			rootPart.CFrame = mailbox.CFrame + Vector3.new(0, 4, 0)
		end

		local verified = secureMailboxCheck(player)
		if verified then
			print(player.Name .. " passed Mailbox security check.")
		else
			print(player.Name .. " failed Mailbox security check.")
		end
	end)
end

Players.PlayerAdded:Connect(function(player)
	ensureLeaderstats(player)
	ensureStat(player, "Pets")
	ensureStat(player, "Jewels")
	player:SetAttribute("MailboxOwner", MAILBOX_OWNER)
	player:SetAttribute("MailboxVerified", false)
	player:SetAttribute("MailboxStatus", "Idle")
end)
