ESX               = nil
local ItemsLabels = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('onMySQLReady', function()

	MySQL.Async.fetchAll(
		'SELECT * FROM items',
		{},
		function(result)

			for i=1, #result, 1 do
				ItemsLabels[result[i].name] = result[i].label
			end--

		end
	)

end)

ESX.RegisterServerCallback('hiddenshop:requestDBItems', function(source, cb)

	MySQL.Async.fetchAll(
		'SELECT * FROM hiddenshops',
		{},
		function(result)

			local hiddenshopItems  = {}

			for i=1, #result, 1 do

				if hiddenshopItems[result[i].name] == nil then
					hiddenshopItems[result[i].name] = {}
				end

				table.insert(hiddenshopItems[result[i].name], {
					name  = result[i].item,
					price = result[i].price,
					label = ItemsLabels[result[i].item]
				})

			end

			cb(hiddenshopItems)

		end
	)

end)

RegisterServerEvent('hiddenshop:buyItem')
AddEventHandler('hiddenshop:buyItem', function(itemName, price)

	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)

	if xPlayer.get('money') >= price then

		xPlayer.removeMoney(price)
		xPlayer.addInventoryItem(itemName, 1)

		TriggerClientEvent('esx:showNotification', _source, _U('bought') .. ItemsLabels[itemName])

	else
		TriggerClientEvent('esx:showNotification', _source, _U('not_enough'))
	end

end)
