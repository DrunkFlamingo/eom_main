cm = get_cm(); events = get_events(); eom = _G.eom;
--SCRIPT by Zarkis aka Yarkis de Bodemlooze




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
				} --:vector<string>

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
			} --:vector<string>

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





--setup for player and AI

local function zarkis_compat_setup()
	cm:set_saved_value("last_empire_state", 0);
	cm:set_saved_value("last_stand", 0);

end


events.FirstTickAfterWorldCreated[#events.FirstTickAfterWorldCreated+1] = function() zarkis_compat_setup() end;


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





--v function (context: WHATEVER)
local function Empire_FactionTurn(context)
	
	local turn_number = cm:model():turn_number();

	if turn_number == 2 then
		cm:trigger_incident(EMPIRE_KEY, "wh_twh_incident_state_of_the_empire", true);
	end;

	if turn_number == 1 then 
		cm:apply_effect_bundle("wh_twh_emp_integrity_good", EMPIRE_KEY, 0);
	end

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



		if empire_state < cm:get_saved_value("last_empire_state") then
			----empire of man addition
			local state_to_loyalty = {
				[5] = 10,
				[4] = 10,
				[3] = 10,
				[2] = 5,
				[1] = -5,
				[0] = -5
			}--:map<number, number>
			local new_state_loyalty = state_to_loyalty[empire_state]
			eom:change_all_loyalties(new_state_loyalty)
			--
			
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
			--empire of man addition
			local state_to_loyalty = {
				[6] = -10,
				[5] = -10,
				[4] = -10,
				[3] = -5,
				[2] = 5,
				[1] = 5,
			}--:map<number, number>
			local new_state_loyalty = state_to_loyalty[empire_state]
			eom:change_all_loyalties(new_state_loyalty)
			--

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

			if 10 <= cm:random_number(100) and empire_state > 2 then
				cm:trigger_incident(EMPIRE_KEY, "wh_twh_emp_incident_refugees", false);
			end;

		end;

		cm:set_saved_value("last_empire_state", empire_state);

	end;

end
if eom then
core:add_listener(
	"TWH_Empire_FactionTurnStart",
	"FactionTurnStart",
	function(context) return context:faction():name() == EMPIRE_KEY end,
	function(context) Empire_FactionTurn(context) end,
	true
);

else
	out("Eom not active")
end