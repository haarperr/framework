--[[RegisterNetEvent("vendor:purchase", function(id, item)
    local source = source
    local price = Config.Vendors[section].Items[section].Price
    local item = Config.Vendors[section].Items[section].Name
    local cash = exports.inventory:CountMoney() or 0.0

if not PlayerUtil:CheckCooldown(source, 1.0, true) then return end

else if  cash == price then
    if not slotId then return false end
    local slot = exports.inventory:GetSlot(source, slotId, true)
    if not slot then return false end

    local item = exports.inventory:GiveItem(slot[1])
    if not item then return false end

    local IsItemValid = false

    for _, validItem in ipairs(Config.Vendors[section].Items[section].Name) do 
        if validItem == Config.Items.Name then
            IsItemValid = true
            break
        end
    end

    if not isItemValid then return false end
else
    exports.inventory:GiveItem(source, item, 1, slotID)
    end
end)

if vendor:Purchase(source, item) then 
        exports.log.Add({
         source = source,
         verb = "made",
         noun = "purchase",
         extra = id,
       })
    end
end)]]--
