--轟雷機龍-サンダー・ドラゴン
--Thunder Dragon Thunderstormech
--Scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon procedure: 2+ Thunder monsters
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_THUNDER),2)
	--Apply 1 "Thunder Dragon" monster's effect that discards itself to activate, then place that monster on the top or bottom of your Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(function(e) return e:GetHandler():IsLinkSummoned() end)
	e1:SetTarget(s.applytg)
	e1:SetOperation(s.applyop)
	c:RegisterEffect(e1)
	--If a Thunder monster(s) you control would be destroyed by battle or card effect, you can banish 3 cards from your GY instead
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.reptg)
	e2:SetValue(function(e,c) return s.repfilter(c,e:GetHandlerPlayer()) end)
	c:RegisterEffect(e2)
end
s.listed_series={SET_THUNDER_DRAGON}
function s.runfn(fn,eff,tp,chk)
	return not fn or fn(eff,tp,Group.CreateGroup(),PLAYER_NONE,0,nil,REASON_EFFECT,PLAYER_NONE,chk)
end
function s.applyfilter(c,e,tp)
	if not (c:IsSetCard(SET_THUNDER_DRAGON) and c:IsMonster()
		and c:IsAbleToDeck() and c:IsFaceup()) then return false end
	for _,eff in ipairs({c:GetOwnEffects()}) do
		if eff:HasSelfDiscardCost() and s.runfn(eff:GetCondition(),eff,tp,0) and s.runfn(eff:GetTarget(),eff,tp,0) then return true end
	end
end
function s.applytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.applyfilter,tp,LOCATION_GRAVE|LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,s.applyfilter,tp,LOCATION_GRAVE|LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
	local effs={}
	local options={}
	for _,eff in ipairs({tc:GetOwnEffects()}) do
		if eff:HasSelfDiscardCost() then
			table.insert(effs,eff)
			local eff_chk=s.runfn(eff:GetCondition(),eff,tp,0) and s.runfn(eff:GetTarget(),eff,tp,0)
			table.insert(options,{eff_chk,eff:GetDescription()})
		end
	end
	local op=#options==1 and 1 or Duel.SelectEffect(tp,table.unpack(options))
	local te=effs[op]
	Duel.Hint(HINT_OPSELECTED,1-tp,te:GetDescription())
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	e:SetLabel(te:GetLabel())
	e:SetLabelObject(te:GetLabelObject())
	local targ_fn=te:GetTarget()
	if targ_fn then
		s.runfn(targ_fn,e,tp,1)
		te:SetLabel(e:GetLabel())
		te:SetLabelObject(e:GetLabelObject())
		Duel.ClearOperationInfo(0)
	end
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,tp,0)
end
function s.applyop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local tc=te:GetHandler()
	if not tc:IsRelateToEffect(e) then return end
	local op=te:GetOperation()
	if op then
		e:SetLabel(te:GetLabel())
		e:SetLabelObject(te:GetLabelObject())
		op(e,tp,eg,ep,ev,re,r,rp)
	end
	if tc:IsAbleToDeck() then
		local opt=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2)) or 0
		Duel.BreakEffect()
		Duel.SendtoDeck(tc,nil,opt,REASON_EFFECT)
	end
	e:SetLabel(0)
	e:SetLabelObject(nil)
end
function s.repfilter(c,tp)
	return c:IsRace(RACE_THUNDER) and c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
		and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_BATTLE|REASON_EFFECT)
end
function s.repcostfilter(c)
	return c:IsAbleToRemove() and aux.SpElimFilter(c,true)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp) and Duel.IsExistingMatchingCard(s.repcostfilter,tp,LOCATION_MZONE|LOCATION_GRAVE,0,3,nil) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,s.repcostfilter,tp,LOCATION_MZONE|LOCATION_GRAVE,0,3,3,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		return true
	else return false end
end
