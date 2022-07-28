--Paleozoic Habelia
--By Lacoodapalooza
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,s.xyzfilter,2,3,nil,nil,99)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(s.efilter)
		c:RegisterEffect(e1)
		--copy trap it detaches
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(id,0))
		e2:SetType(EFFECT_TYPE_QUICK_O)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetCountLimit(1,id)
		e2:SetCost(s.cpcost)
		e2:SetTarget(s.cptg)
		e2:SetOperation(s.cpop)
		c:RegisterEffect(e2,false,REGISTER_FLAG_DETACH_XMAT)
	end
	s.listed_series={0xd4}
	function s.efilter(e,te)
		return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
	end
	function s.xyzfilter(c,lc,SUMMON_TYPE_XYZ,tp)
		return Duel.GetFlagEffect(c:GetControler(),id)==0 and c:IsSetCard(0xd4,lc,SUMMON_TYPE_XYZ,tp)
	end
	function s.detachfilter(c)
		return c:GetType()==0x4 and c:CheckActivateEffect(false,true,false)~=nil
	end
	function s.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local g=c:GetOverlayGroup()
		if chk==0 then return g:IsExists(s.detachfilter,1,nil) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
		local dc=g:FilterSelect(tp,s.detachfilter,1,1,nil)
		Duel.SendtoGrave(dc,REASON_COST)
		Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
		e:SetLabelObject(dc:GetFirst())
	end
	function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then return true end
	end
	function s.cpop(e,tp,eg,ep,ev,re,r,rp)
		local tc=e:GetLabelObject()
		if not tc then return end
		local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
		if not te then return end
		local tg=te:GetTarget()
		local op=te:GetOperation()
		if tg then tg(te,tp,Group.CreateGroup(),PLAYER_NONE,0,e,REASON_EFFECT,PLAYER_NONE,1) end
		Duel.BreakEffect()
		tc:CreateEffectRelation(te)
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g and #g>0 then
			for etc in g:Iter() do
				etc:CreateEffectRelation(te)
			end
		end
		if op then op(te,tp,Group.CreateGroup(),PLAYER_NONE,0,e,REASON_EFFECT,PLAYER_NONE,1) end
		tc:ReleaseEffectRelation(te)
		if g and #g>0 then
			for etc in g:Iter() do
				etc:ReleaseEffectRelation(te)
			end
		end
	end
