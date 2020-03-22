local ESX = nil

local CachedPedState = false

TriggerEvent("esx:getSharedObject", function(response)
    ESX = response
end)

ESX.RegisterServerCallback("lazyarmory:pedExists", function(source, cb)
    if CachedPedState then
        cb(true)
    else
        CachedPedState = true

        cb(false)
    end
end)

RegisterServerEvent("lazyarmory:giveWeapon")
AddEventHandler("lazyarmory:giveWeapon", function(weapon)
    local player = ESX.GetPlayerFromId(source)

    if player then
        player.addWeapon(weapon, Config.ReceiveAmmo)

        TriggerClientEvent("esx:showNotification", source, "You just received 1x " .. ESX.GetWeaponLabel(weapon) .. " with " .. Config.ReceiveAmmo .. "x ammo.")
    end
end)