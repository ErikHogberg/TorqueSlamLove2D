

x=100
y=100
vX = 0
vY = 0
torque = 0
xDir = 0
yDir = 0

rot = 0

accel = 200
gravity = 9.82 * 10
drag = 100
aDrag = 20
torqueTransfer = 30

jumpForce = 100

vCap = 10

size = 30
rectW = 15
rectH = 45
groundHeight = 10
touchingGround = false

function love.update(dt)
    vX = vX + xDir * accel * dt
    vY = vY + gravity * dt
    rot = rot + torque * dt
    -- torque = torque - aDrag * dt
    newX = x + vX * dt
    newY = y + vY * dt

    
    if newY - size > 0
    then
        if newY + size < love.graphics.getHeight() - groundHeight
        then
            touchingGround = false
            y = newY
        else 
            y = love.graphics.getHeight() - groundHeight - size
            vY = 0
            touchingGround = true
        end
    else
        vY = -vY
    end
    
    if newX - size > 0
    and newX + size < love.graphics.getWidth()
    then
        x = newX
    else
        vX = -vX
        if not touchingGround and yDir < 0 then
            vY = -jumpForce
        end
    end    
    
    if touchingGround then
        vX = vX + (torque * torqueTransfer) * dt
        if torque < 0 then
            torque = torque + aDrag * dt
        else 
            torque = torque - aDrag * dt
        end

        dragDt = drag * dt

        if math.abs(dragDt) > math.abs(vX) then vX = 0 end

        if vX < 0 then
            vX = vX + dragDt
        else
            vX = vX - dragDt
        end
    end

end

function love.draw()

    love.graphics.clear(.9,.9,.8)

    love.graphics.print("Hello World. " .. tostring(touchingGround), 400, 300)
    love.graphics.setColor(.3,.7,0)
    love.graphics.circle('fill', x,y, size,size)
    love.graphics.setColor(.7, .3, 0)
    
    -- love.graphics.push()
    love.graphics.translate(x,y)
    love.graphics.rotate(rot)
    love.graphics.translate(-x,-y)
    love.graphics.rectangle('fill', x - rectW/2, y - rectH/2, rectW, rectH)
    -- love.graphics.pop()
end

function love.keypressed(key)
    if key == 'w' then
        yDir = -1
        if touchingGround then
            vY = -jumpForce
        end
    elseif key == 'a' then
        xDir = -1
    elseif key == 's' then
        yDir = 1
    elseif key == 'd' then
        xDir = 1
    elseif key == 'e' then
        torque = torque +3
    elseif key == 'q' then
        torque = torque -3

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