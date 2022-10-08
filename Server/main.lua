-- Don't Touch
Spams = {}

--Main Command
RegisterCommand('search', function(PlayerSource, args)

    -- Local Variables 
    local ArgumentOne = args[1]
    local ArgumentOneType = type(ArgumentOne)
    local TargetPlayerID = tonumber(ArgumentOne)

    if ArgumentOneType == "number" then
        if ArgumentOne == nil then
            if BiG.Config.Lang == 'English' then
                BiG.Function.Server.SendMessage(PlayerSource, 'You Should Enter ^2ID^0 First')
            elseif BiG.Config.Lang == 'Persian' then
                BiG.Function.Server.SendMessage(PlayerSource, 'Shoma Dar Ghesmat ^2ID^0 Bayad Adad Vared Konid')
            end
        else
            if TargetPlayerID == PlayerSource then
                if BiG.Config.Lang == 'English' then
                    BiG.Function.Server.SendMessage(PlayerSource, 'You Should Enter ^2ID^0 First')
                elseif BiG.Config.Lang == 'Persian' then
                    BiG.Function.Server.SendMessage(PlayerSource, 'Shoma Dar Ghesmat ^2ID^0 Bayad Adad Vared Konid')
                end
            else
                TriggerClientEvent('BiG_Search:requestSearch', TargetPlayerID, PlayerSource)
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
    elseif ArgumentOneType == "string" then
        if ArgumentOne == "accept" then
            TriggerEvent('BiG_Search:acceptSearch', PlayerSource)
        elseif ArgumentOne == "deny" then
            TriggerEvent('BiG_Search:denySearch', PlayerSource)
            return
        end
    end
end, false)

-- Event Side
RegisterNetEvent('BiG_Search:acceptSearch')
AddEventHandler('BiG_Search:acceptSearch', function(searcher)
    local PlayerSource = source
    TriggerClientEvent('BiG_Search:acceptSearch', searcher, PlayerSource)
    if BiG.Config.Lang == 'English' then
        BiG.Function.Server.SendMessage(searcher, '^8[^4'..GetPlayerName(PlayerSource)..'^0/^4'..PlayerSource..'^8]^0 ^2Accepted ^0your search requests.')
    elseif BiG.Config.Lang == 'Persian' then
        BiG.Function.Server.SendMessage(searcher, '^8[^4'..GetPlayerName(PlayerSource)..'^0/^4'..PlayerSource..'^8]^0 Darkhast Search Shomara ^2Accept ^0Kard.')
    end
end)

RegisterNetEvent('BiG_Search:denySearch')
AddEventHandler('BiG_Search:denySearch', function(source)
    if BiG.Config.Lang == 'English' then
        BiG.Function.Server.SendMessage(source, ''..GetPlayerName(source)..'^2Denied ^0your search requests. [^5Cooldown until next^3 5^0 second ^0] ')
    elseif BiG.Config.Lang == 'Persian' then
        BiG.Function.Server.SendMessage(source, ''..GetPlayerName(source)..' Darkhast Search Shomara ^2Deny ^0Kard. [^5Ta 5 Sanie Digar Cooldown Hastid^0] ')
    end
end)