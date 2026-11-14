--双弓のケンタウロス
function c511001113.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Destruction
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511001113,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_COIN+CATEGORY_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCost(c511001113.descost)
	e2:SetTarget(c511001113.destar)
	e2:SetOperation(c511001113.desop)
	c:RegisterEffect(e2)
end
function c511001113.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c511001113.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()~=PHASE_MAIN2 and Duel.IsExistingTarget(c511001113.filter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(c511001113.filter,tp,0,LOCATION_ONFIELD,1,nil) 
	end
end
function c511001113.destar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c511001113.filter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(c511001113.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(511001113,1))
	local g1=Duel.SelectTarget(tp,c511001113.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(511001113,2))
	local g2=Duel.SelectTarget(tp,c511001113.filter,tp,0,LOCATION_ONFIELD,1,1,nil) 
	e:SetLabelObject(g1:GetFirst())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
end
function c511001113.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc2=g:GetFirst()
	if tc1==tc2 then tc2=g:GetNext() end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(5012,10))
	local coin=Duel.SelectOption(tp,60,61)
	local res=Duel.TossCoin(tp,1)
	if coin~=res then
		Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)
		Duel.Damage(1-tp,tc2:GetBaseAttack(),REASON_EFFECT)
	else
		Duel.Remove(tc1,POS_FACEUP,REASON_EFFECT)
		Duel.Damage(tp,tc1:GetBaseAttack(),REASON_EFFECT)
	end
	Duel.BreakEffect()
	local turnp=Duel.GetTurnPlayer()
		Duel.SkipPhase(turnp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,turnp)
end
