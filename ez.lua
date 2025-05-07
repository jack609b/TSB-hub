-- Kiểm tra quyền truy cập script
local lp = game.Players.LocalPlayer
local allowedUser = "phevatvaiz"

if lp.Name ~= allowedUser then
    local success, result = pcall(function()
        return lp:IsFriendsWith(game.Players:GetUserIdFromNameAsync(allowedUser))
    end)

    if not success or not result then
        lp:Kick("Chỉ có chủ nhân của script này hoặc bạn bè của ngài ấy mới có quyền dùng script này")
        return
    end
end

-- Tải OrionLib
local success, OrionLib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
end)

if not success then
    warn("Không thể tải OrionLib.")
    return
end

-- Khởi tạo
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

local autoHeal = false
local speedEnabled = false
local invisibilityEnabled = false
local alreadyInvisible = false

-- Hàm cập nhật khi reset nhân vật
local function updateCharacter(newChar)
    char = newChar
    hum = char:WaitForChild("Humanoid")
    hrp = char:WaitForChild("HumanoidRootPart")
    alreadyInvisible = false
end

lp.CharacterAdded:Connect(updateCharacter)

-- GUI OrionLib
local Window = OrionLib:MakeWindow({
    Name = "TSB-hub | By: Minh",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "TSBHub"
})

local MainTab = Window:MakeTab({
    Name = "Chức Năng",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MainTab:AddToggle({
    Name = "Tự Hồi Máu",
    Default = false,
    Callback = function(state) autoHeal = state end
})

MainTab:AddToggle({
    Name = "Tăng Tốc Độ",
    Default = false,
    Callback = function(state) speedEnabled = state end
})

MainTab:AddToggle({
    Name = "Tàng Hình",
    Default = false,
    Callback = function(state) invisibilityEnabled = state end
})

-- Vòng lặp chính
game:GetService("RunService").Heartbeat:Connect(function()
    if not char or not hum or not hrp then return end

    -- Tự hồi máu
    if autoHeal and hum.Health < hum.MaxHealth then
        hum.Health = hum.MaxHealth
    end

    -- Tốc độ chạy
    if speedEnabled and hum.WalkSpeed ~= 100 then
        hum.WalkSpeed = 100
    end

    -- Tàng hình hoàn hảo
    if invisibilityEnabled and not alreadyInvisible then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.LocalTransparencyModifier = 1
                v.Transparency = 1
                v.CanCollide = false
            elseif v:IsA("Decal") then
                v.Transparency = 1
            elseif v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
                v.Enabled = false
            end
        end
        -- Ẩn tên
        local head = char:FindFirstChild("Head")
        if head then
            for _, gui in ipairs(head:GetChildren()) do
                if gui:IsA("BillboardGui") then
                    gui.Enabled = false
                end
            end
        end
        alreadyInvisible = true
    elseif not invisibilityEnabled and alreadyInvisible then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.LocalTransparencyModifier = 0
                v.Transparency = 0
                v.CanCollide = true
            elseif v:IsA("Decal") then
                v.Transparency = 0
            elseif v:IsA("BillboardGui") or v:IsA("SurfaceGui") then
                v.Enabled = true
            end
        end
        alreadyInvisible = false
    end
end)

OrionLib:Init()
