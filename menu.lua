--scene: menu
local xCenter = display.contentWidth
local yCenter = display.contentHeight
local scene = composer.newScene()
local localGroup = display.newGroup()


--Called if the scene hasn't been previously seen
function scene:create( event )

	help.alpha = 1
	help.font = "Roboto"

	function settingsFunction()
		composer:gotoScene("settings")
	end
	local settings = widget.newButton --another global value that we can edit the alpha of
	{
		id = "settingsMe",
	    label = "S",
	    fontSize = font3,
   		font = "Roboto", 
	    onRelease = settingsFunction,
	    shape="circle",
	    height = 1,
		labelColor = { default={ 1, 1, 1}, over={ 96/255, 96/255, 96/255, 1 } },
		fillColor = { default={ 96/255, 96/255, 96/255, 1}, over={ 1, 1, 1, .5 } },
		radius = 50,
		emboss = true
	}
	settings.x = 20
	settings.y = 10
	settings.anchorX = 0
	settings.anchorY = 0
	-- settings.alpha = 1

	--Icon-xxxhdpi.png
	local myImage = display.newImage( "playstore-icon.png" )
		myImage.x = xCenter/2
		myImage.y = yCenter/4


	local options1 = {
		text = "loading...",
		x = display.contentCenterX, 
		y = display.contentCenterY, 
		font = "Roboto", 
		fontSize = font3,
		width = display.actualContentWidth-40,
		align = "center"}
	local temp = display.newText( options1 )
	-- local temp2 = display.newText( options1 )
	-- 	temp2.y = temp.y+50
	local temp3 = display.newText( options1 )
		temp3.y = temp.y+75

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
	local bitcoinTime = display.newText( options2 )
		bitcoinTime.y = bitcoin.y+50
	local autoRe = display.newText( options2 )

	local encoded = ""
	local encodedBitcoin = ""
	local weatherTable = {}
	local bitcoinTable = {}
	local coindeskPrices = {}
	local currentTemp = ""
	local currentWind = ""
	local currentBitcoinPrice = ""
	local updatedTimeBitcoin = ""
	local weatherTimeVar1 = ""
	local encodedPricesCoindesk = ""
	local btc_to_usd = ""

	local function networkListener( event )
	    if ( event.isError ) then
	        print( "Network error!" )
	    else
	        encoded = event.response
	        weatherTable = json.decode( encoded )
        	currentTemp = weatherTable.main["temp"] --current temperature in Kelvin
        	currentWind = weatherTable.wind["speed"] 
        	weatherTimeVar1 = weatherTable.dt
	    	
	    end
	end

	local function networkListenerBitcoin( event )
	    if ( event.isError ) then
	        print( "Network error!" )
	    else
	        encodedBitcoin = event.response
	        bitcoinTable = json.decode( encodedBitcoin )
        	currentBitcoinPrice = bitcoinTable.bpi.USD["rate"]
        	updatedTimeBitcoin = bitcoinTable.time.updated
	    end
	end
	local function networkCoindeskPrices( event )
	    if ( event.isError ) then
	        print( "Network error!" )
	    else
	    	encodedPricesCoindesk = event.response
	        coindeskPrices = json.decode( encodedPricesCoindesk )
	        btc_to_usd = coindeskPrices["amount"]
	        print("$" .. btc_to_usd .. " on coindesk")
	    end
	end
	
	local function updateText( ... )
		temp.text = ((tonumber(currentTemp)-273.15)*(9/5))+32 .. " F"
		-- temp2.text = "Feels like " .. currentFeelsLike .. " F"
		temp3.text = "Wind is " .. currentWind .. " MPH"
		-- temp4.text = os.date("%c",1422208800)
		temp4.text = os.date("Last updated %b %d, %Y %H:%M:%S CST", weatherTimeVar1)
		-- bitcoin.text = "$" .. currentBitcoinPrice .. " per Bitcoin"
		bitcoin.text = "$" .. btc_to_usd .. " per Bitcoin"
		bitcoinTime.text = "Last updated " .. updatedTimeBitcoin
	end

	local function getWeather( event )
		network.request( "http://api.openweathermap.org/data/2.5/weather?q=Abilene,tx&APPID=a177751774b84b3fe9d891b9cf2f36d5", "GET", networkListener )
		-- network.request( "http://api.wunderground.com/api/9e2343119ccebae7/conditions/q/79601.json", "GET", networkListener )
		timer.performWithDelay( 1000, updateText )
	end

	local function getBitcoin( event )
		-- http(s)://api.coindesk.com/v1/bpi/currentprice.json
		network.request( "https://api.coinbase.com/v1/prices/spot_rate?currency=USD", "GET", networkCoindeskPrices)
		network.request( "http://api.coindesk.com/v1/bpi/currentprice.json", "GET", networkListenerBitcoin )
		timer.performWithDelay( 1000, updateText )
	end

	local function getStuff(  )
		print("Getting Stuff")
		getWeather()
		getBitcoin()
	end

	local refreshButton = widget.newButton{
	    label = "refresh",
	    onRelease = getStuff,
	    emboss = true,
	    shape="roundedRect",
		fontSize = font2,
		font = "Roboto",
	    width = 300,
	    height = 75,
	    cornerRadius = 25,
		labelColor = { default={ 1, 1, 1}, over={ 96/255, 96/255, 96/255, 1 } },
		fillColor = { default={ 96/255, 96/255, 96/255, 1}, over={ 1, 1, 1, .5 } },
	}
		refreshButton.x = display.contentWidth/2
		refreshButton.y = 10
		refreshButton.anchorY = 0

	local options3 = {
		text = "loading...",
		x = display.contentCenterX, 
		y = bitcoinTime.y+100, 
		fontSize = font5+20,
		font = "Roboto",
		width = display.actualContentWidth-40,
		align = "center"}
	local clockText = display.newText( options3 )


	local function clockTime( ... )
		clockText.text = os.date( "%X %p" )
	end
	timer.performWithDelay( 500, clockTime, -1)

	local function autoRefreshFunction( ... )
		refresh = timer.performWithDelay( 10000, getStuff, -1 )
		print("AutoRefresh on")
		-- to cancel, use timer.cancel

	function cancelAutoR( ... )
	        timer.cancel( refresh ) 
	        print("Cancelled AutoRefresh")
	end

	end

	local function onSwitchPress( event )
	    local switch = event.target
	    if switch.isOn then
	    	autoRefreshFunction()
	    else cancelAutoR()
	    end
	end

	local onOffSwitch = widget.newSwitch
	{
	    left = 50,
	    top = 200,
	    style = "onOff",
	    id = "onOffSwitch",
	    onRelease = onSwitchPress
	}
	autoRe.text = "Auto-Refresh"
	autoRe.x = 100
	autoRe.y = 175


	network.request( "http://api.openweathermap.org/data/2.5/weather?q=Abilene,tx&APPID=a177751774b84b3fe9d891b9cf2f36d5", "GET", networkListener )
	-- network.request( "http://api.wunderground.com/api/9e2343119ccebae7/conditions/q/79601.json", "GET", networkListener )
	--this one beneath here gets the forcast and I need to find somewhere to put it
	-- network.request("http://api.openweathermap.org/data/2.5/forecast/daily?q=Abilene,tx&mode=json&cnt=2&units=imperial", "GET", networkListener3)
	--bitcoin
	network.request( "http://api.coindesk.com/v1/bpi/currentprice.json", "GET", networkListenerBitcoin )
	network.request( "https://api.coinbase.com/v1/prices/spot_rate?currency=USD", "GET", networkCoindeskPrices)
	--Ads Loading Here
	-- ads.init( "admob", "ca-app-pub-1135191116314099/8859539762" )
	-- ads.show( "banner", { x=0, y=yCenter})

	localGroup:insert(settings)
	localGroup:insert(temp)
	localGroup:insert(clockText)
	localGroup:insert(temp3)
	localGroup:insert(temp4)
	localGroup:insert(refreshButton)
	localGroup:insert(bitcoin)
	localGroup:insert(bitcoinTime)
	localGroup:insert(myImage)
	localGroup:insert(onOffSwitch)

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

