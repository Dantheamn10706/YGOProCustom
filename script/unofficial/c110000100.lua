--オレイカルコス・デウテロス
function c110000100.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c110000100.actcon)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(110000100,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)	
	e2:SetTarget(c110000100.target)
	e2:SetOperation(c110000100.operation)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetDescription(aux.Stringid(110000100,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c110000100.atkcon)
	e3:SetCost(c110000100.atkcost)
	e3:SetTarget(c110000100.atktg)
	e3:SetOperation(c110000100.atkop)
	c:RegisterEffect(e3)
	--Selfdes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c110000100.sdcon2)
	e4:SetOperation(c110000100.sdop)
	c:RegisterEffect(e4)
	--add code
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_ADD_CODE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetValue(48179391)
	c:RegisterEffect(e5)
end
function c110000100.sdcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(110000100)==0
end
function c110000100.sdop(e,tp,eg,ep,ev,re,r,rp)	
	e:GetHandler():CopyEffect(511000256,RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterFlagEffect(110000100,RESET_EVENT+0x1fe0000,0,1)
end
function c110000100.actcon(e)
	local tc=Duel.GetFieldCard(e:GetHandler():GetControler(),LOCATION_SZONE,5)	
	return tc~=nil and tc:IsFaceup() and tc:IsCode(48179391)
end
function c110000100.filter(c)
	return c:IsCode(48179391)
end
function c110000100.cfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c110000100.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c110000100.cfilter,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return ct>0 end
	Duel.SetTargetPlayer(tp)
	local rec=ct*500
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c110000100.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c110000100.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local rec=ct*500
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,rec,REASON_EFFECT)
end
function c110000100.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c110000100.refilter(c)
	return c:IsType(TYPE_MONSTER) or c:GetFlagEffect(511000256)>0 or c:GetFlagEffect(511000257)>0
end
function c110000100.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c110000100.refilter,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c110000100.refilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
end
function c110000100.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=Duel.GetAttacker()
	if chkc then return chkc==tg end
	if chk==0 then return Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and tg:IsOnField() and tg:IsDestructable() and tg:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
end
function c110000100.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToEffect(e) and tc:CanAttack() and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end