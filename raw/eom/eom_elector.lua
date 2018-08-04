local eom_elector = {} --# assume eom_elector: EOM_ELECTOR

--v function(info: ELECTOR_INFO) --> EOM_ELECTOR
function eom_elector.new(info)
    local self = {} 
    setmetatable(
        self, {
            __index = eom_elector,
            __tostring = function() return "EOM_ELECTOR" end
        }
    )--# assume self: EOM_ELECTOR

    --central data
    self._key = info._key
    self._loyalty = info._loyalty
    self._power = info._power
    self._state = info._state
    self._fullyLoyal = info._fullyLoyal
    --casus belli 
    self._baseRegions = info._baseRegions
    --revival
    self._turnsDead = info._turnsDead
    self._capital = info._capital
    self._expeditionX = info._expeditionX
    self._expeditionY = info._expeditionY
    self._expeditionRegion = info._expeditionRegion
    self._leaderSubtype = info._leaderSubtype
    self._leaderForename = info._leaderForename
    self._leaderSurname  = info._leaderSurname
    self._homeRegions = info._homeRegions
    --ui
    self._hideFromUi = info._hideFromUi
    self._image = info._image
    self._uiName = info._uiName
    self._uiTooltip = info._uiTooltip
    self._isCult = info._isCult

    self._knights = info._knights
    self._canRevive = info._canRevive
    self._unitList = info._unitList
    self._willCapitulate = info._willCapitulate 
    self._fullLoyaltyCallback = function(model) end --:function(model: EOM_MODEL)
    return self
end

--save
--v function(self: EOM_ELECTOR) --> ELECTOR_INFO
function eom_elector.save(self)

    local savetable = {}
    savetable._key = self._key
    savetable._loyalty = self._loyalty
    savetable._power = self._power
    savetable._state = self._state
    savetable._fullyLoyal = self._fullyLoyal
    --casus belli 
    savetable._baseRegions = self._baseRegions
    --revival
    savetable._turnsDead = self._turnsDead
    savetable._capital = self._capital
    savetable._expeditionX = self._expeditionX
    savetable._expeditionY = self._expeditionY
    savetable._expeditionRegion = self._expeditionRegion
    savetable._leaderSubtype = self._leaderSubtype
    savetable._leaderForename = self._leaderForename
    savetable._leaderSurname  = self._leaderSurname
    --ui
    savetable._hideFromUi = self._hideFromUi
    savetable._image = self._image
    savetable._uiName = self._uiName
    savetable._uiTooltip = self._uiTooltip
    savetable._isCult = self._isCult
    savetable._knights = self._knights
    savetable._unitList = self._unitList
    savetable._canRevive = self._canRevive
    savetable._willCapitulate = self._willCapitulate
    savetable._homeRegions = self._homeRegions
    return savetable
end


--keys

--v function(self: EOM_ELECTOR) --> ELECTOR_NAME
function eom_elector.name(self)
    return self._key
end

--v function(self: EOM_ELECTOR) --> string
function eom_elector.capital(self)
    return self._capital
end


--full loyalty

--v function(self: EOM_ELECTOR) --> boolean
function eom_elector.is_loyal(self)
    return self._fullyLoyal
end

--v function(self: EOM_ELECTOR) 
function eom_elector.make_fully_loyal(self)
    self._fullyLoyal = true
end


--cultiness

--v function(self: EOM_ELECTOR) --> boolean
function eom_elector.is_cult(self)
    return self._isCult
end


--state

--v function(self: EOM_ELECTOR) --> ELECTOR_STATUS
function eom_elector.status(self)
    return self._state
end

--v function(self: EOM_ELECTOR, status: ELECTOR_STATUS)
function eom_elector.set_status(self, status)
    EOMLOG("entered for ["..self:name().."] ", "eom_elector.set_status(self)")
    if self:is_loyal() and status ~= "loyal" then
        EOMLOG("this elector is fully loyal, aborting")
        return
    end
    self._state = status
    EOMLOG("set status for ["..self:name().."] to ["..self:status().."]")
end


--loyalty

