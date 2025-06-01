-- NetWin Hub Script
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NetWinHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Ana panel
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 500, 0, 300)
main.Position = UDim2.new(0.5, -250, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Active = true
main.Draggable = true
main.Visible = false
main.Parent = ScreenGui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- Başlık
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 40)
title.Position = UDim2.new(0, 10, 0, 5)
title.Text = "NetWin"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

-- Kapatma butonu
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.Gotham
closeBtn.TextSize = 18
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.Parent = main

-- Küçük panel
local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0, 110, 0, 110)
miniBtn.Position = UDim2.new(0.5, -55, 0.5, -55)
miniBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
miniBtn.Visible = true
miniBtn.AutoButtonColor = false
miniBtn.Text = "NetWin"
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 30
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBtn.TextStrokeTransparency = 0.6
miniBtn.TextWrapped = true
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 20)
miniBtn.Parent = ScreenGui

-- Tween ayarları
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

closeBtn.MouseButton1Click:Connect(function()
	TweenService:Create(main, tweenInfo, {Position = UDim2.new(0.5, -250, 0.5, 500), BackgroundTransparency = 1}):Play()
	TweenService:Create(miniBtn, tweenInfo, {Position = UDim2.new(0.5, -55, 0.5, 500), BackgroundTransparency = 1}):Play()
	task.wait(0.5)
	ScreenGui:Destroy()
end)

miniBtn.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- Mini panel sürükleme
local dragging
local dragInput
local dragStart
local startPos

miniBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = miniBtn.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

miniBtn.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		miniBtn.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- Sol Ekran (sayfa deisme menusu)
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0, 120, 1, -50)
leftPanel.Position = UDim2.new(0, 10, 0, 50)
leftPanel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", leftPanel).CornerRadius = UDim.new(0, 8)
leftPanel.Parent = main

local leftLayout = Instance.new("UIListLayout", leftPanel)
leftLayout.FillDirection = Enum.FillDirection.Vertical
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
leftLayout.Padding = UDim.new(0, 10)

-- Sağ panel (scriptlerin oldugu kisim)
local rightPanel = Instance.new("ScrollingFrame")
rightPanel.Position = UDim2.new(0, 140, 0, 50)
rightPanel.Size = UDim2.new(1, -150, 1, -60)
rightPanel.BackgroundTransparency = 1
rightPanel.BorderSizePixel = 0
rightPanel.ScrollBarThickness = 6
rightPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
rightPanel.ScrollingDirection = Enum.ScrollingDirection.Y
rightPanel.Parent = main

local rightLayout = Instance.new("UIListLayout", rightPanel)
rightLayout.Padding = UDim.new(0, 10)
rightLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Script butonu
local function addScriptBtn(parent, name, url)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.Text = name
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 18
	btn.TextColor3 = Color3.fromRGB(220, 220, 220)
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	btn.Parent = parent

	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end)

	btn.MouseButton1Click:Connect(function()
		pcall(function()
			loadstring(game:HttpGet(url, true))()
		end)
	end)
end

local function clearRightPanel()
	for _, child in pairs(rightPanel:GetChildren()) do
		if not child:IsA("UIListLayout") then
			child:Destroy()
		end
	end
end

-- Sayfalar
local function updateInfoPage()
	clearRightPanel()
	local label = Instance.new("TextLabel")
	label.Text = "Creator:\nDevren and NetWin\n\nScript Info:\nThis is a collection script. None of the scripts inside belong to us."
	label.Size = UDim2.new(1, 0, 0, 150)
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextWrapped = true
	label.TextYAlignment = Enum.TextYAlignment.Top
	label.Font = Enum.Font.GothamBold
	label.TextSize = 16
	label.BackgroundTransparency = 1
	label.Parent = rightPanel
end

local function updateAdminPage()
	clearRightPanel()
	addScriptBtn(rightPanel, "Infinite Yield", "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source")
	addScriptBtn(rightPanel, "Reviz Admin", "https://raw.githubusercontent.com/retpirato/Roblox-Scripts/master/reviz_admin_script%20(1).lua")
end

local function updateBrookhavenPage()
	clearRightPanel()
	addScriptBtn(rightPanel, "Darkoness Gui", "https://raw.githubusercontent.com/TheDarkoneMarcillisePex/Other-Scripts/main/Brook%20Haven%20Gui")
	addScriptBtn(rightPanel, "Gumbell Hub", "https://raw.githubusercontent.com/JaozinScripts/Gumball-Hub/refs/heads/main/GumballHubRetorn2.1.1.1.lua")
	addScriptBtn(rightPanel, "Real Hub", "https://raw.githubusercontent.com/Laelmano24/Rael-Hub/main/main.txt")
	addScriptBtn(rightPanel, "SP Hub", "https://raw.githubusercontent.com/as6cd0/SP_Hub/refs/heads/main/Brookhaven")
end

local function updateFlingThingsPage()
	clearRightPanel()
	addScriptBtn(rightPanel, "Bliz_T", "https://raw.githubusercontent.com/BlizTBr/scripts/main/FTAP.lua")
end

-- Sol panel butonları
local buttons = {}

local function addCategoryBtn(name, onClick)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BorderSizePixel = 0
	btn.ClipsDescendants = true
	btn.TextWrapped = true
	btn.TextScaled = true
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	btn.Parent = leftPanel

	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(85, 85, 85)
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	end)

	btn.MouseButton1Click:Connect(function()
		for _, b in pairs(buttons) do
			b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		end
		btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		onClick()
	end)

	table.insert(buttons, btn)
	return btn
end

local infoBtn = addCategoryBtn("Info", updateInfoPage)
local adminBtn = addCategoryBtn("Admin Scripts", updateAdminPage)
local brookhavenBtn = addCategoryBtn("Brookhaven", updateBrookhavenPage)
local flingBtn = addCategoryBtn("Fling Things and People", updateFlingThingsPage)

-- Başlangıç sayfası
infoBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
updateInfoPage()

-- Insert tuşuyla aç/kapat
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
		ScreenGui.Enabled = not ScreenGui.Enabled
	end
end)
