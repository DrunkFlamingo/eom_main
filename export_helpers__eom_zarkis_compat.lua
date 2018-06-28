cm = get_cm(); events = get_events(); eom = _G.eom;
--SCRIPT by Zarkis aka Yarkis de Bodemlooze
if eom then 
	if eom:empire() == "wh_main_emp_empire" then


EMPIRE_KEY = "wh_main_emp_empire"
EMPIRE_REGION_COUNT = 25

EMPIRE_REGIONS = {
				"wh_main_averland_averheim",
				"wh_main_averland_grenzstadt",
				"wh_main_hochland_brass_keep",
				"wh_main_hochland_hergig",
				"wh_main_middenland_carroburg",
				"wh_main_middenland_middenheim",
				"wh_main_middenland_weismund",
				"wh_main_nordland_dietershafen",
				"wh_main_nordland_salzenmund",
				"wh_main_ostermark_bechafen",
				"wh_main_ostermark_essen",
				"wh_main_ostland_castle_von_rauken",
				"wh_main_ostland_norden",
				"wh_main_ostland_wolfenburg",
				"wh_main_reikland_altdorf",
				"wh_main_reikland_eilhart",
				"wh_main_reikland_grunburg",
				"wh_main_reikland_helmgart",
				"wh_main_stirland_the_moot",
				"wh_main_stirland_wurtbad",
				"wh_main_talabecland_kemperbad",
				"wh_main_talabecland_talabheim",
				"wh_main_wissenland_nuln",
				"wh_main_wissenland_pfeildorf",
				"wh_main_wissenland_wissenburg"
				};

EMPIRE_FACTIONS = {
				"wh_main_emp_empire",
				"wh_main_emp_averland",
				"wh_main_emp_hochland",
				"wh_main_emp_ostermark",
				"wh_main_emp_stirland",
				"wh_main_emp_middenland",
				"wh_main_emp_nordland",
				"wh_main_emp_ostland",
				"wh_main_emp_wissenland",
				"wh_main_emp_talabecland",
				"wh_main_emp_empire_separatists"
			};

PREVENT_WAR_LIST = {
				"faction:wh_main_emp_averland",
				"faction:wh_main_emp_hochland",
				"faction:wh_main_emp_ostermark",
				"faction:wh_main_emp_stirland",
				"faction:wh_main_emp_middenland",
				"faction:wh_main_emp_nordland",
				"faction:wh_main_emp_ostland",
				"faction:wh_main_emp_wissenland",
				"faction:wh_main_emp_talabecland",
				"faction:wh_main_emp_empire"
			};

PREVENT_WAR_LIST_AI = {
				"faction:wh_main_emp_averland",
				"faction:wh_main_emp_hochland",
				"faction:wh_main_emp_ostermark",
				"faction:wh_main_emp_stirland",
				"faction:wh_main_emp_middenland",
				"faction:wh_main_emp_nordland",
				"faction:wh_main_emp_ostland",
				"faction:wh_main_emp_wissenland",
				"faction:wh_main_emp_talabecland",
				"faction:wh_main_emp_empire",
				"faction:wh_main_ksl_kislev"
			};

EMPIRE_ENEMIES_LIST = {};
EOTE_ENABLED = false;
RULE_DILEMMA_TIMER = 5;
PAX_IMPERIA_DILEMMA_TIMER = 2;
KISLEV_DILEMMA_TIMER = 3;
MARIENBURG_DILEMMA_TIMER = 6;

cm:add_game_created_callback(
	function()

	local emp = cm:get_faction(EMPIRE_KEY);

		if cm:model():campaign_name("main_warhammer") then

			if emp:is_human() then
				twh_empire_listeners()
			else
				twh_emp_nothuman_listeners()
			end;

			if cm:is_new_game() then
				twh_empire_setup();
			end;

		end
	end
);


function zar_twh_the_empire()
	cm:set_saved_value("zar_twh_the_empire", true);
end


--setup for player and AI
function twh_empire_setup()

	cm:set_saved_value("last_empire_state", 0);
	cm:set_saved_value("last_stand", 0);
