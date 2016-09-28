--
-- Author: wangdi
-- Date: 2016-02-13 15:44:57
--
local SpecialEnemy = class("SpecialEnemy", import("src/app/view/BaseEnemy"))

SpecialEnemyType = {}
SpecialEnemyType.kBlack = 0
SpecialEnemyType.kSliver = 1
SpecialEnemyType.kBrown = 2

function SpecialEnemy:ctor(type)
	SpecialEnemy.super.ctor(self)
	self:enemyType(type)
	self:setMoveSpeed(4)
	self:setScore(150)
	self.life = 1
	self.maxLife = self.life

	self:pos()

	self:setScale(0.7)
end

function SpecialEnemy:enemyType(type)
	if type == SpecialEnemyType.kBlack then
		self:setSpriteFrame(display.newSpriteFrame("enemy_black.png"))
	elseif type == SpecialEnemyType.kSliver then
		self:setSpriteFrame(display.newSpriteFrame("enemy_sliver.png"))
	elseif type == SpecialEnemyType.kBrown then
		self:setSpriteFrame(display.newSpriteFrame("enemy_brown.png"))
	end	
end

function SpecialEnemy:reduceHP(bullet)
	self.life = self.life - bullet:getBulletPower()
	if self.life <=0 then
		self.life = 0
		self:splitBullet(14)
		self:remove()
	end
end

return SpecialEnemy