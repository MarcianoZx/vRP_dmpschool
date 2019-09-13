vRP = Proxy.getInterface("vRP")
--[[Variables]]


-- cost of mission
local cost = 15000

--[[LANGUAGE CONFIG]]
local warning_text_1 = "~r~Você está dirigindo sem regulamento ANAC"
local warning_text_2 = "Sem regulamento ANAC para pilotar"
local alreadyhaspermission_text = "~r~Você já possui permissão para voar"
local marker_entrance_text = "Pressione ~INPUT_PICKUP~ para pagar " ..cost.. " e tirar sua carteira de piloto"
local reproved_text = "~r~Reprovado! ~w~O supervisor encontrou problemas em sua pilotagem."
local success_text = "~g~Finalizado! ~w~Agora você pode voar sem problemas."
local inflight_text = "~g~Em treinamento. ~w~Erros:~r~ "


-- location of starter marker
local location = {x=-988.07366943359, y=-2812.5461425781, z=14.305760383606,} -- -988.07366943359,-2812.5461425781,14.305760383606

-- location of start mission
local missionloc = {
x=-985.19476318359,
y=-3346.4038085938,
z=13.944444656372
} -- -985.19476318359,-3346.4038085938,13.944444656372


-- color of waypoint
local color = {
    r=247,
    g=181,
    b=0
}

local pilotwlicense = false -- change this if you want to pilot planes whitout license, but with warning. 
-- [[true --> pilot without license; false --> cannot pilot without license]]

-- dont change this
local hasPP = false
local isinvehicle = false
local Error = 0
local instrutor = nil
-- waypoints (each letter is one waypoint)
-- [[if you want to add more waypoints add them here and set to false (wich i dont recommend cuz i made a lot of things that you have to do)]]
local waypoint = {
    a = false,
    b = false,
    c = false,
    d = false,
    e = false,
    f = false,
    g = false,
    h = false,
    i = false
}
-- scale of waypoint
local scale = 50.0


-- debug
local debug = false -- set debug to true or false

if debug == true then 
    RegisterCommand('testp', function ()
        Notify("Funcionando corretamente")
    end)
    RegisterCommand('bool', function ()
        if isinvehicle == true then
            Notify("true")
        else
            Notify("false")
        end
    end)
        waypoint.a = true
        waypoint.b = true
        waypoint.c = true
        waypoint.d = true
        waypoint.e = true
        waypoint.f = true
        waypoint.g = true
        waypoint.h = true
        waypoint.i = true
end
RegisterCommand('pilotcheck', function () -- opitional
    TriggerServerEvent("check")
end)
RegisterCommand('pilotdebug', function () -- opitional
    if debug == false then
        debug = true
    else
        debug = false
    end
end)

--CHECK FOR EACH PLAYER PLANE
--[[functions for text]]
function DrawMissionText2(m_text, showtime)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(showtime, 1)
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end
--[[check if have a license]]
Citizen.CreateThread(function()
    while true do
        Wait(1000)
        local ped = GetPlayerPed(-1)
        if IsPedInAnyVehicle(ped) then
            if IsPedInAnyPlane(ped) and not isinvehicle and not hasPP then
                DrawMissionText2(warning_text_1, 2000)	
                drawHelpMessage(warning_text_2)
                Wait(1000)
                if pilotwlicense == false then
                    TaskLeaveVehicle(ped, GetVehiclePedIsIn(ped), 0)
                end
            end
        end
    end
end)

