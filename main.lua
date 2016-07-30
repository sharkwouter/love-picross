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

function load_workspace()
    workspace = {}
    for y=1,raster_height do
        workspace [y] = {}
        for x=1,raster_width do
            workspace [y] [x] = 0
        end
    end
    
    return workspace
end

function love.load()
    game_name = "love-picross"
    
    puzzle = load_puzzle()
    
    block_size = 64
    raster_width = table.getn(puzzle[1])
    raster_height = table.getn(puzzle)
    
    block_x = 0
    block_y = 0
    
    -- Create empty array to draw on
    workspace = load_workspace()
    
    -- Calculate values on the side
    numbers = calculate_numbers(puzzle)
    
    -- Set window properties
    love.window.setMode(block_size*(raster_width+2),block_size*(raster_height+2))
    love.window.setTitle(game_name)
    
    -- Set colors
    love.graphics.setBackgroundColor(255,255,255)
    love.graphics.setColor(0,0,0)
end

function draw_raster(width, height, block_size)
    
    -- Draw horizontal lines
    for i=0,height do
        love.graphics.line(block_size,block_size+block_size*i,block_size+block_size*width,block_size+block_size*i)
    end
    -- Draw vertical lines
    for i=0,width do
        love.graphics.line(block_size*(i+1),block_size,block_size*(i+1),block_size*(height+1))
    end
end

function draw_workspace(workspace)
    for y=1,raster_height do
        for x=1,raster_width do
            if workspace [y] [x] == 1 then
                love.graphics.rectangle("fill",block_size*(x),block_size*(y),block_size,block_size)
            end
            if workspace [y] [x] == 2 then
                love.graphics.line(block_size*(x),block_size*(y),block_size*(x+1),block_size*(y+1))
                love.graphics.line(block_size*(x),block_size*(y+1),block_size*(x+1),block_size*(y))
            end
        end
    end
end

function calculate_numbers(puzzle)
    --this will be calculating the numbers to be printed on the side
    hor_numbers = {}
    for x=1,raster_width do
        current_number = 0
        hor_numbers [x] = {}
        for y=1,raster_height do
            if puzzle [y] [x] == 1 then
               current_number = current_number+1
            elseif current_number > 0 and x > 1 then
                numbers_amount = table.getn(hor_numbers [x])
                hor_numbers [numbers_amount+1] = current_number
            end 
        end
    end
    vert_numbers = {}
    for y=1,raster_height do
        current_number = 0
        vert_numbers [y] = {}
        for x=1,raster_width do
            if puzzle [y] [x] == 1 then
               current_number = current_number+1
            elseif current_number > 0 and y > 1 then
                numbers_amount = table.getn(vert_numbers [y])
                vert_numbers [numbers_amount+1] = current_number
            end 
        end
    end
    numbers_full = {}
    numbers_full [1] = hor_numbers
    numbers_full [2] = ver_numbers
    return numbers_full
end

function draw_numbers(numbers)
--    for 
end

-- This function is only for 2 dimensional arrays!
-- It is used to check if the puzzle has been solved yet
function arrays_equal(array1,array2)
    equal = 1
    height = table.getn(array1)
    width = table.getn(array1[1])
    for y=1,height do
        if equal == 0 then
            break
        end
        for x=1,width do
            if array1 [y] [x] ~= array2 [y] [x] then
                equal = 0
            end
        end
   end
   
   return equal
end

function draw_debug_info()
    love.graphics.setColor(255,0,0)
    for y=1,raster_height do
        for x=1,raster_width do
            love.graphics.print(puzzle [y] [x],x*block_size+1,y*block_size)
            love.graphics.print(workspace [y] [x],x*block_size+1,y*block_size+block_size-14)
        end
    end
end

function love.mousereleased(mouse_x,mouse_y,mouse_button)
    if mouse_x > block_size and mouse_x < block_size*(raster_width+1) and mouse_y > block_size and mouse_y < block_size*(raster_height+1) then
        block_x = math.floor((mouse_x)/block_size)
        block_y = math.floor((mouse_y)/block_size)
        if mouse_button == "l" or mouse_button == 1 then
            if workspace [block_y] [block_x] == 1 then
                workspace [block_y] [block_x] = 0
            else
                workspace [block_y] [block_x] = 1
            end
        end
        if mouse_button == "r" or mouse_button == 2 then
            if workspace [block_y] [block_x] == 2 then
                workspace [block_y] [block_x] = 0
            else
                workspace [block_y] [block_x] = 2
            end
        end
    end
end

function love.update(dt)
    if arrays_equal(workspace,puzzle) == 1 then
        print("Congratulations! The puzzle has been solved!")
        --reset the workspace
        workspace = load_workspace()
   end
end

function love.draw()
    love.graphics.setColor(0,0,0)
    draw_raster(raster_width,raster_height,block_size)
    draw_workspace(workspace)
--    draw_debug_info()
end
