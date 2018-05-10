local eom_elector = {} --# assume eom_elector: EOM_ELECTOR
EOMLOG("Loading the eom_elector object", "file.eom_elector")
--object assembly

--v function(info: map<string, WHATEVER>) --> EOM_ELECTOR
function eom_elector.new(info)
    local self = {}
    setmetatable(self, {
        __index = eom_elector
    })
    --# assume self: EOM_ELECTOR

    -- script variables
    self.loyalty = info.loyalty --:integer
    self.fully_loyal = info.fully_loyal --:boolean
    self.hidden = info.hidden --:boolean
    self.base_power = info.base_power --:integer
    self.faction_name = info.faction_name --:string
    self.ui_name = info.ui_name --:string
    self.image = info.image --:string
    self.tooltip = info.tooltip --:string
    self.status = info.status --:int
    self.leader_subtype = info.leader_subtype --:string
    self.leader_forename = info.leader_forename --:string
    self.leader_surname = info.leader_surname --:string
    self.capital = info.capital --:string
    self.expedition_x = info.expedition_x --:number
    self.expedition_y = info.expedition_y --:number
    self.traits = {} --: vector<map<string, string>>
    self.expedition_region = info.expedition_region --:string
    self.turns_dead = info.turns_dead --:number
    self.revive_happened = info.revive_happened --:boolean
    self.base_regions = info.base_regions --:int
    -- game variables
    self.dead = get_faction(self.faction_name):is_dead();
    self.regions_count = get_faction(self.faction_name):region_list():num_items();
    self.capital_x = get_region(self.capital):settlement():logical_position_x() --:number
    self.capital_y = get_region(self.capital):settlement():logical_position_y() --:number
    return self;
end;

--v function(self: EOM_ELECTOR) --> map<string, WHATEVER>
function eom_elector.save(self)
    local save_table = {} --:map<string, WHATEVER>
    save_table.loyalty = self.loyalty 
    save_table.fully_loyal = self.fully_loyal 
    save_table.hidden = self.hidden 
    save_table.base_power = self.base_power 
    save_table.faction_name = self.faction_name 
    save_table.ui_name = self.ui_name
    save_table.image = self.image 
    save_table.tooltip = self.tooltip
    save_table.status = self.status 
    save_table.leader_subtype = self.leader_subtype
    save_table.leader_forename = self.leader_forename
    save_table.leader_surname = self.leader_surname
    save_table.capital = self.capital 
    save_table.expedition_x = self.expedition_x 
    save_table.expedition_y = self.expedition_y 
    save_table.traits = self.traits
    save_table.expedition_region = self.expedition_region 
    save_table.turns_dead = self.turns_dead 
    save_table.revive_happened = self.revive_happened 
    save_table.base_regions = self.base_regions 
    return save_table
end

--general
--most changes handled up stream but functions can be directly called.

--v function(self: EOM_ELECTOR) --> int
function eom_elector.get_loyalty(self)
    EOMLOG("retrieved elector loyalty ["..self.faction_name.."]", "eom_elector.get_loyalty(self)")
    return self.loyalty
end;

--v function(self: EOM_ELECTOR, value: int) 
function eom_elector.set_loyalty(self, value)
    EOMLOG("set elector loyalty ["..self.faction_name.."] to ["..tostring(value).."]", "eom_elector.set_loyalty(self, value)")
    self.loyalty = value
end

--v function(self: EOM_ELECTOR, value: int)
function eom_elector.change_loyalty(self, value)
    EOMLOG("changed elector loyalty ["..self.faction_name.."] from ["..self.loyalty.."] to ["..tostring(self.loyalty + value).."]", "eom_elector.change_loyalty(self, value)")
    self.loyalty = self.loyalty + value
end

--v function(self: EOM_ELECTOR, status: int)
function eom_elector.set_status(self, status)
    EOMLOG("set elector status ["..self.faction_name.."] to ["..tostring(status).."]", "eom_elector.set_status")
    self.status = status
end

--v function(self: EOM_ELECTOR) --> int
function eom_elector.get_status(self)
    return self.status
end


