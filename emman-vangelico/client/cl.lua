-----------------For support, scripts, and more----------------
--------------- https://discord.gg/qBUx3y8v8u  -------------
---------------------------------------------------------------

local QBCore = exports['qb-core']:GetCoreObject()

local isAnimating = false
local vaultInputActive = false
local vaultOpened = false
local emmanCooldownActive = false
local code
local emmanCooldown = Config.RobberyCooldown
local emmanInteractPed = 'cs_solomon'
local guardPedModel = 'ig_fbisuit_01'
local interactPedCoords = vector4(705.52, -965.80, 29.40, 284.93)
local emman1GuardPed = vector4(706.06, -966.55, 29.41, 306.63)
local emman2GuardPed = vector4(710.38, -965.26, 29.40, 280.99)
local emmanPed, emman1, emman2

local function loadParticle()
    if not HasNamedPtfxAssetLoaded('scr_jewelheist') then
        RequestNamedPtfxAsset('scr_jewelheist')
        while not HasNamedPtfxAssetLoaded('scr_jewelheist') do
            Wait(0)
        end
    end
    SetPtfxAssetNextCall('scr_jewelheist')
end

local function getRandomItem()
    local totalChance = 0
    local cumulativeChances = {}

    for _, item in ipairs(Config.EmmanRandomItems) do
        totalChance = totalChance + item.chance
        table.insert(cumulativeChances, totalChance)
    end

    local rand = math.random(1, totalChance)

    for i, chance in ipairs(cumulativeChances) do
        if rand <= chance then
            return Config.EmmanRandomItems[i].name
        end
    end
end

local function getRandomReward()
    local items = Config.SearchItems
    local randomIndex = math.random(1, #items) -- Get a random index
    return items[randomIndex]
end

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

local function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(500)
    end
end

local function setupTarget()
    exports['qb-target']:AddTargetEntity(emmanPed, {
        options = {
            {
                type = "client",
                event = "emman-vangelico:client:emmanWithPed",
                icon = "fas fa-comment",
                label = "Talk to Mr. Solomon",
            },
        },
        distance = 2.5
    })
end

local function createPeds()
    if emmanPed or emman1 or emman2 then return end

    loadModel(emmanInteractPed)
    emmanPed = CreatePed(4, emmanInteractPed, interactPedCoords.x, interactPedCoords.y, interactPedCoords.z, interactPedCoords.w, false, true)
    SetEntityAsMissionEntity(emmanPed, true, true)
    FreezeEntityPosition(emmanPed, true)
    TaskStartScenarioInPlace(emmanPed, "WORLD_HUMAN_TOURIST_MOBILE", 0, true)

    loadModel(guardPedModel)
    emman1 = CreatePed(4, guardPedModel, emman1GuardPed.x, emman1GuardPed.y, emman1GuardPed.z, emman1GuardPed.w, false, true)
    emman2 = CreatePed(4, guardPedModel, emman2GuardPed.x, emman2GuardPed.y, emman2GuardPed.z, emman2GuardPed.w, false, true)

    SetEntityAsMissionEntity(emman1, true, true)
    SetEntityAsMissionEntity(emman2, true, true)
    FreezeEntityPosition(emman1, true)
    FreezeEntityPosition(emman2, true)
    TaskStartScenarioInPlace(emman1, "WORLD_HUMAN_GUARD_STAND", 0, true)
    TaskStartScenarioInPlace(emman2, "WORLD_HUMAN_GUARD_STAND", 0, true)

    SetEntityInvincible(emmanPed, true)
    SetEntityInvincible(emman1, true)
    SetEntityInvincible(emman2, true)
    SetBlockingOfNonTemporaryEvents(emmanPed, true)
    SetBlockingOfNonTemporaryEvents(emman1, true)
    SetBlockingOfNonTemporaryEvents(emman2, true)

    setupTarget()
end

local function despawnPeds()
    if DoesEntityExist(emmanPed) then
        DeleteEntity(emmanPed)
        emmanPed = nil
    end
    if DoesEntityExist(emman1) then
        DeleteEntity(emman1)
        emman1 = nil
    end
    if DoesEntityExist(emman2) then
        DeleteEntity(emman2)
        emman2 = nil
    end
end

local function spawnPeds()
    createPeds()
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        if Config.NightTime() then
            if emmanPed and emman1 and emman2 then
                despawnPeds()
            end
        else
            if not (emmanPed and emman1 and emman2) then
                spawnPeds()
            end
        end
    end
end)

