-- Don't Touch
ESX = nil
Spams = {}
local searchQueue = nil
local TargetID = nil
local searchRequest = nil
TriggerEvent(BiG.Config.ESXEventString, function(obj) ESX = obj end)

--Main Command
RegisterCommand('search', function(source, args)

    -- Local Variables 
    local PlayerSource = source
    local ArgumentOne = args[1] -- Just i Wanna choose name for args[1]
    local TargetPlayerID = tonumber(ArgumentOne) -- TargetPlayerID for request search from searcher
    local TargetPlayerNameFromID = GetPlayerName(ArgumentOne) -- Get target player Name 
    local ArgumentOneString = string.lower(ArgumentOne) -- for get {"accept" OR "decline"} in Argument 1
    local ArgumentOneNumber = tonumber(ArgumentOne) -- for get ID in Argument 1
    local PlayerSourceCoordinate = GetEntityCoords(GetPlayerPed(PlayerSource)) -- Searcher Player Coordinate
	local TargetPlayerCoordinate = GetEntityCoords(GetPlayerPed(args[1])) -- Target Player Coordinate
	local DistanceBetweenPlayers = BiG.Function.Server.GetDistanceBetweenPlayers(PlayerSourceCoordinate, TargetPlayerCoordinate) -- Get Distance Between SourcePlayer and Target 

    if ArgumentOne == nil then
        if BiG.Config.Lang == 'English' then
            BiG.Function.Server.SendMessage(PlayerSource, 'You Should Enter ^2Argument^0 First')
        elseif BiG.Config.Lang == 'Persian' then
            BiG.Function.Server.SendMessage(PlayerSource, 'Shoma Dar Ghesmat ^2Argument^0 Bayad ^3Value ^0Vared Konid')
        end
    end

    if ArgumentOneNumber then
		if searchQueue == nil then
			if not TargetPlayerNameFromID then
				if BiG.Config.Lang == 'English' then
					BiG.Function.Server.SendMessage(PlayerSource, 'ID is not ^8Online')
				elseif BiG.Config.Lang == 'Persian' then
					BiG.Function.Server.SendMessage(PlayerSource, '^8ID ^0Vared Shode ^2Online^0 Nist.')
				end
				return
			end
			if DistanceBetweenPlayers <= BiG.Config.MaxDistance then
				TriggerEvent('BiG_Search:requestSearch', PlayerSource, TargetPlayerID)
				TriggerClientEvent('BiG_Search:checkSearchAvailable', PlayerSource, TargetPlayerID)
				TargetID = TargetPlayerID
				Citizen.CreateThread(function()
					Spams[PlayerSource] = true
					Citizen.Wait(BiG.Config.SpamTime)
					Spams[PlayerSource] = nil
				end)
				if Spams[PlayerSource] then
					BiG.Function.Server.SendMessage(PlayerSource, 'Lotfan ^3Spam ^0Nakonid.')
					return
				end
			end
		else
			Citizen.CreateThread(function()
				Spams[PlayerSource] = true
				Citizen.Wait(BiG.Config.SpamTime)
				Spams[PlayerSource] = nil
			end)
			if Spams[PlayerSource] then
				if BiG.Config.Lang == 'English' then
					BiG.Function.Server.SendMessage(PlayerSource, 'Please Dont\'t ^2Spam ^0in Chat.')
				elseif BiG.Config.Lang == 'Persian' then
					BiG.Function.Server.SendMessage(PlayerSource, 'Shoma dar hal hazer yek darkhast ^2search ^0baz darid')
				end
				return
			else
				if BiG.Config.Lang == 'English' then
					BiG.Function.Server.SendMessage(PlayerSource, 'You Have Another Active ^2Search ^0Request')
				elseif BiG.Config.Lang == 'Persian' then
					BiG.Function.Server.SendMessage(PlayerSource, 'Shoma dar hal hazer yek darkhast ^2search ^0baz darid')
				end
			end
		end
    end

    if ArgumentOneString then
        if ArgumentOneString == "accept" then
            if searchQueue == nil then
                if BiG.Config.Lang == 'English' then
                    BiG.Function.Server.SendMessage(PlayerSource, 'You Don\'t have any ^2Active ^8Search ^0Request')
                elseif BiG.Config.Lang == 'Persian' then
                    BiG.Function.Server.SendMessage(PlayerSource, 'Shoma darkhast ^8Search ^2Active^0 Nadarid.')
                end
                return
            else
                TriggerClientEvent('BiG_Search:acceptSearch', PlayerSource ,TargetID)
                if BiG.Config.Lang == 'English' then
                    BiG.Function.Server.SendMessage(PlayerSource, '^8[^4'..GetPlayerName(TargetID)..'^0/^4'..TargetID..'^8]^0 ^2Accepted ^0your search requests.')
					BiG.Function.Server.SendMessage(TargetID, '^0You\'r ^2Accepted ^8[^4'..GetPlayerName(PlayerSource)..'^0/^4'..PlayerSource..'^8]^0 Search Request.')
                elseif BiG.Config.Lang == 'Persian' then
                    BiG.Function.Server.SendMessage(PlayerSource, '^8[^4'..GetPlayerName(TargetID)..'^0/^4'..TargetID..'^8]^0 Darkhast Search Shomara ^2Accept ^0Kard.')
					BiG.Function.Server.SendMessage(TargetID, '^0Shoma Darkhast Search ^8[^4'..GetPlayerName(PlayerSource)..'^0/^4'..PlayerSource..'^8]^0 ra ^2Accept ^0Kardid.')
                end
            end
            searchQueue = nil
        elseif ArgumentOneString == "decline" then

            if searchQueue == nil then
                if BiG.Config.Lang == 'English' then
                    BiG.Function.Server.SendMessage(PlayerSource, 'You Don\'t have any ^2Active ^8Search ^0Request')
                elseif BiG.Config.Lang == 'Persian' then
                    BiG.Function.Server.SendMessage(PlayerSource, 'Shoma darkhast ^8Search ^2Active^0 Nadarid.')
                end
                return
            else

                if BiG.Config.Lang == 'English' then
                    BiG.Function.Server.SendMessage(PlayerSource, '^8[^4'..GetPlayerName(TargetID)..'^0/^4'..TargetID..'^8]^0 ^2Declined ^0your search requests.')
					BiG.Function.Server.SendMessage(TargetID, '^0You\'r ^1Declined ^8[^4'..GetPlayerName(PlayerSource)..'^0/^4'..PlayerSource..'^8]^0 Search Request.')
                elseif BiG.Config.Lang == 'Persian' then
                    BiG.Function.Server.SendMessage(PlayerSource, '^8[^4'..GetPlayerName(TargetID)..'^0/^4'..TargetID..'^8]^0 Darkhast Search Shomara ^2Decline ^0Kard.')
					BiG.Function.Server.SendMessage(TargetID, '^0Shoma Darkhast Search ^8[^4'..GetPlayerName(PlayerSource)..'^0/^4'..PlayerSource..'^8]^0 ra ^1Decline ^0Kardid.')
                end

            end
            searchQueue = nil

        end
    end

end, false)

