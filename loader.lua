-- Only run this script if you're in the correct place
if game.PlaceId ~= 100490989733123 then
    warn("Dachshund Hub: Not in supported place. Script stopped.")
    game.StarterGui:SetCore("SendNotification", {
        Title = "🐕 Dachshund Hub",
        Text = "This script only works in the supported game!",
        Duration = 5
    })
    return -- stop the script
end

-----------------------------------------------------
-- // MAIN SCRIPT STARTS HERE
-----------------------------------------------------
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "🐕 Dachshund Hub",
   LoadingTitle = "Testing Testing 123",
   LoadingSubtitle = "via Mr Dachshund",
   ShowText = "Dachshund Hub",
   Theme = "Amethyst",

   ToggleUIKeybind = "T",

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = true,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = true,
      FileName = "Dachshund Hub"
   },

   Discord = {
      Enabled = true,
      Invite = "discord.gg/dachshundhub",
      RememberJoins = true
   },

   KeySystem = true,
   KeySettings = {
      Title = "🐕 Dachshund Hub",
      Subtitle = "Key System",
      Note = "Join The Discord To Access Key Discord.gg/DachshundHub",
      FileName = "DachshundTestHubKey",
      SaveKey = false,
      GrabKeyFromSite = true,
      Key = {"https://pastebin.com/raw/cMbek3ga"}
   }
})

local MainTab = Window:CreateTab("🏠 Home", nil)
local TogglesSection = MainTab:CreateSection("Toggles")

Rayfield:Notify({
   Title = "You executed the script",
   Content = "Discord.gg/DachshundHub",
   Duration = 5,
   Image = 13047715178,
   Actions = {
      Ignore = {
         Name = "Okay!",
         Callback = function()
            print("User tapped Okay!")
         end
      },
   },
})

local vu = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   task.wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-----------------------------------------------------
-- // INFINITE JUMP (Toggle)
-----------------------------------------------------
local infinjumpEnabled = false

local function toggleInfiniteJump(state)
	infinjumpEnabled = state
	local plr = game:GetService("Players").LocalPlayer
	local m = plr:GetMouse()
	
	if infinjumpEnabled then
		game.StarterGui:SetCore("SendNotification", {Title="Dachshund Hub"; Text="Infinite Jump: ON"; Duration=3;})
	else
		game.StarterGui:SetCore("SendNotification", {Title="Dachshund Hub"; Text="Infinite Jump: OFF"; Duration=3;})
	end

	if not _G.infinJumpStarted then
		_G.infinJumpStarted = true
		m.KeyDown:connect(function(k)
			if infinjumpEnabled and k:byte() == 32 then
				local humanoid = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
				if humanoid then
					humanoid:ChangeState("Jumping")
					wait()
					humanoid:ChangeState("Seated")
				end
			end
		end)
	end
end

local InfiniteJumpToggle = MainTab:CreateToggle({
	Name = "Infinite Jump",
	CurrentValue = false,
	Flag = "infinitejump",
	Callback = function(Value)
		toggleInfiniteJump(Value)
	end,
})

-----------------------------------------------------
-- // Noclip (Toggle)
-----------------------------------------------------
local noclip = false
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local function setNoclip(state)
	noclip = state
	if noclip then
		game.StarterGui:SetCore("SendNotification", {Title="Dachshund Hub"; Text="Noclip: ON"; Duration=2;})
	else
		game.StarterGui:SetCore("SendNotification", {Title="Dachshund Hub"; Text="Noclip: OFF"; Duration=2;})
	end
end

