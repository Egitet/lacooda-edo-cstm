--Evoltile Schlero
--By Lacoodapalooza
local s,id=GetID()
function s.initial_effect(c)
--Dual-Typing= Dinsosaur
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_RACE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(RACE_DINOSAUR)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
s.listed_series={0x304e,0x604e}
function s.cfilter(c,ft,tp)
	return (ft>0 or c:IsInMainMZone(tp)) and (c:IsSetCard(0x304e) or c:IsSetCard(0x604e))
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroupCost(tp,s.cfilter,1,true,nil,e:GetHandler(),ft,tp) end
	local g=Duel.SelectReleaseGroupCost(tp,s.cfilter,1,1,true,nil,e:GetHandler(),ft,tp)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.Release(g,REASON_COST)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,LOCATION_HAND)
end
function s.evfilter(c,e,tp)
	return  c:IsSetCard(0x604e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)then
		Duel.SpecialSummonComplete()
		Duel.BreakEffect()
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
		Duel.ConfirmDecktop(tp,e:GetLabel())
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetDecktopGroup(tp,e:GetLabel()):Filter(s.evfilter,nil,e,tp)
		local ct=0
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.DisableShuffleCheck()
			Duel.SpecialSummon(sg,170,tp,tp,false,false,POS_FACEUP)
			ct=1
		end
		local ac=e:GetLabel()-ct
		if ac>0 then
			Duel.MoveToDeckBottom(ac,tp)
			Duel.SortDeckbottom(tp,tp,ac)
		end
	end
end
