--
-- Author: wangdi
-- Date: 2016-02-09 14:07:46
--
local NormalEnemy = class("NormalEnemy", import("src/app/view/BaseEnemy"))

function NormalEnemy:ctor()
	NormalEnemy.super.ctor(self)
	self.life = 1

	self:enemyType(math.random(1,4))
	self:setMoveSpeed(math.random(12, 14))
	self:pos()
end

function NormalEnemy:enemyType(type)
	if type == 1 then
		self:setSpriteFrame(display.newSpriteFrame("enemy3.png"))
	elseif type ==2 then
		self:setSpriteFrame(display.newSpriteFrame("enemy4.png"))
	elseif type ==3 then
		self:setSpriteFrame(display.newSpriteFrame("enemy1.png"))
	elseif type ==4 then
		self:setSpriteFrame(display.newSpriteFrame("enemy2.png"))
	end	
end

function NormalEnemy:reduceHP(node)	
	self.life = self.life - node:getBulletPower()
	if self.life <=0 then
		self:splitBullet(node:getSplitNum())
		self:remove()
	end
end

return NormalEnemy