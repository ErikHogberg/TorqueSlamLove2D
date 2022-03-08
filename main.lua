
-- player1 = {
--     x=100,
--     y=100,

--     vX = 0,
--     vY = 0,
--     torque = 0,
    
--     xDir = 0,
--     yDir = 0,
--     lastDir = 1,

--     rot = 0,
--     touchingGround = false
-- }

players = {}
playerCount = 2

keys = {
    {'w','s','a','d','e','q'},
    {'i','k','j','l','o','u'},
}

for i=1,playerCount do
    players[i] = {
        x=100 * i,
        y=100,
    
        vX = 0,
        vY = 0,
        torque = 0,
        
        xDir = 0,
        yDir = 0,
        lastDir = 1,
    
        rot = 0,
        touchingGround = false,

        upKey = keys[i][1],
        downKey = keys[i][2],
        leftKey = keys[i][3],
        rightKey = keys[i][4],
        cwKey = keys[i][5],
        ccwKey = keys[i][6],
    }
end


accel = 200
rollStrength = 50
rollImpulseStrength = 10

gravity = 9.82 * 10
downFactor = 20
drag = 100
aDrag = 20
airTorqueDrag = 1
torqueTransfer = 30

jumpForce = 150

vCap = 100

size = 30
rectW = 15
rectH = 45
groundHeight = 10

turnLoss = .5


pillarCount = 6
pillars = {}

debugval =1

for i = 0, pillarCount +1 do pillars[i] = 0 end

function sign(number)
    return number > 0 and 1 or (number == 0 and 0 or -1)
end

function love.update(dt)

    -- TODO: player-to-player collision

    for i=1,playerCount do

        players[i].vY = players[i].vY + gravity * dt

        -- players[i].vX = players[i].vX + players[i].xDir * accel * dt
        if players[i].vY > 0 then
            if players[i].vX > 0 then
                players[i].vY = players[i].vY + math.max(0, players[i].torque) * downFactor * dt
            elseif players[i].vX < 0 then
                players[i].vY = players[i].vY + math.min(0, players[i].torque) * downFactor * dt
            end
        end
        players[i].rot = players[i].rot + players[i].torque * dt
        -- torque = torque - aDrag * dt
        newX = players[i].x + players[i].vX * dt
        newY = players[i].y + players[i].vY * dt

        
        screenWidth = love.graphics.getWidth()
        pillarWidth = screenWidth/pillarCount
        pillarIndex = math.floor(players[i].x/(pillarWidth))+1
        newPillarIndex = math.floor((newX + size * sign(newX - players[i].x ))/(pillarWidth))+1
        newPillarHeight = love.graphics.getHeight() - groundHeight -pillars[newPillarIndex]

        if newY - size > 0 then
            if newY + size < love.graphics.getHeight() - groundHeight - pillars[pillarIndex] then    
                players[i].touchingGround = false
                players[i].y = newY
            else 
                oldVY = players[i].vY
                players[i].vY = 0
                if not players[i].touchingGround then
                    -- pillars[pillarIndex] = pillars[pillarIndex] + 5
                    if players[i].yDir < 0 then
                        players[i].vY = -jumpForce
                    end
                end
                if players[i].y > love.graphics.getHeight() - groundHeight - pillars[pillarIndex] then
                    -- players[i].vX= -players[i].vX
                elseif not players[i].touchingGround then
                    players[i].touchingGround = true
                    debugval = oldVY
                    if oldVY > 150 and math.abs(players[i].vX)/players[i].vY > 1 then
                        pillars[pillarCount- pillarIndex+1] = pillars[pillarCount - pillarIndex+1] + players[i].torque* 1 + oldVY * .1
                        players[i].torque = 0 
                    end
                    players[i].y = love.graphics.getHeight() - groundHeight - size - pillars[pillarIndex]
                end
            end
        else
            players[i].vY = -players[i].vY
        end
        

        if newX - size > 0
        and newX + size < love.graphics.getWidth()
        and newY < newPillarHeight 
        then
            players[i].x = newX
            if players[i].y + size - .1 > newPillarHeight then
                players[i].y = newPillarHeight - size
            end
        else
            players[i].vX = -players[i].vX
            if not players[i].touchingGround and players[i].yDir < 0 then
                players[i].vY = -jumpForce
            end
        end    
        
        if players[i].touchingGround then
            players[i].torque = players[i].torque + players[i].xDir * rollStrength * dt

            
            players[i].vX = players[i].vX + (players[i].torque * torqueTransfer) * dt
            if players[i].torque < 0 then
                players[i].torque = players[i].torque + aDrag * dt
            else
                players[i].torque = players[i].torque - aDrag * dt
            end

            dragDt = drag * dt

            if math.abs(dragDt) > math.abs(players[i].vX) then players[i].vX = 0 end

            if players[i].vX < 0 then
                players[i].vX = players[i].vX + dragDt
            else
                players[i].vX = players[i].vX - dragDt
            end
        else
            players[i].vX = players[i].vX + (players[i].xDir * accel - sign(players[i].vX)* math.abs( players[i].torque) * airTorqueDrag) * dt
             
        end

        
        -- sqrMagnitude = players[i].vX * players[i].vX + players[i].vY * players[i].vY
        -- if sqrMagnitude > vCap * vCap then
        --     magnitude = math.sqrt( sqrMagnitude )
        --     xyRatio = math.max(players[i].vX/math.abs(players[i].vX),0.001)
        --     players[i].vX = (players[i].vX/magnitude) * vCap
        --     players[i].Y = (players[i].vY/magnitude) * vCap
        --     -- players[i].vY = sign(players[i].vY)*(1-xyRatio) * vCap
        -- end
    end

