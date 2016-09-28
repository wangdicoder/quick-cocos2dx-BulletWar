--
-- Author: wangdi
-- Date: 2016-02-11 21:19:47
--
local Buff = import("src/app/view/Buff.lua")

local BossEnemy = class("BossEnemy", import("src/app/view/BaseEnemy"))

BossEnemyType = {}
BossEnemyType.kTiny = 0
BossEnemyType.kBig = 1

function BossEnemy:ctor()
	BossEnemy.super.ctor(self)
	self:pos()
	if math.random(0, 100) <= 40 then
		self.type = BossEnemyType.kTiny
	else
		self.type = BossEnemyType.kBig
	end

	if self.type == BossEnemyType.kTiny then
		self:setSpriteFrame(display.newSpriteFrame("enemy_black.png"))
		self:setMoveSpeed(26)
		self:setScore(400)
		self.life = 10
		self:addTailParticle(130, 1)
		self:setTimerName("#speedBar.png")
		self:addHP(0.6)
	else
		self:setSpriteFrame(display.newSpriteFrame("enemy_boss.png"))
		self:setMoveSpeed(30)
		self:setScore(500)
		self.life = 18
		self:addTailParticle(150, 1.8)
		self:setTimerName("#hpBar.png")
		self:addHP(0.9)
	end
	
	self.maxLife = self.life	
end

function BossEnemy:reduceHP(bullet)
	self.life = self.life - bullet:getBulletPower()
	if self.life <=0 then
		self.life = 0
		if self.type == 0 then
			self:splitBullet(18)
			self:createBuff()
		else
			self:splitBullet(22)
			--self:splitBullet(22)
			self:createBuff()		
			self:createBuff()
			self:createBuff()
		end
		self:remove()
	else
		self.hp:setPercentage(100 / self.maxLife * self.life)
	end	
end

function BossEnemy:createBuff()
	local buff = Buff.new(math.random(0, 6))
	local x = self:getPositionX()
	if x < 0 then
		x = 5
	elseif x > display.width then
		x = display.width - 5
	end

	buff:setPosition(x, self:getPositionY())
	buff:setRotation(math.random(0, 180))
	self:getParent():add(buff, 2)
end

return BossEnemy