--おジャマシーン・イエロー
function c511005030.initial_effect(c)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetOperation(c511005030.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(511005030,0))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetOperation(c511005030.damop)
	c:RegisterEffect(e5)
end
function c511005030.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	local def=c:GetDefense()
	local lv=c:GetLevel()
	local race=c:GetRace()
	local att=c:GetAttribute()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or (Duel.IsPlayerAffectedByEffect(tp,59822133) and ft>1) 
	or not Duel.IsPlayerCanSpecialSummonMonster(tp,c,511005031,0,0x4011,atk,def,lv,race,att) then return end
	local g=Group.CreateGroup()
	for i=1,ft do
		local token=Duel.CreateToken(tp,511005031)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		token:CopyEffect(c:GetOriginalCode(),RESET_EVENT+0xfe0000,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		e2:SetValue(def)
		token:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(lv)
		token:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(race)
		token:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetValue(att)
		token:RegisterEffect(e5)
		g:AddCard(token)
	end
	Duel.SpecialSummonComplete()
	g:KeepAlive()
	local e6=Effect.CreateEffect(e:GetHandler())
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c511005030.tdamtg)
	e6:SetOperation(c511005030.tdamop)
	e6:SetLabelObject(g)
	Duel.RegisterEffect(e6,tp)
end
function c511005030.tokenatk(e,c)
	return e:GetOwner():GetAttack()
end
function c511005030.tokendef(e,c)
	return e:GetOwner():GetDefense()
end
function c511005030.tokenlv(e,c)
	return e:GetOwner():GetLevel()
end
function c511005030.tokenrace(e,c)
	return e:GetOwner():GetRace()
end
function c511005030.tokenatt(e,c)
	return e:GetOwner():GetAttribute()
end
function c511005030.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_DESTROY) then
		Duel.Damage(1-e:GetHandler():GetPreviousControler(),300,REASON_EFFECT)
	end
	e:Reset()
end
function c511005030.tdamfilter(c,g)
	return g:IsContains(c)
end
function c511005030.tdamtg(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if eg:IsExists(c511005030.tdamfilter,1,nil,g) then
		return true
	elseif not g:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD) then
		g:DeleteGroup()
		e:Reset()
	end
	return false
end
function c511005030.tdamop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tc=eg:GetFirst()
	while tc do
		if g:IsContains(tc) then
			Duel.Damage(1-tc:GetPreviousControler(),300,REASON_EFFECT)
			g:RemoveCard(tc)
		end
		tc=eg:GetNext()
	end
end
