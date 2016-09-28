--
-- Author: wangdi
-- Date: 2016-02-09 00:18:20
--
local Bullet = import("src/app/view/Bullet.lua")
local M_PI = 3.14

local BaseEnemy = class("BaseEnemy", function ()
	return display.newSprite("#enemy3.png")
end)

EnemyMoveDir = {}
EnemyMoveDir.kToRight = 0
EnemyMoveDir.kToLeft = 1

function BaseEnemy:ctor()
    self:setTag(ENEMY_TAG)
    self.life = 1
    self.score = 100
	self.dir = EnemyMoveDir.kToRight
    self.moveSpeed = 14
    self.timerName = "#attackBar.png"
end

function BaseEnemy:pos()
    local ran = math.random(1,5)
    
    if ran == 1 then
    	self:setPositionY(display.height*0.25)
    elseif ran == 2 then
    	self:setPositionY(display.height*0.4)
    elseif ran == 3 then
    	self:setPositionY(display.height*0.55)
    elseif ran == 4 then
    	self:setPositionY(display.height*0.7)
    elseif ran == 5 then
    	self:setPositionY(display.height*0.85)
    end

	ran = math.random(0,1)
	self.dir = ran
    if ran == EnemyMoveDir.kToRight then 
    	self:setPositionX(-self:getContentSize().width/2-20)
    elseif ran == EnemyMoveDir.kToLeft then
    	self:setPositionX(display.width+self:getContentSize().width/2+20)
    	self:flipX(true)
    end
end

function BaseEnemy:addHP(scale)
    local hpBackground = display.newSprite("#panel.png")
    hpBackground:setPosition(self:getContentSize().width/2, self:getContentSize().height + 12*scale)
    self:add(hpBackground)
    hpBackground:setScale(scale)

    self.hp = display.newProgressTimer(self.timerName, display.PROGRESS_TIMER_BAR)
    self.hp:setMidpoint(cc.p(0, 1))
    self.hp:setBarChangeRate(cc.p(1, 0))
    self.hp:setPercentage(100)
    self.hp:setPosition(self:getContentSize().width/2, self:getContentSize().height + 12*scale)
    self:add(self.hp)
    self.hp:setScale(scale)
end

function BaseEnemy:splitBullet(dirTotal)
    for i = 0, dirTotal-1 do      
        local currBullet = Bullet.new(dirTotal)
        currBullet:setPosition(self:getPositionX(),self:getPositionY())
        self:getParent():addChild(currBullet)

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

        local farthestDistance = display.width
        local overshotVector = cc.p(normalizedShootVector.x * farthestDistance, normalizedShootVector.y * farthestDistance)
        local offscreenPoint = cc.p(currBullet:getPositionX() - overshotVector.x, currBullet:getPositionY() - overshotVector.y)

        transition.moveTo(currBullet, {x = offscreenPoint.x, y = offscreenPoint.y, time = 3, 
        onComplete = function()
            currBullet:removeFromParent(true)
        end})
    end
end

function BaseEnemy:addPhysicsBody()
	local body = cc.PhysicsBody:createBox(cc.size(self:getContentSize().width*self:getScaleX(), self:getContentSize().height*self:getScaleY()))
	--body:setGravityEnable(false)
    body:setDynamic(false)
	body:setCollisionBitmask(0x00)
	body:setContactTestBitmask(0x01)
	self:setPhysicsBody(body)
end

function BaseEnemy:move()
    local movePerPixel = self.moveSpeed / display.width
    local distanceToBorder = nil
    self:addPhysicsBody()
    if self.dir == EnemyMoveDir.kToRight then
        distanceToBorder = -self:getPositionX()
        transition.moveTo(self, {x = display.width+self:getContentSize().width/2, y = self:getPositionY(), time = self.moveSpeed + distanceToBorder*movePerPixel, 
            onComplete = function ()
                table.removebyvalue(enemyVector, self)
                self:removeFromParent(true)
            end})
    else
        distanceToBorder = self:getPositionX() - display.width
        transition.moveTo(self, {x = -self:getContentSize().width/2, y = self:getPositionY(), time = self.moveSpeed + distanceToBorder*movePerPixel, 
            onComplete = function ()
                table.removebyvalue(enemyVector, self)
                self:removeFromParent(true)
            end})
    end
end

function BaseEnemy:addTailParticle(gravity, scale)
    local p = cc.ParticleSystemQuad:create("particles/fire.plist")
    if self.dir == EnemyMoveDir.kToRight then
        p:setPosition(p:getContentSize().width/2*scale, self:getContentSize().height/2)
        p:setGravity(cc.p(-gravity, 0))
    else
        p:setPosition(self:getContentSize().width - p:getContentSize().width/2*scale, self:getContentSize().height/2)
        p:setGravity(cc.p(gravity, 0))
    end
    p:setScale(scale)
    self:add(p)
end

function BaseEnemy:remove()
    self:addScore()
    table.removebyvalue(enemyVector, self)
    self:removeFromParent(true)
end

function BaseEnemy:addScore()
    local scene = cc.Director:getInstance():getRunningScene()
    scene:setScoreBoardValue(self.score)
    scene:addComboValue()
end

function BaseEnemy:setMoveSpeed(value)
    self.moveSpeed = value
end

function BaseEnemy:setMoveDirection(dirType)
    self.dir = dirType
    if self.dir == EnemyMoveDir.kToLeft then
        self:flipX(true)
    else
        self:flipX(false)
    end
end

function BaseEnemy:getScore()
    return self.score
end

function BaseEnemy:setScore(val)
    self.score = val
end

function BaseEnemy:setTimerName(str)
    self.timerName = str
end

function BaseEnemy:createBuff()
end

return BaseEnemy