local Util = {}

Util.clamp = function(value, min, max)
    return math.min(max, math.max(value, min))
end

Util.choose = function(cond, a, b)
    if cond then
        return a
    else
        return b
    end
end

Util.copy = function(orig)
    local orig_type = type(orig)
    local copy

    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end

    return copy
end

Util.deepcopy = function(orig)
    local orig_type = type(orig)
    local copy

    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Util.deepcopy(orig_key)] = Util.deepcopy(orig_value)
        end
        setmetatable(copy, Util.deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end

    return copy
end

local EPSILON = 0.000001

Util.floatsEqual = function(a, b)
    return math.abs(a - b) < EPSILON
end

Util.hasSubtable = function(tbl, expectedAttrs)
    for k, v in pairs(expectedAttrs) do
        if tbl[k] ~= v then
            return false
        end
    end

    return true
end

Util.keys = function(t)
    local keys = {}
    local n = 1
    for k,v in pairs(t) do
        keys[n] = k
        n = n + 1
    end

    return keys
end

Util.mousePos = function()
    local x, y = lm:getPosition()
    x = x / _scale
    y = y / _scale

    return x, y
end

Util.roll = function(chance, a, b)
    if (rng() * 100) < chance then
        return a
    else
        return b
    end
end

-- Use Example:
--     Util.rngSelect({
--         {o = 120, v = 'Sixty Percent Chance'},
--         {o = 10, v = 'Five Percent Chance'},
--         {o = 70, v = 'Thirty-Five Percent Chance'},
--     })
Util.rngSelect = function(tbl)
    local total_odds = 0
    for _,t in ipairs(tbl) do
        total_odds = total_odds + t.o
    end

    local roll = rng() * total_odds
    for _, t in ipairs(tbl) do
        if roll <= t.o then
            return t.v
        else
            roll = roll - t.o
        end
    end
end

Util.sample = function(t)
    return t[rng(#t)]
end

Util.sampleValidate = function(t, validateFunc)
    local inf = InfProt()
    while true do
        inf:inc()
        local val = t[rng(#t)]

        if validateFunc(val) then
            return val
        end
    end
end

Util.sameSign = function(a, b)
    return (a >= 0 and b >= 0) or (a <= 0 and b <= 0)
end

Util.tableConcat = function(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

Util.vectorBetween = function(x1, y1, x2, y2, speed)
    local relx, rely = x2 - x1, y2 - y1
    local dx, dy = Vector.normalize(relx, rely)

    return dx * speed, dy * speed
end

return Util
