--スピード・ワールド ３
--Speed World 3
local s,id=GetID()
local SPEED_COUNTER=0x91
local SPEED_SET=0x500
-- The announce-card message writes its opcode count as a uint8, so a declare
-- filter can never be longer than this or the message silently truncates.
local MAX_OPCODES=255

-- Anime Speed Spell pool: card id -> Speed Counters you must have to activate it.
-- Generated from every card in the database whose name contains "Speed Spell".
-- s.pool    = the ones that carry the "Speed Spell" setcode (0x500).
-- s.pool_ex = the ones that do not (the "(Anime)" reprints, setcode 0x200).
s.pool={
	[100100001]=4,  [100100002]=5,  [100100003]=2,  [100100004]=3,  [100100005]=2,
	[100100006]=8,  [100100007]=3,  [100100008]=2,  [100100009]=2,  [100100010]=3,
	[100100011]=5,  [100100012]=2,  [100100013]=3,  [100100014]=2,  [100100015]=2,
	[100100016]=2,  [100100017]=3,  [100100018]=4,  [100100019]=2,  [100100020]=4,
	[100100021]=2,  [100100022]=12, [100100023]=2,  [100100024]=2,  [100100025]=2,
	[100100026]=2,  [100100027]=3,  [100100028]=8,  [100100029]=2,  [100100030]=3,
	[100100031]=2,  [100100032]=2,  [100100033]=2,  [100100034]=2,  [100100035]=3,
	[100100036]=6,  [100100037]=7,  [100100038]=1,  [100100039]=2,  [100100040]=3,
	[100100041]=2,  [100100042]=2,  [100100043]=2,  [100100044]=1,  [100100045]=1,
	[100100046]=2,  [100100047]=2,  [100100048]=4,  [100100049]=8,  [100100050]=2,
	[100100051]=3,  [100100052]=12, [100100053]=2,  [100100054]=2,  [100100055]=2,
	[100100056]=10, [100100057]=3,  [100100058]=2,  [100100059]=12, [100100060]=2,
	[100100061]=3,  [100100062]=4,  [100100063]=4,  [100100064]=2,  [100100065]=3,
	[100100066]=2,  [100100067]=3,  [100100068]=3,  [100100069]=6,  [100100070]=3,
	[100100071]=3,  [100100072]=2,  [100100073]=6,  [100100074]=4,  [100100075]=2,
	[100100076]=3,  [100100077]=6,  [100100078]=2,  [100100079]=5,  [100100080]=1,
	[100100081]=2,  [100100082]=2,  [100100083]=3,  [100100084]=3,  [100100100]=2,
	[100100101]=3,  [100100102]=4,  [100100103]=2,  [100100104]=8,  [100100105]=3,
	[100100106]=1,  [100100107]=6,  [100100108]=0,  [100100109]=4,  [100100110]=1,
	[100100111]=2,  [100100112]=0,  [100100113]=2,  [100100114]=3,  [100100115]=2,
	[100100116]=2,  [100100117]=0,  [100100118]=4,  [100100119]=2,  [100100120]=2,
	[100100121]=3,  [100100122]=0,  [100100123]=2,  [100100124]=3,  [100100125]=2,
	[100100126]=0,  [100100127]=3,  [100100128]=2,  [100100129]=2,  [100100130]=3,
	[100100131]=2,  [100100132]=4,  [100100133]=8,  [100100500]=2,  [100100501]=1,
	[100100502]=6,  [100100503]=2,  [100100504]=2,  [100100505]=2,  [100100506]=2,
	[100100507]=2,  [100100508]=2,  [100100509]=2,  [100100510]=4,  [100100511]=2,
	[100100512]=2,  [100100513]=2,  [100100514]=2,  [100100515]=1,  [100100516]=2,
	[100100517]=1,  [100100518]=1,  [100100519]=4,  [100100520]=3,  [100100521]=3,
	[100100522]=2,  [100100525]=7,  [100100700]=6,  [100101000]=4,  [100101001]=2,
	[100101002]=2,  [100101003]=2,  [511000093]=2,  [511000779]=7,  [511000780]=4,
	[511000944]=2,  [511000972]=2,  [511000977]=4,  [511000978]=4,  [511600294]=3,
}
s.pool_ex={
	[513000145]=2,  [513000146]=2,  [513000147]=10, [513000148]=8,  [513000149]=5,
	[513000150]=3,  [513000151]=2,  [513000152]=5,  [513000153]=4,  [513000154]=2,
	[513000155]=4,  [513000156]=4,  [513000157]=10, [513000158]=2,  [513000159]=3,
}
function s.initial_effect(c)
    -- Enable Speed Counters (0x91)
    c:EnableCounterPermit(SPEED_COUNTER)
    c:SetCounterLimit(SPEED_COUNTER,12)
    -- Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    -- All Spell Cards become Quick-Play
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e2:SetCode(EFFECT_BECOME_QUICK)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(LOCATION_HAND+LOCATION_SZONE, LOCATION_HAND+LOCATION_SZONE)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSpell))
    c:RegisterEffect(e2)
    -- Add 1 Speed Counter during your Standby Phase
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCountLimit(1)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
    e3:SetCondition(s.ctcon)
    e3:SetOperation(s.ctop)
    c:RegisterEffect(e3)
    -- Once per turn: Generate a Speed Spell you have the Speed Counters for
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(id, 0))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(s.gencon)
    e4:SetOperation(s.generate_spell)
    c:RegisterEffect(e4)
