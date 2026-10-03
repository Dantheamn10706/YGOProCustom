--ジャイアント・ボマー・エアレイド
function c120000132.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--Summon destroy & damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000132,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c120000132.damcon)
	e2:SetTarget(c120000132.damtg)
	e2:SetOperation(c120000132.damop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--destroy & damage set and activate Spell/trap
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(120000132,0))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_QUICK_F)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c120000132.damcon1)
	e5:SetTarget(c120000132.damtg1)
	e5:SetOperation(c120000132.damop1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(120000132,0))
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_MSET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c120000132.damcon2)
	e6:SetTarget(c120000132.damtg2)
	e6:SetOperation(c120000132.damop2)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SSET)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(120000132,0))
	e8:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_CHANGE_POS)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCondition(c120000132.damcon3)
	e8:SetTarget(c120000132.damtg3)
	e8:SetOperation(c120000132.damop3)
	c:RegisterEffect(e8)
	--destroy
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(120000132,0))
	e9:SetCategory(CATEGORY_DESTROY)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCost(c120000132.descost)
	e9:SetTarget(c120000132.destg)
	e9:SetOperation(c120000132.desop)
	c:RegisterEffect(e9)
end
function c120000132.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetFlagEffect(tp,120000132)==0
end
function c120000132.dfilter(c,e,sp)
	return c:GetSummonPlayer()==sp and (not e or c:IsRelateToEffect(e))
end
function c120000132.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c120000132.dfilter,1,nil,nil,1-tp) end
	local g=eg:Filter(c120000132.dfilter,nil,nil,1-tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c120000132.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c120000132.dfilter,nil,e,1-tp)
	if e:GetHandler():IsRelateToEffect(e) and g:GetCount()~=0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,800,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,120000132,RESET_PHASE+PHASE_END,0,1)
	end
end
function c120000132.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetFlagEffect(tp,120000132)==0
end
function c120000132.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c120000132.damop1(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,800,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,120000132,RESET_PHASE+PHASE_END,0,1)
	end
end
function c120000132.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and rp~=tp and Duel.GetFlagEffect(tp,120000132)==0
end
function c120000132.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c120000132.damop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,800,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,120000132,RESET_PHASE+PHASE_END,0,1)
	end
end
function c120000132.damcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and rp~=tp and Duel.GetFlagEffect(tp,120000132)==0
end
function c120000132.sfilter(c,e)
	return c:IsFacedown() and (not e or c:IsRelateToEffect(e))
end
function c120000132.damtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c120000132.sfilter,1,nil) end
	local g=eg:Filter(c120000132.sfilter,nil)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c120000132.damop3(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c120000132.sfilter,nil,e)
	if e:GetHandler():IsRelateToEffect(e) and g:GetCount()~=0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,800,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,120000132,RESET_PHASE+PHASE_END,0,1)
	end
end
function c120000132.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c120000132.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c120000132.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,0,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