--[[
--We dont want too much infighting or wars with Kislev
	cm:force_declare_war("wh_main_ksl_kislev", "wh_main_nor_varg", true, true);


	--if not cm:get_saved_value("df_politics_main") then
		cm:force_declare_war("wh_main_emp_nordland", "wh_main_nor_skaeling", true, true);
		cm:force_declare_war("wh_main_emp_hochland", "wh_dlc03_bst_redhorn", true, true);
		cm:force_declare_war("wh_main_emp_ostermark", "wh_dlc03_bst_redhorn", true, true);
		cm:force_declare_war("wh_main_emp_ostland", "wh_dlc03_bst_redhorn", true, true);
	--end
]]
end


function twh_empire_listeners()

	core:add_listener(
		"TWH_Empire_FactionTurnStart",
		"FactionTurnStart",
		function(context) return context:faction():name() == EMPIRE_KEY end,
		function(context) Empire_FactionTurn(context) end,
		true
	);

end


function twh_emp_nothuman_listeners()

	core:add_listener(
		"Emp_NotHuman_FactionTurnStart",
		"FactionTurnStart",
		function(context)
		local human_factions = cm:get_human_factions();
		return context:faction():name() == human_factions[1];  --should run only once per turn?
		end,
		function(context) Emp_NotHuman_FactionTurn(context) end,
		true
	);


-- Enemy of the Empire mechanic
	if EOTE_ENABLED and not cm:is_multiplayer() then

		core:add_listener(
			"Emp_StartCharacterSackedSettlement",
			"CharacterSackedSettlement",
			true,
			function(context) EmpEnemySearch_Sack(context) end,
			true
		);
		core:add_listener(
			"Emp_StartCharacterRazedSettlement",
			"CharacterRazedSettlement",
			true,
			function(context) EmpEnemySearch_Raze(context) end,
			true
		);
		core:add_listener(
			"Emp_StartCharacterOccupiesSettlement",
			"GarrisonOccupiedEvent",
			true,
			function(context) EmpEnemySearch_Conquer(context) end,
			true
		);

	end;

end


