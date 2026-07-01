--ディメンション・リフレクター
function c120000161.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c120000161.condition)
	e1:SetCost(c120000161.cost)
	e1:SetTarget(c120000161.target)
	e1:SetOperation(c120000161.activate)
	c:RegisterEffect(e1)
end
function c120000161.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return (a and a:IsControler(1-tp))
end
function c120000161.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemoveAsCost()
end	
function c120000161.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000161.costfilter,tp,LOCATION_ONFIELD,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c120000161.costfilter,tp,LOCATION_ONFIELD,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c120000161.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local at=Duel.GetAttacker()
	if chkc then return chkc==at end
	if chk==0 then return at:IsOnField() and at:IsCanBeEffectTarget() end
	Duel.SetTargetCard(at)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c120000161.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	local atk=tc:GetAttack()
	local def=tc:GetDefense()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,120000148,0,0x21,atk,def,4,RACE_SPELLCASTER,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT)
	if Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP_ATTACK) then
		c:AddMonsterAttributeComplete()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		e2:SetValue(def)
		c:RegisterEffect(e2)
		--damage
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(54297661,0))
		e3:SetCategory(CATEGORY_DAMAGE)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetTarget(c120000161.damtg)
		e3:SetOperation(c120000161.damop)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e3,true)
	end
	Duel.SpecialSummonComplete()
end
function c120000161.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetHandler():GetAttack()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c120000161.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,e:GetHandler():GetAttack(),REASON_EFFECT)
end	
