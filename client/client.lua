ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local locations = { 
    { x = -1742.08, y = -1129.58, z = 12.17, h = 237.0}, 
	{ x = -1745.47, y = -1133.63, z = 12.17, h = 237.0}, 
	{ x = -1730.48, y = -1125.54, z = 12.17, h = 147.0}, 
	{ x = -1727.79, y = -1128.07, z = 12.17, h = 147.0}, 
} 

local store = { 
    [_U('open_store')] = { x = -1340.91, y = -1266.57, z = 4.05}, 
} 

local sell = { 
    [_U('sell_fish')] = { x = -1845.43, y = -1196.18, z = 18.33}, 
} 

local blips = {
	{title = _U('fishing_blip'), sprite = 68, x = -1741.82, y = -1129.24, z = 12.19},
	{title = _U('sell_fish_blip'), sprite = 356, x = -1845.41, y = -1196.15, z = 12.19},
	{title = _U('store_blip'), sprite = 52, x = -1340.91, y = -1266.57, z = 12.17},
}

Citizen.CreateThread(function()

    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.sprite)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 1.0)
      SetBlipColour(info.blip, 0)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)

Citizen.CreateThread(function()
	while true do
      
	Citizen.Wait(5)
	
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for k, v in pairs(locations) do
			if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 100 then
				DrawMarker(27, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
			end
		end
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for k, v in pairs(store) do
			if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 100 then
				DrawMarker(27, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
			end
		end
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for k, v in pairs(sell) do
			if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 100 then
				DrawMarker(27, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 0, 0, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
      
	Citizen.Wait(5)
	
		local coords = GetEntityCoords(GetPlayerPed(-1))
		
		for k, v in pairs(locations) do
			if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.5 then
				DrawText3D(v.x, v.y, v.z+0.9, _U('start'), 0.80)
				if IsControlPressed(0, 38) then
					local fishingrod = 0
					local fishingbait = 0
					local ultrafishingbait = 0
					local extremefishingbait = 0
					
					ESX.TriggerServerCallback('loffe_fishing:getItems', function(fishingRod, fishingBait, ultrafishingBait, extremefishingBait)
						fishingrod = fishingRod
						fishingbait = fishingBait
						ultrafishingbait = ultrafishingBait
						extremefishingbait = extremefishingBait
					end)
					Wait(500)
					if (fishingrod > 0 and fishingbait > 0) or (fishingrod > 0 and ultrafishingbait > 0) or (fishingrod > 0 and extremefishingbait > 0) then
						local ped = GetPlayerPed(-1)
						ClearPedTasks(ped)
						SetEntityHeading(ped, v.h)
						TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_FISHING", 0, false)
						local caught = false
						local this = 0
						if extremefishingbait > 0 then
							Wait(math.random(6000, 8500))
							TriggerServerEvent('loffe_fishing:bait', 'lEbait', 1)
						elseif ultrafishingbait > 0 then
							Wait(math.random(8500, 12000))
							TriggerServerEvent('loffe_fishing:bait', 'lUbait', 1)
						elseif fishingbait > 0 then
							Wait(math.random(12000, 17000))
							TriggerServerEvent('loffe_fishing:bait', 'lbait', 1)
						end
						local randomThis = math.random(100, 350)
						while not caught do
							Wait(5)
							local offset = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 1.0, 0.5)
							DrawText3D(offset.x, offset.y, offset.z, _U('on_hook'), 0.8)
							this = this + 1
							if this == randomThis then
								caught = true
								local fishingRod = GetClosestObjectOfType(coords, 10.0, GetHashKey("prop_fishing_rod_01"), false, false, false)
								ClearPedTasks(ped)
								SetEntityAsMissionEntity(fishingRod, true, true)
								DeleteEntity(fishingRod)
								Notify(_U('got_away'), 2500)
							else
								if IsControlPressed(0, 18) --[[enter]] then
									local fishingRod = GetClosestObjectOfType(coords, 10.0, GetHashKey("prop_fishing_rod_01"), false, false, false)
									ClearPedTasks(ped)
									SetEntityAsMissionEntity(fishingRod, true, true)
									DeleteEntity(fishingRod)
									local randomWeight = math.random(5000, 14000)
									TriggerServerEvent('loffe_fishing:caught')
									caught = true
									Notify(_U('you_caught') .. randomWeight/1000 .. ' kg', 2000)
								end
							end
						end
						caught = false
					else
						Notify(_U('no_equipment'), 2500)
					end
				end
			end
		end
	end
end)

RegisterNetEvent('loffe-fishing:boatFishing')
AddEventHandler('loffe-fishing:boatFishing', function()
    local coords = GetEntityCoords(GetPlayerPed(-1))
        local closestvehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 10.0, 0, 12294)
        if not IsPedInAnyVehicle(GetPlayerPed(-1), true) and IsEntityInWater(closestvehicle) then
                    
                    local fishingrod = 0
					local fishingbait = 0
					local ultrafishingbait = 0
					local extremefishingbait = 0

                    ESX.TriggerServerCallback('loffe_fishing:getItems', function(fishingRod, fishingBait, ultrafishingBait, extremefishingBait)
						fishingrod = fishingRod
						fishingbait = fishingBait
						ultrafishingbait = ultrafishingBait
						extremefishingbait = extremefishingBait
					end)
                    Wait(500)
                    if (fishingrod > 0 and fishingbait > 0) or (fishingrod > 0 and ultrafishingbait > 0) or (fishingrod > 0 and extremefishingbait > 0) then
                    local ped = GetPlayerPed(-1)
                    ClearPedTasks(ped)
                    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_FISHING", 0, false)
                    local caught = false
                    local this = 0
                    	if extremefishingbait > 0 then
							Wait(math.random(6000, 8500))
							TriggerServerEvent('loffe_fishing:bait', 'lEbait', 1)
						elseif ultrafishingbait > 0 then
							Wait(math.random(8500, 12000))
							TriggerServerEvent('loffe_fishing:bait', 'lUbait', 1)
						elseif fishingbait > 0 then
							Wait(math.random(12000, 17000))
							TriggerServerEvent('loffe_fishing:bait', 'lbait', 1)
						end
                    local randomThis = math.random(100, 250)
                    while not caught do
                        Wait(5)
                        local offset = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 0.0, 1.0)
                        DrawText3D(offset.x, offset.y, offset.z, _U('on_hook'), 0.6)
                        this = this + 1
                        if this == randomThis then
                            caught = true
                            local fishingRod = GetClosestObjectOfType(coords, 10.0, GetHashKey("prop_fishing_rod_01"), false, false, false)
                            ClearPedTasks(ped)
                            SetEntityAsMissionEntity(fishingRod, true, true)
                            DeleteEntity(fishingRod)
                            Notify(_U('got_away'), 2500)
                        else
                            if IsControlPressed(0, 18) --[[enter]] then
                                local fishingRod = GetClosestObjectOfType(coords, 10.0, GetHashKey("prop_fishing_rod_01"), false, false, false)
                                ClearPedTasks(ped)
                                SetEntityAsMissionEntity(fishingRod, true, true)
                                DeleteEntity(fishingRod)
                                local randomWeight = math.random(5000, 14000)
                                TriggerServerEvent('loffe_fishing:caught')
                                caught = true
                                Notify(_U('you_caught') .. randomWeight/1000 .. ' kg', 2000)
                            end
                        end
                    end
                        caught = false
                    else
                        Notify(_U('no_equipment'), 2500)
                end
        end
end)

