--エンシェント・シャーク ハイパー・メガロドン
function c120000154.initial_effect(c)
	--normal summon with 1 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000154,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c120000154.otcon)
	e1:SetOperation(c120000154.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(120000154,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c120000154.condition)
	e3:SetTarget(c120000154.target)
	e3:SetOperation(c120000154.operation)
	c:RegisterEffect(e3)
end
function c120000154.otfilter(c,tp)
	return (c:IsControler(tp) or c:IsFaceup()) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c120000154.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c120000154.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	return c:GetLevel()>6 and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c120000154.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c120000154.otfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c120000154.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c120000154.filter(c,dam)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAttackBelow(dam) 
end
function c120000154.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dam=Duel.GetBattleDamage(1-tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000154.filter,tp,0,LOCATION_ONFIELD,1,nil,dam) end
	local g=Duel.GetMatchingGroup(c120000154.filter,tp,0,LOCATION_ONFIELD,nil,dam)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c120000154.operation(e,tp,eg,ep,ev,re,r,rp)
	local dam=Duel.GetBattleDamage(1-tp)
	local g=Duel.GetMatchingGroup(c120000154.filter,tp,0,LOCATION_ONFIELD,nil,dam)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end