spawnPeds()

RegisterNetEvent("emman-vangelico:client:searchCabinet")
AddEventHandler("emman-vangelico:client:searchCabinet", function()
    if emmanCooldownActive then
        lib.notify({
            title = 'Cooldown',
            description = 'You must wait before searching again.',
            type = 'error'
        })
        return
    end

    local itemFound = Config.SearchItems[math.random(#Config.SearchItems)]
    local quantity = math.random(1, 3)

    local success = lib.skillCheck({'easy', 'easy', {areaSize = 80, speedMultiplier = 1}, 'medium'}, {'1', '2', '3', '4'})
    if success then
        loadAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
        TaskPlayAnim(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -1, -1, 49, 0, 0, 0, 0)
        QBCore.Functions.Progressbar('search_cabinet', 'Searching the cabinet...', 5000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() 
            ClearPedTasksImmediately(PlayerPedId())
            TriggerServerEvent("emman-vangelico:server:addItem", itemFound, quantity)
            lib.notify({
                title = 'Success',
                description = 'You successfully searched the cabinet and found ' .. quantity .. 'x ' .. itemFound,
                type = 'success'
            })
            emmanCooldownActive = true
            Wait(emmanCooldown)
            emmanCooldownActive = false
            lib.notify({
                title = 'Cooldown Over',
                description = 'You can search the cabinet again.',
                type = 'success'
            })
        end, function()
            ClearPedTasksImmediately(PlayerPedId())
            lib.notify({
                title = 'Cancelled',
                description = 'You stopped searching the cabinet.',
                type = 'error'
            })
        end)
    else
        lib.notify({
            title = 'Failed',
            description = 'You failed to search the cabinet properly.',
            type = 'error'
        })
    end
end)

local function playSmashAnimation(locationIndex, item, itemCount)
    local playerPed = PlayerPedId()
    local itemReceived = false
    local smashing = true

    isAnimating = true

    local breakAnimDict = "missheist_jewel"
    local breakAnimName = "smash_case"
    loadAnimDict(breakAnimDict)

    FreezeEntityPosition(playerPed, true)
    TaskPlayAnim(playerPed, breakAnimDict, breakAnimName, 8.0, -8.0, -1, 49, 0, false, false, false)
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)

    loadParticle()

    local plyCoords = GetEntityCoords(playerPed)
    StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', plyCoords.x, plyCoords.y, plyCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
    
    local totalDuration = 10000 
    local firstSoundPlayTime = 500
    local secondSoundPlayTime = 6000

    CreateThread(function()
        Wait(firstSoundPlayTime)
        if smashing then
            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'breaking_vitrine_glass', 0.25)
        end

        Wait(secondSoundPlayTime - firstSoundPlayTime)
        if smashing then
            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'breaking_vitrine_glass', 0.25)
        end
    end)
    
    QBCore.Functions.Progressbar('smash_glass', 'Breaking the glass...', totalDuration, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        smashing = false

        StopParticleFxLooped(particleEffect, 0)
        
        local particleEffect2 = StartParticleFxLoopedAtCoord('scr_jewel_cab_smash', plyCoords.x, plyCoords.y, plyCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)

        Wait(0)
        StopParticleFxLooped(particleEffect2, 0)
        
        if not itemReceived then
            itemReceived = true
            TriggerServerEvent('emmanRewards:checkCooldown', locationIndex, item, itemCount)
        end
        

        FreezeEntityPosition(playerPed, false)
        isAnimating = false

    end, function()
        lib.notify({
            title = 'Action Canceled',
            description = 'You have canceled the action.',
            type = 'error'
        })
        FreezeEntityPosition(playerPed, false)
        isAnimating = false
        StopParticleFxLooped(particleEffect1, 0)
    end)
end

local function hasAllRequiredItems()
    return true
end

local function validWeapon()
    local ped = PlayerPedId()
    local pedWeapon = GetSelectedPedWeapon(ped)

    for k, _ in pairs(Config.RequiredItems) do
        if pedWeapon == k then
            return true
        end
    end
    return false
end

local function emmanComputerAnimation()
    local playerPed = PlayerPedId()
    loadAnimDict("mp_fbi_heist")

    TaskPlayAnim(playerPed, "mp_fbi_heist", "loop", 8.0, -8.0, -1, 49, 0, false, false, false)
end

local function emmanDoorAnimation()
    local playerPed = PlayerPedId()
    loadAnimDict("anim@amb@carmeet@checkout_engine@")

    TaskPlayAnim(playerPed, "anim@amb@carmeet@checkout_engine@", "female_c_idle_d", 8.0, -8.0, -1, 49, 0, false, false, false)
