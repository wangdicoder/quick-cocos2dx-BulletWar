--
-- Author: wangdi
-- Date: 2016-02-09 00:17:53
--
local GameManager = import("src/app/manager/GameManager.lua")

local Bullet = class("Bullet", function ()
	return display.newSprite("bullet.png")
end)

function Bullet:ctor(splitNum)
	local attr = GameManager.getAttr()
	self:setTag(BULLET_TAG)
	self:addPhysicsBody()

	self.power = attr.bulletPower

	local maxBulletSplitNum = attr.maxBulletSplitNum
	if splitNum+2 <= maxBulletSplitNum then
		self.splitNum = 2 + splitNum
	else
		self.splitNum = maxBulletSplitNum
	end

	self:setScale(0.8)
end

function Bullet:addPhysicsBody()
	local body = cc.PhysicsBody:createCircle(self:getContentSize().width/2)
	body:setGravityEnable(false)
	body:setCollisionBitmask(0x00)
	body:setContactTestBitmask(0x01)
	self:setPhysicsBody(body)
end

function Bullet:getBulletPower()
	return self.power
end

function Bullet:setBulletPower(val)
	self.power = val
end

function Bullet:getSplitNum()
	return self.splitNum
end

function Bullet:addSplitNum()
	local maxBulletSplitNum = 10
	if self.splitNum + 2 <= maxBulletSplitNum then
		self.splitNum = self.splitNum + 2
	end
end

function Bullet:remove()
	self:stopAllActions()
	self:removeFromParent(true)
end

return Bullet