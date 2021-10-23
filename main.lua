--[[
Nathan Moore
Aaron Mendez

CS 371 - Mobile Application Development
Dr. Haeyong Chung

Programming Assignment Two - Interactive Sprite App
  This application builds an interactive Ryu sprite and plays sounds when specific animations are selected
  Ryu Has Four Moves:
    Left Punch
    Right Punch
    Low Kick
    High Kick
  Ryu also plays a walking animation when the horizontal movement slider is being moved
  The user can:
    Alter the Position along the x-axis with the slider labeled: Hor. Move
    Change the Rotation of Ryu by changing the value of the Rot Slider
    Increase the Size of Ryu with the Size slider
  Application has a 1080p background imagine found online - not original material
  This application only supports landscape mode and can alter betweeen landscapeLeft and landscapeRight

]]--

local widget = require("widget") --require the widget library
local low = false; --checks if it is low
local high = false; --checks if it is high

local kickSound = audio.loadSound( "kick.mp3" ) --initialize kick sound to kick.mp3
local punchSound = audio.loadSound( "punch.mp3" ) --intialize punch sound to punch.mp3

--creation of background
local background = display.newImageRect("triangles.png", 1920, 1080) -- pass in the image with the correct pixel size
background.x = display.contentCenterX --center the background with the x and y axis
background.y = display.contentCenterY


-----------animation frame locations-------------------
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



------------------Displaying Ryu--------------------
local anim = display.newSprite(ryu, seqData); --display the sprite
anim.anchorX = 0.0; --x anchor
anim.anchorY = 0.0; --y anchor
anim.x  = display.contentCenterX; --init x position
anim.y = display.contentCenterY-300; -- init y position
anim.xScale = 5; -- x scale of sprite
anim.yScale = 5; -- y scale of sprite
anim:setSequence("idle"); -- initial sequence



----------Event Listener Area---------------------
--high button event listener
local function highButtonPress(event)
  local switch = event.target --switch changes if user clicks the target
  high = true --setting high to true for the high kick and right punch
  low = false 
  --anim:setSequence("high kick") -- set to high kick
end

--low button event listener
local function lowButtonPress(event)
  local switch = event.target--switch changes if user clicks the target
  high = false
  low = true --setting the low to true for the low kick and right punch
  --anim:setSequence("high kick") -- set to low kick
end

--function to start playing the animation
local function startAnim()  --getter for animation play function
    anim:play() --call the animated sprite to start playing an animation
end

--function to end playing the animation
local function endAnim()  --pasue and reset to standing
  anim:pause() --pause animation
  anim:setSequence("idle") -- reset to standing position
end

--high kick animation event listener
local function highKick(event)  
    anim:setSequence("high kick")--set animation to high kick seqData values
    transition.to( anim, {time = 2000, x = anim.x, y = anim.y, transition = easing.linear, onStart = startAnim, onComplete = endAnim}) -- transition though animation for 2 seconds
end

local function kickButtonEvent( event ) -- kick button event listener
    if (low == true and high == false) then --if low button is selected
      anim:setSequence("low kick") --set animation to low kick
      audio.play( kickSound ) -- play sound for kicking
      transition.to( anim, {time = 800, x = anim.x, y = anim.y, transition = easing.linear, onStart = startAnim, onComplete = endAnim} ) --transition through animation in 800 ms
    end
    if (low == false and high == true) then -- if the high button is clicked
      anim:setSequence("high kick") --set the animation to high kick
      audio.play( kickSound ) -- play sound for kicking
      transition.to( anim, {time = 800, x = anim.x, y = anim.y, transition = easing.linear, onStart = startAnim, onComplete = endAnim} ) -- transition through the animation in 800 ms
    end
    if ( "ended" == event.phase ) then -- if phase is ended
        print( "Kick was pressed and released" ) --pass a debug script to the console
    end

end
 
local function punchButtonEvent( event ) -- punch button event listener
    if (low == true and high == false) then -- if the low button is pressed
      anim:setSequence("left punch") --set the left punch animation as the loaded animation sequence
      audio.play( punchSound ) -- play the punch sounds
      transition.to( anim, {time = 800, x = anim.x, y = anim.y, transition = easing.linear, onStart = startAnim, onComplete = endAnim} ) --play the animation for 800ms
    end
    if (low == false and high == true) then --if the high button is pressed
      anim:setSequence("right punch") -- set the right punch animation as the loaded animation sequence
      audio.play( punchSound ) --play punch sound
      transition.to( anim, {time = 800, x = anim.x, y = anim.y, transition = easing.linear, onStart = startAnim, onComplete = endAnim} )--play the animation for 800ms
    end
    if ( "ended" == event.phase ) then --if the event phase is ending 
        print( "Punch was pressed and released" ) --print a debug script to the console
    end
end

-- Size Slider listener
local function sizeListener( event ) 
      if(event.value <= 5) then --default size is 5 dont get smaller than this
        anim.xScale = 5; -- x scale of sprite
        anim.yScale = 5; -- y scale of sprite
      elseif(event.value > 15 and event.value < 100) then
        anim.xScale = event.value * 0.3; -- scale sprite from 5->30 size on y axis
        anim.yScale = event.value * 0.3; -- scale sprite from 5->30 size on y axis
      end
      
end