game:GetService("RunService").Stepped:Connect(function()
	if noclip and char then
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

local NoclipToggle = MainTab:CreateToggle({
	Name = "No clip",
	CurrentValue = false,
	Flag = "nocliptoggle",
	Callback = function(Value)
		setNoclip(Value)
	end,
})

-----------------------------------------------------
-- // FLY SYSTEM (Toggle + Speed Slider)
-----------------------------------------------------
local flying = false
local flySpeed = 80
local bodyGyro
local bodyVelocity
local uis = game:GetService("UserInputService")

local function startFly()
	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
	bodyGyro.P = 3000
	bodyGyro.CFrame = hrp.CFrame
	bodyGyro.Parent = hrp

	bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
	bodyVelocity.Velocity = Vector3.zero
	bodyVelocity.Parent = hrp

	game:GetService("RunService").RenderStepped:Connect(function()
		if flying and bodyGyro and bodyVelocity then
			local cam = workspace.CurrentCamera
			bodyGyro.CFrame = cam.CFrame
			local moveDirection = Vector3.zero

			if uis:IsKeyDown(Enum.KeyCode.W) then moveDirection += cam.CFrame.LookVector end
			if uis:IsKeyDown(Enum.KeyCode.S) then moveDirection -= cam.CFrame.LookVector end
			if uis:IsKeyDown(Enum.KeyCode.A) then moveDirection -= cam.CFrame.RightVector end
			if uis:IsKeyDown(Enum.KeyCode.D) then moveDirection += cam.CFrame.RightVector end
			if uis:IsKeyDown(Enum.KeyCode.Space) then moveDirection += Vector3.new(0, 1, 0) end
			if uis:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection -= Vector3.new(0, 1, 0) end

			if moveDirection.Magnitude > 0 then
				bodyVelocity.Velocity = moveDirection.Unit * flySpeed
			else
				bodyVelocity.Velocity = Vector3.zero
			end
		end
	end)
end

local function stopFly()
	if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
	if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
end

local FlyToggle = MainTab:CreateToggle({
	Name = "Fly",
	CurrentValue = false,
	Flag = "flytoggle",
	Callback = function(Value)
		flying = Value
		if flying then
			startFly()
			game.StarterGui:SetCore("SendNotification", {Title="Dachshund Hub"; Text="Fly: ON"; Duration=3;})
		else
			stopFly()
			game.StarterGui:SetCore("SendNotification", {Title="Dachshund Hub"; Text="Fly: OFF"; Duration=3;})
		end
	end,
})

-----------------------------------------------------
-- // SLIDERS (Speed, Jump, Fly Speed)
-----------------------------------------------------
local TogglesSection = MainTab:CreateSection("Sliders")

local WalkSpeedSlider = MainTab:CreateSlider({
	Name = "Walk Speed",
	Range = {1, 350},
	Increment = 1,
	Suffix = "Speed",
	CurrentValue = 16,
	Flag = "walkspeed",
	Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
	end,
})

local JumpPowerSlider = MainTab:CreateSlider({
	Name = "Jump Power",
	Range = {1, 350},
	Increment = 1,
	Suffix = "Power",
	CurrentValue = 50,
	Flag = "jumppower",
	Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
	end,
})

local FlySpeedSlider = MainTab:CreateSlider({
	Name = "Fly Speed",
	Range = {10, 350},
	Increment = 5,
	Suffix = "Speed",
	CurrentValue = 80,
	Flag = "flyspeed",
	Callback = function(Value)
		flySpeed = Value
	end,
})

-----------------------------------------------------
-- // 🌕 Custom Gravity Slider
-----------------------------------------------------
MainTab:CreateSlider({
	Name = "Custom Gravity",
	Range = {0, 196.2},
	Increment = 1,
	Suffix = "Gravity",
	CurrentValue = 196.2,
	Flag = "customgravity",
	Callback = function(Value)
		workspace.Gravity = Value
	end,
})

-----------------------------------------------------
-- // TELEPORTS TAB
-----------------------------------------------------
local OtherTab = Window:CreateTab("📌Other", nil)
local TeleportSection = OtherTab:CreateSection("Teleports")

-- Teleport coordinates
local teleportCoords = Vector3.new(-68.38, 45, -32.97)

-- Teleport function
local function teleportToSafeZone()
	local player = game.Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	hrp.CFrame = CFrame.new(teleportCoords)

	game.StarterGui:SetCore("SendNotification", {
		Title = "🐕 Dachshund Hub",
		Text = "Teleported to Safe Zone!",
		Duration = 3
	})
end

-- Create button
local TeleportButton = OtherTab:CreateButton({
	Name = "Teleport To Safe Zone",
	Callback = teleportToSafeZone
})

-- Create keybind (change "G" to any key you want)
local TeleportKeybind = OtherTab:CreateKeybind({
	Name = "Teleport Keybind",
	CurrentKeybind = "G",
	HoldToInteract = false,
	Flag = "teleportkeybind",
	Callback = function(Keybind)
		teleportToSafeZone()
	end,
})

-- ✅ SAFETY CHECK
if not Window then
   warn("Dachshund Hub Addon: Rayfield window missing.")
   return
end

-----------------------------------------------------
-- // UTILITIES TAB
-----------------------------------------------------
local UtilTab = Window:CreateTab("⚙️ Utilities", nil)
local UtilSection = UtilTab:CreateSection("System Tools")

-- Reset Character
UtilTab:CreateButton({
   Name = "Reset Character",
   Callback = function()
      local player = game.Players.LocalPlayer
      if player.Character then
         player.Character:BreakJoints()
         game.StarterGui:SetCore("SendNotification", {
            Title = "🐕 Dachshund Hub",
            Text = "Character reset!",
            Duration = 3
         })
      end
   end,
})

-- Rejoin Game
UtilTab:CreateButton({
   Name = "Rejoin Game",
   Callback = function()
      local TeleportService = game:GetService("TeleportService")
      TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
   end,
})

-- Server Hop
UtilTab:CreateButton({
   Name = "Server Hop",
   Callback = function()
      local Http = game:GetService("HttpService")
      local TPS = game:GetService("TeleportService")
      local Api = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
      local Servers = Http:JSONDecode(game:HttpGet(Api))
      for _,v in pairs(Servers.data) do
         if v.playing < v.maxPlayers then
            TPS:TeleportToPlaceInstance(game.PlaceId, v.id)
            break
         end
      end
   end,
})

-----------------------------------------------------
-- // VISUALS TAB
-----------------------------------------------------
local VisualTab = Window:CreateTab("🎨 Visuals", nil)
local VisualSection = VisualTab:CreateSection("Graphics & Lighting")

-- Fullbright toggle
local FullbrightToggle = VisualTab:CreateToggle({
   Name = "Fullbright",
   CurrentValue = false,
   Flag = "fullbright",
   Callback = function(Value)
      local lighting = game:GetService("Lighting")
      if Value then
         lighting.Brightness = 2
         lighting.ClockTime = 14
         lighting.FogEnd = 1e6
         lighting.GlobalShadows = false
         lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
         game.StarterGui:SetCore("SendNotification", {Title="Dachshund Hub"; Text="Fullbright: ON"; Duration=3})
      else
         lighting.GlobalShadows = true
         game.StarterGui:SetCore("SendNotification", {Title="Dachshund Hub"; Text="Fullbright: OFF"; Duration=3})
      end
   end,
})

-- Remove Fog instantly
VisualTab:CreateButton({
   Name = "Remove Fog",
   Callback = function()
      local lighting = game:GetService("Lighting")
      lighting.FogStart = 1e6
      lighting.FogEnd = 1e6
      game.StarterGui:SetCore("SendNotification", {Title="Dachshund Hub"; Text="Fog removed!"; Duration=3})
   end,
})

-----------------------------------------------------
-- // ANTI-AFK SYSTEM
-----------------------------------------------------
local vu = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
   vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
   task.wait(1)
   vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-----------------------------------------------------
-- // STATUS HUD
-----------------------------------------------------
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local DachshundHUD = Instance.new("ScreenGui")
DachshundHUD.Name = "DachshundHUD"
DachshundHUD.ResetOnSpawn = false
DachshundHUD.Parent = CoreGui

local Status = Instance.new("TextLabel")
Status.Parent = DachshundHUD
Status.Position = UDim2.new(0, 15, 0, 15)
Status.Size = UDim2.new(0, 260, 0, 50)
Status.BackgroundTransparency = 0.5
Status.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Status.BorderSizePixel = 0
Status.TextColor3 = Color3.fromRGB(255, 255, 255)
Status.Font = Enum.Font.GothamBold
Status.TextSize = 15
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.TextYAlignment = Enum.TextYAlignment.Center
Status.TextStrokeTransparency = 0.7

-- auto-update status
RunService.RenderStepped:Connect(function()
   local ws = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed or 0
   Status.Text = string.format("🐕 Dachshund Hub Active\nWalkSpeed: %d | Fly: %s | Noclip: %s",
      ws,
      tostring(flying and "ON" or "OFF"),
      tostring(noclip and "ON" or "OFF"))
end)

-- ✅ SAFETY CHECK
if not Window then
   warn("Dachshund Hub Addon: Rayfield window missing.")
   return
end

-----------------------------------------------------
-- // ESP SETUP
-----------------------------------------------------
local ESPTab = Window:CreateTab("👁️ ESP / Finder", nil)
local ESPSection = ESPTab:CreateSection("Player ESP & Finder")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ESP_Highlights = {}
local ESP_Enabled = false

-- Default ESP Colors
local ESPColor_Outline = Color3.fromRGB(0, 255, 255)
local ESPColor_Text = Color3.fromRGB(0, 255, 255)

-- Function: Create ESP visuals for a player
local function createESP(player)
	if player == LocalPlayer then return end
	if not player.Character then return end
	if ESP_Highlights[player] then return end

	local highlight = Instance.new("Highlight")
	highlight.Name = "DachshundESP"
	highlight.FillTransparency = 1
	highlight.OutlineColor = ESPColor_Outline
	highlight.Parent = player.Character
	ESP_Highlights[player] = highlight

	-- Billboard name tag
	local head = player.Character:FindFirstChild("Head")
	if not head then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "NameTag"
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = player.Name
	label.TextColor3 = ESPColor_Text
	label.Font = Enum.Font.GothamBold
	label.TextScaled = true
	label.Parent = billboard

	billboard.Parent = head
end

-- Function: Remove ESP
local function removeESP(player)
	if ESP_Highlights[player] then
		if ESP_Highlights[player].Parent then
			ESP_Highlights[player]:Destroy()
		end
		ESP_Highlights[player] = nil
	end
	if player.Character and player.Character:FindFirstChild("NameTag") then
		player.Character.NameTag:Destroy()
	end
end

-- Toggle ESP
ESPTab:CreateToggle({
	Name = "Enable Player ESP",
	CurrentValue = false,
	Flag = "playeresp",
	Callback = function(Value)
		ESP_Enabled = Value
		if Value then
			for _, player in pairs(Players:GetPlayers()) do
				createESP(player)
			end
			game.StarterGui:SetCore("SendNotification", {
				Title = "🐕 Dachshund Hub",
				Text = "ESP Enabled",
				Duration = 3
			})
		else
			for _, player in pairs(Players:GetPlayers()) do
				removeESP(player)
			end
			game.StarterGui:SetCore("SendNotification", {
				Title = "🐕 Dachshund Hub",
				Text = "ESP Disabled",
				Duration = 3
			})
		end
	end,
})

-- Update when players join or leave
Players.PlayerAdded:Connect(function(player)
	if ESP_Enabled then
		player.CharacterAdded:Connect(function()
			task.wait(1)
			createESP(player)
		end)
	end
end)
Players.PlayerRemoving:Connect(function(player)
	removeESP(player)
end)

-----------------------------------------------------
-- // COLOR CUSTOMIZATION
-----------------------------------------------------
local ColorSection = ESPTab:CreateSection("ESP Color Customization")

-- Outline color picker
ESPTab:CreateColorPicker({
	Name = "Outline Color",
	Color = ESPColor_Outline,
	Flag = "espoutlinecolor",
	Callback = function(Value)
		ESPColor_Outline = Value
		for _, hl in pairs(ESP_Highlights) do
			if hl and hl.Parent then
				hl.OutlineColor = Value
			end
		end
	end,
})

-- Name tag color picker
ESPTab:CreateColorPicker({
	Name = "Name Tag Color",
	Color = ESPColor_Text,
	Flag = "esptextcolor",
	Callback = function(Value)
		ESPColor_Text = Value
		for _, player in pairs(Players:GetPlayers()) do
			if player.Character and player.Character:FindFirstChild("NameTag") then
				player.Character.NameTag.TextLabel.TextColor3 = Value
			end
		end
	end,
})

-----------------------------------------------------
-- // FUN TAB (Smooth Version)
-----------------------------------------------------
local FunTab = Window:CreateTab("🎉 Fun", nil)
local FunSection = FunTab:CreateSection("Playful Features")

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local rainbowRunning = false

-- 🌈 Smooth Rainbow Character Effect
FunTab:CreateToggle({
   Name = "Rainbow Character",
   CurrentValue = false,
   Flag = "rainbowchar",
   Callback = function(Value)
      rainbowRunning = Value
      local player = LocalPlayer
      task.spawn(function()
         while rainbowRunning do
            if player.Character then
               local hue = tick() % 5 / 5
               local color = Color3.fromHSV(hue, 1, 1)
               for _, part in pairs(player.Character:GetDescendants()) do
                  if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                     TweenService:Create(part, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = color}):Play()
                  end
               end
            end
            task.wait(0.05)
         end
      end)
   end,
})

