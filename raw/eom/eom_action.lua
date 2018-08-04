local eom_action = {} --# assume eom_action: EOM_ACTION

--v function(key: string, conditional: function(eom: EOM_MODEL) --> boolean, choices: map<number, function(eom: EOM_MODEL)>, eom: EOM_MODEL) --> EOM_ACTION
function eom_action.new(key, conditional, choices, eom)
    local self = {}
    setmetatable(
        self, {
            __index = eom_action
        }
    )--# assume self: EOM_ACTION

    self._key = key
    self._condition = conditional
    self._choices = choices
    self._eom = eom
    EOMLOG("Created a new Action with key ["..key.."]")
    return self
end

--v function(self: EOM_ACTION) --> EOM_MODEL
function eom_action.model(self)
    return self._eom
end


--v function(self: EOM_ACTION) --> string
function eom_action.key(self)
    return self._key
end

--v function(self: EOM_ACTION) --> boolean
function eom_action.allowed(self)
    return self._condition(self:model())
end

--v function(self: EOM_ACTION, choice: number)
function eom_action.do_choice(self, choice)
    EOMLOG("Doing choice callback ["..tostring(choice).."] for event ["..self:key().."]")
    local choice_callback = self._choices[choice]
    choice_callback(self:model())
end

--v function(self: EOM_ACTION)
function eom_action.act_ai(self)
    EOMLOG("Preforming action ["..self:key().."] for an AI emperor")
    if self._choices[3] ~= nil and self._choices[4] ~= nil then
        local choice = cm:random_number(4)
        local choice_callback = self._choices[choice]
        choice_callback(self:model())
    else   
        local choice = cm:random_number(2)
        local choice_callback = self._choices[choice]
        choice_callback(self:model())
    end
end
    

--v function(self: EOM_ACTION)
function eom_action.act(self)
    EOMLOG("Preforming action ["..self:key().."] ")
    cm:trigger_dilemma(EOM_GLOBAL_EMPIRE_FACTION, self:key(), true)
    core:add_listener(
        self:key(),
        "DilemmaChoiceMadeEvent",
        function(context)
            return context:faction():name() == EOM_GLOBAL_EMPIRE_FACTION
        end,
        function(context)
            self:do_choice((context:choice()+1))
        end,
        false)
end
    

return {
    new = eom_action.new
}
