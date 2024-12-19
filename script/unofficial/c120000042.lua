--EMチアモール
Duel.LoadScript("c419.lua")
function c120000042.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c120000042.atktg)
	e1:SetValue(400)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17857780,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_FLAG_DELAY+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(511001265)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCountLimit(1)
	e2:SetCondition(c120000042.condition)
	e2:SetTarget(c120000042.target)
	e2:SetOperation(c120000042.activate)
	c:RegisterEffect(e2)
end
function c120000042.atktg(e,c)
	return c:IsType(TYPE_PENDULUM)
end
function c120000042.cfilter(c)
	local val=0
	if c:GetFlagEffect(284)>0 then val=c:GetFlagEffectLabel(284) end
	return c:IsFaceup() and c:GetAttack()~=val
end
function c120000042.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_MONSTER) and eg:IsExists(c120000042.cfilter,1,nil)
end
function c120000042.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c120000042.filter(chkc) end
	if chk==0 then return eg:IsExists(c120000042.cfilter,1,nil) end
	if eg:GetCount()==1 then
		Duel.SetTargetCard(eg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=eg:FilterSelect(tp,c120000042.cfilter,1,1,nil)
		Duel.SetTargetCard(g)
	end
end
function c120000042.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local atk=tc:GetAttack()
		local batk=tc:GetBaseAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		if atk>batk or atk==batk then
			e1:SetValue(1000)
		else
			e1:SetValue(-1000)
		end
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end