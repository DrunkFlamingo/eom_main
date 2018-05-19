
--# assume global class EOM_VIEW
--# assume global class EOM_CONTROLLER

--# assume global class EOM_MODEL

--# assume global class EOM_ELECTOR
--# assume global class EOM_CULT
--# assume global class EOM_ACTION
--# assume global class EOM_CIVIL_WAR
--# assume global class EOM_TRAIT


--the entity class is used to reflect functions which can take either an elector count or a religion cult. This reduces work.
--Any methods valid for both classes should be reflected below.


--# assume global class EOM_ENTITY 

--# assume EOM_ENTITY.change_loyalty: method(i: number)
--# assume EOM_ENTITY.get_faction_name: method() --> string

--# type global ELECTOR_STATES = 
--# "normal" | "seceded" | "notyetexisting" | "loyal" | "civil_war_enemy" | "civil_war_emperor" |
--# "open_rebellion" | "fallen"