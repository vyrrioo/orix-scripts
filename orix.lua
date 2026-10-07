-- Orix | Blox Fruits | Magnet Update (v30) | Delta Mobile

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer
local Char, HRP, Hum

local function refreshChar()
    Char = LP.Character
    if not Char then return end
    HRP = Char:FindFirstChild("HumanoidRootPart")
    Hum = Char:FindFirstChild("Humanoid")
end
refreshChar()
LP.CharacterAdded:Connect(function(c)
    Char = c
    HRP = c:WaitForChild("HumanoidRootPart")
    Hum = c:WaitForChild("Humanoid")
end)

local function alive()
    refreshChar()
    return Hum and Hum.Health > 0
end

-- CONFIG
local Cfg = {
    AutoFarmMobs   = true,
    AutoFarmBoss   = true,
    AutoChest      = true,
    FruitSniper    = true,
    MagnetFarm     = true,  -- Magnet Update: pulls items/mobs to you
    AutoDungeon    = false,
    AutoPvPArena   = false,
    AutoEvent      = true,
    ESPEnabled     = true,
    InfiniteJump   = true,
    NoClip         = false,
    FastSail       = true,
    AutoSkill      = true,
    AntiDeath      = true,
    AutoQuest      = true,
    AutoMastery    = true,
}

-- UTILS
local function notify(t, m)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification",
            {Title=t, Text=m, Duration=5})
    end)
end

local function tp(pos)
    if HRP then HRP.CFrame = CFrame.new(pos) end
end

local RS = game:GetService("ReplicatedStorage")
local function fire(name, ...)
    pcall(function()
        local rem = RS:FindFirstChild("Remotes")
            and RS.Remotes:FindFirstChild(name)
        if not rem then return end
        if rem:IsA("RemoteEvent") then rem:FireServer(...) end
        if rem:IsA("RemoteFunction") then rem:InvokeServer(...) end
    end)
end

local function skills()
    local list = {
        "UseSkill_1","UseSkill_2","UseSkill_3",
        "UseSkill_4","UseSkill_5","UseSkill_6",
        "Attack","Action_1"
    }
    for _, n in ipairs(list) do
        fire(n)
        task.wait(0.1)
    end
end

-- MAGNET UPDATE: pull nearby items/mobs toward HRP
local function magnetPull(radius)
    radius = radius or 80
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Anchored then
            local d = (HRP.Position - v.Position).Magnitude
            if d < radius and d > 2 then
                local dir = (HRP.Position - v.Position).Unit
                v.Velocity = dir * 60
            end
        end
    end
end

-- LOCATIONS (v30 / Magnet Update)
local Locs = {
    -- Sea 1
    ["Starter Island"]   = Vector3.new(976,12,1818),
    ["Middle Town"]      = Vector3.new(114,29,1535),
    ["Jungle"]           = Vector3.new(-1630,5,-336),
    ["Desert"]           = Vector3.new(942,7,-610),
    ["Frozen Village"]   = Vector3.new(1164,10,-990),
    ["Marine Fortress"]  = Vector3.new(-2610,4,-1588),
    ["Skylands"]         = Vector3.new(-5072,430,-4905),
    -- Sea 2
    ["Kingdom of Rose"]  = Vector3.new(-1800,4,-4100),
    ["Hot and Cold"]     = Vector3.new(-5113,103,-6174),
    ["Ice Castle"]       = Vector3.new(-6900,397,-5950),
    ["Fountain City"]    = Vector3.new(-4960,5,-5020),
    -- Sea 3
    ["Port Town"]        = Vector3.new(-28,73,-5360),
    ["Floating Turtle"]  = Vector3.new(-15563,113,-4310),
    ["Haunted Castle"]   = Vector3.new(-11810,295,-2015),
    ["Cursed Ship"]      = Vector3.new(-14810,25,-1435),
    ["Sea of Treats"]    = Vector3.new(-15060,5,-1900),
    -- Update 30 (Magnet Update)
    ["Magnet Island"]    = Vector3.new(3200,15,3500),
    ["Dark Rework Zone"] = Vector3.new(-8200,50,-3100),
    ["New PvP Zone"]     = Vector3.new(-3440,5,-2360),
    -- Dungeons
    ["Dungeon S1"]       = Vector3.new(430,29,-1070),
    ["Dungeon S2"]       = Vector3.new(-3800,5,-4200),
    ["Dungeon S3"]       = Vector3.new(-12300,100,-2900),
    -- Event
    ["Event Island"]     = Vector3.new(2000,5,2000),
}