Citizen.CreateThread(function()
	while true do
      
	Citizen.Wait(5)
	
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for k, v in pairs(sell) do
			if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.5 then
				DrawText3D(v.x, v.y, v.z+0.9, k, 0.80)
				if IsControlPressed(0, 38) then
					TriggerServerEvent('loffe_fishing:sell')
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
      
	Citizen.Wait(5)
	
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for k, v in pairs(store) do
			if GetDistanceBetweenCoords(coords, v.x, v.y, v.z, true) < 1.5 then
				DrawText3D(v.x, v.y, v.z+0.9, k, 0.80)
				if IsControlPressed(0, 38) then
					OpenFishMenu()
				end
			end
		end
	end
end)

function OpenFishMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'fish_menu',
        {
            title    = _U('fishing_store'),
            elements = {
				{label = _U('fishing_rod'), item = 'lrod', price = 1500, amount = 1},
				{label = _U('fishing_bait'), item = 'lbait', price = 5, amount = 1},
				{label = _U('ultra_bait'), item = 'lUbait', price = 10, amount = 1},
				{label = _U('extreme_bait'), item = 'lEbait', price = 15, amount = 1},
            }
        },
        function(data, menu)
			local item = data.current.item
			local price = data.current.price
			local amount = data.current.amount
            TriggerServerEvent('loffe_fishing:buyEquipment', item, price, amount)
        end,
    function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent('loffe_fishing:notify')
AddEventHandler('loffe_fishing:notify', function(msg)
	Notify(msg, 5000)
end)

function Notify(message, time)
    local timePassed = 0
    while timePassed <= time/10 do
        Wait(1)
        timePassed = timePassed + 1
        local offset = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 1.0, 0.5)
        DrawText3D(offset.x, offset.y, offset.z, message, 0.8)
    end
end

function DrawText3D(x, y, z, text, scale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
 
    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 215)
 
    AddTextComponentString(text)
    DrawText(_x, _y)
 
    local factor = (string.len(text)) / 230
    DrawRect(_x, _y + 0.0250, 0.095 + factor, 0.06, 41, 11, 41, 100)
end