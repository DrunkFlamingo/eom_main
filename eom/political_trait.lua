local EomTrait = {} --#assume EomTrait: EOM_TRAIT




--Creates a trait.
--v function(name: string, ui: boolean, text: string, tooltip: string, event:string, condition: function(context: WHATEVER) --> boolean, callback: function(context: WHATEVER), imagepath: string) --> EOM_TRAIT
function EomTrait.new(name, ui, text, tooltip, event, condition, callback, imagepath)
    local self = {}
    setmetatable(self,{
        __index = EomTrait
    });
    --# assume self: EOM_TRAIT
    self.ui = ui;
    self.name = name;
    self.text = text;
    self.tooltip = tooltip;
    self.event = event;
    self.condition = condition;
    self.callback = callback;
    self.imagepath = imagepath;

    return self
end;

--v function(self: EOM_TRAIT)
function EomTrait.activate(self)
    core:add_listener(
        self.name,
        self.event,
        self.condition,
        self.callback,
        true);

end;

--v function(self: EOM_TRAIT) --> boolean
function EomTrait.visible(self)
    return self.ui
end;



return {
    new = EomTrait.new;
}

