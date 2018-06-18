local eom_civil_war = {} --# assume eom_civil_war: EOM_CIVIL_WAR

--v function(name: string, model: EOM_MODEL) --> EOM_CIVIL_WAR
function eom_civil_war.new(name, model)
local self = {}
setmetatable(self, {
    __index = eom_civil_war
}) --# assume self: EOM_CIVIL_WAR

self._name = name
self._model = model 
self._current_stage = 0 --:int
self._triggers = {} --:vector<function(eom: EOM_MODEL) --> boolean>
self._callbacks = {} --:vector<function(eom: EOM_MODEL)>
if cm:get_saved_value("civil_war_ended_"..name) == nil then
    cm:set_saved_value("civil_war_ended"..name,false) 
end


return self
end

--v function(self: EOM_CIVIL_WAR) --> string
function eom_civil_war.name(self)
    return self._name
end

--v function(self: EOM_CIVIL_WAR) --> EOM_MODEL
function eom_civil_war.model(self)
    return self._model
end

--v function(self: EOM_CIVIL_WAR) --> int
function eom_civil_war.current_stage(self)
    return self._current_stage
end

--v function(self: EOM_CIVIL_WAR, stage: int)
function eom_civil_war.set_stage(self, stage)
    EOMLOG("Advancing stage for civil war ["..self:name().."] to ["..tostring(stage).."] ")
    self._current_stage = stage
end

--v function(self: EOM_CIVIL_WAR, stage: integer) --> boolean
function eom_civil_war.has_stage(self, stage)
    return not not self._triggers[stage]
end

--v function(self: EOM_CIVIL_WAR, stage: integer)
function eom_civil_war.stage_callback(self, stage)
    if not self._callbacks[stage] then
        EOMLOG("No callbacks for stage ["..tostring(stage).."] in civil war ["..self:name().."] ")
        return
    end
    self._callbacks[stage](self:model())
end


--v function(self: EOM_CIVIL_WAR, stage: integer) --> boolean
function eom_civil_war.check_trigger(self, stage)
    return self._triggers[stage](self:model())
end



--v function(self: EOM_CIVIL_WAR) --> boolean
function eom_civil_war.is_over(self)
    return cm:get_saved_value("civil_war_ended_"..self:name())
end

--v function(self: EOM_CIVIL_WAR)
function eom_civil_war.check_advancement(self)
    if self:is_over() then
        EOMLOG("Checked advancement for civil war ["..self:name().."] but that civil war is over! ")
        return 
    end
    local c_stage = self:current_stage()
    local n_stage = c_stage + 1;
    if self:has_stage(n_stage) and self:check_trigger(n_stage) then
        self:set_stage(n_stage)
        self:stage_callback(n_stage)
    else 
        EOMLOG("Civil war ["..self:name().."] is ready to advance but has no next stage!!")
    end
end

--v function(self: EOM_CIVIL_WAR, stage: int, trigger: function(model: EOM_MODEL) --> boolean)
function eom_civil_war.add_stage_trigger(self, stage, trigger)
EOMLOG("")
    self._triggers[stage] = trigger
end