function Empire_FactionTurn(context)
	
	local turn_number = cm:model():turn_number();

	if turn_number == 2 then
		cm:trigger_incident(EMPIRE_KEY, "wh_twh_incident_state_of_the_empire", true);
	end;


	if turn_number > 1 then

		local region_count = 0;

		for i = 1, #EMPIRE_REGIONS do
				local region = cm:model():world():region_manager():region_by_key(EMPIRE_REGIONS[i]);
			for j = 1, #EMPIRE_FACTIONS do
				if region:owning_faction():name() == EMPIRE_FACTIONS[j] then
					region_count = region_count + 1;
				end;
			end;
		end;

		local region_diff = EMPIRE_REGION_COUNT - region_count

		cm:apply_effect_bundle("wh_twh_emp_integrity_good", EMPIRE_KEY, 0);
		cm:apply_effect_bundle("wh_twh_emp_integrity_bad_1", EMPIRE_KEY, 0);
		cm:apply_effect_bundle("wh_twh_emp_integrity_bad_2", EMPIRE_KEY, 0);
		cm:apply_effect_bundle("wh_twh_emp_integrity_bad_3", EMPIRE_KEY, 0);
		cm:apply_effect_bundle("wh_twh_emp_integrity_bad_4", EMPIRE_KEY, 0);
		cm:apply_effect_bundle("wh_twh_emp_integrity_bad_5", EMPIRE_KEY, 0);
		cm:apply_effect_bundle("wh_twh_emp_integrity_bad_6", EMPIRE_KEY, 0);

		cm:remove_effect_bundle("wh_twh_emp_integrity_good", EMPIRE_KEY);
		cm:remove_effect_bundle("wh_twh_emp_integrity_bad_1", EMPIRE_KEY);
		cm:remove_effect_bundle("wh_twh_emp_integrity_bad_2", EMPIRE_KEY);
		cm:remove_effect_bundle("wh_twh_emp_integrity_bad_3", EMPIRE_KEY);
		cm:remove_effect_bundle("wh_twh_emp_integrity_bad_4", EMPIRE_KEY);
		cm:remove_effect_bundle("wh_twh_emp_integrity_bad_5", EMPIRE_KEY);
		cm:remove_effect_bundle("wh_twh_emp_integrity_bad_6", EMPIRE_KEY);

		--empire of man addition
		local state_to_loyalty = {
			[6] = -20,
			[5] = -10,
			[4] = 0,
			[3] = 10,
			[2] = 15,
			[1] = 10,
			[0] = 0
		}
		local last_state = cm:get_saved_value("last_empire_state")
		local last_state_loyalty_value = state_to_loyalty[last_state]
		eom:change_all_loyalties(-(last_state_loyalty_value))







		local empire_state = 0;

		if region_diff >= 12 then
	-- The Empire is falling apart with nearly half of it's former territories occupied or destroyed. People flee their homes, but where can they go? There seems to be no hope and the trust in the Emperor is lost.
			cm:apply_effect_bundle("wh_twh_emp_integrity_bad_6", EMPIRE_KEY, 0);
			empire_state = 6;
		elseif region_diff >= 10 then
	-- The bad news do not end. More regions are lost or devastated. The trust in the Emperor is vanishing. Some even say the end times are near. Will the Empire survive?
			cm:apply_effect_bundle("wh_twh_emp_integrity_bad_5", EMPIRE_KEY, 0);
			empire_state = 5;
		elseif region_diff >= 8 then
	-- More then a quarter of the Empire is devastated or occupied. The streets are full with refugees. People flock to the temples to pray. May the gods help us!
			cm:apply_effect_bundle("wh_twh_emp_integrity_bad_4", EMPIRE_KEY, 0);
			empire_state = 4;
		elseif region_diff >= 6 then
	-- The Empire is under serious threat. More regions are lost or devastated, which hurts our economy. We need to rally our strength and stand together against our common enemies.
			cm:apply_effect_bundle("wh_twh_emp_integrity_bad_3", EMPIRE_KEY, 0);
			empire_state = 3;
		elseif region_diff >= 4 then
	-- The loss of of more territories troubles the citizens of the Empire everywhere and starts to have a demoralizing effect on our troops. The Elector Counts look at you for guidance in this hard times. We need to take back what is rightfully ours!
			cm:apply_effect_bundle("wh_twh_emp_integrity_bad_2", EMPIRE_KEY, 0);
			empire_state = 2;
		elseif region_diff >= 2 then
	-- The Empire lost some of its territory. People are worried about the future.
			cm:apply_effect_bundle("wh_twh_emp_integrity_bad_1", EMPIRE_KEY, 0);
			empire_state = 1;
		else
	-- The Empire is a in a stable condition. Most of the populace is happy with the Emperors rule.
			cm:apply_effect_bundle("wh_twh_emp_integrity_good", EMPIRE_KEY, 0);
			empire_state = 0;
		end;

		--eom additions
		eom:change_all_loyalties(state_to_loyalty[empire_state])


		if empire_state < cm:get_saved_value("last_empire_state") then
			
			cm:show_message_event_located(
				EMPIRE_KEY,
				"event_feed_strings_text_wh_event_feed_string_faction_state_improved_primary_detail",
				"",
				"event_feed_strings_text_wh_event_feed_string_faction_state_improved_secondary_detail",
				500,
				450,
				true,
				110
			);

		elseif empire_state > cm:get_saved_value("last_empire_state") then
			
			cm:show_message_event_located(
				EMPIRE_KEY,
				"event_feed_strings_text_wh_event_feed_string_faction_state_deteriorated_primary_detail",
				"",
				"event_feed_strings_text_wh_event_feed_string_faction_state_deteriorated_secondary_detail",
				500,
				450,
				true,
				111
			);

			if 10 <= cm:random_number(100, 1) and empire_state > 2 then
				cm:trigger_incident(EMPIRE_KEY, "wh_twh_emp_incident_refugees", false);
			end;

		end;

		cm:set_saved_value("last_empire_state", empire_state);

	end;

end


function Emp_NotHuman_FactionTurn(context)

	local faction = context:faction();
	local faction_name = faction:name();
	local turn_number = cm:model():turn_number();

