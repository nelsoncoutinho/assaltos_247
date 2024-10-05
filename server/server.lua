local ESX = exports["es_extended"]:getSharedObject()
local rob = false
local robbers = {}

-- State variables
local policeCount = 0
local lastPoliceCheck = 0

-- Function to send notification
local function sendNotification(source, type, message)
	if Config.NotificationSystem == "ox" then
		TriggerClientEvent('ox_lib:notify', source, {type = type, description = message})
	elseif Config.NotificationSystem == "okokNotify" then
		local title = _L('robbery')
		local color = nil
		if type == 'error' then
			color = '#f44336'
		elseif type == 'success' then
			color = '#4CAF50'
		elseif type == 'inform' then
			color = '#2196F3'
		end
		TriggerClientEvent('okokNotify:Alert', source, title, message, 5000, color, true)
	end
end

-- Function to send dispatch alert
local function sendDispatchAlert(store)
	if Config.DispatchSystem == "cd_dispatch" then
		TriggerClientEvent('cd_dispatch:AddNotification', -1, {
			job_table = {'police'},
			coords = store.position,
			title = _L('store_robbery'),
			message = _L('robbery_in_progress'):format(store.nameOfStore),
			flash = 0,
			unique_id = tostring(math.random(0000000,9999999)),
			blip = {
				sprite = 161,
				scale = 1.2,
				colour = 3,
				flashes = false,
				text = _L('store_robbery'),
				time = (60*1000),
				sound = 1,
			}
		})
	elseif Config.DispatchSystem == "qs-dispatch" then
		TriggerClientEvent('qs-dispatch:server:notify', -1, {
			job = {'police'},
			title = _L('store_robbery'),
			message = _L('robbery_in_progress'):format(store.nameOfStore),
			location = store.position,
			blip = {
				sprite = 161,
				scale = 1.2,
				color = 3,
				flashes = false,
				text = _L('store_robbery'),
				time = 60,
				sound = 1,
			}
		})
	end
end

-- Event for when the player is too far
RegisterNetEvent('assaltos_247:tooFar')
AddEventHandler('assaltos_247:tooFar', function(currentStore)
	local source = source
	local xPlayers = ESX.GetExtendedPlayers()
	rob = false

	for _, xPlayer in pairs(xPlayers) do
		if xPlayer.job.name == 'police' then
			sendNotification(xPlayer.source, 'inform', _L('robbery_cancelled_at'):format(Stores[currentStore].nameOfStore))
			TriggerClientEvent('assaltos_247:killBlip', xPlayer.source)
		end
	end

	if robbers[source] then
		TriggerClientEvent('assaltos_247:tooFar', source)
		robbers[source] = nil
		sendNotification(xPlayer.source, 'inform', _L('robbery_cancelled_at'):format(Stores[currentStore].nameOfStore))
	end
end)

-- Event to start the robbery
RegisterNetEvent('assaltos_247:robberyStarted')
AddEventHandler('assaltos_247:robberyStarted', function(currentStore)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetExtendedPlayers()

	if Stores[currentStore] then
		local store = Stores[currentStore]

		if (os.time() - store.lastRobbed) < Config.RobberyCooldown and store.lastRobbed ~= 0 then
			sendNotification(source, 'error', _L('recently_robbed'):format(Config.RobberyCooldown - (os.time() - store.lastRobbed)))
			return
		end

		if not rob then
			rob = true

			sendDispatchAlert(store)

			for _, xPlayer in pairs(xPlayers) do
				if xPlayer.job.name == 'police' then
					TriggerClientEvent('assaltos_247:setBlip', xPlayer.source, Stores[currentStore].position)
				end
			end
			
			TriggerClientEvent('assaltos_247:currentlyRobbing', source, currentStore)
			TriggerClientEvent('assaltos_247:startTimer', source)
			
			Stores[currentStore].lastRobbed = os.time()
			robbers[source] = currentStore

			SetTimeout(store.secondsRemaining * 1000, function()
				if robbers[source] then
					rob = false
					if xPlayer then
						TriggerClientEvent('assaltos_247:robberyComplete', source, store.reward)

						if Config.GiveBlackMoney then
							exports.ox_inventory:AddItem(source, 'black_money', store.reward)
						else
							exports.ox_inventory:AddItem(source, 'money', store.reward)
						end
					
						
						for _, xPlayer in pairs(xPlayers) do
							if xPlayer.job.name == 'police' then
								sendNotification(xPlayer.source, 'inform', _L('robbery_complete_at', store.nameOfStore))
								TriggerClientEvent('assaltos_247:killBlip', xPlayer.source)
							end
						end
					end
				end
			end)
		else
			sendNotification(source, 'error', _L('robbery_already'))
		end
	end
end)

