local eom = {} --# assume eom: EOM_MODEL
local eom_util = require("eom/eom_table_management")


--v function(gametable: WHATEVER) --> EOM_MODEL
function eom.initialise(gametable)
    local self = {} 
    setmetatable({
        __index = eom
    })--# assume self: EOM_MODEL

    self.electors = gametable.electors --:vector<EOM_ELECTOR>
    self.cults = gametable.cults --:vector<EOM_CULT>
    self.emperor = gametable.emperor --:vector<EOM_EMPEROR>
    self.civil_wars = gametable.civil_wars --:vector<EOM_CIVIL_WAR>




    return self;

end;
----------------------------------------
---BASIC RETVAL FUNCTIONS FOR ELECTORS--
----------------------------------------

--what is the current loyalty?
--v function(self: EOM_MODEL, elector: string) --> integer
function eom.get_elector_loyalty(self, elector)
    local electors = self.electors;
    local index = eom_util.find_elector_by_key(electors, elector)
    return index.loyalty
end

--what is the base power?
--v function(self: EOM_MODEL, elector: string) --> integer
function eom.get_elector_base_power(self, elector)
    local electors = self.electors;
    local index = eom_util.find_elector_by_key(electors, elector)
    return index.base_power
end

--what is the total power?
--v function(self: EOM_MODEL, elector: string) --> integer
function eom.get_elector_power(self, elector)
    local electors = self.electors;
    local index = eom_util.find_elector_by_key(electors, elector)
    return index.power
end

--what is the l_mood?
--v function(self: EOM_MODEL, elector: string) --> integer
function eom.get_elector_l_mood(self, elector)
    local electors = self.electors;
    local index = eom_util.find_elector_by_key(electors, elector)
    return index.l_mood
end

--what is the p_mood?
--v function(self: EOM_MODEL, elector: string) --> integer
function eom.get_elector_p_mood(self, elector)
    local electors = self.electors;
    local index = eom_util.find_elector_by_key(electors, elector)
    return index.p_mood
end

--how war wary is the elector?
--v function(self: EOM_MODEL, elector: string) --> integer
function eom.get_elector_war_wariness(self, elector)
    local electors = self.electors;
    local index = eom_util.find_elector_by_key(electors, elector)
    return index.war_wariness
end

--is the elector visable on the UI?
--v function(self: EOM_MODEL, elector: string) --> boolean
function eom.get_elector_ui(self, elector)
    local electors = self.electors;
    local index = eom_util.find_elector_by_key(electors, elector)
    return index.ui
end

--is the elector seceded?
--v function(self: EOM_MODEL, elector: string) --> boolean
function eom.get_elector_left_the_empire(self, elector)
    local electors = self.electors;
    local index = eom_util.find_elector_by_key(electors, elector)
    return index.left_the_empire
end

--is the elector in open rebellion?
--v function(self: EOM_MODEL, elector: string) --> boolean
function eom.get_elector_open_rebellion(self, elector)
    local electors = self.electors;
    local index = eom_util.find_elector_by_key(electors, elector)
    return index.open_rebellion
end

--is the elector dead?
--v function(self: EOM_MODEL, elector: string) --> boolean
function eom.get_elector_alive(self, elector)
    local electors = self.electors;
    local index = eom_util.find_elector_by_key(electors, elector)
    return index.alive
end

--what is the cult lookup of the elector
--v function(self: EOM_MODEL, elector: string) --> string
function eom.get_elector_cult_lookup(self, elector)
    local electors = self.electors;
    local index = eom_util.find_elector_by_key(electors, elector)
    return index.cult_lookup
end

--what is the civil war lookup of the elector
--v function(self: EOM_MODEL, elector: string) --> string
function eom.get_elector_civil_war_lookup(self, elector)
    local electors = self.electors;
    local index = eom_util.find_elector_by_key(electors, elector)
    return index.civil_war_lookup
end





----------------------------------------
---BASIC RETVAL FUNCTIONS FOR CULTS--
----------------------------------------

--what is the current loyalty?
--v function(self: EOM_MODEL, cult: string) --> integer
function eom.get_cult_loyalty(self, cult)
    local cults = self.cults;
    local index = eom_util.find_cult_by_key(cults, cult)
    return index.loyalty
