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
    --ui
    self._hideFromUi = info._hideFromUi
    self._image = info._image
    self._uiName = info._uiName
    self._uiTooltip = info._uiTooltip
    self._isCult = info._isCult
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
    return savetable
end


--keys

--v function(self: EOM_ELECTOR) --> string
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
    if self:is_loyal() then
        EOMLOG("this elector is fully loyal, aborting")
        return
    end
    self._state = status
    EOMLOG("set status for ["..self:name().."] to ["..self:status().."]")
end


--loyalty

--v function(self: EOM_ELECTOR) --> number
function eom_elector.loyalty(self)
    return self._loyalty;
end

--v function(self: EOM_ELECTOR, changevalue: number)
function eom_elector.change_loyalty(self, changevalue)
    EOMLOG("entered", "eom_elector.change_loyalty(self, changevalue)")
    if self:is_loyal() then
        EOMLOG("Not applying any loyalty change  to ["..self:name().."] because the elector is fully loyal!")
        return
    end
    if not self:status() == "normal" then
        EOMLOG("Not applying any loyalty change to ["..self:name().."] because the elector has a non-normal status!")
        return
    end
    local ov = self._loyalty;
    local nv = ov + changevalue;
    if nv > 100 then nv = 100 end;
    if nv < 0 then nv = 0 end;
    self._loyalty = nv;
    EOMLOG("changed loyalty for ["..self:name().."] by ["..tostring(changevalue).."] to ["..self:loyalty().."] ")
end

--v function(self: EOM_ELECTOR, setvalue: number)
function eom_elector.set_loyalty(self, setvalue)
    EOMLOG("entered", "eom_elector.change_loyalty(self, changevalue)")
    if self:is_loyal() then
        EOMLOG("WARNING: setting the loyalty of a fully loyal elector!!!")
    end
    self._loyalty = setvalue
    EOMLOG("set loyalty for ["..self:name().."] to ["..self:loyalty().."] ")
end

--power

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
function eom_elector.set_visible(self, visible)
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
    self._leaderSubtype = subtype
end

--v function(self: EOM_ELECTOR, forename: string)
function eom_elector.set_leader_forename(self, forename)
    self._leaderForename = forename
end

--v function(self: EOM_ELECTOR, surname: string)
function eom_elector.set_leader_surname(self, surname)
    self._leaderSurname = surname
end



--base regions

--v function(self: EOM_ELECTOR) --> number
function eom_elector.base_region_count(self)
    return self._baseRegions
end

--v function(self: EOM_ELECTOR, count: number)
function eom_elector.set_base_regions(self, count)
    EOMLOG("Entered", "eom_elector.set_base_regions(self, count)")
    self._baseRegions = count
    EOMLOG("Set base regions for ["..self:name().."] to ["..tostring(self:base_region_count()).."]")
end


--revival system

--v function(self: EOM_ELECTOR) --> number
function eom_elector.turns_dead(self)
    return self._turnsDead
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


return {
    new = eom_elector.new
}


