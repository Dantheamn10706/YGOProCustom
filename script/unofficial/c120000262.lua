--アルケミー・サイクル
function c120000262.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetCondition(c120000262.condition)
	e1:SetTarget(c120000262.target)
	e1:SetOperation(c120000262.activate)
	c:RegisterEffect(e1)
end
function c120000262.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if not at or tc:IsFacedown() or at:IsFacedown() then return false end
	if tc:IsControler(1-tp) then tc=at end
	e:SetLabelObject(tc)
	return tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE) and tc:GetAttack()>0
end
function c120000262.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c120000262.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsRelateToBattle() and tc:IsFaceup() then
		--atk
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		--indes
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		--draw
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_BATTLED)
		e3:SetCondition(c120000262.con)
		e3:SetTarget(c120000262.tg)
		e3:SetOperation(c120000262.op)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3) 
	end
end
function c120000262.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsStatus(STATUS_OPPO_BATTLE) and not c:IsStatus(STATUS_BATTLE_DESTROYED) 
end
function c120000262.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c120000262.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	Duel.Draw(p,d,REASON_EFFECT)
end
