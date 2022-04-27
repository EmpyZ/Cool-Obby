------------------------------START TIMER--------------------------------

local plrService = game:GetService("Players")
local replicatedSt = game:GetService("ReplicatedStorage")

local parts = workspace:WaitForChild("Stages"):GetDescendants()

local debounce = false

for i , touchedParts in pairs(parts) do
	if touchedParts:IsA("BasePart") and touchedParts.Name == "Start" then
		touchedParts.Touched:Connect(function(hit)
			local plr = plrService:GetPlayerFromCharacter(hit.Parent)
			if plr and plr.Character then
				if plr.Current_Stage.Value == touchedParts.Parent.Name then
					plr.StageVal.Value = touchedParts.Parent.Name
					if debounce == false and plr.Touched.Value == false and plr.Current_Stage.Value == touchedParts.Parent.Name and plr.GameVals.OldCheckpoint.Value == touchedParts.Parent.Name and plr.StageVal.Value == touchedParts.Parent.Name then
						local start = tick()
						debounce = true
						local stringname = string.gsub(touchedParts.Parent.Name, "Stage", "")
						plr.GameVals.StageCounter.Value = tonumber(stringname)
						plr.Times.StartTimer.Value = start
						touchedParts.Transparency = .5
						plr.Touched.Value = true
						replicatedSt.TimerStart:FireClient(plr,touchedParts.Parent)
						wait(.75)
						touchedParts.Transparency = 0
						debounce = false
					end
				else
					plr.Touched.Value = false
					plr.StageVal.Value = ""
					replicatedSt.MSG:FireClient(plr)
				end
			end
		end)
	end
end
