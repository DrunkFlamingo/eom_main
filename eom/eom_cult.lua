local eom_cult = {} --# assume eom_cult: EOM_CULT
EOMLOG("Loading the eom_cult object", "file.eom_cult")

--cult object assembly

--v function(info: map<string, WHATEVER>) --> EOM_CULT
function eom_cult.new(info)
    local self = {}
    setmetatable(self, {
        __index = eom_cult
    })
    --# assume self: EOM_CULT

    self.faction_name = info.faction_name --:string
    self.ui_name = info.ui_name --:string
    self.loyalty = info.loyalty --: int
    self.spawn_x = info.spawn_x --: number
    self.spawn_y = info.spawn_y --: number
    self.second_spawn_x = info.second_spawn_x --: number
    self.second_spawn_y = info.second_spawn_y --: number
    self.leader_forename = info.leader_forename --:string
    self.leader_subtype = info.leader_subtype --:string
    self.leader_surname = info.leader_surname --:string 
    self.second_forename = info.second_surname --:string
    self.second_subtype = info.second_subtype --:string
    self.second_surname = info.second_surname --:string
    self.leader_region = info.leader_region --:string
    self.second_region = info.second_region --:string


    return self;
end;

--v function(self: EOM_CULT) --> map<string, WHATEVER>
function eom_cult.save(self)
    local save_table = {} --: map<string, WHATEVER>

    save_table.faction_name = self.faction_name
    save_table.ui_name = self.ui_name
    save_table.loyalty = self.loyalty 
    save_table.spawn_x = self.spawn_x 
    save_table.spawn_y = self.spawn_y 
    save_table.second_spawn_x = self.second_spawn_x 
    save_table.second_spawn_y = self.second_spawn_y 
    save_table.leader_forename = self.leader_forename 
    save_table.leader_subtype = self.leader_subtype 
    save_table.leader_surname = self.leader_surname 
    save_table.second_forename = self.second_surname 
    save_table.second_subtype = self.second_subtype 
    save_table.second_surname = self.second_surname 
    save_table.leader_region = self.leader_region 
    save_table.second_region = self.second_region 

    return save_table
end














return {
    new = eom_cult.new
}