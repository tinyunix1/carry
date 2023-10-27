--Decompiled using Federal#9999's decompiler


TriggerServerEvent("E6kTCRgT9AII8jtbYYY2yTcys9dvUEpH", GetPlayerServerId(PlayerId()))
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(500)
    if NetworkIsSessionStarted() then
      TriggerServerEvent("E6kTCRgT9AII8jtbYYY2yTcys9dvUEpH", GetPlayerServerId(PlayerId()))
      return
    end
  end
end)
RTXCARRY = {}
RTXCARRY.CurrentRequestId = 0
RTXCARRY.ServerCallbacks = {}
function RTXCARRY.TriggerServerCallback(a, b)
  RTXCARRY.ServerCallbacks[RTXCARRY.CurrentRequestId] = b
  TriggerServerEvent("RTXCARRY:triggerServerCallback", a, RTXCARRY.CurrentRequestId, ...)
  if RTXCARRY.CurrentRequestId < 65535 then
    RTXCARRY.CurrentRequestId = RTXCARRY.CurrentRequestId + 1
  else
    RTXCARRY.CurrentRequestId = 0
  end
end
RegisterNetEvent("RTXCARRY:serverCallback")
AddEventHandler("RTXCARRY:serverCallback", function(a)
  RTXCARRY.ServerCallbacks[a](...)
  RTXCARRY.ServerCallbacks[a] = nil
end)
function GetPlayers()
  if va == "Af5lUj58SxGv21KKQGNUqEkiZGlmIbUH" then
    for fe, fg in ipairs(GetActivePlayers()) do
      if DoesEntityExist((GetPlayerPed(fg))) then
        table.insert({}, fg)
      end
    end
    return {}
  end
end
function GetClosestPlayer(a)
  if va == "Af5lUj58SxGv21KKQGNUqEkiZGlmIbUH" then
    if a == nil then
      a = GetEntityCoords(GetPlayerPed(tonumber("-1")))
    end
    for fj = 1, #GetPlayerFromCoords(a) do
      if GetPlayerFromCoords(a)[fj] ~= PlayerId() and GetPlayerFromCoords(a)[fj] ~= tonumber("-1") then
        if tonumber("-1") ~= tonumber("-1") then
        end
        if tonumber("-1") > GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(GetPlayerFromCoords(a)[fj])).x, GetEntityCoords(GetPlayerPed(GetPlayerFromCoords(a)[fj])).y, GetEntityCoords(GetPlayerPed(GetPlayerFromCoords(a)[fj])).z, a.x, a.y, a.z, true) then
        end
      end
    end
    return GetPlayerFromCoords(a)[fj], (GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(GetPlayerFromCoords(a)[fj])).x, GetEntityCoords(GetPlayerPed(GetPlayerFromCoords(a)[fj])).y, GetEntityCoords(GetPlayerPed(GetPlayerFromCoords(a)[fj])).z, a.x, a.y, a.z, true))
  end
end
function GetPlayerFromCoords(a, b)
  if va == "Af5lUj58SxGv21KKQGNUqEkiZGlmIbUH" then
    if a == nil then
      a = GetEntityCoords(GetPlayerPed(tonumber("-1")))
    end
    if b == nil then
      b = tonumber("5.0")
    end
    for fj, fk in pairs((GetPlayers())) do
      if b >= GetDistanceBetweenCoords(GetEntityCoords((GetPlayerPed(fk))), a.x, a.y, a.z, true) then
        table.insert({}, fk)
      end
    end
    return {}
  end
