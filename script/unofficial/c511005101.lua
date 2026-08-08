-- ZEXAL Number Rule
--   1) Number archetype (setcard 0x48) monsters are battle-indestructible
--      against non-Number, non-Divine monsters.
--   2) Shining Draw (relocated from Heart of the cards):
--      On predraw, if the turn player controls a Utopia/Utopic monster anywhere
--      reachable (ED/MZONE/GRAVE/REMOVED/DECK), they may banish facedown deck
--      cards and replace them with announced cards. WindBot AI declines.
-- String IDs (str1 = Shining-Draw prompt, str2 = WindBot-AI prompt) live in
-- this card's row in rule_extras.cdb.
local s, id = GetID()
if s then
    function s.initial_effect(c)
        aux.EnableExtraRules(c, s, s.init)
    end
    function s.init(c)
        -- (1) Number battle-indestructibility
        local e2 = Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetRange(LOCATION_REMOVED)
        e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
        e2:SetTargetRange(LOCATION_ONFIELD, LOCATION_ONFIELD)
        e2:SetTarget(s.Target)
        e2:SetValue(s.indval)
        Duel.RegisterEffect(e2, 0)
        -- (2) Shining Draw
        local e3 = Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        e3:SetCode(EVENT_PREDRAW)
        e3:SetCountLimit(1)
        e3:SetCondition(s.shiningcon)
        e3:SetOperation(s.shiningop)
        Duel.RegisterEffect(e3, 0)
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
    function s.check_utopia_conditions(tp)
        local zones = LOCATION_EXTRA + LOCATION_MZONE + LOCATION_GRAVE + LOCATION_REMOVED + LOCATION_DECK
        return Duel.IsExistingMatchingCard(s.utopia_filter, tp, zones, 0, 1, nil)
    end
    function s.shiningcon(e, tp, eg, ep, ev, re, r, rp)
        return Duel.GetLP(Duel.GetTurnPlayer()) <= 1000
            and s.check_utopia_conditions(Duel.GetTurnPlayer())
    end
    function s.shiningop(e, tp, eg, ep, ev, re, r, rp)
        local playerID = Duel.GetTurnPlayer()
        if not Duel.SelectYesNo(playerID, aux.Stringid(id, 0)) then return end
        -- WindBot AI must decline so the announce-card sequence doesn't crash it.
        if Duel.SelectYesNo(playerID, aux.Stringid(id, 1)) then return end
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
end
