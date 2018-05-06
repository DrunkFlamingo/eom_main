local eom_util = {} 


--v function(list: vector<WHATEVER>, toRemove: WHATEVER)
function eom_util.remove_from_vector(list, toRemove)
    for i, value in ipairs(list) do
        if value == toRemove then
            table.remove(list, i);
            return;
        end
    end
end

--v function(list: vector<WHATEVER>, toCount: WHATEVER) --> integer
function eom_util.count_in_vector(list, toCount)
	listCount = 0 --:int
	for i, value in ipairs(list) do
		if value == toCount then
			listCount = listCount + 1;
		end
	end
return listCount;
end;


--v function(list: vector<WHATEVER>, toFind: WHATEVER) --> integer
function eom_util.find_in_vector(list, toFind)
    for i, value in ipairs(list) do
        if value == toFind then
            return i;
        end
    end
    return nil;
end;

--v function(list: vector<EOM_ELECTOR>, key: WHATEVER) --> EOM_ELECTOR
function eom_util.find_elector_by_key(list, key)
    for i, value in ipairs(list) do
        if value.key == key then
            return list[i];
        end
    end
    return nil;
end

--v function(list: vector<EOM_CULT>, key: WHATEVER) --> EOM_CULT
function eom_util.find_cult_by_key(list, key)
    for i, value in ipairs(list) do
        if value.key == key then
            return list[i];
        end
    end
    return nil;
end

--v function(list: vector<EOM_EMPEROR>, key: WHATEVER) --> EOM_EMPEROR
function eom_util.find_emperor_by_key(list, key)
    for i, value in ipairs(list) do
        if value.key == key then
            return list[i];
        end
    end
    return nil;
end


----------------usable functions----------------------
------------------------------------------------------

return {
    remove_from_vector = eom_util.remove_from_vector,
    count_in_vector = eom_util.count_in_vector,
    find_in_vector = eom_util.find_in_vector,
    find_elector_by_key = eom_util.find_elector_by_key,
    find_cult_by_key = eom_util.find_cult_by_key,
    find_emperor_by_key = eom_util.find_emperor_by_key
}