local CurrentDock = nil
local ClosestDock = nil
local PoliceBlip = nil

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    if PlayerJob.name == "police" then
        if PoliceBlip ~= nil then
            RemoveBlip(PoliceBlip)
        end
        PoliceBlip = AddBlipForCoord(QBBoatshop.PoliceBoat.x, QBBoatshop.PoliceBoat.y, QBBoatshop.PoliceBoat.z)
        SetBlipSprite(PoliceBlip, 410)
        SetBlipDisplay(PoliceBlip, 4)
        SetBlipScale(PoliceBlip, 0.8)
        SetBlipAsShortRange(PoliceBlip, true)
        SetBlipColour(PoliceBlip, 29)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(QBCore.Shared._U(Locales, 'client_garage_event_onJobUpdate_PoliceBoaths'))
        EndTextCommandSetBlipName(PoliceBlip)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
            local pos = GetEntityCoords(PlayerPedId())
            if PlayerJob.name == "police" then
                local dist = #(pos - vector3(QBBoatshop.PoliceBoat.x, QBBoatshop.PoliceBoat.y, QBBoatshop.PoliceBoat.z))
                if dist < 10 then
                    DrawMarker(2, QBBoatshop.PoliceBoat.x, QBBoatshop.PoliceBoat.y, QBBoatshop.PoliceBoat.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                    if #(pos - vector3(QBBoatshop.PoliceBoat.x, QBBoatshop.PoliceBoat.y, QBBoatshop.PoliceBoat.z)) < 1.5 then
                        QBCore.Functions.DrawText3D(QBBoatshop.PoliceBoat.x, QBBoatshop.PoliceBoat.y, QBBoatshop.PoliceBoat.z, QBCore.Shared._U(Locales, 'TakeBoath'))
                        if IsControlJustReleased(0, 38) then
                            local coords = QBBoatshop.PoliceBoatSpawn
                            QBCore.Functions.SpawnVehicle("predator", function(veh)
                                SetVehicleNumberPlateText(veh, "PBOA"..tostring(math.random(1000, 9999)))
                                SetEntityHeading(veh, coords.w)
                                exports['LegacyFuel']:SetFuel(veh, 100.0)
                                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                                SetVehicleEngineOn(veh, true, true)
                            end, coords, true)
                        end
                    end
                else
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(3000)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3)
        if isLoggedIn then
            local pos = GetEntityCoords(PlayerPedId())
            if PlayerJob.name == "police" then
                local dist = #(pos - vector3(QBBoatshop.PoliceBoat2.x, QBBoatshop.PoliceBoat2.y, QBBoatshop.PoliceBoat2.z))
                if dist < 10 then
                    DrawMarker(2, QBBoatshop.PoliceBoat2.x, QBBoatshop.PoliceBoat2.y, QBBoatshop.PoliceBoat2.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                    if #(pos - vector3(QBBoatshop.PoliceBoat2.x, QBBoatshop.PoliceBoat2.y, QBBoatshop.PoliceBoat2.z)) < 1.5 then
                        QBCore.Functions.DrawText3D(QBBoatshop.PoliceBoat2.x, QBBoatshop.PoliceBoat2.y, QBBoatshop.PoliceBoat2.z, QBCore.Shared._U(Locales, 'TakeBoath'))
                        if IsControlJustReleased(0, 38) then
                            local coords = QBBoatshop.PoliceBoatSpawn2
                            QBCore.Functions.SpawnVehicle("predator", function(veh)
                                SetVehicleNumberPlateText(veh, "PBOA"..tostring(math.random(1000, 9999)))
                                SetEntityHeading(veh, coords.w)
                                exports['LegacyFuel']:SetFuel(veh, 100.0)
                                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
                                SetVehicleEngineOn(veh, true, true)
                            end, coords, true)
                        end
                    end
                else
                    Citizen.Wait(1000)
                end
            else
                Citizen.Wait(3000)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do

        local inRange = false
        local Ped = PlayerPedId()
        local Pos = GetEntityCoords(Ped)

        for k, v in pairs(QBBoatshop.Docks) do
            local TakeDistance = #(Pos - vector3(v.coords.take.x, v.coords.take.y, v.coords.take.z))

            if TakeDistance < 50 then
                ClosestDock = k
                inRange = true
                PutDistance = #(Pos - vector3(v.coords.put.x, v.coords.put.y, v.coords.put.z))

                local inBoat = IsPedInAnyBoat(Ped)

                if inBoat then
                    DrawMarker(35, v.coords.put.x, v.coords.put.y, v.coords.put.z + 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.7, 1.7, 1.7, 255, 55, 15, 255, false, false, false, true, false, false, false)
                    if PutDistance < 2 then
                        if inBoat then
                            DrawText3D(v.coords.put.x, v.coords.put.y, v.coords.put.z, QBCore.Shared._U(Locales, 'RemoveBoath'))
                            if IsControlJustPressed(0, 38) then
                                RemoveVehicle()
                            end
                        end
                    end
                end

                if not inBoat then
                    DrawMarker(2, v.coords.take.x, v.coords.take.y, v.coords.take.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.5, -0.30, 15, 255, 55, 255, false, false, false, true, false, false, false)
                    if TakeDistance < 2 then
                        DrawText3D(v.coords.take.x, v.coords.take.y, v.coords.take.z, QBCore.Shared._U(Locales, 'TakeBoath'))
                        if IsControlJustPressed(1, 177) and not Menu.hidden then
                            CloseMenu()
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            CurrentDock = nil
                        elseif IsControlJustPressed(0, 38) and Menu.hidden then
                            MenuGarage()
                            Menu.hidden = not Menu.hidden
                            CurrentDock = k
                        end
                        Menu.renderGUI()
                    end
                end
            elseif TakeDistance > 51 then
                if ClosestDock ~= nil then
                    ClosestDock = nil
                end
            end
        end

        for k, v in pairs(QBBoatshop.Depots) do
            local TakeDistance = #(Pos - vector3(v.coords.take.x, v.coords.take.y, v.coords.take.z))

            if TakeDistance < 50 then
                ClosestDock = k
                inRange = true
                PutDistance = #(Pos - vector3(v.coords.put.x, v.coords.put.y, v.coords.put.z))

                local inBoat = IsPedInAnyBoat(Ped)

                if not inBoat then
                    DrawMarker(2, v.coords.take.x, v.coords.take.y, v.coords.take.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.5, -0.30, 15, 255, 55, 255, false, false, false, true, false, false, false)
                    if TakeDistance < 2 then
                        DrawText3D(v.coords.take.x, v.coords.take.y, v.coords.take.z, QBCore.Shared._U(Locales, 'BoathStorage'))
                        if IsControlJustPressed(1, 177) and not Menu.hidden then
                            CloseMenu()
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            CurrentDock = nil
                        elseif IsControlJustPressed(0, 38) and Menu.hidden then
                            MenuBoatDepot()
                            Menu.hidden = not Menu.hidden
                            CurrentDock = k
                        end
                        Menu.renderGUI()
                    end
                end
            elseif TakeDistance > 51 then
                if ClosestDock ~= nil then
                    ClosestDock = nil
                end
            end
        end

        if not inRange then
            Citizen.Wait(1000)
        end

        Citizen.Wait(4)
    end
end)

