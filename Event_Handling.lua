local DataStoreService = game:GetService("DataStoreService")

local DataStore = DataStoreService:GetDataStore("MyDataStore")

local replicatedSt = game:GetService("ReplicatedStorage")

local serverSt = game:GetService("ServerStorage")
local plrsFolder = serverSt:WaitForChild("Players")
local timedStats = serverSt:WaitForChild("TimedStats")

local P5 = game:GetService("PhysicsService")
P5:CreateCollisionGroup("Players")
P5:CollisionGroupSetCollidable("Players", "Players", false)

local function CharacterAdded(Char)
local player = game.Players:GetPlayerFromCharacter(Char)
	if player.GameVals.OldCheckpoint.Value ~= "NeutralSpawn" then
		print(game.Teams[player.GameVals.OldCheckpoint.Value])
		if game.Workspace.Checkpoints:FindFirstChild(player.GameVals.OldCheckpoint.Value) then
			player.Team = game.Teams[player.GameVals.OldCheckpoint.Value]
			print("Success")
		end
	end
	
	repeat wait(1) until Char.Humanoid
	
	local humanoid = Char:WaitForChild("Humanoid")
	if humanoid ~= nil then
		humanoid.Died:Connect(function()
			if player ~= nil and Char then
				player.StageVal.Value = ""
				player.Touched.Value = false
			end
		end)
	end

	for i,playerParts in pairs(Char:GetChildren()) do
		if playerParts:IsA("BasePart") then
			P5:SetPartCollisionGroup(playerParts, "Players")
			print("Success")
		end
	end
end

local function OnPlayerAdded(player)
local beginChar
	--Connect the event
	local playerUserId = player.UserId

	local userId = Instance.new("Folder")
	userId.Name = playerUserId
	userId.Parent = plrsFolder
	
	local gamevals = Instance.new("Folder")
	gamevals.Name = "GameVals"
	gamevals.Parent = player
	
	local Times = Instance.new("Folder")
	Times.Name = "Times"
	Times.Parent = player
	
	local touched = Instance.new("BoolValue")
	touched.Name = "Touched"
	touched.Value = false
	touched.Parent = player

	local oldCheckpoint = Instance.new("StringValue")
	oldCheckpoint.Name = "OldCheckpoint"
	oldCheckpoint.Value = "NeutralSpawn"
	oldCheckpoint.Parent = gamevals

	local DecidedOnPrompt = Instance.new("BoolValue")
	DecidedOnPrompt.Name = "DecidedOnPrompt"
	DecidedOnPrompt.Value = false
	DecidedOnPrompt.Parent = gamevals
	
	local StartTimer = Instance.new("NumberValue")
	StartTimer.Name = "StartTimer"
	StartTimer.Parent = Times
	StartTimer.Value = 0
	
	local EndTimer = Instance.new("NumberValue")
	EndTimer.Name = "EndTimer"
	EndTimer.Parent = Times
	EndTimer.Value = 0
	
	local StageVal = Instance.new("StringValue")
	StageVal.Name = "StageVal"
	StageVal.Parent = player
	StageVal.Value = ""
	
	local Current_Stage = Instance.new("StringValue")
	Current_Stage.Name = "Current_Stage"
	Current_Stage.Parent = player
	Current_Stage.Value = ""
	
	local StageCounter = Instance.new("IntValue")
	StageCounter.Name = "StageCounter"
	StageCounter.Parent = gamevals
	StageCounter.Value = 1
	
	local CompletedLvls = Instance.new("IntValue")
	CompletedLvls.Name = "CompletedLvls"
	CompletedLvls.Parent = gamevals
	CompletedLvls.Value = 0
	
	local clonedTimes = timedStats:Clone()
	clonedTimes.Parent = gamevals

	local gamevalsCopy = player.GameVals:Clone()
	gamevalsCopy.Parent = plrsFolder:FindFirstChild(playerUserId)
	
	player.Team = game.Teams["NeutralSpawn"] --game.Teams:FindFirstChild(plrsFolder[player.UserId].GameVals.OldCheckpoint.Value)
	print(player.Team)

