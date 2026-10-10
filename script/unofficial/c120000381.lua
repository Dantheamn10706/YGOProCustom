--幻蝶の護り
function c120000381.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c120000381.activate)
	c:RegisterEffect(e1)
end
function c120000381.activate(e,tp,eg,ep,ev,re,r,rp)
	--damage
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetCondition(c120000381.damcon)
	e1:SetOperation(c120000381.damop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--position
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetCountLimit(1)
	e2:SetTarget(c120000381.target)
	e2:SetOperation(c120000381.operation)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end	
function c120000381.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c120000381.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,ev/2)
end
function c120000381.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsPosition(POS_FACEUP_ATTACK)
end
function c120000381.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c120000381.filter,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c120000381.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c120000381.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsPosition(POS_FACEUP_ATTACK) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	end
end
