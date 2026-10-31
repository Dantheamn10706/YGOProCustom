-- Signer Draw — when Shooting Star Dragon (24696097) chains, owner piles
-- N Tuners from deck onto deck top, where N = opponent's monsters on field.
-- Extracted from the original c511004000 (Anime Style Duel) bundle.
local s, id = GetID()
if s then
    function s.initial_effect(c)
        aux.EnableExtraRules(c, s, s.init)
    end
    function s.init(c)
        local e4 = Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        e4:SetCode(EVENT_CHAINING)
        e4:SetCondition(s.sscon)
        e4:SetOperation(s.ssop)
        Duel.RegisterEffect(e4, 0)
    end
    function s.sscon(e, tp, eg, ep, ev, re, r, rp)
        return re:GetHandler():IsCode(24696097)
            and re:GetHandlerPlayer() == Duel.GetTurnPlayer()
            and Duel.GetFieldGroupCount(Duel.GetTurnPlayer(), 0, LOCATION_MZONE) > 0
            and Duel.GetTurnPlayer() == Duel.GetTurnPlayer()
    end
    function s.ssop(e, tp, eg, ep, ev, re, r, rp)
        local count = Duel.GetFieldGroupCount(Duel.GetTurnPlayer(), 0, LOCATION_MZONE)
        Duel.Hint(HINT_SELECTMSG, Duel.GetTurnPlayer(), HINTMSG_TODECK)
        local g = Duel.SelectMatchingCard(Duel.GetTurnPlayer(), Card.IsType, Duel.GetTurnPlayer(), LOCATION_DECK, 0, count, count, nil, TYPE_TUNER)
        if #g > 0 then
            Duel.ShuffleDeck(Duel.GetTurnPlayer())
            Duel.MoveToDeckTop(g)
        end
    end
end
