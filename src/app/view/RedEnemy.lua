--
-- Author: wangdi
-- Date: 2016-02-13 15:44:45
--
local Buff = import("src/app/view/Buff.lua")
local Bullet = import("src/app/view/Bullet.lua")

local RedEnemy = class("RedEnemy", import("src/app/view/BaseEnemy"))

function RedEnemy:ctor()
	RedEnemy.super.ctor(self)
	self:setSpriteFrame(display.newSpriteFrame("enemy_red.png"))
	self:setMoveSpeed(12)
	self:setScore(300)
	self.life = 7
	self.maxLife = self.life

	self:pos()

	self:setTimerName("#explosionBar.png")
	self:addHP(0.7)
	self:addTailParticle(-100, 1)
end

function RedEnemy:reduceHP(bullet)
	self.life = self.life - bullet:getBulletPower()
	if self.life <=0 then
		self.life = 0
		--self:splitBullet(16)
		self:createBuff()
		--self:remove()
	else
		self.hp:setPercentage(100 / self.maxLife * self.life)
	end	
end

function RedEnemy:createBuff()
	local function splitAgain()
		self:splitBullet(20)
		self:remove()
	end

	self:hide()
	self:stopAllActions()
	self:setPosition(display.cx, display.cy)
	self:getPhysicsBody():setCategoryBitmask(0x00)
	self:splitBullet(20)
	self:performWithDelay(splitAgain, 1)
	
end

return RedEnemy