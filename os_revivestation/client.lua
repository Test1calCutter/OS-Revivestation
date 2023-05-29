local circleCenter = vector3(342.5406, -1398.013, 32.49817 )
local circleRadius = 1.0
local reviveDistance = 122.0
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(10)
    end
end)
AddTextEntry('label', 'Health Care')
blip = AddBlipForCoord(circleCenter)
SetBlipSprite(blip, 621)
SetBlipDisplay(blip, 2)
SetBlipScale(blip, 0.9)
SetBlipColour(blip, 1)
SetBlipAsShortRange(blip, true)
BeginTextCommandSetBlipName("label")
EndTextCommandSetBlipName(blip)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local distance = GetDistanceBetweenCoords(playerCoords, circleCenter, true)


        if distance <= 150 then
            local playerHealth = GetEntityHealth(playerPed)
            print(playerHealth)

            if playerHealth <= 0 then
                print(playerHealth)
                DisplayHelpText("Press ~INPUT_CONTEXT~ to revive.") -- Not showing when dead... Maybe you can fix it?
                DrawMarker(1, circleCenter.x, circleCenter.y, circleCenter.z - 1.0, 0, 0, 0, 0, 0, 0, circleRadius * 2.0, circleRadius * 2.0, 1.0, 255, 0, 0, 200, false, false, 2, nil, nil, false)

                if distance <= circleRadius and IsControlJustReleased(0, 38) then
                    TriggerEvent('esx_ambulancejob:revive')
                end
            elseif playerHealth <= 150 then
                print(playerHealth)
                if distance <= circleRadius then
                    DisplayHelpText("Press ~INPUT_CONTEXT~ to heal.")
                end


                DrawMarker(1, circleCenter.x, circleCenter.y, circleCenter.z - 1.0, 0, 0, 0, 0, 0, 0, circleRadius * 2.0, circleRadius * 2.0, 1.0, 0, 255, 0, 200, false, false, 2, nil, nil, false)

                if distance <= circleRadius and IsControlJustReleased(0, 38) then
                    TriggerEvent('esx_ambulancejob:revive')
                end
            elseif playerHealth >= 150 then
                DrawMarker(1, circleCenter.x, circleCenter.y, circleCenter.z - 1.0, 0, 0, 0, 0, 0, 0, circleRadius * 2.0, circleRadius * 2.0, 1.0, 0, 0, 255, 200, false, false, 2, nil, nil, false)
                print(playerHealth)

                if distance <= circleRadius then
                    DisplayHelpText("You got no injuries little one.")
                end
                if distance <= circleRadius and IsControlJustReleased(0, 38) then
                    ESX.ShowNotification('Go and cry about it.')
                end
            end
        else
            RemoveHelpText()
        end
    end
end)

function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function RemoveHelpText()
    BeginTextCommandDisplayHelp("STRING")
    EndTextCommandDisplayHelp(0, false, true, -1)
end
