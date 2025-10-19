TMN = SMODS.current_mod

Omega = assert(SMODS.load_file("omeganum.lua"))()
Formatter = assert(SMODS.load_file("format.lua"))()
function descendants(tbl, ret)
    ret = ret or {}
    for i, v in pairs(tbl) do
        if type(v) == "table" then
            descendants(tbl, ret)
        else
            table.insert(ret, v)
        end
    end

    return ret
end

function to_big(...)
    return Omega:create(...)
end

local oldupd = love.update
function love.update(dt)
    if type(mult) == "number" and type(hand_chips) == "number" then
        mult = Omega:new(mult)
        hand_chips = Omega:new(hand_chips)
    end

    if type(G.GAME.dollars) == "number" then
        G.GAME.dollars = Omega:new(G.GAME.dollars)
    end

    oldupd(dt)
end

SMODS.Atlas({
    key = "modicon",
    path = "icon.png",
    px = 34,
    py = 34
}):inject()


local tmn_atlas = G.ASSET_ATLAS.tmn_modicon
local tables_to_hook = { tmn_atlas.image_data, tmn_atlas.image, G.SAVE_MANAGER.channel }

for i, love_obj in pairs(tables_to_hook) do
    local obj_mt = getmetatable(love_obj)
    if obj_mt then
        local index = rawget(obj_mt, "__index")
        if index then
            for key, val in pairs(index) do
                if type(val) == "function" then
                    index[key] = function(...)
                        local args = { ... }
                        local i = 1
                        while i <= #args do
                            local v = args[i]
                            if type(v) == "cdata" then
                                args[i] = v:to_number_lease()
                            end
                            i = i + 1
                        end
                        return val(unpack(args))
                    end
                end
            end
            goto continue
        end
    end
    ::continue::
end

local function deep_replace(tbl, seen)
    local new = {}
    seen = seen or {}
    for i, v in pairs(tbl) do
        if type(v) == "cdata" then
            new[i] = v:to_number_lease()
        elseif type(v) == "table" then
            if seen[v] then
                tbl[i] = seen[v]
            end
            new[i] = deep_replace(v)
            seen[v] = new[i]
        end
    end
    return new
end

local nf = number_format
function number_format(num, e_switch_point)
    if type(num) == 'cdata' then
        if num.str then return num.str end
        if num:arraySize() > 2 then
            local str = Formatter:format(num, 3)
            num.str = str
            return str
        end
        G.E_SWITCH_POINT = G.E_SWITCH_POINT or 100000000000
        if (num or 0) < (to_big(G.E_SWITCH_POINT) or 0) then
            return nf(num:to_number(), e_switch_point)
        else
            return Formatter:format(num, 3)
        end
    else
        return nf(num, e_switch_point)
    end
end

local old = getmetatable(G.SAVE_MANAGER.channel).push
getmetatable(G.SAVE_MANAGER.channel).push = function(self, val)
    if type(val) == "table" then
        -- sorry guys cloning > sharing
        val = deep_replace(val)
    end
    return old(self, val)
end

local old = tonumber
function tonumber(num, base)
    if getmetatable(num) == OmegaMeta then
        return num:to_number()
    end
    return old(num, base)
end

for i, v in pairs(math) do
    if type(v) == "function" then
        math[i] = function(...)
            local args = { ... }
            local i = 1
            local len = #args
            while i <= len do
                local v = args[i]
                if type(v) == "cdata" then
                    args[i] = v:to_number_lease()
                end
                i = i + 1
            end
            return v(unpack(args))
        end
    end
end

local old = G.FUNCS.evaluate_play
function G.FUNCS.evaluate_play(...)
    G.TMN_SCORING = true
    local ret = old(...)
    G.TMN_SCORING = false
    return ret
end

local old = mod_mult
function mod_mult(mul)
    return to_big(old(mul))
end

local old = mod_chips
function mod_chips(chips)
    return to_big(old(chips))
end

SMODS.Joker {
    key = "urmom",
    loc_txt = {
        name = "numberslop",
        text = { "^2 mult" }
    },
    calculate = function(self, card, context)
        if context.joker_main then
            print(type(mult), type(mult ^ 2))
            mult = mod_mult(mult ^ 2)
            return {
                message = "^2 Mult!",
                colour = G.C.RED
            }
        end
    end
}
