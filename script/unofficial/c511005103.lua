-- Puppet Sandbox (Daniel's custom rule card, 2026-06-13).
-- Toggleable via Extra Rules dialog (PUPPET_SANDBOX = 0x10000).
-- Uses the EDOPro "Skill zone" UI pattern (same as the Deck Master rule):
--   * Card lives logically in the deck (after aux.EnableExtraRules' SendtoDeck).
--   * Duel.Hint(HINT_SKILL_FLIP, ...) renders it as a free-floating card
--     icon in the dedicated skill slot off to the side of the field.
--   * EVENT_FREE_CHAIN continuous effect makes it surface as a clickable
--     activation during the player's own MP1/MP2 — no auto-prompt interrupt,
--     no chain animation crash (no real card location to render).
-- On activation, loops through Sort / Swap / Shuffle / Done.
local s, id = GetID()
if s then
    function s.initial_effect(c)
        aux.EnableExtraRules(c, s, s.init)
    end
    function s.init(c)
        -- No HINT_SKILL_* hint at all — the card stays purely in deck/limbo
        -- after aux.EnableExtraRules and nothing visible is created on the
        -- field. The engine surfaces the EVENT_FREE_CHAIN continuous effect
        -- below as activatable through its normal free-chain UI indicator
        -- when condition is true.
        local e1 = Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_FREE_CHAIN)
        e1:SetCondition(s.cond)
        e1:SetOperation(s.op)
        Duel.RegisterEffect(e1, 0)
        -- Register a second copy for player 1 too, so the effect is also
        -- activatable on the AI's side. In Manual override mode, the AI's
        -- IDLECMD prompts route to the human (Puppet Mode plumbing in
        -- generic_duel.cpp), letting the user run sandbox actions on the AI's
        -- own hand/deck. In normal duels, WindBot has no executor for this
        -- unknown rule effect and won't voluntarily activate it.
        local e2 = e1:Clone()
        Duel.RegisterEffect(e2, 1)
    end
    function s.cond(e, tp, eg, ep, ev, re, r, rp)
        return Duel.GetTurnPlayer() == tp
            and (Duel.GetCurrentPhase() == PHASE_MAIN1 or Duel.GetCurrentPhase() == PHASE_MAIN2)
    end
    function s.op(e, tp, eg, ep, ev, re, r, rp)
        while true do
            local opts = {
                aux.Stringid(id, 3),  -- Sort deck (reorder)
                aux.Stringid(id, 4),  -- Swap hand & deck
                aux.Stringid(id, 5),  -- Shuffle deck
                aux.Stringid(id, 6),  -- Done
            }
            local choice = Duel.SelectOption(tp, table.unpack(opts))
            if choice == 0 then
                s.do_sort(tp)
            elseif choice == 1 then
                s.do_swap(tp)
            elseif choice == 2 then
                s.do_shuffle(tp)
            else
                break  -- Done
            end
        end
    end
    function s.do_sort(p)
        -- Heart-of-the-cards sort pattern: pick a group from deck, move them
        -- all to the top, then reorder the top group to the desired sequence.
        local n = Duel.GetFieldGroupCount(p, LOCATION_DECK, 0)
        if n == 0 then return end
        Duel.Hint(HINT_SELECTMSG, p, HINTMSG_TODECK)
        local g = Duel.SelectMatchingCard(p, nil, p, LOCATION_DECK, 0, 1, n, nil)
        local count = #g
        if count == 0 then return end
        for tc in aux.Next(g) do
            Duel.MoveSequence(tc, 0)
        end
        Duel.SortDecktop(p, p, count)
    end
    function s.do_swap(p)
        -- Pick N hand cards and N matching deck cards (1..min of the two
        -- counts), trade them all simultaneously, then shuffle.
        local hand_n = Duel.GetFieldGroupCount(p, LOCATION_HAND, 0)
        local deck_n = Duel.GetFieldGroupCount(p, LOCATION_DECK, 0)
        if hand_n == 0 or deck_n == 0 then return end
        local max_swap = math.min(hand_n, deck_n)
        Duel.Hint(HINT_SELECTMSG, p, HINTMSG_TODECK)
        local hg = Duel.SelectMatchingCard(p, nil, p, LOCATION_HAND, 0, 1, max_swap, nil)
        local hcount = #hg
        if hcount == 0 then return end
        Duel.Hint(HINT_SELECTMSG, p, HINTMSG_ATOHAND)
        local dg = Duel.SelectMatchingCard(p, nil, p, LOCATION_DECK, 0, hcount, hcount, nil)
        if #dg ~= hcount then return end
        Duel.SendtoDeck(hg, p, 0, REASON_RULE)
        Duel.SendtoHand(dg, p, REASON_RULE)
        Duel.ShuffleDeck(p)
    end
    function s.do_shuffle(p)
        Duel.ShuffleDeck(p)
    end
end
