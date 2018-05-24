

-- CLASS DECLARATION
--# assume global class CM
--# assume global class CUIM
--# assume global class CA_UIC
--# assume global class CA_Component
--# assume global class CA_UIContext
--# assume global class CA_CHAR_CONTEXT
--# assume global class CA_SETTLEMENT_CONTEXT
--# assume global class CA_CQI
--# assume global class CA_CHAR
--# assume global class CA_CHAR_LIST
--# assume global class CA_MILITARY_FORCE
--# assume global class CA_MILITARY_FORCE_LIST
--# assume global class CA_REGION
--# assume global class CA_REGION_LIST
--# assume global class CA_SETTLEMENT
--# assume global class CA_GARRISON_RESIDENCE
--# assume global class CA_SLOT_LIST
--# assume global class CA_SLOT
--# assume global class CA_BUILDING
--# assume global class CA_FACTION
--# assume global class CA_FACTION_LIST
--# assume global class CA_GAME
--# assume global class CA_MODEL
--# assume global class CA_WORLD
--# assume global class CA_EFFECT
--# assume global class CA_PENDING_BATTLE
--# assume global class CA_UNIT
--# assume global class CA_UNIT_LIST

--be warned, this type is not a precise type. 
--# assume global class CA_CONTEXT


--# assume global class CORE
--# assume global class _G


-- TYPES
--# type global CA_EventName = 
--# "CharacterCreated"      | "ComponentLClickUp"     | "ComponentMouseOn"    |
--# "PanelClosedCampaign"   | "PanelOpenedCampaign" |
--# "TimeTrigger"           | "UICreated"

--# type global BUTTON_STATE = 
--# "active" | "hover" | "down" | 
--# "selected" | "selected_hover" | "selected_down" |
--# "drop_down"


--# type global BATTLE_SIDE =
--# "Attacker" | "Defender" 



-- CONTEXT
--# assume CA_UIContext.component: CA_Component
--# assume CA_UIContext.string: string
--# assume CA_SETTLEMENT_CONTEXT.garrison_residence: method() --> CA_GARRISON_RESIDENCE
--# assume CA_CHAR_CONTEXT.character: method() --> CA_CHAR

-- UIC
--# assume CA_UIC.Address: method() --> CA_Component
--# assume CA_UIC.Adopt: method(pointer: CA_Component)
--# assume CA_UIC.ChildCount: method() --> number
--# assume CA_UIC.ClearSound: method()
--# assume CA_UIC.CreateComponent: method(name: string, path: string)
--# assume CA_UIC.CurrentState: method() --> BUTTON_STATE
--# assume CA_UIC.DestroyChildren: method()
--# assume CA_UIC.Dimensions: method() --> (number, number)
--# assume CA_UIC.Find: method(arg: number | string) --> CA_Component
--# assume CA_UIC.GetTooltipText: method() --> string
--# assume CA_UIC.Id: method() --> string
--# assume CA_UIC.MoveTo: method(x: number, y: number)
--# assume CA_UIC.Parent: method() --> CA_Component
--# assume CA_UIC.Position: method() --> (number, number)
--# assume CA_UIC.Resize: method(w: number, h: number)
--# assume CA_UIC.SetInteractive: method(interactive: boolean)
--# assume CA_UIC.SetOpacity: method(opacity: number)
--# assume CA_UIC.SetState: method(state: BUTTON_STATE)
--# assume CA_UIC.SetStateText: method(text: string)
--# assume CA_UIC.SetVisible: method(visible: boolean)
--# assume CA_UIC.SetDisabled: method(disabled: boolean)
--# assume CA_UIC.ShaderTechniqueSet: method(technique: string | number, unknown: boolean)
--# assume CA_UIC.ShaderVarsSet: method(p1: number, p2: number, p3: number, p4: number, unknown: boolean)
--# assume CA_UIC.SimulateClick: method()
--# assume CA_UIC.Visible: method() --> boolean

