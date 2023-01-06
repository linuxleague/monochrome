conky.config = {
  update_interval = 2,  -- update interval in seconds
  xinerama_head = 0,    -- for multi monitor setups, select monitor to run on: 0,1,2
  double_buffer = true, -- use double buffering (reduces flicker, may not work for everyone)

  -- window alignment
  alignment = 'top_left',       -- top|middle|bottom_left|middle|right
  gap_x = 152,                  -- same as passing -x at command line
  gap_y = 290,

  -- window settings
  minimum_width = 213,
  minimum_height = 110,
  own_window = true,
  own_window_type = 'desktop',    -- values: desktop (background), panel (bar)
  own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',

  -- transparency configuration
  own_window_transparent = false,
  own_window_argb_visual = false,  -- turn on transparency
  own_window_argb_value = 255,    -- range from 0 (transparent) to 255 (opaque)

  -- window borders
  draw_borders = false,     -- draw borders around the conky window
  border_width = 0,         -- width of border window in pixels
  stippled_borders = 0,     -- border stippling (dashing) in pixels
  border_inner_margin = 8,  -- margin between the border and text in pixels
  border_outer_margin = 0,  -- margin between the border and the edge of the window in pixels

  -- graph settings
  draw_graph_borders = false, -- borders around the graph, ex. cpu graph, network down speed grah
                              -- does not include bars, ie. wifi strength bar, cpu bar

  imlib_cache_flush_interval = 300,
  -- use the parameter -n on ${image ..} to never cache and always update the image upon a change
  
  if_up_strictness = 'address', -- network device must be up, having link and an assigned IP address
                                -- to be considered "up" by ${if_up}
                                -- values are: up, link or address

  -- font settings
  draw_shades = false,    -- black shadow on text (not good if text is black)
  draw_outline = false,   -- black outline around text (not good if text is black)

  -- colors
  default_color = '[=colors.systemText]',  -- regular text
  color1 = '[=colors.systemLabels]',         -- text labels
  own_window_colour = '[=colors.ownWindow]'
};

conky.text = [[
${color1}${goto 32}kernel${goto 75}${color}${kernel}
${voffset 3}${goto 32}${color1}uptime${goto 75}${color}${uptime}
${voffset 3}${color1}compositor${goto 75}${color}${execi 3600 echo $XDG_SESSION_TYPE}
${voffset 16}\
# if on wifi
${if_up wlp4s0}\
${voffset 3}${goto 19}${color1}network${goto 75}${color}${wireless_essid wlp4s0}
${voffset 3}${color1}${goto 12}local ip${goto 75}${color}${addr wlp4s0}
${voffset 8}\
${endif}\
# use of the netstat command to determine how many 'established' connections the transmission bittorrent client has currently open
${voffset 3}${color1}bittorrent${goto 75}${color}${execi 3 netstat -tuapn | grep -iE 'established.+transmission' | wc -l} peer(s)
${voffset 3}${color1}${goto 44}zoom${goto 75}${color}${if_running zoom}running${else}off${endif}
# :::::::::::: package updates
${if_existing /tmp/dnf.packages}\
${voffset 15}${alignc}${color1}dnf package management
${voffset 3}${alignc}${color}${lines /tmp/dnf.packages} package update(s) available
${if_existing /tmp/dnf.packages}\
${voffset 5}${color1}package${alignr}version
# the dnf package lookup script refreshes the package list every 10m
${voffset 3}${color}${cat /tmp/dnf.packages.preview}\
${endif}\
${else}\
${voffset 3}${goto 51}${color1}dnf${goto 75}${color}no updates available
${endif}\
]];