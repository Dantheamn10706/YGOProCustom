-- ZEXAL Number Rule
--   1) Number archetype (setcard 0x48) monsters are battle-indestructible
--      against non-Number, non-Divine monsters.
--   2) Shining Draw (relocated from Heart of the cards):
--      Right before a player draws, they may banish facedown deck cards and
--      replace them (on top of the Deck) with announced cards.
--      Fires for the normal draw (predraw) AND for effect draws: any chain
--      link that declares CATEGORY_DRAW in its operation info (Pot of Greed,
--      Card of Sanctity, Xyz Treasure, ...). Searches / add-to-hand effects
--      don't declare a draw, so they never prompt.
--      Offered when the drawing player:
--        a) controls a face-up Utopia/Utopic monster, or
--        b) has 1000 LP or less and a Utopia/Utopic monster in ED/MZONE/GRAVE/REMOVED/DECK.
--      Declining a (a)-only prompt offers "stop asking unless LP <= 1000"
--      for the rest of the duel. WindBot AI declines via the str2 gate.
-- String IDs (str1 = Shining-Draw prompt, str2 = WindBot-AI prompt,
-- str3 = stop-asking prompt) live in this card's row in rule_extras.cdb.
local s, id = GetID()
if s then
    function s.initial_effect(c)
        aux.EnableExtraRules(c, s, s.init)
    end
    function s.init(c)
        s.quiet = {[0] = false, [1] = false}
        -- (1) Number battle-indestructibility
        local e2 = Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetRange(LOCATION_REMOVED)
        e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e2:SetTargetRange(LOCATION_ONFIELD, LOCATION_ONFIELD)
        e2:SetTarget(s.Target)
        e2:SetValue(s.indval)
        Duel.RegisterEffect(e2, 0)
        -- (2a) Shining Draw: normal draw
        local e3 = Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        e3:SetCode(EVENT_PREDRAW)
        e3:SetCountLimit(1)
        e3:SetCondition(s.predrawcon)
        e3:SetOperation(s.predrawop)
        Duel.RegisterEffect(e3, 0)
        -- (2b) Shining Draw: effect draws, just before the draw effect resolves
        local e4 = Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        e4:SetCode(EVENT_CHAIN_SOLVING)
        e4:SetOperation(s.chainop)
        Duel.RegisterEffect(e4, 0)
    end
    function s.indval(e, c)
        return not c:IsSetCard(0x48) and not c:IsAttribute(ATTRIBUTE_DIVINE)
    end
    function s.Target(e, c)
        return c:IsSetCard(0x48) and not c:IsDisabled(c)
    end
    function s.utopia_filter(c)
        return c:IsSetCard(0x107F) or c:IsSetCard(0x7F)
    end
    function s.utopia_field_filter(c)
        return c:IsFaceup() and s.utopia_filter(c)
    end
    -- Returns trigger flags: field = Utopia/Utopic face-up on field,
    -- lowlp = LP <= 1000 with a Utopia/Utopic reachable anywhere.
    function s.triggers(p)
        local field = Duel.IsExistingMatchingCard(s.utopia_field_filter, p, LOCATION_MZONE, 0, 1, nil)
        local zones = LOCATION_EXTRA + LOCATION_MZONE + LOCATION_GRAVE + LOCATION_REMOVED + LOCATION_DECK
        local lowlp = Duel.GetLP(p) <= 1000
            and Duel.IsExistingMatchingCard(s.utopia_filter, p, zones, 0, 1, nil)
        return field, lowlp
    end
    function s.can_offer(p)
        if Duel.GetFieldGroupCount(p, LOCATION_DECK, 0) == 0 then return false end
        local field, lowlp = s.triggers(p)
        if lowlp then return true end
        return field and not s.quiet[p]
    end
    function s.predrawcon(e, tp, eg, ep, ev, re, r, rp)
        local p = Duel.GetTurnPlayer()
        return Duel.GetTurnCount() > 1 and Duel.GetDrawCount(p) > 0 and s.can_offer(p)
    end
    function s.predrawop(e, tp, eg, ep, ev, re, r, rp)
        s.shining(Duel.GetTurnPlayer())
    end
    function s.chainop(e, tp, eg, ep, ev, re, r, rp)
        local ok, _, _, p = Duel.GetOperationInfo(ev, CATEGORY_DRAW)
        if not ok then return end
        if p == PLAYER_ALL then
            local first = Duel.GetTurnPlayer()
            if s.can_offer(first) then s.shining(first) end
            if s.can_offer(1 - first) then s.shining(1 - first) end
        elseif (p == 0 or p == 1) and s.can_offer(p) then
            s.shining(p)
        end
    end
    function s.shining(p)
        if not Duel.SelectYesNo(p, aux.Stringid(id, 0)) then
            -- Declined: if only the Utopia-on-field trigger fired, offer to go quiet.
            local field, lowlp = s.triggers(p)
            if field and not lowlp and not s.quiet[p]
                and Duel.SelectYesNo(p, aux.Stringid(id, 2)) then
                s.quiet[p] = true
            end
            return
        end
        -- WindBot AI must decline so the announce-card sequence doesn't crash it.
        if Duel.SelectYesNo(p, aux.Stringid(id, 1)) then return end
        Duel.Hint(HINT_SELECTMSG, p, HINTMSG_REMOVE)
        local g = Duel.SelectMatchingCard(p, Card.IsAbleToRemove, p, LOCATION_DECK, 0, 1, 99, nil, p, POS_FACEDOWN)
        if g and #g > 0 then
            local ct = Duel.Remove(g, POS_FACEDOWN, REASON_EFFECT)
            Duel.ShuffleDeck(p)
            s.announce_filter = s.announce_filter or {TYPE_MONSTER + TYPE_SPELL + TYPE_TRAP, OPCODE_ISTYPE, OPCODE_ALLOW_ALIASES}
            for i = 1, ct do
                local ac = Duel.AnnounceCard(p, table.unpack(s.announce_filter))
                local token = Duel.CreateToken(p, ac)
                Duel.SendtoDeck(token, p, SEQ_DECKTOP, REASON_EFFECT)
            end
        end
    end
end
