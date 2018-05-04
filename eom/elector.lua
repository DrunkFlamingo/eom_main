local Cult = require("eom/cult")
local Emperor = require("eom/emperor")
local EomAction = require("eom/political_action")
local EomTrait = require("eom/political_trait")
local Elector = {} --#assume Elector: EOM_ELECTOR

--v function(info: map<string, WHATEVER>)--> EOM_ELECTOR
function Elector.new(info)
    local self = {}
    setmetatable(self, {
        __index = Elector
    })

    --# assume self: EOM_ELECTOR
    self.name = info.name --:string
    self.faction_key = info.faction_key --: string 
    self.capital_key = info.capital_key --: string
    self.loyalty = info.loyalty --: number
    self.power = info.power --: number
    self.base_power = info.base_power --:number
    self.mood_loyalty = info.mood_loyalty --: number
    self.mood_power = info.mood_power --: number
    self.action_index = info.action_index --:vector<EOM_ACTION>
    self.trait_index = info.trait_index --:vector<EOM_TRAIT>
    self.religion_lookup = info.religion_lookup --: string
    self.fully_loyal = info.fully_loyal --:boolean
    self.war_wariness = info.war_wariness --:number
    self.civil_war = info.civil_war --:string
    self.ui = info.ui --:boolean
    self.is_player_faction = get_faction(self.faction_key):is_human()

    return self;
end

--v function(self: EOM_ELECTOR) --> map<string, WHATEVER>
function Elector.save(self)
    local st = {}

    st.name = self.name --:string
    st.faction_key = self.faction_key --: string 
    st.capital_key = self.capital_key --: string
    st.loyalty = self.loyalty --: number
    st.power = self.power --: number
    st.mood_loyalty = self.mood_loyalty --: number
    st.mood_power = self.mood_power --: number
    st.action_index = self.action_index --:vector<EOM_ACTION>
    st.trait_index = self.trait_index --:vector<EOM_TRAIT>
    st.religion_lookup = self.religion_lookup --: string
    st.fully_loyal = self.fully_loyal --:boolean
    st.war_wariness = self.war_wariness --:number
    st.civil_war = self.civil_war --:string
    st.ui = self.ui --:boolean

    return st;

end

-------------------------
--DATA RETREVAL METHODS--
-------------------------

--returns the capital of an elector count
--v function(self: EOM_ELECTOR) --> string
function Elector.capital(self)
    return self.capital_key;
end;

--v function(self: EOM_ELECTOR) --> CA_FACTION
function Elector.faction(self)
    return get_faction(self.faction_key);
end;

--v function(self: EOM_ELECTOR) --> boolean
function Elector.is_human(self)
    return self.is_player_faction;
end

--v function(self:EOM_ELECTOR) --> boolean
function Elector.is_fully_loyal(self)
    return self.fully_loyal;
end;

--v function(self: EOM_ELECTOR) --> number
function Elector.get_loyalty(self)
    return self.loyalty;
end;

--v function(self: EOM_ELECTOR) --> number
function Elector.get_power(self)
    return self.power;
end;

--v function(self: EOM_ELECTOR) --> number
function Elector.get_l_mood(self)
    return self.mood_loyalty;
end;

--v function(self:EOM_ELECTOR) --> number
function Elector.get_p_mood(self)
    return self.mood_power;
end;

--v function(self: EOM_ELECTOR) --> number
function Elector.get_war_wariness(self)
    return self.war_wariness
end

--v function(self: EOM_ELECTOR) --> string
function Elector.religion(self)
    return self.religion_lookup
end



-------------------------------------
------------Power Managers-----------
-------------------------------------

--
--v function(self: EOM_ELECTOR, quantity:number)
function Elector.increase_p_mood(self, quantity)
    local old_mood = self.mood_power;
    
    change = 3 --:number
    if quantity < 15 then
        change = 2;
    elseif quantity < 10 then
        change = 1;
    end
    local new_mood = old_mood + change;
    if new_mood > 5 then new_mood = 5; Log.write("PowerMood would have exceeded cap, setting it to maximum"); end
    self.mood_power = new_mood;
