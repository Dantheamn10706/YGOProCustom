--スピード・ワールド ３
--Speed World 3
local s,id=GetID()
function s.initial_effect(c)
    -- Enable Speed Counters (0x91)
    c:EnableCounterPermit(0x91)
    c:SetCounterLimit(0x91,12)
    -- Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    -- All Spell Cards become Quick-Play
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e2:SetCode(EFFECT_BECOME_QUICK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_HAND+LOCATION_SZONE, LOCATION_HAND+LOCATION_SZONE)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSpell))
    c:RegisterEffect(e2)
    -- Add 1 Speed Counter during your Standby Phase
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
    e3:SetCondition(s.ctcon)
    e3:SetOperation(s.ctop)
    c:RegisterEffect(e3)
    -- Once per turn: Generate any Speed Spell
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id, 0))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(s.gencon)
    e4:SetOperation(s.generate_spell)
    c:RegisterEffect(e4)
end
-- Add counter condition (block if certain effects are active)
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsPlayerAffectedByEffect(tp,100100090)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():AddCounter(0x91,1)
end
-- Condition: Can only activate if you don't have a Speed Spell in hand
function s.gencon(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(function(c) return c:IsSetCard(0x500) end,tp,LOCATION_HAND,0,1,nil)
end
-- Generate any Speed Spell (via token) - Using anime style pattern
function s.generate_spell(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then return end
    
    -- Filter to only allow Speed Spells (setname 0x500)
    s.announce_filter = {0x500, OPCODE_ISSETCARD, OPCODE_ALLOW_ALIASES}
    local ac = Duel.AnnounceCard(tp, table.unpack(s.announce_filter))
    local token = Duel.CreateToken(tp, ac)
    
    -- Send the token to the player's hand (tp = turn player)
    Duel.SendtoHand(token, tp, REASON_EFFECT)
    
    -- Confirm the card to the opponent (needs to be a group)
    Duel.ConfirmCards(1-tp, Group.FromCards(token))
end