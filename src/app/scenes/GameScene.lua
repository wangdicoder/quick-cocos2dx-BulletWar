--
-- Author: wangdi
-- Date: 2016-02-09 00:10:14
--
local scheduler = require("framework.scheduler")
local BackgroundLayer = import("src/app/scenes/BackgroundLayer.lua")
local GameManager = import("src/app/manager/GameManager.lua")
local BuffPanel = import("src/app/ui/BuffPanel")
local CoinBoard = import("src/app/ui/CoinBoard.lua")
local ScoreBoard = import("src/app/ui/ScoreBoard.lua")
local NormalEnemy = import("src/app/view/NormalEnemy.lua")
local Cannon = import("src/app/view/Cannon.lua")
local Bullet = import("src/app/view/Bullet.lua")
local BaseEnemy = import("src/app/view/BaseEnemy.lua")
local CoinEnemy = import("src/app/view/CoinEnemy.lua")
local BossEnemy = import("src/app/view/BossEnemy.lua")
local SpecialEnemy = import("src/app/view/SpecialEnemy.lua")
local RedEnemy = import("src/app/view/RedEnemy.lua")
local SpecialWaveLayer = import("src/app/scenes/SpecialWaveLayer.lua")
local BulletPanel = import("src/app/ui/BulletPanel")
local ComboBoard = import("src/app/ui/ComboBoard")


local GameScene = class("GameScene", function ()
	return display.newPhysicsScene("GameScene")
end)

function GameScene:ctor()
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	buffVector = {}
	enemyVector = {}
	self.gameTime = 0
	self:UI()
	self.doubleScore = false

    self:createEnemy()
    self:addCollisionLogic()

end

function GameScene:createEnemy()
	local function update()
		for i=1, 3 do
			self:getPhysicsWorld():step(1/180.0)
		end
	end

	local function intervalNormal(dt)
    	local enemy = NormalEnemy.new()
		self:add(enemy)
		enemy:move()
		table.insert(enemyVector, enemy)
    end

    local function intervalCoin(dt)
    	self.gameTime = self.gameTime + 1

    	local enemy = nil
    	if math.fmod(self.gameTime, 10) == 0 then    		
			enemy = SpecialEnemy.new(math.random(0, 2))
			self:add(enemy)
    		enemy:move()
    		table.insert(enemyVector, enemy)
		elseif math.fmod(self.gameTime, 14) == 0 then
			enemy = RedEnemy.new()
			self:add(enemy)
    		enemy:move()
    		table.insert(enemyVector, enemy)
		elseif math.fmod(self.gameTime, 23) == 0 then
			enemy = CoinEnemy.new(self.coinBoard)
			self:add(enemy)
    		enemy:move()
    		table.insert(enemyVector, enemy)
		elseif math.fmod(self.gameTime, 37) == 0 then
			enemy = BossEnemy.new()
			self:add(enemy)
    		enemy:move()
    		table.insert(enemyVector, enemy)
    	end

    	if self.gameTime == 370 then
    		self.gameTime = 0
    	end
    end

	self.handle = scheduler.scheduleUpdateGlobal(update)
	self.handle1 = scheduler.scheduleGlobal(intervalNormal, 1.2)
	self.handle2 = scheduler.scheduleGlobal(intervalCoin, 1)
	

	--self:getPhysicsWorld():setDebugDrawMask(cc.PhysicsWorld.DEBUGDRAW_ALL)
    
end

function GameScene:addCollisionLogic()
	local function onContactBegin(contact)
		local a = contact:getShapeA():getBody():getNode()
		local b = contact:getShapeB():getBody():getNode()

		if a ~=nil and b ~= nil then
			if a:getTag() == BULLET_TAG and b:getTag() == WALL_TAG then
				a:removeFromParent(true)
				a = nil
			elseif b:getTag() == BULLET_TAG and a:getTag() == WALL_TAG then
				b:removeFromParent(true)
				b = nil
			end
		end

		if a ~= nil and b ~= nil then
			if b:getTag() == ENEMY_TAG then
				b:reduceHP(a)
				a:removeFromParent(true)
				a = nil
			elseif a:getTag() == ENEMY_TAG then
				a:reduceHP(b)
				b:removeFromParent(true)
				b = nil
			end
		end

		return true
	end

	local wall = display.newNode()
	wall:setAnchorPoint(cc.p(0.5, 0.5))
	local wallBody = cc.PhysicsBody:createEdgeBox(cc.size(display.width+50, display.height + BUFF_SP_HEIGHT), cc.PhysicsMaterial(0.1, 0.5, 0.5), 1, cc.p(0, BUFF_SP_HEIGHT/2))
	wallBody:setContactTestBitmask(0x01)
	wall:setPhysicsBody(wallBody)
	wall:setPosition(display.cx, display.cy)
	wall:setTag(WALL_TAG)
	self:add(wall)

	self:getPhysicsWorld():setGravity(cc.p(0, -500))
	self:getPhysicsWorld():setAutoStep(false)


	self.contactListener = cc.EventListenerPhysicsContact:create()
	self.contactListener:registerScriptHandler(onContactBegin, cc.Handler.EVENT_PHYSICS_CONTACT_BEGIN)
	cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(self.contactListener, 1)

