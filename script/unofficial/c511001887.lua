--光のピラミッド
function c511001887.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Banish
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c511001887.banop)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(c511001887.leave)
	c:RegisterEffect(e3)
end
function c511001887.filter(c)
	return c:IsFaceup() and (c:IsAttribute(ATTRIBUTE_DIVINE) or c:IsRace(RACE_DIVINE) or c:IsRace(RACE_CREATORGOD) 
		or (c:GetOriginalRace()&RACE_DIVINE)==RACE_DIVINE or (c:GetOriginalRace()&RACE_CREATORGOD)==RACE_CREATORGOD 
		or (c:GetOriginalAttribute()&ATTRIBUTE_DIVINE)==ATTRIBUTE_DIVINE) and c:IsAbleToRemove()
end
function c511001887.filter2(c)
	return c:IsFacedown() and (c:IsAttribute(ATTRIBUTE_DIVINE) or c:IsRace(RACE_DIVINE) or c:IsRace(RACE_CREATORGOD) 
		or (c:GetOriginalRace()&RACE_DIVINE)==RACE_DIVINE or (c:GetOriginalRace()&RACE_CREATORGOD)==RACE_CREATORGOD 
		or (c:GetOriginalAttribute()&ATTRIBUTE_DIVINE)==ATTRIBUTE_DIVINE) and c:IsAbleToRemove()
end
function c511001887.banop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511001887.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local conf=Duel.GetMatchingGroup(c511001887.filter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #conf>0 then
		Duel.ConfirmCards(tp,conf)
		Duel.Remove(conf,POS_FACEUP,REASON_EFFECT)
	end
end
function c511001887.defilter(c)
	local code=c:GetCode()
	return c:IsFaceup() and (code==78800047 or code==78800046 or code==51402177 or code==15013468) and c:IsDestructable()
end
function c511001887.leave(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetPreviousControler()==tp and c:IsStatus(STATUS_ACTIVATED) then
		local g=Duel.GetMatchingGroup(c511001887.defilter,tp,LOCATION_ONFIELD,0,nil)
		Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)
	end
end