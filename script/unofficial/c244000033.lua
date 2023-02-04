--Worm Ambush
--By Lacoodapalooza
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.spfilter(c,e,tp,tc)
  return c:IsSetCard(0x3e) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.fdcontrolfilter(c)
	return c:IsSetCard(0x3e) and c:IsRace(RACE_REPTILE) and c:IsFacedown()
end
function s.fucontrolfilter(c)
	return c:IsSetCard(0x3e) and c:IsRace(RACE_REPTILE) and c:IsFaceup()
end
function s.nfdcontrolfilter(c)
	return c:IsFacedown()
end
function s.nfucontrolfilter(c)
	return c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.GetCurrentPhase()~=PHASE_DAMAGE and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local b2=Duel.GetCurrentPhase()~=PHASE_DAMAGE and Duel.IsExistingTarget(s.fdcontrolfilter,tp,LOCATION_MZONE,0,1,nil)
	local b3=Duel.GetCurrentPhase()~=PHASE_DAMAGE and Duel.IsExistingTarget(s.fucontrolfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)},
		{b3,aux.Stringid(id,2)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
	elseif op==2 then
		e:SetCategory(CATEGORY_POSITION)
		if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
		Duel.SelectTarget(tp,s.fdcontrolfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
	elseif op==3 then
		e:SetCategory(CATEGORY_POSITION)
		if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
		Duel.SelectTarget(tp,s.fucontrolfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==1 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local x=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
		if #x>0 then
			Duel.SpecialSummon(x,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				local f=Duel.SelectMatchingCard(tp,s.fdcontrolfilter,tp,LOCATION_MZONE,0,1,1,nil)
				if #f>0 then
					Duel.ChangePosition(f,POS_FACEUP_ATTACK)
				end
			end
		end
	elseif op==2 then
		local tc=Duel.GetFirstTarget()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		if tc and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFacedown() then
			Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
			if Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
				local h=Duel.SelectMatchingCard(tp,s.nfucontrolfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
				if #h>0 then
					Duel.ChangePosition(h,POS_FACEDOWN_DEFENSE)
				end
			end
		end
	elseif op==3 then
		local tc2=Duel.GetFirstTarget()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		if tc2 and tc2:IsRelateToEffect(e) and tc2:IsLocation(LOCATION_MZONE) and tc2:IsFaceup() then
			Duel.ChangePosition(tc2,POS_FACEDOWN_DEFENSE)
			if Duel.SelectYesNo(tp,aux.Stringid(id,5)) then
				local u=Duel.SelectMatchingCard(tp,s.nfdcontrolfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
				if #u>0 then
					Duel.ChangePosition(u,POS_FACEUP_ATTACK)
				end
			end
		end
	end
		if not c:IsRelateToEffect(e) then return end
		if c:IsSSetable(true) then
			Duel.BreakEffect()
			c:CancelToGrave()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