-------------------reference the players user id for datastore
 
local data

	local success, errormsg = pcall(function()
		 data = DataStore:GetAsync(player.UserId)
	print("got the right player")
	end)

	if data ~= nil then

		if plrsFolder:FindFirstChild(playerUserId).Name == tostring(player.UserId) then
			
			if data.OldCheckpoint then
				plrsFolder[player.UserId].GameVals.OldCheckpoint.Value = data.OldCheckpoint
				oldCheckpoint.Value = data.OldCheckpoint
			end
			
			if data.CompletedLvls then
				plrsFolder[player.UserId].GameVals.CompletedLvls.Value = data.CompletedLvls
				CompletedLvls.Value = data.CompletedLvls
			end
			
			if data.TimedStats then
				print(data.TimedStats)
				for i ,v in pairs(data.TimedStats) do
					if plrsFolder[player.UserId].GameVals.TimedStats:FindFirstChild("Stage"..i) then
						plrsFolder[player.UserId].GameVals.TimedStats["Stage"..i].Value = data.TimedStats[i]
						player.GameVals.TimedStats["Stage"..i].Value = data.TimedStats[i]
						print(data.TimedStats[i])
					end
				end
			end
			
		else

			print(player.Name.." Has no data")

		end
	end
	
	if player then
		player.CharacterAdded:Connect(CharacterAdded)
		local Char = player.Character
		if not Char or not Char.Parent then
			Char = player.CharacterAdded:Wait()
		end
		CharacterAdded(Char)
	end
end -------------------------------------------- ENDING THE PLAYERADDED FUNCTION

--Connect the event
game.Players.PlayerAdded:Connect(OnPlayerAdded)

--Take care of when it already exists
for i,v in pairs(game.Players:GetPlayers()) do
	OnPlayerAdded(v)
end



local function onplayerleave(player)
	local playerUserId = plrsFolder:FindFirstChild(player.UserId)

	if playerUserId.Name == tostring(player.UserId) then

		local data = {} -- userid,oldcheckpoint,stats,etc
		
		data.OldCheckpoint = plrsFolder[player.UserId].GameVals.OldCheckpoint.Value
		data.CompletedLvls = plrsFolder[player.UserId].GameVals.CompletedLvls.Value
		data.TimedStats = {}
		
		for i, v in pairs(plrsFolder[player.UserId].GameVals.TimedStats:GetChildren()) do
			table.insert(data.TimedStats,v.Value)
		end
		
		print(data.CompletedLvls)
		print(data.OldCheckpoint)
		print(data.TimedStats)
		
		local success,errormsg = pcall(function()
			DataStore:SetAsync(player.UserId,data)
			
		end)

		if success then
			print("Successfully Saved")
		else
		warn(errormsg)
		end
	end

end


game.Players.PlayerRemoving:Connect(onplayerleave)


game:BindToClose(function()
	if #game.Players:GetPlayers() <= 1 then return end
		for i, player in pairs(game.Players:GetPlayers()) do
		local data = {} -- userid,oldcheckpoint,stats,etc
		local playerUserId = plrsFolder:FindFirstChild(player.UserId)
		if playerUserId.Name == tostring(player.UserId) then
			
			data.OldCheckpoint = plrsFolder[player.UserId].GameVals.OldCheckpoint.Value
			data.CompletedLvls = plrsFolder[player.UserId].GameVals.CompletedLvls.Value
			data.TimedStats = {}

			for i, v in pairs(plrsFolder[player.UserId].GameVals.TimedStats:GetChildren()) do
				table.insert(data.TimedStats,v.Value)
			end
			
			print(data.CompletedLvls)
			print(data.TimedStats)
			print(data.OldCheckpoint)
			
			print("running the bindtoclose")
			wait(10)
			
		local success,errormsg = pcall(function()
			DataStore:SetAsync(player.UserId,data)
			end)
			
			if success then
				print("Successfully Saved")
			else
				warn(errormsg)
			end
		end
	end
end)
