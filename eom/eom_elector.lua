local eom_elector = {} --# assume eom_elector: EOM_ELECTOR
EOMLOG("Loading the eom_elector object", "file.eom_elector")
--object assembly

--v function(info: map<string, WHATEVER>) --> EOM_ELECTOR
function eom_elector.new(info)
    local self = {}
    setmetatable({
        __index = eom_elector
    })
    --# assume self: EOM_ELECTOR

    -- script variables
    self.loyalty = info.loyalty --:integer
    self.fully_loyal = info.fully_loyal --:boolean
    self.hidden = info.hidden --:boolean
    self.base_power = info.base_power --:integer
    self.faction_name = info.faction_name --:string
    self.image = info.image --:string
    self.tooltip = info.tooltip --:string
    self.status = info.status --:number
    self.leader_subtype = info.leader_subtype --:string
    self.leader_forename = info.leader_forename --:string
    self.leader_surname = info.leader_surname --:string
    self.capital = info.capital --:string
    self.capital_x = info.capital_x --:number
    self.capital_y = info.capital_y --:number
    self.expedition_x = info.expedition_x --:number
    self.expedition_y = info.expedition_y --:number
    self.expedition_region = info.expedition_region --:string
    self.turns_dead = info.turns_dead --:number
    self.revive_happened = info.revive_happened --:boolean
    self.base_regions = info.base_regions --:int
    -- game variables
    self.dead = get_faction(self.faction_name):is_dead();
    self.regions_count = get_faction(self.faction_name):region_list():num_items();
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
    save_table.image = self.image 
    save_table.tooltip = self.tooltip
    save_table.status = self.status 
    save_table.leader_subtype = self.leader_subtype
    save_table.leader_forename = self.leader_forename
    save_table.leader_surname = self.leader_surname
    save_table.capital = self.capital 
    save_table.capital_x = self.capital_x 
    save_table.capital_y = self.capital_y 
    save_table.expedition_x = self.expedition_x 
    save_table.expedition_y = self.expedition_y 
    save_table.expedition_region = self.expedition_region 
    save_table.turns_dead = self.turns_dead 
    save_table.revive_happened = self.revive_happened 
    save_table.base_regions = self.base_regions 
    return save_table
end


--v function(self: EOM_ELECTOR)
function eom_elector.refresh(self)
    self.dead = get_faction(self.faction_name):is_dead();
    self.regions_count = get_faction(self.faction_name):region_list():num_items();
    if self.dead == true then
        self.turns_dead = self.turns_dead + 1;
    elseif self.dead == false then
        self.turns_dead = 0;
    end
end


return {
    new = eom_elector.new
}