-- ESP
local ESPF = Instance.new("Folder")
ESPF.Name = "Orix_ESP"
ESPF.Parent = game:GetService("CoreGui")

local EC = {
    Player = Color3.fromRGB(255,60,60),
    Mob    = Color3.fromRGB(255,200,0),
    Boss   = Color3.fromRGB(255,0,255),
    Fruit  = Color3.fromRGB(0,255,100),
    Chest  = Color3.fromRGB(0,180,255),
}

local function tag(obj, col, txt)
    local bb = Instance.new("BillboardGui")
    bb.AlwaysOnTop = true
    bb.Size = UDim2.new(0,90,0,34)
    bb.StudsOffset = Vector3.new(0,4,0)
    bb.Adornee = obj
    bb.Parent = ESPF
    local fr = Instance.new("Frame",bb)
    fr.Size = UDim2.new(1,0,1,0)
    fr.BackgroundColor3 = col
    fr.BackgroundTransparency = 0.5
    fr.BorderSizePixel = 0
    Instance.new("UICorner",fr).CornerRadius = UDim.new(0,4)
    local lb = Instance.new("TextLabel",fr)
    lb.Size = UDim2.new(1,0,1,0)
    lb.BackgroundTransparency = 1
    lb.Text = txt
    lb.TextColor3 = Color3.new(1,1,1)
    lb.TextScaled = true
    lb.Font = Enum.Font.GothamBold
end

RunService.RenderStepped:Connect(function()
    for _, v in ipairs(ESPF:GetChildren()) do v:Destroy() end
    if not Cfg.ESPEnabled or not HRP then return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local r = p.Character:FindFirstChild("HumanoidRootPart")
            if r then
                local d = math.floor((HRP.Position-r.Position).Magnitude)
                tag(r, EC.Player, p.Name.."\n"..d.."s")
            end
        end
    end
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:find("Fruit") then
            local h = v:FindFirstChild("Handle") or v.PrimaryPart
            if h then
                local d = math.floor((HRP.Position-h.Position).Magnitude)
                tag(h, EC.Fruit, "Fruit\n"..d.."s")
            end
        end
        if v:IsA("BasePart") and v.Name:lower():find("chest") then
            local d = math.floor((HRP.Position-v.Position).Magnitude)
            tag(v, EC.Chest, "Chest\n"..d.."s")
        end
        if v:IsA("Humanoid") and v.Health > 0 and v.Parent ~= Char then
            local r = v.Parent:FindFirstChild("HumanoidRootPart")
            if r then
                local d = math.floor((HRP.Position-r.Position).Magnitude)
                local boss = v.MaxHealth > 20000
                tag(r, boss and EC.Boss or EC.Mob,
                    (boss and "BOSS " or "")..v.Parent.Name.."\n"..d.."s")
            end
        end
    end
end)