--# assume CA_UIC.SetImage: method(path: string)
--# assume CA_UIC.SetCanResizeHeight: method(state: boolean)
--# assume CA_UIC.SetCanResizeWidth: method(state: boolean)
--# assume CA_UIC.SetTooltipText: method(tooltip: string, state: boolean?)
--# assume CA_UIC.GetStateText: method() --> string
--# assume CA_UIC.PropagatePriority: method(priority: number)
--# assume CA_UIC.Priority: method() --> number
--# assume CA_UIC.Bounds: method() --> (number, number)
--# assume CA_UIC.Height: method() --> number
--# assume CA_UIC.Width: method() --> number
--# assume CA_UIC.SetImageRotation:  method(unknown: number, rotation: number)
--# assume CA_UIC.ResizeTextResizingComponentToInitialSize: method(width: number, height: number)
--# assume CA_UIC.SimulateLClick: method()
--# assume CA_UIC.SimulateKey: method(keyString: string)


-- CAMPAIGN MANAGER
--# assume CM.get_game_interface: method() --> CA_GAME
--# assume CM.model: method() --> CA_MODEL
--# assume CM.get_local_faction: method() --> string
--# assume CM.get_human_factions: method() --> vector<string>
--# assume CM.get_campaign_ui_manager: method() --> CUIM
--# assume CM.callback: method(
--#     callback: function(),
--#     delay: number,
--#     name: string
--# )
--# assume CM.repeat_callback: method(
--#     callback: function(),
--#     delay: number,
--#     name: string
--# )
--# assume CM.create_force_with_general: method(
--#     faction_key: string,
--#     army_list: string,
--#     region_key: string,
--#     xPos: number,
--#     yPos: number,
--#     agent_type: string,
--#     agent_subtype: string,
--#     forename: string,
--#     clan_name: string,
--#     family_name: string,
--#     other_name: string,
--#     id: string,
--#     make_faction_leader: boolean,
--#     success_callback: function(CA_CQI)
--# )
--# assume CM.force_add_trait: method(character_cqi: CA_CQI, trait_key: string, showMessage: boolean)
--# assume CM.force_add_trait_on_selected_character: method(trait_key: string)
--# assume CM.disable_event_feed_events: method(disable: boolean, categories: string, subcategories: string, events: string)
--# assume CM.trigger_incident: method(factionName: string, incidentKey: string, fireImmediately: boolean)
--# assume CM.apply_effect_bundle_to_characters_force: method(bundleKey: string, charCqi: CA_CQI, turns: number, useCommandQueue: boolean)
--# assume CM.zero_action_points: method(charName: string)
--# assume CM.add_agent_experience: method(charName: string, experience: number)
--# assume CM.spawn_character_to_pool: method(
--#    factionKey: string, forname: string, familyName: string, clanName: string, 
--#    otherName: string, age: int, male: boolean, agentKey: string, agent_subtypeKey: string, 
--#    isImmortal: boolean, artSetId: string
--#)
--# assume CM.set_saved_value: method(valueKey: string, value: any)
--# assume CM.get_saved_value: method(valueKey: string) --> WHATEVER
--# assume CM.save_named_value: method(name: string, value: any, context: WHATEVER?)
--# assume CM.load_named_value: method(name: string, default: any, context: WHATEVER?) --> WHATEVER
--# assume CM.teleport_to: method(charString: string, xPos: number, yPos: number, useCommandQueue: boolean)
--# assume CM.is_new_game: method() --> boolean
--# assume CM.apply_effect_bundle_to_region: method(bundle: string, region: string, turns: number)
--# assume CM.remove_effect_bundle_from_region: method(bundle: string, region: string)
--# assume CM.grant_unit_to_character: method(cqi: CA_CQI, unit: string)
--# assume CM.add_saving_game_callback: method(function(context: WHATEVER))
--# assume CM.add_loading_game_callback: method(function(context: WHATEVER))
--# assume CM.random_number: method(num: int) --> int
--# assume CM.apply_effect_bundle: method(bundle: string, faction: string, timer: int)
--# assume CM.remove_effect_bundle: method(bundle: string, faction: string)
--# assume CM.add_default_diplomacy_record: method(faction: string, other_faction: string, record: string, offer: boolean, accept: boolean, enable_payments: boolean)
--# assume CM.force_make_peace: method(faction: string, other_faction: string)
--# assume CM.force_declare_war: method(declarer: string, declaree: string, attacker_allies: boolean, defender_allies: boolean)
--# assume CM.pending_battle_cache_get_defender: method(pos: int) --> (CA_CQI, CA_CQI, string)
--# assume CM.pending_battle_cache_get_attacker: method(pos: int) --> (CA_CQI, CA_CQI, string)
--# assume CM.force_change_cai_faction_personality: method(key: string, personality: string)
--# assume CM.transfer_region_to_faction: method(region: string, faction:string)


