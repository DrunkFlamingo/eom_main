
--# assume global class EOM_PANEL



--# assume global class EOM_MODEL



--container classes

--# assume global class EOM_ELECTOR
--# assume global class EOM_CULT
--# assume global class EOM_CIVIL_WAR
--# assume global class EOM_EMPEROR

--# assume global class EOM_ACTION
--# assume global class EOM_REFORM
--# assume global class EOM_TRAIT
--# assume global class EOM_RECONQUEST
--# assume global class EOM_CRUSADE
--# assume global class EOM_CIVIL_CONFLICTS


--EOM ELECTOR
--# assume EOM_ELECTOR.key: string
--# assume EOM_ELECTOR.loyalty: integer
--# assume EOM_ELECTOR.base_power: integer
--# assume EOM_ELECTOR.power: integer
--# assume EOM_ELECTOR.l_mood: integer
--# assume EOM_ELECTOR.p_mood: integer
--# assume EOM_ELECTOR.ui: boolean
--# assume EOM_ELECTOR.fully_loyal: boolean
--# assume EOM_ELECTOR.left_the_empire: boolean
--# assume EOM_ELECTOR.open_rebellion: boolean
--# assume EOM_ELECTOR.civil_war_lookup: string
--# assume EOM_ELECTOR.actions: vector<EOM_ACTION>
--# assume EOM_ELECTOR.traits: vector<EOM_TRAIT>
--# assume EOM_ELECTOR.cult_lookup: string
--# assume EOM_ELECTOR.war_wariness: integer
--# assume EOM_ELECTOR.alive: boolean
--# assume EOM_ELECTOR.reconquest: vector<EOM_RECONQUEST>

--EOM CULT
--# assume EOM_CULT.key: string
--# assume EOM_CULT.loyalty: integer
--# assume EOM_CULT.base_power: integer
--# assume EOM_CULT.power: integer
--# assume EOM_CULT.l_mood: integer
--# assume EOM_CULT.p_mood: integer
--# assume EOM_CULT.civil_war_lookup: string
--# assume EOM_CULT.actions: vector<EOM_ACTION>
--# assume EOM_CULT.traits: vector<EOM_TRAIT>
--# assume EOM_CULT.active: boolean
--# assume EOM_CULT.crusade: vector<EOM_CRUSADE>
--# assume EOM_CULT.open_rebellion: boolean

--EOM EMPEROR
--# assume EOM_EMPEROR.key: string
--# assume EOM_EMPEROR.legitimacy: integer
--# assume EOM_EMPEROR.base_power: integer
--# assume EOM_EMPEROR.power: integer
--# assume EOM_EMPEROR.reform: vector<EOM_REFORM>

--EOM CIVIL_WAR
--# assume EOM_CIVIL_WAR.started: boolean
--# assume EOM_CIVIL_WAR.condition: function(EOM_MODEL) --> boolean
--# assume EOM_CIVIL_WAR.callback: function()
--# assume EOM_CIVIL_WAR.ending: function(EOM_MODEL) --> boolean
--# assume EOM_CIVIL_WAR.key: string
