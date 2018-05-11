eom_trait = {} --# assume eom_trait: EOM_TRAIT

--v function(name: string, entity: EOM_ENTITY, event: string, conditional: function(context: WHATEVER) --> boolean, loyaltychange: int) --> EOM_TRAIT
function eom_trait.new(name, entity, event, conditional, loyaltychange)
local self = {}
setmetatable(self, {
    __index = eom_trait
})
--# assume self: EOM_TRAIT

self.name = name
self.eom = nil --: EOM_MODEL
self.entity = entity
self.event = event
self.conditional = conditional
self.loyalty_change = loyaltychange

return self
end

--v function(self: EOM_TRAIT,eom: EOM_MODEL)
function eom_trait.activate(self, eom)
    self.eom = eom
    core:add_listener(
        self.name,
        self.event,
        function(context)
            return self.conditional(context)
        end,
        function(context)
            self.entity:change_loyalty(self.loyalty_change)
        end,
        true)
end

--v function(self: EOM_TRAIT) --> string
function eom_trait.get_name(self)
    return self.name
end

--v function(self: EOM_TRAIT)
function eom_trait.deactivate(self)
    core:remove_listener(self.name)
end



return {
    new = eom_trait.new
}