-- CAMPAIGN UI MANAGER
--# assume CUIM.get_char_selected: method() --> string
--# assume CUIM.settlement_selected: string


-- GAME INTERFACE
--# assume CA_GAME.filesystem_lookup: method(filePath: string, matchRegex:string) --> string


-- CHARACTER
--# assume CA_CHAR.has_trait: method(traitName: string) --> boolean
--# assume CA_CHAR.logical_position_x: method() --> number
--# assume CA_CHAR.logical_position_y: method() --> number
--# assume CA_CHAR.character_subtype_key: method() --> string
--# assume CA_CHAR.region: method() --> CA_REGION
--# assume CA_CHAR.faction: method() --> CA_FACTION
--# assume CA_CHAR.military_force: method() --> CA_MILITARY_FORCE
--# assume CA_CHAR.won_battle: method() --> boolean


-- CHARACTER LIST
--# assume CA_CHAR_LIST.num_items: method() --> number
--# assume CA_CHAR_LIST.item_at: method(index: number) --> CA_CHAR


-- MILITARY FORCE
--# assume CA_MILITARY_FORCE.general_character: method() --> CA_CHAR
--# assume CA_MILITARY_FORCE.unit_list: method() --> CA_UNIT_LIST


-- MILITARY FORCE LIST
--# assume CA_MILITARY_FORCE_LIST.num_items: method() --> number
--# assume CA_MILITARY_FORCE_LIST.item_at: method(index: number) --> CA_MILITARY_FORCE

--UNIT
--# assume CA_UNIT.faction: method() --> CA_FACTION
--# assume CA_UNIT.unit_key: method() --> string
--# assume CA_UNIT.has_force_commander: method() --> boolean
--# assume CA_UNIT.force_commander: method() --> CA_CHAR


--UNIT_LIST

--#assume CA_UNIT_LIST.num_items: method() --> number


-- REGION
--# assume CA_REGION.settlement: method() --> CA_SETTLEMENT
--# assume CA_REGION.name: method() --> string
--# assume CA_REGION.is_null_interface: method() --> boolean
--# assume CA_REGION.is_abandoned: method() --> boolean
--# assume CA_REGION.owning_faction: method() --> CA_FACTION
--# assume CA_REGION.slot_list: method() --> CA_SLOT_LIST

-- SETTLEMENT
--# assume CA_SETTLEMENT.logical_position_x: method() --> number
--# assume CA_SETTLEMENT.logical_position_y: method() --> number
--# assume CA_SETTLEMENT.get_climate: method() --> string

--SLOT LIST
--# assume CA_SLOT_LIST.num_items: method() --> number
--# assume CA_SLOT_LIST.item_at: method(index: number) --> CA_SLOT

--SLOT
--# assume CA_SLOT.has_building: method() --> boolean
--# assume CA_SLOT.building: method() --> CA_BUILDING

--BUILDING
--# assume CA_BUILDING.name: method() --> string
--# assume CA_BUILDING.chain: method() --> string
--# assume CA_BUILDING.superchain: method() --> string
--# assume CA_BUILDING.faction: method() --> CA_FACTION
--# assume CA_BUILDING.region: method() --> CA_REGION

-- GARRISON RESIDENCE
--# assume CA_GARRISON_RESIDENCE.region: method() --> CA_REGION


-- MODEL
--# assume CA_MODEL.world: method() --> CA_WORLD
--# assume CA_MODEL.difficulty_level: method() --> number
--# assume CA_MODEL.turn_number: method() --> number
--# assume CA_MODEL.pending_battle: method() --> CA_PENDING_BATTLE


-- WORLD
--# assume CA_WORLD.faction_list: method() --> CA_FACTION_LIST
--# assume CA_WORLD.faction_by_key: method(factionKey: string) --> CA_FACTION
--# assume CA_WORLD.whose_turn_is_it: method() --> CA_FACTION

