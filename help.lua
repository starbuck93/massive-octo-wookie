
--====================================================================--
-- SCENE: HALP
--====================================================================--


local xCenter = display.contentCenterX
local yCenter = display.contentCenterY
local localGroup = display.newGroup()
local scene = composer.newScene()

function scene:create( event )

	--Ads Loading Here
	ads.init( "admob", "ca-app-pub-1135191116314099/8859539762" )
	ads.show( "banner", { x=0, y=display.contentHeight})

	local options = {
		text ="Powered by CoinDesk",
		x = display.contentCenterX, 
		y = 100, 
		font = "Roboto", 
		fontSize = font2,
		width = display.actualContentWidth-40,
		align = "center"}
	local poweredBy = display.newText(options)
	local options2 = {
		text ="And by OpenWeatherMap",
		x = display.contentCenterX, 
		y = 200, 
		font = "Roboto", 
		fontSize = font2,
		width = display.actualContentWidth-40,
		align = "center"}
	local weatherLink = display.newText(options2)

	local back = widget.newButton{
	 	width = 200,
	 	height = 75,
        left = 5,
        top = 5,
        id = "back",
        label = "<-- back",
        fontSize = font2,
        font = "Roboto",
        labelColor = { default={ 1, 1, 1}, over={ 232/255, 100/255, 37/255, 1 } },
        location = composer.getSceneName( "previous" ),
        onRelease = function() composer.gotoScene(location); end, --ads.hide();
    }
    location = composer.getSceneName( "previous" )

	local url1 = "http://www.coindesk.com/price/"
	local url2 = "http://m.openweathermap.com"
	function deskListener( event )
		system.openURL( url1 )
	end
	function weatherListener( event )
		system.openURL( url2 )
	end


	localGroup:insert( back )
	localGroup:insert( poweredBy )
	localGroup:insert( weatherLink )

	poweredBy:addEventListener( "tap", deskListener )
	weatherLink:addEventListener( "tap", weatherListener )

end


function scene:show(event)
	localGroup.alpha = 1
	composer.removeHidden( true )
end

function scene:hide(event)
	localGroup.alpha = 0
end

-- "createScene" is called whenever the scene is FIRST called
scene:addEventListener( "create", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "show", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "hide", scene )

return scene