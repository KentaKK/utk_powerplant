local Program = 0
local scaleform = nil
local lives = 5
local ClickReturn
local SorF = false
local Hacking = false
local UsingComputer = false
local DrawText3D = DrawText3D
local DrawMarker = DrawMarker
local RouletteWords = {
    "FASZVAGY",
    "TEKOCSOG",
    "NEMAGECI",
    "TEKURVAA",
    "GENYOOOO",
    "KENTAKEN",
    "KOBAGECI"
}
local UT = {}

RegisterNetEvent('UTK:PedHandler', function(netIdTable)
    for i = 1, #netIdTable do
        UT:LoadNpc(i, netIdTable[i])
    end
end)

function UT:LoadNpc(index, netID)
  CreateThread(function()
        SetPedRelationshipGroupHash(PlayerPedId(), `PLAYER`)
        while not NetworkDoesEntityExistWithNetworkId(netID) do
            Wait(200)
        end
        local npc = NetworkGetEntityFromNetworkId(netID)
        SetPedRandomComponentVariation(npc, 1)
        SetPedRandomProps(npc)
		SetPedArmour(npc, 200)
		SetPedAsEnemy(npc, true)
        SetPedConfigFlag(npc, 13, true)
        SetPedNeverLeavesGroup(npc, true)
		TaskCombatPed(npc, PlayerPedId(), 0, 16)
		SetPedAccuracy(npc, 100)
        SetPedHighlyPerceptive(npc, true)
        SetPedAccuracy(npc, 90)
        SetPedAlertness(npc, 3)
		SetPedDropsWeaponsWhenDead(npc, false)
        SetEntityAsMissionEntity(npc, true, true)
        SetPedRelationshipGroupHash(npc, `SECURITY_GUARD`)
		SetRelationshipBetweenGroups(0, `SECURITY_GUARD`, `SECURITY_GUARD`)
		SetRelationshipBetweenGroups(0, `PLAYER`, `PLAYER`)
		SetRelationshipBetweenGroups(5, `SECURITY_GUARD`, `PLAYER`)
		SetRelationshipBetweenGroups(5, `PLAYER`, `SECURITY_GUARD`)
  end)
end

local function police(x, y, z)
    CreateThread(function()
        local blip = AddBlipForCoord(x,y,z)
        SetBlipSprite(blip, 161)
        SetBlipColour(blip,1)
        SetBlipDisplay(blip, 10)
        ESX.ShowAdvancedNotification('Riasztás', '', '~r~Betörtek az erömü területére~w~', "CHAR_CALL911", 1)
        Wait(30000)
        ESX.ShowAdvancedNotification('Riasztás', '', '~r~Betörtek az erömü területére~w~', "CHAR_CALL911", 1)
        Wait(60000)
        RemoveBlip(blip)
    end)
end

RegisterNetEvent("utk:policeAlert")
AddEventHandler("utk:policeAlert", function(x, y, z)
    police(x, y, z)
end)

UTK = {
    guards = 1972614767,
    police = 2046537925,
    others = 1403091332,
    hackdone = false,
    hacksuccess = false,
    hackfail = false,
    hackres = false,
    showtime = 60,
    currenthack,
    planted1,
    planted2,
    planted3,
    planted4,
    planted5,
    planted6,
    hacked1,
    hacked2,
    hacked3,
    hacked4,
    hacked5,
    hacked6,

    info = {},
    --[[prison = {
        planted1,
        planted2,
        planted3,
        planted4,
        planted6,
        planted7,
        planted8,
        planted9,
        planted10,
        planted11,
        planted12,
    },]]
    locations ={
        loud = {
            start = {x=2655.91, y=1641.92, z=24.59},
            bomb1 = {x=2809.77, y=1547.20, z=24.53},
            bomb2 = {x=2800.69, y=1513.80, z=24.53},
            bomb3 = {x=2792.19, y=1482.00, z=24.53},
            bomb4 = {x=2771.49, y=1548.19, z=24.50},
            bomb5 = {x=2764.38, y=1521.63, z=24.50},
            bomb6 = {x=2750.77, y=1470.91, z=24.50}
        },
        silent = {
            start = {x=2830.83, y=1673.68, z=24.66, h=267.51},
            hack1 = {x=2864.92, y=1509.36, z=23.50, h=168.81},
            hack2 = {x=2768.95, y=1392.27, z=23.50, h=270.13},
            hack3 = {x=2716.51, y=1463.28, z=23.50, h=343.34},
            hack4 = {x=2670.41, y=1625.46, z=23.50, h=87.95},
            hack5 = {x=2722.81, y=1509.28, z=43.15, h=256.79},
            hack6 = {x=2714.67, y=1479.15, z=43.15, h=256.79}
        },
        --[[prison = {
            bomb1 = {x=1772.07, y=2509.74, z=55.14, h=126.06},
            bomb2 = {x=1688.72, y=2445.00, z=55.16, h=87.43},
            bomb3 = {x=1683.36, y=2450.05, z=55.16, h=86.68},
            bomb4 = {x=1687.31, y=2462.92, z=55.16, h=89.49},
            bomb5 = {x=1638.93, y=2476.70, z=55.19, h=42.40},
            bomb6 = {x=1621.12, y=2463.05, z=55.19, h=49.71},
            bomb7 = {x=1606.65, y=2475.19, z=55.19, h=55.93},
            bomb8 = {x=1605.84, y=2484.23, z=55.19, h=142.23},
            bomb9 = {x=1596,00, y=2534.48, z=55.19, h=3.45},
            bomb10 = {x=1574.02, y=2557.91, z=55.19, h=2.07},
            bomb11 = {x=1579.02, y=2563.22, z=55.19, h=358.55},
            bomb12 = {x=1591.84, y=2559.49, z=55.19, h=6.10}
        }]]
    },
    texts = {
        blackout = "BLACKOUT!",
        loud = {
            start = "[~g~E~w~] ~r~HANGOS~w~ erömü robbantás",
            bomb = "[~g~E~w~] C4 felrakása a fö generátorra",
            backup = "[~g~E~w~] C4 felrakása a tartalék generátorra",
            time = "200 mp és sötétség!",
            planted = "C4 felhelyezve"
        },
        silent = {
            start = "[~g~E~w~] ~r~CSENDES~w~ erömü robbantás",
            hack = "[~g~E~w~] Rendszer feltörése",
            plant = "[~g~E~w~] C4 felhelyezése",
            time = "50 mp és sötétség!",
            caught = "megláttak!",
            hacked = "Rendszer feltörve"
        },
        --[[prison = {
            bomb = "[~g~E~w~] Plant C4 to power generator"
        }]]
    },
}

CreateThread(function()
    Wait(10000)
    UTK:GetStage()
end)

function UTK:GetStage(...)
    ESX.TriggerServerCallback("utk_pb:GetData", function(output)
        self.info = output
        return self:HandleInfo()
    end)
