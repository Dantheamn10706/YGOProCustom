--Red-Eyes Ultimate Dragon
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,74677422,3) -- "Red-Eyes B. Dragon"
end
