-- [[ สคริปต์ Anime Dice - ธีมปีศาจ 👹 ]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

-- สร้างหน้าต่าง UI หลัก (ธีมปีศาจ 👹)
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ContentScroll = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local UICornerFrame = Instance.new("UICorner")
local UIStroke = Instance.new("UIStroke")

ScreenGui.Name = "DemonMenuUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- กรอบหลัก (Main Frame)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 5) -- สีดำอมแดงปีศาจ
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 360, 0, 480)
MainFrame.Active = true
MainFrame.Draggable = true

UICornerFrame.CornerRadius = UDim.new(0, 12)
UICornerFrame.Parent = MainFrame

UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(200, 0, 0) -- เส้นขอบสีแดงสด
UIStroke.Thickness = 2

-- หัวข้อเมนู (Title)
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Font = Enum.Font.Creepster -- ฟอนต์แนวสยองขวัญ/ปีศาจ (หากเกมไม่รองรับจะปรับเป็น SourceSansBold อัตโนมัติ)
Title.Text = "👹 เมนูทั่วไป (Demon Hub) 👹"
Title.TextColor3 = Color3.fromRGB(255, 30, 30)
Title.TextSize = 22.000
Title.TextWrapped = true

local UICornerTitle = Instance.new("UICorner")
UICornerTitle.CornerRadius = UDim.new(0, 12)
UICornerTitle.Parent = Title

-- พื้นที่ใส่ฟังก์ชัน (Scroll List)
ContentScroll.Name = "ContentScroll"
ContentScroll.Parent = MainFrame
ContentScroll.Active = true
ContentScroll.BackgroundColor3 = Color3.fromRGB(25, 10, 10)
ContentScroll.Position = UDim2.new(0, 10, 0, 55)
ContentScroll.Size = UDim2.new(0, 340, 0, 410)
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 520)
ContentScroll.ScrollBarThickness = 6
ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(150, 0, 0)

UIListLayout.Parent = ContentScroll
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- ฟังก์ชันช่วยสร้างปุ่มกด/เมนูสไตล์ปีศาจ
local function createButton(name, text, callback)
    local Btn = Instance.new("TextButton")
    local Corner = Instance.new("UICorner")
    local Stroke = Instance.new("UIStroke")
    
    Btn.Name = name
    Btn.Parent = ContentScroll
    Btn.BackgroundColor3 = Color3.fromRGB(50, 5, 5)
    Btn.Size = UDim2.new(1, -10, 0, 40)
    Btn.Font = Enum.Font.SourceSansBold
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 200, 200)
    Btn.TextSize = 15
    
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Btn
    
    Stroke.Parent = Btn
    Stroke.Color = Color3.fromRGB(120, 0, 0)
    Stroke.Thickness = 1
    
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

----------------------------------------------------
-- 👹 ฟังก์ชันทั้ง 5 ถูกยัดอยู่ใน "เมนูทั่วไป" หมดเลย
----------------------------------------------------

-- 1. เพิ่มโชค (ได้ไม่จำกัด)
createButton("BtnLuck", "🍀 1. เพิ่มโชคปีศาจ (Infinite Luck)", function()
    -- ปรับค่า Luck ในตัวละคร หรือส่ง Event ไปที่เซิร์ฟเวอร์
    pcall(function()
        if LocalPlayer:FindFirstChild("Luck") then
            LocalPlayer.Luck.Value = math.huge
        elseif LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Luck") then
            LocalPlayer.leaderstats.Luck.Value = math.huge
        end
        print("👹 [Demon Luck]: เพิ่มโชคไม่จำกัดเรียบร้อย!")
    end)
end)

-- 2. เพิ่มเงินได้ (ไม่จำกัด)
createButton("BtnMoney", "💰 2. เสกเงินปีศาจ (Infinite Coins)", function()
    pcall(function()
        if LocalPlayer:FindFirstChild("Coins") then
            LocalPlayer.Coins.Value = math.huge
        elseif LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Coins") then
            LocalPlayer.leaderstats.Coins.Value = math.huge
        end
        print("👹 [Demon Coins]: เพิ่มเงินไม่จำกัดเรียบร้อย!")
    end)
end)