-- FACTION
--# assume CA_FACTION.character_list: method() --> CA_CHAR_LIST
--# assume CA_FACTION.treasury: method() --> number
--# assume CA_FACTION.name: method() --> string
--# assume CA_FACTION.subculture: method() --> string
--# assume CA_FACTION.culture: method() --> string
--# assume CA_FACTION.military_force_list: method() --> CA_MILITARY_FORCE_LIST
--# assume CA_FACTION.is_human: method() --> boolean
--# assume CA_FACTION.is_dead: method() --> boolean
--# assume CA_FACTION.is_vassal_of: method(faction: string) --> boolean
--# assume CA_FACTION.is_ally_vassal_or_client_state_of: method(faction: string) --> boolean
--# assume CA_FACTION.at_war_with: method(faction: string) --> boolean
--# assume CA_FACTION.region_list: method() --> CA_REGION_LIST
--# assume CA_FACTION.has_effect_bundle: method(bundle:string) --> boolean

-- FACTION LIST
--# assume CA_FACTION_LIST.num_items: method() --> number
--# assume CA_FACTION_LIST.item_at: method(index: number) --> CA_FACTION

--REGION LIST
--# assume CA_REGION_LIST.num_items: method() --> number
--# assume CA_REGION_LIST.item_at: method() --> CA_REGION

-- EFFECT
--# assume CA_EFFECT.get_localised_string: function(key: string) --> string


-- PENDING BATTLE
--# assume CA_PENDING_BATTLE.attacker: method() --> CA_CHAR
--# assume CA_PENDING_BATTLE.defender: method() --> CA_CHAR


-- CORE
--# assume CORE.get_ui_root: method() --> CA_UIC
--# assume CORE.add_listener: method(
--#     listenerName: string,
--#     eventName: string,
--#     conditionFunc: function(context: CA_CONTEXT) --> boolean,
--#     listenerFunc: function(context: CA_CONTEXT),
--#     persistent: boolean
--# )
--# assume CORE.remove_listener: method(listenerName: string)
--# assume CORE.add_ui_created_callback: method(function())
--# assume CORE.get_screen_resolution: method() --> (number, number)
--# assume CORE.trigger_event: method(event_name: string)

-- GLOBAL VARIABLES
--# assume global cm: CM
--# assume global core: CORE
--# assume global effect: CA_EFFECT
--# assume global __write_output_to_logfile: boolean


-- GLOBAL FUNCTIONS
-- COMMON
--# assume global find_uicomponent: function(parent: CA_UIC, string...) --> CA_UIC
--# assume global UIComponent: function(pointer: CA_Component) --> CA_UIC
--# assume global output: function(output: string | number)  
--# assume global print_all_uicomponent_children: function(component: CA_UIC)
--# assume global is_uicomponent: function(object: any) --> boolean
--# assume global output_uicomponent: function(uic: CA_UIC, omit_children: boolean)
--# assume global faction_is_horde: function(faction: CA_FACTION) --> boolean
--# assume global uicomponent_to_str: function(component: CA_UIC) --> string
--# assume global is_string: function(arg: string) --> boolean
--# assume global is_table: function(arg: table) --> boolean
--# assume global is_number: function(arg: number) --> boolean
--# assume global is_function: function(arg: function) --> boolean
--# assume global get_timestamp: function() --> string
--# assume global script_error: function(msg: string)
--# assume global to_number: function(n: any) --> number

-- CAMPAIGN
--# assume global remove_all_units_from_character: function(char: CA_CHAR)
--# assume global get_character_by_cqi: function(cqi: CA_CQI) --> CA_CHAR
--# assume global get_region: function(regionName: string) --> CA_REGION
--# assume global get_faction: function(factionName: string) --> CA_FACTION
--# assume global char_lookup_str: function(char: CA_CQI | CA_CHAR | number) --> string
--# assume global kill_all_armies_for_faction: function(factionName: string)
--# assume global get_cm: function() --> CM
--# assume global Get_Character_Side_In_Last_Battle: function(char: CA_CHAR) --> BATTLE_SIDE

--Context
--# assume CA_CONTEXT.choice: method() --> int
--# assume CA_CONTEXT.dilemma: method() --> string
--# assume CA_CONTEXT.faction: method() --> CA_FACTION
--# assume CA_CONTEXT.character: method() --> CA_CHAR
--# assume CA_CONTEXT.region: method() --> CA_REGION
--# assume CA_CONTEXT.garrison_residence: method() --> CA_GARRISON_RESIDENCE
