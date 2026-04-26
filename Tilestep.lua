do  
    local D,T,P,X,S,E,R,Pa,GM,SM,RG,RS,RE,CG,Sel,C,G=  
        debug,type,pcall,xpcall,tostring,error,rawget,pairs,  
        getmetatable,setmetatable,rawget,rawset,rawequal,collectgarbage,select,coroutine,_G  
  
    local function dbgOK()  
        if T(D)~="table" then return false end  
        for _,k in Pa{"getinfo","getlocal","getupvalue","traceback","sethook","setupvalue","getregistry"} do  
            if T(D[k])~="function" then return false end  
        end  
        return true  
    end  
    if not dbgOK() then E("Tamper Detected! Reason: Debug library incomplete") return end  
  
    local function isNative(f)  
        local i=D.getinfo(f)  
        return i and i.what=="C"  
    end  
  
    local function checkNativeFuncs()  
        local natives={  
            P,X,assert,E,print,RG,RS,RE,tonumber,S,T,  
            Sel,next,ipairs,Pa,CG,GM,SM,  
            load,loadstring,loadfile,dofile,collectgarbage,  
            D.getinfo,D.getlocal,D.getupvalue,D.sethook,D.setupvalue,D.traceback,  
            C.create,C.resume,C.yield,C.status,  
            math.abs,math.acos,math.asin,math.atan,math.ceil,math.cos,math.deg,math.exp,  
            math.floor,math.fmod,math.huge,math.log,math.max,math.min,math.modf,math.pi,  
            math.rad,math.random,math.sin,math.sqrt,math.tan,  
            os.clock,os.date,os.difftime,os.execute,os.exit,os.getenv,os.remove,  
            os.rename,os.setlocale,os.time,os.tmpname,  
            string.byte,string.char,string.dump,string.find,string.format,string.gmatch,  
            string.gsub,string.len,string.lower,string.match,string.rep,string.reverse,  
            string.sub,string.upper,  
            table.insert,table.maxn,table.remove,table.sort  
        }  
        local mts={string,table,math,os,G,package}  
        for _,t in Pa(mts) do  
            local mt=GM(t)  
            if mt then  
                for _,m in Pa{"__index","__newindex","__call","__metatable"} do  
                    local mf=mt[m]  
                    if mf and T(mf)=="function" and not isNative(mf) then  
                        return false,"Metamethod tampered: "..m  
                    end  
                end  
            end  
        end  
        for _,fn in Pa(natives) do  
            if T(fn)=="function" and not isNative(fn) then  
                return false,"Native function replaced or wrapped"  
            end  
        end  
        return true  
    end  
  
    local function isMinified(f)  
        local i=D.getinfo(f,"Sl")  
        return i and i.linedefined==i.lastlinedefined  
    end  
  
    local function scanUp(f)  
        local i=1  
        while true do  
            local n,v=D.getupvalue(f,i)  
            if not n then break end  
            if T(v)=="function" and not isMinified(v) then return false,"Suspicious upvalue: "..n end  
            i=i+1  
        end  
        return true  
    end  
  
    local function scanLocals(l)  
        local i=1  
        while true do  
            local n,v=D.getlocal(l,i)  
            if not n then break end  
            if T(v)=="function" and not isMinified(v) then return false,"Suspicious local: "..n end  
            i=i+1  
        end  
        return true  
    end  
  
    local function checkGlobals()  
        local essentials={"pcall","xpcall","type","tostring","string","table","debug","coroutine","math","os","package"}  
        for _,k in Pa(essentials) do  
            if T(G[k])~=T(_G[k]) then return false,"Global modified: "..k end  
        end  
        if package and package.loaded and T(package.loaded.debug)~="table" then  
            return false,"Package.debug modified"  
        end  
        return true  
    end  
  
    local function run()  
        local ok,r=checkNativeFuncs()  
        if not ok then return false,r end  
        ok,r=checkGlobals()  
        if not ok then return false,r end  
        for l=2,4 do  
            local i=D.getinfo(l,"f")  
            if i and i.func then  
                ok,r=scanUp(i.func)  
                if not ok then return false,r.." @lvl "..l end  
            end  
            ok,r=scanLocals(l)  
            if not ok then return false,r.." @lvl "..l end  
        end  
        return true  
    end  
  
    local ok,r=run()  
    if not ok then  
        E("Tamper Detected! Reason: "..S(r))  
        while true do E("Tamper Detected! Reason: "..S(r)) end  
    end  
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

