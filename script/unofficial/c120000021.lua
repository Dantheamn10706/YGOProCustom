--魔法効果の矢
function c120000021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000021,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c120000021.condition)
	e1:SetTarget(c120000021.target)
	e1:SetOperation(c120000021.activate)
	c:RegisterEffect(e1)
	--Reflect spell
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000021,0))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c120000021.chcon)
	e2:SetOperation(c120000021.chop)
	c:RegisterEffect(e2)
	--Change the effect target of an Spell Card
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetDescription(aux.Stringid(120000021,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c120000021.efcon)
	e3:SetTarget(c120000021.eftg)
	e3:SetOperation(c120000021.efop)
	c:RegisterEffect(e3)
	--Reflect Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(120000021,0))
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c120000021.sumcon)
	e4:SetOperation(c120000021.sumop)
	c:RegisterEffect(e4)
	--Switch announce
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(120000021,0))
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCondition(c120000021.swcon)
	e5:SetOperation(c120000021.swop)
	c:RegisterEffect(e5)
end
-----Change the effect flag player---------------------------
function c120000021.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and re:IsHasProperty(EFFECT_FLAG_PLAYER_TARGET)
end
function c120000021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local te=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
		local ftg=te:GetTarget()
		return ftg==nil or ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c120000021.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(ev,CHAININFO_TARGET_PLAYER)
	local select=Duel.SelectOption(tp,aux.Stringid(120000021,1),aux.Stringid(120000021,2))
	if select==0 then
		Duel.ChangeTargetPlayer(ev,p)
	else
		Duel.ChangeTargetPlayer(ev,1-p)
	end	
end
-----Reflect spell-----------------------------------------
function c120000021.chcon(e,tp,eg,ep,ev,re,r,rp)
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_ANNOUNCE)
	if ex or re:IsHasProperty(EFFECT_FLAG_PLAYER_TARGET) or re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or re:IsHasCategory(CATEGORY_SUMMON) 
	or re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) then return false end 
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)  
end
function c120000021.chop(e,tp,eg,ep,ev,re,r,rp)
	local op=re:GetOperation()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local p=Duel.GetChainInfo(ev,CHAININFO_TARGET_PLAYER)
	local select=Duel.SelectOption(tp,aux.Stringid(120000021,1),aux.Stringid(120000021,2))
	if not op then return false end
	if select==0 then 	
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeTargetPlayer(ev,1-p)
		Duel.ChangeChainOperation(ev,c120000021.repop1(tp,op))
	else
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeTargetPlayer(ev,p)
		Duel.ChangeChainOperation(ev,c120000021.repop2(tp,op))
	end	
end
function c120000021.repop1(tp,op)
	return function(e,tp,eg,ep,ev,re,r,rp)
		op(e,tp,eg,ep,ev,re,r,rp)
	end
end
function c120000021.repop2(tp,op)
	return function(e,tp,eg,ep,ev,re,r,rp)
		op(e,1-tp,eg,ep,ev,re,r,rp)
	end
end
-----Change the effect target---------------------------
function c120000021.efcon(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasCategory(CATEGORY_SUMMON) or re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)  
	or not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_SPELL) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end	
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g then return false end
	local tc=g:GetFirst()
	return tc:IsLocation(LOCATION_ONFIELD)
end
function c120000021.tcfilter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c120000021.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and tf(re,rp,ceg,cep,cev,cre,cr,crp,0,chkc) end
	if chk==0 then return Duel.IsExistingTarget(c120000021.tcfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c120000021.tcfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp)
end
function c120000021.efop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetFirst():IsRelateToEffect(e) then
		Duel.ChangeTargetCard(ev,g)
	end
end
------Reflect Summon-----------------------------------
function c120000021.sumcon(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsHasCategory(CATEGORY_SUMMON) or re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)) then return false end
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) 
end
function c120000021.sumop(e,tp,eg,ep,ev,re,r,rp)
	local op=re:GetOperation()
	local select=Duel.SelectOption(tp,aux.Stringid(120000021,1),aux.Stringid(120000021,2))
	if not op then return false end
	if select==0 then 	
		Duel.ChangeChainOperation(ev,c120000021.repop2(tp,op))
	else
		Duel.ChangeChainOperation(ev,c120000021.repop3(tp,op))
	end	
end
function c120000021.repop2(tp,op)
	return function(e,tp,eg,ep,ev,re,r,rp)
		op(e,tp,eg,ep,ev,re,r,rp)
	end
end
function c120000021.repop3(tp2,op)
	return function(e,tp,eg,ep,ev,re,r,rp)
		op(e,tp2,eg,ep,ev,re,r,rp)
	end
end
------switch announce--------------------------------------
function c120000021.swcon(e,tp,eg,ep,ev,re,r,rp)
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_ANNOUNCE)
	if not ex then return false end 
	return re:IsActiveType(TYPE_SPELL) and (cv&ANNOUNCE_CARD+ANNOUNCE_CARD_FILTER)~=0
end
function c120000021.swop(e,tp,eg,ep,ev,re,r,rp)
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_ANNOUNCE)
	local ac=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	if (cv&ANNOUNCE_CARD)~=0 then
		ac=Duel.AnnounceCard(tp,cv)
	else
		ac=Duel.AnnounceCard(tp,table.unpack(re:GetHandler().announce_filter))
	end
	Duel.ChangeTargetParam(ev,ac)
end