end
function UTK:HandleInfo(...)
    if not self.info.locked then
        if self.info.stage == 0 then
            CreateThread(function()
                while true do
                    local sleep = 2000
                    local player = PlayerPedId()
                    local pedcoords = GetEntityCoords(player)
                    local startloud = #(pedcoords - vector3(self.locations.loud.start.x, self.locations.loud.start.y, self.locations.loud.start.z))
                    local startsilent = #(pedcoords - vector3(self.locations.silent.start.x, self.locations.silent.start.y, self.locations.silent.start.z))

                    if startloud <= 15 then
                        sleep = 3
                        DrawText3D(self.locations.loud.start.x, self.locations.loud.start.y, self.locations.loud.start.z, self.texts.loud.start, 0.40)
                        DrawMarker(1, self.locations.loud.start.x, self.locations.loud.start.y, self.locations.loud.start.z - 1, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 236, 80, 80, 155, false, false, 2, false, 0, 0, 0)
                        if startloud <= 1.5 and IsControlJustReleased(0, 38) then
                            TriggerServerEvent('utk:alertPolice', pedcoords.x, pedcoords.y, pedcoords.z)
                            TriggerServerEvent("utk_pb:lock")
                            self.info.stage = 1
                            self.info.style = 1
                            return self:HandleInfo()
                        end
                    end
                    if startsilent <= 15 then
                        sleep = 3
                        DrawText3D(self.locations.silent.start.x, self.locations.silent.start.y, self.locations.silent.start.z, self.texts.silent.start, 0.40)
                        DrawMarker(1, self.locations.silent.start.x, self.locations.silent.start.y, self.locations.silent.start.z - 1, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 236, 80, 80, 155, false, false, 2, false, 0, 0, 0)
                        if startsilent <= 1.5 and IsControlJustReleased(0, 38) then
                            TriggerServerEvent('utk:alertPolice', pedcoords.x, pedcoords.y, pedcoords.z)
                            TriggerServerEvent("utk_pb:lock")
                            self.info.stage = 1
                            self.info.style = 2
                            self.currenthack = 0
                            return self:Hack()
                        end
                    end
                    Wait(sleep)
                end
            end)
        elseif self.info.stage == 1 then
            if self.info.style == 1 then
                TriggerServerEvent('UTK:spawn')
                CreateThread(function()
                    while true do
                        local sleep = 1000
                        local pedcoords = GetEntityCoords(PlayerPedId())

                        if not UTK.planted1 then
                            local bomb1 = #(pedcoords - vector3(self.locations.loud.bomb1.x, self.locations.loud.bomb1.y, self.locations.loud.bomb1.z))

                            if bomb1 <= 5 and not UTK.planted1 then
                                sleep = 1
                                DrawText3D(self.locations.loud.bomb1.x, self.locations.loud.bomb1.y, self.locations.loud.bomb1.z, self.texts.loud.backup, 0.40)
                                DrawMarker(1, self.locations.loud.bomb1.x, self.locations.loud.bomb1.y, self.locations.loud.bomb1.z - 1, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 236, 80, 80, 155, false, false, 2, false, 0, 0, 0)
                                if bomb1 <= 1.5 and IsControlJustReleased(0, 38) then
                                    ESX.TriggerServerCallback("utk_pb:checkItem", function(cb)
                                        if cb then
                                            UTK.planted1 = true
                                            self.currentplant = 1
                                            TriggerServerEvent("utk_pb:removeItem", "c4")
                                            self:PlantBomb()
                                        elseif not cb then
                                            exports['mythic_notify']:DoHudText("error", "Nincs nálad c4.")
                                        end
                                    end, "c4")
                                end
                            end
                        end
                        if not UTK.planted2 then
                            local bomb2 = #(pedcoords - vector3(self.locations.loud.bomb2.x, self.locations.loud.bomb2.y, self.locations.loud.bomb2.z))
                            if bomb2 <= 5 and not UTK.planted2 then
                                sleep = 1
                                DrawText3D(self.locations.loud.bomb2.x, self.locations.loud.bomb2.y, self.locations.loud.bomb2.z, self.texts.loud.backup, 0.40)
                                DrawMarker(1, self.locations.loud.bomb2.x, self.locations.loud.bomb2.y, self.locations.loud.bomb2.z - 1, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 236, 80, 80, 155, false, false, 2, false, 0, 0, 0)
                                if bomb2 <= 1.5 and IsControlJustReleased(0, 38) then
                                    ESX.TriggerServerCallback("utk_pb:checkItem", function(cb)
                                        if cb then
                                            UTK.planted2 = true
                                            self.currentplant = 2
                                            TriggerServerEvent("utk_pb:removeItem", "c4")
                                            self:PlantBomb()
                                        elseif not cb then
                                            exports['mythic_notify']:DoHudText("error", "Nincs nálad c4.")
                                        end
                                    end, "c4")
                                end
                            end
                        end
                        if not UTK.planted3 then
                            local bomb3 = #(pedcoords - vector3(self.locations.loud.bomb3.x, self.locations.loud.bomb3.y, self.locations.loud.bomb3.z))
                            if bomb3 <= 5 and not UTK.planted3 then
                                sleep = 1
                                DrawText3D(self.locations.loud.bomb3.x, self.locations.loud.bomb3.y, self.locations.loud.bomb3.z, self.texts.loud.backup, 0.40)
                                DrawMarker(1, self.locations.loud.bomb3.x, self.locations.loud.bomb3.y, self.locations.loud.bomb3.z - 1, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 236, 80, 80, 155, false, false, 2, false, 0, 0, 0)
                                if bomb3 <= 1.5 and IsControlJustReleased(0, 38) then
                                    ESX.TriggerServerCallback("utk_pb:checkItem", function(cb)
                                        if cb then
                                            UTK.planted3 = true
                                            self.currentplant = 3
                                            TriggerServerEvent("utk_pb:removeItem", "c4")
                                            self:PlantBomb()
                                        elseif not cb then
                                            exports['mythic_notify']:DoHudText("error", "Nincs nálad c4.")
                                        end
                                    end, "c4")
                                end
                            end
                        end
                        if not UTK.planted4 then
                            local bomb4 = #(pedcoords - vector3(self.locations.loud.bomb4.x, self.locations.loud.bomb4.y, self.locations.loud.bomb4.z))
                            if bomb4 <= 5 and not UTK.planted4 then
                                sleep = 1
                                DrawText3D(self.locations.loud.bomb4.x, self.locations.loud.bomb4.y, self.locations.loud.bomb4.z, self.texts.loud.bomb, 0.40)
                                DrawMarker(1, self.locations.loud.bomb4.x, self.locations.loud.bomb4.y, self.locations.loud.bomb4.z - 1, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 236, 80, 80, 155, false, false, 2, false, 0, 0, 0)
                                if bomb4 <= 1.5 and IsControlJustReleased(0, 38) then
                                    ESX.TriggerServerCallback("utk_pb:checkItem", function(cb)
                                        if cb then
                                            UTK.planted4 = true
                                            self.currentplant = 4
                                            TriggerServerEvent("utk_pb:removeItem", "c4")
                                            self:PlantBomb()
                                        elseif not cb then
                                            exports['mythic_notify']:DoHudText("error", "Nincs nálad c4.")
                                        end
                                    end, "c4")
                                end
                            end
                        end
                        if not UTK.planted5 then
                            local bomb5 = #(pedcoords - vector3(self.locations.loud.bomb5.x, self.locations.loud.bomb5.y, self.locations.loud.bomb5.z))
                            if bomb5 <= 5 and not UTK.planted5 then
                                sleep = 1
                                DrawText3D(self.locations.loud.bomb5.x, self.locations.loud.bomb5.y, self.locations.loud.bomb5.z, self.texts.loud.bomb, 0.40)
                                DrawMarker(1, self.locations.loud.bomb5.x, self.locations.loud.bomb5.y, self.locations.loud.bomb5.z - 1, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 236, 80, 80, 155, false, false, 2, false, 0, 0, 0)
                                if bomb5 <= 1.5 and IsControlJustReleased(0, 38) then
                                    ESX.TriggerServerCallback("utk_pb:checkItem", function(cb)
                                        if cb then
                                            UTK.planted5 = true
                                            self.currentplant = 5
                                            TriggerServerEvent("utk_pb:removeItem", "c4")
                                            self:PlantBomb()
                                        elseif not cb then
                                            exports['mythic_notify']:DoHudText("error", "Nincs nálad c4.")
                                        end
                                    end, "c4")
                                end
                            end
                        end
                        if not UTK.planted6 then
                            local bomb6 = #(pedcoords - vector3(self.locations.loud.bomb6.x, self.locations.loud.bomb6.y, self.locations.loud.bomb6.z))
                            if bomb6 <= 5 and not UTK.planted6 then
                                sleep = 1
                                DrawText3D(self.locations.loud.bomb6.x, self.locations.loud.bomb6.y, self.locations.loud.bomb6.z, self.texts.loud.bomb, 0.40)
                                DrawMarker(1, self.locations.loud.bomb6.x, self.locations.loud.bomb6.y, self.locations.loud.bomb6.z - 1, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 236, 80, 80, 155, false, false, 2, false, 0, 0, 0)
                                if bomb6 <= 1.5 and IsControlJustReleased(0, 38) then
                                    ESX.TriggerServerCallback("utk_pb:checkItem", function(cb)
                                        if cb then
                                            UTK.planted6 = true
                                            self.currentplant = 6
                                            TriggerServerEvent("utk_pb:removeItem", "c4")
                                            self:PlantBomb()
                                        elseif not cb then
                                            exports['mythic_notify']:DoHudText("error", "Nincs nálad c4.")
                                        end
                                    end, "c4")
                                end
                            end
                        end
                        if UTK.planted1 and UTK.planted2 and UTK.planted3 and UTK.planted4 and UTK.planted5 and UTK.planted6 then
                            self.info.stage = 2
                            return self:HandleInfo()
                        end
                        Wait(sleep)
                    end
                end)
            elseif self.info.style == 2 then
                CreateThread(function()
                    while true do
                        local sleep = 1000
                        local pedcoords = GetEntityCoords(PlayerPedId())
                        if not UTK.hacked1 then
                            local hack1 = #(pedcoords - vector3(self.locations.silent.hack1.x, self.locations.silent.hack1.y, self.locations.silent.hack1.z))
                            if hack1 <= 15 and not UTK.hacked1 then
                                sleep = 1
                                DrawText3D(self.locations.silent.hack1.x, self.locations.silent.hack1.y, self.locations.silent.hack1.z+1, self.texts.silent.hack, 0.40)
                                DrawMarker(1, self.locations.silent.hack1.x, self.locations.silent.hack1.y, self.locations.silent.hack1.z , 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 236, 80, 80, 155, false, false, 2, false, 0, 0, 0)
                                if hack1 <= 1.5 and IsControlJustReleased(0, 38) then
                                    ESX.TriggerServerCallback("utk_pb:checkItem", function(cb)
                                        if cb then
                                            self.currenthack = 1
                                            self:Hack()
                                        elseif not cb then
                                            exports['mythic_notify']:DoHudText("error", "Nincs nálad laptop.")
                                        end
                                    end, "laptop_h")
                                    Wait(40000)
                                end
                            end
                        end
                        if not UTK.hacked2 then
                            local hack2 = #(pedcoords - vector3(self.locations.silent.hack2.x, self.locations.silent.hack2.y, self.locations.silent.hack2.z))

                            if hack2 <= 15 and not UTK.hacked2 then
                                sleep = 1
                                DrawText3D(self.locations.silent.hack2.x, self.locations.silent.hack2.y, self.locations.silent.hack2.z+1, self.texts.silent.hack, 0.40)
                                DrawMarker(1, self.locations.silent.hack2.x, self.locations.silent.hack2.y, self.locations.silent.hack2.z , 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 236, 80, 80, 155, false, false, 2, false, 0, 0, 0)
                                if hack2 <= 1.5 and  IsControlJustReleased(0, 38) then
                                    ESX.TriggerServerCallback("utk_pb:checkItem", function(cb)
                                        if cb then
                                            self.currenthack = 2
                                            self:Hack()
                                        elseif not cb then
                                            exports['mythic_notify']:DoHudText("error", "Nincs nálad laptop.")
                                        end
                                    end, "laptop_h")
                                    Wait(40000)
                                end
                            end
                        end
                        if not UTK.hacked3 then
                            local hack3 = #(pedcoords - vector3(self.locations.silent.hack3.x, self.locations.silent.hack3.y, self.locations.silent.hack3.z))
                            if hack3 <= 15 and not UTK.hacked3 then
                                sleep = 1
                                DrawText3D(self.locations.silent.hack3.x, self.locations.silent.hack3.y, self.locations.silent.hack3.z+1, self.texts.silent.hack, 0.40)
                                DrawMarker(1, self.locations.silent.hack3.x, self.locations.silent.hack3.y, self.locations.silent.hack3.z , 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 236, 80, 80, 155, false, false, 2, false, 0, 0, 0)
                                if hack3 <= 1.5 and IsControlJustReleased(0, 38) then
                                    ESX.TriggerServerCallback("utk_pb:checkItem", function(cb)
                                        if cb then
                                            self.currenthack = 3
                                            self:Hack()
                                        elseif not cb then
                                            exports['mythic_notify']:DoHudText("error", "Nincs nálad laptop.")
                                        end
                                    end, "laptop_h")
                                    Wait(40000)
                                end
                            end
                        end
                        if not UTK.hacked4 then
                            local hack4 = #(pedcoords - vector3(self.locations.silent.hack4.x, self.locations.silent.hack4.y, self.locations.silent.hack4.z))
                            if hack4 <= 15 and not UTK.hacked4 then
                                sleep = 1
                                DrawText3D(self.locations.silent.hack4.x, self.locations.silent.hack4.y, self.locations.silent.hack4.z+1, self.texts.silent.hack, 0.40)
                                DrawMarker(1, self.locations.silent.hack4.x, self.locations.silent.hack4.y, self.locations.silent.hack4.z , 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 236, 80, 80, 155, false, false, 2, false, 0, 0, 0)
                                if hack4 <= 1.5 and IsControlJustReleased(0, 38) then
                                    ESX.TriggerServerCallback("utk_pb:checkItem", function(cb)
                                        if cb then
                                            self.currenthack = 4
                                            self:Hack()
                                        elseif not cb then
                                            exports['mythic_notify']:DoHudText("error", "Nincs nálad laptop.")
                                        end
                                    end, "laptop_h")
                                    Wait(40000)
                                end
                            end
                        end
                        if not UTK.hacked5 then
                            local hack5 = #(pedcoords - vector3(self.locations.silent.hack5.x, self.locations.silent.hack5.y, self.locations.silent.hack5.z))
                            if hack5 <= 15 and not UTK.hacked5 then
                                sleep = 1
                                DrawText3D(self.locations.silent.hack5.x, self.locations.silent.hack5.y, self.locations.silent.hack5.z+1, self.texts.silent.hack, 0.40)
                                DrawMarker(1, self.locations.silent.hack5.x, self.locations.silent.hack5.y, self.locations.silent.hack5.z , 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 236, 80, 80, 155, false, false, 2, false, 0, 0, 0)
                                if hack5 <= 1.5 and IsControlJustReleased(0, 38) then
                                    ESX.TriggerServerCallback("utk_pb:checkItem", function(cb)
                                        if cb then
                                            self.currenthack = 5
                                            self:Hack()
                                        elseif not cb then
                                            exports['mythic_notify']:DoHudText("error", "Nincs nálad laptop.")
                                        end
                                    end, "laptop_h")
                                    Wait(40000)
                                end
                            end
                        end
                        if not UTK.hacked6 then
                            local hack6 = #(pedcoords - vector3(self.locations.silent.hack6.x, self.locations.silent.hack6.y, self.locations.silent.hack6.z))
                            if hack6 <= 15 and not UTK.hacked6 then
                                sleep = 1
                                DrawText3D(self.locations.silent.hack6.x, self.locations.silent.hack6.y, self.locations.silent.hack6.z+1, self.texts.silent.hack, 0.40)
                                DrawMarker(1, self.locations.silent.hack6.x, self.locations.silent.hack6.y, self.locations.silent.hack6.z , 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 236, 80, 80, 155, false, false, 2, false, 0, 0, 0)
                                if hack6 <= 1.5 and IsControlJustReleased(0, 38) then
                                    ESX.TriggerServerCallback("utk_pb:checkItem", function(cb)
                                        if cb then
                                            self.currenthack = 6
                                            self:Hack()
                                        elseif not cb then
                                            exports['mythic_notify']:DoHudText("error", "Nincs nálad laptop.")
                                        end
                                    end, "laptop_h")
                                    Wait(40000)
                                end
                            end
                        end
                        if UTK.hacked1 and UTK.hacked2 and UTK.hacked3 and UTK.hacked4 and UTK.hacked5 and UTK.hacked6 then
                            self.info.stage = 2
                            return self:HandleInfo()
                        end
                        Wait(sleep)
                    end
                end)
            end
        elseif self.info.stage == 2 then
            if self.info.style == 1 then
                UTK.showtime = 60
                self.info.stage = 3
                self.info.locked = true
                self:Blackout()
                TriggerServerEvent("utk_pb:updateUTK", self)
                return
            elseif self.info.style == 2 then
                UTK.showtime = 60
                self.info.stage = 3
                self.info.locked = true
                self:Blackout()
                TriggerServerEvent("utk_pb:updateUTK", self)
                return
            end
        end
    end