-- Event Side
RegisterNetEvent('BiG_Search:requestSearch')
AddEventHandler('BiG_Search:requestSearch', function(SourcePlayer, TargetPlayer)

    local PlayerSourceCoordinate = GetEntityCoords(GetPlayerPed(SourcePlayer)) -- Searcher Player Coordinate
	local TargetPlayerCoordinate = GetEntityCoords(GetPlayerPed(TargetPlayer)) -- Target Player Coordinate
	local DistanceBetweenPlayers = BiG.Function.Server.GetDistanceBetweenPlayers(PlayerSourceCoordinate, TargetPlayerCoordinate) -- Get Distance Between SourcePlayer and Target 

    if DistanceBetweenPlayers > BiG.Config.MaxDistance then return end

	if BiG.Config.Lang == 'English' then
		BiG.Function.Server.SendMessage(TargetPlayer,'^8[^4'..GetPlayerName(SourcePlayer)..'^0/^4'..SourcePlayer..'^8] ^0He Want to Search you , For accept Type [^0/search^2 accept^0] or for Decline Type [^0/search^8 deny^0] ^0in Chat.')
	elseif BiG.Config.Lang == 'Persian' then
		BiG.Function.Server.SendMessage(TargetPlayer,'^8[^4'..GetPlayerName(SourcePlayer)..'^0/^4'..SourcePlayer..'^8] ^0Mikhahad Shomara search konad , Baraye Accept Kardan Command [^0/search^2 accept^0] Ra Vared Konid va Baraye Deny Kardan Command [^0/search^8 deny^0] ^0ra vared konid .')
	end

    searchQueue = source
    Citizen.CreateThread(function()
        Citizen.Wait(BiG.Config.AcceptTime)
        searchQueue = nil
    end)
end)