end

local function emmanSmash(locationIndex)
    if not hasAllRequiredItems() then
        lib.notify({
            title = 'Missing Items',
            description = 'You must need a required item to smash the glass.',
            type = 'error'
        })
        return
    end
    
    if not validWeapon() then
        lib.notify({
            title = 'Invalid Weapon',
            description = 'You must need a valid weapon to smash the glass.',
            type = 'error'
        })
        return
    end

    local item = getRandomItem()
    local itemCount = math.random(1, 3)
    Config.Locations[locationIndex].isBusy = true
    playSmashAnimation(locationIndex, item, itemCount)
    TriggerServerEvent('police:server:policeAlert', 'Robbery in progress at Vangelico location ' .. locationIndex)
    Config.Locations[locationIndex].isOpened = true
end

RegisterNetEvent('emman-vangelico:client:smashGlass', function(locationIndex)

    QBCore.Functions.TriggerCallback('emman-vangelico:server:getCops', function(cops)
        local requiredCops = Config.RequiredCops

        if cops >= requiredCops then
            emmanSmash(locationIndex)
        else
            lib.notify({
                title = 'Insufficient Cops',
                description = 'Not enough cops to trigger this.',
                type = 'error'
            })
        end
    end)
end)

RegisterNetEvent('emman-vangelico:client:emmanDoor', function()
    local hasLockpick = QBCore.Functions.HasItem('lockpick')

    if hasLockpick then
        local success = exports['qb-minigames']:Lockpick(5)

        if success then
            emmanDoorAnimation()
            QBCore.Functions.Progressbar('lockpicking_door', 'Lockpicking...', 10000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function()
                lib.notify({
                    title = 'Success',
                    description = 'Door Opened!',
                    type = 'success'
                })
                TriggerServerEvent('emman-vangelico:server:lockpickremove')
                TriggerServerEvent('qb-doorlock:server:updateState', "emman-vangedoor", false, false, false, true, false, false)
                local camId = '31 | 32 | 33 | 34'
                exports['ps-dispatch']:VangelicoRobbery(camId)
            end, function()
                lib.notify({
                    title = 'Error',
                    description = 'Failed to unlock the door.',
                    type = 'error'
                })
                TriggerServerEvent('emman-vangelico:server:lockpickremove')
            end)
        else
            lib.notify({
                title = 'Error',
                description = 'Failed to unlock the door.',
                type = 'error'
            })
            TriggerServerEvent('emman-vangelico:server:lockpickremove')
        end
    else
        lib.notify({
            title = 'Error',
            description = 'You need a lockpick to open this door.',
            type = 'error'
        })
    end
end)

RegisterNetEvent('emman-vangelico:client:computer2', function()
    if emmanCooldownActive then
        lib.notify({
            title = 'Error',
            description = 'You must wait before hacking the computer again.',
            type = 'error'
        })
        return
    end

    local item3 = QBCore.Functions.HasItem('flashdrive')
    if item3 then
        local success = lib.skillCheck({'easy', 'easy', {areaSize = 80, speedMultiplier = 1}, 'medium'}, {'1', '2', '3', '4'})
            if success then
                emmanComputerAnimation()
                QBCore.Functions.Progressbar('hacking_computer', 'Hacking the computer...', 15000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function()

                    ClearPedTasksImmediately(PlayerPedId())
                    code = tostring(math.random(1000, 9999))
                    TriggerServerEvent('emman-vangelico:server:flashdriveremove')
                    lib.notify({
                        title = 'Success',
                        description = 'Computer Hacked! Use the code to open the vault.',
                        type = 'success'
                    })
                    TriggerServerEvent('police:server:policeAlert', 'Robbery in progress')
                    local camId = '31 | 32 | 33 | 34'
                    exports['ps-dispatch']:VangelicoRobbery(camId)

                    Wait(3000)
                    emmandisplayCode(code)

                    emmanCooldownActive = true
                    SetTimeout(emmanCooldown, function()
                        emmanCooldownActive = false
                        lib.notify({
                            title = 'Success',
                            description = 'The computer is now ready to be hacked again.',
                            type = 'success'
                        })
                    end)
                end, function()
                ClearPedTasksImmediately(PlayerPedId())
                lib.notify({
                    title = 'Error',
                    description = 'Failed to hack the computer.',
                    type = 'error'
                })
            end)
        else
            lib.notify({
                title = 'Error',
                description = 'Failed to hack the computer.',
                type = 'error'
            })
        end
    else
        lib.notify({
            title = 'Error',
            description = 'You can\'t open this..',
            type = 'error'
        })
    end
end)

