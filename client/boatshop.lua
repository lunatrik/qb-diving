local ClosestBerth = 1
local BerthLocation = ""
local BoatsSpawned = false
local ModelLoaded = true
local SpawnedBoats = {}
local Buying = false

-- Berth's Boatshop Loop

Citizen.CreateThread(function()
    while true do
        local pos = GetEntityCoords(PlayerPedId(), true)
        for loc, _ in pairs(QBBoatshop.Locations) do
            for localization, _ in pairs(QBBoatshop.Locations[loc]) do
                local BerthDist = #(pos -
                                      vector3(
                                          QBBoatshop.Locations[loc][localization]["coords"]["boat"]["x"],
                                          QBBoatshop.Locations[loc][localization]["coords"]["boat"]["y"],
                                          QBBoatshop.Locations[loc][localization]["coords"]["boat"]["z"]))

                if BerthDist < 100 then
                    SetClosestBerthBoat(loc)
                    if not BoatsSpawned then
                        SpawnBerthBoats(loc, QBBoatshop.Locations[loc][localization])
                    end
                elseif BerthDist > 110 then
                    if BoatsSpawned then BoatsSpawned = false end
                end
            end
        end

        Citizen.Wait(1000)
    end
end)

function SpawnBerthBoats(loc, localization)

    if SpawnedBoats[loc] ~= nil then
        QBCore.Functions.DeleteVehicle(SpawnedBoats[loc])
    end
    local model = GetHashKey(localization["boatModel"])
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end

    local veh = CreateVehicle(model, localization["coords"]["boat"]["x"],
                              localization["coords"]["boat"]["y"],
                              localization["coords"]["boat"]["z"], false, false)

    SetModelAsNoLongerNeeded(model)
    SetVehicleOnGroundProperly(veh)
    SetEntityInvincible(veh, true)
    SetEntityHeading(veh, localization["coords"]["boat"]["w"])
    SetVehicleDoorsLocked(veh, 3)

    FreezeEntityPosition(veh, true)
    SpawnedBoats[loc] = veh

    BoatsSpawned = true
end

function SetClosestBerthBoat(localization)
    local pos = GetEntityCoords(PlayerPedId(), true)
    local current = nil
    local dist = nil
    
    for id, veh in pairs(QBBoatshop.Locations[localization]) do
        if current ~= nil then
            if #(pos -
                vector3(
                    QBBoatshop.Locations[localization][id]["coords"]["buy"]["x"],
                    QBBoatshop.Locations[localization][id]["coords"]["buy"]["y"],
                    QBBoatshop.Locations[localization][id]["coords"]["buy"]["z"])) <
                dist then
                current = id
                dist = #(pos -
                           vector3(
                               QBBoatshop.Locations[localization][id]["coords"]["buy"]["x"],
                               QBBoatshop.Locations[localization][id]["coords"]["buy"]["y"],
                               QBBoatshop.Locations[localization][id]["coords"]["buy"]["z"]))
            end
        else
            dist = #(pos -
                       vector3(
                           QBBoatshop.Locations[localization][id]["coords"]["buy"]["x"],
                           QBBoatshop.Locations[localization][id]["coords"]["buy"]["y"],
                           QBBoatshop.Locations[localization][id]["coords"]["buy"]["z"]))
            current = id
        end
        if current ~= ClosestBerth or BerthLocation ~= localization then 
            ClosestBerth = current
            BerthLocation = localization
         end
    end