-- Event to check the store
RegisterNetEvent('assaltos_247:checkstore')
AddEventHandler('assaltos_247:checkstore', function(currentStore)
	local source = source
	if Stores[currentStore] then
		local store = Stores[currentStore]
		if (os.time() - store.lastRobbed) < Config.RobberyCooldown and store.lastRobbed ~= 0 then
			sendNotification(source, 'error', _L('recently_robbed'):format(Config.RobberyCooldown - (os.time() - store.lastRobbed)))
			return
		end
	end
end)

-- Callback to check the number of police officers
lib.callback.register('assaltos_247:server:checkcops', function(source)
	local currentTime = os.time()
	if currentTime - lastPoliceCheck > 60 then -- Verifica a cada 60 segundos
		policeCount = 0
		local xPlayers = ESX.GetExtendedPlayers()
		for _, xPlayer in pairs(xPlayers) do
			if xPlayer.job.name == 'police' then
				policeCount = policeCount + 1
			end
		end
		lastPoliceCheck = currentTime
	end
	return policeCount >= Config.RequiredPolice, policeCount
end)

-- Thread para atualizar o estado do roubo
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000) -- Verifica a cada segundo
		if rob then
			for source, currentStore in pairs(robbers) do
				local xPlayer = ESX.GetPlayerFromId(source)
				if xPlayer and #(xPlayer.getCoords(true) - Stores[currentStore].position) > 15 then
					TriggerEvent('assaltos_247:tooFar', source, currentStore)
				end
			end
		end
	end
end)

-- Função para obter identificadores do jogador
local function getPlayerIdentifiers(source)
	local identifiers = {}
	for k,v in pairs(GetPlayerIdentifiers(source)) do
		if string.sub(v, 1, string.len("license:")) == "license:" then
			identifiers.license = v
		elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
			identifiers.steam = v
		end
	end
	return identifiers
end

-- Função para verificar atualizações
local function checkForUpdates()
	PerformHttpRequest("https://api.github.com/repos/nelsoncoutinho/assaltos_247/releases/latest", function(err, text, headers)
		if err ~= 200 then
			print("^1Erro ao verificar atualizações para assaltos_247^7")
			return
		end
		
		local data = json.decode(text)
		if data.tag_name ~= GetResourceMetadata(GetCurrentResourceName(), "version", 0) then
			print("^3Uma nova versão do assaltos_247 está disponível!^7")
			print("^3Versão atual: " .. GetResourceMetadata(GetCurrentResourceName(), "version", 0) .. "^7")
			print("^3Nova versão: " .. data.tag_name .. "^7")
			print("^3Baixe a nova versão em: " .. data.html_url .. "^7")
		else
			print("^2assaltos_247 está atualizado.^7")
		end
	end, "GET", "", {["Content-Type"] = "application/json"})
end

-- Verificar atualizações ao iniciar o recurso
Citizen.CreateThread(function()
	Citizen.Wait(5000) -- Espera 5 segundos para garantir que tudo esteja carregado
	checkForUpdates()
end)