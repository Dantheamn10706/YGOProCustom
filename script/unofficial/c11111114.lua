--Millennium Necklace
local s,id=GetID()
function s.initial_effect(c)
    -- Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)

    -- Look at top 2 cards of either deck by sending top 2 of your deck to GY
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_SZONE+LOCATION_GRAVE)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.condition)
    e1:SetCost(s.cost)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsLocation(LOCATION_SZONE) or (c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp))
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2 end
    local g=Duel.GetDecktopGroup(tp,2)
    Duel.DisableShuffleCheck()
    Duel.SendtoGrave(g,REASON_COST)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2 or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=2
    end
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0)) -- e.g. "Choose a deck to look at"
    local opt=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1)) -- 0 = own deck, 1 = opponent's
    local p=(opt==0) and tp or 1-tp

    if Duel.GetFieldGroupCount(p,LOCATION_DECK,0)<2 then return end

    local g=Duel.GetDecktopGroup(p,2)
    Duel.ConfirmCards(tp,g)
end