end

function UTK:PlantBomb(...)
    if self.currentplant == 1 then
        loc = self.locations.loud.bomb1
        heading = 71.85
    elseif self.currentplant == 2 then
        loc = self.locations.loud.bomb2
        heading = 71.85
    elseif self.currentplant == 3 then
        loc = self.locations.loud.bomb3
        heading = 71.85
    elseif self.currentplant == 4 then
        loc = self.locations.loud.bomb4
        heading = 71.85
    elseif self.currentplant == 5 then
        loc = self.locations.loud.bomb5
        heading = 71.85
    elseif self.currentplant == 6 then
        loc = self.locations.loud.bomb6
        heading = 71.85
    elseif self.currentplant == "hack1" then
        loc = self.locations.silent.hack5
        loc.x = loc.x + 1.42
        loc.y = loc.y - 0.70
        loc.z = loc.z + 1
        heading = 254.35
    elseif self.currentplant == "hack2" then
        loc = self.locations.silent.hack6
        loc.x = loc.x + 1.42
        loc.y = loc.y - 0.70
        loc.z = loc.z + 1
        heading = 254.35
    elseif self.currentplant == 2.1 then
        loc.x = self.locations.prison.bomb1.x
        loc.y = self.locations.prison.bomb1.y
        loc.z = self.locations.prison.bomb1.z
        heading = self.locations.prison.bomb1.h
    elseif self.currentplant == 2.2 then
        loc.x = self.locations.prison.bomb2.x
        loc.y = self.locations.prison.bomb2.y
        loc.z = self.locations.prison.bomb2.z
        heading = self.locations.prison.bomb2.h
    elseif self.currentplant == 2.3 then
        loc.x = self.locations.prison.bomb3.x
        loc.y = self.locations.prison.bomb3.y
        loc.z = self.locations.prison.bomb3.z
        heading = self.locations.prison.bomb3.h
    elseif self.currentplant == 2.4 then
        loc.x = self.locations.prison.bomb4.x
        loc.y = self.locations.prison.bomb4.y
        loc.z = self.locations.prison.bomb4.z
        heading = self.locations.prison.bomb4.h
    elseif self.currentplant == 2.5 then
        loc.x = self.locations.prison.bomb5.x
        loc.y = self.locations.prison.bomb5.y
        loc.z = self.locations.prison.bomb5.z
        heading = self.locations.prison.bomb5.h
    elseif self.currentplant == 2.6 then
        loc.x = self.locations.prison.bomb6.x
        loc.y = self.locations.prison.bomb6.y
        loc.z = self.locations.prison.bomb6.z
        heading = self.locations.prison.bomb6.h
    elseif self.currentplant == 2.7 then
        loc.x = self.locations.prison.bomb7.x
        loc.y = self.locations.prison.bomb7.y
        loc.z = self.locations.prison.bomb7.z
        heading = self.locations.prison.bomb7.h
    elseif self.currentplant == 2.8 then
        loc.x = self.locations.prison.bomb8.x
        loc.y = self.locations.prison.bomb8.y
        loc.z = self.locations.prison.bomb8.z
        heading = self.locations.prison.bomb8.h
    elseif self.currentplant == 2.9 then
        loc.x = self.locations.prison.bomb9.x
        loc.y = self.locations.prison.bomb9.y
        loc.z = self.locations.prison.bomb9.z
        heading = self.locations.prison.bomb9.h
    elseif self.currentplant == 2.10 then
        loc.x = self.locations.prison.bomb10.x
        loc.y = self.locations.prison.bomb10.y
        loc.z = self.locations.prison.bomb10.z
        heading = self.locations.prison.bomb10.h
    elseif self.currentplant == 2.11 then
        loc.x = self.locations.prison.bomb11.x
        loc.y = self.locations.prison.bomb11.y
        loc.z = self.locations.prison.bomb11.z
        heading = self.locations.prison.bomb11.h
    elseif self.currentplant == 2.12 then
        loc.x = self.locations.prison.bomb12.x
        loc.y = self.locations.prison.bomb12.y
        loc.z = self.locations.prison.bomb12.z
        heading = self.locations.prison.bomb12.h
    end

    RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
    RequestModel(`hei_p_m_bag_var22_arm_s`)
    RequestModel(`prop_bomb_01`)
    while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") and not HasModelLoaded("hei_p_m_bag_var22_arm_s") and not HasModelLoaded("prop_bomb_01")do
        Wait(50)
    end
    local ped = PlayerPedId()

    SetEntityHeading(ped, heading)
    Wait(100)
    local rot = GetEntityRotation(ped)
    local bagscene = NetworkCreateSynchronisedScene(loc.x - 0.70, loc.y + 0.50, loc.z, rot.x, rot.y, rot.z, 2, false, false, 1065353216, 0, 1.3)
    local bag = CreateObject(`hei_p_m_bag_var22_arm_s`, loc.x, loc.y, loc.z,  true,  true, false)

    NetworkAddPedToSynchronisedScene(ped, bagscene, "anim@heists@ornate_bank@thermal_charge", "thermal_charge", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, bagscene, "anim@heists@ornate_bank@thermal_charge", "bag_thermal_charge", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    NetworkStartSynchronisedScene(bagscene)
    exports['progressBars']:startUI(4500, "Planting")
    Wait(1500)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local bomba = CreateObject(`prop_bomb_01`, x, y, z + 0.2,  true,  true, true)

    AttachEntityToEntity(bomba, ped, GetPedBoneIndex(ped, 28422), 0, 0, 0, 0, 0, 200.0, true, true, false, true, 1, true)
    Wait(3000)
    DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 45, 0, 0)
    DetachEntity(bomba, 1, 1)
    FreezeEntityPosition(bomba, true)
    NetworkStopSynchronisedScene(bagscene)
    exports['mythic_notify']:DoHudText("success", "C4 Felhelyezve")
    if self.currentplant == "hack1" then
        SmallExp(1)
    elseif self.currentplant == "hack2" then
        SmallExp(2)
    elseif self.currentplant == 2.1 then
        SmallExp(self.currentplant, vector3(self.locations.prison.bomb1.x, self.locations.prison.bomb1.y, self.locations.prison.bomb1.z))
    elseif self.currentplant == 2.2 then
        SmallExp(self.currentplant, vector3(self.locations.prison.bomb2.x, self.locations.prison.bomb2.y, self.locations.prison.bomb2.z))
    elseif self.currentplant == 2.3 then
        SmallExp(self.currentplant, vector3(self.locations.prison.bomb3.x, self.locations.prison.bomb3.y, self.locations.prison.bomb3.z))
    elseif self.currentplant == 2.4 then
        SmallExp(self.currentplant, vector3(self.locations.prison.bomb4.x, self.locations.prison.bomb4.y, self.locations.prison.bomb4.z))
    elseif self.currentplant == 2.5 then
        SmallExp(self.currentplant, vector3(self.locations.prison.bomb5.x, self.locations.prison.bomb5.y, self.locations.prison.bomb5.z))
    elseif self.currentplant == 2.6 then
        SmallExp(self.currentplant, vector3(self.locations.prison.bomb6.x, self.locations.prison.bomb6.y, self.locations.prison.bomb6.z))
    elseif self.currentplant == 2.7 then
        SmallExp(self.currentplant, vector3(self.locations.prison.bomb7.x, self.locations.prison.bomb7.y, self.locations.prison.bomb7.z))
    elseif self.currentplant == 2.8 then
        SmallExp(self.currentplant, vector3(self.locations.prison.bomb8.x, self.locations.prison.bomb8.y, self.locations.prison.bomb8.z))
    elseif self.currentplant == 2.9 then
        SmallExp(self.currentplant, vector3(self.locations.prison.bomb9.x, self.locations.prison.bomb9.y, self.locations.prison.bomb9.z))
    elseif self.currentplant == 2.10 then
        SmallExp(self.currentplant, vector3(self.locations.prison.bomb10.x, self.locations.prison.bomb10.y, self.locations.prison.bomb10.z))
    elseif self.currentplant == 2.11 then
        SmallExp(self.currentplant, vector3(self.locations.prison.bomb11.x, self.locations.prison.bomb11.y, self.locations.prison.bomb11.z))
    elseif self.currentplant == 2.12 then
        SmallExp(self.currentplant, vector3(self.locations.prison.bomb12.x, self.locations.prison.bomb12.y, self.locations.prison.bomb12.z))
    end
