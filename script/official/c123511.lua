--ワンダー・ワンド
--Wonder Wand
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0x55))
	--Pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--send to the gy and Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(s.drcost)
	e4:SetOperation(s.activate)
	c:RegisterEffect(e4)
	
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local ec=c:GetEquipTarget()
		local tc=e:GetHandler():GetEquipTarget()
		if chk==0 then return c:IsAbleToGraveAsCost() and ec and c:GetControler()==ec:GetControler()and tc and tc:GetAttack()>=2000
			and ec:IsAbleToGraveAsCost() end
		local g=Group.FromCards(c,ec)
		Duel.SendtoGrave(g,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		e:SetLabel(0)
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.filter2(e)
	local tc=e:GetHandler():GetEquipTarget()
	return tc and tc:GetAttack()>=2000
end
function s.filter(c,e,tp)
	return c:IsCode(93717133) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		if Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)>0 then
			g:GetFirst():CompleteProcedure()
		end
	else
		Duel.GoatConfirm(tp,LOCATION_HAND)
	end
end