-- 🌀 Smooth Spin Player Animation
FunTab:CreateButton({
   Name = "Spin Character",
   Callback = function()
      local char = LocalPlayer.Character
      if not char or not char:FindFirstChild("HumanoidRootPart") then return end
      local hrp = char.HumanoidRootPart
      local spinSpeed = 720 -- degrees total
      local duration = 2
      local startCFrame = hrp.CFrame
      local goalCFrame = startCFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)

      TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {CFrame = goalCFrame}):Play()
   end,
})

-- 📏 Character Size Slider (no notifications)
FunTab:CreateSlider({
   Name = "Character Size",
   Range = {0.5, 3},
   Increment = 0.1,
   Suffix = "x",
   CurrentValue = 1,
   Flag = "charsize",
   Callback = function(Value)
      local char = LocalPlayer.Character
      if char then
         for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") then
               TweenService:Create(part, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                  Size = Vector3.new(2, 2, 1) * Value
               }):Play()
            end
         end
      end
   end,
})

-- 🕹️ Fake Admin Command Console (smooth fade)
FunTab:CreateButton({
   Name = "Fake Admin Command Console",
   Callback = function()
      local cmd = Instance.new("ScreenGui")
      cmd.Parent = game.CoreGui
      cmd.IgnoreGuiInset = true

      local bg = Instance.new("Frame", cmd)
      bg.Size = UDim2.new(0, 400, 0, 200)
      bg.Position = UDim2.new(0.5, -200, 0.5, -100)
      bg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
      bg.BorderSizePixel = 0
      bg.Active = true
      bg.Draggable = true
      bg.BackgroundTransparency = 1

      -- Smooth fade-in
      TweenService:Create(bg, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()

      local title = Instance.new("TextLabel", bg)
      title.Size = UDim2.new(1, 0, 0, 30)
      title.Text = "🐕 Dachshund Admin Console"
      title.TextColor3 = Color3.new(1, 1, 1)
      title.BackgroundTransparency = 1
      title.Font = Enum.Font.GothamBold
      title.TextSize = 16

      local textBox = Instance.new("TextBox", bg)
      textBox.Size = UDim2.new(1, -10, 0, 30)
      textBox.Position = UDim2.new(0, 5, 0, 40)
      textBox.PlaceholderText = "Enter fake admin command..."
      textBox.Text = ""
      textBox.TextColor3 = Color3.new(1, 1, 1)
      textBox.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
      textBox.BorderSizePixel = 0
      textBox.Font = Enum.Font.Code
      textBox.TextSize = 14

      -- Pressing Enter closes smoothly
      textBox.FocusLost:Connect(function()
         TweenService:Create(bg, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}):Play()
         task.wait(0.3)
         cmd:Destroy()
      end)
   end,
})