-- EMPIRE AI LAST STAND TRIGGER
	if turn_number > 1 and cm:get_saved_value("last_stand") == 0 then

			local region_count = 0;
			for i = 1, #EMPIRE_REGIONS do
					local region = cm:model():world():region_manager():region_by_key(EMPIRE_REGIONS[i]);
				for j = 1, #EMPIRE_FACTIONS do
					if region:owning_faction():name() == EMPIRE_FACTIONS[j] then
						region_count = region_count + 1;
					end;
				end;
			end;

			local region_diff = EMPIRE_REGION_COUNT - region_count
			if 	region_diff >= 16 then
				EmpireLastStand(faction_name);
			end;

	end;

-- Enemy of the Empire check
	if EOTE_ENABLED and not cm:is_multiplayer() then
		DeclareEnemyOfTheEmpire(faction_name)
	end;

end
--[[

events.DilemmaChoiceMadeEvent[#events.DilemmaChoiceMadeEvent+1] =
function(context)

	local dilemma = context:dilemma();
	local choice = context:choice();
	local turn_number = cm:model():turn_number();

--- PAX IMPERIA DILEMMA
	if dilemma == "wh_twh_emp_pax_imperia" then
		PAX_IMPERIA_DILEMMA_TIMER = turn_number + 40;
		if choice == 0 then
			for i = 1, #PREVENT_WAR_LIST do
				for j = 1, #PREVENT_WAR_LIST do
					cm:force_diplomacy(PREVENT_WAR_LIST[i], PREVENT_WAR_LIST[j], "war", false, false, false);
				end
			end
		elseif choice == 1 then
			for i = 1, #PREVENT_WAR_LIST do
				for j = 1, #PREVENT_WAR_LIST do
					cm:force_diplomacy(PREVENT_WAR_LIST[i], PREVENT_WAR_LIST[j], "war", true, true, false);
				end
			end
		end
	end

--- MARIENBURG DILEMMA
	if dilemma == "wh_twh_emp_marienburg" then
		MARIENBURG_DILEMMA_TIMER = turn_number + 40;
		if choice == 0 then
			cm:force_diplomacy("faction:wh_main_emp_empire", "faction:wh_main_emp_marienburg", "war", false, false, false);
			cm:trigger_incident(EMPIRE_KEY, "wh_twh_incident_nordland_angry", true);
		elseif choice == 1 then
			cm:trigger_incident(EMPIRE_KEY, "wh_twh_incident_nordland_pleased", true);
			cm:force_diplomacy("faction:wh_main_emp_empire", "faction:wh_main_emp_marienburg", "war", true, true, false);
		end
	end

--- KISLEV DILEMMA
	if dilemma == "wh_twh_emp_kislev" then
		KISLEV_DILEMMA_TIMER = turn_number + 40;
		if choice == 0 then
			for i = 1, #PREVENT_WAR_LIST do
				cm:force_diplomacy("faction:wh_main_ksl_kislev", PREVENT_WAR_LIST[i], "war", false, false, false);
				cm:force_diplomacy(PREVENT_WAR_LIST[i], "faction:wh_main_ksl_kislev", "war", false, false, false);
			end;
			cm:treasury_mod("wh_main_ksl_kislev", 2000)
		elseif choice == 1 then
			for i = 1, #PREVENT_WAR_LIST do
				cm:force_diplomacy("faction:wh_main_ksl_kislev", PREVENT_WAR_LIST[i], "war", true, true, false);
				cm:force_diplomacy(PREVENT_WAR_LIST[i], "faction:wh_main_ksl_kislev", "war", true, true, false);
			end;
		end;
	end;

-- RULE DILEMMA
	if dilemma == "wh_twh_emp_rule_dilemma" then
		RULE_DILEMMA_TIMER = turn_number + 30;
	end

-- EMPIRE AI DIPLOMACY CONFIGURATION DILEMMA
	if dilemma == "wh_twh_emp_pax_imperia_AI" then
		if choice == 0 then
			EOTE_ENABLED = true;  --Enemy of the Empire mechanic
			for i = 1, #PREVENT_WAR_LIST_AI do
				for j = 1, #PREVENT_WAR_LIST_AI do
					cm:force_diplomacy(PREVENT_WAR_LIST_AI[i], PREVENT_WAR_LIST_AI[j], "war", false, false, false);
				end;
			end;
		end;
	end;

end
]]

function EmpireLastStand(faction_name)

	local laststand_units = "wh_main_emp_cav_demigryph_knights_1,wh_main_emp_art_great_cannon,wh_main_emp_inf_greatswords,wh_main_emp_inf_greatswords,wh_main_emp_inf_halberdiers,wh_main_emp_inf_halberdiers,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_dlc04_emp_inf_flagellants_0,wh_dlc04_emp_inf_flagellants_0,wh_dlc04_emp_inf_flagellants_0,wh_dlc04_emp_inf_flagellants_0,wh_main_emp_cav_empire_knights,wh_main_emp_cav_empire_knights,wh_main_emp_cav_outriders_0,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_crossbowmen,wh_main_emp_inf_handgunners";

	local x = 486;
	local y = 438;
	local region_name = "wh_main_reikland_altdorf";

	-- check if there is a character at that point, if so, return
	local faction_list = cm:model():world():faction_list();
	
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		local char_list = current_faction:character_list();
		
		for j = 0, char_list:num_items() - 1 do
			local current_char = char_list:item_at(j);
			if current_char:logical_position_x() == x and current_char:logical_position_y() == y then
				return;
			end;
		end;
	end;

	cm:create_force(
			EMPIRE_KEY,
			laststand_units,
			region_name,
			x,
			y,
			true,
			true,
			function(cqi)
				cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, -1, true);
				cm:add_agent_experience(cm:char_lookup_str(cqi), 22580); --skill lvl 15
			end
		);

	cm:set_saved_value("last_stand", 1) 

	cm:show_message_event_located(
		faction_name,
		"event_feed_strings_text_wh_event_feed_string_empire_last_stand_primary_detail",
		"",
		"event_feed_strings_text_wh_event_feed_string_empire_last_stand_secondary_detail",
		486,
		438,
		true,
		112
	);