function RemoveVehicle()
    local ped = PlayerPedId()
    local Boat = IsPedInAnyBoat(ped)

    if Boat then
        local CurVeh = GetVehiclePedIsIn(ped)
        TriggerServerEvent('qb-diving:server:SetBoatState', GetVehicleNumberPlateText(CurVeh), 1, ClosestDock)

        QBCore.Functions.DeleteVehicle(CurVeh)
        SetEntityCoords(ped, QBBoatshop.Docks[ClosestDock].coords.take.x, QBBoatshop.Docks[ClosestDock].coords.take.y, QBBoatshop.Docks[ClosestDock].coords.take.z)
    end
end

Citizen.CreateThread(function()
    for k, v in pairs(QBBoatshop.Docks) do
        DockGarage = AddBlipForCoord(v.coords.put.x, v.coords.put.y, v.coords.put.z)

        SetBlipSprite (DockGarage, 410)
        SetBlipDisplay(DockGarage, 4)
        SetBlipScale  (DockGarage, 0.8)
        SetBlipAsShortRange(DockGarage, true)
        SetBlipColour(DockGarage, 3)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.label)
        EndTextCommandSetBlipName(DockGarage)
    end

    for k, v in pairs(QBBoatshop.Depots) do
        BoatDepot = AddBlipForCoord(v.coords.take.x, v.coords.take.y, v.coords.take.z)

        SetBlipSprite (BoatDepot, 410)
        SetBlipDisplay(BoatDepot, 4)
        SetBlipScale  (BoatDepot, 0.8)
        SetBlipAsShortRange(BoatDepot, true)
        SetBlipColour(BoatDepot, 3)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.label)
        EndTextCommandSetBlipName(BoatDepot)
    end
end)

-- MENU JAAAAAAAAAAAAAA

