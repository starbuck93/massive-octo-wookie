--project: NerfAppTimerProject
--Adam Starbuck, Ryan Podany 2014

globals = require( "globals" ) -- make this global
coronium = require( "mod_coronium" ) -- make this global
composer = require("composer") -- make this global
widget = require ( "widget" ) -- make this global
ads = require ( "ads" ) -- make this global
json = require ("json")

display.setDefault( "background", 0, 0, 0, 1 )
display.setStatusBar( display.HiddenStatusBar )
-- widget.setTheme( "widget_theme_android_holo_dark" )

-- --== Init Coronium
-- coronium:init({ appId = globals.appId, apiKey = globals.apiKey })

-- --== Store in globals module
-- globals.coronium = coronium

-- --== Start composer
-- display.setStatusBar( display.HiddenStatusBar )

-- coronium:appOpened() --analytics

-------------------------------
-----enable back button-----
-------------------------------

-- Roboto = native.newFont("Roboto")


font1 = 34
font2 = 48
font3 = 60
font4 = 70
font5 = 80

--dynamic fonts. you're welcome.
if display.contentWidth < 720 and display.contentHeight < 1080 then
	font1 = font1-(font1*0.1)
	font2 = font2-(font2*0.1) 
	font3 = font3-(font3*0.1)
	font4 = font4-(font4*0.1)
	font5 = font5-(font5*0.1)
end


function helpFunction()
	composer:gotoScene("help")
	--coronium:addEvent( "helpEvent", "Help! " .. username)
end

help = widget.newButton --another global value that we can edit the alpha of
{
	id = "helpMe",
    label = "?",
    fontSize = font3,
    font = "Roboto",
    onRelease = helpFunction,
    shape="circle",
    height = 1,
	labelColor = { default={ 1, 1, 1}, over={ 96/255, 96/255, 96/255, 1 } },
	fillColor = { default={ 96/255, 96/255, 96/255, 1}, over={ 1, 1, 1, .5 } },
	radius = 50,
	emboss = true
}
help.x = display.contentWidth-20
help.y = 10
help.anchorX = 1
help.anchorY = 0
help.alpha = 0

	local options =
{
    effect = "fade",
    time = 1000,
}
	composer.gotoScene("menu", options)