-- Horizontal Movement Slider listener
local function horMoveListener( event )
      anim:setSequence("walk") --set the animation to walk
      if (anim.x < display.contentWidth) then  -- as long as the x value is on the screen
        transition.to( anim, {time = 500, x = event.value*16, y = anim.y, transition = easing.linear, onStart = startAnim, onComplete = endAnim} ) --transition trough animation in 800ms
      end
end

-- Rotate Slider listener
local function rotateListener( event )
  anim:rotate(1.8) --rotate the player 1.8 degrees clockwise for each percentage of slider
end


------------Radio Button/Switch Creation-------------------
local radioGroup = display.newGroup() --create a new group for the buttons

--HIGH button creation
local radioButtonHigh = widget.newSwitch( 
  {
    x = 300,  --x and y location values in pixels
    y = 900,
    style = "radio",  --setting type of button to radio
    id = "High", --give the button an id
    initialSwitchState = false, --initialize the state of the button to not selected
    onPress = highButtonPress -- pass the event listener for this button to the handler
  }
 )
radioGroup:insert(radioButtonHigh) --insert the high button to the button group

--LOW button creation
local radioButtonLow = widget.newSwitch( 
  {
    x = 300, --x and y values in pixels
    y = 800,
    style = "radio", --setting the button type
    id = "Low", --give the button an id
    initialSwitchState = false, --initialize the state of the button to not selected
    onPress = lowButtonPress --pass the low button event listener to the handler
  }
 )
radioGroup:insert(radioButtonLow) --insert the low button to the button group


--------------Text Background Creation--------------
local kickButtonBackground = display.newRoundedRect(500,775,200,100, 25) --display a new rounded box for the kick button
  kickButtonBackground:setFillColor(0, 0, 0, 0.8) --set the transparency to 80%

local punchButtonBackground = display.newRoundedRect(500,900,200,100, 25)--display a new rounded box for the punch button
  punchButtonBackground:setFillColor(0, 0, 0, 0.8)--set the transparency to 80%

local sliderBackground = display.newRoundedRect(1200,850,650, 350, 25)--display a new rounded box for the sliders background
  sliderBackground:setFillColor(0, 0, 0, 0.8)--set the transparency to 80%

--------------Text Box Creation-----------------
local textGroup = display.newGroup() --create a new group for all the text 

local highText = display.newText(  --create the high text box
  {
    text = "HIGH",--fill text
    x = 225,-- x and y position
    y = 900,
    fontSize = 40 -- set the font size
  } 
)
highText:setFillColor(1,1,1) -- set the color of the text to white
textGroup:insert(highText) --insert the text to the group

local lowText = display.newText(  --create the low text box
  {
    text = "LOW",--fill text
    x = 225,-- x and y position
    y = 800,
    fontSize = 40-- set the font size
  } 
)
lowText:setFillColor(1,1,1)-- set the color of the text to white
textGroup:insert(lowText)--insert the text to the group

local sizeText = display.newText( --create the size text box
  {
    text = "SIZE",--fill text
    x = 1000,-- x and y position
    y = 750,
    fontSize = 40-- set the font size
  } 
)
sizeText:setFillColor(1,1,1)-- set the color of the text to white
textGroup:insert(sizeText)--insert the text to the group

local horMoveText = display.newText( --create the horizontal move text box
  {
    text = "Hor Move",--fill text
    x = 1000,-- x and y position
    y = 850,
    fontSize = 40-- set the font size
  } 
)
horMoveText:setFillColor(1,1,1)-- set the color of the text to white
textGroup:insert(horMoveText)--insert the text to the group

local rotateText = display.newText( --create the rotate text box
  {
    text = "Rotate",--fill text
    x = 1000,-- x and y position
    y = 950,
    fontSize = 40-- set the font size
  } 
)
rotateText:setFillColor(1,1,1)-- set the color of the text to white
textGroup:insert(rotateText)--insert the text to the group


---------------Button Creation----------------------
local kickButton = widget.newButton( -- create the kick button 
    {
        x = 500, --x and y position
        y = 775,
        id = "button1", -- give button an id
        label = "Kick", -- give button a label to display
        fontSize = 50, -- set font size 
        onEvent = kickButtonEvent -- pass kick event listener to handler
    }
)

local punchButton = widget.newButton(-- create the punch button 
    {
        
        x = 500, --x and y position
        y = 900,
        id = "button2",-- give button an id
        label = "Punch",-- give button a label to display
        fontSize = 50,-- set font size 
        onEvent = punchButtonEvent-- pass punch event listener to handler
    }
)


----------------Slider Creation----------------------
-- Create the widget
local sizeSlider = widget.newSlider( --create size slider
    {
        x = 1300, --x and y postion
        y = 750,
        width = 400, --width of slider
        value = 10,  -- Start slider at 10% (optional)
        listener = sizeListener -- add size event listener to the slider
    }
)

-- Create the widget
local horSlider = widget.newSlider(--create horizontal move slider
    {
        x = 1300,--x and y postion
        y = 850,
        width = 400,--width of slider
        value = 10,  -- Start slider at 10% (optional)
        listener = horMoveListener-- add horizontal move event listener to the slider
    }
)

-- Create the widget
local rotSlider = widget.newSlider(--create rotation slider
    {
        x = 1300,--x and y postion
        y = 950,
        width = 400,--width of slider
        value = 10,  -- Start slider at 10% (optional)
        listener = rotateListener -- add rotate event listener to handler
    }
)