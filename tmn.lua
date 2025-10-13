TMN = SMODS.current_mod

local Big = assert(SMODS.load_file("omeganum.lua"))()
TMN.get_big = function(msg)
    if msg == "i promise ill use it properly" then
        return Big
    end
end