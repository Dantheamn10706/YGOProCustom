--Zorc Necrophade
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()

    -- Special Summon procedure: Tribute 3 Wicked Gods
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetValue(1)
    e1:SetCondition(s.spcon)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)

    -- Cannot be special summoned by other ways
    local e2=Effect.CreateEffect(c)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_SPSUMMON_CONDITION)
    e2:SetValue(aux.FALSE)
    c:RegisterEffect(e2)

    -- Cannot be targeted or destroyed by opponent's effects
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e4:SetValue(function(e,re,tp) return tp~=e:GetHandlerPlayer() end)
    c:RegisterEffect(e4)

    -- Cannot be tributed or used as material
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
    e5:SetValue(1)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    c:RegisterEffect(e6)
    local e7=e5:Clone()
    e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
    c:RegisterEffect(e7)
    local e8=e5:Clone()
    e8:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    c:RegisterEffect(e8)
    local e9=e5:Clone()
    e9:SetCode(EFFECT_UNRELEASABLE_SUM)
    c:RegisterEffect(e9)
    local e10=e5:Clone()
    e10:SetCode(EFFECT_UNRELEASABLE_NONSUM)
    c:RegisterEffect(e10)

    -- Control cannot change
    local e11=Effect.CreateEffect(c)
    e11:SetType(EFFECT_TYPE_SINGLE)
    e11:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
    c:RegisterEffect(e11)

    -- Destroy monster it battles + burn
    local e12=Effect.CreateEffect(c)
    e12:SetDescription(aux.Stringid(id,0))
    e12:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e12:SetCode(EVENT_BATTLE_START)
    e12:SetCondition(s.descon)
    e12:SetTarget(s.destg)
    e12:SetOperation(s.desop)
    c:RegisterEffect(e12)

    -- Direct attack: Set opponent LP to 0
    local e13=Effect.CreateEffect(c)
    e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e13:SetCode(EVENT_DAMAGE_STEP_END)
    e13:SetCondition(s.lpcon)
    e13:SetOperation(s.lpop)
    c:RegisterEffect(e13)

    -- Set ATK to 0
    local e14=Effect.CreateEffect(c)
    e14:SetType(EFFECT_TYPE_SINGLE)
    e14:SetCode(EFFECT_SET_BASE_ATTACK)
    e14:SetValue(0)
    c:RegisterEffect(e14)
end

-- IDs of Wicked Gods
local WICKED_AVATAR = 21208154
local WICKED_DREADROOT = 62180201
local WICKED_ERASER = 57793869

function s.spfilter(c,code)
    local code1,code2=c:GetOriginalCodeRule()
    return code1==code or code2==code
end

function s.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local rg=Duel.GetReleaseGroup(tp)
    local g1=rg:Filter(s.spfilter,nil,WICKED_AVATAR)
    local g2=rg:Filter(s.spfilter,nil,WICKED_DREADROOT)
    local g3=rg:Filter(s.spfilter,nil,WICKED_ERASER)
    local g=g1:Clone()
    g:Merge(g2)
    g:Merge(g3)
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3 and #g1>0 and #g2>0 and #g3>0
        and aux.SelectUnselectGroup(g,e,tp,3,3,s.rescon,0)
end

function s.rescon(sg,e,tp,mg)
    return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:IsExists(s.chk,1,nil,sg,Group.CreateGroup(),WICKED_AVATAR,WICKED_DREADROOT,WICKED_ERASER)
end
function s.chk(c,sg,g,code,...)
    local code1,code2=c:GetOriginalCodeRule()
    if code~=code1 and code~=code2 then return false end
    local res
    if ... then
        g:AddCard(c)
        res=sg:IsExists(s.chk,1,g,sg,g,...)
        g:RemoveCard(c)
    else
        res=true
    end
    return res
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
    local rg=Duel.GetReleaseGroup(tp)
    local g1=rg:Filter(s.spfilter,nil,WICKED_AVATAR)
    local g2=rg:Filter(s.spfilter,nil,WICKED_DREADROOT)
    local g3=rg:Filter(s.spfilter,nil,WICKED_ERASER)
    g1:Merge(g2)
    g1:Merge(g3)
    local g1=aux.SelectUnselectGroup(g1,e,tp,3,3,s.rescon,1,tp,HINTMSG_RELEASE,s.rescon,nil,true)
    if #g1>0 then
        g1:KeepAlive()
        e:SetLabelObject(g1)
        return true
    end
    return false
end

function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local g1=e:GetLabelObject()
    if not g1 then return end
    Duel.Release(g1,REASON_COST)
    g1:DeleteGroup()
end

-- Battle effect
function s.descon(e,tp,eg,ep,ev,re,r,rp)
    local bc=e:GetHandler():GetBattleTarget()
    return bc~=nil and bc:IsControler(1-tp)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local bc=e:GetHandler():GetBattleTarget()
    if chk==0 then return bc and bc:IsRelateToBattle() end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,math.max(bc:GetAttack(),0))
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local bc=e:GetHandler():GetBattleTarget()
    if bc and bc:IsRelateToBattle() then
        local atk=math.max(bc:GetAttack(),0)
        Duel.Destroy(bc,REASON_EFFECT)
        Duel.Damage(1-tp,atk,REASON_EFFECT)
    end
end

-- Direct attack LP drop
function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetAttackTarget()==nil and Duel.GetAttacker()==e:GetHandler()
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
    Duel.SetLP(1-tp, 0)
end
