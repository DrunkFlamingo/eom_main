local eom_plot = {} --# assume eom_plot: EOM_PLOT

--v function(name: string, model: EOM_MODEL) --> EOM_PLOT
function eom_plot.new(name, model)
local self = {}
setmetatable(self, {
    __index = eom_plot
}) --# assume self: EOM_PLOT
EOMLOG("Creating plot line ["..name.."] ")
self._name = name
self._model = model 
if cm:get_saved_value("plot_line_stage"..name) then
    self._current_stage = cm:get_saved_value("plot_line_stage"..name) --:int
    EOMLOG("Loaded stage ["..tostring(self._current_stage).."] for plot element ["..name.."]")
else
    self._current_stage = 0
end
self._triggers = {} --:vector<function(eom: EOM_MODEL) --> boolean>
self._callbacks = {} --:vector<function(eom: EOM_MODEL)>
if cm:get_saved_value("plot_line_ended_"..name) == nil then
    cm:set_saved_value("civil_war_ended"..name,false) 
end


return self
end

--v function(self: EOM_PLOT) --> string
function eom_plot.name(self)
    return self._name
end

--v function(self: EOM_PLOT) --> EOM_MODEL
function eom_plot.model(self)
    return self._model
end

--v function(self: EOM_PLOT) --> int
function eom_plot.current_stage(self)
    return self._current_stage
end

--v function(self: EOM_PLOT, stage: int)
function eom_plot.set_stage(self, stage)
    EOMLOG("Advancing stage for civil war ["..self:name().."] to ["..tostring(stage).."] ")
    self._current_stage = stage
    cm:set_saved_value("plot_line_stage"..self:name(), self:current_stage())
end

--v function(self: EOM_PLOT, stage: integer) --> boolean
function eom_plot.has_stage(self, stage)
    return not not self._triggers[stage]
end

--v function(self: EOM_PLOT, stage: integer)
function eom_plot.stage_callback(self, stage)
    if not self._callbacks[stage] then
        EOMLOG("No callbacks for stage ["..tostring(stage).."] in civil war ["..self:name().."] ")
        return
    end
    local stage_callback = self._callbacks[stage]
    stage_callback(self:model())
end


--v function(self: EOM_PLOT, stage: integer) --> boolean
function eom_plot.check_trigger(self, stage)
    local stage_trigger = self._triggers[stage]
    return stage_trigger(self:model())
end



--v function(self: EOM_PLOT) --> boolean
function eom_plot.is_over(self)
    return cm:get_saved_value("plot_line_ended_"..self:name())
end

--v function(self: EOM_PLOT) --> boolean
function eom_plot.is_active(self)
    return (not cm:get_saved_value("plot_line_ended_"..self:name())) and (self:current_stage() > 0)
end


--v [NO_CHECK] function(self: EOM_PLOT)--> boolean
function eom_plot.check_advancement(self) 
    if self:is_over() then
        EOMLOG("Checked advancement for civil war ["..self:name().."] but that civil war is over! ")
        return false
    end
    if self:model():get_core_data_with_key("test_all_plot_events") == true then
        return true
    end
    local c_stage = self:current_stage()
    local n_stage = c_stage + 1;
    if self:has_stage(n_stage) and self:check_trigger(n_stage) then
        return true
    else 
        EOMLOG("Civil war ["..self:name().."] is not advancing")
        return false
    end
end

--v function (self: EOM_PLOT)
function eom_plot.advance(self)
    local c_stage = self:current_stage()
    local n_stage = c_stage + 1;
    self:set_stage(n_stage)
    self:stage_callback(n_stage)
end

--v function(self: EOM_PLOT, stage: int, trigger: function(model: EOM_MODEL) --> boolean)
function eom_plot.add_stage_trigger(self, stage, trigger)
EOMLOG("Added trigger for stage ["..tostring(stage).."] in plot line ["..self:name().."]")
    self._triggers[stage] = trigger
end
--v function(self: EOM_PLOT, stage: int, callback: function(model: EOM_MODEL))
function eom_plot.add_stage_callback(self, stage, callback)
    EOMLOG("Added callback for stage ["..tostring(stage).."] in plot line ["..self:name().."]")
    self._callbacks[stage] = callback
end

--v function(self: EOM_PLOT)
function eom_plot.finish(self)
    cm:set_saved_value("plot_line_ended_"..self:name(), true)
end

--v function(self: EOM_PLOT)
function eom_plot.save(self)
    cm:set_saved_value("plot_line_stage"..self:name(), self:current_stage())
end



return {
    new = eom_plot.new
}