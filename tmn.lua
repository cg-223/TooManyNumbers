TMN = SMODS.current_mod

Omega = assert(SMODS.load_file("omeganum.lua"))()

local function descendants(tbl, ret)
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