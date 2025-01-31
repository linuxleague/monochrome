<#import "/lib/menu-square.ftl" as menu>
conky.config = {
  lua_load = '~/conky/monochrome/common.lua ~/conky/monochrome/menu.lua',
  lua_draw_hook_pre = 'reset_state',
  
  update_interval = 2,    -- update interval in seconds
  xinerama_head = 0,      -- for multi monitor setups, select monitor to run on: 0,1,2
  double_buffer = true,   -- use double buffering (reduces flicker, may not work for everyone)

  -- window alignment
  alignment = 'bottom_left',  -- top|middle|bottom_left|right
  gap_x = 123,
  gap_y = 10,

  -- window settings
  minimum_width = 373,      -- conky will add an extra pixel to this width
  maximum_width = 373,
  minimum_height = 46,      -- conky will add an extra pixel to this height
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
  draw_shades = false,    -- black shadow on text (not good if text is black)
  draw_outline = false,   -- black outline around text (not good if text is black)
  
  -- colors
  default_color = '[=colors.systemText]',  -- regular text
  color1 = '[=colors.systemLabels]',         -- text labels
  
  -- n.b. this conky requires the music-player java app to be running in the background
  --      it generates input files under /tmp/conky/musicplayer.* which this conky will read
};

conky.text = [[
# the UI of this conky changes as per one of these states: no music player is running
#                                                          song with album art
#                                                          song with no album art
# :::: no player available
${if_existing /tmp/conky/musicplayer.name Nameless}\
${image ~/conky/monochrome/images/[=conky]/[=image.primaryColor]-sound-wave-small.png -p 0,0}\
<@menu.table x=49 y=0 width=110 header=3 body=43/>
${voffset 10}${goto 55}${color1}now playing
${voffset 4}${goto 55}${color}no player running\
${else}\
# :::::::: album art
${if_existing /tmp/conky/musicplayer.albumArtPath}\
${image ~/conky/monochrome/images/[=conky]/[=image.primaryColor]-music-player-album.png -p 0,0}\
${lua_parse album_art_image ${cat /tmp/conky/musicplayer.albumArtPath} 146x146 6,7}\
# having album art will push the track details text & images towards the bottom right
${lua add_offsets 91 84}\
# ::: player header
${voffset 64}${goto 168}${color1}\
${if_existing /tmp/conky/musicplayer.playbackStatus Playing}now playing on\
${else}${lua_parse truncate_string ${cat /tmp/conky/musicplayer.playbackStatus}}${endif}\
${goto 310}${color}${lua_parse truncate_string ${cat /tmp/conky/musicplayer.name}}${voffset 7}
# :::::::: no album art
${else}\
${image ~/conky/monochrome/images/[=conky]/[=image.primaryColor]-sound-wave.png -p 0,0}\
${endif}\
# ::::::::: track details
${lua_parse draw_image ~/conky/monochrome/images/common/[=image.primaryColor]-menu-dark.png 71 0}\
${lua_parse draw_image ~/conky/monochrome/images/common/[=image.primaryColor]-menu-light.png 116 0}\
# add blank out images to ensure the menu image comes out correctly
# right side
${lua_parse draw_image ~/conky/monochrome/images/common/menu-blank.png 282 0}\
# bottom
${lua_parse draw_image ~/conky/monochrome/images/common/menu-blank.png 71 69}${lua_parse draw_image ~/conky/monochrome/images/common/menu-blank.png 96 69}\
${voffset 3}${lua_parse add_x_offset goto 77}${color1}title${lua_parse add_x_offset goto 122}${color}${lua_parse truncate_string ${cat /tmp/conky/musicplayer.title} 26}
${voffset 3}${lua_parse add_x_offset goto 77}${color1}album${lua_parse add_x_offset goto 122}${color}${lua_parse truncate_string ${cat /tmp/conky/musicplayer.album} 26}
${voffset 3}${lua_parse add_x_offset goto 77}${color1}artist${lua_parse add_x_offset goto 122}${color}${lua_parse truncate_string ${cat /tmp/conky/musicplayer.artist} 26}
${voffset 3}${lua_parse add_x_offset goto 77}${color1}genre${lua_parse add_x_offset goto 122}${color}${lua_parse truncate_string ${cat /tmp/conky/musicplayer.genre} 26}\
${endif}\
# the final vertical offset required depends on what UI is active
${voffset 5}${if_existing /tmp/conky/musicplayer.albumArtPath}${voffset 5}${endif}\
]];