Rayfield:CreateWindow({
    Name = "TileStep",
    LoadingTitle = "TileStep Script",
    LoadingSubtitle = "by Scriptide",
    ConfigurationSaving = { Enabled = false },
    KeySystem = true,
    KeySettings = {
        Title = "TileStep",
        Subtitle = "Key System",
        Note = "Join our Discord for the key",
        FileName = "TileStepKey",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = {"187gwe874fqweq072t448"}
    }
})
local RS = game:GetService("ReplicatedStorage")
local remote = RS:WaitForChild("TileStep")
local convertRemote = RS:WaitForChild("Convert")
local upgradeRemote = RS:WaitForChild("Upgrade")
local unboxRemote = RS:WaitForChild("Unbox")
local buffRemote = RS:WaitForChild("Biff")
local rebirthRemote = RS:WaitForChild("Rebirth")

local running = false
local autoConvert = false
local autoUpgrade = false
local autoSpaceEgg = false
local autoPlanetCrate = false
local autoBuff = false
local autoCrate = false
local autoPetEgg = false
local autoRebirth = false
local selectedCrate = {}
local selectedEgg = nil
local autoEquipPets = false
local autoEquipTiles = false
local equipRemote = RS:WaitForChild("Equip")

local selectedBuffs = {
    ["Pet Range"] = false,
    ["Luck"] = false,
    ["Speed"] = false,
    ["Chain Reaction"] = false,
}
local buffOrder = {"Pet Range", "Luck", "Speed", "Chain Reaction"}

local Window = Rayfield:CreateWindow({
    Name = "TileStep",
    LoadingTitle = "TileStep Script",
    LoadingSubtitle = "by Scriptide",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false,
})

local MainTab = Window:CreateTab("Main", "zap")
local CratesTab = Window:CreateTab("Crates", "box")
local EggsTab = Window:CreateTab("Eggs", "egg")
local BuffsTab = Window:CreateTab("Buffs", "sparkles")

-- MAIN TAB
MainTab:CreateSection("TileStep")

MainTab:CreateToggle({
    Name = "Auto TileStep",
    CurrentValue = false,
    Flag = "AutoTileStep",
    Callback = function(val)
        running = val
    end,
})

MainTab:CreateToggle({
    Name = "Auto Convert",
    CurrentValue = false,
    Flag = "AutoConvert",
    Callback = function(val)
        autoConvert = val
    end,
})

MainTab:CreateToggle({
    Name = "Auto Upgrade",
    CurrentValue = false,
    Flag = "AutoUpgrade",
    Callback = function(val)
        autoUpgrade = val
    end,
})

MainTab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Flag = "AutoRebirth",
    Callback = function(val)
        autoRebirth = val
    end,
})
MainTab:CreateSection("Auto Equip")

MainTab:CreateToggle({
    Name = "Auto Equip Pets",
    CurrentValue = false,
    Flag = "AutoEquipPets",
    Callback = function(val)
        autoEquipPets = val
    end,
})

MainTab:CreateToggle({
    Name = "Auto Equip Tiles",
    CurrentValue = false,
    Flag = "AutoEquipTiles",
    Callback = function(val)
        autoEquipTiles = val
    end,
})

-- CRATES TAB
CratesTab:CreateSection("Box Openings")

CratesTab:CreateToggle({
    Name = "Auto Space Egg",
    CurrentValue = false,
    Flag = "AutoSpaceEgg",
    Callback = function(val)
        autoSpaceEgg = val
    end,
})

CratesTab:CreateToggle({
    Name = "Auto Planet Crate",
    CurrentValue = false,
    Flag = "AutoPlanetCrate",
    Callback = function(val)
        autoPlanetCrate = val
    end,
})

