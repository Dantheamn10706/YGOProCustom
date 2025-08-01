--Royal Temple of the Kings
--Scripted by The Razgriz
local s,id=GetID()
function s.initial_effect(c)
	aux.AddFieldSkillProcedure(c,2,false)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--"Royal Temple of the Kings" is unaffected by your opponent's card effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_FZONE,LOCATION_FZONE)
	e1:SetTarget(function(e,c) return c:IsFaceup() and c:IsCode(id) end)
	e1:SetValue(function(e,re) return e:GetOwnerPlayer()~=re:GetOwnerPlayer() end)
	c:RegisterEffect(e1)
	--"Mystical Beast of Serket" cannot be destroyed by its own effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,89194033))
	e2:SetValue(function(e,re) return re and re:GetOwner():IsCode(89194033) end)
	c:RegisterEffect(e2)
	--Pay 500 LP to activate a Continuous Trap that Special Summons itself the turn it was Set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(function(e) return aux.CanActivateSkill(e:GetHandlerPlayer()) end)
	e3:SetCost(Cost.PayLP(500))
	e3:SetOperation(s.ctop)
	c:RegisterEffect(e3)
end
s.listed_names={id,89194033} --"Royal Temple of the Kings","Mystical Beast of Serket"
function s.ctop(e,tp,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local c=e:GetHandler()
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e4:SetTargetRange(LOCATION_SZONE,0)
	e4:SetCountLimit(1,id)
	e4:SetTarget(aux.TargetBoolFunction(aux.AND(Card.IsTrapMonster,Card.IsContinuousTrap)))
	e4:SetReset(RESET_PHASE|PHASE_END)
	c:RegisterEffect(e4)
end