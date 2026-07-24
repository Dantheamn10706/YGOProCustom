--Guardian Eatos (Anime)
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetCondition(s.sumlimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(s.spcon)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id)
	e5:SetCost(s.rmcost)
	e5:SetTarget(s.rmtg)
	e5:SetOperation(s.rmop)
	c:RegisterEffect(e5)
end
s.listed_names={55569674}
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(55569674)
end
function s.sumlimit(e)
	return not Duel.IsExistingMatchingCard(s.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and not Duel.IsExistingMatchingCard(Card.IsMonster,tp,LOCATION_GRAVE,0,1,nil)
end
function s.swordfilter(c)
	return c:IsFaceup() and c:IsCode(55569674) and c:IsDestructable()
end
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetHandler():GetEquipGroup():Filter(s.swordfilter,nil)
	if chk==0 then return #g>0 end
	e:SetLabelObject(g:GetFirst())
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabelObject()~=nil end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Group.FromCards(e:GetLabelObject()),1,0,0)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local eq=e:GetLabelObject()
	if not eq or not eq:IsRelateToEffect(e) then return end
	if Duel.Destroy(eq,REASON_EFFECT)==0 then return end
	local c=e:GetHandler()
	local total_atk=0
	while true do
		local gy=Duel.GetFieldGroup(1-tp,LOCATION_GRAVE,0)
		if #gy==0 then break end
		local top=gy:GetFirst()
		for tc in aux.Next(gy) do
			if tc:GetSequence()>top:GetSequence() then top=tc end
		end
		if not top:IsMonster() then break end
		if not top:IsAbleToRemove() then break end
		local atk=math.max(top:GetAttack(),0)
		if Duel.Remove(Group.FromCards(top),POS_FACEUP,REASON_EFFECT)==0 then break end
		total_atk=total_atk+atk
	end
	if total_atk>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(total_atk)
		e1:SetReset(RESETS_STANDARD_DISABLE_PHASE_END)
		c:RegisterEffect(e1)
	end
end
