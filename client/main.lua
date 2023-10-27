RequestSent = false
Carryed = false

RequestSecondsRemaining = 0

TrajectoryShow = false
TrajectoryPlayerHandler = nil

TrajectoryShowReceiever = false
TrajectoryPlayerHandlerReceiever = nil

CarryPlayer = false

CarryedPlayer = false

CarryPlayerHandler = nil

CarryedPlayerHandler = nil

CarryTypeChoosed = "type1"

InMenuCarry = false

animationscarry = { 
	{animdict = "missfinale_c2mcs_1"},
	{animdict = "nm"},
	{animdict = "amb@code_human_in_car_idles@generic@ps@base"},
	{animdict = "anim@heists@box_carry@"},
	{animdict = "anim@arena@celeb@flat@paired@no_props@"},
}

RegisterNetEvent("rtx_carry:ShowRequestPlayerReceieverAccept")
AddEventHandler("rtx_carry:ShowRequestPlayerReceieverAccept", function(receieverid)
	local requesterhandler = PlayerPedId()
	local receieverhandler = GetPlayerFromServerId(receieverid)
	local receieverhandlerped = GetPlayerPed(receieverhandler)
	for i, animations in ipairs(animationscarry) do
		while not HasAnimDictLoaded(animations.animdict) do
			RequestAnimDict(animations.animdict)
			Citizen.Wait(5)
		end			
	end
	if CarryTypeChoosed == "type1" then
		if not IsEntityPlayingAnim(requesterhandler, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 3) then
			TaskPlayAnim(requesterhandler, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", tonumber("8.0"), tonumber("-8.0"), 100000, 49, 0, false, false, false)
		end
		if not IsEntityPlayingAnim(receieverhandlerped, "nm", "firemans_carry", 3) then
			TaskPlayAnim(receieverhandlerped, "nm", "firemans_carry", tonumber("8.0"), tonumber("-8.0"), 100000, 33, 0, false, false, false)
		end
	elseif CarryTypeChoosed == "type2" then
		if not IsEntityPlayingAnim(requesterhandler, "anim@heists@box_carry@", "idle", 3) then
			TaskPlayAnim(requesterhandler, "anim@heists@box_carry@", "idle", tonumber("8.0"), tonumber("-8.0"), 100000, 49, 0, false, false, false)
		end
		if not IsEntityPlayingAnim(receieverhandlerped, "amb@code_human_in_car_idles@generic@ps@base", "base", 3) then
			TaskPlayAnim(receieverhandlerped, "amb@code_human_in_car_idles@generic@ps@base", "base", tonumber("8.0"), tonumber("-8.0"), 100000, 33, 0, false, false, false)
		end	
	elseif CarryTypeChoosed == "type3" then
		if not IsEntityPlayingAnim(requesterhandler, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_a", 3) then
			TaskPlayAnim(requesterhandler, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_a", tonumber("8.0"), tonumber("-8.0"), 100000, 49, 0, false, false, false)
		end
		if not IsEntityPlayingAnim(receieverhandlerped, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_b", 3) then
			TaskPlayAnim(receieverhandlerped, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_b", tonumber("8.0"), tonumber("-8.0"), 100000, 33, 0, false, false, false)
		end	
	end
	CarryPlayer = true
	CarryedPlayerHandler = receieverid
	RequestSecondsRemaining = 0
	RequestSent = false
	TrajectoryShow = false
	TrajectoryPlayerHandler = nil	
	SendNUIMessage({
		message	= "hide"
	})
end)

function RGBRainbow(frequency)
	local result = {}
	local curtime = GetGameTimer() / 1000
	result.r = math.floor( math.sin( curtime * frequency + 0 ) * 127 + 128 )
	result.g = math.floor( math.sin( curtime * frequency + 2 ) * 127 + 128 )
	result.b = math.floor( math.sin( curtime * frequency + 4 ) * 127 + 128 )
	return result
end

RegisterNetEvent("rtx_carry:Carry")
AddEventHandler("rtx_carry:Carry", function(carrytype)
	Carry(carrytype)
end)

if Config.CarryViaCommand then
	RegisterCommand(Config.CarryCommand, function(source, args)
		Carry(args[1])
	end)
end

function Carry(carrytype)
	local playerid = PlayerId()
	local dead = IsPlayerDead(playerid)
	if dead == false then
		local playerped = PlayerPedId()
		if CarryPlayer == true then
			local PlayerReceiever = GetPlayerFromServerId(CarryedPlayerHandler)
			local PlayerReceieverPed = GetPlayerPed(PlayerReceiever)				
			CarryPlayer = false
			if CarryedPlayerHandler ~= nil then
				ClearPedTasksImmediately(PlayerReceieverPed)
			end
			TriggerServerEvent("rtx_carry:DisableCarryServer")
			CarryedPlayerHandler = nil
			DetachEntity(playerped, true, false)
			ClearPedTasksImmediately(playerped)
		elseif TrajectoryShow == true and TrajectoryPlayerHandler then	
			TriggerServerEvent("rtx_carry:CancelCarryRequestReceiever", GetPlayerServerId(TrajectoryPlayerHandler))
			RequestSent = false
			TrajectoryShow = false
			TrajectoryPlayerHandler = nil	
			SendNUIMessage({
				message	= "hide"
			})								
		else
			if tostring(carrytype) == "1" then
				InMenuCarry = false
				CarryTypeChoosed = "type1"
				if CarryPlayer == false and CarryedPlayer == false then
					if not IsPedSittingInAnyVehicle(playerped) then
						local ClosestPlayer, distance = GetClosestPlayer()
						if ClosestPlayer ~= tonumber("-1") and distance < Config.CarryDistance then
							if Carryed == false then
								if RequestSent == false then
									RTXCARRY.TriggerServerCallback("rtx_carry:IsPlayerCarryed", function(carrydata)		
										if carrydata == true then
											RequestSent = true
											TrajectoryShow = true
											TrajectoryPlayerHandler = ClosestPlayer		
											RequestSecondsRemaining = Config.RequestDuration
										elseif carrydata == "playercarrysomeone" then
											Notify(Language[Config.Language]["targetcarrysomeone"])
										elseif carrydata == "youarecarryed" then
											Notify(Language[Config.Language]["someonecarryou"])		
										elseif carrydata == "targetalreadycarry" then
											Notify(Language[Config.Language]["targetcarryed"])		
										elseif carrydata == "alreadysentrequest" then
											Notify(Language[Config.Language]["requestalready"])	
										elseif carrydata == "targethaverequestfromsomeone" then
											Notify(Language[Config.Language]["targethaverequest"])	
										elseif carrydata == "playerincarrymenu" then
											Notify(Language[Config.Language]["targetmenu"])	
										end
									end, GetPlayerServerId(ClosestPlayer), CarryTypeChoosed)
								else
									Notify(Language[Config.Language]["requestalready"])
								end
							else
								Notify(Language[Config.Language]["someonecarryou"])
							end
						else
							Notify(Language[Config.Language]["noplayernearby"])
						end
					else
						Notify(Language[Config.Language]["invehicle"])
					end	
				else
					Notify(Language[Config.Language]["youcarrysomeone"])
				end	
			elseif tostring(carrytype) == "2" then
				InMenuCarry = false
				CarryTypeChoosed = "type2"
				if CarryPlayer == false and CarryedPlayer == false then
					if not IsPedSittingInAnyVehicle(playerped) then
						local ClosestPlayer, distance = GetClosestPlayer()
						if ClosestPlayer ~= tonumber("-1") and distance < Config.CarryDistance then
							if Carryed == false then
								if RequestSent == false then
									RTXCARRY.TriggerServerCallback("rtx_carry:IsPlayerCarryed", function(carrydata)		
										if carrydata == true then
											RequestSent = true
											TrajectoryShow = true
											TrajectoryPlayerHandler = ClosestPlayer		
											RequestSecondsRemaining = Config.RequestDuration
										elseif carrydata == "playercarrysomeone" then
											Notify(Language[Config.Language]["targetcarrysomeone"])
										elseif carrydata == "youarecarryed" then
											Notify(Language[Config.Language]["someonecarryou"])		
										elseif carrydata == "targetalreadycarry" then
											Notify(Language[Config.Language]["targetcarryed"])		
										elseif carrydata == "alreadysentrequest" then
											Notify(Language[Config.Language]["requestalready"])	
										elseif carrydata == "targethaverequestfromsomeone" then
											Notify(Language[Config.Language]["targethaverequest"])	
										elseif carrydata == "playerincarrymenu" then
											Notify(Language[Config.Language]["targetmenu"])	
										end
									end, GetPlayerServerId(ClosestPlayer), CarryTypeChoosed)
								else
									Notify(Language[Config.Language]["requestalready"])
								end
							else
								Notify(Language[Config.Language]["someonecarryou"])
							end
						else
							Notify(Language[Config.Language]["noplayernearby"])
						end
					else
						Notify(Language[Config.Language]["invehicle"])
					end	
				else
					Notify(Language[Config.Language]["youcarrysomeone"])
				end		
			elseif tostring(carrytype) == "3" then
				InMenuCarry = false
				CarryTypeChoosed = "type3"
				if CarryPlayer == false and CarryedPlayer == false then
					if not IsPedSittingInAnyVehicle(playerped) then
						local ClosestPlayer, distance = GetClosestPlayer()
						if ClosestPlayer ~= tonumber("-1") and distance < Config.CarryDistance then
							if Carryed == false then
								if RequestSent == false then
									RTXCARRY.TriggerServerCallback("rtx_carry:IsPlayerCarryed", function(carrydata)		
										if carrydata == true then
											RequestSent = true
											TrajectoryShow = true
											TrajectoryPlayerHandler = ClosestPlayer		
											RequestSecondsRemaining = Config.RequestDuration
										elseif carrydata == "playercarrysomeone" then
											Notify(Language[Config.Language]["targetcarrysomeone"])
										elseif carrydata == "youarecarryed" then
											Notify(Language[Config.Language]["someonecarryou"])		
										elseif carrydata == "targetalreadycarry" then
											Notify(Language[Config.Language]["targetcarryed"])		
										elseif carrydata == "alreadysentrequest" then
											Notify(Language[Config.Language]["requestalready"])	
										elseif carrydata == "targethaverequestfromsomeone" then
											Notify(Language[Config.Language]["targethaverequest"])	
										elseif carrydata == "playerincarrymenu" then
											Notify(Language[Config.Language]["targetmenu"])	
										end
									end, GetPlayerServerId(ClosestPlayer), CarryTypeChoosed)
								else
									Notify(Language[Config.Language]["requestalready"])
								end
							else
								Notify(Language[Config.Language]["someonecarryou"])
							end
						else
							Notify(Language[Config.Language]["noplayernearby"])
						end
					else
						Notify(Language[Config.Language]["invehicle"])
					end	
				else
					Notify(Language[Config.Language]["youcarrysomeone"])
				end		
			else
				if CarryPlayer == false and CarryedPlayer == false then
					if not IsPedSittingInAnyVehicle(playerped) then
						local ClosestPlayer, distance = GetClosestPlayer()
						if ClosestPlayer ~= tonumber("-1") and distance < Config.CarryDistance then
							if Carryed == false then
								if RequestSent == false then
									RTXCARRY.TriggerServerCallback("rtx_carry:CheckCarryStatus", function(carrydata)		
										if carrydata == true then
											InMenuCarry = true
											SetNuiFocus(true, true)
											SendNUIMessage({
												message	= "showtypes"
											})										
										elseif carrydata == "playercarrysomeone" then
											Notify(Language[Config.Language]["targetcarrysomeone"])
										elseif carrydata == "youarecarryed" then
											Notify(Language[Config.Language]["someonecarryou"])		
										elseif carrydata == "targetalreadycarry" then
											Notify(Language[Config.Language]["targetcarryed"])		
										elseif carrydata == "alreadysentrequest" then
											Notify(Language[Config.Language]["requestalready"])	
										elseif carrydata == "targethaverequestfromsomeone" then
											Notify(Language[Config.Language]["targethaverequest"])	
										elseif carrydata == "playerincarrymenu" then
											Notify(Language[Config.Language]["targetmenu"])												
										end
									end, GetPlayerServerId(ClosestPlayer))
								else
									Notify(Language[Config.Language]["requestalready"])
								end
							else
								Notify(Language[Config.Language]["someonecarryou"])
							end
						else
							Notify(Language[Config.Language]["noplayernearby"])
						end
					else
						Notify(Language[Config.Language]["invehicle"])
					end	
				else
					Notify(Language[Config.Language]["youcarrysomeone"])
				end	
			end
		end	
	end
end

if Config.CarryMarker or Config.CarryLine then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(5)
			if TrajectoryShow == true and TrajectoryPlayerHandler then
				local PlayerSender = PlayerPedId()
				local PlayerSenderCoords = GetEntityCoords(PlayerSender)
				local PlayerReceiever = GetPlayerPed(TrajectoryPlayerHandler)
				local PlayerReceieverCoords = GetEntityCoords(PlayerReceiever)
				local distance = #(PlayerSenderCoords - PlayerReceieverCoords)
				local rainbow = RGBRainbow(1)
				if PlayerReceiever then
					if distance < Config.CarryDistanceDraw then
						if Config.CarryMarker then
							DrawMarker(2, PlayerReceieverCoords.x, PlayerReceieverCoords.y, PlayerReceieverCoords.z+tonumber("1.0"), tonumber("0.0"), tonumber("0.0"), tonumber("0.0"), 0, tonumber("0.0"), tonumber("0.0"), tonumber("0.3"), tonumber("0.3"), tonumber("0.3"), rainbow.r, rainbow.g, rainbow.b, 255, false, true, 2, false, false, false, false)
						end
						if Config.CarryLine then
							DrawLine(PlayerSenderCoords.x, PlayerSenderCoords.y, PlayerSenderCoords.z, PlayerReceieverCoords.x, PlayerReceieverCoords.y, PlayerReceieverCoords.z, rainbow.r, rainbow.g, rainbow.b, 255)
						end
					end
				end
			else
				Citizen.Wait(1000)
			end
		end
	end)
end

if Config.CarryMarker or Config.CarryLine then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(5)
			if TrajectoryShowReceiever == true and TrajectoryPlayerHandlerReceiever then
				local PlayerSender = PlayerPedId()
				local PlayerSenderCoords = GetEntityCoords(PlayerSender)
				local PlayerReceiever = GetPlayerFromServerId(TrajectoryPlayerHandlerReceiever)
				local PlayerReceieverPed = GetPlayerPed(PlayerReceiever)
				local PlayerReceieverCoords = GetEntityCoords(PlayerReceieverPed)
				local distance = #(PlayerSenderCoords - PlayerReceieverCoords)
				local rainbow = RGBRainbow(1)
				if PlayerReceiever then
					if distance < Config.CarryDistanceDraw then
						if Config.CarryMarker then
							DrawMarker(2, PlayerReceieverCoords.x, PlayerReceieverCoords.y, PlayerReceieverCoords.z+tonumber("1.0"), tonumber("0.0"), tonumber("0.0"), tonumber("0.0"), 0, tonumber("0.0"), tonumber("0.0"), tonumber("0.3"), tonumber("0.3"), tonumber("0.3"), rainbow.r, rainbow.g, rainbow.b, 255, false, true, 2, false, false, false, false)
						end
						if Config.CarryLine then
							DrawLine(PlayerSenderCoords.x, PlayerSenderCoords.y, PlayerSenderCoords.z, PlayerReceieverCoords.x, PlayerReceieverCoords.y, PlayerReceieverCoords.z, rainbow.r, rainbow.g, rainbow.b, 255)
						end
					end
				end
			else
				Citizen.Wait(1000)
			end
		end
	end)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if TrajectoryShow == true and TrajectoryPlayerHandler and RequestSecondsRemaining > 0 then
			RequestSecondsRemaining = RequestSecondsRemaining-tonumber("1")
			SendNUIMessage({
				message	= "showcarryrequestrequester",
				remainingseconds = RequestSecondsRemaining
			})			
			if RequestSecondsRemaining == 0 then
				TriggerServerEvent("rtx_carry:CancelCarryRequestReceiever", GetPlayerServerId(TrajectoryPlayerHandler))
				RequestSent = false
				TrajectoryShow = false
				TrajectoryPlayerHandler = nil	
				SendNUIMessage({
					message	= "hide"
				})						
			end
		else
			Citizen.Wait(1000)
		end
	end
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		if CarryPlayer == true then
			if CarryedPlayerHandler ~= nil then
				local PlayerSender = PlayerPedId()
				local PlayerReceiever = GetPlayerFromServerId(CarryedPlayerHandler)
				local PlayerReceieverPed = GetPlayerPed(PlayerReceiever)		
				if CarryTypeChoosed == "type1" then
					if not IsEntityPlayingAnim(PlayerSender, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 3) then
						TaskPlayAnim(PlayerSender, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", tonumber("8.0"), tonumber("-8.0"), 100000, 49, 0, false, false, false)
					end
					if not IsEntityPlayingAnim(PlayerReceieverPed, "nm", "firemans_carry", 3) then
						TaskPlayAnim(PlayerReceieverPed, "nm", "firemans_carry", tonumber("8.0"), tonumber("-8.0"), 100000, 33, 0, false, false, false)
					end
				elseif CarryTypeChoosed == "type2" then
					if not IsEntityPlayingAnim(PlayerSender, "anim@heists@box_carry@", "idle", 3) then
						TaskPlayAnim(PlayerSender, "anim@heists@box_carry@", "idle", tonumber("8.0"), tonumber("-8.0"), 100000, 49, 0, false, false, false)
					end
					if not IsEntityPlayingAnim(PlayerReceieverPed, "amb@code_human_in_car_idles@generic@ps@base", "base", 3) then
						TaskPlayAnim(PlayerReceieverPed, "amb@code_human_in_car_idles@generic@ps@base", "base", tonumber("8.0"), tonumber("-8.0"), 100000, 33, 0, false, false, false)
					end			
				elseif CarryTypeChoosed == "type3" then
					if not IsEntityPlayingAnim(PlayerSender, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_a", 3) then
						TaskPlayAnim(PlayerSender, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_a", tonumber("8.0"), tonumber("-8.0"), 100000, 49, 0, false, false, false)
					end
					if not IsEntityPlayingAnim(PlayerReceieverPed, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_b", 3) then
						TaskPlayAnim(PlayerReceieverPed, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_b", tonumber("8.0"), tonumber("-8.0"), 100000, 33, 0, false, false, false)
					end			
				end
			end
		elseif CarryedPlayer == true then
			if CarryedPlayerHandler ~= nil then
				local PlayerSender = PlayerPedId()
				local PlayerReceiever = GetPlayerFromServerId(CarryedPlayerHandler)
				local PlayerReceieverPed = GetPlayerPed(PlayerReceiever)			
				if CarryTypeChoosed == "type1" then
					if not IsEntityAttachedToEntity(PlayerReceieverPed, PlayerSender) then
						AttachEntityToEntity(PlayerSender, PlayerReceieverPed, 0, tonumber("0.30"), tonumber("0.16"), tonumber("0.65"), tonumber("0.5"), tonumber("0.5"), 180, false, false, false, false, 2, false)	
					end
				elseif CarryTypeChoosed == "type2" then
					if not IsEntityAttachedToEntity(PlayerReceieverPed, PlayerSender) then
						AttachEntityToEntity(PlayerSender, PlayerReceieverPed, 9816, tonumber("0.02"), tonumber("0.4"), tonumber("0.10"), tonumber("0.10"), tonumber("0.30"), tonumber("90.0"), false, false, false, false, 2, false)	
					end			
				elseif CarryTypeChoosed == "type3" then
					if not IsEntityAttachedToEntity(PlayerReceieverPed, PlayerSender) then
						AttachEntityToEntity(PlayerSender, PlayerReceieverPed, 0, tonumber("0.0"), tonumber("-0.07"), tonumber("0.45"), tonumber("0.5"), tonumber("0.5"), 180, false, false, false, false, 2, false)
					end			
				end
			end
		else
			Citizen.Wait(1000)
		end
	end
end)	

RegisterCommand("aggrecarry", function()
	if TrajectoryPlayerHandlerReceiever then
		local PlayerSender = PlayerPedId()
		local PlayerSenderCoords = GetEntityCoords(PlayerSender)
		local PlayerReceiever = GetPlayerFromServerId(TrajectoryPlayerHandlerReceiever)
		local PlayerReceieverPed = GetPlayerPed(PlayerReceiever)
		local PlayerReceieverCoords = GetEntityCoords(PlayerReceieverPed)
		local distance = #(PlayerSenderCoords - PlayerReceieverCoords)	
		if distance < Config.CarryDistance then
			ClearPedTasksImmediately(PlayerSender)
			for i, animations in ipairs(animationscarry) do
				while not HasAnimDictLoaded(animations.animdict) do
					RequestAnimDict(animations.animdict)
					Citizen.Wait(5)
				end			
			end			
			if CarryTypeChoosed == "type1" then
				AttachEntityToEntity(PlayerSender, PlayerReceieverPed, 0, tonumber("0.30"), tonumber("0.16"), tonumber("0.65"), tonumber("0.5"), tonumber("0.5"), 180, false, false, false, false, 2, false)	
				if not IsEntityPlayingAnim(PlayerReceieverPed, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 3) then
					TaskPlayAnim(PlayerReceieverPed, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman",  tonumber("8.0"), tonumber("-8.0"), 100000, 49, 0, false, false, false)
				end
				if not IsEntityPlayingAnim(PlayerSender, "nm", "firemans_carry", 3) then
					TaskPlayAnim(PlayerSender, "nm", "firemans_carry",  tonumber("8.0"), tonumber("-8.0"), 100000, 33, 0, false, false, false)
				end					
			elseif CarryTypeChoosed == "type2" then
				AttachEntityToEntity(PlayerSender, PlayerReceieverPed, 9816, tonumber("0.02"), tonumber("0.4"), tonumber("0.10"), tonumber("0.10"), tonumber("0.30"), tonumber("90.0"), false, false, false, false, 2, false)
				if not IsEntityPlayingAnim(PlayerReceieverPed, "anim@heists@box_carry@", "idle", 3) then
					TaskPlayAnim(PlayerReceieverPed, "anim@heists@box_carry@", "idle",  tonumber("8.0"), tonumber("-8.0"), 100000, 49, 0, false, false, false)
				end
				if not IsEntityPlayingAnim(PlayerSender, "amb@code_human_in_car_idles@generic@ps@base", "base", 3) then
					TaskPlayAnim(PlayerSender, "amb@code_human_in_car_idles@generic@ps@base", "base",  tonumber("8.0"), tonumber("-8.0"), 100000, 33, 0, false, false, false)
				end					
			elseif CarryTypeChoosed == "type3" then
				AttachEntityToEntity(PlayerSender, PlayerReceieverPed, 0, tonumber("0.0"), tonumber("-0.07"), tonumber("0.45"), tonumber("0.5"), tonumber("0.5"), 180, false, false, false, false, 2, false)
				if not IsEntityPlayingAnim(PlayerReceieverPed, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_a", 3) then
					TaskPlayAnim(PlayerReceieverPed, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_a",  tonumber("8.0"), tonumber("-8.0"), 100000, 49, 0, false, false, false)
				end
				if not IsEntityPlayingAnim(PlayerSender, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_b", 3) then
					TaskPlayAnim(PlayerSender, "anim@arena@celeb@flat@paired@no_props@", "piggyback_c_player_b", tonumber("8.0"), tonumber("-8.0"), 100000, 33, 0, false, false, false)
				end					
			end			
			CarryedPlayerHandler = TrajectoryPlayerHandlerReceiever
			TriggerServerEvent("rtx_carry:CancelCarryRequestReceieverAccept", TrajectoryPlayerHandlerReceiever)
			TrajectoryShowReceiever = false
			TrajectoryPlayerHandlerReceiever = nil
			if Config.CarryInterfaceWhileCarryed then
				SendNUIMessage({
					message	= "showcarryed"
				})
			end
			CarryedPlayer = true
		else
			Notify(Language[Config.Language]["norequestdistance"])
		end
	end
end)

RegisterCommand("declinecarry", function()
	if TrajectoryPlayerHandlerReceiever then
		TriggerServerEvent("rtx_carry:CancelCarryRequestReceieverDecline", TrajectoryPlayerHandlerReceiever)
		TrajectoryShowReceiever = false
		TrajectoryPlayerHandlerReceiever = nil
		SendNUIMessage({
			message	= "hide"
		})					
	end
end)

RegisterKeyMapping("aggrecarry", Language[Config.Language]["agreecarry"], "keyboard", Config.DefaultKeyBindAccept)

RegisterKeyMapping("declinecarry", Language[Config.Language]["declinecarry"], "keyboard", Config.DefaultKeyBindDecline)