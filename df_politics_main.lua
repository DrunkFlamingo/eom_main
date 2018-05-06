

local eom = require("eom/eom")


_G.eom = eom;


function eom_table_setup()

if cm:is_new_game() then
    eom_master = {
        electors = {
            {
                key = "",
                loyalty = 0,
                base_power = 0,
                power = 0,
                l_mood = 0,
                p_mood = 0,
                ui = true,
                fully_loyal = false,
                left_the_empire = false,
                open_rebellion = false,
                civil_war_lookup = "undecided",
                actions = {},
                traits = {},
                cult_lookup = "",
                war_wariness = 0,
                alive = true,
                reconquest = {}
            }
        },
        cults = {
            {
                key = "",
                loyalty = 0,
                power = 0,
                base_power = 0,
                l_mood = 0,
                p_mood = 3,
                civil_war_lookup = "",
                actions = {},
                traits = {},
                active = false,
                open_rebellion = false,
                crusade = {}
            }
        },
        emperor = {
            {
                key = "",
                legitimacy = 35,
                base_power = 35,
                power = 35,
                reform = {}
            }
        },
        civil_wars = {
            {
                started = false,
                possibilities = {},
                lookup = "undecided",
                active_war = {}
            }
        }
    }

elseif not cm:is_new_game() then
    eom.initialise(eom_master)
end



end




cm:add_saving_game_callback(
    function(context)
    output("EOM: SAVING THE GAME")
    cm:save_named_value("eom_master", eom_master, context)
    end
)

cm:add_loading_game_callback(
    function(context)
    output("EOM: LOADING THE GAME")
    eom_master = cm:load_named_value("eom_master", eom_master, context)
    end
)




core:add_ui_created_callback(
    function()
        eom_table_setup();
    end
)


