--Duel Field Generator
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableExtraRules(c,s,s.thop,s.init)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_FZONE,LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(Duel.GetTurnPlayer(),aux.Stringid(id,0)) then
	tp=Duel.GetTurnPlayer()
	else
	tp=Duel.GetTurnPlayer()+1
	end
	s.announce_filter={TYPE_FIELD,OPCODE_ISTYPE,OPCODE_ALLOW_ALIASES}
	local ac=Duel.AnnounceCard(Duel.GetTurnPlayer(),table.unpack(s.announce_filter))
	local token=Duel.CreateToken(Duel.GetTurnPlayer(),ac)
	Duel.MoveToField(token,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
end
function s.Target(e,c)
	return c:IsType(TYPE_FIELD)
end
function s.filter(e,re,tp)
	return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end