end;

--v function(self: EOM_ELECTOR, quantity:number)
function Elector.decrease_p_mood(self, quantity)
    local old_mood = self.mood_power;
    change = 3 
    if quantity < 15 then
        change = 2;
    elseif quantity < 10 then
        change = 1;
    end
    local new_mood = old_mood - change;
    if new_mood < 1 then new_mood = 1; Log.write("PowerMood would have went under floor, setting it to Minimum"); end
    self.mood_power = new_mood;
end;

--v function(self: EOM_ELECTOR, quantity: number)
function Elector.increase_base_power(self, quantity)
    local old_power = self.base_power
    local new_power = old_power + quantity;
    if new_power > 100 then new_power = 100; Log.write("Power would have exceeded cap, setting it to maximum"); end
    self.base_power = new_power;
    Elector.increase_p_mood(self, quantity);
end;

--v function(self: EOM_ELECTOR, quantity: number)
function Elector.decrease_base_power(self, quantity)
    local old_power = self.base_power
    local new_power = old_power - quantity;
    if new_power < 0 then new_power = 0; Log.write("Power would have dropped below floor, setting it to minimum"); end
    self.base_power = new_power;
    Elector.decrease_p_mood(self, quantity);
end;

-------------------------------------
----------Loyalty Managers-----------
-------------------------------------

--takes a change in loyalty and increments the mood.
--v function(self: EOM_ELECTOR, quantity:number)
function Elector.increase_l_mood(self, quantity)
    local old_mood = self.mood_loyalty;
    Log.write("LoyaltyMoodUp() called for ["..self.name.."] and a loyalty change of ["..tostring(quantity).."]")
    
    change = 3 
    if quantity < 15 then
        change = 2;
    elseif quantity < 10 then
        change = 1;
    end
    local new_mood = old_mood + change;
    if new_mood > 5 then new_mood = 5; Log.write("LoyaltyMood would have exceeded cap, setting it to maximum"); end
    self.mood_loyalty = new_mood;
end;

--takes a change in loyalty and decremenents the mood.
--v function(self: EOM_ELECTOR, quantity:number)
function Elector.decrease_l_mood(self, quantity)
    local old_mood = self.mood_loyalty;
    change = 3 
    if quantity < 15 then
        change = 2;
    elseif quantity < 10 then
        change = 1;
    end
    local new_mood = old_mood - change;
    if new_mood < 1 then new_mood = 1; Log.write("LoyaltyMood would have went under floor, setting it to minimum"); end
    self.mood_loyalty = new_mood;
end;

--increases loyalty.
--v function(self: EOM_ELECTOR, quantity: number)
function Elector.increase_loyalty(self, quantity)
    local old_loyalty = self.loyalty
    local new_loyalty = old_loyalty + quantity;
    if new_loyalty > 100 then new_loyalty = 100; Log.write("Loyalty would have exceeded cap, setting it to maximum"); end
    self.loyalty = new_loyalty;
    Elector.increase_l_mood(self, quantity);
end;

--decreases loyalty.
--v function(self: EOM_ELECTOR, quantity: number)
function Elector.decrease_loyalty(self, quantity)
    local old_loyalty = self.loyalty
    local new_loyalty = old_loyalty - quantity;
    if new_loyalty < 0 then new_loyalty = 0; Log.write("Loyalty would have dropped below floor, setting it to minimum"); end
    self.loyalty = new_loyalty;
    Log.write("DecreaseLoyalty() called and lower loyalty by ["..tostring(quantity).."] to ["..tostring(self.loyalty).."]")
    Elector.decrease_l_mood(self, quantity);
    
end;









return {
    new = Elector.new
}