end

function GameScene:addMoreEnemy()
	local time = GameManager.getAttr().moreEnemiesDuration
	local handle = nil
	local interval = 1.4
	local repeatNum =  math.ceil(time / interval)
	local index = 0

	local function add()
		local enemy = NormalEnemy.new()
		self:add(enemy)
		enemy:move()
		table.insert(enemyVector, enemy)
	end

	self:randomEnemy()
	self:randomEnemy()

	handle = cc.Director:getInstance():getScheduler():scheduleScriptFunc(function ()
		index = index+1
		add()
		if index >= repeatNum then
			scheduler.unscheduleGlobal(handle)
			print("over")
		end
	end, interval, false)
end

function GameScene:randomEnemy()
	local ran = math.random(0, 3)
    local enemy = nil
    if ran == 0 then
		enemy = SpecialEnemy.new(math.random(0, 2))
	elseif ran == 1 then
		enemy = RedEnemy.new()
	elseif ran == 2 then
		enemy = CoinEnemy.new(self.coinBoard)
	elseif ran == 3 then
		enemy = BossEnemy.new()
    end

    self:add(enemy)
    enemy:move()
    table.insert(enemyVector, enemy)
end

function GameScene:UI()
	BackgroundLayer.new():addTo(self)

	self.coinBoard = CoinBoard.new()
	self:add(self.coinBoard)

	self.scoreBoard = ScoreBoard.new()
	self.scoreBoard:setPosition(display.cx, display.height - 35)
	self:add(self.scoreBoard)

	self.cannon = Cannon.new()
	self.cannon:setPosition(display.cx, 5)
	self:add(self.cannon, 1)

	self.buffPanel = BuffPanel.new()
	self:add(self.buffPanel)
	GameManager.setBuffPanel(self.buffPanel)

	self.bulletPanel = BulletPanel.new()
	self:add(self.bulletPanel)

	self.comboBoard = ComboBoard.new()
	self:add(self.comboBoard)

	local pauseBtn = cc.ui.UIPushButton.new({normal = "pause.png", press = "pause.png"}, nil)
	pauseBtn:onButtonClicked(function(event)
		--display.pause()		
		app:enterScene("StartScene", nil, "fade", 0.8)
	end)
	pauseBtn:setPosition(display.width - 30, display.height - 30)
	self:add(pauseBtn,1)

	local shoot = display.newSprite("shoot.png")
	shoot:setPosition(display.width - 130, 150)
	self:add(shoot, 1)
	shoot:setTouchEnabled(true)
	shoot:setTouchSwallowEnabled(false)
	shoot:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
	shoot:addNodeEventListener(cc.NODE_TOUCH_EVENT, function ( event )
		if event.name == "began" then
			self.cannon:actionEffect()
			--self.bulletPanel:reduceBullet()
			
			local bullet = Bullet.new(0)
			bullet:setPosition(display.cx, self.cannon:getPositionY()+self.cannon:getContentSize().height/2-2)
			self:add(bullet)
			transition.moveTo(bullet, {x = display.cx, y = display.height-bullet:getContentSize().height/2, time = GameManager.getAttr().shootSpeed, 
				onComplete = function ()
					bullet:removeFromParent(true)
				end})


			--print(#enemyVector)
		end

		return true
	end)
	
end

function GameScene:setScoreBoardValue(val)
	val = val + self.comboBoard:getComboValue()*3
	if self.doubleScore then
		val = val * 2
	end
	self.scoreBoard:addValue(val)
end

function GameScene:updateBulletPanel()
	self.bulletPanel:addBullet()
end

function GameScene:addComboValue()
	self.comboBoard:addValue()
end

function GameScene:setDoubleScore( value )
	self.doubleScore = value
end

function GameScene:onExit()
	scheduler.unscheduleGlobal(self.handle)
	scheduler.unscheduleGlobal(self.handle1)
	scheduler.unscheduleGlobal(self.handle2)
	cc.Director:getInstance():getEventDispatcher():removeEventListener(self.contactListener)

end

return GameScene