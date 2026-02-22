--山
function c316000207.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1,316000206)
	e1:SetRange(0x5f)
	e1:SetCondition(c316000206.con)
	e1:SetOperation(c316000206.op)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DRAGON+RACE_WINDBEAST+RACE_THUNDER))
	e2:SetValue(c316000207.val1)
	c:RegisterEffect(e2)
	--Def
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENCE)
	e3:SetValue(c316000207.val2)
	c:RegisterEffect(e3)
	--forbidden
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_SSET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(1,0)
	e4:SetTarget(c316000207.setlimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(1,0)
	e5:SetValue(c316000207.actlimit)
	c:RegisterEffect(e5)
end
function c316000207.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(LOCATION_SZONE,0,5)
	if tc and tc:IsFaceup() then return false end
	tc=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return not tc and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_SZONE,0,1,nil,50913601) and Duel.GetTurnCount()==1
end
function c316000207.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not Duel.SelectYesNo(1-tp,aux.Stringid(316000207,0)) or not Duel.SelectYesNo(tp,aux.Stringid(316000207,0)) then
        local sg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_SZONE,0,nil,50913601)
        Duel.SendtoDeck(sg,nil,-2,REASON_RULE)
        return
    end	
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_SZONE,0,1,nil,50913601) then
		Duel.DisableShuffleCheck()
		Duel.SendtoDeck(c,nil,-2,REASON_RULE)
	else
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	if c:GetPreviousLocation()==LOCATION_HAND then
		Duel.Draw(tp,1,REASON_RULE)
	end
end
function c316000207.val1(e,c)
	return c:GetAttack()*3/10
end
function c316000207.val2(e,c)
	return c:GetDefence()*3/10
end
function c316000207.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function c316000207.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
