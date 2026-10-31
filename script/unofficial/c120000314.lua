--BF－アンカー
function c120000314.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000314,0))
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetCost(c120000314.cost1)
	e1:SetOperation(c120000314.activate)
	c:RegisterEffect(e1)
end	
function c120000314.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsSetCard,1,nil,0x33) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsSetCard,1,1,nil,0x33)
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.Release(g,REASON_COST)
end
function c120000314.activate(e,tp,eg,ep,ev,re,r,rp)
	--atk
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(120000314,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetLabel(e:GetLabel())
	e2:SetCost(c120000314.cost2)
	e2:SetTarget(c120000314.tg)
	e2:SetOperation(c120000314.op)
	Duel.RegisterEffect(e2,tp)
end
function c120000314.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c120000314.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c120000314.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000314.filter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c120000314.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,c120000314.filter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(e:GetLabel())
		tc:RegisterEffect(e1)
	end
end