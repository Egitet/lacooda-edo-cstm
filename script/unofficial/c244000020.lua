--Code W - "The Amalgamation"
--By Lacoodapalooza
local s,id=GetID()
function s.initial_effect(c)
--Activate
local e1=Effect.CreateEffect(c)
e1:SetCategory(CATEGORY_FUSION_SUMMON)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
e1:SetCost(s.cost)
e1:SetTarget(s.target)
e1:SetOperation(s.activate)
c:RegisterEffect(e1)
end
s.listed_series={0x3e}
function s.diswfilter(c)
	return c:IsSetCard(0x3e) and c:IsRace(RACE_REPTILE) and c:IsDiscardable()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.diswfilter,tp,LOCATION_HAND,0,1,nil) end
	local w=Duel.DiscardHand(tp,s.diswfilter,1,60,REASON_COST+REASON_DISCARD)
	e:SetLabel(w)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_FUSION_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local w=e:GetLabel()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,5*w)
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_FUSION)==0 then return end
	local g=Duel.GetDecktopGroup(tp,5*w)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		Duel.DisableShuffleCheck()
		if Fusion.SummonEffTG{fusfilter=aux.FilterBoolFunction(Card.IsSetCard,0x3e),matfilter=function(c) return g:IsContains(c) end,extrafil=function() return g end,stage2=s.stage2}(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Fusion.SummonEffOP{fusfilter=aux.FilterBoolFunction(Card.IsSetCard,0x3e),matfilter=function(c) return g:IsContains(c) end,extrafil=function() return g end,stage2=s.stage2}(e,tp,eg,ep,ev,re,r,rp)
		end
	end
	local ac=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)
	if ac>0 then
		Duel.MoveToDeckBottom(ac,tp)
		Duel.SortDeckbottom(tp,tp,ac)
	end
end
function s.stage2(e,tc,tp,sg,chk)
	if chk==0 and tc:GetMaterialCount()>=6 then
		local e1=Effect.CreateEffect(tc)
		e1:SetDescription(aux.Stringid(id,3))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(s.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
	end
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
