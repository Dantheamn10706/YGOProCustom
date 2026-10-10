--ミラージュ・マジック
function c511009201.initial_effect(c)
	--reverse change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511009201,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(511009201)
	e1:SetCondition(c511009201.condition)
	e1:SetOperation(c511009201.operation)
	c:RegisterEffect(e1)
	if not c511009201.global_check then
		c511009201.global_check=true
		--register
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(c511009201.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c511009201.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local g=Duel.GetMatchingGroup(nil,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:GetFlagEffect(511009201)==0 then
			local e1=Effect.CreateEffect(c)	
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e1:SetCode(EVENT_CHAIN_SOLVED)
			e1:SetRange(LOCATION_MZONE)
			e1:SetLabel(tc:GetAttack())
			e1:SetOperation(c511009201.op)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(511009201,RESET_EVENT+0x1fe0000,0,1) 	
		end	
		tc=g:GetNext()
	end		
end
function c511009201.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==c:GetAttack() then return end
	local val=0
	if e:GetLabel()>c:GetAttack() then
		val=e:GetLabel()-c:GetAttack()
	else
		val=c:GetAttack()-e:GetLabel()
	end
	Duel.RaiseEvent(c,511009201,re,REASON_EFFECT,rp,tp,val)
	e:SetLabel(c:GetAttack())
end
function c511009201.condition(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	e:SetLabel(ev)
	return rp~=tp and ec:IsControler(tp) and ev>0
end
function c511009201.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc and tc:IsFaceup() and tc:GetAttack()~=tc:GetBaseAttack() or tc:GetDefense()~=tc:GetBaseDefense() then
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local batk=tc:GetBaseAttack()
		local badf=tc:GetBaseDefense()
		if batk~=atk or badf~=def then
			local dif1=(batk>atk) and (batk-atk) or (atk-batk)
			local dif2=(badf>def) and (badf-def) or (def-badf)
			local dif=dif1+dif2
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(batk)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(badf)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			local rec=Duel.Recover(tp,dif,REASON_EFFECT)
		end
			tc=eg:GetNext()
	end
end
