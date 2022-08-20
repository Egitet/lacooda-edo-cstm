--Evolsaur Chasmo
--By Lacoodapalooza
local s,id=GetID()
function s.initial_effect(c)
--spsummon
local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(id,0))
e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
e1:SetCode(EVENT_SPSUMMON_SUCCESS)
e1:SetCountLimit(1,id)
e1:SetCondition(aux.evospcon)
e1:SetTarget(s.sptg)
e1:SetOperation(s.sadd)
c:RegisterEffect(e1)
end
	function s.filter(c)
		return c:IsCode(5338223,8632967,14154221,24362891,34026662,64815084,74100225,88760522,78933589,93504463,244000014,244000015) and c:IsAbleToHand()
	end
	function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	function s.sadd(e,tp,eg,ep,ev,re,r,rp,chk)
		local tg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
		if tg then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
