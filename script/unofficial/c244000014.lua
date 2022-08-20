--Evo-Tree
--By Lacoodapalooza
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--boost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_REPTILE+RACE_DINOSAUR+RACE_DRAGON))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--Return Evoltile, then Special Summon Evolsaur
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.evtg)
	e3:SetOperation(s.evop)
	c:RegisterEffect(e3)
	--Attach Material PHASE_STANDBY
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetTarget(s.attg)
	e4:SetOperation(s.atop)
	c:RegisterEffect(e4)
end
s.listed_series={0x304e,0x604e}
function s.thfilter(c,e,tp)
  return c:IsFaceup() and c:IsSetCard(0x304e) and c:IsType(TYPE_MONSTER) and Duel.GetMZoneCount(tp,c)>0 and c:IsAbleToHandAsCost() and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function s.spfilter(c,e,tp,tc)
  return c:IsSetCard(0x604e) and c:IsType(TYPE_MONSTER) and not c:IsCode(tc:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.evtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local c=e:GetHandler()
  if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.thfilter(chkc,e,tp) and chkc~=c end
  if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_MZONE,0,1,c,e,tp) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
  local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_MZONE,0,1,1,c,e,tp)
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.evop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
  local tc=Duel.GetFirstTarget()
  if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tc)
    if #g~=0 then
      Duel.SpecialSummon(g,170,tp,tp,false,false,POS_FACEUP)
    end
  end
end
function s.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_DRAGON)
end
function s.matfilter(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE)) and c:IsSetCard(0x304e) or c:IsSetCard(0x604e)
end
function s.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.matfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
	end
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	local tg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_MZONE,0,nil,e)
	if #mg>0 and #tg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local mc=mg:Select(tp,1,1,false):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local tc=tg:Select(tp,1,1,false):GetFirst()
		if mc and tc then
			Duel.Overlay(tc,mc)
		end
	end
end