-----------------------------------------------------
-- // 🎨 THEMES TAB (Fixed: Safe Callbacks + GUI Transparency)
-----------------------------------------------------
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local ThemesTab = Window:CreateTab("🎨 Themes", nil)
local ThemeSection = ThemesTab:CreateSection("Customization")

-----------------------------------------------------
-- ✅ THEME CHANGER (Safe Callback)
-----------------------------------------------------
ThemesTab:CreateDropdown({
	Name = "Select Theme",
	Options = {"DarkBlue", "Crimson", "Aqua", "Amethyst", "Emerald", "Gold"},
	CurrentOption = "Amethyst",
	Flag = "themechoice",
	Callback = function(Value)
		-- Make sure we actually got a string
		if typeof(Value) == "table" then
			Value = Value[1]
		end
		if typeof(Value) == "string" then
			pcall(function()
				Rayfield:ChangeTheme(Value)
				task.wait(0.2)
				game.StarterGui:SetCore("SendNotification", {
					Title = "🐕 Dachshund Hub",
					Text = "Theme changed to " .. Value,
					Duration = 3
				})
			end)
		end
	end,
})

-----------------------------------------------------
-- 🌫 UI BLUR TOGGLE (Fixed)
-----------------------------------------------------
local blur = Lighting:FindFirstChild("DachshundBlur") or Instance.new("BlurEffect")
blur.Name = "DachshundBlur"
blur.Size = 10
blur.Enabled = false
blur.Parent = Lighting

