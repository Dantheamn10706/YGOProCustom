--ガードペナルティ
function c120000360.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c120000360.target)
	e1:SetOperation(c120000360.activate)
	c:RegisterEffect(e1)
end
function c120000360.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c120000360.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000360.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,0)
end
function c120000360.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,c120000360.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local rfid=tc:GetRealFieldID()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EVENT_CHANGE_POS)
		e1:SetLabel(rfid)
		e1:SetCondition(c120000360.drcon)
		e1:SetOperation(c120000360.drop)
		tc:RegisterEffect(e1,true)
	end
end
function c120000360.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsDefensePos() and c:IsPreviousPosition(POS_ATTACK) and c:GetRealFieldID()==e:GetLabel()
end
function c120000360.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end	