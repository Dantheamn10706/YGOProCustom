--シャーク・フォートレス
function c120000246.initial_effect(c)
	---xyz summon
	Xyz.AddProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000246,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c120000246.xyzcon)
	e1:SetOperation(c120000246.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--Atk Limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetTarget(c120000246.atlimit)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Add Attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(120000246,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c120000246.atkcon)
	e3:SetCost(c120000246.atkcost)
	e3:SetTarget(c120000246.atktg)
	e3:SetOperation(c120000246.atkop)
	c:RegisterEffect(e3)
end
function c120000246.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c120000246.xyzfilter(c)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()==5 
end
function c120000246.xyzcon(e,c,minxyzct)
	if c==nil then return true end
	local g=Duel.GetMatchingGroup(c120000246.xyzfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)
	local ct=c.minxyzct
	return g:IsExists(c120000246.xyzfilter,ct-1,nil,g,c) and Duel.IsExistingMatchingCard(c120000246.cfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function c120000246.xyzop(e,tp,eg,ep,ev,re,r,rp,c,minxyzct)
	local g=Duel.GetMatchingGroup(c120000246.xyzfilter,tp,LOCATION_ONFIELD,0,nil)
	local ct=c.minxyzct
	if g:IsExists(c120000246.xyzfilter,ct-1,nil,g,c) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=g:FilterSelect(tp,c120000246.xyzfilter,ct-1,ct-1,nil,c)
	e:GetHandler():SetMaterial(g1)
	Duel.Overlay(e:GetHandler(),g1)
	Duel.RegisterFlagEffect(tp,120000246,RESET_CHAIN,0,0)
	end
end
function c120000246.atlimit(e,c)
	return c~=e:GetHandler()
end
function c120000246.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and ph>=0x08 and ph<=0x20 and (ph~=PHASE_DAMAGE or not Duel.IsDamageCalculated()) 
	and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c120000246.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
c120000246.collection={
	[13429800]=true;[34290067]=true;[10532969]=true;[71923655]=true;[32393580]=true;
	[810000016]=true;[20358953]=true;[37798171]=true;[70101178]=true;[23536866]=true;
	[7500772]=true;[511001410]=true;[69155991]=true;[37792478]=true;[17201174]=true;
	[44223284]=true;[70655556]=true;[63193879]=true;[25484449]=true;[810000026]=true;
	[17643265]=true;[64319467]=true;[810000030]=true;[810000008]=true;[20838380]=true;
	[87047161]=true;[80727036]=true;[28593363]=true;[50449881]=true;[49221191]=true;
	[65676461]=true;[440556]=true;[511001273]=true;[31320433]=true;[5014629]=true;
	[14306092]=true;[84224627]=true;[511001163]=true;[511001169]=true;[511001858]=true;
}
function c120000246.filter(c)
	return c:IsFaceup() and c:GetAttackAnnouncedCount()>0 and c120000246.collection[c:GetCode()] and c:GetFlagEffect(120000246)==0
end
function c120000246.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and c120000246.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c120000246.filter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c120000246.filter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
end
function c120000246.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		tc:RegisterFlagEffect(120000246,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