--[[Start Marker]]
Citizen.CreateThread(function()
	while true do
		Wait(0)
		
		local playerCoords = GetEntityCoords(GetPlayerPed(-1), true)		
		
        
        -- vehicle and ped mission check
        if debug ~= true then
            if IsPedInVehicle(GetPlayerPed(-1), spawned_plane, false) then
                isinvehicle = true
            else
                isinvehicle = false
            end
        else
            isinvehicle = true
        end
        if instrutor ~= nil then
            if isinvehicle == false then
                DeleteEntity(spawned_plane)
                DeletePed(instrutor)
            end
        end

		-- Start marker

        DrawMarker(1, location.x,location.y,location.z-1.0001, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 2.0, 255, 255, 255, 155, 0, 0, 2, 0, 0, 0, 0)
		if GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, location.x,location.y,location.z, true) <= 4.0 then
			drawHelpMessage(marker_entrance_text)
            if IsControlJustPressed(0, 38) then
                TriggerServerEvent("check")
                Wait(900)
                if not hasPP then
                    TriggerServerEvent("start:mission", cost)
                else
                    Notify(alreadyhaspermission_text)
                end
			end
		end


        -- [[MISSIONS]]
        if isinvehicle == true then
            if waypoint.a == true then
                DrawMarker(6, -1149.1220703125,-3252.2651367188,14.850953102112, 0.2, -0.1, 0, 0, 0, 0, scale, scale, scale,color.r, color.g, color.b, 155, 0, 0, 2, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, -1149.1220703125,-3252.2651367188,14.850953102112, true) <= scale then
                    TriggerEvent('draw:waypoint', 2)
                end
            end
            if waypoint.b == true then
                DrawMarker(6, -1645.4588623047,-2965.2912597656,86.093490600586, 0.2, -0.1, 0, 0, 0, 0, scale, scale, scale,color.r, color.g, color.b, 155, 0, 0, 2, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, -1645.4588623047,-2965.2912597656,86.093490600586, true) <= scale then
                    TriggerEvent('draw:waypoint', 3)
                end
            end
            if waypoint.c == true then
                DrawMarker(6, -1800.0502929688,-1636.7801513672,371.63415527344, 0, 0, 0, 0, 0, 0, scale, scale, scale,color.r, color.g, color.b, 155, 0, 0, 2, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, -1800.0502929688,-1636.7801513672,371.63415527344, true) <= scale then
                    TriggerEvent('draw:waypoint', 4)
                end
            end
            if waypoint.d == true then
                DrawMarker(6, -1653.5300292969,-275.39205932617,566.5166015625, 0, 0, 0, 0, 0, 0, scale, scale, scale,color.r, color.g, color.b, 155, 0, 0, 2, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, -1653.5300292969,-275.39205932617,566.5166015625, true) <= scale then
                    TriggerEvent('draw:waypoint', 5)
                end
            end
            if waypoint.e == true then
                DrawMarker(6, -1607.5855712891,148.8547668457,570.92974853516, 0, 0, 0, 0, 0, 0, scale, scale, scale,color.r, color.g, color.b, 155, 0, 0, 2, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, -1607.5855712891,148.8547668457,570.92974853516, true) <= scale then
                    TriggerEvent('draw:waypoint', 6)
                end
            end
            if waypoint.f == true then
                DrawMarker(6, -1524.2025146484,592.34088134766,588.43212890625, 0, 0, 0, 0, 0, 0, scale, scale, scale,color.r, color.g, color.b, 155, 0, 0, 2, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, -1524.2025146484,592.34088134766,588.43212890625, true) <= scale then
                    TriggerEvent('draw:waypoint', 7)
                end
            end
            if waypoint.g == true then
                DrawMarker(6, -1332.802734375,1213.271484375,597.09362792969, 0, 0, 0, 0, 0, 0, scale, scale, scale,color.r, color.g, color.b, 155, 0, 0, 2, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, -1332.802734375,1213.271484375,597.09362792969, true) <= scale then
                    TriggerEvent('draw:waypoint', 8)
                end
            end
            if waypoint.h == true then
                DrawMarker(6, -1402.8625488281,2015.0499267578,261.16448974609, 0, 0, 0, 0, 0, 0,scale, scale, scale,color.r, color.g, color.b, 155, 0, 0, 2, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, -1402.8625488281,2015.0499267578,261.16448974609, true) <= scale then
                    TriggerEvent('draw:waypoint', 9)
                end
            end
            if waypoint.i == true then
                DrawMarker(6, -2138.7277832031,2934.0959472656,33.605281829834, 1.0 , -0.5, 0, 0, 0, 0, scale, scale, scale,color.r, color.g, color.b, 155, 0, 0, 2, 0, 0, 0, 0)
                if GetDistanceBetweenCoords(playerCoords.x, playerCoords.y, playerCoords.z, -2138.7277832031,2934.0959472656,33.605281829834, true) <= scale then
                    waypoint.i = false
                    -- ped stuff
                    local player = GetPlayerPed(-1)
                    SetPedCanSwitchWeapon(player, true)
                    SetPedCanBeDraggedOut(player, true)
                    SetPedCanRagdoll(player, true)
                    SetPedCanRagdollFromPlayerImpact(player, true)
                    SetPedCanBeDraggedOut(player, true)
                    SetPedCanSmashGlass(player, true)
                    SetPedCanBeShotInVehicle(player, true)
                    Wait(3000)
                    DoScreenFadeOut(600)
                    Wait(900)
                    DeleteEntity(spawned_plane)
                    SetEntityCoords(player, location.x, location.y, location.z, true, true, true, true)
                    Wait(200)
                    DoScreenFadeIn(600)
                    if Error >= 3 then
                        Notify(reproved_text)
                    else
                        Notify(success_text)
                        TriggerServerEvent("givePP")
                        hasPP = true
                    end
                end
            end
        end
    end
