--先史遺産ソル・モノリス
function c120000401.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000401,0))
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c120000401.condition)
	e1:SetTarget(c120000401.target)
	e1:SetOperation(c120000401.operation)
	c:RegisterEffect(e1)
end
function c120000401.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c120000401.atkfilter(c,lv)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:GetLevel()~=lv
end
function c120000401.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and chkc~=c and c120000401.atkfilter(chkc,lv) end
	if chk==0 then return Duel.IsExistingTarget(c120000401.atkfilter,tp,LOCATION_ONFIELD,0,1,c,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c120000401.atkfilter,tp,LOCATION_ONFIELD,0,1,1,c,lv)
end
function c120000401.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end