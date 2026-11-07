--ＥＭフラットラット
function c120000035.initial_effect(c)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000035,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetTarget(c120000035.lvtg)
	e1:SetOperation(c120000035.lvop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(120000035,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_FLAG_DELAY+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(511001265)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetCondition(c120000035.condition)
	e3:SetCost(c120000035.cost)
	e3:SetTarget(c120000035.target)
	e3:SetOperation(c120000035.operation)
	c:RegisterEffect(e3)
end
function c120000035.lvfilter(c,e)
	return c:IsFaceup() and c:GetLevel()>0
end
function c120000035.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_MONSTER) and eg:IsExists(c120000035.lvfilter,1,e:GetHandler()) end
	Duel.SetTargetCard(eg)
end
function c120000035.lvop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local lv=c:GetLevel()
	local g=eg:Filter(c120000035.lvfilter,nil):Filter(Card.IsRelateToEffect,nil,e)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c120000035.cfilter(c)
	local val=0
	if c:GetFlagEffect(284)>0 then val=c:GetFlagEffectLabel(284) end
	return c:GetAttack()~=val
end
function c120000035.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_MONSTER) and eg:IsExists(c120000035.cfilter,1,nil)
end
function c120000035.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c120000035.tgfilter(c,e,tp,chk)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() and c:IsCanBeEffectTarget(e) and c:GetFlagEffect(284)>0
end
function c120000035.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c120000035.tgfilter(chkc,e,tp,true) end
	local g=eg:Filter(c120000035.tgfilter,nil,e,tp,false)
	if chk==0 then return g:GetCount()>0 end
		if g:GetCount()==1 then
		Duel.SetTargetCard(g:GetFirst())
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tc=g:Select(tp,1,1,nil)
		Duel.SetTargetCard(tc)
	end	
end
function c120000035.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:GetAttack()~=tc:GetBaseAttack() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(tc:GetBaseAttack())
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
	end
end