ThemesTab:CreateToggle({
	Name = "Enable UI Blur",
	CurrentValue = false,
	Flag = "uiblur",
	Callback = function(Value)
		if typeof(Value) ~= "boolean" then return end
		pcall(function()
			blur.Enabled = Value
			game.StarterGui:SetCore("SendNotification", {
				Title = "🐕 Dachshund Hub",
				Text = Value and "UI Blur Enabled" or "UI Blur Disabled",
				Duration = 3
			})
		end)
	end,
})

-----------------------------------------------------
-- 🪟 GUI TRANSPARENCY SLIDER (Fixed: Only Affects Dachshund Hub UI)
-----------------------------------------------------
local TweenService = game:GetService("TweenService")

ThemesTab:CreateSlider({
	Name = "GUI Transparency",
	Range = {0, 1},
	Increment = 0.05,
	Suffix = "",
	CurrentValue = 0,
	Flag = "guitransparency",
	Callback = function(Value)
		if typeof(Value) ~= "number" then return end
		pcall(function()
			-- Find only the Rayfield UI (usually named "Rayfield" or similar)
			for _, ui in pairs(game.CoreGui:GetChildren()) do
				if ui.Name:lower():find("rayfield") or ui.Name:lower():find("dachshund") then
					for _, gui in pairs(ui:GetDescendants()) do
						if gui:IsA("Frame") or gui:IsA("TextLabel") or gui:IsA("TextButton") or gui:IsA("TextBox") then
							TweenService:Create(gui, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
								BackgroundTransparency = Value
							}):Play()

							if gui:IsA("TextLabel") or gui:IsA("TextButton") or gui:IsA("TextBox") then
								TweenService:Create(gui, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
									TextTransparency = Value
								}):Play()
							end
						end
					end
				end
			end
		end)
	end,
})

