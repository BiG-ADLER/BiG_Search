RegisterCommand('heal', function(source, args)

	local xPlayer = ESX.GetPlayerFromId(source)

	if not args[1] then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "^0Shoma dar argument aval chizi vared nakardid")
		return
	end

	if not tonumber(args[1]) then
		local input = string.lower(args[1])
		if input == "accept" then
			local identifier = GetPlayerIdentifier(source)
			if heals[identifier] then
				local heal = heals[identifier]
				local zPlayer = ESX.GetPlayerFromIdentifier(heal.target)
				if zPlayer then
					if xPlayer.bank >= 1000 then
						if getDistance(GetEntityCoords(GetPlayerPed(source)), GetEntityCoords(heal.ped)) < 1 then
							heals[identifier] = nil
							xPlayer.removeBank(1000)
							zPlayer.addBank(250)
							TriggerClientEvent('esx_ambulancejob:healr', source)
							TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "^0Shoma ba movafagiat heal shodid!")
							TriggerClientEvent('chatMessage', zPlayer.source, "[SYSTEM]", {255, 0, 0}, "^2" .. GetPlayerName(source) .. "^0 darkhast heal shoma ra ghabol kard!")
						else
							TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "^0Shoma az shakhsi ke baraye shoma darkhast heal ferestade ast dor hastid!")
						end
					else
						TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "^0Shoma baraye ghabol kardan darkhast heal niaz be ^21000$ ^0darid!")
					end
				else
					TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "^0Kasi ke baraye shoma darkhast heal ferestade shahr ra tark karde ast!")
				end
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "^0Shoma hich requeste heali nadarid!")
			end
		elseif input == "decline" then
			local identifier = GetPlayerIdentifier(source)
			if heals[identifier] then
				heals[identifier] = nil
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "^0Darkhast heal shoma ba movafaghiat baste shod!")
			else
				TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "^0Shoma hich requeste heali nadarid!")
			end
		else
			TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "^0Syntax vared shode eshtebah ast!")
			return
		end
		return
	end
	
	if xPlayer.job.name ~= "ambulance" then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "^0Shoma medic nistid!")
		return
	end

	local target = tonumber(args[1])

	if target == source then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "^0Shoma nemitavanid be khodetan darkhast heal befrestid!")
		return
	end

	local name = GetPlayerName(target)

	if not name then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "^0ID vared shode eshtebah ast!")
		return
	end
	local identifier = GetPlayerIdentifier(target)

	if heals[identifier] then
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "^0In player yek darkhast heal baz darad!")
		return
	end

	local coords = GetEntityCoords(GetPlayerPed(source))
	local tcoords = GetEntityCoords(GetPlayerPed(target))
	local distance = getDistance(coords, tcoords)
	
	if distance < 1 then
		heals[identifier] = {time = os.time(), ped = GetPlayerPed(source), target = GetPlayerIdentifier(source)}
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "^0Darkhast heal ba ^2movafaghiat ^0 be ^3" .. name  .. "^0 ferestade shod!")
		TriggerClientEvent('chatMessage', target, "[SYSTEM]", {255, 0, 0}, "^0Shoma yek darkhast heal az ^2" .. GetPlayerName(source) .. "^0 daryaft kardid! (/heal accept)")
	else
		TriggerClientEvent('chatMessage', source, "[SYSTEM]", {255, 0, 0}, "^0Fasele shoma az player mored niaz ziad ast!")
	end
	
end, false)

-------fx_version 'cerulean'
game 'gta5'

author ''
description ''
version '1.0.0'

client_script 'client/*.lua'
server_script 'server/*.lua'
shared_script 'shared/*.lua'