end
-- Add counter condition (block if certain effects are active)
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsPlayerAffectedByEffect(tp,100100090)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():AddCounter(SPEED_COUNTER,1)
end
-- A card counts as a Speed Spell if it is in the set or in the off-set list
function s.is_speed_spell(c)
    return c:IsSetCard(SPEED_SET) or s.pool_ex[c:GetCode()]~=nil
end
-- Split the pool against the Speed Counters you have right now
function s.split_pool(ct)
    local ok,blocked,ok_ex={},{},{}
    for cid,rq in pairs(s.pool) do
        if rq<=ct then ok[#ok+1]=cid else blocked[#blocked+1]=cid end
    end
    for cid,rq in pairs(s.pool_ex) do
        if rq<=ct then ok_ex[#ok_ex+1]=cid end
    end
    return ok,blocked,ok_ex
end
-- Opcodes an OR-chain of "is this card id" tests costs
local function chain_cost(n)
    if n==0 then return 0 end
    return 3*n-1
end
local function push_chain(t,ids)
    for i=1,#ids do
        t[#t+1]=ids[i]
        t[#t+1]=OPCODE_ISCODE
        if i>1 then t[#t+1]=OPCODE_OR end
    end
end
-- Build the declare filter so the list only ever offers Speed Spells you can
-- actually activate right now. Two equivalent forms, whichever encodes smaller:
--   inclusive: id or id or id ...              (cheap when you have few counters)
--   exclusive: in the set, and not one of the out-of-reach ids, or an off-set id
function s.build_filter(ct)
    local ok,blocked,ok_ex=s.split_pool(ct)
    local eligible={}
    for i=1,#ok do eligible[#eligible+1]=ok[i] end
    for i=1,#ok_ex do eligible[#eligible+1]=ok_ex[i] end
    if #eligible==0 then return nil end
    local incl_cost=chain_cost(#eligible)+1
    local excl_cost=3
    if #blocked>0 then excl_cost=excl_cost+chain_cost(#blocked)+2 end
    if #ok_ex>0 then excl_cost=excl_cost+chain_cost(#ok_ex)+1 end
    local f={}
    if incl_cost<=excl_cost and incl_cost<=MAX_OPCODES then
        push_chain(f,eligible)
    elseif excl_cost<=MAX_OPCODES then
        f[#f+1]=SPEED_SET
        f[#f+1]=OPCODE_ISSETCARD
        if #blocked>0 then
            push_chain(f,blocked)
            f[#f+1]=OPCODE_NOT
            f[#f+1]=OPCODE_AND
        end
        if #ok_ex>0 then
            push_chain(f,ok_ex)
            f[#f+1]=OPCODE_OR
        end
    else
        -- Safety net: the pool grew past what one announce message can encode.
        -- Offer the whole set and let the check in the operation do the gating.
        f[#f+1]=SPEED_SET
        f[#f+1]=OPCODE_ISSETCARD
    end
    f[#f+1]=OPCODE_ALLOW_ALIASES
    return f
end
-- Condition: no Speed Spell in hand, and at least 1 Speed Spell within reach
function s.gencon(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsExistingMatchingCard(s.is_speed_spell,tp,LOCATION_HAND,0,1,nil) then return false end
    return s.build_filter(e:GetHandler():GetCounter(SPEED_COUNTER))~=nil
end
-- Generate the declared Speed Spell (via token)
function s.generate_spell(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then return end

    local ct=e:GetHandler():GetCounter(SPEED_COUNTER)
    local filter=s.build_filter(ct)
    if not filter then return end
    local ac=Duel.AnnounceCard(tp,filter)

    -- Marine Dolphin and Twinkle Moss stay declarable whatever the filter says,
    -- so confirm the declared card really is a Speed Spell within reach.
    local rq=s.pool[ac] or s.pool_ex[ac]
    if not rq or rq>ct then return end

    local token=Duel.CreateToken(tp, ac)

    -- Send the token to the player's hand (tp = turn player)
    Duel.SendtoHand(token, tp, REASON_EFFECT)

    -- Confirm the card to the opponent (needs to be a group)
    Duel.ConfirmCards(1-tp, Group.FromCards(token))
end
