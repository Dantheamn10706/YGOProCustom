--Rod of Silence - Kay'est (Anime)
--Bare equip; anti-spell / attack protection lives on Kay'est herself.
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(500)
	c:RegisterEffect(e1)
end