function MenuBoatDepot()
    ClearMenu()
    QBCore.Functions.TriggerCallback("qb-diving:server:GetDepotBoats", function(result)
        ped = PlayerPedId();
        MenuTitle = QBCore.Shared._U(Locales, 'MyVehicles')
        if result == nil then
            QBCore.Functions.Notify(QBCore.Shared._U(Locales, 'client_garage_function_MenuBoatDepot_notify_1'), "error", 5000)
            CloseMenu()
        else
            -- Menu.addButton(QBBoatshop.Depots[CurrentDock].label, "yeet", QBBoatshop.Depots[CurrentDock].label)

            for k, v in pairs(result) do
                currentFuel = v.fuel
                state = QBCore.Shared._U(Locales, 'state_InBoat')

                if v.state == 0 then
                    state =QBCore.Shared._U(Locales, 'state_InDepot')
                end

                Menu.addButton(QBBoatshop.ShopBoats[v.model]["label"], "TakeOutDepotBoat", v, state, QBCore.Shared._U(Locales, 'Fuel') ..currentFuel.. "%")
            end
        end

        Menu.addButton(QBCore.Shared._U(Locales, 'Back'), "MenuGarage", nil)
    end)
end

function VehicleList()
    ClearMenu()
    QBCore.Functions.TriggerCallback("qb-diving:server:GetMyBoats", function(result)
        ped = PlayerPedId();
        MenuTitle = QBCore.Shared._U(Locales, 'MyVehicles')

        if result == nil then
            QBCore.Functions.Notify(QBCore.Shared._U(Locales, 'client_garage_function_VehicleList_notify_1'), "error", 5000)
            CloseMenu()
        else
            -- Menu.addButton(QBBoatshop.Docks[CurrentDock].label, "yeet", QBBoatshop.Docks[CurrentDock].label)

            for k, v in pairs(result) do
                currentFuel = v.fuel
                if v.state == 0 then
                    state = QBCore.Shared._U(Locales, 'state_InDepot')
                elseif v.state == 1 then
                    state = QBCore.Shared._U(Locales, 'state_InBoat')
                end

                Menu.addButton(QBBoatshop.ShopBoats[v.model]["label"], "TakeOutVehicle", v, state, QBCore.Shared._U(Locales, 'Fuel') ..currentFuel.. "%")
            end
        end

        Menu.addButton(QBCore.Shared._U(Locales, 'Back'), "MenuGarage", nil)
    end, CurrentDock)
end

function TakeOutVehicle(vehicle)
    if vehicle.state == 1 then
        QBCore.Functions.SpawnVehicle(vehicle.model, function(veh)
            SetVehicleNumberPlateText(veh, vehicle.plate)
            SetEntityHeading(veh, QBBoatshop.Docks[CurrentDock].coords.put.w)
            exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
            QBCore.Functions.Notify(QBCore.Shared._U(Locales, 'client_garage_function_TakeOutVehicle_notify_1')..currentFuel.. "%", "primary", 4500)
            CloseMenu()
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
            SetVehicleEngineOn(veh, true, true)
            TriggerServerEvent('qb-diving:server:SetBoatState', GetVehicleNumberPlateText(veh), 0, CurrentDock)
        end, QBBoatshop.Docks[CurrentDock].coords.put, true)
    else
        QBCore.Functions.Notify(QBCore.Shared._U(Locales, 'client_garage_function_TakeOutVehicle_notify_2'), "error", 4500)
    end
end

function TakeOutDepotBoat(vehicle)
    QBCore.Functions.SpawnVehicle(vehicle.model, function(veh)
        SetVehicleNumberPlateText(veh, vehicle.plate)
        SetEntityHeading(veh, QBBoatshop.Depots[CurrentDock].coords.put.w)
        exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
        QBCore.Functions.Notify(QBCore.Shared._U(Locales, 'client_garage_function_TakeOutDepotBoat_notify_1')..currentFuel.. "%", "primary", 4500)
        CloseMenu()
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
    end, QBBoatshop.Depots[CurrentDock].coords.put, true)
end

function MenuGarage()
    ped = PlayerPedId();
    MenuTitle = "Garage"
    ClearMenu()
    Menu.addButton(QBCore.Shared._U(Locales, 'MyVehicles'), "VehicleList", nil)
    Menu.addButton(QBCore.Shared._U(Locales, 'CloseMenu'), "CloseMenu", nil)
end

function CloseMenu()
    Menu.hidden = true
    CurrentDock = nil
    ClearMenu()
end

function ClearMenu()
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end
