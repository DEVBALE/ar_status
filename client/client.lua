ESX = nil
local buffer = {}
local isLoad = false
local isBlock = false
ARROW = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

CreateThread(function()
	while true do
		if NetworkIsPlayerActive(PlayerId()) then
			Wait(5 * 1000)
			onSetup()
			break
		end
		Wait(0)
	end
end)

CreateThread(function()
    while true do
        Wait(Config.TickTime)
		if isLoad and buffer then ARROW.onCalculate() end
    end
end)

ARROW.SETUP = function()
	local kvp = GetResourceKvpString(Config.Setting.KPV)
	local status = json.decode(kvp)
	if kvp == nil or kvp == "" then
		local elm = {}
		for k,v in pairs(Config.Status) do
			elm[k] = { max = v.max, val = v.max, del = v.del[3] }
		end
		SetResourceKvp(Config.Setting.KPV, json.encode(elm))
        buffer = elm
    else
        local elm = {}
		for k, v in pairs(status) do
            buffer[k] = v
        end
	end
	isLoad = true
	TriggerEvent("ar_status:Load")
end

ARROW.OnAction = function(typ, action, value)
	if buffer[typ] and value >= 0 then
		if action == 'add' then
			if (buffer[typ].val + value) >= buffer[typ].max then 
				buffer[typ].val = buffer[typ].max
			else
				buffer[typ].val = buffer[typ].val + value
			end
		elseif action == 'remove' then
			if (buffer[typ].val - value) < 0 then 
				buffer[typ].val = 0
			else
				buffer[typ].val = buffer[typ].val - value
			end
		elseif action == 'set' then
			if value >= buffer[typ].max then 
				buffer[typ].val = buffer[typ].max
			else
				buffer[typ].val = value
			end
		end
	end
end

ARROW.onCalculate = function()
	for k, v in pairs(buffer) do
		if not isBlock then
			if (buffer[k].val - v.del) < 0 then
				buffer[k].val = 0
			else
				buffer[k].val = buffer[k].val - v.del
			end
		end
	end
end

ARROW.onStatus = function()
	local elm = {}
	for k, v in pairs(buffer) do
		elm[k] = (buffer[k].val / buffer[k].max) * 100
	end
	return elm
end

RegisterNetEvent('esx_status:set')
AddEventHandler('esx_status:set', function(name, val)
	ARROW.OnAction(name, "set", val)
end)

RegisterNetEvent('esx_status:add')
AddEventHandler('esx_status:add', function(name, val)
	ARROW.OnAction(name, "add", val)
end)

RegisterNetEvent('esx_status:remove')
AddEventHandler('esx_status:remove', function(name, val)
	ARROW.OnAction(name, "remove", val)
end)

exports('ToggleStatus', function(bool)
	isBlock = bool
end)

CreateThread(function()
	while true do
		Wait(1000)
		if isLoad and not IsPedDeadOrDying(PlayerPedId()) then
			local playerPed  = PlayerPedId()
			local prevHealth = GetEntityHealth(playerPed)
			local health     = prevHealth
			if ARROW.onStatus().hunger <= 0 then
				if prevHealth <= 150 then
					health = health - 5
				else
					health = health - 1
				end
			end
			if health ~= prevHealth and not IsPedDeadOrDying(PlayerPedId() , 1) then
				SetEntityHealth(playerPed, health)
			end
		end
	end
end)