function emmandisplayCode(code)
    lib.notify({
        title = 'Vault Code',
        description = 'The vault code is: ' .. code .. '\nUse this code to open the vault.',
        type = 'inform',
        duration = 10000,
        position = 'center-right',
    })
end

RegisterNetEvent('emman-vangelico:client:vault', function()
    if vaultOpened then
        lib.notify({
            title = 'Error',
            description = 'The vault has already been opened. Please wait for a cooldown.',
            type = 'error'
        })
        return
    end

    if vaultInputActive then
        lib.notify({
            title = 'Error',
            description = 'You are already entering a vault code.',
            type = 'error'
        })
        return
    end

    vaultInputActive = true
    local vaultcode = tonumber(code)

    local input = lib.inputDialog('Safe Vault', {
        { type = "input", label = "Enter the vault code", password = true, icon = 'fas fa-key' }
    })

    if input then
        local result = tonumber(input[1])

        if result == vaultcode then

            loadAnimDict("mini@safe_cracking")
            TaskPlayAnim(PlayerPedId(), "mini@safe_cracking", "dial_turn_anti_fast_1", 3.0, 3.0, -1, 49, 0, 0, 0, 0)
            
            QBCore.Functions.Progressbar('vault_code_input', 'Cracking the safe...', 15000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function()
                ClearPedTasksImmediately(PlayerPedId())
                TriggerServerEvent('emmanRewardsVault')
                vaultOpened = true
            end, function()
                ClearPedTasksImmediately(PlayerPedId())
                vaultInputActive = false
            end)
        else

            loadAnimDict("mini@safe_cracking")
            TaskPlayAnim(PlayerPedId(), "mini@safe_cracking", "dial_turn_anti_fast_2", 3.0, 3.0, -1, 49, 0, 0, 0, 0)

            QBCore.Functions.Progressbar('vault_code_error', 'Cracking the safe...', 15000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function()
            ClearPedTasksImmediately(PlayerPedId())
            lib.notify({
                title = 'Error',
                description = 'Incorrect code...',
                type = 'error'
            })
            vaultInputActive = false
            end, function ()               
                vaultInputActive = false
            end)
        end
    else
        ClearPedTasksImmediately(PlayerPedId())
        vaultInputActive = false
    end
end)

RegisterNetEvent('emman-vangelico:client:emmanWithPed', function()
    local items = Config.SellItems
    local itemOptions = {}
    for _, item in ipairs(items) do
        table.insert(itemOptions, {
            title = item.label .. " - $" .. item.price,
            event = 'emman-vangelico:client:purchaseItem',
            args = { item = item.name, price = item.price }
        })
    end
    lib.registerContext({
        id = 'selling_menu',
        title = 'Items for Sale',
        options = itemOptions,
    })
    lib.showContext('selling_menu')
end)

RegisterNetEvent('emman-vangelico:client:purchaseItem', function(data)
    local item = data.item
    local price = data.price
    local input = lib.inputDialog('Sell Item', {
        { type = 'input', label = 'Enter quantity', placeholder = '1' },
    })

    if input then
        local quantity = tonumber(input[1])
        if quantity and quantity > 0 then
            local PlayerData = QBCore.Functions.GetPlayerData()
            local itemCount = PlayerData.items
            local itemFound = false
            for _, v in ipairs(itemCount) do
                if v.name == item and v.amount >= quantity then
                    itemFound = true
                    break
                end
            end
            if itemFound then
                local playerPed = PlayerPedId()
                RequestAnimDict("mp_common")
                while not HasAnimDictLoaded("mp_common") do
                    Wait(100)
                end
                TaskPlayAnim(playerPed, "mp_common", "givetake1_a", 8.0, -8.0, 5000, 49, 0, false, false, false)
                QBCore.Functions.Progressbar('selling_item', 'Selling item...', 5000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {}, {}, {}, function()
                    ClearPedTasks(playerPed)
                    TriggerServerEvent('emman-vangelico:server:sellItem', item, quantity)
                end, function()
                    ClearPedTasks(playerPed)
                    lib.notify({ title = "Sale Cancelled", description = "You cancelled the sale.", type = "error" })
                end)
            else
                lib.notify({ title = "Sale Failed", description = "You do not have any " .. item .. " in your inventory.", type = "error" })
            end
        else
            lib.notify({ title = "Invalid Input", description = "Please enter a valid quantity.", type = "error" })
        end
    end
end)

