-- Heart of the cards — LP <= 1000 triggers a menu of draw-substitute options.
-- (Shining Draw / Utopia option lives on the ZEXAL Number Rule card instead.)
-- String IDs (str1-str7) live in this card's own row in rule_extras.cdb.
local s, id = GetID()
s.hasUsedOptionOne = {}
if s then
    function s.initial_effect(c)
        aux.EnableExtraRules(c, s, s.init)
    end
    function s.init(c)
        local e3 = Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        e3:SetCode(EVENT_PREDRAW)
        e3:SetCountLimit(1)
        e3:SetCondition(s.ddcon)
        e3:SetOperation(s.ddop)
        Duel.RegisterEffect(e3, 0)
    end
    function s.synchro_dragon_filter(c, tp)
        return c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(7) and c:IsRace(RACE_DRAGON)
    end
    function s.ddcon(e, tp, eg, ep, ev, re, r, rp)
        return Duel.GetLP(Duel.GetTurnPlayer()) <= 1000
    end
    function s.ddop(e, tp, eg, ep, ev, re, r, rp)
        local playerID = Duel.GetTurnPlayer()
        if not Duel.SelectYesNo(playerID, aux.Stringid(id, 0)) then return end
        local opts = {}
        table.insert(opts, aux.Stringid(id, 1))
        if not s.hasUsedOptionOne[playerID] then
            table.insert(opts, aux.Stringid(id, 2))
        end
        if Duel.IsExistingMatchingCard(s.synchro_dragon_filter, playerID, LOCATION_EXTRA + LOCATION_MZONE + LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, nil) then
            table.insert(opts, aux.Stringid(id, 5))
        end
        if Duel.GetFieldGroupCount(playerID, LOCATION_DECK, 0) > 0 then
            table.insert(opts, aux.Stringid(id, 6))
        end

        if #opts == 0 then return end
        local opt = Duel.SelectOption(playerID, table.unpack(opts))
        if opts[opt + 1] == aux.Stringid(id, 1) then
            Duel.Hint(HINT_CARD, playerID, id)
            Duel.Hint(HINT_SELECTMSG, playerID, HINTMSG_ATOHAND)
            local g = Duel.SelectMatchingCard(playerID, s.thfilter, playerID, LOCATION_DECK, 0, 1, 1, nil)
            local tc = g:GetFirst()
            if tc then
                Duel.ShuffleDeck(playerID)
                Duel.MoveSequence(tc, 0)
            end
        elseif opts[opt + 1] == aux.Stringid(id, 2) then
            s.hasUsedOptionOne[playerID] = true
            if not Duel.SelectYesNo(playerID, aux.Stringid(id, 3)) then
                s.announce_filter = {TYPE_MONSTER + TYPE_SPELL + TYPE_TRAP, OPCODE_ISTYPE, OPCODE_ALLOW_ALIASES}
                local ac = Duel.AnnounceCard(playerID, table.unpack(s.announce_filter))
                local token = Duel.CreateToken(playerID, ac)
                Duel.SendtoDeck(token, playerID, 0, REASON_EFFECT)
            end
        elseif opts[opt + 1] == aux.Stringid(id, 5) then
            Duel.Hint(HINT_SELECTMSG, playerID, HINTMSG_TODECK)
            local g = Duel.SelectMatchingCard(playerID, nil, playerID, LOCATION_DECK, 0, 1, 5, nil)
            if #g == 5 then
                for i = 1, 5 do
                    local tc = g:GetFirst()
                    Duel.MoveSequence(tc, 0)
                    g:RemoveCard(tc)
                end
            end
        elseif opts[opt + 1] == aux.Stringid(id, 6) then
            Duel.Hint(HINT_SELECTMSG, playerID, HINTMSG_TODECK)
            local deck_count = Duel.GetFieldGroupCount(playerID, LOCATION_DECK, 0)
            local g = Duel.SelectMatchingCard(playerID, nil, playerID, LOCATION_DECK, 0, 1, deck_count, nil)
            local count = #g
            if count > 0 then
                for tc in aux.Next(g) do
                    Duel.MoveSequence(tc, 0)
                end
                Duel.SortDecktop(playerID, playerID, count)
            end
        end
    end
end
