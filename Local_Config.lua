local runService = game:GetService("RunService")
local replicatedSt = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local SService = game:GetService("SoundService")

local plr = Players.LocalPlayer
local character = plr.Character
local humanoid = character:WaitForChild("Humanoid")

if not character or not character.Parent then
	character = plr.CharacterAdded:Wait()
end

local head = character:WaitForChild("Head")
local stage_Count = 15
local debounce = false
local FirstJoin = false

local camera = game.Workspace.Camera
local cams = workspace:WaitForChild("Cams")

local TextLabel = script.Parent
local MainGUI = TextLabel.Parent
local frame = MainGUI.Frame
local BGFrame = frame.BackgroundFrame
local sideFrame = BGFrame.SidePanelFrame
local ScrollFrame = BGFrame.SF

local teleName = sideFrame:WaitForChild("TeleportName")
local teleBtn = teleName:WaitForChild("TeleBtn")
local wrongStage = MainGUI:WaitForChild("WrongStage")
local NotComplete = MainGUI:WaitForChild("NotComplete")
local menuBtn = MainGUI.MenuBackground.MenuBtn
local playbtn = MainGUI.PlayBtn

local BoolVal = plr.Touched
local stageTele = replicatedSt:WaitForChild("StageTele")
local FirstConn

local function resetCameraSubject()
	if workspace.CurrentCamera and character then
		if humanoid then
			game.Workspace.Camera.CameraType = Enum.CameraType.Custom
			workspace.CurrentCamera.CameraSubject = humanoid
			game.Workspace.CurrentCamera.FieldOfView = 70
			character.Humanoid.WalkSpeed = 16
			character.Humanoid.JumpPower = 50
		end
	end
end

local function ShortestTween(part1,part2,length,howfast)
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CameraSubject = nil
	camera.CFrame = part1.CFrame

	local tween = TweenService:Create(camera, TweenInfo.new(howfast), {CFrame = part2.CFrame})
	tween:Play()

	wait(length)

end

lighting.Blur.Enabled = true
TextLabel.Visible = false
camera.CameraType = Enum.CameraType.Scriptable
camera.CameraSubject = nil
camera.CFrame = cams.FirstCam.CFrame
humanoid.WalkSpeed = 0
humanoid.JumpPower = 0

wait(3)

playbtn.Visible = true
for i = 1,0,-.05 do
	wait(.05)
	playbtn.BackgroundTransparency = i
	playbtn.TextTransparency = i
	playbtn.TextStrokeTransparency = i
end

FirstConn = playbtn.MouseButton1Click:Connect(function()
	if FirstJoin == false then
		FirstJoin = true
		for i = 0,1.1,.05 do
			wait(.05)
			playbtn.BackgroundTransparency = i
			playbtn.TextTransparency = i
			playbtn.TextStrokeTransparency = i
		end
		playbtn.Visible = false
		for i = 12,0,-.5 do
			wait(.05)
			lighting.Blur.Size = i
		end
		TextLabel.Visible = true
		menuBtn.Parent.Visible = true
		for i = 1,0,-.05 do
			wait(.05)
			menuBtn.Parent.BackgroundTransparency = i
			menuBtn.BackgroundTransparency = i
			menuBtn.TextTransparency = i
			TextLabel.BackgroundTransparency = i
			TextLabel.Stage.BackgroundTransparency = i
			TextLabel.Timer.BackgroundTransparency = i
			TextLabel.Timer.TextTransparency = i
		end
		lighting.Blur.Enabled = false
		ShortestTween(cams.FirstCam,head,2,1.5)
		resetCameraSubject()
	end
	FirstConn:Disconnect()
end)

local function TimeToMSMS(TIME)
	local m = math.floor(TIME/60)
	local s = math.floor(TIME%60)
	local ms = math.floor(TIME% 1 * 100)
	return string.format("%02i:%02i:%02i", m, s, ms)
end

for i = 1,stage_Count,1 do
	local stageClone = script.Parent.Stage:Clone()
	stageClone.Parent = ScrollFrame
	stageClone.Visible = true
	stageClone.Name = "Stage"..tostring(i)
	stageClone.Num.Text = "Stage"..tostring(i)
	stageClone.Num.Name = tostring(i)
