--地獄詩人ヘルポエマー(Manga)
function c511015127.initial_effect(c)
	--tograve replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetCondition(c511015127.repcon)
	e1:SetTarget(c511015127.reptg)
	e1:SetOperation(c511015127.repop)
	c:RegisterEffect(e1)
	--handes
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76052811,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetCondition(c511015127.hdcon)
	e2:SetTarget(c511015127.hdtg)
	e2:SetOperation(c511015127.hdop)
	c:RegisterEffect(e2)
end
function c511015127.repcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsType(TYPE_MONSTER) and c:GetDestination()==LOCATION_GRAVE and c:GetOwner()==tp and c:IsReason(REASON_DESTROY)
end
function c511015127.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE) end
	return true
end
function c511015127.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT+REASON_REPLACE,1-tp)
	e:GetHandler():RegisterFlagEffect(76052811,RESET_EVENT+0x1fe0000,0,0)
end
function c511015127.hdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsType(TYPE_MONSTER) and Duel.GetTurnPlayer()==tp and c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c:GetOwner()==1-tp and c:GetFlagEffect(76052811)~=0
end
function c511015127.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():ResetFlagEffect(76052811)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function c511015127.hdop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():RegisterFlagEffect(76052811,RESET_EVENT+0x1fe0000,0,0)
		local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		if g:GetCount()==0 then return end
		local sg=g:RandomSelect(tp,1)
		Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
	end
end
