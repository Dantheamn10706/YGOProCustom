local s,id=GetID()
function s.initial_effect(c)
    --Xyz Summon
    c:EnableReviveLimit()
    Xyz.AddProcedure(c,nil,8,3,s.ovfilter,aux.Stringid(id,0))
    --ATK Up by Materials
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(s.atkval)
    c:RegisterEffect(e1)
    --Detach to Gain ATK
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(s.atkcost)
    e2:SetOperation(s.atkop)
    c:RegisterEffect(e2)
end
s.xyz_number=62
s.xyzset=0x107b

function s.ovfilter(c,tp,xyzc)
	return Duel.GetLP(tp)<=1000 and c:IsFaceup() and c:IsSetCard(0x107b) and c:IsType(TYPE_XYZ,xyzc,SUMMON_TYPE_XYZ,tp) and c:GetRank()==8
end
function s.atkval(e,c)
    local g=e:GetHandler():GetOverlayGroup():Filter(Card.IsType,nil,TYPE_MONSTER)
    local val=0
    local tc=g:GetFirst()
    while tc do
        if tc:GetRank()>0 then
            val=val+tc:GetRank()
        else
            val=val+tc:GetLevel()
        end
        tc=g:GetNext()
    end
    return val*100
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetMaterial():Filter(Card.IsType,nil,TYPE_MONSTER)
    local atk=0
    local tc=g:GetFirst()
    while tc do
        atk=atk+tc:GetAttack()
        tc=g:GetNext()
    end
    if atk>0 then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end
