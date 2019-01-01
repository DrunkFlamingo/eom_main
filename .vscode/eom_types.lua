
--# assume global class EOM_VIEW
--# assume global class EOM_CONTROLLER

--# assume global class EOM_MODEL
--# assume global class EOM_KNIGHTS
--# assume global class EOM_ELECTOR
--# assume global class EOM_CULT
--# assume global class EOM_ACTION
--# assume global class EOM_PLOT
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
--# _baseRegions: number, _turnsDead: number, _image: string, _fullyLoyal: boolean, _uiName: string, _uiTooltip: string,
--# _knights: boolean, _unitList: string, _canRevive: boolean, _homeRegions:vector<string>, _willCapitulate: boolean?}

--# type global EOM_EVENT = {
--# key: string, conditional: function(eom: EOM_MODEL) --> boolean,  choices: map<number, function(eom: EOM_MODEL)>
--# }



--# type global EOM_MODEL_SAVETABLE = {
--# _electors: map<ELECTOR_NAME, ELECTOR_INFO>,
--# _coredata: map<string, EOM_CORE_DATA>
--# }




--# assume global class MCM
--# assume global class MCM_MOD
--# assume global class MCM_VAR
--# assume global class MCM_TWEAKER
--# assume global class MCM_OPTION

--MOD CONFIGURATION MANAGER
--# assume MCM.register_mod: method(key: string, ui_name: string, ui_tooltip: string) --> MCM_MOD
--# assume MCM.get_mod: method(key: string) --> MCM_MOD
--# assume MCM.started_with_mod: method(key: string) --> boolean
--# assume MCM.add_pre_process_callback: method(callback: function())
    --// happens before any MCM value callbacks. Happens regardless of whether the game is new or loaded. 
--# assume MCM.add_post_process_callback: method(callback: function())
    --// happens after any MCM value callbacks. Happens regardless of whether the game is new or loaded. 
    --// This is the recommended method for using your settings.
--# assume MCM.add_new_game_only_callback: method(callback: function())
    --// happens after any MCM value callbacks only in new saves.
    --// this is the recommended method for using settings only applicable to game start. 

--MOD OBJECT
--# assume MCM_MOD.name: method() --> string
--# assume MCM_MOD.add_tweaker: method(key: string, ui_name: string, tooltip: string) --> MCM_TWEAKER
    --// All tweakers set a save value "mcm_tweaker_<mod_key>_<tweaker_key>_value" 
    --// This value equals the option key of the selected option
    --// Tweakers additionally trigger an event called "mcm_tweaker_<mod_key>_<tweaker_key>_event".
    --// The value is easily accessible within this event through context.string
--# assume MCM_MOD.add_variable: method(key: string,
--# minimum: number, maximum: number, default: number, step_value: number,
--# ui_name: string, ui_tooltip: string) --> MCM_VAR
    --// All variables set a save value "mcm_variable_<mod_key>_<variable_key>_value" 
    --// This value equals the option key of the selected option
    --// variables additionally trigger an event called "mcm_variable_<mod_key>_<variable_key>_event".
    --// The value is easily accessible within this event through tonumber(context.string)

--TWEAKER OBJECT
--# assume MCM_TWEAKER.name: method() -->string
--# assume MCM_TWEAKER.selected_option: method() --> MCM_OPTION
--# assume MCM_TWEAKER.get_option_with_key: method(key: string) --> MCM_OPTION
--# assume MCM_TWEAKER.add_option: method(key: string, ui_name: string, ui_tooltip: string) --> MCM_OPTION
    --// the first option added to any tweaker is the default value.

--OPTION OBJECT
--# assume MCM_OPTION.name: method() -->string
--# assume MCM_OPTION.has_callback: method() --> boolean
--# assume MCM_OPTION.add_callback: method(callback: function(context: MCM)) 
    --// The added callback will happen both in new and saved games.
    --// The callback will occur when the MCM panel closes.
    --// These callbacks are best used to load values into another defined data structure or object; 
    --// general purpose uses are better off using the methods of MCM for callbacks.

--VAR OBJECT
--# assume MCM_VAR.name: method() --> string
--# assume MCM_VAR.current_value: method() --> number
--# assume MCM_VAR.has_callback: method() --> boolean
--# assume MCM_VAR.add_callback: method(callback: function(context: MCM)) 
    --// The added callback will happen both in new and saved games.
    --// The callback will occur when the MCM panel closes.
    --// These callbacks are best used to load values into another defined data structure or object; 
    --// general purpose uses are better off using the methods of MCM for callbacks.

--GLOBAL ACCESS
--# assume mcm:MCM
_G.mcm = mcm