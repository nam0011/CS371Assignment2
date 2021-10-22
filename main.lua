local widget = require("widget")
local low = false; --checks if it is low
local high = false; --checks if it is high

--creation of background
local background = display.newImageRect("triangles.png", 1920, 1080)
background.x = display.contentCenterX
background.y = display.contentCenterY


--animation frame locations
local opt = 
{
  frames = {
    {x = 5, y = 17, width = 43, height = 81}, -- idle 1 1
    {x = 50, y = 17, width = 43, height = 81}, -- idle 2 2
    {x = 100, y = 17, width = 43, height = 81}, -- idle 3 3
    {x = 150, y = 17, width = 43, height = 81}, -- idle 4 4

    {x = 205, y = 17, width = 43, height = 81}, -- walking 1 5
    {x = 250, y = 17, width = 43, height = 81}, -- walking 2 6
    {x = 300, y = 17, width = 43, height = 81}, -- walking 3 7
    {x = 350, y = 17, width = 43, height = 81}, -- walking 4 8
    {x = 400, y = 17, width = 43, height = 81}, -- walking 5 9

    {x = 5, y = 130, width = 43, height = 81}, -- left punch 1 10
    {x = 50, y = 130, width = 60, height = 81}, -- left punch 2 11
    {x = 117, y = 133, width = 43, height = 81}, -- left punch 3 12

    {x = 170, y = 133, width = 43, height = 81}, -- right punch 1 13 
    {x = 216, y = 128, width = 56, height = 85}, -- right punch 2 14
    {x = 276, y = 130, width = 73, height = 85}, -- right punch 3 15
    {x = 355, y = 125, width = 53, height = 90}, -- right punch 4 16
    {x = 405, y = 125, width = 53, height = 90}, -- right punch 5 17

    {x = 5, y = 260, width = 53, height = 90}, -- low kick 1 18
    {x = 57, y = 260, width = 76, height = 90}, -- low kick 2 19
    {x = 132, y = 260, width = 56, height = 90}, -- low kick 3 20

    {x = 188, y = 260, width = 56, height = 90}; -- high kick 1 21
    {x = 244, y = 259, width = 56, height = 90}, -- high kick 2 22
    {x = 303, y =  259, width = 75, height = 90}, -- high kick 3 23 
    {x = 381, y = 258, width = 65, height = 90}, --high kick 4 24
    {x = 443, y = 265, width = 54, height = 85} -- high kick 5 25

  }
}

--creating sprite sheet
local ryu = graphics.newImageSheet( "ryu.png", opt);

--creation of action sequences
local seqData = {
  {name = "idle", start = 1, count = 4, time = 200}, --idle sequence for when ryu does nothing
  {name = "walk", start = 5, count = 4, time = 800}, --walking sequence if moving
  {name = "left punch", start = 10, count =  3, time = 800}, -- left punch sequence
  {name = "right punch", start = 13, count = 5, time = 800}, -- right punch sequence
  {name = "low kick", start = 18, count = 3, time = 800}, -- low kick sequence
  {name = "high kick", start = 21, count = 5, time = 600}, -- high kick sequence

}



--block to display ryu above background
local anim = display.newSprite(ryu, seqData); --display the sprite
anim.anchorX = 0.0; --x anchor
anim.anchorY = 0.0; --y anchor
anim.x  = display.contentCenterX; --init x position
anim.y = display.contentCenterY-300; -- init y position
anim.xScale = 5; -- x scale of sprite
anim.yScale = 5; -- y scale of sprite
anim:setSequence("idle"); -- initial sequence



local function highButtonPress(event)
  local switch = event.target
  high = true --setting high to true for the high kick and right punch
  low = false 
  --anim:setSequence("high kick") -- set to high kick
end

local function lowButtonPress(event)
  local switch = event.target
  high = false
  low = true --setting the low to true for the low kick and right punch
  --anim:setSequence("high kick") -- set to low kick
end


local function startAnim()  --getter for animation play function
    anim:play()
end

local function endAnim()  --pasue and reset to standing
  anim:pause() --pause animation
  anim:setSequence("idle") -- reset to standing position

end

local function highKick(event)
    anim:setSequence("high kick")--start
    transition.to( anim, {time = 2000, x = anim.x, y = anim.y, transition = easing.linear, onStart = startAnim, onComplete = endAnim} )
end