end)
-- check if plane collide
Citizen.CreateThread(function ()
    while true do
        Wait(0)
        if isinvehicle == true then
            DrawMissionText2(inflight_text ..Error, 2000)
            if HasEntityCollidedWithAnything(spawned_plane) then
                Error = Error + 1
                Wait(2000)
            end
        end
    end
end)
-- events
--[[check license]]
RegisterNetEvent("check:has")
AddEventHandler("check:has", function ()
    hasPP = true
end)
RegisterNetEvent("check:dont")
AddEventHandler("check:dont", function ()
    hasPP = false
end)

--[[start mission]]
RegisterNetEvent('start:mission')
AddEventHandler('start:mission', function()
    DoScreenFadeOut(500)
    Wait(500)
    local player = GetPlayerPed(-1)
    SetEntityCoords(player, missionloc.x, missionloc.y, missionloc.z, true, true, true, true)
    Wait(50)
    -- spawn plane
    local vehicleName = "rogue"
    local myPed = GetPlayerPed(-1)
    local player = PlayerId()
    local vehicle = GetHashKey(vehicleName)
    RequestModel(vehicle)
    while not HasModelLoaded(vehicle) do
    Wait(1)
    end
    spawned_plane = CreateVehicle(vehicle, missionloc.x,missionloc.y,missionloc.z, 55.11, true, false)
    SetVehicleOnGroundProperly(spawned_plane)
    SetModelAsNoLongerNeeded(vehicle)
    Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(spawned_plane))
    SetPedIntoVehicle(GetPlayerPed(-1), spawned_plane, -1)
    -- create instrutor


    RequestModel(GetHashKey("a_m_y_business_01"))
    while not HasModelLoaded(GetHashKey("a_m_y_business_01")) do
    Wait(1)
    end
    instrutor = CreatePedInsideVehicle(spawned_plane, 4, GetHashKey("a_m_y_business_01"), 0, true, true)


    -- just ped stuff [[prevent player anti-rp stuff]]
    SetPedCanSwitchWeapon(player, false)
    SetPedCanBeDraggedOut(player, false)
    SetPedCanRagdoll(player, false)
    SetPedCanRagdollFromPlayerImpact(player, false)
    SetPedCanBeDraggedOut(player, false)
    SetPedCanSmashGlass(player, false)
    SetPedCanBeShotInVehicle(player, false) -- just in case
    -- start waypoint 1
    DoScreenFadeIn(500)
    TriggerEvent('draw:waypoint', 1)
end)

-- [[missions itself]]
RegisterNetEvent('draw:waypoint')
AddEventHandler('draw:waypoint', function(value)
    -- sound
    local dict = "HUD_FRONTEND_DEFAULT_SOUNDSET"
    local name = "MP_AWARD"
    local playerCoords = GetEntityCoords(GetPlayerPed(-1), true)
    vRP.playSpatializedSound({dict,name,playerCoords.x,playerCoords.y,playerCoords.z,10})
    --
    waypoint.a = false waypoint.b = false waypoint.c = false waypoint.d = false waypoint.e = false waypoint.f = false waypoint.g = false waypoint.h = false waypoint.i = false
    if value == 1 then waypoint.a = true SetGPS(-1149.1220703125,-3252.2651367188,14.850953102112) end
    if value == 2 then waypoint.b = true SetGPS(-1645.4588623047,-2965.2912597656,86.093490600586) end
    if value == 3 then waypoint.c = true SetGPS(-1800.0502929688,-1636.7801513672,371.63415527344) end
    if value == 4 then waypoint.d = true SetGPS(-1653.5300292969,-275.39205932617,566.5166015625) end
    if value == 5 then waypoint.e = true SetGPS(-1607.5855712891,148.8547668457,570.92974853516) end
    if value == 6 then waypoint.f = true SetGPS(-1452.7628173828,411.61721801758,657.15380859375) end
    if value == 7 then waypoint.g = true SetGPS(-1332.802734375,1213.271484375,597.09362792969) end
    if value == 8 then waypoint.h = true SetGPS(-1402.8625488281,2015.0499267578,261.16448974609) end
    if value == 9 then waypoint.i = true SetGPS(-2138.7277832031,2934.0959472656,33.605281829834) end
end)


-- blip

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(location.x,location.y,location.z)
	SetBlipSprite(blip,307)
	SetBlipColour(blip,75)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString('ANAC')
	EndTextCommandSetBlipName(blip)
	SetBlipAsShortRange(blip,true)
	SetBlipAsMissionCreatorBlip(blip,true)
end)


-- functions
function Notify(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(false, false)
end
-- [[gps]]
function SetGPS(x,y,z)
    vRP.setNamedBlip({"blip_pilot",x,y,z,1,46,"Waypoint"})
    vRP.setGPS({x,y})
end
function RemoveGPS()
    vRP.removeNamedBlip({"blip_pilot"})
end

function drawHelpMessage(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end