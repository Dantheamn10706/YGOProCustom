--ヒロイック・リベンジ・ソード
function c120000144.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000144,0))
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c120000144.condition)
	e1:SetTarget(c120000144.target)
	e1:SetOperation(c120000144.operation)
	c:RegisterEffect(e1)
end
function c120000144.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	return tc:GetPreviousControler()==tp and tc:IsSetCard(0x6f) and tc:IsReason(REASON_BATTLE) 
end
function c120000144.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsSetCard(0x6f)
end
function c120000144.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c120000144.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c120000144.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c120000144.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=eg:GetFirst():GetReasonCard()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		c:SetCardTarget(tg)
		--Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(1)
		c:RegisterEffect(e1)
		--destroy
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(120000144,1))
		e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e2:SetCode(EVENT_BATTLE_START)
		e2:SetRange(LOCATION_SZONE)
		e2:SetLabelObject(tg)
		e2:SetCondition(c120000144.descon)
		e2:SetTarget(c120000144.destg)
		e2:SetOperation(c120000144.desop)
		c:RegisterEffect(e2)
		--self destroy
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetRange(LOCATION_SZONE)
		e3:SetCode(EVENT_LEAVE_FIELD)
		e3:SetLabelObject(tg)
		e3:SetCondition(c120000144.descon2)
		e3:SetOperation(c120000144.desop2)
		c:RegisterEffect(e3)
	end
end	
function c120000144.descon(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	if ec~=Duel.GetAttacker() and ec~=Duel.GetAttackTarget() then return false end
	local tc=ec:GetBattleTarget()
	local dt=e:GetLabelObject()
	return tc and tc:IsFaceup() and tc==dt
end
function c120000144.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetLabelObject(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabelObject():GetAttack())
end
function c120000144.desop(e,tp,eg,ep,ev,re,r,rp)
	local dt=e:GetLabelObject()
	if dt:IsRelateToBattle() and Duel.Destroy(dt,REASON_EFFECT)~=0 then
		Duel.Damage(1-tp,dt:GetAttack(),REASON_EFFECT)
	end
end
function c120000144.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc and eg:IsContains(tc)
end
function c120000144.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
