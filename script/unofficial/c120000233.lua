--エクトプラズマー
function c120000233.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Release
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000233,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c120000233.rcecon)
	e2:SetTarget(c120000233.rcetg)
	e2:SetOperation(c120000233.rceop)
	c:RegisterEffect(e2)
end
function c120000233.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c120000233.rcecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(c120000233.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c120000233.rcetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c120000233.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	local race=0
	while tc do
		race=bit.bor(race,tc:GetRace())
		tc=g:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local rce=Duel.AnnounceRace(tp,2,race)
	e:SetLabel(rce)
	e:GetHandler():SetHint(CHINT_RACE,rce)
end
function c120000233.rcefilter(c,rce)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsRace(rce)
end
function c120000233.rceop(e,tp,eg,ep,ev,re,r,rp)
	local rce=e:GetLabel()
	local g=Duel.GetMatchingGroup(c120000233.rcefilter,tp,LOCATION_ONFIELD,0,nil,rce)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:Select(tp,1,1,nil):GetFirst()
	local atk=sg:GetAttack()/2
	--Atk
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	sg:RegisterEffect(e1)
	--Plasma
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetValue(120000233)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	sg:RegisterEffect(e2)
	if sg and sg:IsCode(120000233) and Duel.Release(sg,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end		
end
