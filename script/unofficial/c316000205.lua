--海洋
function c316000205.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1,316000205)
	e1:SetRange(0x5f)
	e1:SetCondition(c316000205.con)
	e1:SetOperation(c316000205.op)
	c:RegisterEffect(e1)
	--Hidden monsters
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(POS_FACEDOWN,0)
	e2:SetCondition(c316000205.ttcon)
	e2:SetTarget(c316000205.tttg)
	e2:SetOperation(c316000205.ttop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FISH+RACE_SEASERPENT+RACE_THUNDER+RACE_AQUA))
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTarget(c316000205.settg)
	e4:SetOperation(c316000205.setop)
	c:RegisterEffect(e4)
	--Atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_ONFIELD,0)
	e5:SetValue(c316000205.val1)
	c:RegisterEffect(e5)
	--Def
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENCE)
	e6:SetValue(c316000205.val2)
	c:RegisterEffect(e6)
	--forbidden
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EFFECT_CANNOT_SSET)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTargetRange(1,0)
	e7:SetTarget(c316000205.setlimit)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e8:SetCode(EFFECT_CANNOT_ACTIVATE)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTargetRange(1,0)
	e8:SetValue(c316000205.actlimit)
	c:RegisterEffect(e8)
end
function c316000205.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(LOCATION_SZONE,0,5)
	if tc and tc:IsFaceup() then return false end
	tc=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return not tc and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_SZONE,0,1,nil,22702055) and Duel.GetTurnCount()==1
end
function c316000205.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if not Duel.SelectYesNo(1-tp,aux.Stringid(316000205,0)) or not Duel.SelectYesNo(tp,aux.Stringid(316000205,0)) then
        local sg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_SZONE,0,nil,22702055)
        Duel.SendtoDeck(sg,nil,-2,REASON_RULE)
        return
    end	
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_SZONE,0,1,nil,22702055) then
		Duel.DisableShuffleCheck()
		Duel.SendtoDeck(c,nil,-2,REASON_RULE)
	else
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	if c:GetPreviousLocation()==LOCATION_HAND then
		Duel.Draw(tp,1,REASON_RULE)
	end
end
function c316000205.ttcon(e,c)
	if c==nil then return true end
	min,max=c:GetTributeRequirement()
	return Duel.CheckTribute(c,min,max)
end
function c316000205.tttg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local c=e:GetHandler()
	min,max=c:GetTributeRequirement()
	local g=Duel.SelectTribute(tp,c,min,max,nil,nil,nil,true)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function c316000205.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	g:DeleteGroup()
end

function c316000205.setfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet() and (c:IsRace(RACE_FISH) or c:IsRace(RACE_SEASERPENT) or c:IsRace(RACE_THUNDER) or c:IsRace(RACE_AQUA))
end
function c316000205.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c316000205.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c316000205.setfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c316000205.setfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c316000205.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_ATTACK)
	end
end
function c316000205.val1(e,c)
	local r=c:GetRace()
	if bit.band(r,RACE_FISH+RACE_SEASERPENT+RACE_THUNDER+RACE_AQUA)>0 then return c:GetAttack()*3/10
	elseif bit.band(r,RACE_MACHINE+RACE_PYRO)>0 then return -c:GetAttack()*3/10
	else return 0 end
end
function c316000205.val2(e,c)
	local r=c:GetRace()
	if bit.band(r,RACE_FISH+RACE_SEASERPENT+RACE_THUNDER+RACE_AQUA)>0 then return c:GetDefence()*3/10
	elseif bit.band(r,RACE_MACHINE+RACE_PYRO)>0 then return -c:GetDefence()*3/10
	else return 0 end
end
function c316000205.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function c316000205.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end