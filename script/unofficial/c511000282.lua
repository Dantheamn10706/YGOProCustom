--インパクト・リヴァイヴ
function c511000282.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511000282.condition)
	e1:SetTarget(c511000282.target)
	e1:SetOperation(c511000282.activate)
	c:RegisterEffect(e1)
end
function c511000282.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c511000282.filter(c,e,tp,tid)
	return bit.band(c:GetReason(),REASON_BATTLE)~=0 and c:GetTurnID()==tid and Duel.GetLocationCount(c:GetPreviousControler(),LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c511000282.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tid=Duel.GetTurnCount()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c511000282.filter(chkc,e,tp,tid) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c511000282.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp,tid) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c511000282.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp,tid)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c511000282.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	local pos=tc:GetPreviousPosition()
	local cop=tc:GetPreviousControler()
	if tc:IsRelateToEffect(e) then
		if Duel.GetLocationCount(cop,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		Duel.SpecialSummon(tc,0,tp,cop,true,false,pos)
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_UPDATE_ATTACK)
			e0:SetValue(500)
			e0:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e0)
            local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_SKIP_TURN)
			e1:SetTargetRange(0,1)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e2:SetTargetRange(1,0)
			e2:SetCode(EFFECT_SKIP_M2)
			if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
			e2:SetCondition(c511000282.skipcon)
			e2:SetLabel(Duel.GetTurnCount())
			e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
			else
			e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			end
			Duel.RegisterEffect(e2,tp)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetTargetRange(1,0)
			e3:SetCode(EFFECT_SKIP_DP)
			if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE then
			e3:SetCondition(c511000282.skipcon)
			e3:SetLabel(Duel.GetTurnCount())
			e3:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
			else
			e3:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN)
			end
			Duel.RegisterEffect(e3,tp)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_SKIP_SP)
			Duel.RegisterEffect(e4,tp)
			local e5=e3:Clone()
			e5:SetCode(EFFECT_SKIP_M1)
			Duel.RegisterEffect(e5,tp)
	end
end
function c511000282.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end