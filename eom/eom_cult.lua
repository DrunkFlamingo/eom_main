local eom_cult = {} --# assume eom_cult: EOM_CULT
EOMLOG("Loading the eom_cult object", "file.eom_cult")

--cult object assembly

--v function(info: map<string, WHATEVER>) --> EOM_CULT
function eom_cult.new(info)
    local self = {}
    setmetatable({
        __index = eom_cult
    })
    --# assume self: EOM_CULT

    self.faction_name = info.faction_name --:string
    self.loyalty = info.loyalty --: int
    self.spawn_x = info.spawn_x --: number
    self.spawn_y = info.spawn_y --: number
    self.second_spawn_x = info.second_spawn_x --: number
    self.second_spawn_y = info.second_spawn_y --: number
    self.leader_forename = info.leader_forename --:string
    self.leader_title = info.leader_title --:string
    self.leader_surname = info.leader_surname --:string 
    self.second_forename = info.second_surname --:string
    self.second_title = info.second_title --:string
    self.second_surname = info.second_surname --:string
    self.leader_region = info.leader_region --:string
    self.second_region = info.second_region --:string


    return self;
end;

--v function(self: EOM_CULT) --> map<string, WHATEVER>
function eom_cult.save(self)
    local save_table = {} --: map<string, WHATEVER>

    save_table.faction_name = self.faction_name
    save_table.loyalty = self.loyalty 
    save_table.spawn_x = self.spawn_x 
    save_table.spawn_y = self.spawn_y 
    save_table.second_spawn_x = self.second_spawn_x 
    save_table.second_spawn_y = self.second_spawn_y 
    save_table.leader_forename = self.leader_forename 
    save_table.leader_title = self.leader_title 
    save_table.leader_surname = self.leader_surname 
    save_table.second_forename = self.second_surname 
    save_table.second_title = self.second_title 
    save_table.second_surname = self.second_surname 
    save_table.leader_region = self.leader_region 
    save_table.second_region = self.second_region 

    return save_table
end

return {
    new = eom_cult.new
}