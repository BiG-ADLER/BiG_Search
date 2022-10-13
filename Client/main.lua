-- Don't Touch These Lines
ESX = nil
local searchQueue = nil
local searchRequest = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(BiG.Config.ESXEventString, function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)


-- Event Side

RegisterNetEvent('BiG_Search:checkSearchAvailable')
AddEventHandler('BiG_Search:checkSearchAvailable', function(TargetPlayerID)

    local PlayerPed = GetPlayerPed(-1)
    local PlayerCoordinate = GetEntityCoords(PlayerPed)

    local TargetPlayer = GetPlayerFromServerId(TargetPlayerID)
    local TargetPlayerPed = GetPlayerPed(TargetPlayer)
    local TargetPlayerCoordinate = GetEntityCoords(TargetPlayerPed)

    local DistanceBetweenPlayers = #(PlayerCoordinate - TargetPlayerCoordinate)

    if DistanceBetweenPlayers > BiG.Config.MaxDistance then
        if BiG.Config.Lang == 'English' then
            BiG.Function.Server.SendMessage(PlayerSource, '^0Target ^2Player^0 is ^1Too ^0far from you')
        elseif BiG.Config.Lang == 'Persian' then
            BiG.Function.Client.SendMessage('^2ID ^0Mored Nazar Az Shoma Kheyli ^1Door ^0ast .')
        end
        return
    end
    searchRequest = TargetPlayerID
    Citizen.CreateThread(function()
        Citizen.Wait(BiG.Config.AcceptTime)
        searchRequest = nil
    end)
end)


RegisterNetEvent('BiG_Search:acceptSearch')
AddEventHandler('BiG_Search:acceptSearch', function(TargetPlayerID)
    if TargetPlayerID ~= searchRequest then return end
    local PlayerServerID = GetPlayerFromServerId(TargetPlayerID)
    BiG.Function.Client.ShowTargetPlayerInventory(PlayerServerID)
end)

RegisterNetEvent('BiG_Search:RemoveWeaponFromTargetPlayerPed')
AddEventHandler('BiG_Search:RemoveWeaponFromTargetPlayerPed', function(gun,ammo,to)
	RemoveWeaponFromPed(GetPlayerPed(player), GetHashKey(gun))
	TriggerServerEvent('BiG_Search:RemoveWeaponFromTargetPlayerInventory', to, gun, ammo)
end)