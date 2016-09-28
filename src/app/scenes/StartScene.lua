--
-- Author: wangdi
-- Date: 2016-02-09 00:10:14
--
local BackgroundLayer = import("src/app/scenes/BackgroundLayer.lua")
local PurchaseLayer = import("src/app/scenes/PurchaseLayer.lua")

local StartScene = class("StartScene", function()
    return display.newScene("StartScene")
end)

function StartScene:ctor()
    self:UI()    
    self:exitAndStart()    
end

function StartScene:UI()
    BackgroundLayer.new():addTo(self)

    local title = display.newSprite("title.png", display.cx, display.height*0.65)
    self:addChild(title)

    local startTip = display.newSprite("tips_start.png", display.cx, display.height*0.2)
    self:addChild(startTip)
    startTip:runAction(cca.repeatForever(transition.sequence({cca.fadeOut(0.8), cca.fadeIn(0.8)})))

	self:addButton()
end

function StartScene:addButton()
	local shopBtn = cc.ui.UIPushButton.new({normal = "shop.png", press = "shop.png"}, nil)
	shopBtn:onButtonClicked(function(event)
		self:add(PurchaseLayer.new())
	end)
	shopBtn:setPosition(display.width - 30, display.height - 30)
	self:addChild(shopBtn, 1)
end

function StartScene:exitAndStart()
	local layer = display.newLayer()
	self:addChild(layer)
	layer:setKeypadEnabled(true)
	layer:addNodeEventListener(cc.KEYPAD_EVENT, function(event)
		if event.key == 'back' then
			luaj.callStaticMethod("org/cocos2dx/lua/AppActivity", "exit")
		end
	end)

	layer:setTouchEnabled(true)
	layer:setTouchSwallowEnabled(true)
	layer:setTouchMode(cc.TOUCH_MODE_ONE_BY_ONE)
	layer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function (event)
		if event.name == 'ended' then
			app:enterScene("GameScene", nil, "fade", 0.8)
		end

		return true
	end)
end

return StartScene