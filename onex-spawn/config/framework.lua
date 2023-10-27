Settings = {}

Settings.JailCheck = true --- It will check jail data if your server support this make it true when a jailed player join it will put him jail

Settings.EnableLastLocation = true -- If you want to disable last location spawn then make it [false].

Settings.FrameworkName = 'QBCore' -- QBCore , Esx , Vrp , Custom

Settings.GlobalTriggerNmae = "onex-spawn:setupimidiate"

if Settings.FrameworkName == "QBCore" then
    Settings.SpawnTriggerEventName = "qb-spawn:client:setupSpawns"
elseif Settings.FrameworkName == "Esx" then
    Settings.SpawnTriggerEventName = "onex-spawn:appearspawn"
elseif Settings.FrameworkName == "Vrp" then
    Settings.SpawnTriggerEventName = "playerSpawned"
elseif Settings.FrameworkName == "Custom" then
    Settings.SpawnTriggerEventName = "PlaceHolder"
end

function onPlayerloaded() -- It will run when player spawned
    if Settings.FrameworkName == "QBCore" then
        TriggerEvent('QBCore:Client:OnPlayerLoaded')
    elseif Settings.FrameworkName == "Esx" then
        TriggerEvent('esx:playerLoaded')
    elseif Settings.FrameworkName == "Vrp" then
        --- As i know vrp dosent need any load event if u have any event you can put
    elseif Settings.FrameworkName == "Custom" then
        -- If your server requre u can put
    end
end

local vrpIsonJail = false

function isPlayerOnJail()
    if Settings.FrameworkName == "QBCore" then
        local QBCore = exports['qb-core']:GetCoreObject()
        local QBPdata = QBCore.PlayerData
        if QBPdata.metadata["injail"] > 0 then
            TriggerEvent("prison:client:Enter", QBPdata.metadata["injail"])
            return true
        end
    elseif Settings.FrameworkName == "Esx" then
        -- On esx legacy wont support this 
        Settings.JailCheck = false
    elseif Settings.FrameworkName == "Vrp" then
        TriggerServerEvent("onex-spawn-vrp:requestJailInfo")
        Citizen.Wait(500)
        return vrpIsonJail
    elseif Settings.FrameworkName == "Custom" then

    end
    
    return false
end

local vrpLastlocation = vector3(-206.2997, -1014.8234, 30.1381)

function GetLastLocation() -- if Settings.EnableLastLocation enabled  
    local LastLocation = nil
    if Settings.FrameworkName == "QBCore" then
        local QBCore = exports['qb-core']:GetCoreObject()
        local QBPdata = QBCore.PlayerData
        LastLocation = vector3(QBPdata.position.x, QBPdata.position.y, QBPdata.position.z)
    elseif Settings.FrameworkName == "Esx" then
        local ESX = exports['es_extended']:getSharedObject()
        local EsxPdata = ESX.GetPlayerData() 
        LastLocation = vector3(EsxPdata.coords.x, EsxPdata.coords.y, EsxPdata.coords.z)
    elseif Settings.FrameworkName == "Vrp" then
        TriggerServerEvent("onex-spawn-vrp:requestLaslocations")
        Citizen.Wait(500)
        LastLocation = vrpLastlocation
    elseif Settings.FrameworkName == "Custom" then

    end

    return LastLocation
end

--- Vrp uitility -- dont touch 

RegisterNetEvent('onex-spawn:vrp:togglevrpJaildata')
AddEventHandler("onex-spawn:vrp:togglevrpJaildata", function(boolean)
    vrpIsonJail = boolean
end)

RegisterNetEvent('onex-spawn:vrp:lastlocdata')
AddEventHandler("onex-spawn:vrp:lastlocdata", function(vec3coords)
    vrpLastlocation = vec3coords
end)
  
  