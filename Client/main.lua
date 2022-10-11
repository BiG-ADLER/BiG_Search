-- Don't Touch These Lines
searchQueue = nil
local searchRequest = nil
if (BiG.Config.FrameWork == 'ESX') or (BiG.Config.FrameWork == 'ESS') then
    ESX = nil
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(0)
        end
    end)
end

-- Event Side

RegisterNetEvent('BiG_Search:checkSearchAvailable')
AddEventHandler('BiG_Search:checkSearchAvailable', function(target)

    local pPed = GetPlayerPed(-1)
    local pCoords = GetEntityCoords(pPed)

    local tPlayer = GetPlayerFromServerId(target)
    local tPed = GetPlayerPed(tPlayer)
    local tCoords = GetEntityCoords(tPed)

    local distance = #(pCoords - tCoords)

    if distance > BiG.Config.MaxDistance then
        BiG.Function.Client.SendMessage('ID Mored Nazar Az Shoma Kheyli door ast .')
        return
    end
    searchRequest = target
    Citizen.CreateThread(function()
        Citizen.Wait(BiG.Config.AcceptTime)
        searchRequest = nil
    end)
end)

RegisterNetEvent('BiG_Search:acceptSearch')
AddEventHandler('BiG_Search:acceptSearch', function(target)

    if target ~= searchRequest then return end

    local player = GetPlayerFromServerId(target)
    ESX.TriggerServerCallback('esx:getOtherPlayerDataCard', function(data)

        local elements = {}
        table.insert(elements, {label = '--- Money ---', value = nil})

        table.insert(elements, {label =  ESX.Math.GroupDigits(data.money), value = nil})

        table.insert(elements, {label = '--- Guns ---', value = nil})

        for i=1, #data.weapons, 1 do
            table.insert(elements, {
                label    = 'weapon: '.. ESX.GetWeaponLabel(data.weapons[i].name),
                value    = data.weapons[i].name,
                itemType = 'item_weapon',
                amount   = data.weapons[i].ammo
            })
        end

        table.insert(elements, {label = '--- Inventory Items ---', value = nil})

        for i=1, #data.inventory, 1 do
            if data.inventory[i].count > 0 then
                table.insert(elements, {
                    label    = ''.. data.inventory[i].count..'x ' ..data.inventory[i].label,
                    value    = data.inventory[i].name,
                    itemType = 'item_standard',
                    amount   = data.inventory[i].count
                })
            end
        end


        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'body_search',
                {
                    title    = 'search',
                    align    = 'top-left',
                    elements = elements,
                },
                function(data, menu)

                    local itemType = data.current.itemType
                    local itemName = data.current.value
                    local amount   = data.current.amount

                    if data.current.value ~= nil then
                        TriggerServerEvent('esx:confiscatePlayerItem', GetPlayerServerId(player), itemType, itemName, amount)
                        OpenBodySearchMenu(player)
                    end

                end, function(data, menu)
                    menu.close()
                end)

    end, GetPlayerServerId(player))
end)