ESX.RegisterServerCallback('BiG_Search:ShowTargetPlayerInventory', function(source, cb, target)

	local xPlayer = ESX.GetPlayerFromId(target)

	local identifier = GetPlayerIdentifiers(target)[1]

	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
		['@identifier'] = identifier
	})

	local name 		= result[1].playerName or (result[1].firstname.."_"..result[1].lastname)
	local dob       = result[1].dateofbirth
	local height    = result[1].height
	local sex

	if result[1].skin ~= nil then
		skin = json.decode(result[1].skin)
		local isMale = skin.sex == 0
		if isMale then sex = 'm' else sex = 'f' end
	end

	local data = {
		name      = name,
		money	  = xPlayer.money,
		job       = xPlayer.job,
		inventory = xPlayer.inventory,
		weapons   = xPlayer.loadout,
		sex       = sex
	}

	TriggerEvent('esx_status:getStatus', target, 'drunk', function(status)
		if status ~= nil then
			data.drunk = math.floor(status.percent)
		end
	end)

	TriggerEvent('esx_license:getLicenses', target, function(licenses)
		data.licenses = licenses
		cb(data)
	end)

end)

RegisterNetEvent('BiG_Search:ConfiscateTargetPlayerItems')
AddEventHandler( 'BiG_Search:ConfiscateTargetPlayerItems', function(target, itemType, itemName, amount)
	local _source 		= source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local oocname 		=  GetPlayerName(source)
	local targetName 	=  GetPlayerName(target)

	if not targetXPlayer then return end

	if targetXPlayer.get("aduty") or targetXPlayer.get("admin") then
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Shoma Nemitavanid Admin On Duty Ra Loot Konid')
		return
	end
    if itemType == 'item_standard' then
    	local label = sourceXPlayer.getInventoryItem(itemName).label
    	local itemLimit = sourceXPlayer.getInventoryItem(itemName).limit
    	local sourceItemCount = sourceXPlayer.getInventoryItem(itemName).count
    	local targetItemCount = targetXPlayer.getInventoryItem(itemName).count
    	if amount > 0 and targetItemCount >= amount then
    		if itemLimit ~= -1 and (sourceItemCount + amount) > itemLimit then
    			TriggerClientEvent('esx:showNotification', targetXPlayer.source, _U('ex_inv_lim_target'))
    			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('ex_inv_lim_source'))
    		else
    			targetXPlayer.removeInventoryItem(itemName, amount)
    			sourceXPlayer.addInventoryItem(itemName, amount)
    			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_stole') .. ' ~g~x' .. amount .. ' ' .. label .. ' ~w~' .. _U('from_your_target') )
    			TriggerClientEvent('esx:showNotification', targetXPlayer.source, _U('someone_stole') .. ' ~r~x'  .. amount .. ' ' .. label )
    		end
    	else
    		TriggerClientEvent('esx:showNotification', _source, _U('invalid_quantity'))
    	end

    elseif itemType == 'item_money' then

    	if amount > 0 and targetXPlayer.get('money') >= amount then
    		targetXPlayer.removeMoney(amount)
    		sourceXPlayer.addMoney(amount)

    		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_stole') .. ' ~g~$' .. amount .. ' ~w~' .. _U('from_your_target') )
    		TriggerClientEvent('esx:showNotification', targetXPlayer.source, _U('someone_stole') .. ' ~r~$'  .. amount )
    		TriggerEvent('DiscordBot:ToDiscord', 'loot', sourceXPlayer.name .. '('.. source .. ')', '```css\n ' .. GetPlayerName(source).. '('.. sourceXPlayer.name .. ')\nTedad ('..amount ..'$) Az '.. targetXPlayer.name ..'(' .. targetName .. ') Loot Kard\n```')
    	else
    		TriggerClientEvent('esx:showNotification', _source, _U('imp_invalid_amount'))
    	end

    elseif itemType == 'item_weapon' then
    	local weapon = targetXPlayer.hasWeapon(itemName)
    	TriggerClientEvent('BiG_Search:RemoveWeaponFromTargetPlayerPed', target, itemName,weapon.ammo,_source)
    end

end)

RegisterServerEvent('BiG_Search:RemoveWeaponFromTargetPlayerInventory')
AddEventHandler('BiG_Search:RemoveWeaponFromTargetPlayerInventory', function(target, itemName, ammo)
	local _source 		= source
	local sourceXPlayer = ESX.GetPlayerFromId(target)
	local targetXPlayer = ESX.GetPlayerFromId(_source)
	local oocname 		=  GetPlayerName(source)
	local targetName 	=  GetPlayerName(target)
	local weapon = targetXPlayer.hasWeapon(itemName)

	if weapon then
		targetXPlayer.removeWeapon(itemName, ammo)
		sourceXPlayer.addWeapon(itemName, ammo)

		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, _U('you_stole') .. ' ~g~x' .. ammo .. ' ' .. itemName .. ' ~w~' .. _U('from_your_target') )
		TriggerClientEvent('esx:showNotification', targetXPlayer.source, _U('someone_stole') .. ' ~r~x'  .. ammo .. ' ' .. itemName )
		if weapon.components ~= {} then
			for k,v in pairs(weapon.components) do
				sourceXPlayer.addWeaponComponent(itemName, v)
			end
		end
	end

end)