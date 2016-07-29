-- This is going to be my first love2d game
-- Wouter Wijsman aka sharkwouter 2016

function load_puzzle()
    return {
            {0,1,1,0,0},
            {1,1,1,1,0},
            {0,0,1,0,0},
            {1,1,1,1,1},
            {0,1,1,1,0},
           }
end

function love.load()
    game_name = "love-picross"
    
    puzzle = load_puzzle()
    
    block_size = 64
    raster_width = table.getn(puzzle[1])
    raster_height = table.getn(puzzle)
    
    -- Set window properties
    love.window.setMode(block_size*(raster_width+2),block_size*(raster_height+2))
    love.window.setTitle(game_name)
    
    -- Set colors
    love.graphics.setBackgroundColor(255,255,255)
    love.graphics.setColor(0,0,0)
end

function draw_raster(width, height, block_size)
    
    -- Draw horizontal lines
    for i=0,height,1 do
        love.graphics.line(block_size,block_size+block_size*i,block_size+block_size*width,block_size+block_size*i)
    end
    -- Draw vertical lines
    for i=0,width,1 do
        love.graphics.line(block_size*(i+1),block_size,block_size*(i+1),block_size*(height+1))
    end
end

--function love.update(dt)
--    if 
--end

function love.draw()
    draw_raster(raster_width,raster_height,block_size)
end
