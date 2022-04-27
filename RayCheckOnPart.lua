local Players = game:GetService("Players")
local RunService = game:GetService('RunService')
local player = game.Players.LocalPlayer
local Character = player.Character
local RootPart = Character:WaitForChild("LowerTorso")

local LastPartCFrame

local Function
local Function2

Function = RunService.Heartbeat:Connect(function()
	
	for i , parts in pairs(workspace.Stages:GetDescendants()) do
		
		if parts:IsA("BasePart") and parts.Name == "HPart" then

			local ray = Ray.new(RootPart.CFrame.p,Vector3.new(0,-50,0))

			local Hit, Position, Normal, Material = workspace:FindPartOnRay(ray,Character)
			
			local magnitude = (RootPart.Position - parts.Position).magnitude
			
			if magnitude < 25 then
				
				parts = Hit
				
					if Hit then
						
						local part = Hit
						if LastPartCFrame == nil then
							LastPartCFrame = part.CFrame -- Connect the Variable
						end
					local partCF = part.CFrame
					
					if magnitude < 8 then
					
						local Rel = partCF * LastPartCFrame:inverse()

						LastPartCFrame = part.CFrame -- Updated here.

						RootPart.CFrame = Rel * RootPart.CFrame -- Set the player's CFrame
							
					end

					else
						LastPartCFrame = nil -- Clear the value when the player gets off.

					end
					
				end
				
			end
		
		end

	Function2 = Character.Humanoid.Died:Connect(function()
		Function:Disconnect()
		Function2:Disconnect() 
	end)

end)