end

--  Enemy of the Empire mechanic

function EmpEnemySearch_Conquer(context)

	local enemy_faction_name = context:character():faction():name();
	local enemy_faction_sc = context:character():faction():subculture();
	local region_name = context:character():region():name();
	local defender_cqi, defender_force_cqi, defender_name = cm:pending_battle_cache_get_defender(1);
	local defender_faction_key = cm:model():world():faction_by_key(defender_name);
	local defender_faction_name = defender_faction_key:name();
	local defender_sc = defender_faction_key:subculture();
	local is_empire_region = false;

	for i = 1, #EMPIRE_REGIONS do
		if EMPIRE_REGIONS[i] == region_name then
			is_empire_region = true;
		end;
	end;

	if is_empire_region and defender_sc == "wh_main_sc_emp_empire" and defender_faction_name ~= "wh_main_emp_marienburg" and defender_faction_name ~= "wh_main_emp_empire_rebels" and enemy_faction_sc ~= "wh_main_sc_emp_empire" then
		AddEmpEnemy(enemy_faction_name);
	end;

end


function EmpEnemySearch_Sack(context)

	local enemy_faction_name = context:character():faction():name();
	local enemy_faction_sc = context:character():faction():subculture();
	local region_name = context:character():region():name();
	local defender_cqi, defender_force_cqi, defender_name = cm:pending_battle_cache_get_defender(1);
	local defender_faction_key = cm:model():world():faction_by_key(defender_name);
	local defender_faction_name = defender_faction_key:name();
	local defender_sc = defender_faction_key:subculture();
	local is_empire_region = false;

	for i = 1, #EMPIRE_REGIONS do
		if EMPIRE_REGIONS[i] == region_name then
			is_empire_region = true;
		end;
	end;

	if is_empire_region and defender_sc == "wh_main_sc_emp_empire" and defender_faction_name ~= "wh_main_emp_marienburg" and defender_faction_name ~= "wh_main_emp_empire_rebels" and enemy_faction_sc ~= "wh_main_sc_emp_empire" then
		AddEmpEnemy(enemy_faction_name);
	end;

end


