

x=100
y=100
vX = 0
vY = 0
torque = 0
xDir = 0
yDir = 0

rot = 0

accel = 100
gravity = 9.82
drag = 1

size = 10


function love.update(dt)
    vX = vX + xDir * accel * dt
    vY = vY + yDir * accel * dt
    rot = rot + torque * dt
    newX = x + vX * dt
    newY = y + vY * dt

    if newX - size > 0
    and newX + size < love.graphics.getWidth()
    then
        x = newX
    else
        vX = -vX
    end    

    if newY - size > 0
    and newY + size < love.graphics.getHeight()
    then
        y = newY
    else
        vY = -vY
    end
     

end

function love.draw()

    love.graphics.clear(.9,.9,.8)

    love.graphics.print("Hello World", 400, 300)
    love.graphics.setColor(.3,.7,0)
    love.graphics.circle('fill', x,y, 10,10)
    love.graphics.setColor(.7, .3, 0)
    
    -- love.graphics.push()
    love.graphics.translate(x,y)
    love.graphics.rotate(rot)
    love.graphics.translate(-x,-y)
    love.graphics.rectangle('fill', x-size +6,y-size+2, 8,size * 2-4)
    -- love.graphics.pop()
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
        torque = torque +1
    elseif key == 'q' then
        torque = torque -1

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