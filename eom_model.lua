local eom = {} --# assume eom: EOM_MODEL


--v function(loyalty_table: map<string, number>, cult_appeasment_table: map<string, number>, all_elector:vector<string>, all_cult: vector<string>, elector_status: map<string, number>, elector_actions_table: vector<map<string, function(EOM_MODEL) --> WHATEVER>>, cult_actions_table: vector<map<string, function(EOM_MODEL) --> WHATEVER>>, civil_wars_table: vector<map<string, function(EOM_MODEL)>>, elector_ui_traits: map<string, vector<map<string, string>>>, elector_conditions: map<string, string>, elector_respawn_data: map<string, map<string, string>>)
function eom.new(loyalty_table, cult_appeasment_table, all_elector, all_cult, elector_status, elector_actions_table, cult_actions_table, civil_wars_table, elector_ui_traits, elector_conditions, elector_respawn_data)

local self = {} 
setmetatable({
    __index = eom
})
--# assume self: EOM_MODEL

self.loyalty_index = loyalty_table --:map<string, number>
self.appeasement_index = cult_appeasment_table




end;




