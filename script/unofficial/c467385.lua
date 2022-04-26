--Coin Jar
--Scripted by Lacoodapalooza
local s,id=GetID()
function s.initial_effect(c)
	--Flip Effect to trigger Coin Toss and Draw.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COIN+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.toss_coin=true
--Proceeds the coin toss effect regardless of whether both players can draw 5 or not.
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,PLAYER_ALL,5)
	end
--Checks each instance of the 5 Coin tosses and delivers a draw each per result to the respective players based on results. Head= Controller Draws 1 | Tails= Opponent of controller draws 1
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COIN)
	local c1,c2,c3,c4,c5=Duel.TossCoin(tp,5)
	if c1==1 then Duel.Draw(tp,1,REASON_EFFECT)
	else Duel.Draw(1-tp,1,REASON_EFFECT)end
	if c2==1 then Duel.Draw(tp,1,REASON_EFFECT)
	else Duel.Draw(1-tp,1,REASON_EFFECT)end
	if c3==1 then Duel.Draw(tp,1,REASON_EFFECT)
	else Duel.Draw(1-tp,1,REASON_EFFECT)end
	if c4==1 then Duel.Draw(tp,1,REASON_EFFECT)
	else Duel.Draw(1-tp,1,REASON_EFFECT)end
	if c5==1 then Duel.Draw(tp,1,REASON_EFFECT)
	else Duel.Draw(1-tp,1,REASON_EFFECT)end
end