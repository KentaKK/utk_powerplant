
local info = {stage = 0, style = nil, locked = false}
local blackoutstatus = false
local blackoutdur = 3000 -- Duration of blackout in seconds
local cooldown = 9900 -- duration for hitting powerplant again
local spawnedPeds, netIdTable = {}, {}
local blackout = false

RegisterServerEvent('utk:penz')
AddEventHandler('utk:penz', function()
	local xPlayer  = ESX.GetPlayerFromId(source)
	if Config.GiveMoney then
		xPlayer.addAccountMoney(Config.Account, Config.Money)
		TriggerClientEvent('utk:notify',source,Config.Lang['you_stole']..' $'..Config.Money)
	end
	if Config.GiveItems then
		for i=1,#Config.Items do
			local item = Config.Items[i]
			xPlayer.addInventoryItem(item.name, item.count)
			TriggerClientEvent('utk:notify',source,Config.Lang['you_stole']..item.count..' '..item.name)
		end
	end
	if Config.GiveWeapons then
		for i=1,#Config.Weapons do
			local wp = Config.Weapons[i]
			xPlayer.addInventoryItem(wp.weapon, 1)
			TriggerClientEvent('utk:notify',source,Config.Lang['you_stole']..wp.weapon)
		end
	end
end)

RegisterServerEvent("utk_pb:updateUTK")
RegisterServerEvent("utk_pb:removeItem")
RegisterServerEvent("utk_pb:lock")
RegisterServerEvent("utk_pb:handlePlayers")
RegisterServerEvent("utk_pb:blackout")
RegisterServerEvent("utk_pb:checkblackout")

ESX.RegisterServerCallback("utk_pb:GetData", function(source, cb)
    cb(info)
end)

ESX.RegisterServerCallback("utk_pb:checkItem", function(source, cb, itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemname)["count"]

    if item >= 1 then
        cb(true)
    else
        cb(false)
    end
end)

AddEventHandler("utk_pb:updateUTK", function(table)
    info = {stage = table.info.stage, style = table.info.style, locked = table.info.locked}
    TriggerClientEvent("utk_pb:upUTK", -1, table)
end)

AddEventHandler("utk_pb:removeItem", function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(item, 1)
end)

AddEventHandler("utk_pb:lock", function()
    local source = source
    local xPlayers = ESX.GetExtendedPlayers()

    for _, xPlayer in pairs(xPlayers) do
        if xPlayer.source ~= source then
            TriggerClientEvent("utk_pb:lock_c", xPlayer.source)
        end
    end
end)

AddEventHandler("utk_pb:checkblackout", function()
    if blackoutstatus == true then
        TriggerClientEvent("utk_pb:power", source, true)
    end
end)

AddEventHandler("utk_pb:blackout", function(status)
    blackoutstatus = true

    ExecuteCommand('blackout')
    Wait(200)
    TriggerEvent('vSync:requestSync')
    BlackoutTimer()
end)

function BlackoutTimer()
    local timer = blackoutdur
    repeat
        Wait(1000)
        timer = timer - 1
    until timer == 0
    blackoutstatus = false
    ExecuteCommand('blackout')
    Wait(200)
    TriggerEvent('vSync:requestSync')
    Cooldown()
end
function Cooldown()
    local timer = cooldown
    repeat
        Wait(1000)
        timer = timer - 1
    until timer == 0
    info = {stage = 0, style = nil}

    TriggerClientEvent("utk_pb:reset", -1)
end

RegisterServerEvent('utk:alertPolice')
AddEventHandler('utk:alertPolice', function(x, y, z)
    local xPlayers = ESX.GetExtendedPlayers()
        for _, xPlayer in pairs(xPlayers) do
            if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' then
                TriggerClientEvent('utk:policeAlert', xPlayer.source, x, y, z)
            end
        end
end)

ESX.RegisterCommand("utkped", 'admin', function(xPlayer, args, showError)
    UTK.DeletePeds()
end, false)


RegisterServerEvent('UTK:spawn', function()
    UTK.CreatePeds()
end)

RegisterServerEvent('UTK:server:deletenpc', function()
    UTK.DeletePeds()
end)

UTK = {
    CreatePeds = function()
        for i = 1, #Peds do
            local model = Peds[i].Model
            local coords = Peds[i].Position
            local weapons = Peds[i].Weapon
            spawnedPeds[i] = CreatePed(0, model, coords.x, coords.y, coords.z, coords.w, true, false)
            GiveWeaponToPed(spawnedPeds[i], weapons, 250, false, true)
            netIdTable[i] = NetworkGetNetworkIdFromEntity(spawnedPeds[i])
            while not DoesEntityExist(spawnedPeds[i]) do Wait(50) end
        end

        Wait(1000)
        TriggerClientEvent('UTK:PedHandler', -1, netIdTable)
    end,
    DeletePeds = function()
        for i = 1, #spawnedPeds do
            if DoesEntityExist(spawnedPeds[i]) then
                DeleteEntity(spawnedPeds[i])
                spawnedPeds[i] = nil
            end
        end
    end
}
