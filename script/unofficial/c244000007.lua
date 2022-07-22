--Cambrian Explosion
--By Lacoodapalooza
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x400)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Add Counters(?)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
	--Paleo gain ATK/DEF per Paleo Counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd4))
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
end
s.listed_series={0xd4}
s.counter_place_list={0x400}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) end
end
function s.filter(c)
	return c:IsAbleToHand() and c:IsSetCard(0xd4)
end
function s.mfilter(c)
	return c:IsType(TYPE_TRAP)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,5) then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	if #g>0 and g:IsExists(s.filter,1,nil) then
		Duel.DisableShuffleCheck()
		if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,s.filter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.BreakEffect()
		local vg=g:Filter(s.mfilter,nil)
		if #vg>0 then
			for tc in vg:Iter() do
				Duel.SendtoGrave(vg,REASON_EFFECT+REASON_REVEAL)
				g:Sub(vg)
			end
			Duel.MoveToDeckBottom(#g,tp)
			Duel.SortDeckbottom(tp,tp,#g)
		end
	elseif #g>0 and not g:IsExists(s.filter,1,nil) then
	end
		local lg=g:Filter(s.mfilter,nil)
		if #lg>0 then
			for tc in lg:Iter() do
				Duel.SendtoGrave(lg,REASON_EFFECT+REASON_REVEAL)
				g:Sub(lg)
			end
			Duel.MoveToDeckBottom(#g,tp)
			Duel.SortDeckbottom(tp,tp,#g)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rea=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE|EFFECT_TYPE_QUICK_O|EFFECT_TYPE_IGNITION|EFFECT_TYPE_TRIGGER_O) and rea:IsSetCard(0xd4) and re~=e:GetHandler() then
		c:AddCounter(0x400,1)
	end
end
function s.atkval(e,c)
		return e:GetHandler():GetCounter(0x400)*100
end