--Runtime:addEventListener( "tap", highKick ) --runtime evenet listener for screen to always be checking for event


local radioGroup = display.newGroup()

local radioButtonHigh = widget.newSwitch( 
  {
    x = 300,
    y = 900,
    style = "radio",
    id = "High",
    initialSwitchState = false,
    onPress = highButtonPress
  }
 )

radioGroup:insert(radioButtonHigh)


local radioButtonLow = widget.newSwitch( 
  {
    x = 300,
    y = 800,
    style = "radio",
    id = "Low",
    initialSwitchState = false,
    onPress = lowButtonPress
  }
 )

radioGroup:insert(radioButtonLow)


local textGroup = display.newGroup()

local highText = display.newText( 
  {
    text = "HIGH",
    x = 225,
    y = 900,
    fontSize = 40
  } 
)
highText:setFillColor(1,1,1)

textGroup:insert(highText)

local lowText = display.newText( 
  {
    text = "LOW",
    x = 225,
    y = 800,
    fontSize = 40
  } 
)
highText:setFillColor(1,1,1)

textGroup:insert(lowText)

local function kickButtonEvent( event )
    if (low == true and high == false) then
      anim:setSequence("low kick")
      transition.to( anim, {time = 800, x = anim.x, y = anim.y, transition = easing.linear, onStart = startAnim, onComplete = endAnim} )
    end
    if (low == false and high == true) then
      anim:setSequence("high kick")
      transition.to( anim, {time = 800, x = anim.x, y = anim.y, transition = easing.linear, onStart = startAnim, onComplete = endAnim} )
    end
    if ( "ended" == event.phase ) then
        print( "Kick was pressed and released" )
    end

end
 
local function punchButtonEvent( event )
    if (low == true and high == false) then
      anim:setSequence("left punch")
      transition.to( anim, {time = 800, x = anim.x, y = anim.y, transition = easing.linear, onStart = startAnim, onComplete = endAnim} )
    end
    if (low == false and high == true) then
      anim:setSequence("right punch")
      transition.to( anim, {time = 800, x = anim.x, y = anim.y, transition = easing.linear, onStart = startAnim, onComplete = endAnim} )
    end
    if ( "ended" == event.phase ) then
        print( "Punch was pressed and released" )
    end
end

local kickButtonBackground = display.newRoundedRect(500,775,200,100, 25)
  kickButtonBackground:setFillColor(0, 0, 0, 0.8)
local punchButtonBackground = display.newRoundedRect(500,900,200,100, 25)
  punchButtonBackground:setFillColor(0, 0, 0, 0.8)

local kickButton = widget.newButton(
    {
        x = 500,
        y = 775,
        id = "button1",
        label = "Kick",
        fontSize = 50,
        onEvent = kickButtonEvent
    }
)

local punchButton = widget.newButton(
    {
        
        x = 500,
        y = 900,
        id = "button2",
        label = "Punch",
        fontSize = 50,
        onEvent = punchButtonEvent
    }
)




------slider functions-------

local sliderBackground = display.newRoundedRect(1200,850,650, 350, 25)
  sliderBackground:setFillColor(0, 0, 0, 0.8)

-- Slider listener
local function sliderListener( event )
    print( "Slider at " .. event.value .. "%" )
end

local sizeText = display.newText( 
  {
    text = "SIZE",
    x = 1000,
    y = 750,
    fontSize = 40
  } 
)

highText:setFillColor(1,1,1)
 
-- Create the widget
local slider = widget.newSlider(
    {
        x = 1300,
        y = 750,
        width = 400,
        value = 10,  -- Start slider at 10% (optional)
        listener = sliderListener
    }
)


local lowText = display.newText( 
  {
    text = "Hor Move",
    x = 1000,
    y = 850,
    fontSize = 40
  } 
)
highText:setFillColor(1,1,1)

-- Create the widget
local slider = widget.newSlider(
    {
        x = 1300,
        y = 850,
        width = 400,
        value = 10,  -- Start slider at 10% (optional)
        listener = sliderListener
    }
)


local lowText = display.newText( 
  {
    text = "Rotate",
    x = 1000,
    y = 950,
    fontSize = 40
  } 
)
highText:setFillColor(1,1,1)

-- Create the widget
local slider = widget.newSlider(
    {
        x = 1300,
        y = 950,
        width = 400,
        value = 10,  -- Start slider at 10% (optional)
        listener = sliderListener
    }
)