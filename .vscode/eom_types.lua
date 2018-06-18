
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




--# type global ELECTOR_STATUS = 
--# "normal" | "seceded" | "notyetexisting" | "loyal" | "civil_war_enemy" | "civil_war_emperor" |
--# "open_rebellion" | "fallen"

--# type global ELECTOR_NAME = 
--# "wh_main_emp_averland" | "wh_main_emp_hochland" | "wh_main_emp_ostermark" | "wh_main_emp_stirland" |
--# "wh_main_emp_middenland" | "wh_main_emp_nordland" | "wh_main_emp_talabecland" | "wh_main_emp_wissenland" |
--# "wh_main_emp_ostland" | "wh_main_emp_marienburg" | "wh_main_emp_sylvania" | "wh_main_vmp_schwartzhafen" | "wh_main_emp_cult_of_sigmar" | "wh_main_emp_cult_of_ulric"

--# type global EMPIRE_REGION =
--#	"wh_main_ostland_castle_von_rauken" | "wh_main_ostland_norden" |"wh_main_ostland_wolfenburg"|
--# "wh_main_reikland_altdorf" | "wh_main_reikland_eilhart" | "wh_main_reikland_grunburg" | "wh_main_reikland_helmgart" |
--# "wh_main_stirland_the_moot" | "wh_main_stirland_wurtbad" | "wh_main_talabecland_kemperbad" | "wh_main_wissenland_nuln" |
--# "wh_main_wissenland_pfeildorf" | "wh_main_wissenland_wissenburg" | 	"wh_main_hochland_brass_keep" | "wh_main_hochland_hergig" |
--# "wh_main_middenland_carroburg" | "wh_main_middenland_middenheim" | "wh_main_middenland_weismund" | "wh_main_nordland_dietershafen" |
--# "wh_main_nordland_salzenmund" |	"wh_main_talabecland_talabheim" | "wh_main_averland_averheim" | "wh_main_averland_grenzstadt" |
--# "wh_main_ostermark_bechafen" | "wh_main_ostermark_essen" | "wh_main_the_wasteland_gorssel" | "wh_main_the_wasteland_marienburg"


--# type global EOM_CORE_DATA = string | boolean | number


--# type global ELECTOR_INFO = {_key: ELECTOR_NAME,
--# _loyalty: number, _power: number, _state: ELECTOR_STATUS, _isCult: boolean,
--# _capital: string, _hideFromUi: boolean, _leaderSubtype: string,
--# _leaderForename: string, _leaderSurname: string, _expeditionX: number, _expeditionY: number, _expeditionRegion: string,
--# _baseRegions: number, _turnsDead: number, _image: string, _fullyLoyal: boolean, _uiName: string, _uiTooltip: string}

--# type global EOM_EVENT = {
--# key: string, conditional: function(eom: EOM_MODEL) --> boolean,  choices: map<number, function(eom: EOM_MODEL)>
--# }



--# type global EOM_MODEL_SAVETABLE = {
--# _electors: map<string, ELECTOR_INFO>,
--# _coredata: map<string, EOM_CORE_DATA>
--# }