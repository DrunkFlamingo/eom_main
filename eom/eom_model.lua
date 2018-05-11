EOMLOG("eom model required", "file.eom_model")

local eom_model = {} --# assume eom_model: EOM_MODEL


--model assembly


--v function() --> EOM_MODEL
function eom_model.new()
    EOMLOG("Starting Model Creation", "function.eom_model.new()")
    local self = {};
    setmetatable(self, {
        __index = eom_model
    })
    --# assume self: EOM_MODEL

    self.electors = {}--:map<string, EOM_ELECTOR>
    self.cults = {}--:map<string, EOM_CULT>
    self.civil_wars = {}--:vector<EOM_CIVIL_WAR>
    self.elector_actions = {} --:vector<EOM_ACTION>
    self.cult_actions = {} --:vector<EOM_ACTION>
    self.core_data = {} --:map<string, string | number | boolean>
    EOMLOG("******CREATED THE MODEL*****", "function.eom_model.new()")
    return self
end;

--object population

--v function(self: EOM_MODEL) --> map<string, WHATEVER>
function eom_model.save(self)
    local st = {}
    st.electors = {}
    for key, value in pairs(self.electors) do
        local s = self.electors[key]:save()
        table.insert(st.electors, s)
    end
    st.cults = {}
    for key, value in pairs(self.cults) do
        local s = self.cults[key]:save()
        table.insert(st.cults, s)
    end
    st.core_data = self.core_data

    return st
end


--v function(self: EOM_MODEL, key: string, elector: EOM_ELECTOR)
function eom_model.add_elector(self, key, elector)
    EOMLOG("Added elector with key ["..key.."]", "eom_model.add_elector(self, key,elector)")
    local electors = self.electors;
    electors[key] = elector;
end;

--v function(self: EOM_MODEL, key: string, cult: EOM_CULT)
function eom_model.add_cult(self, key, cult)
    EOMLOG("Added cult with key ["..key.."]", "eom_model.add_cult(self, key, elector)")
    local cults = self.cults
    cults[key] = cult
end;

--v function(self: EOM_MODEL, civil_war: EOM_CIVIL_WAR)
function eom_model.add_civil_war(self, civil_war)
    EOMLOG("Added a new civil war to the model", "eom_model.add_civil_war(self, civil_war)")
    table.insert(self.civil_wars, civil_war)
    civil_war.eom = self
end

--v function(self: EOM_MODEL, key: string, data: string | number | boolean)
function eom_model.add_core_data(self, key, data)
    EOMLOG("added core data with key ["..key.."] and value ["..tostring(data).."]", "eom_model.add_core_data(self, key_data)")
    local core_data = self.core_data
    core_data[key] = data
end

--v function(self: EOM_MODEL, action: EOM_ACTION)
function eom_model.add_elector_action(self, action)
    EOMLOG("added an action to the elector actions", "eom_model.add_elector_action(self, action)")
    table.insert(self.elector_actions, action)
    action.eom = self
end

--v function(self: EOM_MODEL, action: EOM_ACTION)
function eom_model.add_cult_action(self, action)
    EOMLOG("added an action to the cult actions", "eom_model.add_cult_action(self, action)")
    table.insert(self.cult_actions, action)
end

--retval--

--v function(self: EOM_MODEL, key: string) --> number | string | boolean
function eom_model.get_core_data(self, key)
    EOMLOG("retrieved core data piece at ["..key.."]", "eom_model.get_core_data(self, key)")
    return self.core_data[key]
end

--v function(self: EOM_MODEL, key: string) --> EOM_ELECTOR
function eom_model.get_elector(self, key)
    EOMLOG("retrieved elector object ["..key.."]", "eom_model.get_elector(self, key)")
    return self.electors[key]
end

--v function(self: EOM_MODEL, key: string) --> EOM_CULT
function eom_model.get_cult(self, key)
    EOMLOG("retrieved cult object ["..key.."]", "eom_model.get_cult(self_key)")
    return self.cults[key]
end




return {
    new = eom_model.new
}