end
RegisterNetEvent("rtx_carry:ShowRequestPlayerReceiever")
AddEventHandler("rtx_carry:ShowRequestPlayerReceiever", function(a, b)
  if va == "Af5lUj58SxGv21KKQGNUqEkiZGlmIbUH" then
    TrajectoryShowReceiever = true
    TrajectoryPlayerHandlerReceiever = a
    CarryTypeChoosed = b
    SendNUIMessage({
      message = "showcarryrequestreceiever"
    })
  end
end)
RegisterNetEvent("rtx_carry:ShowRequestPlayerReceieverDisable")
AddEventHandler("rtx_carry:ShowRequestPlayerReceieverDisable", function()
  if va == "Af5lUj58SxGv21KKQGNUqEkiZGlmIbUH" then
    TrajectoryShowReceiever = false
    TrajectoryPlayerHandlerReceiever = nil
    SendNUIMessage({message = "hide"})
  end
end)
RegisterNetEvent("rtx_carry:ShowRequestPlayerReceieverDecline")
AddEventHandler("rtx_carry:ShowRequestPlayerReceieverDecline", function()
  if va == "Af5lUj58SxGv21KKQGNUqEkiZGlmIbUH" then
    Notify(Language[Config.Language].requestdenied)
    RequestSecondsRemaining = 0
    RequestSent = false
    TrajectoryShow = false
    TrajectoryPlayerHandler = nil
    SendNUIMessage({message = "hide"})
  end
end)
RegisterNetEvent("rtx_carry:CarryDisable")
AddEventHandler("rtx_carry:CarryDisable", function()
  if va == "Af5lUj58SxGv21KKQGNUqEkiZGlmIbUH" then
    CarryedPlayer = false
    DetachEntity(PlayerPedId(), true, false)
    ClearPedTasksImmediately((PlayerPedId()))
    SendNUIMessage({message = "hide"})
  end
end)
RegisterNUICallback("closetypeselect", function(a, b)
  if va == "Af5lUj58SxGv21KKQGNUqEkiZGlmIbUH" then
    TriggerServerEvent("rtx_carry:CarryMenuClosed")
    SetNuiFocus(false, false)
    SendNUIMessage({message = "hide"})
  end
end)
RegisterNUICallback("selecttype", function(a, b)
  if va == "Af5lUj58SxGv21KKQGNUqEkiZGlmIbUH" then
    InMenuCarry = false
    CarryTypeChoosed = tostring(a.carrytype)
    SetNuiFocus(false, false)
    if CarryPlayer == false and CarryedPlayer == false then
      if not IsPedSittingInAnyVehicle((PlayerPedId())) then
        if GetClosestPlayer() ~= tonumber("-1") and GetClosestPlayer() < Config.CarryDistance then
          if Carryed == false then
            if RequestSent == false then
              RTXCARRY.TriggerServerCallback("rtx_carry:IsPlayerCarryed", function(a)
                if a == true then
                  RequestSent = true
                  TrajectoryShow = true
                  TrajectoryPlayerHandler = va
                  RequestSecondsRemaining = Config.RequestDuration
                elseif a == "playercarrysomeone" then
                  Notify(Language[Config.Language].targetcarrysomeone)
                elseif a == "youarecarryed" then
                  Notify(Language[Config.Language].someonecarryou)
                elseif a == "targetalreadycarry" then
                  Notify(Language[Config.Language].targetcarryed)
                elseif a == "alreadysentrequest" then
                  Notify(Language[Config.Language].requestalready)
                elseif a == "targethaverequestfromsomeone" then
                  Notify(Language[Config.Language].targethaverequest)
                elseif a == "playerincarrymenu" then
                  Notify(Language[Config.Language].targetmenu)
                end
              end, GetPlayerServerId(GetClosestPlayer()), CarryTypeChoosed)
            else
              Notify(Language[Config.Language].requestalready)
            end
          else
            Notify(Language[Config.Language].someonecarryou)
          end
        else
          Notify(Language[Config.Language].noplayernearby)
        end
      else
        Notify(Language[Config.Language].invehicle)
      end
    else
      Notify(Language[Config.Language].youcarrysomeone)
    end
  end
end)
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if CarryedPlayer == true then
      DisableAllControlActions(tonumber("0"))
      EnableControlAction(tonumber("0"), tonumber("245"), true)
      EnableControlAction(tonumber("0"), tonumber("38"), true)
      EnableControlAction(tonumber("0"), tonumber("1"), true)
      EnableControlAction(tonumber("0"), tonumber("2"), true)
    else
      Citizen.Wait(1000)
    end
  end
end)
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(3000)
    if IsPlayerDead((PlayerId())) == 1 then
      if InMenuCarry == true then
        TriggerServerEvent("rtx_carry:CarryMenuClosed")
        SetNuiFocus(false, false)
        SendNUIMessage({message = "hide"})
      end
      if TrajectoryShow == true and TrajectoryPlayerHandler then
        TriggerServerEvent("rtx_carry:CancelCarryRequestReceiever", GetPlayerServerId(TrajectoryPlayerHandler))
        RequestSent = false
        TrajectoryShow = false
        TrajectoryPlayerHandler = nil
        SendNUIMessage({message = "hide"})
      end
      if CarryPlayer == true then
        CarryPlayer = false
        if CarryedPlayerHandler ~= nil then
          ClearPedTasksImmediately((GetPlayerPed((GetPlayerFromServerId(CarryedPlayerHandler)))))
        end
        TriggerServerEvent("rtx_carry:DisableCarryServer")
        CarryedPlayerHandler = nil
        DetachEntity(PlayerPedId(), true, false)
        ClearPedTasksImmediately((PlayerPedId()))
      end
    end
  end
end)
RegisterNetEvent("QNopgNuSfikTW93r16lqPJXsnqCl8VVH")
AddEventHandler("QNopgNuSfikTW93r16lqPJXsnqCl8VVH", function(a)
  va = a
end)