--return the loyalty of an elector
--v function(self: EOM_ELECTOR) --> number
function eom_elector.loyalty(self)
    return self._loyalty;
end

--change the loyalty of an elector by a value
--v function(self: EOM_ELECTOR, changevalue: number)
function eom_elector.change_loyalty(self, changevalue)
    if self:is_loyal() then
        EOMLOG("Not applying any loyalty change  to ["..self:name().."] because the elector is fully loyal!")
        return
    end
    

    if self:status() == "normal" then
        local ov = self._loyalty;
        local nv = ov + changevalue;
        if nv > 100 then nv = 100 end;
        if nv < 0 then nv = 0 end;
        self._loyalty = nv;
        EOMLOG("changed loyalty for ["..self:name().."] by ["..tostring(changevalue).."] to ["..self:loyalty().."] ")
    else
        EOMLOG("Not applying any loyalty change to ["..self:name().."] because the elector has a non-normal status!")
        return
    end
end


--set the loyalty of an elector to a value.
--v function(self: EOM_ELECTOR, setvalue: number)
function eom_elector.set_loyalty(self, setvalue)
    if self:is_loyal() then
        EOMLOG("WARNING: setting the loyalty of a fully loyal elector!!!")
    end
    self._loyalty = setvalue
    EOMLOG("set loyalty for ["..self:name().."] to ["..self:loyalty().."] ")
end

--power
--consider these to be legacy commands, they are unused.
--v function(self: EOM_ELECTOR) --> number
function eom_elector.power(self)
    return self._power
end

--v function(self: EOM_ELECTOR, value: number)
function eom_elector.set_power(self, value)
    self._power = value
end

--v function(self: EOM_ELECTOR, value: number)
function eom_elector.change_power(self, value)
    self._power = self._power + value
end

--capitulation

--v function(self: EOM_ELECTOR, should_capitulate: boolean)
function eom_elector.set_should_capitulate(self, should_capitulate)
    EOMLOG("Set the Elector ["..self:name().."] to capitulation status ["..tostring(should_capitulate).."] !")
    self._willCapitulate = should_capitulate
end

--v function(self: EOM_ELECTOR) --> boolean
function eom_elector.will_capitulate(self)
    return self._willCapitulate
end





--ui

--v function(self: EOM_ELECTOR) --> boolean
function eom_elector.is_hidden(self)
    return self._hideFromUi
end

--v function(self: EOM_ELECTOR) --> string
function eom_elector.image(self)
    return self._image
end

--v function(self: EOM_ELECTOR) --> string
function eom_elector.ui_name(self)
    return self._uiName
end

--v function(self: EOM_ELECTOR, visible: boolean)
function eom_elector.set_hidden(self, visible)
    EOMLOG("Set Elector ["..self:name().."] UI visibility to ["..tostring(visible).."] ")
    self._hideFromUi = visible
end

--leadership


--v function(self: EOM_ELECTOR) --> string
function eom_elector.leader_subtype(self)
    return self._leaderSubtype
end

--v function(self: EOM_ELECTOR) --> string
function eom_elector.leader_forename(self)
    return self._leaderForename
end

--v function(self: EOM_ELECTOR) --> string
function eom_elector.leader_surname(self)
    return self._leaderSurname
end



--v function(self: EOM_ELECTOR, subtype: string)
function eom_elector.set_leader_subtype(self, subtype)
    EOMLOG("Set leader subtype for ["..self:name().."] ")
    self._leaderSubtype = subtype
end

--v function(self: EOM_ELECTOR, forename: string)
function eom_elector.set_leader_forename(self, forename)
    EOMLOG("Set leader forename for ["..self:name().."] ")
    self._leaderForename = forename
end

--v function(self: EOM_ELECTOR, surname: string)
function eom_elector.set_leader_surname(self, surname)
    EOMLOG("Set leader surname for ["..self:name().."] ")
    self._leaderSurname = surname
end

--armies

--v function(self: EOM_ELECTOR, army_list: string)
function eom_elector.set_army_list(self, army_list)
    EOMLOG("Set the army list for ["..self:name().."] ")
    self._unitList = army_list
end