RegisterNetEvent('emmanRewards:Notify')
AddEventHandler('emmanRewards:Notify', function(message, notifyType)
    lib.notify({
        title = 'Notification',
        description = message,
        type = notifyType
    })
end)

CreateThread(function()
    if Config.UseTarget then
        for k, v in pairs(Config.Locations) do
            exports['qb-target']:AddBoxZone('vangelico' .. k, v.coords, 1, 1, {
                name = 'vangelico' .. k,
                heading = 40,
                minZ = v.coords.z - 1,
                maxZ = v.coords.z + 1,
                debugPoly = false
            }, {
                options = {
                    {
                        type = 'client',
                        icon = 'fa fa-hand',
                        label = Lang:t('general.target_label'),
                        action = function()
                            if not v.isOpened and not v.isBusy then
                                QBCore.Functions.TriggerCallback('emman-vangelico:server:getCops', function(cops)
                                    local requiredCops = Config.RequiredCops

                                    if cops >= requiredCops then
                                        emmanSmash(k)
                                    else
                                        lib.notify({
                                            title = 'Insufficient Cops',
                                            description = 'Not enough cops to trigger this.',
                                            type = 'error'
                                        })
                                    end
                                end)

                                SetTimeout(emmanCooldown, function()
                                    v.isOpened = false
                                    v.isBusy = false
                                end)
                            else
                                lib.notify({
                                    title = 'Error',
                                    description = 'This Vangelico robbery is currently busy or has already been opened.',
                                    type = 'error'
                                })
                            end
                        end,
                        canInteract = function()
                            return not v.isOpened and not v.isBusy
                        end,
                    }
                },
                distance = 1.5
            })
            exports['qb-target']:AddCircleZone("EmmanDoor", vector3(-628.09, -229.45, 38.07), 0.5, { 
                name = "emman-door",
                debugPoly = false,
                useZ = true,
            }, {
                options = {
                    {
                        type = "client",
                        event = "emman-vangelico:client:emmanDoor",
                        icon = "fa fa-key",
                        label = "Lockpick"
                    },
                },
                distance = 1
            })
            exports['qb-target']:AddCircleZone("computer", vector3(-630.86, -230.83, 38.21), 0.5, {
                name = "computer2",
                debugPoly = false,
                useZ = true,
            }, {
                options = {
                    {
                        type = "client",
                        event = "emman-vangelico:client:computer2",
                        icon = "fas fa-computer",
                        label = "Hack Computer"
                    },
                },
                distance = 2
            })
            exports['qb-target']:AddCircleZone("searchCabinet", vector3(-632.16, -228.94, 38.06), 0.5, {
                name = "searchCabinet",
                debugPoly = false,
                useZ = true,
            }, {
                options = {
                    {
                        type = "client",
                        event = "emman-vangelico:client:searchCabinet",
                        icon = "fas fa-cabinet",
                        label = "Search",
                    },
                },
                distance = 2
            })
            
        end
    end
end)

CreateThread(function()
    local safeProp = CreateObject(GetHashKey("sf_prop_v_43_safe_s_bk_01a"), -631.02, -227.98, 37.06570, true,  true, true)
    FreezeEntityPosition(safeProp, true)
    SetEntityHeading(safeProp, 38.19)
    Wait(500)
    exports['qb-target']:AddTargetEntity(safeProp, {
        options = {
            {
                type = "client",
                event = "emman-vangelico:client:vault",
                icon = "fas fa-box-circle-check",
                label = "Input the code",
            },
        },
        distance = 3.0
    })
end)

CreateThread(function()
    while true do
        Wait(0)

        if isAnimating then
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)
            DisableControlAction(0, 32, true)
            DisableControlAction(0, 33, true)
        end
    end
end)

CreateThread(function()
    if Config and Config.VangelicoLocation then
        local emmanBlip = AddBlipForCoord(Config.VangelicoLocation.coords.x, Config.VangelicoLocation.coords.y, Config.VangelicoLocation.coords.z)
        SetBlipScale(emmanBlip, 0.7)
        SetBlipSprite(emmanBlip, 617)
        SetBlipColour(emmanBlip, 3)
        SetBlipAlpha(emmanBlip, 255)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.BlipName)
        EndTextCommandSetBlipName(emmanBlip)
        SetBlipCategory(emmanBlip, 2)
    end
end)