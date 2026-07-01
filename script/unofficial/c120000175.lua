--宝玉獣 エメラルド・タートル
function c120000175.initial_effect(c)
	--send replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000175,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c120000175.repcon)
	e1:SetOperation(c120000175.repop)
	c:RegisterEffect(e1)
	--change pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000175,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c120000175.target)
	e2:SetOperation(c120000175.operation)
	c:RegisterEffect(e2)
end
function c120000175.repcon(e)
	return e:GetHandler():IsType(TYPE_MONSTER) and e:GetHandler():IsReason(REASON_DESTROY)
end
function c120000175.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	c:RegisterEffect(e1)
	Duel.RaiseEvent(c,EVENT_CUSTOM+47408488,e,0,tp,0,0)
end
function c120000175.filter(c)
	return c:IsAttackPos() and c:GetAttackedCount()>0
end
function c120000175.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c120000175.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c120000175.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c120000175.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c120000175.filter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local tg=g:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,0,0)
end