--v function(self: EOM_ELECTOR)
function eom_elector.refresh(self)
    self.dead = get_faction(self.faction_name):is_dead();
    self.regions_count = get_faction(self.faction_name):region_list():num_items();
    if self.status > 0 then --we only want to count dead turns and cause revivals if the elector exists and is part of the empire.
        if self.dead == true then
            self.turns_dead = self.turns_dead + 1;
        elseif self.dead == false then
            self.turns_dead = 0;
        end
    end
end


--ui api
--v function(self: EOM_ELECTOR) --> int
function eom_elector.num_traits(self)
    return #self.traits
end

--v function(self: EOM_ELECTOR, i: int) --> map<string, string>
function eom_elector.get_trait(self, i)
    return self.traits[i]
end

--v function(self: EOM_ELECTOR) --> string
function eom_elector.get_image(self)
    return self.image
end


--v function(self: EOM_ELECTOR)
function eom_elector.hide(self)
    EOMLOG("hid ["..self.faction_name.."]", "eom_elector.hide(self)")
    self.hidden = true
end

--v function(self: EOM_ELECTOR)
function eom_elector.show(self)
    EOMLOG("showed ["..self.faction_name.."]", "eom_elector.show(self)")
    self.hidden = false
end

--v function(self: EOM_ELECTOR, visible: boolean)
function eom_elector.set_visible(self, visible)
    self.hidden = visible
end

--v function(self: EOM_ELECTOR, tooltip: string)
function eom_elector.set_tooltip(self, tooltip)
    self.tooltip = tooltip
end

--v function(self:EOM_ELECTOR) --> string
function eom_elector.get_ui_name(self)
    return self.ui_name
end






--integration API for Mixu's lords

--v function(self: EOM_ELECTOR, subtype: string)
function eom_elector.set_leader_subtype(self, subtype)
    self.leader_subtype = subtype
end

--v function(self: EOM_ELECTOR, forename: string)
function eom_elector.set_leader_forename(self, forename)
    self.leader_forename = forename
end

--v function(self: EOM_ELECTOR, surname: string)
function eom_elector.set_leader_surname(self, surname)
    self.leader_surname = surname
end



--elector restoration event support


--v function(self: EOM_ELECTOR) --> string
function eom_elector.get_leader_subtype(self)
    return self.leader_subtype
end

--v function(self: EOM_ELECTOR) --> string 
function eom_elector.get_leader_forename(self)
    return self.leader_forename
end

--v function(self: EOM_ELECTOR) --> string
function eom_elector.get_leader_surname(self)
    return self.leader_surname
end

--v function(self: EOM_ELECTOR) --> string
function eom_elector.get_capital_key(self)
    return self.capital
end

--v function(self: EOM_ELECTOR) --> CA_REGION
function eom_elector.get_capital_region(self)
    return get_region(self.capital)
end

--v function(self: EOM_ELECTOR) --> number
function eom_elector.get_expedition_x(self)
    return self.expedition_x
end

--v function(self: EOM_ELECTOR) --> number
function eom_elector.get_expedition_y(self)
    return self.expedition_y
end

--v function(self: EOM_ELECTOR) --> string
function eom_elector.get_expedition_region(self)
    return self.expedition_region
end

--casus belli

--v function(self: EOM_ELECTOR) --> int
function eom_elector.get_base_size(self)
    return self.base_regions
end

--v function(self: EOM_ELECTOR, size: int)
function eom_elector.set_base_size(self, size)
    self.base_regions = size
end

--v function(self: EOM_ELECTOR, player: string) --> boolean
function eom_elector.is_casus_belli_by(self, player)
    return get_faction(self.faction_name):has_effect_bundle("eom_casus_belli_"..self.faction_name)
end

--v function(self: EOM_ELECTOR)
function eom_elector.grant_casus_belli(self)
    if not get_faction(self.faction_name):has_effect_bundle("eom_casus_belli_"..self.faction_name) then
        cm:apply_effect_bundle("eom_casus_belli_"..self.faction_name, self.faction_name, 6)
    end
end

return {
    new = eom_elector.new
}