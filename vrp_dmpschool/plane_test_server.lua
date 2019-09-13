MySQL = module("vrp_mysql", "MySQL")
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_dmpschool")



-- MYSQL COMMANDS

MySQL.createCommand("vRP/dmp_column", "ALTER TABLE vrp_users ADD IF NOT EXISTS DmpTest varchar(50) NOT NULL default 'Required'")
MySQL.createCommand("vRP/dmp_success", "UPDATE vrp_users SET DmpTest='Passed' WHERE id = @id")
MySQL.createCommand("vRP/dmp_search", "SELECT * FROM vrp_users WHERE id = @id AND DmpTest = 'Passed'")

-- init 
MySQL.query("vRP/dmp_column")


--[[LANGUAGE]]
local starting_text = "~g~Seu treinamento começará em breve!"
local notenoughtmoney_text = "~r~Dinheiro insuficiente"

-- debug [[only debug]]
RegisterNetEvent('check')
AddEventHandler('check', function ()
    local user_id = vRP.getUserId({source})
        local player = vRP.getUserSource({user_id})
        MySQL.query("vRP/dmp_search", {id = user_id}, function(rows, affected)
        if #rows > 0 then
            vRPclient.notify(player,{"Licença de Piloto: ~g~Obtida"})
            TriggerClientEvent('check:has',player)
        else
            TriggerClientEvent('check:dont',player)
        end
    end)
end)

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
	MySQL.query("vRP/dmp_search", {id = user_id}, function(rows, affected)
      if #rows > 0 then
          TriggerClientEvent('check:has',source)
      else
        TriggerClientEvent('check:dont',source)
      end
    end)
end)

-- Events

-- [[Start Mission]]
RegisterNetEvent('start:mission')
AddEventHandler('start:mission', function (cost)
    local user_id = vRP.getUserId({source})
    local player = vRP.getUserSource({user_id})
    local pay = vRP.tryPayment({user_id,cost})
    if pay == true then
        vRPclient.notify(player,{starting_text})
        TriggerClientEvent('start:mission', player)
    else
        vRPclient.notify(player,{notenoughtmoney_text})
    end
end)

RegisterNetEvent("givePP")
AddEventHandler('givePP', function()
    local user_id = vRP.getUserId({source})
    MySQL.query("vRP/dmp_success", {id = user_id})
end)