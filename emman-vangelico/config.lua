-----------------For support, scripts, and more----------------
--------------- https://discord.gg/qBUx3y8v8u  -------------
---------------------------------------------------------------

Config = Config or {}

Config.UseTarget = GetConvar('UseTarget', 'false') == 'true'

Config.BlipName = "Emman Vangelico Script"

Config.RequiredCops = 0

Config.RobberyCooldown = 1800000

Config.VangelicoLocation = {
    coords = vector3(-623.45, -231.54, 38.06)
}

Config.NightTime = function()
    local hour = GetClockHours()
    return hour >= 20 or hour < 6
end

Config.RequiredItems = {
    [`weapon_assaultrifle`] = {
        ['timeOut'] = 10000
    },
    [`weapon_carbinerifle`] = {
        ['timeOut'] = 10000
    },
    [`weapon_pumpshotgun`] = {
        ['timeOut'] = 10000
    },
    [`weapon_sawnoffshotgun`] = {
        ['timeOut'] = 10000
    },
    [`weapon_compactrifle`] = {
        ['timeOut'] = 10000
    },
    [`weapon_microsmg`] = {
        ['timeOut'] = 10000
    },
    [`weapon_autoshotgun`] = {
        ['timeOut'] = 10000
    },
    [`weapon_pistol`] = {
        ['timeOut'] = 10000
    },
    [`weapon_pistol_mk2`] = {
        ['timeOut'] = 10000
    },
    [`weapon_combatpistol`] = {
        ['timeOut'] = 10000
    },
    [`weapon_appistol`] = {
        ['timeOut'] = 10000
    },
    [`weapon_pistol50`] = {
        ['timeOut'] = 10000
    },
}

Config.EmmanRandomItems = {
    {name = 'rolex', chance = 40},
    {name = 'diamond_ring', chance = 10},
    {name = 'goldchain', chance = 40},
    {name = 'diamond', chance = 10}
}

Config.SearchItems = {
    "markedbills",
    "radio",
}

Config.EmmanRewardsVault = {
    { name = "markedbills", chance = 60, maxAmount = 10 },
    { name = "armor", chance = 50, maxAmount = 3 },
    { name = "diamond", chance = 40, maxAmount = 3 },
    { name = "phone", chance = 80, maxAmount = 2 },
    { name = "tenkgoldchain", chance = 60, maxAmount = 2 }
}

Config.SellItems = {
    { name = "tenkgoldchain", label = "10K Gold Chain", price = 1000 },
    { name = "diamond", label = "Diamond", price = 1000 },
    { name = "rolex", label = "Rolex", price = 1000 },
    { name = "diamond_ring", label = "Diamond Ring", price = 1000 },
    { name = "goldchain", label = "Gold Chain", price = 1000 },
}

Config.Locations = {
    { coords = vector3(-625.3, -238.26, 38.06), isOpened = false, isBusy = false },
    { coords = vector3(-626.33, -239.0, 38.06), isOpened = false, isBusy = false },
    { coords = vector3(-627.24, -234.87, 38.06), isOpened = false, isBusy = false },
    { coords = vector3(-626.14, -234.18, 38.06), isOpened = false, isBusy = false },
    { coords = vector3(-626.85, -233.44, 38.09), isOpened = false, isBusy = false },
    { coords = vector3(-627.88, -234.18, 38.18), isOpened = false, isBusy = false },
    { coords = vector3(-624.2, -230.71, 38.22), isOpened = false, isBusy = false },
    { coords = vector3(-623.96, -228.48, 38.17), isOpened = false, isBusy = false },
    { coords = vector3(-621.55, -228.53, 38.22), isOpened = false, isBusy = false },
    { coords = vector3(-619.74, -230.9, 38.22), isOpened = false, isBusy = false },
    { coords = vector3(-620.34, -233.07, 38.22), isOpened = false, isBusy = false },
    { coords = vector3(-622.51, -233.15, 38.22), isOpened = false, isBusy = false },
    { coords = vector3(-619.99, -234.87, 38.22), isOpened = false, isBusy = false },
    { coords = vector3(-619.05, -234.09, 38.22), isOpened = false, isBusy = false },
    { coords = vector3(-625.05, -227.35, 38.22), isOpened = false, isBusy = false },
    { coords = vector3(-623.99, -226.74, 38.22), isOpened = false, isBusy = false },
    { coords = vector3(-620.22, -226.39, 38.19), isOpened = false, isBusy = false },
    { coords = vector3(-619.48, -227.41, 38.21), isOpened = false, isBusy = false },
    { coords = vector3(-617.98, -229.43, 38.22), isOpened = false, isBusy = false },
    { coords = vector3(-617.18, -230.38, 38.22), isOpened = false, isBusy = false },
    { coords = vector3(-620.11, -237.67, 38.37), isOpened = false, isBusy = false },
    { coords = vector3(-618.66, -238.08, 38.33), isOpened = false, isBusy = false },
    { coords = vector3(-617.28, -237.68, 38.35), isOpened = false, isBusy = false },
    { coords = vector3(-616.25, -236.48, 38.37), isOpened = false, isBusy = false },
    { coords = vector3(-616.06, -234.97, 38.39), isOpened = false, isBusy = false },
    { coords = vector3(-624.02, -223.86, 38.36), isOpened = false, isBusy = false },
    { coords = vector3(-625.46, -223.45, 38.36), isOpened = false, isBusy = false },
    { coords = vector3(-626.92, -223.9, 38.34), isOpened = false, isBusy = false },
    { coords = vector3(-627.86, -224.97, 38.41), isOpened = false, isBusy = false },
    { coords = vector3(-628.07, -226.62, 38.32), isOpened = false, isBusy = false },
}

Config.RequiredItems = {
    [`weapon_assaultrifle`] = {
        ['timeOut'] = 10000
    },
    [`weapon_carbinerifle`] = {
        ['timeOut'] = 10000
    },
    [`weapon_pumpshotgun`] = {
        ['timeOut'] = 10000
    },
    [`weapon_sawnoffshotgun`] = {
        ['timeOut'] = 10000
    },
    [`weapon_compactrifle`] = {
        ['timeOut'] = 10000
    },
    [`weapon_microsmg`] = {
        ['timeOut'] = 10000
    },
    [`weapon_autoshotgun`] = {
        ['timeOut'] = 10000
    },
    [`weapon_pistol`] = {
        ['timeOut'] = 10000
    },
    [`weapon_pistol_mk2`] = {
        ['timeOut'] = 10000
    },
    [`weapon_combatpistol`] = {
        ['timeOut'] = 10000
    },
    [`weapon_appistol`] = {
        ['timeOut'] = 10000
    },
    [`weapon_pistol50`] = {
        ['timeOut'] = 10000
    },
}

