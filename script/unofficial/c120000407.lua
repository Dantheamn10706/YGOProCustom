--紋章獣ツインヘッド・イーグル
function c120000407.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000407,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c120000407.target)
	e1:SetOperation(c120000407.activate)
	c:RegisterEffect(e1)
end
function c120000407.filter1(c)
	return c:IsSetCard(0x92) and c:IsType(TYPE_XYZ) and c:GetOverlayCount()==0
end
function c120000407.filter2(c)
	return c:IsType(TYPE_MONSTER)
end
function c120000407.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c120000407.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c120000407.filter2,tp,LOCATION_GRAVE,0,2,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19310321,1))
	local g=Duel.SelectTarget(tp,c120000407.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c120000407.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19310321,2))
		local g=Duel.SelectMatchingCard(tp,c120000407.filter2,tp,LOCATION_GRAVE,0,2,2,e:GetHandler())
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end	
	end
end