end

local function clickedStage(btn)
	teleBtn.StageName.Value = btn.Name
	if plr.GameVals.TimedStats:FindFirstChild(tostring("Stage"..teleBtn.StageName.Value)).Value ~= 0 then
		local TimeToConvert = plr.GameVals.TimedStats[tostring("Stage"..teleBtn.StageName.Value)].Value
		sideFrame.TimerName.name.Text = TimeToMSMS(TimeToConvert/100)
		sideFrame.Description.Info.Text = "Would You Like To Teleport To Stage"..teleBtn.StageName.Value.."?"
		sideFrame.CompletionName.name.Text = "Complete"
	else
		sideFrame.Description.Info.Text = "That Stage Isn't Complete Yet"
		sideFrame.CompletionName.name.Text = "Not Complete"
		sideFrame.TimerName.name.Text = "00:00:00"
	end
	
end

for i, btns in ipairs(ScrollFrame:GetDescendants()) do
	if btns:IsA("TextButton") then
		btns.MouseButton1Click:Connect(function()clickedStage(btns)end)
	end
end

for i , FLbtns in pairs(frame.Floors:GetDescendants()) do
	if FLbtns:IsA("TextButton") then
		FLbtns.MouseButton1Click:Connect(function()
			replicatedSt.FloorTele:FireServer(FLbtns.Parent.Name)
		end)
	end
end

local function openMenu()
	frame.Visible = not frame.Visible
end

local function onClickedTele()
	print(plr)
	if plr and character then
		if plr.GameVals.TimedStats and teleBtn.StageName.Value ~= "" and debounce == false then
			debounce = true
			wait(.5)
			stageTele:FireServer(teleBtn.StageName.Value)
			debounce = false
		end
	end
end

menuBtn.MouseButton1Click:Connect(openMenu)
teleBtn.MouseButton1Click:Connect(onClickedTele)

replicatedSt.TimerStart.OnClientEvent:Connect(function(stage)
	local current_time = tick()
	runService:BindToRenderStep("Start",Enum.RenderPriority.Last.Value - 1,function()
		if BoolVal.Value == false then
			runService:UnbindFromRenderStep("Start")
		end
	    TextLabel.Timer.Text = TimeToMSMS(tick() - current_time)
	end)
end)

replicatedSt.TimerStop.OnClientEvent:Connect(function(score,Stage)
	TextLabel.Timer.Text = score
	wait(3)
	TextLabel.Timer.Text = "00:00:00"
	print(score)
end)

replicatedSt.LevelMsg.OnClientEvent:Connect(function(MSG)
	if debounce == false then
		debounce = true
		local clonedComplete = NotComplete:Clone()
		clonedComplete.Parent = MainGUI
		clonedComplete.MainText.Text = MSG
		clonedComplete:TweenPosition(UDim2.new(0.367, 0, .35, 0))
		wait(2.5)
		clonedComplete:TweenPosition(UDim2.new(0.367, 0, -.5, 0))
		clonedComplete.MainText.Text = ""
		wait(1)
		clonedComplete:Destroy()
		debounce = false
	end
end)

replicatedSt.Win.OnClientEvent:Connect(function(MSG)
	if debounce == false then
		debounce = true
		local clonedComplete = NotComplete:Clone()
		clonedComplete.Parent = MainGUI
		clonedComplete.MainText.Text = MSG
		clonedComplete:TweenPosition(UDim2.new(0.367, 0, .35, 0))
		SService.Yay:Play()
		wait(2.5)
		clonedComplete:TweenPosition(UDim2.new(0.367, 0, -.5, 0))
		clonedComplete.MainText.Text = ""
		wait(1)
		clonedComplete:Destroy()
		debounce = false
	end
end)

replicatedSt.MSG.OnClientEvent:Connect(function()
	if debounce == false then
		debounce = true
		wrongStage.Visible = true
		sideFrame.TimerName.name.Text = "00:00:00"
		TextLabel.Timer.Text = "00:00:00"
		wait(3.5)
		TextLabel.Timer.Text = "00:00:00"
		wrongStage.Visible = false
		debounce = false
	end
end)
