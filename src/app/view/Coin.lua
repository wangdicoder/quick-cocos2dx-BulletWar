--
-- Author: wangdi
-- Date: 2016-02-11 14:30:08
--
local CoinBoard = import("src/app/ui/CoinBoard.lua")
local GameManager = import("src/app/manager/GameManager.lua")

local Coin = class("Coin", function()
	return display.newSprite("coin.png")
end)

CoinType = {}
CoinType.kFromCoinEnemy = 0
CoinType.kFromCoinRain = 1

function Coin:ctor(coinBoard, coinType)
	--self:addPhysicsBody()
	self:setScale(0.7)
	self.coinBoard = coinBoard

	if coinType == CoinType.kFromCoinEnemy then
		self.value = GameManager.getAttr().coinEnemySplitValue
	elseif coinType == CoinType.kFromCoinRain then
		self.value = GameManager.getAttr().coinRainValue
	end

end

function Coin:addPhysicsBody()
	local body = cc.PhysicsBody:createCircle(self:getContentSize().width/2 - 5)
	body:setMass(1)
	self:setPhysicsBody(body)
end

function Coin:addValue()
	self.coinBoard:addValue(self.value)
end

return Coin