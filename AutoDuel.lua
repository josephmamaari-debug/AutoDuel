-- AUTO DUEL v1 | Mobile player monitor
-- Local monitoring only. Does not move players or control the game.

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

local old = CoreGui:FindFirstChild("AutoDuel")
if old then old:Destroy() end

local GUI = Instance.new("ScreenGui")
GUI.Name = "AutoDuel"
GUI.ResetOnSpawn = false
GUI.Parent = CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 290, 0, 350)
Main.Position = UDim2.new(0.5, -145, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Parent = GUI
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 42)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Title.Text = "AUTO DUEL | حرب القنابل"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = Main
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 28)
Status.Position = UDim2.new(0, 10, 0, 48)
Status.BackgroundTransparency = 1
Status.Text = "الحالة: جاهز"
Status.TextColor3 = Color3.fromRGB(100, 220, 140)
Status.TextSize = 13
Status.Parent = Main

local Refresh = Instance.new("TextButton")
Refresh.Size = UDim2.new(1, -20, 0, 35)
Refresh.Position = UDim2.new(0, 10, 0, 80)
Refresh.BackgroundColor3 = Color3.fromRGB(45, 100, 180)
Refresh.Text = "تحديث اللاعبين"
Refresh.TextColor3 = Color3.new(1, 1, 1)
Refresh.TextSize = 14
Refresh.Parent = Main
Instance.new("UICorner", Refresh).CornerRadius = UDim.new(0, 8)

local List = Instance.new("ScrollingFrame")
List.Size = UDim2.new(1, -20, 0, 210)
List.Position = UDim2.new(0, 10, 0, 125)
List.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
List.BorderSizePixel = 0
List.ScrollBarThickness = 4
List.CanvasSize = UDim2.new()
List.Parent = Main
Instance.new("UICorner", List).CornerRadius = UDim.new(0, 8)

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.Parent = List

local function isGreenTeam(player)
    local team = player.Team
    if not team then return false end
    local color = team.TeamColor.Color
    return color.G > 0.45 and color.G > color.R * 1.3
end

local function update()
    for _, child in ipairs(List:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    local count = 0
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            count += 1
            local green = isGreenTeam(player)
            local character = player.Character
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            local root = character and character:FindFirstChild("HumanoidRootPart")

            local distance = "?"
            local myCharacter = LocalPlayer.Character
            local myRoot = myCharacter and myCharacter:FindFirstChild("HumanoidRootPart")
            if root and myRoot then
                distance = tostring(math.floor((root.Position - myRoot.Position).Magnitude)) .. "m"
            end

            local row = Instance.new("TextButton")
            row.Size = UDim2.new(1, -8, 0, 38)
            row.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
            row.TextColor3 = green and Color3.fromRGB(100, 255, 130)
                or Color3.fromRGB(255, 110, 110)
            row.TextSize = 12
            row.TextWrapped = true
            row.Text = (green and "[فريقك] " or "[خصم محتمل] ")
                .. player.DisplayName .. " | " .. distance
                .. " | HP: " .. (humanoid and tostring(math.floor(humanoid.Health)) or "?")
            row.Parent = List
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)
        end
    end

    List.CanvasSize = UDim2.new(0, 0, 0, count * 43)
    Status.Text = "اللاعبون الآخرون: " .. count
end

Refresh.Activated:Connect(update)

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(1, -20, 0, 28)
Close.Position = UDim2.new(0, 10, 0, 310)
Close.BackgroundColor3 = Color3.fromRGB(150, 45, 45)
Close.Text = "إغلاق"
Close.TextColor3 = Color3.new(1, 1, 1)
Close.Parent = Main
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)
Close.Activated:Connect(function() GUI:Destroy() end)

update()
