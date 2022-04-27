local Players = game:GetService("Players")
local ServerSt = game:GetService("ServerStorage")
local replicatedSt = game:GetService("ReplicatedStorage")

local checkpoints = game.Workspace:WaitForChild("Checkpoints")
local plrsFolder = ServerSt:WaitForChild("Players")

local touched = false

for i, chckpts in pairs(checkpoints:GetChildren()) do
	if chckpts:IsA("BasePart") then
		chckpts.Touched:Connect(function(hit)
			local player = Players:GetPlayerFromCharacter(hit.Parent) or Players:GetPlayerFromCharacter(hit.Parent.Parent)
			if touched == false then
				touched = true
				if player and player.Character then
					player.GameVals.OldCheckpoint.Value = chckpts.Name
					plrsFolder[player.UserId].GameVals.OldCheckpoint.Value = chckpts.Name
					player.Team = game.Teams:FindFirstChild(chckpts.Name)
					player.Current_Stage.Value = chckpts.Name
				end
				if chckpts.Name == "Stage16" then
					replicatedSt.Win:FireClient(player,"You Win!")
				end
				wait()
				touched = false
			end
			--chckpts:Destroy()
		end)
	end
end
