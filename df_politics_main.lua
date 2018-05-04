local Elector = require("eom/elector")
local Cult = require("eom/cult")
local Emperor = require("eom/emperor")
local EomAction = require("eom/political_action")
local EomTrait = require("eom/political_trait")
local EomPanel = require("eom/panel")
local eom = require("eom/eom")

_G.Elector = Elector;
_G.Cult = Cult;
_G.Emperor = Emperor;
_G.EomAction = EomAction;
_G.EomTrait = EomTrait;
_G.eom = eom;

core:add_ui_created_callback(
    function()
    end
)


