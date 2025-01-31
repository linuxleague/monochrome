conky.config = {
  update_interval = 2,  -- update interval in seconds
  xinerama_head = 0,    -- for multi monitor setups, select monitor to run on: 0,1,2
  double_buffer = true, -- use double buffering (reduces flicker, may not work for everyone)

  -- window alignment
  alignment = 'bottom_left',  -- top|middle|bottom_left|right
  gap_x = 471,               -- same as passing -x at command line
  gap_y = 3,

  -- window settings
  minimum_width = 323,
  minimum_height = 138,
  own_window = true,
  own_window_type = 'desktop',    -- values: desktop (background), panel (bar)
  own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',

  -- transparency configuration
  draw_blended = false,
  own_window_transparent = true,
  own_window_argb_visual = true,  -- turn on transparency
  own_window_argb_value = 255,    -- range from 0 (transparent) to 255 (opaque)

  -- window borders
  draw_borders = false,     -- draw borders around the conky window
  border_width = 1,         -- width of border window in pixels
  stippled_borders = 0,     -- border stippling (dashing) in pixels
  border_inner_margin = 0,  -- margin between the border and text in pixels
  border_outer_margin = 0,  -- margin between the border and the edge of the window in pixels

  -- graph settings
  draw_graph_borders = false, -- borders around the graph, ex. cpu graph, network down speed grah
                              -- does not include bars, ie. wifi strength bar, cpu bar

  top_name_verbose = true,    -- show full command in ${top ...}
  top_name_width = 21,        -- how many characters to print

  imlib_cache_flush_interval = 250,
  -- use the parameter -n on ${image ..} to never cache and always update the image upon a change

  -- font settingsr
  draw_shades = false,    -- black shadow on text (not good if text is black)
  
  -- colors
  default_color = '[=colors.text]', -- regular text
  color1 = '[=colors.labels]',        -- text labels
  color2 = '[=colors.cpuBar]',        -- bar
  color3 = '[=colors.warning]',        -- bar critical
  
  -- :::::::::::::::::::::::::::::::: templates ::::::::::::::::::::::::::::::::
  -- cpu bar: ${template0 cpuCore}
  template0 = [[${voffset -3}${offset 16}${color2}${if_match ${cpu cpu\1} >= [=threshold.cpu]}${color3}${endif}${cpubar cpu\1 4, 66}]],

  -- top cpu process: ${template1 process#}
  template1 = [[${voffset 3}${goto 110}${color}${top name \1}${top cpu \1}% ${top pid \1}]],
  
  -- hwmon entry: index/device type index threshold
  template2 = [[${if_match ${hwmon \1 \2 \3} > \4}${color3}${else}${color}${endif}${hwmon \1 \2 \3}]]
};

conky.text = [[
${image ~/conky/monochrome/images/widgets/[=image.primaryColor]-cpu.png -p 0,0}\
${voffset 12}<#list 1..8 as x>${template0 [=x]}<#sep>[='\n']</#sep></#list>
${voffset 7}${offset 9}${cpugraph cpu0 31,82 [=colors.writeGraph]}
${voffset -135}${goto 109}${color1}process${alignr 5}cpu   pid${voffset 4}
<#list 1..4 as x>
${template1 [=x]}
</#list>
${voffset 14}${goto 109}${color1}cpu${goto 139}${color}${cpu cpu0}%${alignr 5}${template2 atk0110 temp 1 [=threshold.tempCPU]}°C ${color1}cpu temp
${voffset 4}${goto 109}${color1}load${goto 139}${color}${loadavg}${alignr 5}${template2 coretemp temp 2 [=threshold.tempCPUCore]}°C${color1}core temp
]];
