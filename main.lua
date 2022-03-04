

x=100
y=100
vX = 0
vY = 0
torque = 0
xDir = 0
yDir = 0

accel = 10
rot = 0

size = 10


function love.update(dt)
    vX = vX + xDir * accel * dt
    vY = vY + yDir * accel * dt
    x = x + vX * dt
    y = y + vY * dt
    rot = torque * dt
end

function love.draw()
    love.graphics.print("Hello World", 400, 300)
    love.graphics.setColor(.3,.7,0)
    love.graphics.circle('fill', x,y, 10,10)
    love.graphics.setColor(.7, .3, 0)
    
    love.graphics.rectangle('fill', x,y, 7,10)
end

function love.keypressed(key)
    if key == 'w' then
        yDir = -1
    elseif key == 'a' then
        xDir = -1
    elseif key == 's' then
        yDir = 1
    elseif key == 'd' then
        xDir = 1
    elseif key == 'e' then
        
    elseif key == 'q' then

    elseif key == 'escape' then
        love.event.push('quit')
    end
 end
function love.keyreleased(key)
    if key == 'w' and yDir == -1 then
        yDir = 0
    elseif key == 'a' and xDir == -1 then
        xDir = 0
    elseif key == 's' and yDir == 1 then
        yDir = 0
    elseif key == 'd' and xDir == 1 then
        xDir = 0
    end
 end

 function love.mousepressed(x, y, button, istouch)
    if button == 1 then
    end
 end