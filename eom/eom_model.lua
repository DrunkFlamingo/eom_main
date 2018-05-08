EOMLOG("eom model required", "eom_model.file")

local eom_model = {} --# assume eom_model: EOM_MODEL


--model assembly


--v function() --> EOM_MODEL
function eom_model.new()
    local self = {} 
    setmetatable({
        __index = eom_model
    })
    --# assume self: EOM_MODEL

    self.electors = {}--:map<string, EOM_ELECTOR>
    self.cults = {}--:map<string, EOM_CULT>
    self.civil_wars = {}--:vector<EOM_CIVIL_WAR>
    self.elector_actions = {} --:vector<EOM_ACTION>
    self.cult_actions = {} --:vector<EOM_ACTION>
    self.core_data = {} --:map<string, string | number>

    return self
end;

--object population

--v function(self: EOM_MODEL, key: string, elector: EOM_ELECTOR)
function eom_model.add_elector(self, key, elector)
    local electors = self.electors;
    electors[key] = elector;
end;

--v function(self: EOM_MODEL, key: string, cult: EOM_CULT)
function eom_model.add_cult(self, key, cult)
    local cults = self.cults
    cults[key] = cult
end;

--v function(self: EOM_MODEL, civil_war: EOM_CIVIL_WAR)
function eom_model.add_civil_war(self, civil_war)
    table.insert(self.civil_wars, civil_war)
    civil_war.eom = self
end

--v function(self: EOM_MODEL, key: string, data: string | number)
function eom_model.add_core_data(self, key, data)
    local core_data = self.core_data
    core_data[key] = data
end

--v function(self: EOM_MODEL, action: EOM_ACTION)
function eom_model.add_elector_action(self, action)
    table.insert(self.elector_actions, action)
    action.eom = self
end

--v function(self: EOM_MODEL, action: EOM_ACTION)
function eom_model.add_cult_action(self, action)
    table.insert(self.cult_actions, action)
end

--retval--

--v function(self: EOM_MODEL, key: string) --> number | string
function eom_model.get_core_data(self, key)
    return self.core_data[key]
end

--v function(self: EOM_MODEL, key: string) --> EOM_ELECTOR
function eom_model.get_elector(self, key)
    return self.electors[key]
end

--v function(self: EOM_MODEL, key: string) --> EOM_CULT
function eom_model.get_cult(self, key)
    return self.cults[key]
end




return {
    new = eom_model.new
}