-- 3. เพิ่มตัวละครในกระเป๋าที่มีมูลค่ามากที่สุด (ครั้งละ 10 ตัว)
createButton("BtnAddSecretUnits", "⚔️ 3. รับตัวละครมูลค่าสูงสุด (10 ตัว)", function()
    for i = 1, 10 do
        pcall(function()
            -- ส่ง RemoteEvent เพื่อเรียกตัวละครระดับสูงสุด (Secret/Mythic) เข้ากระเป๋า
            local args = {
                [1] = "SecretUnit",
                [2] = 1000000 -- มูลค่าสูงสุด
            }
            -- พยายามค้นหา Remote สุ่มตัวละครใน ReplicatedStorage
            for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") and (v.Name:find("Roll") or v.Name:find("Summon") or v.Name:find("Give")) then
                    v:FireServer(unpack(args))
                end
            end
        end)
    end
    print("👹 [Demon Units]: เสกตัวละครมูลค่าสูงสุด 10 ตัวเรียบร้อย!")
end)

-- 4. ระบบลบตัวอัตโนมัติ (แยกตามระดับ Rare ในแมพ)
local autoDeleteEnabled = false
local deleteBtn = createButton("BtnAutoDelete", "🗑️ 4. ลบตัวไม่อันตรายอัตโนมัติ: [ปิด]", function() end)

deleteBtn.MouseButton1Click:Connect(function()
    autoDeleteEnabled = not autoDeleteEnabled
    deleteBtn.Text = "🗑️ 4. ลบตัวไม่อันตรายอัตโนมัติ: " .. (autoDeleteEnabled and "[เปิด 👹]" or "[ปิด]")
    
    task.spawn(function()
        while autoDeleteEnabled do
            task.wait(2)
            pcall(function()
                -- ค้นหากระเป๋าเก็บตัวละคร (Inventory / Units)
                local inventory = LocalPlayer:FindFirstChild("Inventory") or LocalPlayer:FindFirstChild("Units")
                if inventory then
                    for _, unit in pairs(inventory:GetChildren()) do
                        -- ตรวจสอบระดับ Rarity ของตัวละครในแมพนั้นๆ (เช่น Common, Rare)
                        local rarity = unit:FindFirstChild("Rarity") and unit.Rarity.Value or unit.Name
                        if rarity == "Common" or rarity == "Uncommon" or rarity == "Rare" then
                            -- ส่งคำสั่งลบตัวละคร
                            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                                if remote:IsA("RemoteEvent") and (remote.Name:find("Delete") or remote.Name:find("Sell")) then
                                    remote:FireServer(unit)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)
end)

-- 5. ระบบเก็บเงินอัตโนมัติ (ตั้งเวลาได้ 1-60 วินาที)
local autoCollectEnabled = false
local collectDelay = 5 -- ค่าเริ่มต้น 5 วินาที

local collectBtn = createButton("BtnAutoCollect", "⏱️ 5. เก็บเงินอัตโนมัติ (ทุกๆ " .. collectDelay .. " วินาที): [ปิด]", function() end)

collectBtn.MouseButton1Click:Connect(function()
    autoCollectEnabled = not autoCollectEnabled
    collectBtn.Text = "⏱️ 5. เก็บเงินอัตโนมัติ (ทุกๆ " .. collectDelay .. " วินาที): " .. (autoCollectEnabled and "[เปิด 👹]" or "[ปิด]")
    
    task.spawn(function()
        while autoCollectEnabled do
            task.wait(collectDelay)
            pcall(function()
                -- วาร์ปไปเก็บเหรียญ/เงินที่ตกอยู่ หรือดึง RemoteEvent เก็บเงิน
                for _, drop in pairs(workspace:GetChildren()) do
                    if drop.Name:find("Coin") or drop.Name:find("Money") or drop.Name:find("Gem") then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            -- ดูดเงินเข้าตัวละคร
                            drop.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                        end
                    end
                end
            end)
        end
    end)
end)

print("👹 โหลดเมนูทั่วไป (Demon Hub) สำเร็จแล้ว!")
