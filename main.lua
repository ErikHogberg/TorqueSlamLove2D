
player1 = {

    x=100,
    y=100,

    vX = 0,
    vY = 0,
    torque = 0,
    
    xDir = 0,
    yDir = 0,
    lastDir = 1,

    rot = 0,
    touchingGround = false
}

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


pillarCount = 6
pillars = {}

for i = 1, pillarCount do pillars[i] = 0 end


function love.update(dt)
    player1.vX = player1.vX + player1.xDir * accel * dt
    player1.vY = player1.vY + gravity * dt
    player1.rot = player1.rot + player1.torque * dt
    -- torque = torque - aDrag * dt
    newX = player1.x + player1.vX * dt
    newY = player1.y + player1.vY * dt

    
    screenWidth = love.graphics.getWidth()
    pillarWidth = screenWidth/pillarCount
    pillarIndex = math.floor(player1.x/(pillarWidth))+1
    if newY - size > 0
    then
        if newY + size < love.graphics.getHeight() - groundHeight -pillars[pillarIndex]
        then
            player1.touchingGround = false
            player1.y = newY
        else 
            player1.vY = 0
            if not player1.touchingGround then
                pillars[pillarIndex] = pillars[pillarIndex] + 5
                if player1.yDir <0 then
                    player1.vY = -jumpForce
                end
            end
            if player1.y > love.graphics.getHeight() - groundHeight - pillars[pillarIndex] then
                player1.vX= -player1.vX
            else
            player1.y = love.graphics.getHeight() - groundHeight - size - pillars[pillarIndex]
            player1.touchingGround = true
            end
        end
    else
        player1.vY = -player1.vY
    end
    
    if newX - size > 0
    and newX + size < love.graphics.getWidth()
    then
        player1.x = newX
    else
        player1.vX = -player1.vX
        if not player1.touchingGround and player1.yDir < 0 then
            player1.vY = -jumpForce
        end
    end    
    
    if player1.touchingGround then
        player1.vX = player1.vX + (player1.torque * torqueTransfer) * dt
        if player1.torque < 0 then
            player1.torque = player1.torque + aDrag * dt
        else
            player1.torque = player1.torque - aDrag * dt
        end

        dragDt = drag * dt

        if math.abs(dragDt) > math.abs(player1.vX) then player1.vX = 0 end

        if player1.vX < 0 then
            player1.vX = player1.vX + dragDt
        else
            player1.vX = player1.vX - dragDt
        end
    end

end

function love.draw()

    love.graphics.clear(.9,.9,.8)

    love.graphics.print("Hello World. " .. tostring(player1.touchingGround), 400, 300)
    love.graphics.setColor(.3,.7,0)
    love.graphics.circle('fill', player1.x,player1.y, size,size)
    love.graphics.setColor(.7, .3, 0)
    
    screenWidth = love.graphics.getWidth()
    screenHeight= love.graphics.getHeight()
    pillarWidth = screenWidth/pillarCount
    for i = 1, pillarCount do  
        love.graphics.setColor(i/pillarCount, .3, 0)
        love.graphics.rectangle('fill', 
            pillarWidth * (i-1), 
            screenHeight - pillars[i] - groundHeight, 
            pillarWidth, 
            1000 
        )
    end    

    love.graphics.push()
    love.graphics.translate(player1.x,player1.y)
    love.graphics.rotate(player1.rot)
    love.graphics.translate(-player1.x,-player1.y)
    love.graphics.rectangle('fill', player1.x - rectW/2, player1.y - rectH/2, rectW, rectH)
    love.graphics.pop()
 

end

function love.keypressed(key)
    if key == 'w' then
        player1.yDir = -1
        if player1.touchingGround then
            player1.vY = -jumpForce
        end
    elseif key == 'a' then
        player1.xDir = -1
        player1.lastDir = -1
    elseif key == 's' then
        player1.yDir = 1
    elseif key == 'd' then
        player1.xDir = 1
        player1.lastDir = 1
    elseif key == 'e' then
        player1.torque = player1.torque +3
    elseif key == 'q' then
        player1.torque = player1.torque -3

    elseif key == 'escape' then
        love.event.push('quit')
    end
 end
function love.keyreleased(key)
    if key == 'w' and player1.yDir == -1 then
        player1.yDir = 0
    elseif key == 'a' and player1.xDir == -1 then
        player1.xDir = 0
    elseif key == 's' and player1.yDir == 1 then
        player1.yDir = 0
    elseif key == 'd' and player1.xDir == 1 then
        player1.xDir = 0
    end
 end