-- INFINITE JUMP
UIS.JumpRequest:Connect(function()
    if Cfg.InfiniteJump and Hum then
        Hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- NOCLIP
RunService.Stepped:Connect(function()
    if Cfg.NoClip and Char then
        for _, p in ipairs(Char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
end)

-- FAST SAIL
RunService.Heartbeat:Connect(function()
    if not Cfg.FastSail then return end
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("VehicleSeat") and v.Occupant == Hum then
            v.MaxSpeed = 120
            v.TurnSpeed = 2
        end
    end
end)

-- MAGNET FARM LOOP
task.spawn(function()
    while true do
        task.wait(0.05)
        if Cfg.MagnetFarm and alive() then
            magnetPull(100)
        end
    end
end)

-- FRUIT SNIPER
task.spawn(function()
    while true do
        task.wait(0.1)
        if not Cfg.FruitSniper or not alive() then continue end
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v.Name:find("Fruit") then
                local h = v:FindFirstChild("Handle") or v.PrimaryPart
                if h then
                    local d = (HRP.Position-h.Position).Magnitude
                    if d < 500 then
                        tp(h.Position + Vector3.new(0,2,0))
                        task.wait(0.05)
                        fire("Eat_Fruit", v)
                    end
                end
            end
        end
    end
end)

-- AUTO CHEST
task.spawn(function()
    while true do
        task.wait(1)
        if not Cfg.AutoChest or not alive() then continue end
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name:lower():find("chest") then
                tp(v.Position + Vector3.new(0,3,0))
                task.wait(0.2)
                fire("Open_Chest", v)
            end
        end
    end
end)

-- AUTO QUEST
task.spawn(function()
    while true do
        task.wait(2)
        if not Cfg.AutoQuest or not alive() then continue end
        fire("StartQuest")
        task.wait(0.5)
        fire("AcceptQuest")
    end
end)

-- NEAREST MOB
local function nearMob()
    local best, bd = nil, math.huge
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Humanoid") and v.Health > 0 and v.Parent ~= Char then
            local r = v.Parent:FindFirstChild("HumanoidRootPart")
            if r then
                local d = (HRP.Position-r.Position).Magnitude
                if d < bd then best,bd = v.Parent,d end
            end
        end
    end
    return best
end

-- AUTO FARM MOBS
task.spawn(function()
    while true do
        task.wait(0.1)
        if not Cfg.AutoFarmMobs or not alive() then continue end
        if Hum.Health < Hum.MaxHealth * 0.2 then task.wait(3) continue end
        local mob = nearMob()
        if mob then
            local r = mob:FindFirstChild("HumanoidRootPart")
            if r then
                tp(r.Position + Vector3.new(0,2,3))
                if Cfg.AutoSkill then skills() end
            end
        end
    end
end)

-- AUTO FARM BOSSES
local Bosses = {
    "Sea Beast","Darkbeard","Order","Greybeard","wysper",
    "Thunder God","Cyborg","Cake Queen","Longma","Rip_indra",
    "Dough King","Cursed Captain","Soul Reaper",
    "Island Empress","Corrupted Anomaly",
    "Magnet Warlord",  -- Update 30 boss
}

task.spawn(function()
    while true do
        task.wait(0.5)
        if not Cfg.AutoFarmBoss or not alive() then continue end
        for _, name in ipairs(Bosses) do
            local b = workspace:FindFirstChild(name, true)
            if b then
                local r = b:FindFirstChild("HumanoidRootPart")
                if r then
                    tp(r.Position + Vector3.new(3,2,3))
                    if Cfg.AutoSkill then skills() end
                    task.wait(0.1)
                end
            end
        end
    end
end)

-- AUTO EVENT
local EventQ = {
    "Valentine_Quest","Heart_Deliver","Corrupted_Anomaly_Quest",
    "Easter_Egg_Hunt","Egg_Collection","Event_Quest",
    "Daily_Quest","Weekly_Quest","Magnet_Event_Quest",
}
task.spawn(function()
    while true do
        task.wait(3)
        if not Cfg.AutoEvent or not alive() then continue end
        for _, q in ipairs(EventQ) do
            fire("StartQuest", q)
            task.wait(0.3)
            fire("CompleteQuest", q)
        end
    end
end)

-- AUTO DUNGEON
task.spawn(function()
    while true do
        task.wait(1)
        if not Cfg.AutoDungeon or not alive() then continue end
        fire("EnterDungeon")
        task.wait(2)
        local mob = nearMob()
        if mob then
            local r = mob:FindFirstChild("HumanoidRootPart")
            if r then tp(r.Position+Vector3.new(2,2,2)) skills() end
        end
    end
end)

-- AUTO PVP
task.spawn(function()
    while true do
        task.wait(0.5)
        if not Cfg.AutoPvPArena or not alive() then continue end
        fire("QueueArena")
        task.wait(2)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local r = p.Character:FindFirstChild("HumanoidRootPart")
                if r and (HRP.Position-r.Position).Magnitude < 600 then
                    tp(r.Position+Vector3.new(3,2,3))
                    skills()
                end
            end
        end
    end
end)

-- GUI
local cg = game:GetService("CoreGui")
if cg:FindFirstChild("Orix_GUI") then
    cg:FindFirstChild("Orix_GUI"):Destroy()
end

local GUI = Instance.new("ScreenGui", cg)
GUI.Name = "Orix_GUI"
GUI.ResetOnSpawn = false

local Win = Instance.new("Frame", GUI)
Win.Name = "Win"
Win.Size = UDim2.new(0,220,0,460)
Win.Position = UDim2.new(0,8,0.5,-230)
Win.BackgroundColor3 = Color3.fromRGB(10,10,18)
Win.BorderSizePixel = 0
Win.Active = true
Win.Draggable = true
Instance.new("UICorner",Win).CornerRadius = UDim.new(0,10)

local bar = Instance.new("Frame",Win)
bar.Size = UDim2.new(1,0,0,3)
bar.BackgroundColor3 = Color3.fromRGB(80,150,255)
bar.BorderSizePixel = 0

local lbl = Instance.new("TextLabel",Win)
lbl.Size = UDim2.new(1,0,0,34)
lbl.Position = UDim2.new(0,0,0,3)
lbl.BackgroundTransparency = 1
lbl.Text = "ORIX  |  Magnet Update v30"
lbl.TextColor3 = Color3.fromRGB(120,190,255)
lbl.Font = Enum.Font.GothamBold
lbl.TextSize = 13

local Scroll = Instance.new("ScrollingFrame",Win)
Scroll.Size = UDim2.new(1,-8,1,-42)
Scroll.Position = UDim2.new(0,4,0,40)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Color3.fromRGB(80,150,255)
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
Scroll.BorderSizePixel = 0

local UIL = Instance.new("UIListLayout",Scroll)
UIL.Padding = UDim.new(0,4)
UIL.SortOrder = Enum.SortOrder.LayoutOrder

local function mkToggle(name, key, order)
    local b = Instance.new("TextButton",Scroll)
    b.Size = UDim2.new(1,-4,0,30)
    b.BorderSizePixel = 0
    b.LayoutOrder = order
    b.Font = Enum.Font.Gotham
    b.TextSize = 12
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,6)
    local function upd()
        b.BackgroundColor3 = Cfg[key]
            and Color3.fromRGB(15,100,50)
            or  Color3.fromRGB(90,18,18)
        b.Text = (Cfg[key] and "[ON] " or "[OFF] ")..name
    end
    upd()
    b.MouseButton1Click:Connect(function()
        Cfg[key] = not Cfg[key]
        upd()
    end)
end

local togs = {
    {"Auto Farm Mobs",   "AutoFarmMobs"},
    {"Auto Farm Bosses", "AutoFarmBoss"},
    {"Auto Chest",       "AutoChest"},
    {"Fruit Sniper",     "FruitSniper"},
    {"Magnet Farm",      "MagnetFarm"},
    {"Auto Quest",       "AutoQuest"},
    {"Auto Dungeon",     "AutoDungeon"},
    {"Auto PvP Arena",   "AutoPvPArena"},
    {"Auto Event",       "AutoEvent"},
    {"ESP",              "ESPEnabled"},
    {"Infinite Jump",    "InfiniteJump"},
    {"NoClip",           "NoClip"},
    {"Fast Sail",        "FastSail"},
    {"Auto Skill",       "AutoSkill"},
}

for i, t in ipairs(togs) do mkToggle(t[1],t[2],i) end

-- section divider
local div = Instance.new("TextLabel",Scroll)
div.Size = UDim2.new(1,-4,0,18)
div.BackgroundTransparency = 1
div.Text = "--- Teleports ---"
div.TextColor3 = Color3.fromRGB(80,150,255)
div.Font = Enum.Font.GothamBold
div.TextSize = 11
div.LayoutOrder = #togs+1

local order = #togs+2
for name, pos in pairs(Locs) do
    local tb = Instance.new("TextButton",Scroll)
    tb.Size = UDim2.new(1,-4,0,26)
    tb.BackgroundColor3 = Color3.fromRGB(20,20,40)
    tb.BorderSizePixel = 0
    tb.Font = Enum.Font.Gotham
    tb.TextSize = 11
    tb.TextColor3 = Color3.fromRGB(170,210,255)
    tb.Text = "TP: "..name
    tb.LayoutOrder = order
    order = order+1
    Instance.new("UICorner",tb).CornerRadius = UDim.new(0,6)
    local p = pos
    tb.MouseButton1Click:Connect(function() tp(p) end)
end

notify("Orix", "Magnet Update v30 loaded!")
