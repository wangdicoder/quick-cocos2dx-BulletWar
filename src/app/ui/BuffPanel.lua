--
-- Author: wangdi
-- Date: 2016-02-12 21:11:32
--
local BuffPanel = class("BuffPanel", function()
	return display.newLayer()
end)

posX = {
	{display.cx},
	{display.cx - 40, display.cx + 40},
	{display.cx - 80, display.cx, display.cx + 80},
	{display.cx - 120, display.cx - 40, display.cx + 40, display.cx + 120},
	{display.cx - 160, display.cx - 80, display.cx, display.cx + 80, display.cx + 160},
	{display.cx - 200, display.cx - 120, display.cx - 40, display.cx + 40, display.cx + 120, display.cx + 200}
}

function BuffPanel:ctor()	
	self.posY = display.height*0.75
end

function BuffPanel:addBuff(node)
	table.insert(buffVector, node)
	self.buffNode = node
	local index = #buffVector
	self:updateBuffPosition(#buffVector-1)

	transition.execute(node, cca.scaleTo(0.1, 0, 0, 1), {
		onComplete = function()
			node:rotation(0)
			node:setPosition(posX[index][index], self.posY)
		end})
	transition.execute(node, cca.scaleTo(0.1, 1, 1, 1), {delay = 0.1,
		onComplete = function ()
			node:addTimer(self)
		end})
end

function BuffPanel:updateBuffPosition(length)
	for i=1, length do
		transition.execute(buffVector[i], cc.MoveTo:create(0.3, cc.p(posX[#buffVector][i], self.posY)), {easing = "exponentialOut",
			onComplete = function()

			end})
	end
end

return BuffPanel