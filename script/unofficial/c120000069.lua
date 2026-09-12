--女帝の冠
function c120000069.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000069,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCondition(c120000069.condition)
	e1:SetTarget(c120000069.target)
	e1:SetOperation(c120000069.activate)
	c:RegisterEffect(e1)
	--Activate from hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000069,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c120000069.condition2)
	e2:SetTarget(c120000069.target)
	e2:SetOperation(c120000069.activate)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c120000069.actcon)
	c:RegisterEffect(e3)
end
function c120000069.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c120000069.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c120000069.cfilter,tp,0,LOCATION_ONFIELD,1,nil)
end
function c120000069.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(c120000069.cfilter,tp,0,LOCATION_ONFIELD,nil)*2
		return ct>0 and Duel.IsPlayerCanDraw(tp,ct)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c120000069.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(c120000069.cfilter,tp,0,LOCATION_ONFIELD,nil)*2
	Duel.Draw(p,ct,REASON_EFFECT)
end
function c120000069.chfilter(c,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsControler(1-tp)
end
function c120000069.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c120000069.chfilter,1,nil,tp)
end
function c120000069.actcon(e)
	local tp=e:GetHandlerPlayer()
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
	if res then
		return teg:IsExists(c120000069.chfilter,1,nil,tp)
	end
end