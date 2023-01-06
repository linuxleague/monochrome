conky.config = {
  update_interval = 1,    -- update interval in seconds
  xinerama_head = 1,      -- for multi monitor setups, select monitor to run on: 0,1,2
  double_buffer = true,   -- use double buffering (reduces flicker, may not work for everyone)

  -- window alignment
  alignment = 'middle_left',  -- top|middle|bottom_left|right
  gap_x = 2,               -- same as passing -x at command line
  gap_y = -324,

  -- window settings
  minimum_width = 56,      -- conky will add an extra pixel to this
  minimum_height = 10,
  own_window = true,
  own_window_type = 'panel',    -- values: desktop (background), panel (bar)
  own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager',

  -- window borders
  draw_borders = false,     -- draw borders around the conky window
  border_width = 0,         -- width of border window in pixels
  border_inner_margin = 0,  -- margin between the border and text in pixels
  border_outer_margin = 0,  -- margin between the border and the edge of the window in pixels
  
  -- transparency configuration
  own_window_transparent = true,
  own_window_argb_visual = true,  -- turn on transparency
  own_window_argb_value = 255,    -- range from 0 (transparent) to 255 (opaque)
  
  -- font settings
  use_xft = true,
  xftalpha = 1,
  uppercase = true,
  draw_shades = false,      -- black shadow on text (not good if text is black)
  draw_outline = false,     -- black outline around text (not good if text is black)
  -- colors
  default_color = '[=colors.widgetText]',  -- regular text
  color1 = '[=colors.widgetTextSmall]'
};

conky.text = [[
# this conky uses the 'panel' window type in order to create a sidebar panel effect on the monitor
# when an application window is maximized, the widgets will still be visible
${alignc}${color}${font Promenade de la Croisette:size=40}${time %I}${font Promenade de la Croisette:size=37}:${time %M}
${voffset -29}${alignc}${color1}${font Noto Sans CJK JP Thin:size=11}${time %a}
]];