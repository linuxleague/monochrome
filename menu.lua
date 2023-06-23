--[[  :::::: functions for drawing menus with dynamic sizes ::::::

methods to allow a conky client to manipulate x,y positions of images or text at runtime,
examples:

1) drawing menu windows

      ╭──────────╮    a menu window is drawn by conky using a combination
      |──────────|    of several images imposed on top of each other
      |          |
      |          |    
      |          |    for menus with a variable amount of text (ex. based on the contents of a file)
      ╰──────────╯  < the position of the bottom edge images are determined at runtime
                      based on the number of lines said file

2) draw an image taking into account a x,y offsets to alter the image's starting x,y coordinates
3) alter text ${goto x} or ${offset x} statements with a runtime x offset

]]

-- table to hold variables
vars = {}


--[[ 
parses the given conky expression and stores its value for future use
if the 'expression' is not provided, the current value stored for the variable is returned

arguments:
    name          name of the variable
    expression    conky variable to parse (optional argument)
]]
function conky_get(name, expression)
  if expression ~= nil then vars[name] = conky_parse(expression) end
  if vars[name] == nil then print("variable '" .. name .. "' does not exist") end

  return vars[name]
end


-- resets the x,y offsets
-- this method should be invoked by conky on each refresh cycle
function conky_reset_state()
  vars["xOffset"] = 0
  vars["yOffset"] = 0
end


--[[ 
adds an offset to the x & y coordinates
the client can then call the following methods which will take these offsets into account:

  - conky_draw_image(..)
  - conky_add_x_offset(..)

on each conky session the offsets are reset to 0 (see the conky_reset_state() method)
this methoed is cumulative, ie. the numbers are increased each times the method is called
]]
function conky_add_offsets(xOffset, yOffset)
  local x = vars["xOffset"] or 0
  x = x + tonumber(xOffset)
  vars["xOffset"] = x

  local y = vars["yOffset"] or 0
  y = y + tonumber(yOffset)
  vars["yOffset"] = y
  return ''
end


--[[ 
update the conky variable with the current 'x' offset
call this method with ${goto} or ${offset} conky variables
]]
function conky_add_x_offset(variable, x)
  local xOffset = vars["xOffset"] or 0
  return "${" .. variable .. " " .. tonumber(x) + xOffset .. "}"
end


--[[ 
creates a conky image variable string at the x,y coordinate position after any available offsets are applied, ex. calling conky_draw_image(/directory/image.jpg, 0, 50) 
             with the current offsets being x = 10, y = 50
             would yield this image variable: ${image /directory/image.jpg -p 10,100}

arguments:
    path  path to image file
    x     image x coordinate
    y     image y coordinate

@see the 'conky_add_offsets()' method
]]
function conky_draw_image(path, x, y)
  local xOffset = vars["xOffset"] or 0
  local yOffset = vars["yOffset"] or 0
  return build_image_variable(path, tonumber(x) + xOffset, tonumber(y) + yOffset)
end


function conky_configure_menu(theme, image, width, textVOffset)
  vars["theme"] = theme;
  vars["image"] = image;
  vars["width"] = tonumber(width);
  vars["textVOffset"] = tonumber(textVOffset);
  return ''
end

--[[ 
convenience method to fill up the contents of a menu window by reading a file
it performs to steps atomically

   - read a file similar to the linux 'head' command
   - print the bottom edge images taken into account the number of lines printed

arguments:
    filepath  absolute path to the file
    max       maximun number of lines to print
]]
function conky_head(filepath, max)
  max = (max~=nil) and tonumber(max) or 30
  local text = conky_parse("${cat " .. filepath .. "}")
  local lines = select(2, text:gsub('\n','\n')) + 1     -- last line will not have a new line so we increase by 1
  lines = (lines < max) and lines or max
  vars["lines"] = lines
  
  local i = 0
  local pos = 0
  
  while i < max do
    pos = string.find(text, "\n", pos+1)
    if pos == nil then break end
    i = i + 1
  end
  
  text = string.sub(text, 1, pos)
  text = string.gsub(text, '\n$', '')     -- remove last new line (if any)
  text = text .. draw_round_bottom_edges(vars["theme"], vars["image"], vars["xOffset"], vars["yOffset"], vars["width"], vars["textVOffset"], lines)

  return text
end


--[[ 
prints the menu's bottom edge ${image} variables based on the number of lines in the body

arguments:
    theme     conky theme: compact, widets, glass, etc...
    filename  image file name
    x         image x coordinate
    y         starting y coordinate of the menu's body image
    voffset   vertical offset used for each line in the menu's body
              ie. if the text uses this notation
              
                      ${voffset 3} some text
                      ${voffset 3} bla bla bla
                                 \
                                 you have to provide this value here
                                 
    lines     number of lines in the body
]]
function draw_round_bottom_edges(theme, filename, x, y, width, voffset, lines)
  local lineMultiplier = 15
  
  if voffset > 2 then
    lineMultiplier = lineMultiplier + voffset - 2
  end

  lines = (lines > 0) and lines or 0
  y = y + (lines * lineMultiplier) - voffset
  local imageDir = "~/conky/monochrome/images/"
  local path = imageDir .. theme .. "/" .. filename .. "-left.png"
  local s = build_image_variable(path, x, y)
  path = imageDir .. theme .. "/" .. filename .. "-right.png"
  s = s .. build_image_variable(path, x+width-7, y)
  -- add a blank image right below the bottom edge image, bottom edges are 7x7px
  y = y + 7
  s = s .. build_image_variable(imageDir .. "menu-blank.png", x, y)
  vars["yOffset"] = y

  return s
end


--[[ creates a conky image variable string, ex. ${image /directory/image.jpg -p 0,0}

arguments:
    path  path to image file
    x     image x coordinate
    y     image y coordinate
]]
function build_image_variable(path, x, y)
  return "${image " .. path .. " -p " .. x .. "," .. y .. "}"
end


--[[
complementary method to the head() function in order to print the bottom edges of a table
next to the one being populated by said head() method

use this when you are splitting the columns of a table into individual tables

                 x coordinate
                     |
        table 1         table 2
      ╭──────────╮   ╭──────────╮
      |──────────|   |──────────| < y coordinate is where the table's header ends, ie. the body of the table begins
      |          |   |          |
      |          |   |          | 
      |          |   |          |
      ╰──────────╯   ╰──────────╯ < you want to print the edges for this colum here
           \                        head() saves the # of lines read under the "lines" variable
            \
           head() is driving the height of the table
           and will print its edges

arguments:
    x       x coordinate
    y       y coordinate
    width   width of this table
]]
function conky_draw_bottom_edges(x,y, width)
  if not vars["lines"] then
    print("the lua head() method has not been invoked yet, unable to draw a bottom edge")
    return ''
  end
  
  return draw_round_bottom_edges(vars["theme"], vars["image"], tonumber(x), tonumber(y), tonumber(width), vars["textVOffset"], vars["lines"])
end