--v function(self: EOM_ELECTOR) --> string
function eom_elector.get_army_list(self)
    return self._unitList
end



--base regions

--v function(self: EOM_ELECTOR) --> number
function eom_elector.base_regions(self)
    return self._baseRegions
end

--v function(self: EOM_ELECTOR, count: number)
function eom_elector.set_base_regions(self, count)
    self._baseRegions = count
    EOMLOG("Set base regions for ["..self:name().."] to ["..tostring(self:base_regions()).."]")
end

--v function(self: EOM_ELECTOR) --> vector<string>
function eom_elector.home_regions(self)
    return self._homeRegions
end



--revival system

--v function(self: EOM_ELECTOR) --> number
function eom_elector.turns_dead(self)
    return self._turnsDead
end

--v function(self: EOM_ELECTOR) --> boolean
function eom_elector.can_revive(self)
    return self._canRevive
end

--v function(self: EOM_ELECTOR, can_revive: boolean)
function eom_elector.set_can_revive(self, can_revive)
    EOMLOG("Set Can Revive for Elector ["..self:name().."] to ["..tostring(can_revive).."] ")
    self._canRevive = can_revive
end

--v function(self: EOM_ELECTOR) 
function eom_elector.dead_for_turn(self)
    EOMLOG("entered", "eom_elector.dead_for_turn(self)")
    self._turnsDead = self._turnsDead + 1;
    EOMLOG(" ["..self:name().."] is dead this turn, incrementing their dead counter to ["..tostring(self:turns_dead()).."] ")
end

--v function(self: EOM_ELECTOR) --> (number, number)
function eom_elector.expedition_coordinates(self)
    return self._expeditionX, self._expeditionY
end

--v function(self: EOM_ELECTOR) --> string
function eom_elector.expedition_region(self)
    return self._expeditionRegion
end

--echos some information about the elector to the log.
--v function(self: EOM_ELECTOR)
function eom_elector.echo_information(self)
    EOMLOG("Echoing Elector ["..self:name().."] with loyalty ["..tostring(self:loyalty()).."], status ["..self:status().."], UI visibility: ["..tostring(self:is_hidden()).."] and capitulation flag ["..tostring(self:will_capitulate()).."] ")
end












--v function(self: EOM_ELECTOR, transfer_no_region: boolean?)
function eom_elector.respawn_at_capital(self, transfer_no_region)
    EOMLOG("Respawning elector ["..self:name().."] at capital with transfer no region ["..tostring(transfer_no_region).."] ")
    cm:create_force_with_general(
        self:name(),
        self:get_army_list(),
        self:capital(),
        cm:get_region(self:capital()):settlement():logical_position_x() + 1,
        cm:get_region(self:capital()):settlement():logical_position_y() + 1,
        "general",
        self:leader_subtype(),
        self:leader_forename(),
        "",
        self:leader_surname(), 
        "",
        true,
        function(cqi)

        end)
    if not transfer_no_region then
        cm:callback( function()
            cm:transfer_region_to_faction(self:capital(), self:name())
            cm:treasury_mod(self:name(), 5000)
        end, 0.2)
    end
end


--v function(self: EOM_ELECTOR, callback: function(model: EOM_MODEL))
function eom_elector.set_full_loyalty_callback(self, callback)
    EOMLOG("Set a fully loyal callback for "..self:name().." ")
    self._fullLoyaltyCallback = callback
end



--v function(self: EOM_ELECTOR, model: EOM_MODEL)
function eom_elector.set_fully_loyal(self, model)
    EOMLOG("Setting elector ["..self:name().."] fully loyal! ")
    self:set_status("loyal")
    self:make_fully_loyal()
    self._fullLoyaltyCallback(model)
    if cm:get_faction(EOM_GLOBAL_EMPIRE_FACTION):is_human() then
        cm:trigger_incident(EOM_GLOBAL_EMPIRE_FACTION, "eom_full_loyalty_"..self:name(), true)
    end
    if not cm:get_faction(self:name()):is_dead() then
        cm:force_confederation(EOM_GLOBAL_EMPIRE_FACTION, self:name())
    end
end

return {
    new = eom_elector.new
}


