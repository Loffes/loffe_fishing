ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('loffe_fishing:getItems', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local fishingRod = xPlayer.getInventoryItem('lrod').count
	local fishingBait = xPlayer.getInventoryItem('lbait').count
	local ultrafishingBait = xPlayer.getInventoryItem('lUbait').count
	local extremefishingBait = xPlayer.getInventoryItem('lEbait').count
	cb(fishingRod, fishingBait, ultrafishingBait, extremefishingBait)
end)

RegisterServerEvent('loffe_fishing:caught')
AddEventHandler('loffe_fishing:caught', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
	xPlayer.addInventoryItem('lfish', 1)
end)

RegisterServerEvent('loffe_fishing:bait')
AddEventHandler('loffe_fishing:bait', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
	xPlayer.removeInventoryItem('lbait', 1)
end)

RegisterServerEvent('loffe_fishing:ultra')
AddEventHandler('loffe_fishing:ultra', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
	xPlayer.removeInventoryItem('lUbait', 1)
end)

RegisterServerEvent('loffe_fishing:extreme')
AddEventHandler('loffe_fishing:extreme', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	
	xPlayer.removeInventoryItem('lEbait', 1)
end)

RegisterServerEvent('loffe_fishing:sell')
AddEventHandler('loffe_fishing:sell', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local itemAmount = xPlayer.getInventoryItem('lfish').count
	if itemAmount > 0 then
		xPlayer.removeInventoryItem('lfish', itemAmount)
		local price = itemAmount*math.random(30,40)
		xPlayer.addMoney(price)
		TriggerClientEvent('loffe_fishing:notify', _source, _U('sold') .. price .. ':-')
	end
end)

RegisterServerEvent('loffe_fishing:buyEquipment')
AddEventHandler('loffe_fishing:buyEquipment', function(item, price, amount)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local itemAmount = xPlayer.getInventoryItem(item).count
	if(xPlayer.getMoney() >= price) then
		if item == 'lrod' and itemAmount > 0 or item == 'lbait' and itemAmount >= 200 then
			TriggerClientEvent('loffe_fishing:notify', _source, _U('too_much'))
		else
			xPlayer.removeMoney(price)
			xPlayer.addInventoryItem(item, amount)
			TriggerClientEvent('loffe_fishing:notify', _source, 'Du köpte ' .. amount .. ' ' .. ESX.GetItemLabel(item) .. ' för ~g~$' .. price)
		end
	else
		TriggerClientEvent('loffe_fishing:notify', _source, _U('not_enough'))
	end
end)

--[[
]]
