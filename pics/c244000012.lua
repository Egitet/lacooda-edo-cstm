--Evoltile Soleno
--By Lacoodapalooza
local s,id=GetID()
function s.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--En Mass Level Modulation Match Target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.lvtg)
	e2:SetOperation(s.lvop)
	c:RegisterEffect(e2)
end
s.listed_series={0x304e,0x604e}
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.filter(c)
	return c:IsCode(5338223,8632967,14154221,24362891,34026662,64815084,74100225,88760522,78933589,93504463,244000014,244000015) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function s.lvfilter1(c,tp)
	return c:IsFaceup() and c:HasLevel() and c:IsSetCard(0x604e)
		and Duel.IsExistingMatchingCard(s.lvfilter2,tp,LOCATION_MZONE,0,1,c,c:GetLevel())
end
function s.lvfilter2(c,lv)
	return c:IsFaceup() and c:HasLevel() and (c:IsSetCard(0x604e) or c:IsSetCard(0x304e))
	and not c:IsLevel(lv)
end
function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.lvfilter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.lvfilter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.lvfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function s.tyfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x304e)
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local lv=tc:GetLevel()
		local g=Duel.GetMatchingGroup(s.lvfilter2,tp,LOCATION_MZONE,0,tc,lv)
		local lc=g:GetFirst()
		for lc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			lc:RegisterEffect(e1)
		end
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(s.tyfilter,tp,LOCATION_MZONE,0,nil)
		if #g>0 then
			local tc=g:GetFirst()
			for tc in aux.Next(g) do
				local e1=Effect.CreateEffect(e:GetHandler())
				 e1:SetType(EFFECT_TYPE_SINGLE)
				  e1:SetCode(EFFECT_CHANGE_RACE)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(RACE_DINOSAUR)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			end
		end
	end
