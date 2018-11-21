ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('loffe_fishing:getItems', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local fishingRod = xPlayer.getInventoryItem('loffe_rod').count
	local fishingBait = xPlayer.getInventoryItem('loffe_fishingbait').count
	cb(fishingRod, fishingBait)
	if fishingBait > 0 and fishingRod > 0 then
		xPlayer.removeInventoryItem('loffe_fishingbait', 1)
	end
end)

RegisterServerEvent('loffe_fishing:caught')
AddEventHandler('loffe_fishing:caught', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
	xPlayer.addInventoryItem('loffe_fish', 1)
end)

RegisterServerEvent('loffe_fishing:sell')
AddEventHandler('loffe_fishing:sell', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local itemAmount = xPlayer.getInventoryItem('loffe_fish').count
	if itemAmount > 0 then
		xPlayer.removeInventoryItem('loffe_fish', itemAmount)
		xPlayer.addMoney(itemAmount*math.random(30,40))
	end
end)

RegisterServerEvent('loffe_fishing:buyEquipment')
AddEventHandler('loffe_fishing:buyEquipment', function(item, price, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local itemAmount = xPlayer.getInventoryItem(item).count
	if(xPlayer.getMoney() >= price) then
		if item == 'loffe_rod' and itemAmount > 0 or item == 'loffe_fishingbait' and itemAmount >= 200 then
			TriggerClientEvent('loffe_fishing:notify', _source, 'You can\'t hold that much!')
		else
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem(item, amount)
			TriggerClientEvent('loffe_fishing:notify', _source, 'You bought ' .. amount .. ' ' .. ESX.GetItemLabel(item) .. ' for ~g~$' .. price)
		end
	else
		TriggerClientEvent('loffe_fishing:notify', _source, 'You don\'t have enough money!')
	end
end)

--[[
]]
