local tweenService = game:GetService("TweenService")
local lobby = workspace:WaitForChild("Lobby")
local clouds = lobby:WaitForChild("Clouds")

for i , parts in pairs(clouds:GetDescendants()) do
	if parts.Name == "CloudMain" and parts:IsA("BasePart") then
		local FirstTween = tweenService:Create(parts, TweenInfo.new(48), {CFrame =  parts.CFrame * CFrame.new(parts.Value1.Value) * CFrame.Angles(0,math.rad(120),0)})
		local SecondTween = tweenService:Create(parts, TweenInfo.new(48), {CFrame = parts.CFrame * CFrame.new(parts.Value2.Value) * CFrame.Angles(0,math.rad(240),0)})
		local ThirdTween = tweenService:Create(parts, TweenInfo.new(48), {CFrame = parts.CFrame * CFrame.new(parts.Value3.Value) * CFrame.Angles(0,math.rad(360),0)})
		FirstTween:Play()
		FirstTween.Completed:Connect(function()
			SecondTween:Play()
		end)
		SecondTween.Completed:Connect(function()
			ThirdTween:Play()
		end)
		ThirdTween.Completed:Connect(function()
			FirstTween:Play()
		end)
	end
end
