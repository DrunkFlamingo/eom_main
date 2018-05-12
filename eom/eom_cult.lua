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

--general

--v function(self: EOM_CULT) --> string
function eom_cult.get_faction_name(self)
    return self.faction_name
end


--v function(self: EOM_CULT) --> int
function eom_cult.get_loyalty(self)
    EOMLOG("retrieved elector loyalty ["..self.faction_name.."]", "eom_elector.get_loyalty(self)")
    return self.loyalty
end;

--v function(self: EOM_CULT, value: int) 
function eom_cult.set_loyalty(self, value)
    EOMLOG("set elector loyalty ["..self.faction_name.."] to ["..tostring(value).."]", "eom_elector.set_loyalty(self, value)")
    self.loyalty = value
end

--v function(self: EOM_CULT, value: int)
function eom_cult.change_loyalty(self, value)
    EOMLOG("changed elector loyalty ["..self.faction_name.."] from ["..self.loyalty.."] to ["..tostring(self.loyalty + value).."]", "eom_elector.change_loyalty(self, value)")
    self.loyalty = self.loyalty + value
end



--ui

--v function(self: EOM_CULT) --> string
function eom_cult.get_ui_name(self)
    return self.ui_name
end

--v function(self: EOM_CULT) --> string
function eom_cult.get_image(self)
    return "ui/flags/"..self.faction_name.."/mon_rotated.png"
end


--invasions and spawns

--v function(self: EOM_CULT) --> (number, number)
function eom_cult.get_spawn_location(self)
    return self.spawn_x, self.spawn_y
end

--v function(self: EOM_CULT) --> (number, number)
function eom_cult.get_secondary_spawn_location(self)
    return self.second_spawn_x, self.second_spawn_y
end


--v function(self: EOM_CULT) --> string
function eom_cult.get_leader_forname(self)
    return self.leader_forename;
end;

--v function(self: EOM_CULT) --> string
function eom_cult.get_leader_surname(self)
    return self.leader_surname;
end;

--v function(self: EOM_CULT) --> string
function eom_cult.get_leader_subtype(self)
    return self.leader_subtype;
end;

--v function(self: EOM_CULT) --> string
function eom_cult.get_leader_region(self)
    return self.leader_region
end


--v function(self: EOM_CULT) --> string
function eom_cult.get_second_forname(self)
    return self.second_forename;
end;

--v function(self: EOM_CULT) --> string
function eom_cult.get_second_surname(self)
    return self.second_surname;
end;

--v function(self: EOM_CULT) --> string
function eom_cult.get_second_subtype(self)
    return self.second_subtype;
end;

--v function(self: EOM_CULT) --> string
function eom_cult.get_second_region(self)
    return self.second_region
end










return {
    new = eom_cult.new
}