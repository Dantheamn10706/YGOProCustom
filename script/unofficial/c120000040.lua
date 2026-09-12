--ドロー・マッスル
function c120000040.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DEFCHANGE)
	e1:SetDescription(aux.Stringid(120000040,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c120000040.condition)
	e1:SetTarget(c120000040.target)
	e1:SetOperation(c120000040.activate)
	c:RegisterEffect(e1)
end
function c120000040.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsPosition(POS_FACEUP_DEFENSE) and c:IsDefenseBelow(1000)
end
function c120000040.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c120000040.filter,tp,LOCATION_ONFIELD,0,nil)==1
end
function c120000040.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c120000040.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingTarget(c120000040.filter,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUPDEFENSE)
	Duel.SelectTarget(tp,c120000040.filter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c120000040.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.GetDecktopGroup(p,1)
	local td=g:GetFirst()
	local tc=Duel.GetFirstTarget()
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-p,td)
		if td and td:IsType(TYPE_MONSTER) and tc:IsRelateToEffect(e) then
			--gain def
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetValue(td:GetDefense())
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			--battle indestructable
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
		else 
			Duel.Destroy(tc,REASON_EFFECT)
		end	
		Duel.ShuffleHand(p)
	end
end
