--歓喜の断末魔
function c511002093.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c511002093.condition)
	e1:SetTarget(c511002093.target)
	e1:SetOperation(c511002093.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_MSET)
	c:RegisterEffect(e2)
end
function c511002093.cfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c511002093.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return eg:GetCount()==1 and eg:IsExists(c511002093.cfilter,1,nil,1-tp) and tc:GetSummonType()==SUMMON_TYPE_TRIBUTE
end
function c511002093.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	local mg=tc:GetMaterial()
	if chk==0 then return mg:GetCount()>0 end
	local atk=mg:GetSum(Card.GetPreviousAttackOnField)
	Duel.SetTargetCard(tc)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function c511002093.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if tc and Duel.Recover(p,d,REASON_EFFECT) then
		tc:SetMaterial(nil) 
	end
end
