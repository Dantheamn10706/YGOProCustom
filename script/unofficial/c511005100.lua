-- Heart of the cards — LP <= s.LP_LIMIT:
--   * Draw Phase (predraw): menu of draw-substitute options (str2/3/6/7).
--   * Effect draws (any chain link declaring CATEGORY_DRAW: Pot of Greed,
--     Card of Sanctity, Xyz Treasure, ...): just before it resolves, the
--     drawing player may pick up to N Deck cards (N = cards about to be drawn)
--     and stack them on top in any order. Searches don't declare a draw, so
--     they never prompt.
-- (Shining Draw / Utopia option lives on the ZEXAL Number Rule card instead.)
-- String IDs (str1-str7) live in this card's own row in rule_extras.cdb.
local s, id = GetID()
if s then
    s.LP_LIMIT = 1000
    function s.initial_effect(c)
        aux.EnableExtraRules(c, s, s.init)
    end
    function s.init(c)
        s.hasUsedOptionOne = {}
        -- Normal draw
        local e3 = Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        e3:SetCode(EVENT_PREDRAW)
        e3:SetCountLimit(1)
        e3:SetCondition(s.ddcon)
        e3:SetOperation(s.ddop)
        Duel.RegisterEffect(e3, 0)
        -- Effect draws, just before the draw effect resolves
        local e4 = Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        e4:SetCode(EVENT_CHAIN_SOLVING)
        e4:SetOperation(s.chainop)
        Duel.RegisterEffect(e4, 0)
    end
    function s.synchro_dragon_filter(c, tp)
        return c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(7) and c:IsRace(RACE_DRAGON)
    end
    function s.can_offer(p)
        return Duel.GetLP(p) <= s.LP_LIMIT and Duel.GetFieldGroupCount(p, LOCATION_DECK, 0) > 0
    end
    function s.ddcon(e, tp, eg, ep, ev, re, r, rp)
        local p = Duel.GetTurnPlayer()
        return Duel.GetTurnCount() > 1 and Duel.GetDrawCount(p) > 0 and s.can_offer(p)
    end
    function s.ddop(e, tp, eg, ep, ev, re, r, rp)
        s.heart(Duel.GetTurnPlayer())
    end
    function s.chainop(e, tp, eg, ep, ev, re, r, rp)
        local ok, _, _, p, n = Duel.GetOperationInfo(ev, CATEGORY_DRAW)
        if not ok then return end
        if p == PLAYER_ALL then
            local first = Duel.GetTurnPlayer()
            if s.can_offer(first) then s.stack(first, n) end
            if s.can_offer(1 - first) then s.stack(1 - first, n) end
        elseif (p == 0 or p == 1) and s.can_offer(p) then
            s.stack(p, n)
        end
    end
    -- Effect draw: pick up to n Deck cards (whole Deck if n is unknown),
    -- move them to the top, then order them. The rest of the draw is random.
    function s.stack(p, n)
        if not Duel.SelectYesNo(p, aux.Stringid(id, 0)) then return end
        local deck_count = Duel.GetFieldGroupCount(p, LOCATION_DECK, 0)
        local max = (n and n > 0) and math.min(n, deck_count) or deck_count
        Duel.Hint(HINT_SELECTMSG, p, HINTMSG_TODECK)
        local g = Duel.SelectMatchingCard(p, nil, p, LOCATION_DECK, 0, 1, max, nil)
        local count = g and #g or 0
        if count == 0 then return end
        for tc in aux.Next(g) do
            Duel.MoveSequence(tc, 0)
        end
        if count > 1 then Duel.SortDecktop(p, p, count) end
    end
    -- Draw Phase menu (unchanged)
    function s.heart(playerID)
        if not Duel.SelectYesNo(playerID, aux.Stringid(id, 0)) then return end
        local opts = {}
        table.insert(opts, aux.Stringid(id, 1))
        if not s.hasUsedOptionOne[playerID] then
            table.insert(opts, aux.Stringid(id, 2))
        end
        if Duel.IsExistingMatchingCard(s.synchro_dragon_filter, playerID, LOCATION_EXTRA + LOCATION_MZONE + LOCATION_GRAVE + LOCATION_REMOVED, 0, 1, nil) then
            table.insert(opts, aux.Stringid(id, 5))
        end
        table.insert(opts, aux.Stringid(id, 6))

        local opt = Duel.SelectOption(playerID, table.unpack(opts))
        if opts[opt + 1] == aux.Stringid(id, 1) then
            Duel.Hint(HINT_CARD, playerID, id)
            Duel.Hint(HINT_SELECTMSG, playerID, HINTMSG_ATOHAND)
            local g = Duel.SelectMatchingCard(playerID, nil, playerID, LOCATION_DECK, 0, 1, 1, nil)
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
