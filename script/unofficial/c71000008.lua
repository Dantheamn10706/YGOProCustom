--Celestial Sword - Eatos (Anime)
--Anime version: simply a flat +300 ATK equip. The banish/boost effect lives on Eatos herself.
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(300)
	c:RegisterEffect(e1)
end
