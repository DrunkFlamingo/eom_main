local eom_action = {} --# assume eom_action: EOM_ACTION
EOMLOG("Loading the eom_action object", "file.eom_action")

--v function(name: string, condition:function(eom: EOM_MODEL) --> boolean, callback: function(eom: EOM_MODEL)) --> EOM_ACTION
function eom_action.new(name, condition, callback)
    local self = {}
    setmetatable(self, {
        __index = eom_action
    })
    --# assume self: EOM_ACTION
    self.condition = condition
    self.callback = callback
    self.eom = nil --:EOM_MODEL
    self.name = name 

    return self
end

--v function(self: EOM_ACTION, model: EOM_MODEL)
function eom_action.register_to_model(self, model)
    self.eom = model
end;


--v function(self: EOM_ACTION) --> boolean
function eom_action.check(self)
    EOMLOG("Checking an Action Validity for ["..self.name.."] ", "eom_action.check(self)")
    return self.condition(self.eom)
end

--v function(self: EOM_ACTION)
function eom_action.act(self)
    EOMLOG("Action ["..self.name.."] is triggering", "eom_action.act(self)")
    return self.callback(self.eom)
end


return {
    new = eom_action.new
}