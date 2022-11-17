if not IsDuplicityVersion() then -- CLIENT
    Utils = {
        ShowHelpNotification = function(msg, thisFrame, beep, duration)
            AddTextEntry('aquiverNotification', msg)

            if thisFrame then
                DisplayHelpTextThisFrame('aquiverNotification', false)
            else
                if beep == nil then
                    beep = true
                end
                BeginTextCommandDisplayHelp('aquiverNotification')
                EndTextCommandDisplayHelp(0, false, beep, duration or -1)
            end
        end,
        ShowNotification = function(msg)
            SetNotificationTextEntry('STRING')
            AddTextComponentString(msg)
            DrawNotification(0, 1)
        end,
        GroupDigits = function(value)
            local left, num, right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')

            return left .. (num:reverse():gsub('(%d%d%d)', '%1' .. ','):reverse()) .. right
        end
    }

    RegisterNetEvent('aquiver:showNotification')
    AddEventHandler(
        'aquiver:showNotification',
        function(msg)
            Utils.ShowNotification(msg)
        end
    )
end

if IsDuplicityVersion() then -- server
    Utils = {
        GroupDigits = function(value)
            local left, num, right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')

            return left .. (num:reverse():gsub('(%d%d%d)', '%1' .. ','):reverse()) .. right
        end,
        ShowNotification = function(source, msg)
            TriggerClientEvent('aquiver:showNotification', source, msg)
        end
    }
end
