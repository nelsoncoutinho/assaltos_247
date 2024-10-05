local holdingUp = false
local store = ""
local blipRobbery = nil
local nearStore = false
local currentDistance = 1000

-- Function to send notification
local function sendNotification(message, type, duration)
    if Config.NotificationSystem == "ox" then
        lib.notify({
            description = message,
            type = type,
            duration = 5000
        })
    elseif Config.NotificationSystem == "okokNotify" then
        exports['okokNotify']:Alert(_L('robbery'), message, 5000, type)
    end
end

-- Function to draw text on screen
local function drawTxt(x, y, width, height, scale, text, r, g, b, a, outline)
    SetTextFont(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    if outline then SetTextOutline() end
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x - width/2, y - height/2 + 0.005)
end

-- Events
RegisterNetEvent('assaltos_247:currentlyRobbing', function(currentStore)
    holdingUp, store = true, currentStore
end)

RegisterNetEvent('assaltos_247:killBlip', function()
    RemoveBlip(blipRobbery)
end)

RegisterNetEvent('assaltos_247:setBlip', function(position)
    blipRobbery = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blipRobbery, 161)
    SetBlipScale(blipRobbery, 0.7)
    SetBlipColour(blipRobbery, 3)
    PulseBlip(blipRobbery)
end)

RegisterNetEvent('assaltos_247:tooFar', function()
    holdingUp, store = false, ''
    sendNotification(_L('robbery_cancelled'), 'error')
end)

RegisterNetEvent('assaltos_247:robberyComplete', function(award)
    holdingUp, store = false, ''
    sendNotification(_L('robbery_complete'):format(award), 'success')
end)

RegisterNetEvent('assaltos_247:startTimer', function()
    local timer = Stores[store].secondsRemaining

    CreateThread(function()
        while timer > 0 and holdingUp do
            Wait(1000)
            if timer > 0 then
                timer = timer - 1
            end
        end
    end)

    CreateThread(function()
        while holdingUp do
            Wait(0)
            drawTxt(0.66, 1.44, 1.0, 1.0, 0.4, _L('robbery_timer'):format(timer), 255, 255, 255, 255)
        end
    end)
end)

-- Main loop optimized
CreateThread(function()
    while true do
        local playerPos = GetEntityCoords(PlayerPedId(), true)
        nearStore = false
        currentDistance = 1000

        for k, v in pairs(Stores) do
            local storePos = v.position
            local distance = #(playerPos - vector3(storePos.x, storePos.y, storePos.z))

            if distance < 3 and not holdingUp then
                nearStore = true
                currentDistance = distance
                store = k
                break
            end
        end

        Wait(500)
    end
end)

-- Interaction loop
CreateThread(function()
    local textUIShown = false
    while true do
        if nearStore and not holdingUp then
            if not textUIShown then
                lib.showTextUI(_L('press_e_to_rob'))
                textUIShown = true
            end
            
            if currentDistance < 1.0 and IsControlJustReleased(0, 38) then
                if IsPlayerArmedProperly() then
                    TriggerServerEvent('assaltos_247:checkstore', store)
                    lib.callback('assaltos_247:server:checkcops', false, function(canRob, policeCount)
                        if canRob then
                            sendNotification(_L('try_open_safe'), 'info', 10000)
                            
                            local a1, a2, a3 = math.random(0,99), math.random(0,99), math.random(0,99)
                            print("Números do cofre pd-safe:", a1, a2, a3)
                            local res = exports["pd-safe"]:createSafe({a1, a2, a3})
                            
                            if res then
                                TriggerServerEvent('assaltos_247:robberyStarted', store)
                            else
                                sendNotification(_L('failed_open_safe'), 'error', 10000)
                            end
                        else
                            sendNotification(_L('min_police_robbery'), 'error', 10000)
                        end
                    end)
                else
                    sendNotification(_L('no_threat'), 'error')
                end
            end
            Wait(0)
        else
            if textUIShown then
                lib.hideTextUI()
                textUIShown = false
            end
            Wait(1000)
        end
    end
end)

-- Function to check if the player is properly armed
function IsPlayerArmedProperly()
    local ped = cache.ped
    
    -- Check if the player is armed (excluding knives) and not disarmed
    if IsPedArmed(ped, 4) then
        local _, weapon = GetCurrentPedWeapon(ped, true)
        local weaponGroup = GetWeapontypeGroup(weapon)
        
        -- Exclude melee weapons (knives, etc.)
        if weaponGroup ~= 0xD49321D4 then -- 0xD49321D4 is the melee weapons group
            return true
        end
    end
    
    return false
end