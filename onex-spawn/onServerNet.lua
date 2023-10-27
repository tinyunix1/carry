RegisterServerEvent("onex-spawn-vrp:requestJailInfo")
AddEventHandler("onex-spawn-vrp:requestJailInfo", function()
    local Tunnel = module('vrp','lib/Tunnel')
    local Proxy = module('vrp','lib/Proxy')
    local vRP = Proxy.getInterface('vRP')

    local src = source
    local user_id = vRP.getUserId({src})

    vRP.getUData({user_id, "vRP:jail:time", function(value)
        if value ~= nil then
            TriggerClientEvent("onex-spawn:vrp:togglevrpJaildata", src , true)
            -- break
        end
    end})

    TriggerClientEvent("onex-spawn:vrp:togglevrpJaildata", src , false)
end)


RegisterServerEvent("onex-spawn-vrp:requestLaslocations")
AddEventHandler("onex-spawn-vrp:requestLaslocations", function()
    local Tunnel = module('vrp','lib/Tunnel')
    local Proxy = module('vrp','lib/Proxy')
    local vRP = Proxy.getInterface('vRP')

    local src = source
    local user_id = vRP.getUserId({src})
    local VrpData = vRP.getUserDataTable({user_id})

    TriggerClientEvent("onex-spawn:vrp:lastlocdata", src , vector3(VrpData.position.x,VrpData.position.y,VrpData.position.z))
end)