end

function love.draw()

    love.graphics.clear(.9,.9,.8)

    love.graphics.setColor(.7,.3,.0)
    love.graphics.print("Hello World. " .. tostring(players[1].touchingGround) .. " " .. tostring(debugval), 400, 300)
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

    for i=1,playerCount do
        -- TODO: afterimage, trail, or delayed/interpolated render position
        percent = (i-1)/playerCount
        love.graphics.setColor(.3,.7 - (percent) * .7, 1-percent)
        love.graphics.circle('fill', players[i].x,players[i].y, size,size)
        
        love.graphics.setColor(.7, .3, .0)
        love.graphics.push()
        love.graphics.translate(players[i].x,players[i].y)
        love.graphics.rotate(players[i].rot)
        love.graphics.translate(-players[i].x,-players[i].y)
        love.graphics.rectangle('fill', players[i].x - rectW/2, players[i].y - rectH/2, rectW, rectH)
        love.graphics.pop()
    end

end

function love.keypressed(key)
    for i=1,playerCount do
        if key == players[i].upKey then
            players[i].yDir = -1
            if players[i].touchingGround then
                players[i].vY = -jumpForce
            end
        elseif key == players[i].leftKey then
            players[i].xDir = -1
            players[i].lastDir = -1
            -- if players[i].vX > 0 then players[i].vX = -players[i].vX*turnLoss end

        elseif key == players[i].downKey then
            players[i].yDir = 1
            if(players[i].vY < 0) then players[i].vY= -players[i].vY end
            -- players[i].vX = -players[i].vX
        elseif key == players[i].rightKey then
            players[i].xDir = 1
            players[i].lastDir = 1
            -- if players[i].vX < 0 then players[i].vX = -players[i].vX*turnLoss end

        elseif key == players[i].cwKey then
            players[i].torque = players[i].torque + rollImpulseStrength
        elseif key == players[i].ccwKey then
            players[i].torque = players[i].torque - rollImpulseStrength

        elseif key == 'escape' then
            love.event.push('quit')
        end
    end
end

function love.keyreleased(key)
    for i= 1, playerCount do
        if key == players[i].upKey and players[i].yDir == -1 then
            players[i].yDir = 0
        elseif key == players[i].leftKey and players[i].xDir == -1 then
            players[i].xDir = 0
        elseif key == players[i].downKey and players[i].yDir == 1 then
            players[i].yDir = 0
        elseif key == players[i].rightKey and players[i].xDir == 1 then
            players[i].xDir = 0
        end
    end
 end

