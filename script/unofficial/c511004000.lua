-- Anime Style Duel
-- Scripted by Daniel
local s, id = GetID()
s.hasUsedOptionOne = {}  -- Initialize the table right after defining the `s` variable
if s then
    function s.initial_effect(c)
        aux.EnableExtraRules(c, s, s.init)
    end
    function s.init(c)
        -- summon face-up defense
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_LIGHT_OF_INTERVENTION)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET + EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetTargetRange(1, 1)
        Duel.RegisterEffect(e1, 0)
        -- ZEXAL NUMBER rule
        local e2 = Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetRange(LOCATION_REMOVED)
        e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e2:SetTargetRange(LOCATION_ONFIELD, LOCATION_ONFIELD)
        e2:SetTarget(s.Target)
        e2:SetValue(s.indval)
        Duel.RegisterEffect(e2, 0)
        -- Destiny Draw
        local e3 = Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        e3:SetCode(EVENT_PREDRAW)
        e3:SetCountLimit(1)
        e3:SetCondition(s.ddcon)
        e3:SetOperation(s.ddop)
        Duel.RegisterEffect(e3, 0)
        -- Shooting Star Dragon custom response
        local e4 = Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        e4:SetCode(EVENT_CHAINING) -- This triggers when a chain starts
        e4:SetCondition(s.sscon)
        e4:SetOperation(s.ssop)
        Duel.RegisterEffect(e4, 0)
        -- After Pendulum Summon effect
        local e5 = Effect.CreateEffect(c)
        e5:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        e5:SetCode(EVENT_SPSUMMON_SUCCESS)
        e5:SetCondition(s.pscon)
        e5:SetOperation(s.psop)
        Duel.RegisterEffect(e5, 0)
    end
    function s.pendfilter(c, tp)
        return c:GetSummonType() == SUMMON_TYPE_PENDULUM and c:IsControler(Duel.GetTurnPlayer())
    end
    local pendulumFlag = false  -- A new flag to handle recursive pendulum summons
    function s.pscon(e, tp, eg, ep, ev, re, r, rp)
        return eg:IsExists(s.pendfilter, 1, nil, Duel.GetTurnPlayer()) and not pendulumFlag
    end
    function s.psop(e, tp, eg, ep, ev, re, r, rp)
        if not Duel.SelectYesNo(Duel.GetTurnPlayer(), aux.Stringid(id, 6)) then return end
        local ct = Duel.GetLocationCount(Duel.GetTurnPlayer(), LOCATION_MZONE)
        if ct <= 0 then return end
        local g = Duel.SelectMatchingCard(Duel.GetTurnPlayer(), Card.IsFaceup, Duel.GetTurnPlayer(), LOCATION_EXTRA, 0, 1, ct, nil)
        if #g > 0 then
            Duel.SendtoGrave(g, REASON_EFFECT)
            local sg = Duel.GetOperatedGroup()
            if sg:GetCount() > 0 then
                pendulumFlag = true  -- Setting the flag to true to prevent recursion
                Duel.BreakEffect()
                Duel.SpecialSummon(sg, SUMMON_TYPE_PENDULUM, Duel.GetTurnPlayer(), Duel.GetTurnPlayer(), false, false, POS_FACEUP)
                pendulumFlag = false  -- Resetting the flag for future uses
            end
        end
    end
    function s.sscon(e, tp, eg, ep, ev, re, r, rp)
        return re:GetHandler():IsCode(24696097) and re:GetHandlerPlayer() == Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(Duel.GetTurnPlayer(), 0, LOCATION_MZONE) > 0 and Duel.GetTurnPlayer() == Duel.GetTurnPlayer()
    end
    function s.ssop(e, tp, eg, ep, ev, re, r, rp)
        local count = Duel.GetFieldGroupCount(Duel.GetTurnPlayer(), 0, LOCATION_MZONE) -- Number of opponent's monsters
        Duel.Hint(HINT_SELECTMSG, Duel.GetTurnPlayer(), HINTMSG_TODECK)
        local g = Duel.SelectMatchingCard(Duel.GetTurnPlayer(), Card.IsType, Duel.GetTurnPlayer(), LOCATION_DECK, 0, count, count, nil, TYPE_TUNER)
        if #g > 0 then
            Duel.ShuffleDeck(Duel.GetTurnPlayer()) -- Place the selected cards on top of the deck
            Duel.MoveToDeckTop(g) -- If you want to order them
        end
    end
    function s.indval(e, c)
        return not c:IsSetCard(0x48) and not c:IsAttribute(ATTRIBUTE_DIVINE)
    end
    function s.Target(e, c)
        return c:IsSetCard(0x48) and not c:IsDisabled(c)
    end
    function s.check_utopia_conditions(tp)
        local zones = LOCATION_EXTRA + LOCATION_MZONE + LOCATION_GRAVE + LOCATION_REMOVED + LOCATION_DECK
        return Duel.IsExistingMatchingCard(s.utopia_filter, Duel.GetTurnPlayer(), zones, 0, 1, nil)
    end
    function s.utopia_filter(c)
        return c:IsSetCard(0x107F) or c:IsSetCard(0x7F)  -- Utopia or Utopic set
    end
    function s.synchro_dragon_filter(c, tp)
        return c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(7) and c:IsRace(RACE_DRAGON)
    end
    function s.ddcon(e, tp, eg, ep, ev, re, r, rp)
        return Duel.GetLP(Duel.GetTurnPlayer()) <= 1000
    end
    function s.ddop(e, tp, eg, ep, ev, re, r, rp)
    local playerID = Duel.GetTurnPlayer()
    if not Duel.SelectYesNo(playerID, aux.Stringid(511004000, 0)) then return end
    local opts = {}
    -- Option 0 (Always available): Draw a card
    table.insert(opts, aux.Stringid(511004000, 1))
    -- Option 1 (Generate a card, available once per player)
    if not s.hasUsedOptionOne[playerID] then
        table.insert(opts, aux.Stringid(511004000, 2))
    end
    -- Option 2 (Available if the user controls a "Utopia" or "Utopic" monster)
    if s.check_utopia_conditions(playerID) then
        table.insert(opts, aux.Stringid(511004000, 4))
    end
    -- Option 3 (Available if "Shooting Star Dragon" is on your field)
    if Duel.IsExistingMatchingCard(s.synchro_dragon_filter, playerID, LOCATION_EXTRA + LOCATION_MZONE + LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, nil) then
        table.insert(opts, aux.Stringid(511004000, 5))
    end
    -- New Option: Banish cards and return to the top of the deck
    table.insert(opts, aux.Stringid(511004000, 6))
    
    if #opts == 0 then return end -- If no options are available, don't continue.
    local opt = Duel.SelectOption(playerID, table.unpack(opts))
    if opts[opt + 1] == aux.Stringid(511004000, 1) then
        Duel.Hint(HINT_CARD, playerID, id)
        Duel.Hint(HINT_SELECTMSG, playerID, HINTMSG_ATOHAND)
        local g = Duel.SelectMatchingCard(playerID, s.thfilter, playerID, LOCATION_DECK, 0, 1, 1, nil)
        local tc = g:GetFirst()
        if tc then
            Duel.ShuffleDeck(playerID)
            Duel.MoveSequence(tc, 0)
        end
    elseif opts[opt + 1] == aux.Stringid(511004000, 2) then
        s.hasUsedOptionOne[playerID] = true
        if not Duel.SelectYesNo(playerID, aux.Stringid(511004000, 3)) then
            s.announce_filter = {TYPE_MONSTER + TYPE_SPELL + TYPE_TRAP, OPCODE_ISTYPE, OPCODE_ALLOW_ALIASES}
            local ac = Duel.AnnounceCard(playerID, table.unpack(s.announce_filter))
            local token = Duel.CreateToken(playerID, ac)
            Duel.SendtoDeck(token, playerID, 0, REASON_EFFECT)
        end
    elseif opts[opt + 1] == aux.Stringid(511004000, 4) then
        if not Duel.SelectYesNo(playerID, aux.Stringid(id, 3)) then
            Duel.Hint(HINT_SELECTMSG, playerID, HINTMSG_REMOVE)
            local g = Duel.SelectMatchingCard(playerID, Card.IsAbleToRemove, playerID, LOCATION_DECK, 0, 1, 99, nil, POS_FACEDOWN)
            if g and #g > 0 then
                Duel.Remove(g, POS_FACEDOWN, REASON_EFFECT)
                Duel.ShuffleDeck(playerID)
                s.announce_filter = s.announce_filter or {TYPE_MONSTER + TYPE_SPELL + TYPE_TRAP, OPCODE_ISTYPE, OPCODE_ALLOW_ALIASES}
                for i = 1, #g do
                    local ac = Duel.AnnounceCard(playerID, table.unpack(s.announce_filter))
                    local token = Duel.CreateToken(playerID, ac)
                    Duel.SendtoDeck(token, playerID, 0, REASON_EFFECT)
                end
            end
        end
    elseif opts[opt + 1] == aux.Stringid(511004000, 5) then
        Duel.Hint(HINT_SELECTMSG, playerID, HINTMSG_TODECK)
        local g = Duel.SelectMatchingCard(playerID, nil, playerID, LOCATION_DECK, 0, 1, 5, nil)
        if #g == 5 then
            for i = 1, 5 do
                local tc = g:GetFirst() -- Assumes sequential selection, adjust as needed for your logic
                Duel.MoveSequence(tc, 0)
                g:RemoveCard(tc)
            end
        end
    elseif opts[opt + 1] == aux.Stringid(511004000, 6) then
        -- New Banish and Return to Deck Option
        Duel.Hint(HINT_SELECTMSG, playerID, HINTMSG_REMOVE)
        local g = Duel.SelectMatchingCard(playerID, Card.IsAbleToRemove, playerID, LOCATION_DECK, 0, 1, #Duel.GetFieldGroup(playerID, LOCATION_DECK, 0), nil)
        if g and #g > 0 then
            Duel.Remove(g, POS_FACEDOWN, REASON_EFFECT)
            Duel.ShuffleDeck(playerID)
            -- Return the banished cards to the deck
            Duel.SendtoDeck(g, nil, SEQ_DECKTOP, REASON_EFFECT)
            -- Allow sorting the deck
            Duel.SortDecktop(playerID, playerID, #g)
        end
    end
end
end