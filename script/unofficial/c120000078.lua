--光波クローンマジック
function c120000078.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000078,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetTarget(c120000078.tgvtg)
	e1:SetOperation(c120000078.tgvop)
	c:RegisterEffect(e1)
end
function c120000078.ffilter(c,e,tp)
	return c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsAbleToGrave() and c:CheckActivateEffect(false,false,false)~=nil
end
function c120000078.tgvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local tc=e:GetLabelObject()
		local tg=tc:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c120000078.ffilter,tp,LOCATION_DECK,0,1,nil) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c120000078.ffilter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local th=g:GetFirst()
	local ac=th:GetActivateEffect()
	local effs={Duel.GetPlayerEffect(tp,EFFECT_CANNOT_ACTIVATE)}
	for _,eff in ipairs(effs) do
		if type(eff:GetValue())=='function' then
			if eff:GetValue()(eff,ac,tp) then return false end
		end	
	end	
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
end
function c120000078.tgvop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
	