-----------------------------------------------------
-- // UTILITIES TAB (Integrated) — Save/Load/FOV/FPS Overlay
-----------------------------------------------------
do
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    -- Defaults
    local DEFAULT_FOV = 70
    local OVERLAY_ENABLED = false
    local overlayGui, overlayFrame, overlayText, overlayGradient, overlayShadow
    local overlayTweenIn, overlayTweenOut
    local fps_history = {}
    local lastTick = tick()

    -- Create Utilities tab using existing Window
    local UtilitiesTab = Window:CreateTab("🧰 Utilities", nil)
    local UtilitiesSection = UtilitiesTab:CreateSection("Tools & Performance")

    -- Save / Load / Reset Buttons
    UtilitiesTab:CreateButton({
        Name = "Save Settings",
        Callback = function()
            pcall(function() Rayfield:SaveConfiguration() end)
            game.StarterGui:SetCore("SendNotification", {Title="🐕 Dachshund Hub", Text="Settings saved.", Duration=2})
        end,
    })

    UtilitiesTab:CreateButton({
        Name = "Load Settings",
        Callback = function()
            pcall(function() Rayfield:LoadConfiguration() end)
            game.StarterGui:SetCore("SendNotification", {Title="🐕 Dachshund Hub", Text="Settings loaded.", Duration=2})
        end,
    })

    UtilitiesTab:CreateButton({
        Name = "Reset to Default Settings",
        Callback = function()
            -- Reset sensible defaults
            pcall(function()
                -- set FOV default
                workspace.CurrentCamera.FieldOfView = DEFAULT_FOV
                -- if you have a Rayfield flag for FOV, try to set it too
                pcall(function() Rayfield:SaveConfiguration() end)
            end)
            game.StarterGui:SetCore("SendNotification", {Title="🐕 Dachshund Hub", Text="Defaults applied.", Duration=2})
        end,
    })

    -- FOV Slider
    UtilitiesTab:CreateSlider({
        Name = "Camera FOV",
        Range = {40, 120},
        Increment = 1,
        Suffix = "°",
        CurrentValue = DEFAULT_FOV,
        Flag = "camera_fov",
        Callback = function(Value)
            if typeof(Value) == "number" then
                pcall(function() workspace.CurrentCamera.FieldOfView = Value end)
            end
        end,
    })

    ------------- Overlay creation function (locked top-right) -------------
    local function createOverlay()
        if overlayGui and overlayGui.Parent then return end

        overlayGui = Instance.new("ScreenGui")
        overlayGui.Name = "Dachshund_Utilities_Overlay"
        overlayGui.ResetOnSpawn = false
        overlayGui.Parent = game:GetService("CoreGui")

        overlayFrame = Instance.new("Frame")
        overlayFrame.AnchorPoint = Vector2.new(1, 0)
        overlayFrame.Position = UDim2.new(1, -18, 0, 18) -- top-right with padding
        overlayFrame.Size = UDim2.new(0, 170, 0, 40)
        overlayFrame.BackgroundTransparency = 0.25
        overlayFrame.BackgroundColor3 = Color3.fromRGB(45, 22, 70) -- amethyst-ish base
        overlayFrame.BorderSizePixel = 0
        overlayFrame.Parent = overlayGui
        overlayFrame.ZIndex = 10
        overlayFrame.ClipsDescendants = true
        overlayFrame.Name = "DachshundOverlayFrame"
        local corner = Instance.new("UICorner", overlayFrame)
        corner.CornerRadius = UDim.new(0, 10)

        -- Drop shadow (using a low-alpha Frame behind)
        overlayShadow = Instance.new("Frame")
        overlayShadow.Size = overlayFrame.Size + UDim2.new(0, 6, 0, 6)
        overlayShadow.Position = overlayFrame.Position + UDim2.new(0, 3, 0, 3)
        overlayShadow.AnchorPoint = overlayFrame.AnchorPoint
        overlayShadow.BackgroundTransparency = 0.5
        overlayShadow.BackgroundColor3 = Color3.fromRGB(10,10,15)
        overlayShadow.BorderSizePixel = 0
        overlayShadow.ZIndex = 9
        overlayShadow.Parent = overlayGui
        local shadowCorner = Instance.new("UICorner", overlayShadow)
        shadowCorner.CornerRadius = UDim.new(0, 12)

        -- Gradient background (animated)
        overlayGradient = Instance.new("UIGradient", overlayFrame)
        overlayGradient.Rotation = 0
        overlayGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(142, 68, 173)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(98, 0, 255))
        })

        -- Text
        overlayText = Instance.new("TextLabel", overlayFrame)
        overlayText.Size = UDim2.new(1, -12, 1, 0)
        overlayText.Position = UDim2.new(0, 8, 0, 0)
        overlayText.BackgroundTransparency = 1
        overlayText.Text = "FPS: -- | Ping: --ms"
        overlayText.TextColor3 = Color3.fromRGB(255,255,255)
        overlayText.Font = Enum.Font.GothamBold
        overlayText.TextSize = 14
        overlayText.TextXAlignment = Enum.TextXAlignment.Right
        overlayText.ZIndex = 11

        -- Fade tweens
        overlayTweenIn = TweenService:Create(overlayFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0.15})
        overlayTweenOut = TweenService:Create(overlayFrame, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})

        -- initial hidden
        overlayFrame.BackgroundTransparency = 1
        overlayShadow.BackgroundTransparency = 1

        -- shadow fade tweens
        local shadowIn = TweenService:Create(overlayShadow, TweenInfo.new(0.25), {BackgroundTransparency = 0.5})
        local shadowOut = TweenService:Create(overlayShadow, TweenInfo.new(0.25), {BackgroundTransparency = 1})
        overlayGui:SetAttribute("shadowInTween", shadowIn)
        overlayGui:SetAttribute("shadowOutTween", shadowOut)
    end

    local function destroyOverlay()
        if overlayGui then
            pcall(function()
                overlayGui:Destroy()
            end)
            overlayGui = nil
            overlayFrame = nil
            overlayText = nil
            overlayGradient = nil
            overlayShadow = nil
        end
    end

    -- animate gradient colors slowly (call while overlay visible)
    local function startGradientAnim()
        spawn(function()
            while OVERLAY_ENABLED and overlayGradient and overlayGui do
                local t = tick() * 0.02
                local c1 = Color3.fromHSV((t + 0.0) % 1, 0.6, 1)
                local c2 = Color3.fromHSV((t + 0.15) % 1, 0.7, 1)
                local seq = ColorSequence.new({ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(1, c2)})
                pcall(function() overlayGradient.Color = seq end)
                task.wait(0.25)
            end
        end)
    end

    -- overlay updater (FPS & Ping)
    local function startOverlayUpdates()
        spawn(function()
            while OVERLAY_ENABLED and overlayGui do
                -- FPS calculation: average of recent RenderStepped deltas
                local now = tick()
                local dt = now - lastTick
                lastTick = now
                table.insert(fps_history, 1 / math.max(dt, 1/1000))
                if #fps_history > 20 then table.remove(fps_history, 1) end
                local sum = 0
                for _,v in ipairs(fps_history) do sum = sum + v end
                local fps = math.floor(sum / #fps_history + 0.5)

                -- Ping read (safe)
                local ping = "N/A"
                pcall(function()
                    local stats = game:GetService("Stats")
                    local pingItem = stats.Network.ServerStatsItem and stats.Network.ServerStatsItem:FindFirstChild("Data Ping") or stats.Network.ServerStatsItem
                    if pingItem and pingItem.Value then
                        ping = tostring(math.floor(pingItem.Value))
                    else
                        -- fallback to GetValueString if available
                        if stats.Network.ServerStatsItem and stats.Network.ServerStatsItem["Data Ping"] then
                            ping = tostring(math.floor(tonumber(stats.Network.ServerStatsItem["Data Ping"]:GetValueString()) or 0))
                        end
                    end
                end)

                if overlayText and overlayGui then
                    pcall(function()
                        overlayText.Text = string.format("FPS: %d | %sms", fps or 0, ping or "N/A")
                    end)
                end

                task.wait(0.5)
            end
        end)
    end

    -- Toggle in Rayfield to show/hide overlay
    UtilitiesTab:CreateToggle({
        Name = "Show FPS + Ping (Overlay)",
        CurrentValue = false,
        Flag = "show_fps_overlay",
        Callback = function(Value)
            OVERLAY_ENABLED = Value
            if Value then
                createOverlay()
                -- fade in
                pcall(function()
                    overlayTweenIn:Play()
                    overlayGui:GetAttribute("shadowInTween"):Play()
                end)
                startGradientAnim()
                startOverlayUpdates()
            else
                pcall(function()
                    overlayTweenOut:Play()
                    overlayGui:GetAttribute("shadowOutTween"):Play()
                end)
                task.delay(0.25, destroyOverlay)
            end
        end,
    })

    -- Ensure overlay removed on teleport/cleanup
    game:BindToClose(function()
        destroyOverlay()
    end)
end
