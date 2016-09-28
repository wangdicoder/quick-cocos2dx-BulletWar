
require("config")
require("cocos.init")
require("framework.init")
require("src/app/manager/GameManager")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    cc.FileUtils:getInstance():addSearchPath("res/images")
    display.addSpriteFrames("images/enemylist.plist","images/enemylist.png")
    self:enterScene("StartScene")
    --self:enterScene("GameScene")
end

return MyApp
