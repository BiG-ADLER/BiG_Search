-- Don't Touch
BiG = {}

-- Config Tables [Don't Touch]
BiG.Config = {}
BiG.Config.Discord = {}
BiG.Config.Discord.Webhook = {}

-- Function Tables [Don't Touch]
BiG.Function = {}
BiG.Function.Client = {}
BiG.Function.Server = {}
BiG.Function.Server.Discord = {}

-- Config Side
BiG.Config.Lang = 'English' -- Just Choose between { 'English' & 'Persian' }
BiG.Config.SpamTime = 4000 -- Time Between Every Search Request and Please Choose ms { 1000ms = 1s }
BiG.Config.MaxDistance = 2 -- Distance will be required to search player
BiG.Config.AcceptTime = 10000 -- Max Accept Time & Please Choose ms { 1000ms = 1s }
BiG.Config.ESXEventString = 'esx:getSharedObject' -- Write your event for connect resource to your Base
BiG.Config.Discord.ServerName = 'BiG Community' -- Write Here your server Community name
BiG.Config.Discord.Webhook.Link = 'https://discord.com/api/webhooks/1030537380110807040/pKK1z07klK5SkGONq8VrpJhOTvm3MRYv7JFuVePjDoK2uBE9USMibqRWA6R5JTrBs2c4' -- Write you discord webhook link here
BiG.Config.Discord.Webhook.AvatarLink = 'https://cdn.discordapp.com/attachments/986628595415916544/1025835093425672315/Png--finall.png?size=1024' -- Write your Avatar url for webhook here

-- Functions Side
-- Functions Help : This Function send native message to player and show in player screen.
function BiG.Function.Client.ShowNotification(StringMessage)
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(StringMessage)
    EndTextCommandThefeedPostTicker(0, 1)
end

-- Functions Help : This Function send message to player in chat and sended in client side.
function BiG.Function.Client.SendMessage(StringMessage)
    TriggerEvent('chatMessage', '[SYSTEM]', {255, 0, 0}, StringMessage)
end

-- Functions Help : This Function show Target player inventory include a menu and work with {esx_menu_default}
function BiG.Function.Client.ShowTargetPlayerInventory(TargetPlayer)
    ESX.TriggerServerCallback('BiG_Search:ShowTargetPlayerInventory', function(data)
        local elements = {}
        table.insert(elements, {label = '--- Money ---', value = nil})

        table.insert(elements, {label =  ESX.Math.GroupDigits(data.money), value = nil})

        table.insert(elements, {label = '--- Weapons ---', value = nil})

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
                    title    = 'Search Menu',
                    align    = 'top-left',
                    elements = elements,
                },
                function(data, menu)

                    local itemType = data.current.itemType
                    local itemName = data.current.value
                    local amount   = data.current.amount

                    if data.current.value ~= nil then
                        TriggerServerEvent('BiG_Search:ConfiscateTargetPlayerItems', GetPlayerServerId(TargetPlayer), itemType, itemName, amount)
                        BiG.Function.Client.ShowTargetPlayerInventory(TargetPlayer)
                    end

                end, function(data, menu)
                    menu.close()
                end)

    end, GetPlayerServerId(TargetPlayer))
end

-- Functions Help : This Function send message to player in chat and sended in server side.
function BiG.Function.Server.SendMessage(PlayerSource, StringMessage)
    TriggerClientEvent('chatMessage', PlayerSource, '[SYSTEM]', {255, 0, 0}, StringMessage)
end

-- Functions Help : This Function send native notification to player from server side
function BiG.Function.Server.ShowNotifcation(PlayerSource, StringMessage)
    TriggerClientEvent('BiG_Search:ShowNativeNotification', PlayerSource, StringMessage)
end

-- Functions Help : This Function get Distance between 2 players and writed in server side for server side 
function BiG.Function.Server.GetDistanceBetweenPlayers(ObjectA, ObjectB)
    return #(vector3(ObjectA.x, ObjectA.y, ObjectA.z) - vector3(ObjectB.x, ObjectB.y, ObjectB.z))
end

-- Functions Help : This Function Send Embed log to selected Discord Channel 
function BiG.Function.Server.Discord.SendLogToDiscord(EmbedTitle, UsernameOfWebhook, NameOfFieldOne, ValueOfFieldOne)
    PerformHttpRequest(BiG.Config.Discord.Webhook.Link, function(err, text, headers) end, 'POST', json.encode({
        embeds = {
            {
                title = EmbedTitle,
                fields = {
                    {
                        name = NameOfFieldOne,
                        value = ValueOfFieldOne
                    }
                },
                footer = {
                    text = BiG.Config.Discord.ServerName.." - "..os.date('%d/%m/%Y | %H:%M:%S')
                },
                color = 2031360
            }
        },
        username = UsernameOfWebhook,
        avatar_url = BiG.Config.Discord.Webhook.AvatarLink
    }), {["Content-Type"] = "application/json"})
end