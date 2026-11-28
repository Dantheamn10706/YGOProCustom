--亜空間バトル
function c511000496.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000496.target)
	e1:SetOperation(c511000496.operation)
	c:RegisterEffect(e1)
	--use effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5012,4))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DAMAGE+CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e2:SetCountLimit(1)
	e2:SetLabel(3)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c511000496.target2)
	e2:SetOperation(c511000496.operation2)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
end
function c511000496.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetLabelObject():SetLabel(0)
end
function c511000496.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetLabelObject():SetLabel(0)
	end
end
function c511000496.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsAbleToGrave()
end
function c511000496.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511000496.filter,tp,LOCATION_DECK,0,3,nil) and Duel.IsExistingMatchingCard(c511000496.filter,tp,0,LOCATION_DECK,3,nil) end
end
function c511000496.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c511000496.filter,tp,LOCATION_DECK,0,3,nil) or not Duel.IsExistingMatchingCard(c511000496.filter,tp,0,LOCATION_DECK,3,nil) 
	or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(511000496,1))
	local g1=Duel.SelectMatchingCard(tp,c511000496.filter,tp,LOCATION_DECK,0,3,3,nil)
	if g1:GetCount()<3 then return end
	local g2=Duel.SelectMatchingCard(1-tp,c511000496.filter,tp,0,LOCATION_DECK,3,3,nil)
	if g2:GetCount()<3 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(511000496,2))
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(511000496,2))
	local sg2=g2:Select(1-tp,1,1,nil)
	Duel.ConfirmCards(1-tp,sg1)
	Duel.ConfirmCards(tp,sg2)
	Duel.BreakEffect()
	if sg1:GetFirst():GetTextAttack()>sg2:GetFirst():GetTextAttack() then
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Damage(1-tp,500,REASON_EFFECT)
		Duel.SendtoGrave(sg2,REASON_EFFECT)
	elseif sg2:GetFirst():GetTextAttack()>sg1:GetFirst():GetTextAttack() then
		Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Damage(tp,500,REASON_EFFECT)
		Duel.SendtoGrave(sg1,REASON_EFFECT)
	elseif sg2:GetFirst():GetTextAttack()==sg1:GetFirst():GetTextAttack() then
		Duel.SendtoGrave(sg2,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SendtoGrave(sg1,REASON_EFFECT)
	end
	g1:Sub(sg1)
	g2:Sub(sg2)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(511000496,2))
	sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(511000496,2))
	sg2=g2:Select(1-tp,1,1,nil)
	Duel.ConfirmCards(1-tp,sg1)
	Duel.ConfirmCards(tp,sg2)
	Duel.BreakEffect()
	if sg1:GetFirst():GetTextAttack()>sg2:GetFirst():GetTextAttack() then
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Damage(1-tp,500,REASON_EFFECT)
		Duel.SendtoGrave(sg2,REASON_EFFECT)
	elseif sg2:GetFirst():GetTextAttack()>sg1:GetFirst():GetTextAttack() then
		Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Damage(tp,500,REASON_EFFECT)
		Duel.SendtoGrave(sg1,REASON_EFFECT)
	elseif sg2:GetFirst():GetTextAttack()==sg1:GetFirst():GetTextAttack() then
		Duel.SendtoGrave(sg2,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SendtoGrave(sg1,REASON_EFFECT)	
	end
	g1:Sub(sg1)
	g2:Sub(sg2)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(511000496,2))
	sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(511000496,2))
	sg2=g2:Select(1-tp,1,1,nil)
	Duel.ConfirmCards(1-tp,sg1)
	Duel.ConfirmCards(tp,sg2)
	Duel.BreakEffect()
	if sg1:GetFirst():GetTextAttack()>sg2:GetFirst():GetTextAttack() then
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Damage(1-tp,500,REASON_EFFECT)
		Duel.SendtoGrave(sg2,REASON_EFFECT)
	elseif sg2:GetFirst():GetTextAttack()>sg1:GetFirst():GetTextAttack() then
		Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Damage(tp,500,REASON_EFFECT)
		Duel.SendtoGrave(sg1,REASON_EFFECT)
	elseif sg2:GetFirst():GetTextAttack()==sg1:GetFirst():GetTextAttack() then
		Duel.SendtoGrave(sg2,nil,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SendtoGrave(sg1,REASON_EFFECT)	
	end
	local ct=e:GetLabel()
		ct=ct+1
		e:SetLabel(ct)
		if ct==3 then Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
