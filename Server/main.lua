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
				if BiG.Config.Lang == 'English' then
					BiG.Function.Server.Discord.SendLogToDiscord("Search Request", GetPlayerName(PlayerSource), "Search Request Sended", 'Source Player Info **:** **ID** : `'..PlayerSource..'`, **OOC Name** : `'..GetPlayerName(PlayerSource)..'`,\n Target Player Info **:** **ID** : `'..TargetPlayerID..'`, **OOC Name** : `'..GetPlayerName(TargetPlayerID)..'`.\n **Time Stamp** : **`'..os.time()..'`**,\n**Data** : Player [**`'..GetPlayerName(PlayerSource)..'/'..PlayerSource..'`**] Sended Search Request to [**`'..GetPlayerName(TargetPlayerID)..'/'..TargetPlayerID..'`**] and wait for Response.\n**Action** : **`Sending Search Request`**.')
				elseif BiG.Config.Lang == 'Persian' then
					BiG.Function.Server.Discord.SendLogToDiscord("Search Request", GetPlayerName(PlayerSource), "Search Request Ersal Shod", 'Source Player Info **:** **ID** : `'..PlayerSource..'`, **Name OOC** : `'..GetPlayerName(PlayerSource)..'`,\n Target Player Info **:** **ID** : `'..TargetPlayerID..'`, **Name OOC** : `'..GetPlayerName(TargetPlayerID)..'`.\n **Time Stamp** : **`'..os.time()..'`**,\n**Data** : Player [**`'..GetPlayerName(PlayerSource)..'/'..PlayerSource..'`**] Be Player [**`'..GetPlayerName(TargetPlayerID)..'/'..TargetPlayerID..'`**] Request Search Dad va Montazer Javab Ast.\n**Action** : **`Sending Search Request`**.')
				end
				Citizen.CreateThread(function()
					Spams[PlayerSource] = true
					Citizen.Wait(BiG.Config.SpamTime)
					Spams[PlayerSource] = nil
				end)
				if Spams[PlayerSource] then
					if BiG.Config.Lang == 'English' then
						BiG.Function.Server.SendMessage(PlayerSource, 'Please Dont\'t ^2Spam ^0in Chat.')
					elseif BiG.Config.Lang == 'Persian' then
						BiG.Function.Server.SendMessage(PlayerSource, 'Lotfan ^3Spam ^0Nakonid.')
					end
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
					BiG.Function.Server.SendMessage(PlayerSource, 'Lotfan ^3Spam ^0Nakonid.')
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
					BiG.Function.Server.Discord.SendLogToDiscord("Search Response", GetPlayerName(PlayerSource), "Search Response Recived", 'Source Player Info **:** **ID** : `'..PlayerSource..'`, **OOC Name** : `'..GetPlayerName(PlayerSource)..'`,\n Target Player Info **:** **ID** : `'..TargetID..'`, **OOC Name** : `'..GetPlayerName(TargetID)..'`.\n **Time Stamp** : **`'..os.time()..'`**,\n**Data** : Player [**`'..GetPlayerName(TargetID)..'/'..TargetID..'`**] **Accepted** Search Request from [**`'..GetPlayerName(PlayerSource)..'/'..PlayerSource..'`**].\n**Action** : **`Accepting Search Request`**.')
				elseif BiG.Config.Lang == 'Persian' then
					BiG.Function.Server.Discord.SendLogToDiscord("Search Response", GetPlayerName(PlayerSource), "Javab Search Request Ersal Shod", 'Source Player Info **:** **ID** : `'..PlayerSource..'`, **Name OOC** : `'..GetPlayerName(PlayerSource)..'`,\n Target Player Info **:** **ID** : `'..TargetID..'`, **Name OOC** : `'..GetPlayerName(TargetID)..'`.\n **Time Stamp** : **`'..os.time()..'`**,\n**Data** : Player [**`'..GetPlayerName(TargetID)..'/'..TargetID..'`**] Search Request Player [**`'..GetPlayerName(PlayerSource)..'/'..PlayerSource..'`**] ra **Accept** Kard.\n**Action** : **`Accepting Search Request`**.')
				end
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
					BiG.Function.Server.Discord.SendLogToDiscord("Search Response", GetPlayerName(PlayerSource), "Search Response Recived", 'Source Player Info **:** **ID** : `'..PlayerSource..'`, **OOC Name** : `'..GetPlayerName(PlayerSource)..'`,\n Target Player Info **:** **ID** : `'..TargetID..'`, **OOC Name** : `'..GetPlayerName(TargetID)..'`.\n **Time Stamp** : **`'..os.time()..'`**,\n**Data** : Player [**`'..GetPlayerName(TargetID)..'/'..TargetID..'`**] **Declined** Search Request from [**`'..GetPlayerName(PlayerSource)..'/'..PlayerSource..'`**].\n**Action** : **`Declining Search Request`**.')
                elseif BiG.Config.Lang == 'Persian' then
                    BiG.Function.Server.SendMessage(PlayerSource, '^8[^4'..GetPlayerName(TargetID)..'^0/^4'..TargetID..'^8]^0 Darkhast Search Shomara ^2Decline ^0Kard.')
					BiG.Function.Server.SendMessage(TargetID, '^0Shoma Darkhast Search ^8[^4'..GetPlayerName(PlayerSource)..'^0/^4'..PlayerSource..'^8]^0 ra ^1Decline ^0Kardid.')
					BiG.Function.Server.Discord.SendLogToDiscord("Search Response", GetPlayerName(PlayerSource), "Javab Search Request Ersal Shod", 'Source Player Info **:** **ID** : `'..PlayerSource..'`, **Name OOC** : `'..GetPlayerName(PlayerSource)..'`,\n Target Player Info **:** **ID** : `'..TargetID..'`, **Name OOC** : `'..GetPlayerName(TargetID)..'`.\n **Time Stamp** : **`'..os.time()..'`**,\n**Data** : Player [**`'..GetPlayerName(TargetID)..'/'..TargetID..'`**] Search Request Player [**`'..GetPlayerName(PlayerSource)..'/'..PlayerSource..'`**] ra **Decline** Kard.\n**Action** : **`Declining Search Request`**.')

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
		BiG.Function.Server.SendMessage(TargetPlayer,'^8[^6'..GetPlayerName(SourcePlayer)..'^0/^6'..SourcePlayer..'^8] ^0He Want to Search you , For accept Type [^0/search^2 accept^0] or for Decline Type [^0/search^8 deny^0] ^0in Chat.')
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
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	local name = result[1].playerName or (result[1].firstname.."_"..result[1].lastname)
	local sex

	if result[1].skin ~= nil then
		skin = json.decode(result[1].skin)
		local isMale = skin.sex == 0
		if isMale then sex = 'm' else sex = 'f' end
	end

	local data = {name = name, money = xPlayer.money, job = xPlayer.job, inventory = xPlayer.inventory, weapons = xPlayer.loadout, sex = sex}

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

	if not targetXPlayer then return end

	if targetXPlayer.get("aduty") or targetXPlayer.get("admin") then
		if BiG.Config.Lang == 'English' then
			BiG.Function.Server.ShowNotifcation(sourceXPlayer.source, 'You Can\'t Search OnDuty Admin')
		elseif BiG.Config.Lang == 'Persian' then
			BiG.Function.Server.ShowNotifcation(sourceXPlayer.source, 'Shoma Nemitavanid Admin OnDuty ra Search Konid')
		end
		return
	end
    if itemType == 'item_standard' then
    	local label = sourceXPlayer.getInventoryItem(itemName).label
    	local itemLimit = sourceXPlayer.getInventoryItem(itemName).limit
    	local sourceItemCount = sourceXPlayer.getInventoryItem(itemName).count
    	local targetItemCount = targetXPlayer.getInventoryItem(itemName).count
    	if amount > 0 and targetItemCount >= amount then
    		if itemLimit ~= -1 and (sourceItemCount + amount) > itemLimit then
				if BiG.Config.Lang == 'English' then
					BiG.Function.Server.ShowNotifcation(sourceXPlayer.source, 'You Can\'t Pickup Because Your inventory is Full.')
				elseif BiG.Config.Lang == 'Persian' then
					BiG.Function.Server.ShowNotifcation(sourceXPlayer.source, 'Inventory Shoma Por Shode ast.')
				end
    		else
    			targetXPlayer.removeInventoryItem(itemName, amount)
    			sourceXPlayer.addInventoryItem(itemName, amount)
				if BiG.Config.Lang == 'English' then
					BiG.Function.Server.ShowNotifcation(sourceXPlayer.source, 'You\'r Stole ~g~x' .. amount .. ' ~w~from ~g~' .. label .. ' ~w~ From ~y~'..GetPlayerName(targetXPlayer.source))
					BiG.Function.Server.ShowNotifcation(targetXPlayer.source, GetPlayerName(sourceXPlayer.source)' Stoled ~r~x'  .. amount .. ' ~w~from ~r~' .. label .. '~w~ From your inventory')
					BiG.Function.Server.Discord.SendLogToDiscord("Search Stole", GetPlayerName(sourceXPlayer.source), "Search Response Recived", 'Source Player Info **:** **ID** : `'..sourceXPlayer.source..'`, **OOC Name** : `'..GetPlayerName(sourceXPlayer.source)..'`,\n Target Player Info **:** **ID** : `'..targetXPlayer.source..'`, **OOC Name** : `'..GetPlayerName(targetXPlayer.source)..'`.\n **Time Stamp** : **`'..os.time()..'`**,\n**Data** : Player [**`'..GetPlayerName(sourceXPlayer.source)..'/'..sourceXPlayer.source..'`**] **Stoled** ['..amount..'x From '..label..'] from [**`'..GetPlayerName(targetXPlayer.source)..'/'..targetXPlayer.source..'`**].\n**Action** : **`Stoling Item From Player`**.')
				elseif BiG.Config.Lang == 'Persian' then
					BiG.Function.Server.ShowNotifcation(sourceXPlayer.source, 'Shoma ~g~x' .. amount .. ' ~w~az ~g~' .. label .. ' ~w~ az ~y~'..GetPlayerName(targetXPlayer.source)..'~w~ Dozdidid')
					BiG.Function.Server.ShowNotifcation(targetXPlayer.source, GetPlayerName(sourceXPlayer.source)' az Shoma ~r~x'  .. amount .. ' ~w~az ~r~' .. label .. '~w~ Dozdid')
					BiG.Function.Server.Discord.SendLogToDiscord("Search Stole", GetPlayerName(sourceXPlayer.source), "Javab Search Request Ersal Shod", 'Source Player Info **:** **ID** : `'..sourceXPlayer.source..'`, **Name OOC** : `'..GetPlayerName(sourceXPlayer.source)..'`,\n Target Player Info **:** **ID** : `'..targetXPlayer.source..'`, **Name OOC** : `'..GetPlayerName(targetXPlayer.source)..'`.\n **Time Stamp** : **`'..os.time()..'`**,\n**Data** : Player [**`'..GetPlayerName(sourceXPlayer.source)..'/'..sourceXPlayer.source..'`**], ['..amount..'x az '..label..'] Az [**`'..GetPlayerName(targetXPlayer.source)..'/'..targetXPlayer.source..'`**] **Dozdid**.\n**Action** : **`Dozdidan Item az Player`**.')
				end
    		end
    	else
			if BiG.Config.Lang == 'English' then
				BiG.Function.Server.ShowNotifcation(_source, 'Invalid Quantity')
			elseif BiG.Config.Lang == 'Persian' then
				BiG.Function.Server.ShowNotifcation(_source, 'Tedad Na Motabar ast')
			end
    	end

    elseif itemType == 'item_money' then

    	if amount > 0 and targetXPlayer.get('money') >= amount then
    		targetXPlayer.removeMoney(amount)
    		sourceXPlayer.addMoney(amount)
			if BiG.Config.Lang == 'English' then
				BiG.Function.Server.ShowNotifcation(sourceXPlayer.source, 'You\'r Stoled ' .. '~g~$' .. amount .. ' ~w~' .. 'From ~y~'..GetPlayerName(targetXPlayer.source))
				BiG.Function.Server.ShowNotifcation(targetXPlayer.source, '~y~'..GetPlayerName(sourceXPlayer.source)..'~w~ Stoled ~r~$'..amount..'~w~ from you')
				BiG.Function.Server.Discord.SendLogToDiscord("Search Stole", GetPlayerName(sourceXPlayer.source), "Javab Search Request Ersal Shod", 'Source Player Info **:** **ID** : `'..sourceXPlayer.source..'`, **Name OOC** : `'..GetPlayerName(sourceXPlayer.source)..'`,\n Target Player Info **:** **ID** : `'..targetXPlayer.source..'`, **Name OOC** : `'..GetPlayerName(targetXPlayer.source)..'`.\n **Time Stamp** : **`'..os.time()..'`**,\n**Data** : Player [**`'..GetPlayerName(sourceXPlayer.source)..'/'..sourceXPlayer.source..'`**], **Stoled** [$'..amount..'💵] From [**`'..GetPlayerName(targetXPlayer.source)..'/'..targetXPlayer.source..'`**].\n**Action** : **`Stoling Money from Player`**.')
			elseif BiG.Config.Lang == 'Persian' then
				BiG.Function.Server.ShowNotifcation(sourceXPlayer.source, 'Shoma ' .. '~g~$' .. amount .. ' ~w~' .. 'az ~y~'..GetPlayerName(targetXPlayer.source)..'~w~ Dozdidid')
				BiG.Function.Server.ShowNotifcation(targetXPlayer.source, '~y~'..GetPlayerName(sourceXPlayer.source)..'~w~ az shoma ~r~$'..amount..'~w~ Dozdid')
				BiG.Function.Server.Discord.SendLogToDiscord("Search Stole", GetPlayerName(sourceXPlayer.source), "Javab Search Request Ersal Shod", 'Source Player Info **:** **ID** : `'..sourceXPlayer.source..'`, **Name OOC** : `'..GetPlayerName(sourceXPlayer.source)..'`,\n Target Player Info **:** **ID** : `'..targetXPlayer.source..'`, **Name OOC** : `'..GetPlayerName(targetXPlayer.source)..'`.\n **Time Stamp** : **`'..os.time()..'`**,\n**Data** : Player [**`'..GetPlayerName(sourceXPlayer.source)..'/'..sourceXPlayer.source..'`**], [$'..amount..'💵] Az [**`'..GetPlayerName(targetXPlayer.source)..'/'..targetXPlayer.source..'`**] **Dozdid**.\n**Action** : **`Dozdidan Pool az Player`**.')
			end
    	else
			if BiG.Config.Lang == 'English' then
				BiG.Function.Server.ShowNotifcation(_source, 'Invalid ~g~Money ~w~Quantity')
			elseif BiG.Config.Lang == 'Persian' then
				BiG.Function.Server.ShowNotifcation(_source, 'Meghdar ~g~Pool ~w~Na Motabar ast')
			end
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
	local weapon = targetXPlayer.hasWeapon(itemName)

	if weapon then
		targetXPlayer.removeWeapon(itemName, ammo)
		sourceXPlayer.addWeapon(itemName, ammo)

		if BiG.Config.Lang == 'English' then
			BiG.Function.Server.ShowNotifcation(sourceXPlayer.source,'You\'r Stoled ' .. ' ~g~x' .. ammo .. '~w~/~g~'..itemName..'~w~ From ~y~'..GetPlayerName(targetXPlayer.source))
			BiG.Function.Server.ShowNotifcation(targetXPlayer.source, '~y~'.. GetPlayerName(sourceXPlayer.source) .. 'Stoled ~r~x'  .. ammo .. '~w~/~r~' .. itemName ..'~w~ From your inventory')
			BiG.Function.Server.Discord.SendLogToDiscord("Search Stole", GetPlayerName(sourceXPlayer.source), "Javab Search Request Ersal Shod", 'Source Player Info **:** **ID** : `'..sourceXPlayer.source..'`, **Name OOC** : `'..GetPlayerName(sourceXPlayer.source)..'`,\n Target Player Info **:** **ID** : `'..targetXPlayer.source..'`, **Name OOC** : `'..GetPlayerName(targetXPlayer.source)..'`.\n **Time Stamp** : **`'..os.time()..'`**,\n**Data** : Player [**`'..GetPlayerName(sourceXPlayer.source)..'/'..sourceXPlayer.source..'`**], **Stoled** [Gun : **'..itemName..'** with **'..ammo..'** Ammo] From [**`'..GetPlayerName(targetXPlayer.source)..'/'..targetXPlayer.source..'`**].\n**Action** : **`Stoling Weapon from Player`**.')
        elseif BiG.Config.Lang == 'Persian' then
			BiG.Function.Server.ShowNotifcation(sourceXPlayer.source,'Shoma' .. ' ~g~x' .. ammo .. '~w~/~g~'..itemName..'~w~ Az ~y~'..GetPlayerName(targetXPlayer.source)..'~w~ Dozdidid')
			BiG.Function.Server.ShowNotifcation(targetXPlayer.source, '~y~'.. GetPlayerName(sourceXPlayer.source) .. 'az Shoma ~r~x'  .. ammo .. '~w~/~r~' .. itemName ..'~w~ Ra dozdid')
			BiG.Function.Server.Discord.SendLogToDiscord("Search Stole", GetPlayerName(sourceXPlayer.source), "Javab Search Request Ersal Shod", 'Source Player Info **:** **ID** : `'..sourceXPlayer.source..'`, **Name OOC** : `'..GetPlayerName(sourceXPlayer.source)..'`,\n Target Player Info **:** **ID** : `'..targetXPlayer.source..'`, **Name OOC** : `'..GetPlayerName(targetXPlayer.source)..'`.\n **Time Stamp** : **`'..os.time()..'`**,\n**Data** : Player [**`'..GetPlayerName(sourceXPlayer.source)..'/'..sourceXPlayer.source..'`**], [Gun : **'..itemName'** ba **'..ammo..'** tir] Az [**`'..GetPlayerName(targetXPlayer.source)..'/'..targetXPlayer.source..'`**] **Dozdid**.\n**Action** : **`Dozdidan Gun az Player`**.')
        end
		if weapon.components ~= {} then
			for k,v in pairs(weapon.components) do
				sourceXPlayer.addWeaponComponent(itemName, v)
			end
		end
	end

end)