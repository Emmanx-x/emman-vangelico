# Emman Project Customize Vangelico Robbery

For all support questions, ask in our [Discord](https://discord.gg/qBUx3y8v8u) support chat. Do not create issues if you need help. Issues are for bug reporting and new features only.

## Dependencies

- [QBCore](https://github.com/qbcore-framework/qb-core)
- [ps-dispatch](https://github.com/Project-Sloth/ps-dispatch)
- [oxmysql](https://github.com/overextended/oxmysql)
- [ox_lib](https://github.com/overextended/ox_lib)
- [qb-doorlock](https://github.com/qbcore-framework/qb-doorlock)

# Installation
* Download ZIP
* Drag and drop resource into your server files, make sure to remove -main in the folder name

* Add this into your qb-doorlock config
```lua
Config.DoorList['emman-vangedoor'] = {
    objYaw = 36.000022888184,
    objName = 1335309163,
    distance = 2,
    locked = true,
    fixText = false,
    doorType = 'door',
    authorizedJobs = { ['police'] = 0 },
    doorRate = 1.0,
    objCoords = vec3(-629.133850, -230.151703, 38.206585),
    doorLabel = 'emman-door',
}
```
* Add the item to your shared.lua > items.lua 
```lua
["flashdrive"] = {
        ["name"] = "flashdrive",
        ["label"] = "USB Device",
        ["weight"] = 10,
        ["type"] = "item",
        ["image"] = "usb.png",
        ["unique"] = false,
        ['useable'] = true,
        ["shouldClose"] = true,
        ["combinable"] = nil,
        ["description"] = "Good To Store Data on"
    },
```

* Support >>> https://discord.gg/qBUx3y8v8u <<<
