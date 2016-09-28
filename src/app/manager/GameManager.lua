--
-- Author: wangdi
-- Date: 2016-02-09 00:13:55
--

local GameManager = {}

buffVector = {}
enemyVector = {}

local buffPanel = nil

local attribution = {
	specialWaveNum = 10,
	maxBuffNum = 5,
	maxBulletShootNum = 10,
	maxBulletSplitNum = 10,
	moreEnemiesDuration = 10,
	specialBulletDuration = 10,
	freeBulletDuration = 10,
	bulletPower = 1,
	coinRainValue = 5,
	coinRainDuration = 8,
	coinEnemySplitValue = 5,
	coinEnemySplitNum = 8,	
	doubleScoreDuration = 10,
	shootSpeed = 2
}

function GameManager.getAttr()
	return attribution
end

function GameManager.setBuffPanel( _buffPanel )
	buffPanel = _buffPanel
end

function GameManager.getBuffPanel()
	return buffPanel
end

return GameManager