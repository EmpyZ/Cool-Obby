--------------------------------TELEPORT----------------------------------

local replicatedSt = game:GetService("ReplicatedStorage")
local serverSt = game:GetService("ServerStorage")
local plrService = game:GetService("Players")

local teleporters = workspace:WaitForChild("Teleporters")
local checkpoints = workspace:WaitForChild("Checkpoints")

local debounce = false

for i , teles in pairs(teleporters:GetDescendants()) do
	if teles:IsA("BasePart") and teles.Name == "TouchPart" then
		teles.Touched:Connect(function(hit)
			local plr = plrService:GetPlayerFromCharacter(hit.Parent)
			if plr and plr.Character and plr.Character:FindFirstChild("Humanoid").Health > 0 then
				local stringname = teles.Parent.Name
				stringname = string.gsub(stringname,"Stage","")
				stringname = tonumber(stringname)
				if debounce == false then
					debounce = true
					if plr.GameVals.StageCounter.Value == stringname then
						wait(.35)
						plr.GameVals.StageCounter.Value = stringname
						plr.Character.HumanoidRootPart.CFrame = checkpoints:FindFirstChild(teles.Parent.Name).CFrame + Vector3.new(0,3.5,0)
						debounce = false
					elseif typeof(stringname) == "number" and plr.GameVals.CompletedLvls.Value + 1 >= stringname then
						wait(.35)
						plr.GameVals.StageCounter.Value = stringname
						plr.Character.HumanoidRootPart.CFrame = checkpoints:FindFirstChild(teles.Parent.Name).CFrame + Vector3.new(0,3.5,0)
						debounce = false
					else
						stringname = nil
						replicatedSt.LevelMsg:FireClient(plr,"Previous Level(s) Not Complete")
						wait(.35)
						debounce = false
					end
				end
			end
		end)
	end
end
