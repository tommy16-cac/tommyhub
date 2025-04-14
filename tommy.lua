-- Tải thư viện UI
loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local OrionLib = OrionLib
local Window = OrionLib:MakeWindow({Name = "Tommy Hub", HidePremium = false, IntroEnabled = false, SaveConfig = true, ConfigFolder = "TommyConfig"})

local autofarm = false

-- Tạo tab và toggle
local MainTab = Window:MakeTab({Name = "Auto Farm", Icon = "rbxassetid://4483345998", PremiumOnly = false})

MainTab:AddToggle({
	Name = "Bật Auto Farm",
	Default = false,
	Save = true,
	Callback = function(Value)
		autofarm = Value
	end    
})

-- Chức năng farm
spawn(function()
	while task.wait(1) do
		if autofarm then
			-- Tìm quái theo level
			local player = game.Players.LocalPlayer
			local level = player.Data.Level.Value
			local targetMob = nil
			local targetPos = nil

			if level <= 10 then
				targetMob = "Bandit"
				targetPos = Vector3.new(1144, 17, 1630)
			elseif level <= 50 then
				targetMob = "Gorilla"
				targetPos = Vector3.new(-1125, 40, 480)
			end

			if targetMob and targetPos then
				-- Tìm quái gần nhất
				for _, mob in pairs(workspace.Enemies:GetChildren()) do
					if mob.Name == targetMob and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
						repeat
							if not autofarm then break end
							pcall(function()
								player.Character:WaitForChild("HumanoidRootPart").CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
								game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game)
							end)
							task.wait()
						until mob.Humanoid.Health <= 0 or not autofarm
					end
				end
			end
		end
	end
end)

OrionLib:Init()
