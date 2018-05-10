local eom_action = {} --# assume eom_action: EOM_ACTION
EOMLOG("Loading the eom_action object", "file.eom_action")

--v function(condition:function(eom: EOM_MODEL) --> boolean, callback: function(eom: EOM_MODEL)) --> EOM_ACTION
function eom_action.new(condition, callback)
    local self = {}
    setmetatable(self, {
        __index = eom_action
    })
    --# assume self: EOM_ACTION
    self.condition = condition
    self.callback = callback
    self.eom = nil --:EOM_MODEL

    return self
end



--v function(self: EOM_ACTION) --> boolean
function eom_action.check(self)
    return self.condition(self.eom)
end

--v function(self: EOM_ACTION)
function eom_action.act(self)
    return self.callback(self.eom)
end


return {
    new = eom_action.new
}