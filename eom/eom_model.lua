local eom = {} --# assume eom: EOM_MODEL
EOMLOG("eom model required", "eom_model.file")

--v function() --> EOM_MODEL
function eom.new()

local self = {} 
setmetatable({
    __index = eom
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

--v function(self: EOM_MODEL, key: string, elector: EOM_ELECTOR)
function eom.add_elector(self, key, elector)

local electors = self.electors;
electors[key] = elector;

end;

--v function(self: EOM_MODEL, key: string, cult: EOM_CULT)
function eom.add_cult(self, key, cult)

local cults = self.cults
cults[key] = cult

end;

--v function(self: EOM_MODEL, civil_war: EOM_CIVIL_WAR)
function eom.add_civil_war(self, civil_war)
    table.insert(self.civil_wars, civil_war)
end

--v function(self: EOM_MODEL, key: string, data: string | number)
function eom.add_core_data(self, key, data)
    local core_data = self.core_data
    core_data[key] = data
end

--v function(self: EOM_MODEL, action: EOM_ACTION)
function eom.add_elector_action(self, action)
    table.insert(self.elector_actions, action)
end

--v function(self: EOM_MODEL, action: EOM_ACTION)
function eom.add_cult_action(self, action)
    table.insert(self.cult_actions, action)
end

--retval--

--v function(self: EOM_MODEL, key: string) --> number | string
function eom.get_core_data(self, key)
    return self.core_data[key]
end




return {
    new = eom.new
}