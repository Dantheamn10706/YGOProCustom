--ＥＭフラットラット
Duel.LoadScript("c419.lua")
function c120000195.initial_effect(c)
	--Atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetDescription(aux.Stringid(120000195,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_FLAG_DELAY+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(511001265)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCondition(c120000195.condition)
	e1:SetCost(c120000195.cost)
	e1:SetTarget(c120000195.target)
	e1:SetOperation(c120000195.operation)
	c:RegisterEffect(e1)
end
function c120000195.cfilter(c,tp)
	local val=0
	if c:GetFlagEffect(284)>0 then val=c:GetFlagEffectLabel(284) end
	return c:IsControler(tp) and c:GetAttack()~=val
end
function c120000195.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_MONSTER) and eg:IsExists(c120000195.cfilter,1,nil,tp)
end
function c120000195.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c120000195.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c120000195.cfilter,1,nil,e,tp)  end
	Duel.SetTargetCard(eg)
end
function c120000195.tgfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:GetFlagEffect(284)>0
end
function c120000195.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=eg:FilterSelect(tp,c120000195.tgfilter,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		end
	end
end