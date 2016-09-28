--
-- Author: wangdi
-- Date: 2016-02-11 21:10:25
--
local SpecialWaveLayer = import("src/app/scenes/SpecialWaveLayer.lua")
local GameManager = import("src/app/manager/GameManager.lua")

local Buff = class("Buff", function ()
	return display.newSprite("#free_bullet.png")
end)

BuffType = {}
BuffType.kFreeBullet = 0
BuffType.kSpecialBullet = 1
BuffType.kCoinRain = 2
BuffType.kDoubleScore = 3
BuffType.kMoreEnemy = 4
BuffType.kSmallWave = 5
BuffType.kLargeWave = 6

function Buff:ctor(buffType)
	local attr = GameManager.getAttr()
	self.maxBuffNum = attr.maxBuffNum
	self.buffType = buffType
	self:addPhysicsBody()
	self:addTouch()
	
	if buffType == BuffType.kFreeBullet then
		self.time = attr.freeBulletDuration
	elseif buffType == BuffType.kSpecialBullet then
		self:setSpriteFrame(display.newSpriteFrame("special_bullet.png"))
		self.time = attr.specialBulletDuration
	elseif buffType == BuffType.kCoinRain then
		self:setSpriteFrame(display.newSpriteFrame("coin_rain.png"))
		self.time = attr.coinRainDuration
	elseif buffType == BuffType.kDoubleScore then
		self:setSpriteFrame(display.newSpriteFrame("double_score.png"))
		self.time = attr.doubleScoreDuration
	elseif buffType == BuffType.kMoreEnemy then
		self:setSpriteFrame(display.newSpriteFrame("more_enemy.png"))
		self.time = attr.moreEnemiesDuration
	elseif buffType == BuffType.kSmallWave then
		self:setSpriteFrame(display.newSpriteFrame("small_wave.png"))
		self.time = 3
	elseif buffType == BuffType.kLargeWave then
		self:setSpriteFrame(display.newSpriteFrame("large_wave.png"))
		self.time = 5
	end
	
end

function Buff:addPhysicsBody()
	self.body = cc.PhysicsBody:createBox(cc.size(self:getContentSize().width, self:getContentSize().height))
	self:setPhysicsBody(self.body)
end

function Buff:removeTouch()
	self.body:setGravityEnable(false)
	self.body:setDynamic(false)
	self.body:setCategoryBitmask(0x00)
	self:removeNodeEventListenersByEvent(cc.NODE_TOUCH_EVENT)

end

function Buff:addTouch()
	self:setTouchEnabled(true)
	self:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
	self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
		local x, y = event.x, event.y

		if event.name == "began" then
			if self:check() then
				if #buffVector + 1 <= self.maxBuffNum then
					self:removeTouch()
					local buffPanel = GameManager.getBuffPanel()
					buffPanel:addBuff(self)
				else
					print("buff up to top!")
				end
			end
		end

		return false
	end)
end

function Buff:addTimer(buffPanel)
	self.timer = display.newProgressTimer("#buff_cover.png", display.PROGRESS_TIMER_RADIAL)
	self.timer:setPercentage(0)
	self.timer:setPosition(self:getContentSize().width/2, self:getContentSize().height/2)
	self:add(self.timer)
	transition.execute(self.timer, cc.ProgressTo:create(self.time, 100), {
		onComplete = function()
			if self.buffType == BuffType.kDoubleScore then
				local scene = cc.Director:getInstance():getRunningScene()
				scene:setDoubleScore(false)
			end
			table.removebyvalue(buffVector, self)
			self:remove()
			buffPanel:updateBuffPosition(#buffVector)
		end})

	--添加buff功能
	self:runBuff()
	

end

function Buff:runBuff()
	local scene = cc.Director:getInstance():getRunningScene()
	if self.buffType == BuffType.kFreeBullet then
		print("kFreeBullet")
	elseif self.buffType == BuffType.kSpecialBullet then
		scene:updateBulletPanel()
	elseif self.buffType == BuffType.kCoinRain then
		print("kCoinRain")
	elseif self.buffType == BuffType.kDoubleScore then
		scene:setDoubleScore(true)
	elseif self.buffType == BuffType.kMoreEnemy then
		scene:addMoreEnemy()
	elseif self.buffType == BuffType.kSmallWave then		
		scene:add(SpecialWaveLayer:new(0))
	elseif self.buffType == BuffType.kLargeWave then
		print("kLargeWave")
	end
end

function Buff:removeTimer()
	self.timer:removeFromParent(true)
end

function Buff:check()
	for i=1, #buffVector do
		if self.buffType == buffVector[i]:getBuffType() then
			buffVector[i]:removeTimer()
			buffVector[i]:addTimer(GameManager.getBuffPanel())
			self:remove()
			return false
		end
	end

	return true
end

function Buff:remove()
	transition.execute(self, cc.ScaleTo:create(0.1, 0, 0, 1), {
		onComplete = function()
			self:removeFromParent(true)
		end})
end

function Buff:getBuffType()
	return self.buffType
end

return Buff