function EmpEnemySearch_Raze(context)

	local enemy_faction_name = context:character():faction():name();
	local enemy_faction_sc = context:character():faction():subculture();
	local region_name = context:character():region():name();
	local defender_cqi, defender_force_cqi, defender_name = cm:pending_battle_cache_get_defender(1);
	local defender_faction_key = cm:model():world():faction_by_key(defender_name);
	local defender_faction_name = defender_faction_key:name();
	local defender_sc = defender_faction_key:subculture();
	local is_empire_region = false;

	for i = 1, #EMPIRE_REGIONS do
		if EMPIRE_REGIONS[i] == region_name then
			is_empire_region = true;
		end;
	end;

	if is_empire_region and defender_sc == "wh_main_sc_emp_empire" and defender_faction_name ~= "wh_main_emp_marienburg" and defender_faction_name ~= "wh_main_emp_empire_rebels" and enemy_faction_sc ~= "wh_main_sc_emp_empire" then
		AddEmpEnemy(enemy_faction_name);
	end;

end


function AddEmpEnemy(enemy_faction_name)

	local has_record = false

	for i = 1, #EMPIRE_ENEMIES_LIST do
		if EMPIRE_ENEMIES_LIST[i] ~= nil then
			if EMPIRE_ENEMIES_LIST[i][1] == enemy_faction_name then
				has_record = true;
				if EMPIRE_ENEMIES_LIST[i][2] ~= -1 then
					EMPIRE_ENEMIES_LIST[i][2] = EMPIRE_ENEMIES_LIST[i][2] + 1;
				end;
				break
			end;
		end;
	end;

	if has_record == false then
		table.insert(EMPIRE_ENEMIES_LIST, {enemy_faction_name, 1});
	end;

end

function DeclareEnemyOfTheEmpire(faction_name)

	local war_declared = false;

	for i = 1, #EMPIRE_ENEMIES_LIST do
		if EMPIRE_ENEMIES_LIST[i] ~= nil then
			if EMPIRE_ENEMIES_LIST[i][2] > 2 then
				for j = 1, #EMPIRE_FACTIONS do
					local emp_faction = cm:model():world():faction_by_key(EMPIRE_FACTIONS[j]);
					if emp_faction:is_null_interface() == false and faction_is_alive(emp_faction) then
						cm:force_declare_war(EMPIRE_FACTIONS[j], EMPIRE_ENEMIES_LIST[i][1], true, true);
						war_declared = true;
						EMPIRE_ENEMIES_LIST[i][2] = -1; --prevents further war declarations against same faction
						cm:apply_effect_bundle("wh_twh_empire_taxes_very_high", EMPIRE_FACTIONS[j], 20); --war tax
					end;
				end;
				break --only one declaration per turn
			end;
		end;
	end;

	if war_declared then
		cm:show_message_event_located(
				faction_name,
				"event_feed_strings_text_wh_event_feed_string_empire_enemy_primary_detail",
				"",
				"event_feed_strings_text_wh_event_feed_string_empire_enemy_secondary_detail",
				486,
				438,
				true,
				113
		);
	end;

end

--[[

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("EMPIRE_ENEMIES_LIST", EMPIRE_ENEMIES_LIST, context);
		cm:save_named_value("EOTE_ENABLED", EOTE_ENABLED, context);
		cm:save_named_value("RULE_DILEMMA_TIMER", RULE_DILEMMA_TIMER, context);
		cm:save_named_value("PAX_IMPERIA_DILEMMA_TIMER", PAX_IMPERIA_DILEMMA_TIMER, context);
		cm:save_named_value("KISLEV_DILEMMA_TIMER", KISLEV_DILEMMA_TIMER, context);
		cm:save_named_value("MARIENBURG_DILEMMA_TIMER", MARIENBURG_DILEMMA_TIMER, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		EMPIRE_ENEMIES_LIST = cm:load_named_value("EMPIRE_ENEMIES_LIST", {}, context);
		EOTE_ENABLED = cm:load_named_value("EOTE_ENABLED", false, context);
		RULE_DILEMMA_TIMER = cm:load_named_value("RULE_DILEMMA_TIMER", 5, context);
		PAX_IMPERIA_DILEMMA_TIMER = cm:load_named_value("PAX_IMPERIA_DILEMMA_TIMER", 2, context);
		KISLEV_DILEMMA_TIMER = cm:load_named_value("KISLEV_DILEMMA_TIMER", 3, context);
		MARIENBURG_DILEMMA_TIMER = cm:load_named_value("MARIENBURG_DILEMMA_TIMER", 6, context);
	end
);
]]

end


end