--
-- Author: wangdi
-- Date: 2016-02-15 15:23:46
--
local GameManager = import("src/app/manager/GameManager.lua")

local BulletPanel = class("BulletPanel", function()
	return display.newLayer()
end)

local lastPosX = display.width*0.57
local lastPosY = display.height*0.04
local bulletVec = {}

function BulletPanel:ctor()
	self.maxBulletShootNum = GameManager.getAttr().maxBulletShootNum
	self:init()
	self.unlock = true  --action lock
end

function BulletPanel:init()
	for i=0, self.maxBulletShootNum-1 do
		local sp = display.newSprite("#bullet.png")
		sp:setPosition(display.width + sp:getContentSize().width/2, lastPosY)
		self:add(sp)
		sp:setScale(0.7)
		table.insert(bulletVec, sp)
		transition.execute(sp, cc.MoveTo:create(1.2 + i * 0.1, cc.p(lastPosX + (sp:getContentSize().width*0.7+5)*i, lastPosY)), {easing = "exponentialOut"})
	end
end

function BulletPanel:reduceBullet()
	if self.unlock == true then
		self.unlock = false
		local preX = bulletVec[1]:getPositionX()
		local temp = nil
		for i=2, #bulletVec do
			temp = bulletVec[i]:getPositionX()
			transition.execute(bulletVec[i], cc.MoveTo:create(0.1, cc.p(preX, bulletVec[i]:getPositionY())), {easing = "exponentialOut", 
				onComplete = function()
					self.unlock = true
				end})
			preX = temp
		end
		bulletVec[1]:removeFromParent(true)
		table.remove(bulletVec, 1)
	end
end

function BulletPanel:addBullet()
	if self.unlock == true then
		self.unlock = false
		local lastX = bulletVec[#bulletVec]:getPositionX()
		local sp = display.newSprite("#bullet.png")
		sp:setPosition(display.width + sp:getContentSize().width/2, lastPosY)
		self:add(sp)
		sp:setScale(0.7)
		table.insert(bulletVec, sp)
		transition.execute(sp, cc.MoveTo:create(0.1, cc.p(lastX + sp:getContentSize().width*0.7+5, lastPosY)), {easing = "exponentialOut",
			onComplete = function()
				self.unlock = true
			end})
	end
end

return BulletPanel