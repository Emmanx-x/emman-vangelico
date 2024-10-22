-----------------For support, scripts, and more----------------
--------------- https://discord.gg/qBUx3y8v8u  -------------
---------------------------------------------------------------

local QBCore = exports['qb-core']:GetCoreObject()

local emmanCooldowns = {}
local emmanRewardsVault = Config.EmmanRewardsVault

local function initializePlayerData(src)
    if not emmanCooldowns[src] then
        emmanCooldowns[src] = {}
    end
end

QBCore.Functions.CreateCallback('emman-vangelico:server:getCops', function(source, cb)
    local amount = 0
    for _, v in pairs(QBCore.Functions.GetQBPlayers()) do
        if (v.PlayerData.job.name == 'police' or v.PlayerData.job.type == 'leo') and v.PlayerData.job.onduty then
            amount = amount + 1
        end
    end
    print("Current police count: " .. amount) 
    cb(amount)
end)

RegisterNetEvent('emmanRewards:checkCooldown')
AddEventHandler('emmanRewards:checkCooldown', function(locationIndex, item, count)
    local src = source
    local currentTime = os.time()
    local emmanCooldownTime = 1800

    initializePlayerData(src)

    if not emmanCooldowns[src][locationIndex] or (currentTime - emmanCooldowns[src][locationIndex] >= emmanCooldownTime) then
        TriggerEvent('emmanRewards:addItem', item, count, src)
        emmanCooldowns[src][locationIndex] = currentTime 
    else
        local timeRemaining = emmanCooldownTime - (currentTime - emmanCooldowns[src][locationIndex])
        TriggerClientEvent('QBCore:Notify', src, "You must wait " .. math.ceil(timeRemaining / 60) .. " minutes before running again.", 'error')
    end
end)

RegisterNetEvent("emman-vangelico:server:addItem")
AddEventHandler("emman-vangelico:server:addItem", function(itemName, quantity)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        Player.Functions.AddItem(itemName, quantity)
    end
end)

RegisterNetEvent('emmanRewards:addItem')
AddEventHandler('emmanRewards:addItem', function(item, count, src)
    print("Attempting to add item:", item, "Count:", count)
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then
        print("Player not found")
        return
    end

    local success = Player.Functions.AddItem(item, count)

    if success then
        local notificationMessage = "You received " .. count .. " " .. item
        TriggerClientEvent('emmanRewards:Notify', src, notificationMessage, 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, "Failed to add item", 'error')
    end
end)

RegisterNetEvent('emmanRewardsVault', function()
    local playerId = source
    local receivedItems = {}
    local eligibleItems = {}

    for _, item in ipairs(emmanRewardsVault) do
        if math.random(1, 100) <= item.chance then
            table.insert(eligibleItems, item)
        end
    end

    local numItemsToGive = math.random(2, math.min(3, #eligibleItems))

    for i = 1, numItemsToGive do
        if #eligibleItems > 0 then
            local randomIndex = math.random(1, #eligibleItems)
            local item = eligibleItems[randomIndex]
            local amount = math.random(1, item.maxAmount)

            local success = exports['ps-inventory']:AddItem(playerId, item.name, amount)

            if success then
                print("Successfully added:", amount, item.name)
                table.insert(receivedItems, { name = item.name, amount = amount })
            else
                print("Failed to add:", item.name)
            end

            table.remove(eligibleItems, randomIndex)
        end
    end

    if #receivedItems > 0 then
        local itemList = ""
        for _, item in ipairs(receivedItems) do
            itemList = itemList .. item.amount .. " " .. item.name .. ", "
        end
        itemList = itemList:sub(1, -3)

        TriggerClientEvent('emmanRewards:Notify', playerId, "You received: " .. itemList, "success")
    else
        TriggerClientEvent('emmanRewards:Notify', playerId, "You didn't receive any items this time.", "info")
    end
end)

RegisterNetEvent('emman-vangelico:server:lockpickremove', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.Functions.RemoveItem('lockpick', 1) then
        TriggerClientEvent('emmanRewards:Notify', src, "Lockpick removed from inventory.", "success")
    else
        TriggerClientEvent('emmanRewards:Notify', src, "You don't have a lockpick.", "error")
    end
end)

RegisterNetEvent('emman-vangelico:server:flashdriveremove', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.Functions.RemoveItem('flashdrive', 1) then
        TriggerClientEvent('emmanRewards:Notify', src, "Flash drive removed from inventory.", "success")
    else       
        TriggerClientEvent('emmanRewards:Notify', src, "You don't have a flash drive.", "error")
    end
end)

RegisterNetEvent('emman-vangelico:server:sellItem')
AddEventHandler('emman-vangelico:server:sellItem', function(itemName, quantity)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local itemToSell = nil

    for _, item in ipairs(Config.SellItems) do
        if item.name == itemName then
            itemToSell = item
            break
        end
    end

    if itemToSell then
        if Player.Functions.RemoveItem(itemName, quantity) then
            local totalPrice = itemToSell.price * quantity
            Player.Functions.AddMoney('cash', totalPrice)
            TriggerClientEvent('emmanRewards:Notify', src, "Sold " .. quantity .. " " .. itemName .. " for $" .. totalPrice, "success")
        else
            TriggerClientEvent('emmanRewards:Notify', src, "You do not have enough " .. itemName, "error")
        end
    else
        TriggerClientEvent('emmanRewards:Notify', src, "Item not available for sale.", "error")
    end
end)



















