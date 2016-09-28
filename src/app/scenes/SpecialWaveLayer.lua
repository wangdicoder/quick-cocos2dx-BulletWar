--
-- Author: wangdi
-- Date: 2016-02-13 17:59:38
--
local SpecialEnemy = import("src/app/view/SpecialEnemy.lua")

local SpecialWaveLayer = class("SpecialWaveLayer", function()
	return display.newLayer()
end)

SpecialWaveType = {}
SpecialWaveType.kSmallWave = 0
SpecialWaveType.kBigWave = 1

SmallWavePosDirToLeft = {
	{display.width+30, 0},	{display.width+80, -30},	{display.width+80, 30}
}

SmallWavePosDirToRight = {
	{-30, 0},	{-80, -30},	{-80, 30}
}

function SpecialWaveLayer:ctor(_type)
	if _type == 0 then 
		self:smallWave()
	else
		self:smallWave()
	end
end

function SpecialWaveLayer:smallWave()
	local t = math.random(0, 2)
	local y = math.random(30, 80)*0.01
	if math.random(0, 1) == 0 then
		for i=1, 3 do
			local se = SpecialEnemy.new(t)			
			self:add(se)
			se:setMoveDirection(EnemyMoveDir.kToRight)
			se:setPosition(cc.p(SmallWavePosDirToRight[i][1], SmallWavePosDirToRight[i][2]+display.height*y))
			se:move()
			
		end
	else
		for i=1, 3 do
			local se = SpecialEnemy.new(t)
			self:add(se)
			se:setMoveDirection(EnemyMoveDir.kToLeft)
			se:setPosition(cc.p(SmallWavePosDirToLeft[i][1], SmallWavePosDirToLeft[i][2]+display.height*y))
			se:move()
			
		end
	end

end

return SpecialWaveLayer