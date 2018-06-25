
core:add_listener(
	"EOMLorefulEmpiresAdditions",
	"LorefulEmpiresActivated",
	true,
	function(context)
		if not not _G.lem then
			lem = _G.lem
			local additions_list = 
			{
				"wh_main_emp_averland",
				"wh_main_emp_hochland",
				"wh_main_emp_ostermark",
				"wh_main_emp_stirland",
				"wh_main_emp_middenland",
				"wh_main_emp_nordland",
				"wh_main_emp_ostland",
				"wh_main_emp_wissenland",
				"wh_main_emp_talabecland",
				"wh_main_emp_cult_of_ulric",
				"wh_main_emp_cult_of_sigmar",
				"wh_main_emp_marienburg",
				"wh_main_emp_sylvania",
				"wh_main_vmp_schwartzhafen"
			}
			if cm:get_faction("wh_main_emp_empire"):is_human() then
				for i = 1, # additions_list do
					lem:add_faction_to_secondary(additions_list[i])
				end
			end
		end
	end,
	false)