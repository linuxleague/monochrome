<#import "/lib/menu-round.ftl" as menu>
conky.config = {
  lua_load = '~/conky/monochrome/menu.lua',
  lua_draw_hook_pre = 'reset_state',
  
  update_interval = 3,  -- update interval in seconds
  xinerama_head = 0,      -- for multi monitor setups, select monitor to run on: 0,1,2
  double_buffer = true,   -- use double buffering (reduces flicker, may not work for everyone)

  -- window alignment
  alignment = 'top_left',  -- top|middle|bottom_left|right
  gap_x = 205,
  gap_y = 38,

  -- window settings
  <#assign width = 189>
  minimum_width = [=width],      -- conky will add an extra pixel to this  
  maximum_width = [=width],
  own_window = true,
  own_window_type = 'desktop',    -- values: desktop (background), panel (bar)
  own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',

  -- window borders
  draw_borders = false,     -- draw borders around the conky window
  border_width = 1,         -- width of border window in pixels
  border_inner_margin = 0,  -- margin between the border and text in pixels
  border_outer_margin = 0,  -- margin between the border and the edge of the window in pixels
  
  -- transparency configuration
  draw_blended = false,
  own_window_transparent = true,
  own_window_argb_visual = true,  -- turn on transparency
  own_window_argb_value = 255,    -- range from 0 (transparent) to 255 (opaque)
  
  -- images
  imlib_cache_flush_interval = 250,

  -- font settings
  use_xft = false,
  draw_shades = false,      -- black shadow on text (not good if text is black)
  draw_outline = false,     -- black outline around text (not good if text is black)
  -- colors
  default_color = '[=colors.menuText]',  -- regular text
  color1 = '[=colors.labels]',
  color2 = '[=colors.highlight]'          -- highlight important packages
};

conky.text = [[
# :::::::::::: package updates
<#assign packagesFile = "/tmp/conky/dnf.packages.formatted">
${if_existing [=packagesFile]}\
<#assign y = 0, 
         header = 19, <#-- menu header -->
         body = 1400,  <#-- menu window without the header -->
         gap = 3>     <#-- empty space between windows -->
<@menu.compositeTable x=0 y=y width=width vheader=51 hheight=body/>
${lua configure_menu [=image.primaryColor] light [=width?c] 3}\
<#assign y += header + 1 + header>
${lua add_offsets 0 [=y]}\
# optional dnf branding, can be removed or won't matter if the image does not exist
${image ~/conky/monochrome/images/common/[=image.primaryColor]-menu-dnf.png -p 114,[=(y+2)?c]}\
${voffset 2}${offset 5}${color1}dnf${goto 57}${color}${lines [=packagesFile]} package updates
${voffset -5}${color2}${hr 1}${voffset -8}
${voffset 7}${offset 5}${color1}package${alignr 5}version${voffset 3}
<#if system == "desktop"><#assign maxLines = 36><#else><#assign maxLines = 15></#if>
${color}${lua_parse populate_menu [=packagesFile] [=maxLines] 900}${voffset 5}
${endif}\
]];
