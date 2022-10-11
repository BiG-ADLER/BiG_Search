-- Don't Touch
Spams = {}
local searchQueue = nil
local searchRequest = nil

--Main Command
RegisterCommand('search', function(source, args)

    -- Local Variables 
    local PlayerSource = source
    local PlayerSourceName = GetPlayerName(PlayerSource) -- Get source player name 
    local ArgumentOne = args[1] -- Just i Wanna choose name for args[1]
    local TargetPlayerID = tonumber(ArgumentOne) -- TargetPlayerID for request search from searcher
    local TargetPlayerNameFromID = GetPlayerName(args[1]) -- Get target player Name 
    local ArgumentOneString = string.lower(ArgumentOne) -- for get {"accept" OR "decline"} in Argument 1
    local ArgumentOneNumber = tonumber(ArgumentOne) -- for get ID in Argument 1
    local PlayerSourceCoordinate = GetEntityCoords(GetPlayerPed(PlayerSource)) -- Searcher Player Coordinate
	local TargetPlayerCoordinate = GetEntityCoords(GetPlayerPed(args[1])) -- Target Player Coordinate
	local DistanceBetweenPlayers = BiG.Function.Server.GetDistanceBetweenPlayers(PlayerSourceCoordinate, TargetPlayerCoordinate) -- Get Distance Between SourcePlayer and Target 

    if not ArgumentOne then
        if BiG.Config.Lang == 'English' then
            BiG.Function.Server.SendMessage(PlayerSource, 'You Should Enter ^2Argument^0 First')
        elseif BiG.Config.Lang == 'Persian' then
            BiG.Function.Server.SendMessage(PlayerSource, 'Shoma Dar Ghesmat ^2Argument^0 Bayad ^3Value ^0Vared Konid')
        end
    end

    if ArgumentOneNumber then
--[[        if TargetPlayerID == PlayerSource then
            if BiG.Config.Lang == 'English' then
                BiG.Function.Server.SendMessage(PlayerSource, 'You ^8Cant ^2Search ^0your inventory')
            elseif BiG.Config.Lang == 'Persian' then
                BiG.Function.Server.SendMessage(PlayerSource, 'Shoma ^8Nemitavanid ^0 Inventory khod ra ^2Search^0 Konid')
            end
            return
        end]]

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

                TriggerClientEvent('BiG_Search:acceptSearch', PlayerSource)
                if BiG.Config.Lang == 'English' then
                    BiG.Function.Server.SendMessage(PlayerSource, '^8[^4'..GetPlayerName(PlayerSource)..'^0/^4'..PlayerSource..'^8]^0 ^2Accepted ^0your search requests.')
                elseif BiG.Config.Lang == 'Persian' then
                    BiG.Function.Server.SendMessage(PlayerSource, '^8[^4'..GetPlayerName(PlayerSource)..'^0/^4'..PlayerSource..'^8]^0 Darkhast Search Shomara ^2Accept ^0Kard.')
                end

            end
        elseif ArgumentOneString == "decline" then
            print("decline work")
        end
    end

end, false)

-- Event Side
RegisterNetEvent('BiG_Search:acceptSearch')
AddEventHandler('BiG_Search:acceptSearch', function(searcher)

end)

RegisterNetEvent('BiG_Search:denySearch')
AddEventHandler('BiG_Search:denySearch', function(searcher)
    local PlayerSource = source
    if searchQueue == nil then

        if BiG.Config.Lang == 'English' then
            BiG.Function.Server.SendMessage(PlayerSource, 'You Don\'t have any ^2Active ^8Search ^0Request')
        elseif BiG.Config.Lang == 'Persian' then
            BiG.Function.Server.SendMessage(PlayerSource,'Shoma darkhast ^8Search ^2Active^0 Nadarid.')
        end
        return

    else

        if BiG.Config.Lang == 'English' then
            BiG.Function.Server.SendMessage(PlayerSource, '^8[^4'..GetPlayerName(PlayerSource)..'^0/^4'..PlayerSource..'^8]^0 ^2Declined ^0your search requests.')
        elseif BiG.Config.Lang == 'Persian' then
            BiG.Function.Server.SendMessage(PlayerSource, '^8[^4'..GetPlayerName(PlayerSource)..'^0/^4'..PlayerSource..'^8]^0 Darkhast Search Shoma ra ^2Decline ^0Kard.')
        end

    end
end)

RegisterNetEvent('BiG_Search:requestSearch')
AddEventHandler('BiG_Search:requestSearch', function(SourcePlayer, TargetPlayer)

    local PlayerSourceCoordinate = GetEntityCoords(GetPlayerPed(SourcePlayer)) -- Searcher Player Coordinate
	local TargetPlayerCoordinate = GetEntityCoords(GetPlayerPed(TargetPlayer)) -- Target Player Coordinate
	local DistanceBetweenPlayers = BiG.Function.Server.GetDistanceBetweenPlayers(PlayerSourceCoordinate, TargetPlayerCoordinate) -- Get Distance Between SourcePlayer and Target 

    if DistanceBetweenPlayers > BiG.Config.MaxDistance then return end

    BiG.Function.Server.SendMessage(TargetPlayer,'^8[^4'..GetPlayerName(SourcePlayer)..'^0/^4'..SourcePlayer..'^8] ^0Mikhahad Shomara search konad , Baraye Accept Kardan Command ^0/search^2 accept ^0 Ra Vared Konid va Baraye Deny Kardan Command ^0/search^8 deny ^0ra vared konid .')

    searchQueue = source
    Citizen.CreateThread(function()
        Citizen.Wait(BiG.Config.AcceptTime)
        searchQueue = nil
    end)
end)