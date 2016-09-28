--
-- Author: wangdi
-- Date: 2016-02-15 06:37:05
--
local BackgroundLayer = class("BackgroundLayer", function()
	return display.newLayer()
end)

function BackgroundLayer:ctor()
	local bg = display.newSprite("bg.png", display.cx, display.cy)
	bg:setScaleX(64)
	self:add(bg)

    local groundClound = display.newSprite("cloud_groud.png")
    groundClound:setPosition(display.cx, display.bottom+150)
    self:add(groundClound)

    local tree1 = display.newSprite("tree2.png", display.cx-15, display.bottom+90)
    self:add(tree1)

	local tree2 = display.newSprite("tree1.png", display.width*0.05, display.bottom+130)
    self:add(tree2)

    local tree3 = display.newSprite("tree3.png", display.width*0.2, display.bottom+120)
    tree3:setScaleX(1.1)
    self:add(tree3)

    local tree4 = display.newSprite("tree3.png", display.width*0.3, display.bottom+170)
    tree4:setScaleY(1.2)
    self:add(tree4)

    local tree5 = display.newSprite("tree5.png", display.width*0.25, display.bottom+40)
    self:add(tree5)

    local tree6 = display.newSprite("tree4.png", display.width*0.75, display.bottom+170)
    self:add(tree6)

	local tree7 = display.newSprite("tree1.png", display.width*0.92, display.bottom+120)
    self:add(tree7)

    local tree8 = display.newSprite("tree1.png", display.width*0.83, display.bottom+50)
    tree8:setScaleX(0.9)
    self:add(tree8)

    local star = cc.ParticleSystemQuad:create("particles/star.plist")
    star:setPosition(display.cx, 20)
    self:add(star)

    local ground1 = display.newSprite("ground.png")
    ground1:setPosition(ground1:getContentSize().width/2 - 20, ground1:getContentSize().height/2-65)
    self:add(ground1)

    local ground2 = display.newSprite("ground.png")
    ground2:setPosition(ground1:getPositionX()+ ground2:getContentSize().width-10, ground1:getPositionY())
    self:add(ground2)
end

return BackgroundLayer