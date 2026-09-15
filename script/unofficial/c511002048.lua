--リビングデッドの呼び声
function c511002048.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511002048.sptg)
	e1:SetOperation(c511002048.spop)
	c:RegisterEffect(e1)
	--remain field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)	
end
function c511002048.filter(c,e,tp)
	return c:IsReason(REASON_BATTLE) and not c:IsRace(RACE_ZOMBIE) and c:GetPreviousLocation()==LOCATION_MZONE and c:GetPreviousControler()==tp 
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511002048.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c511002048.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(c511002048.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c511002048.filter,tp,LOCATION_GRAVE,0,ft,ft,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c511002048.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	if ft<g:GetCount() then return end
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(RACE_ZOMBIE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetCode(EFFECT_SET_BASE_DEFENSE)
            e2:SetValue(0)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2,true)
            tc:RegisterFlagEffect(511002048,RESET_EVENT,0x17a0000,0,0)
			tc=g:GetNext()
		end
			Duel.SpecialSummonComplete()
			--Revive
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e3:SetRange(LOCATION_SZONE)
			e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e3:SetCode(EVENT_BATTLE_DESTROYED)
			e3:SetCondition(c511002048.spcon)
			e3:SetTarget(c511002048.sptg2)
			e3:SetOperation(c511002048.spop2)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e3)
	end
end
function c511002048.cfilter(c,tp)
	return c:GetFlagEffect(511002048)~=0 and c:IsReason(REASON_BATTLE) and not c:IsRace(RACE_ZOMBIE)
end
function c511002048.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511002048.cfilter,1,nil,tp)
end
function c511002048.filter2(c,e,tp,tid)
	return c:GetTurnID()==tid and c:GetFlagEffect(511002048)~=0 and c:GetPreviousControler()==tp and c:GetBaseAttack()~=0 
	and bit.band(c:GetPreviousRaceOnField(),RACE_ZOMBIE)~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511002048.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c511002048.filter2(chkc,e,tp,Duel.GetTurnCount()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingTarget(c511002048.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,Duel.GetTurnCount()) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c511002048.filter2,tp,LOCATION_GRAVE,0,ft,ft,nil,e,tp,Duel.GetTurnCount())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c511002048.spop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e,tp,Duel.GetTurnCount())
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<g:GetCount() then return end
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(RACE_ZOMBIE)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
            e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetRange(LOCATION_MZONE)
            e2:SetCode(EFFECT_SET_BASE_DEFENSE)
            e2:SetValue(0)
            e2:SetReset(RESET_EVENT+0x1fe0000)
            tc:RegisterEffect(e2,true)
			--ATK 10% increase
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetValue(tc:GetBaseAttack()*0.1)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3,true)
			tc=g:GetNext()	
		end
		Duel.SpecialSummonComplete()
	end
end