-------------------------------STOP TIMER--------------------------------

local plrService = game:GetService("Players")
local replicatedSt = game:GetService("ReplicatedStorage")
local serverSt = game:GetService("ServerStorage")

local parts = workspace:WaitForChild("Stages"):GetDescendants()
local plrFolder = serverSt:WaitForChild("Players")
local checkpoints = workspace:WaitForChild("Checkpoints")

local MSG = replicatedSt:WaitForChild("MSG")

local debounce = false

local function TimeToMSMS(TIME)
	local m = math.floor(TIME/60)
	local s = math.floor(TIME%60)
	local ms = math.floor(TIME% 1 * 100)
	return string.format("%02i:%02i:%02i",m, s, ms)
end


for i , touchedParts in pairs(parts) do
	if touchedParts:IsA("BasePart") and touchedParts.Name == "Stop" then
		touchedParts.Touched:Connect(function(hit)
			local plr = plrService:GetPlayerFromCharacter(hit.Parent)
			if plr and plr.Character then
				if plr.Current_Stage.Value == touchedParts.Parent.Name then
					if debounce == false and plr.GameVals.OldCheckpoint.Value == touchedParts.Parent.Name and plr.StageVal.Value == touchedParts.Parent.Name then
						debounce = true
						plr.StageVal.Value = ""
						plr.Touched.Value = false
						wait()
						local stop = tick()
						plr.Times.EndTimer.Value = stop
						touchedParts.Color = Color3.fromRGB(255,0,255)
						local plrScore = plr.Times.EndTimer.Value - plr.Times.StartTimer.Value
						local timedscore = math.floor(plrScore * 100)
						print(math.floor(plrScore * 100))
						local ConvertedScore = TimeToMSMS(timedscore/100)
						print(ConvertedScore)
						if plr.GameVals.TimedStats[touchedParts.Parent.Name].Value == 0 then
							plr.GameVals.TimedStats[touchedParts.Parent.Name].Value = timedscore
							plrFolder[plr.UserId].GameVals.TimedStats[touchedParts.Parent.Name].Value = timedscore
							replicatedSt.TimerStop:FireClient(plr,ConvertedScore,touchedParts.Parent)
						elseif plr.GameVals.TimedStats[touchedParts.Parent.Name].Value > 0 and plr.GameVals.TimedStats[touchedParts.Parent.Name].Value > timedscore then
							plr.GameVals.TimedStats[touchedParts.Parent.Name].Value = timedscore
							replicatedSt.TimerStop:FireClient(plr,ConvertedScore,touchedParts.Parent)
						end
						touchedParts.Color = Color3.fromRGB(255,0,0)
						wait(.25)
						local NewCounter = plr.GameVals.StageCounter.Value + 1
						local stringname = string.gsub(touchedParts.Parent.Name, "Stage", "")
						if checkpoints:FindFirstChild("Stage"..tostring(NewCounter)) and plr.Character and plr.Character.Humanoid.Health > 0 then
							plr.Character.HumanoidRootPart.CFrame = checkpoints["Stage"..tostring(NewCounter)].CFrame + Vector3.new(0,3.5,0)
							plr.GameVals.StageCounter.Value = NewCounter
							if plr.GameVals.CompletedLvls.Value == tonumber(stringname) then
								print("Player has already completed this level and previous levels")
							elseif plr.GameVals.CompletedLvls.Value + 1 == tonumber(stringname) then
								print("Player just completed this level")
								plr.GameVals.CompletedLvls.Value = stringname
								plrFolder[plr.UserId].GameVals.CompletedLvls.Value = stringname
							else
								stringname = nil
								NewCounter = nil
							end 
						end
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
