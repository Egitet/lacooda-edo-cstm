--Evo-Adaptation
--By Lacoodapalooza
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Special Summon Evolsaur after Evoltile effect activated
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	 e3:SetDescription(aux.Stringid(id,1))
	 e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	 e3:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	 e3:SetCountLimit(1,{id,1})
	 e3:SetRange(LOCATION_SZONE)
	 e3:SetCondition(s.rcon)
	 e3:SetOperation(function() return true end)
	 c:RegisterEffect(e3)
end
s.listed_series={0x304e,0x604e}
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetOwnerPlayer()==tp and re:GetHandler():IsSetCard(0x304e)
end
function s.filter(c,e,tp)
	return c:IsSetCard(0x604e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,170,tp,tp,false,false,POS_FACEUP)
	end
end
function s.rcon(e,tp,eg,ep,ev,re,r,rp)
    return (r&REASON_COST)~=0 and re:IsActivated() and re:IsActiveType(TYPE_XYZ) and re:GetHandler():GetRace()==RACE_DRAGON and ep==e:GetOwnerPlayer() and re:GetHandler():GetOverlayCount()>=ev-1
end