end

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local inRange = false
        if BerthLocation ~= nil then
            local coordsBoat = #(vector3(
                                     QBBoatshop.Locations[BerthLocation][ClosestBerth]["coords"]["boat"]["x"],
                                     QBBoatshop.Locations[BerthLocation][ClosestBerth]["coords"]["boat"]["y"],
                                     QBBoatshop.Locations[BerthLocation][ClosestBerth]["coords"]["boat"]["z"]))
      
        local distance
        if #(pos) > coordsBoat then
            distance = #(pos) - coordsBoat
        else
            distance = coordsBoat - #(pos)
        end

        if distance < 15 then
            local BuyLocation = {
                x = QBBoatshop.Locations[BerthLocation][ClosestBerth]["coords"]["buy"]["x"],
                y = QBBoatshop.Locations[BerthLocation][ClosestBerth]["coords"]["buy"]["y"],
                z = QBBoatshop.Locations[BerthLocation][ClosestBerth]["coords"]["buy"]["z"]
            }

            DrawMarker(2, BuyLocation.x, BuyLocation.y, BuyLocation.z, 0.0, 0.0,
                       0.0, 0.0, 0.0, 0.0, 0.3, 0.5, 0.15, 255, 55, 15, 255,
                       false, false, false, true, false, false, false)
            local BuyDistance = #(pos -
                                    vector3(BuyLocation.x, BuyLocation.y,
                                            BuyLocation.z))

            if BuyDistance < 2 then
                local currentBoat =
                    QBBoatshop.Locations[BerthLocation][ClosestBerth]["boatModel"]

                DrawMarker(2,
                           QBBoatshop.Locations[BerthLocation][ClosestBerth]["coords"]["boat"]["x"],
                           QBBoatshop.Locations[BerthLocation][ClosestBerth]["coords"]["boat"]["y"],
                           QBBoatshop.Locations[BerthLocation][ClosestBerth]["coords"]["boat"]["z"] +
                               1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.5,
                           -0.30, 15, 255, 55, 255, false, false, false, true,
                           false, false, false)

                if not Buying then
                    DrawText3D(BuyLocation.x, BuyLocation.y,
                               BuyLocation.z + 0.3,
                               QBCore.Shared
                                   ._U(Locales,
                                       'client_boatshop_Thread_Drawing_1') ..
                                   QBBoatshop.ShopBoats[currentBoat]["label"] ..
                                   QBCore.Shared
                                       ._U(Locales,
                                           'client_boatshop_Thread_Drawing_1_2') ..
                                   QBBoatshop.ShopBoats[currentBoat]["price"])
                    if IsControlJustPressed(0, 38) then
                        Buying = true
                    end
                else
                    DrawText3D(BuyLocation.x, BuyLocation.y,
                               BuyLocation.z + 0.3,
                               QBCore.Shared
                                   ._U(Locales,
                                       'client_boatshop_Thread_Drawing_2') ..
                                   QBBoatshop.ShopBoats[currentBoat]["price"] ..
                                   QBCore.Shared
                                       ._U(Locales,
                                           'client_boatshop_Thread_Drawing_2_2'))
                    if IsControlJustPressed(0, 161) or
                        IsDisabledControlJustReleased(0, 161) then
                        TriggerServerEvent('qb-diving:server:BuyBoat',
                                           QBBoatshop.Locations[BerthLocation][ClosestBerth]["boatModel"],
                                           ClosestBerth, BerthLocation)
                        Buying = false
                    elseif IsControlJustPressed(0, 162) or
                        IsDisabledControlJustReleased(0, 162) then
                        Buying = false
                    end
                end
            elseif BuyDistance > 2.5 then
                if Buying then Buying = false end
            end
        end
        
        
         
    end
        Citizen.Wait(3)
    end
end)

RegisterNetEvent('qb-diving:client:BuyBoat')
AddEventHandler('qb-diving:client:BuyBoat', function(boatModel, plate, loc)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    QBCore.Functions.SpawnVehicle(boatModel, function(veh)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        exports['LegacyFuel']:SetFuel(veh, 100)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, QBBoatshop.SpawnVehicle[loc].w)
        TriggerEvent("vehiclekeys:client:SetOwner",
                     GetVehicleNumberPlateText(veh))
    end, QBBoatshop.SpawnVehicle[loc], false)
    SetTimeout(1000, function() DoScreenFadeIn(250) end)
end)

Citizen.CreateThread(function()
    for loc, _ in pairs(QBBoatshop.Locations) do
        BoatShop = AddBlipForCoord(
                       QBBoatshop.Locations[loc][1]["coords"]["boat"]["x"],
                       QBBoatshop.Locations[loc][1]["coords"]["boat"]["y"],
                       QBBoatshop.Locations[loc][1]["coords"]["boat"]["z"])

        SetBlipSprite(BoatShop, 410)
        SetBlipDisplay(BoatShop, 4)
        SetBlipScale(BoatShop, 0.8)
        SetBlipAsShortRange(BoatShop, true)
        SetBlipColour(BoatShop, 3)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("LSYMC Haven")
        EndTextCommandSetBlipName(BoatShop)
    end
end)
