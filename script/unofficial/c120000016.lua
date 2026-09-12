--邪龍復活の儀式
--Dragon Revival Ritual
--reworked: activate freely, release materials first, then Ritual or Fusion FHD
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_names={99267150,7819629}
s.fit_monster={99267150,7819629}

local ATTR_LIST={ATTRIBUTE_EARTH,ATTRIBUTE_WATER,ATTRIBUTE_FIRE,ATTRIBUTE_WIND,ATTRIBUTE_DARK}

function s.fhdfilter(c)
	return c:IsCode(99267150) or c:IsCode(7819629)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,1-tp,LOCATION_ONFIELD)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--precheck: need one FHD reachable AND materials covering all 5 attributes
	if not Duel.IsExistingMatchingCard(s.fhdfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil) then return end
	local mg=Duel.GetRitualMaterial(tp)
	for _,att in ipairs(ATTR_LIST) do
		if not mg:IsExists(Card.IsAttribute,1,nil,att) then return end
	end

	--select and release 5 materials, one per attribute
	local mats=Group.CreateGroup()
	for _,att in ipairs(ATTR_LIST) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:FilterSelect(tp,Card.IsAttribute,1,1,nil,att)
		mats:Merge(mat)
		mg:Sub(mat)
	end
	Duel.ReleaseRitualMaterial(mats)

	--pick which FHD to summon (auto if only one, prompt if both)
	local sg=Duel.GetMatchingGroup(s.fhdfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil)
	if #sg==0 then return end
	local tc
	if #sg==1 then
		tc=sg:GetFirst()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		tc=sg:Select(tp,1,1,nil):GetFirst()
	end

	--Special Summon as its native type
	tc:SetMaterial(mats)
	local sumtype=tc:IsType(TYPE_FUSION) and SUMMON_TYPE_FUSION or SUMMON_TYPE_RITUAL
	if Duel.SpecialSummon(tc,sumtype,tp,tp,false,true,POS_FACEUP)==0 then return end
	tc:CompleteProcedure()

	--cannot attack the turn it was Special Summoned this way
	local ce=Effect.CreateEffect(e:GetHandler())
	ce:SetType(EFFECT_TYPE_SINGLE)
	ce:SetCode(EFFECT_CANNOT_ATTACK)
	ce:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	ce:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(ce)

	--destroy all cards opponent controls
	local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
