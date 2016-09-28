--
-- Author: wangdi
-- Date: 2016-02-09 16:16:58
--
local Coin = import("src/app/view/Coin.lua")
local CoinBoard = import("src/app/ui/CoinBoard.lua")
local GameManager = import("src/app/manager/GameManager.lua")

local CoinEnemy = class("CoinEnemy", import("src/app/view/BaseEnemy"))

local M_PI = 3.14

function CoinEnemy:ctor(coinBoard)
	CoinEnemy.super.ctor(self)
	self:setSpriteFrame(display.newSpriteFrame("enemy_coin.png"))
	self:setMoveSpeed(24)
	self:setScore(200)
	self.life = 5
	self.maxLife = self.life
	self.coinBoard = coinBoard

	self:pos()

	self:setTimerName("#attackBar.png")
	self:addHP(0.6)
	self:addTailParticle(50, 1)
end

function CoinEnemy:reduceHP(bullet)
	self.life = self.life - bullet:getBulletPower()
	if self.life <=0 then
		self.life = 0
		self:splitCoin()
		self:remove()
	else
		self.hp:setPercentage(100 / self.maxLife * self.life)
	end	
end

function CoinEnemy:splitCoin()
	dirTotal = GameManager.getAttr().coinEnemySplitNum
	for i = 0, dirTotal-1 do      
        local coin = Coin.new(self.coinBoard, CoinType.kFromCoinEnemy)
        coin:setPosition(self:getPositionX(),self:getPositionY())
        self:getParent():addChild(coin, 1)

        local shootVector = cc.p(0,0)
        shootVector.x = 1
        shootVector.y = math.tan(i * 2 * M_PI / dirTotal)
        local normalizedShootVector
        if i >= dirTotal / 2 then
            normalizedShootVector = cc.pNormalize(shootVector)      
        else            
            local temp = cc.pNormalize(shootVector)
            normalizedShootVector = cc.p(-temp.x, -temp.y)
        end

        local farthestDistance = display.height*0.2
        local overshotVector = cc.p(normalizedShootVector.x * farthestDistance, normalizedShootVector.y * farthestDistance)
        local offscreenPoint = cc.p(coin:getPositionX() - overshotVector.x, coin:getPositionY() - overshotVector.y)

        transition.execute(coin, cc.MoveTo:create(0.7, cc.p(offscreenPoint.x, offscreenPoint.y)), {
		    easing = "backout",
		    onComplete = function()
		    	transition.execute(coin, transition.sequence({cc.DelayTime:create(0.2), cc.MoveTo:create(0.1+ 0.05*i, cc.p(35, display.height - 26))}), {
		    			onComplete = function()
		    				coin:addValue()
		    				coin:removeFromParent(true)
		    			end})
		    end})

    end
end

return CoinEnemy