end

function UTK:Hack(...)
    UTK.hackdone = false
    UTK.phonedone = false
    UTK.phonefail = false
    local ped = PlayerPedId()
    local hea = GetEntityHeading(ped)
    local x, y, z = table.unpack(GetEntityCoords(ped))
    local targetRotation = GetEntityRotation(ped)
    TaskStartScenarioAtPosition(ped, "WORLD_HUMAN_STAND_MOBILE", x, y, z + 0.7, hea, 0, 0, 1)
    Wait(2000)
    TriggerEvent("mhacking:show")
    TriggerEvent("mhacking:start", 5, 30, PhoneHacking)
    while not UTK.phonedone do
        Wait(1)
    end
    ClearPedTasks(ped)
    Wait(2500)
    if not UTK.phonefail then
        local animDict = "anim@heists@ornate_bank@hack"

        RequestAnimDict(animDict)
        RequestModel(`hei_prop_hst_laptop`)
        RequestModel(`hei_p_m_bag_var22_arm_s`)
        RequestModel(`hei_prop_heist_card_hack_02`)
        while not HasAnimDictLoaded(animDict)
            or not HasModelLoaded(`hei_prop_hst_laptop`)
            or not HasModelLoaded(`hei_p_m_bag_var22_arm_s`)
            or not HasModelLoaded(`hei_prop_heist_card_hack_02`) do
            Wait(10)
        end
        local animPos2 = GetAnimInitialOffsetPosition(animDict, "hack_loop", x, y, z, targetRotation.x, targetRotation.y, targetRotation.z, 0, 2)
        local animPos3 = GetAnimInitialOffsetPosition(animDict, "hack_exit", x, y, z, targetRotation.x, targetRotation.y, targetRotation.z, 0, 2)
        local laptop = CreateObject(`hei_prop_hst_laptop`, x, y, z, 1, 1, 0)
        local bag = CreateObject(`hei_p_m_bag_var22_arm_s`, x, y, z, 1, 1, 0)

        local netScene2 = NetworkCreateSynchronisedScene(animPos2.x, animPos2.y, animPos2.z + 0.8, targetRotation.x, targetRotation.y, targetRotation.z + 0.8, 2, false, true, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, netScene2, animDict, "hack_loop", 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(bag, netScene2, animDict, "hack_loop_bag", 4.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(laptop, netScene2, animDict, "hack_loop_laptop", 4.0, -8.0, 1)

        local netScene3 = NetworkCreateSynchronisedScene(animPos3.x, animPos3.y, animPos3.z + 0.8, targetRotation.x, targetRotation.y, targetRotation.z + 0.8, 2, false, false, 1065353216, 0, 1.3)
        NetworkAddPedToSynchronisedScene(ped, netScene3, animDict, "hack_exit", 1.5, -4.0, 1, 16, 1148846080, 0)
        NetworkAddEntityToSynchronisedScene(bag, netScene3, animDict, "hack_exit_bag", 4.0, -8.0, 1)
        NetworkAddEntityToSynchronisedScene(laptop, netScene3, animDict, "hack_exit_laptop", 4.0, -8.0, 1)
        SetPedComponentVariation(ped, 5, 0, 0, 0)
        Wait(200)
        NetworkStartSynchronisedScene(netScene2)
        Wait(2500)
        Brute()
        while not UTK.hackdone do
            Wait(1)
        end
        Wait(1500)
        NetworkStartSynchronisedScene(netScene3)
        Wait(2000)
        NetworkStopSynchronisedScene(netScene3)
        DeleteObject(bag)
        DeleteObject(laptop)
        FreezeEntityPosition(ped, false)
        SetPedComponentVariation(ped, 5, 45, 0, 0)
        if not UTK.hackres then
            if self.currenthack == 0 then
                TriggerServerEvent('UTK:spawn')
                self:HandleInfo()
            elseif self.currenthack == 1 then
                UTK.hacked1 = true
            elseif self.currenthack == 2 then
                UTK.hacked2 = true
            elseif self.currenthack == 3 then
                UTK.hacked3 = true
            elseif self.currenthack == 4 then
                UTK.hacked4 = true
            elseif self.currenthack == 5 then
                UTK.hacked5 = true
            elseif self.currenthack == 6 then
                UTK.hacked6 = true
            end
        elseif UTK.hackres then
            self.locations = UTK.locations
            self:HandleInfo()
        end
    elseif UTK.phonefail then
        FreezeEntityPosition(ped, false)
    end
end

function UTK:Blackout(...)
    TriggerEvent("utk_pb:showtime", 1)
    repeat
        Wait(1000)
        UTK.showtime = UTK.showtime - 1
    until UTK.showtime == 0
    if self.info.style == 1 then
        local camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        SetCamCoord(camera, 2812.16, 1554.07, 26.72)
        SetCamRot(camera, 0, 0, 158.55, 2)
        RenderScriptCams(1, 0, 0, 1, 1)
        Wait(2000)
        AddExplosion(self.locations.loud.bomb3.x, self.locations.loud.bomb3.y, self.locations.loud.bomb3.z, 34, 20.0, true, false, 1.0)
        Wait(600)
        AddExplosion(self.locations.loud.bomb2.x, self.locations.loud.bomb2.y, self.locations.loud.bomb2.z, 34, 20.0, true, false, 1.0)
        Wait(600)
        AddExplosion(self.locations.loud.bomb1.x, self.locations.loud.bomb1.y, self.locations.loud.bomb1.z, 34, 20.0, true, false, 1.0)
        Wait(600)
        DestroyCam(camera, 0)
        local camera2 = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        SetCamCoord(camera2, 2748.44, 1468.96, 27.45)
        SetCamRot(camera2, 0, 0, 0, 2)
        RenderScriptCams(1, 0, 0, 1, 1)
        Wait(1000)
        AddExplosion(self.locations.loud.bomb4.x, self.locations.loud.bomb4.y, self.locations.loud.bomb4.z, 34, 20.0, true, false, 1.0)
        Wait(600)
        AddExplosion(self.locations.loud.bomb5.x, self.locations.loud.bomb5.y, self.locations.loud.bomb5.z, 34, 20.0, true, false, 1.0)
        Wait(600)
        AddExplosion(self.locations.loud.bomb6.x, self.locations.loud.bomb6.y, self.locations.loud.bomb6.z, 34, 20.0, true, false, 1.0)
        Wait(600)
        DestroyCam(camera2, 0)
        RenderScriptCams(0, 0, 1, 1, 1)
        SetFocusEntity(PlayerPedId())
    end
    TriggerServerEvent("utk_pb:blackout", true)
    exports['mythic_notify']:DoHudText("success", "SÖTÉTSÉG!")
    TriggerServerEvent("utk:penz")
end

function SmallExp(method, coords)
    UTK.mintime = 5
    TriggerEvent("utk_pb:showtime", 2)
    repeat
        Wait(1000)
        UTK.mintime = UTK.mintime - 1
    until UTK.mintime == 0
    if method == 1 then
        AddExplosion(2723.53, 1509.07, 44.149, 33, 1.0, true, false, 1.0)
    elseif method == 2 then
        AddExplosion(2715.39, 1478.94, 44.149, 33, 1.0, true, false, 1.0)
    elseif method == 2.1 then
        AddExplosion(coords.x, coords.y, coords.z, 33, 1.0, true, false, 1.0)
    elseif method == 2.2 then
        AddExplosion(coords.x, coords.y, coords.z, 33, 1.0, true, false, 1.0)
    elseif method == 2.3 then
        AddExplosion(coords.x, coords.y, coords.z, 33, 1.0, true, false, 1.0)
    elseif method == 2.4 then
        AddExplosion(coords.x, coords.y, coords.z, 33, 1.0, true, false, 1.0)
    elseif method == 2.5 then
        AddExplosion(coords.x, coords.y, coords.z, 33, 1.0, true, false, 1.0)
    elseif method == 2.6 then
        AddExplosion(coords.x, coords.y, coords.z, 33, 1.0, true, false, 1.0)
    elseif method == 2.7 then
        AddExplosion(coords.x, coords.y, coords.z, 33, 1.0, true, false, 1.0)
    elseif method == 2.8 then
        AddExplosion(coords.x, coords.y, coords.z, 33, 1.0, true, false, 1.0)
    elseif method == 2.9 then
        AddExplosion(coords.x, coords.y, coords.z, 33, 1.0, true, false, 1.0)
    elseif method == 2.10 then
        AddExplosion(coords.x, coords.y, coords.z, 33, 1.0, true, false, 1.0)
    elseif method == 2.11 then
        AddExplosion(coords.x, coords.y, coords.z, 33, 1.0, true, false, 1.0)
    elseif method == 2.12 then
        AddExplosion(coords.x, coords.y, coords.z, 33, 1.0, true, false, 1.0)
    end
end

RegisterNetEvent("utk_pb:reset")
RegisterNetEvent("utk_pb:upUTK")
RegisterNetEvent("utk_pb:lock_c")
RegisterNetEvent("utk_pb:showtime")

AddEventHandler("utk_pb:reset", function()
    UTK = UTKreset
    UTK:GetStage()
end)
AddEventHandler("utk_pb:lock_c", function()
    UTK.info.locked = true
    UTK:HandleInfo()
end)
AddEventHandler("utk_pb:upUTK", function(table) -- BURADA KALDIN
    UTK.info = table
    UTK:HandleInfo()
end)
AddEventHandler("utk_pb:showtime", function(method)
    if method == 1 then
        while UTK.showtime > 0 do
            Wait(1)
            ShowTimer(1)
        end
    elseif method == 2 then
        while UTK.mintime > 0 do
            Wait(1)
            ShowTimer(2)
        end
    end
end)
AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        SetArtificialLightsState(false)
    end
end)

-----------------

function DrawText3D(x, y, z, text, scale) local onScreen, _x, _y = World3dToScreen2d(x, y, z) local pX, pY, pZ = table.unpack(GetGameplayCamCoords()) SetTextScale(scale, scale) SetTextFont(4) SetTextProportional(1) SetTextEntry("STRING") SetTextCentre(true) SetTextColour(255, 255, 255, 215) AddTextComponentString(text) DrawText(_x, _y) local factor = (string.len(text)) / 700 DrawRect(_x, _y + 0.0150, 0.095 + factor, 0.03, 41, 11, 41, 100) end
function Brute()
    scaleform = Initialize("HACKING_PC")
    UsingComputer = true
end
function ScaleformLabel(label)
    BeginTextCommandScaleformString(label)
    EndTextCommandScaleformString()
end
function PhoneHacking(output, time)
    if output then
        TriggerEvent('mhacking:hide')
        UTK.phonedone = true
        UTK.phonefail = false
    else
        TriggerEvent('mhacking:hide')
        UTK.phonedone = true
        UTK.phonefail = true
    end
end
function ShowTimer(method)
    if method == 1 then
        SetTextFont(0)
        SetTextProportional(0)
        SetTextScale(0.42, 0.42)
        SetTextDropShadow()
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextEntry("STRING")
        AddTextComponentString("~r~"..UTK.showtime.."~w~")
        DrawText(0.682, 0.96)
    elseif method == 2 then
        SetTextFont(0)
        SetTextProportional(0)
        SetTextScale(0.42, 0.42)
        SetTextDropShadow()
        SetTextEdge(1, 0, 0, 0, 255)
        SetTextEntry("STRING")
        AddTextComponentString("~r~"..UTK.mintime.."~w~")
        DrawText(0.682, 0.96)
    end
end

CreateThread(function()
    function Initialize(scaleform)
        local scaleform = RequestScaleformMovieInteractive(scaleform)
        while not HasScaleformMovieLoaded(scaleform) do
            Wait(0)
        end
        local CAT = 'hack'
        local CurrentSlot = 0
        while HasAdditionalTextLoaded(CurrentSlot) and not HasThisAdditionalTextLoaded(CAT, CurrentSlot) do
            Wait(0)
            CurrentSlot = CurrentSlot + 1
        end

        if not HasThisAdditionalTextLoaded(CAT, CurrentSlot) then
            ClearAdditionalText(CurrentSlot, true)
            RequestAdditionalText(CAT, CurrentSlot)
            while not HasThisAdditionalTextLoaded(CAT, CurrentSlot) do
                Wait(0)
            end
        end
        PushScaleformMovieFunction(scaleform, "SET_LABELS")
        ScaleformLabel("H_ICON_1")
        ScaleformLabel("H_ICON_2")
        ScaleformLabel("H_ICON_3")
        ScaleformLabel("H_ICON_4")
        ScaleformLabel("H_ICON_5")
        ScaleformLabel("H_ICON_6")
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_BACKGROUND")
        PushScaleformMovieFunctionParameterInt(1)
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "ADD_PROGRAM")
        PushScaleformMovieFunctionParameterFloat(1.0)
        PushScaleformMovieFunctionParameterFloat(4.0)
        PushScaleformMovieFunctionParameterString("My Computer")
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "ADD_PROGRAM")
        PushScaleformMovieFunctionParameterFloat(1.0)
        PushScaleformMovieFunctionParameterFloat(4.0)
        PushScaleformMovieFunctionParameterString("My Computer")
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "ADD_PROGRAM")
        PushScaleformMovieFunctionParameterFloat(6.0)
        PushScaleformMovieFunctionParameterFloat(6.0)
        PushScaleformMovieFunctionParameterString("Power Off")
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_LIVES")
        PushScaleformMovieFunctionParameterInt(lives)
        PushScaleformMovieFunctionParameterInt(5)
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_LIVES")
        PushScaleformMovieFunctionParameterInt(lives)
        PushScaleformMovieFunctionParameterInt(5)
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(0)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(1)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(2)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(3)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(4)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(5)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(6)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_COLUMN_SPEED")
        PushScaleformMovieFunctionParameterInt(7)
        PushScaleformMovieFunctionParameterInt(math.random(150,255))
        PopScaleformMovieFunctionVoid()
        return scaleform
    end
    scaleform = Initialize("HACKING_PC")
    while true do
        local sleep = 1000
        if UsingComputer then
            sleep = 0
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
            PushScaleformMovieFunction(scaleform, "SET_CURSOR")
            PushScaleformMovieFunctionParameterFloat(GetControlNormal(0, 239))
            PushScaleformMovieFunctionParameterFloat(GetControlNormal(0, 240))
            PopScaleformMovieFunctionVoid()
            if IsDisabledControlJustPressed(0,24) and not SorF then
                PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT_SELECT")
                ClickReturn = PopScaleformMovieFunction()
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            elseif IsDisabledControlJustPressed(0, 25) and not Hacking and not SorF then
                PushScaleformMovieFunction(scaleform, "SET_INPUT_EVENT_BACK")
                PopScaleformMovieFunctionVoid()
                PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        local sleep = 1000
        if HasScaleformMovieLoaded(scaleform) and UsingComputer then
            sleep = 0
            UTK.DisableInput = true
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            if GetScaleformMovieFunctionReturnBool(ClickReturn) then
                Program = GetScaleformMovieFunctionReturnInt(ClickReturn)
                if Program == 83 and not Hacking then
                    lives = 5

                    PushScaleformMovieFunction(scaleform, "SET_LIVES")
                    PushScaleformMovieFunctionParameterInt(lives)
                    PushScaleformMovieFunctionParameterInt(5)
                    PopScaleformMovieFunctionVoid()

                    PushScaleformMovieFunction(scaleform, "OPEN_APP")
                    PushScaleformMovieFunctionParameterFloat(1.0)
                    PopScaleformMovieFunctionVoid()

                    PushScaleformMovieFunction(scaleform, "SET_ROULETTE_WORD")
                    PushScaleformMovieFunctionParameterString(RouletteWords[math.random(#RouletteWords)])
                    PopScaleformMovieFunctionVoid()

                    Hacking = true
                elseif Program == 82 and not Hacking then
                    PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)
                elseif Hacking and Program == 87 then
                    lives = lives - 1
                    PushScaleformMovieFunction(scaleform, "SET_LIVES")
                    PushScaleformMovieFunctionParameterInt(lives)
                    PushScaleformMovieFunctionParameterInt(5)
                    PopScaleformMovieFunctionVoid()
                    PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)
                elseif Hacking and Program == 92 then
                    PlaySoundFrontend(-1, "HACKING_CLICK_GOOD", "", false)
                elseif Hacking and Program == 86 then
                    SorF = true
                    PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
                    PushScaleformMovieFunction(scaleform, "SET_ROULETTE_OUTCOME")
                    PushScaleformMovieFunctionParameterBool(true)
                    ScaleformLabel("WINBRUTE")
                    PopScaleformMovieFunctionVoid()
                    Wait(0)
                    PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                    PopScaleformMovieFunctionVoid()
                    Hacking = false
                    SorF = false
                    SetScaleformMovieAsNoLongerNeeded(scaleform)
                    DisableControlAction(0, 24, false)
                    DisableControlAction(0, 25, false)
                    FreezeEntityPosition(PlayerPedId(), false)
                    if Method == 1 then
                        exports['mythic_notify']:DoHudText("success", _U("hacked"))
                    elseif Method == 2 then
                        exports['mythic_notify']:DoHudText("success", _U("hacked"))
                    end
                    UTK.hacksuccess = true
                    UsingComputer = false
                    UTK.hackdone = true
                    UTK.hackres = false
                elseif Program == 6 then
                    UsingComputer = false
                    UTK.hackres = true
                    UTK.hackdone = true
                    SetScaleformMovieAsNoLongerNeeded(scaleform)
                    DisableControlAction(0, 24, false)
                    DisableControlAction(0, 25, false)
                    FreezeEntityPosition(PlayerPedId(), false)
                end

                if Hacking then
                    sleep = 0
                    PushScaleformMovieFunction(scaleform, "SHOW_LIVES")
                    PushScaleformMovieFunctionParameterBool(true)
                    PopScaleformMovieFunctionVoid()
                    if lives <= 0 then
                        SorF = true
                        PlaySoundFrontend(-1, "HACKING_FAILURE", "", true)
                        PushScaleformMovieFunction(scaleform, "SET_ROULETTE_OUTCOME")
                        PushScaleformMovieFunctionParameterBool(false)
                        ScaleformLabel("LOSEBRUTE")
                        PopScaleformMovieFunctionVoid()
                        Wait(1000)
                        PushScaleformMovieFunction(scaleform, "CLOSE_APP")
                        PopScaleformMovieFunctionVoid()
                        UTK.hackfail = true
                        UTK.DisableInput = false
                        Hacking = false
                        SorF = false
                        UTK.info.stage = 0
                        UTK.info.style = nil
                        UTK:HandleInfo()
                        FreezeEntityPosition(PlayerPedId(), false)
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

UTKreset = {
    guards = 1972614767,
    police = 2046537925,
    others = 1403091332,
    hackdone = false,
    hacksuccess = false,
    hackfail = false,
    hackres = false,
    showtime,
    currenthack,
    planted1,
    planted2,
    planted3,
    planted4,
    planted5,
    planted6,
    hacked1,
    hacked2,
    hacked3,
    hacked4,
    hacked5,
    hacked6,

    info = {},
    --[[prison = {
        planted1,
        planted2,
        planted3,
        planted4,
        planted6,
        planted7,
        planted8,
        planted9,
        planted10,
        planted11,
        planted12,
    },]]
    locations ={
        loud = {
            start = {x=2655.91, y=1641.92, z=24.59},
            bomb1 = {x=2809.77, y=1547.20, z=24.53},
            bomb2 = {x=2800.69, y=1513.80, z=24.53},
            bomb3 = {x=2792.19, y=1482.00, z=24.53},
            bomb4 = {x=2771.49, y=1548.19, z=24.50},
            bomb5 = {x=2764.38, y=1521.63, z=24.50},
            bomb6 = {x=2750.77, y=1470.91, z=24.50}
        },
        silent = {
            start = {x=2830.83, y=1673.68, z=24.66, h=267.51},
            hack1 = {x=2864.92, y=1509.36, z=23.50, h=168.81},
            hack2 = {x=2768.95, y=1392.27, z=23.50, h=270.13},
            hack3 = {x=2716.51, y=1463.28, z=23.50, h=343.34},
            hack4 = {x=2670.41, y=1625.46, z=23.50, h=87.95},
            hack5 = {x=2722.81, y=1509.28, z=43.15, h=256.79},
            hack6 = {x=2714.67, y=1479.15, z=43.15, h=256.79}
        },
        --[[prison = {
            bomb1 = {x=1772.07, y=2509.74, z=55.14, h=126.06},
            bomb2 = {x=1688.72, y=2445.00, z=55.16, h=87.43},
            bomb3 = {x=1683.36, y=2450.05, z=55.16, h=86.68},
            bomb4 = {x=1687.31, y=2462.92, z=55.16, h=89.49},
            bomb5 = {x=1638.93, y=2476.70, z=55.19, h=42.40},
            bomb6 = {x=1621.12, y=2463.05, z=55.19, h=49.71},
            bomb7 = {x=1606.65, y=2475.19, z=55.19, h=55.93},
            bomb8 = {x=1605.84, y=2484.23, z=55.19, h=142.23},
            bomb9 = {x=1596,00, y=2534.48, z=55.19, h=3.45},
            bomb10 = {x=1574.02, y=2557.91, z=55.19, h=2.07},
            bomb11 = {x=1579.02, y=2563.22, z=55.19, h=358.55},
            bomb12 = {x=1591.84, y=2559.49, z=55.19, h=6.10}
        }]]
    },
    texts = {
        blackout = "BLACKOUT!",
        loud = {
            start = "[~g~E~w~] Start ~r~LOUD~w~ Power Plant hit",
            bomb = "[~g~E~w~] Plant C4 Explosives for main generator",
            backup = "[~g~E~w~] Plant C4 Explosives for backup generator",
            time = "200 seconds to blackout!",
            planted = "C4 planted"
        },
        silent = {
            start = "[~g~E~w~] Start ~r~SILENT~w~ Power Plant hit",
            hack = "[~g~E~w~] Start hacking",
            plant = "[~g~E~w~] Plant C4 charge",
            time = "50 seconds to blackout!",
            caught = "You have seen!",
            hacked = "Hack successful"
        },
        --[[prison = {
            bomb = "[~g~E~w~] Plant C4 to power generator"
        }]]
    },
}
