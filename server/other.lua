
function authorized()
  print("RTX CARRY - THANKS FOR CHOOSE US - https://discord.gg/4AfA9grUtF")
end

RTXCARRY = {}
RTXCARRY.ServerCallbacks = {}
RegisterServerEvent("RTXCARRY:triggerServerCallback")
AddEventHandler("RTXCARRY:triggerServerCallback", function(a, b)
  RTXCARRY.TriggerServerCallback(a, requestID, source, function()
    TriggerClientEvent("RTXCARRY:serverCallback", a, b)
  end)
end)
function RTXCARRY.RegisterServerCallback(a, b)
  RTXCARRY.ServerCallbacks[a] = b
end
function RTXCARRY.TriggerServerCallback(a, b, c, d)
  if RTXCARRY.ServerCallbacks[a] ~= nil then
    RTXCARRY.ServerCallbacks[a](c, d)
  end
end
RTXCARRY.RegisterServerCallback("rtx_carry:IsPlayerCarryed", function(a, b, c, d)
  if va == "SwMmhk0kWCcFEYte0cQpToMcBAVxXWQY" then
    PlayerInMenu[a] = false
    if PlayerInMenu[c] == nil then
      if PlayerCarrySomeone[c] == nil then
        if PlayerCarryed[a] == nil then
          if PlayerCarryed[c] == nil then
            if RequestedPlayerSender[a] == nil then
              if RequestedPlayerSender[c] == nil then
                if RequestedPlayerSender[c] == nil then
                  RequestedPlayerSender[a] = true
                  RequestedPlayer[c] = true
                  TriggerClientEvent("rtx_carry:ShowRequestPlayerReceiever", c, a, d)
                  b(true)
                else
                  b("targethaverequestfromsomeone")
                end
              else
                b("targethaverequestfromsomeone")
              end
            else
              b("alreadysentrequest")
            end
          else
            b("targetalreadycarry")
          end
        else
          b("youarecarryed")
        end
      else
        b("playercarrysomeone")
      end
    else
      b("playerincarrymenu")
    end
  end
end)
RTXCARRY.RegisterServerCallback("rtx_carry:CheckCarryStatus", function(a, b, c, d)
  if va == "SwMmhk0kWCcFEYte0cQpToMcBAVxXWQY" then
    if PlayerInMenu[c] == nil then
      if PlayerCarrySomeone[c] == nil then
        if PlayerCarryed[a] == nil then
          if PlayerCarryed[c] == nil then
            if RequestedPlayerSender[a] == nil then
              if RequestedPlayerSender[c] == nil then
                if RequestedPlayerSender[c] == nil then
                  PlayerInMenu[a] = true
                  b(true)
                else
                  b("targethaverequestfromsomeone")
                end
              else
                b("targethaverequestfromsomeone")
              end
            else
              b("alreadysentrequest")
            end
          else
            b("targetalreadycarry")
          end
        else
          b("youarecarryed")
        end
      else
        b("playercarrysomeone")
      end
    else
      b("playerincarrymenu")
    end
  end
end)
RegisterServerEvent("E6kTCRgT9AII8jtbYYY2yTcys9dvUEpH")
AddEventHandler("E6kTCRgT9AII8jtbYYY2yTcys9dvUEpH", function(a)
  if va == "SwMmhk0kWCcFEYte0cQpToMcBAVxXWQY" then
    TriggerClientEvent("QNopgNuSfikTW93r16lqPJXsnqCl8VVH", a, "Af5lUj58SxGv21KKQGNUqEkiZGlmIbUH")
  end
end)
