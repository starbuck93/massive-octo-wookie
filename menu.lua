--scene: menu
local xCenter = display.contentWidth
local yCenter = display.contentHeight
local scene = composer.newScene()
local localGroup = display.newGroup()


--Called if the scene hasn't been previously seen
function scene:create( event )

	help.alpha = 1
	native.newFont("Roboto")

	function settingsFunction()
		composer:gotoScene("settings")
	end
	local settings = widget.newButton --another global value that we can edit the alpha of
	{
		id = "settingsMe",
	    label = "S",
		font = "Roboto", 
	    fontSize = 60,
	    onRelease = settingsFunction,
	    shape="circle",
	    height = 1,
		labelColor = { default={ 1, 1, 1}, over={ 96/255, 96/255, 96/255, 1 } },
		fillColor = { default={ 96/255, 96/255, 96/255, 1}, over={ 1, 1, 1, .5 } },
		radius = 40,
		emboss = true
	}
	settings.x = 10
	settings.y = 10
	settings.anchorX = 0
	settings.anchorY = 0
	-- settings.alpha = 1

--Icon-xxhdpi.png
	local myImage = display.newImage( "Icon-xxxhdpi.png" )
	myImage.x = xCenter/2
	myImage.y = yCenter/4


	local options1 = {
	text = "loading...",
	x = display.contentCenterX, 
	y = display.contentCenterY, 
	font = "Roboto", 
	fontSize = font2,
	width = display.actualContentWidth-40,
	align = "center"}
	local temp = display.newText( options1 )
	local temp2 = display.newText( options1 )
	temp2.y = temp.y+50
	local temp3 = display.newText( options1 )
	temp3.y = temp2.y+50

	local options2 = {
	text = "loading...",
	x = display.contentCenterX, 
	y = display.contentCenterY, 
	font = "Roboto", 
	fontSize = font1,
	width = display.actualContentWidth-40,
	align = "center"}

	local temp4 = display.newText( options2 )
	temp4.y = temp3.y+50

	local bitcoin = display.newText( options1 )
	bitcoin.y = temp4.y+100

	local encoded = ""
	local encodedBitcoin = ""
	local weatherTable = {}
	local bitcoinTable = {}
	local currentTemp = ""
	local currentFeelsLike = ""
	local currentWind = ""
	local updatedTime = ""
	local currentBitcoinPrice = ""

	local function networkListener( event )
	    if ( event.isError ) then
	        print( "Network error!" )
	    else
	        encoded = event.response
	        weatherTable = json.decode( encoded )
        	currentTemp = weatherTable.current_observation["temp_f"] --current temperature
        	currentFeelsLike = weatherTable.current_observation["feelslike_f"] --feels like current temp
        	currentWind = weatherTable.current_observation["wind_string"] --wind string
        	updatedTime = weatherTable.current_observation["observation_time"]
	    end
	end

	local function networkListenerBitcoin( event )
	    if ( event.isError ) then
	        print( "Network error!" )
	    else
	        encodedBitcoin = event.response
	        bitcoinTable = json.decode( encodedBitcoin )
        	currentBitcoinPrice = bitcoinTable.bpi.USD["rate"]
	    end
	end
	
	function updateText( ... )
		temp.text = currentTemp .. " F"
		temp2.text = "Feels like " .. currentFeelsLike .. " F"
		temp3.text = currentWind
		temp4.text = updatedTime
		bitcoin.text = "$" .. currentBitcoinPrice .. " per Bitcoin."
	end

	function getWeather( event )
		network.request( "http://api.wunderground.com/api/9e2343119ccebae7/conditions/q/79601.json", "GET", networkListener )
		timer.performWithDelay( 1000, updateText )
	end

	function getBitcoin( event )
		-- http(s)://api.coindesk.com/v1/bpi/currentprice.json
		network.request( "http://api.coindesk.com/v1/bpi/currentprice.json", "GET", networkListenerBitcoin )
		timer.performWithDelay( 1000, updateText )
	end

	local refreshButton = widget.newButton{
	    label = "refresh",
	    onRelease = getWeather,
	    emboss = true,
	    --properties for a rounded rectangle button...
	    shape="roundedRect",
		fontSize = font1,
	    width = 200,
	    height = 50,
	    cornerRadius = 20,
		labelColor = { default={ 1, 1, 1}, over={ 96/255, 96/255, 96/255, 1 } },
		fillColor = { default={ 96/255, 96/255, 96/255, 1}, over={ 1, 1, 1, .5 } },
	}
	refreshButton.x = display.contentWidth/2
	refreshButton.y = 10
	refreshButton.anchorY = 0

	--network.request( "http://api.openweathermap.org/data/2.5/weather?q=Abilene,tx&APPID=a177751774b84b3fe9d891b9cf2f36d5", "GET", networkListener )
	network.request( "http://api.wunderground.com/api/9e2343119ccebae7/conditions/q/79601.json", "GET", networkListener )
	
	--bitcoin
	network.request( "http://api.coindesk.com/v1/bpi/currentprice.json", "GET", networkListenerBitcoin )




	--http://api.wunderground.com/api/9e2343119ccebae7/features/settings/q/query.format
	--Ads Loading Here
	ads.init( "admob", "ca-app-pub-1135191116314099/8859539762" )
	ads.show( "banner", { x=0, y=yCenter})

	localGroup:insert(settings)
	localGroup:insert(temp)
	localGroup:insert(temp2)
	localGroup:insert(temp3)
	localGroup:insert(temp4)
	-- localGroup:insert(settings)
	timer.performWithDelay( 2000, updateText )
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