end

--what is the base power?
--v function(self: EOM_MODEL, cult: string) --> integer
function eom.get_cult_base_power(self, cult)
    local cults = self.cults;
    local index = eom_util.find_cult_by_key(cults, cult)
    return index.base_power
end

--what is the total power?
--v function(self: EOM_MODEL, cult: string) --> integer
function eom.get_cult_power(self, cult)
    local cults = self.cults;
    local index = eom_util.find_cult_by_key(cults, cult)
    return index.power
end

--what is the l_mood?
--v function(self: EOM_MODEL, cult: string) --> integer
function eom.get_cult_l_mood(self, cult)
    local cults = self.cults;
    local index = eom_util.find_cult_by_key(cults, cult)
    return index.l_mood
end

--what is the p_mood?
--v function(self: EOM_MODEL, cult: string) --> integer
function eom.get_cult_p_mood(self, cult)
    local cults = self.cults;
    local index = eom_util.find_cult_by_key(cults, cult)
    return index.p_mood
end


--is the cult in open rebellion?
--v function(self: EOM_MODEL, cult: string) --> boolean
function eom.get_cult_open_rebellion(self, cult)
    local cults = self.cults;
    local index = eom_util.find_cult_by_key(cults, cult)
    return index.open_rebellion
end

--is the cult dead?
--v function(self: EOM_MODEL, cult: string) --> boolean
function eom.get_cult_active(self, cult)
    local cults = self.cults;
    local index = eom_util.find_cult_by_key(cults, cult)
    return index.active
end

--what is the civil war lookup of the cult
--v function(self: EOM_MODEL, cult: string) --> string
function eom.get_cult_civil_war_lookup(self, cult)
    local cults = self.cults;
    local index = eom_util.find_cult_by_key(cults, cult)
    return index.civil_war_lookup
end


------------------------------------------
--BASIC RETVAL FUNCTIONS FOR THE EMPEROR--
------------------------------------------

--what is the current legitimacy?
--v function(self: EOM_MODEL, emperor: string) --> integer
function eom.get_emperor_legitimacy(self, emperor)
    local emperors = self.emperor;
    local index = eom_util.find_emperor_by_key(emperors, emperor)
    return index.legitimacy
end

--what is the current base_power?
--v function(self: EOM_MODEL, emperor: string) --> integer
function eom.get_emperor_base_power(self, emperor)
    local emperors = self.emperor;
    local index = eom_util.find_emperor_by_key(emperors, emperor)
    return index.base_power
end
    
--what is the current power?
--v function(self: EOM_MODEL, emperor: string) --> integer
function eom.get_emperor_power(self, emperor)
    local emperors = self.emperor;
    local index = eom_util.find_emperor_by_key(emperors, emperor)
    return index.power
end

------------------------------
--CIVIL_WAR SYSTEM FUNCTIONS--
------------------------------

--v function(self: EOM_MODEL) --> boolean
function eom.has_civil_war_started(self)
    for i = 1, #self.civil_wars do
    local civil_war = self.civil_wars[i]
        if civil_war.started == true then
            return civil_war.started
        end
    end
    return false;
end

--v function(self: EOM_MODEL) --> boolean
function eom.return_any_possible_civil_wars(self)
    for i = 1, #self.civil_wars do
        local civil_war = self.civil_wars[i]
        if civil_war.condition(self) == true then
            return civil_war.condition(self)
        end
    end
    return false;
end

--v function(self: EOM_MODEL) --> integer
function eom.return_a_valid_civil_war(self)
    table_valid_wars = {} --:vector<int>
    for i = 1, #self.civil_wars do
        local civil_war = self.civil_wars[i]
        if civil_war.condition(self) == true then
            table.insert(table_valid_wars, i)
        end
    end
    local index = cm:random_number(#table_valid_wars)
    return table_valid_wars[index]
end;

--v function(self: EOM_MODEL, index: int)
function eom.start_civil_war(self, index)
    local civil_war_to_start = self.civil_wars[index]
    civil_war_to_start.started = true;
    civil_war_to_start.callback()
end


----------------usable functions----------------------
------------------------------------------------------
return {
    initialise = eom.initialise
}