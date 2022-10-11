-- Don't Touch
BiG = {}
BiG.Config = {}
BiG.Function = {}
BiG.Function.Client = {}
BiG.Function.Server = {}

-- Config Side
BiG.Config.FrameWork = 'ESX' -- Just choose between this words { 'ESX', 'ESX_Legacy', 'ESS' }
BiG.Config.Lang = 'Persian' -- Just Choose between { 'English' & 'Persian' }
BiG.Config.SpamTime = 2000 -- Time Between Every Search Request and Please Choose ms { 1000ms = 1s }
BiG.Config.MaxDistance = 1 -- Distance will be required to search player
BiG.Config.AcceptTime = 10000 -- Max Accept Time & Please Choose ms { 1000ms = 1s }

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

-- Functions Help : This Function send message to player in chat and sended in server side.
function BiG.Function.Server.SendMessage(PlayerSource, StringMessage)
    TriggerClientEvent('chatMessage', PlayerSource, '[SYSTEM]', {255, 0, 0}, StringMessage)
end

-- Functions Help : This Function get Distance between 2 players and writed in server side for server side 
function BiG.Function.Server.GetDistanceBetweenPlayers(objA, objB)
    local xDist = objB.x - objA.x
    local yDist = objB.y - objA.y
    return math.sqrt((xDist ^ 2) + (yDist^2))
end