CratesTab:CreateSection("Buy Crates")

CratesTab:CreateDropdown({
    Name = "Select Crates",
    Options = {
        "Wood Crate", "Metal Crate", "Bronze Crate",
        "Diamond Crate", "Aether Crate", "Angel Crate", "Lucky Block Crate"
    },
    CurrentOption = {},
    Flag = "SelectedCrates",
    MultipleOptions = true,
    Callback = function(options)
        selectedCrate = options
    end,
})

CratesTab:CreateToggle({
    Name = "Auto Buy Crate",
    CurrentValue = false,
    Flag = "AutoCrate",
    Callback = function(val)
        autoCrate = val
    end,
})

-- EGGS TAB
EggsTab:CreateSection("Pet Eggs")

EggsTab:CreateDropdown({
    Name = "Select Egg",
    Options = {
        "Starter Egg", "Uncommon Egg", "Earth Egg",
        "Weird Egg", "Special Egg", "CRAZY Egg"
    },
    CurrentOption = {"Starter Egg"},
    Flag = "SelectedEgg",
    MultipleOptions = false,
    Callback = function(option)
        selectedEgg = option[1] or option
    end,
})

EggsTab:CreateToggle({
    Name = "Auto Open Egg",
    CurrentValue = false,
    Flag = "AutoPetEgg",
    Callback = function(val)
        autoPetEgg = val
    end,
})

-- BUFFS TAB
BuffsTab:CreateSection("Buy Buffs")

BuffsTab:CreateToggle({
    Name = "Auto Buff",
    CurrentValue = false,
    Flag = "AutoBuff",
    Callback = function(val)
        autoBuff = val
    end,
})

BuffsTab:CreateSection("Select Buffs")

for _, buffName in ipairs(buffOrder) do
    BuffsTab:CreateToggle({
        Name = buffName,
        CurrentValue = false,
        Flag = "Buff_" .. buffName,
        Callback = function(val)
            selectedBuffs[buffName] = val
        end,
    })
end

-- MAIN LOOP
while true do
    if running then
        for i = 1, 150 do
            task.spawn(function()
                remote:FireServer(i)
            end)
        end
    end
    if autoConvert then convertRemote:FireServer() end
    if autoUpgrade then
        task.spawn(function() upgradeRemote:InvokeServer() end)
    end
    if autoSpaceEgg then
    task.spawn(function()
        unboxRemote:InvokeServer("Space Egg")
        task.wait(0.1)
        keypress(0x51)
        task.wait(0.05)
        keyrelease(0x51)
    end)
end

if autoPlanetCrate then
    task.spawn(function()
        unboxRemote:InvokeServer("Planet Crate")
        task.wait(0.1)
        keypress(0x51)
        task.wait(0.05)
        keyrelease(0x51)
    end)
end

if autoCrate and selectedCrate and #selectedCrate > 0 then
    for _, crate in ipairs(selectedCrate) do
        task.spawn(function()
            unboxRemote:InvokeServer(crate)
            task.wait(0.1)
            keypress(0x51)
            task.wait(0.05)
            keyrelease(0x51)
        end)
    end
end

if autoPetEgg and selectedEgg then
    task.spawn(function()
        unboxRemote:InvokeServer(selectedEgg)
        task.wait(0.1)
        keypress(0x51)
        task.wait(0.05)
        keyrelease(0x51)
    end)
end
    if autoBuff then
        for _, buffName in ipairs(buffOrder) do
            if selectedBuffs[buffName] then
                task.spawn(function() buffRemote:InvokeServer(buffName) end)
            end
        end
    end
	if autoEquipPets then
    task.spawn(function()
        equipRemote:InvokeServer("Pets")
    end)
end
if autoEquipTiles then
    task.spawn(function()
        equipRemote:InvokeServer("Tiles")
    end)
end
    if autoRebirth then
        task.spawn(function() rebirthRemote:InvokeServer() end)
    end
    task.wait(0.4)
end
