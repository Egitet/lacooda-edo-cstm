--Transmogrify
--Scripted by Lacoodapalooza
local s,id=GetID()
function s.initial_effect(c)
	--Activate via targeting monster for an effect to Special Summon a monster
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
	--Filter for target that only allows a monster that is face-up and able to be Tributed.
function s.filter(c)
	return c:IsFaceup() and c:IsReleasableByEffect()
end
	--Filter for a monster that can be Special Summoned from your Deck, except for "floodgate" monsters listed by their card ID.
function s.spfilter(c,e,tp)
	local mon=c:IsCode(42009836,59509952,28423537,35984222,8696773,11366199,77585513,84636823,69072185,32687071,83061014,12435193,38412161,40672993,72845813,56647086,131182,22386234,10963799,19740112,46145256,47961808,73356503,84478195,41855169,74952447,2980764,80701178,18474999,53303460,82085295,33008376,10158145,16008155)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not mon
end
	--Targets a monster to be Tributed using the first filter, and then sets up the rest of the effect for you to Special Summon from your Deck.
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.filter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_DECK)
end
	--Tributes target that isn't immune to effect, then proceeds to Special Summon a monster from your Deck to your opponent's side.
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and Duel.Release(tc,REASON_EFFECT)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP)
		end
	end
end
--Check if it's the main phase
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end