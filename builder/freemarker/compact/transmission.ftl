<#import "/lib/menu-round.ftl" as menu>
conky.config = {
  lua_load = '~/conky/monochrome/common.lua ~/conky/monochrome/menu.lua',
  lua_draw_hook_pre = 'reset_state',
  
  update_interval = 3,    -- update interval in seconds
  xinerama_head = 0,      -- for multi monitor setups, select monitor to run on: 0,1,2
  double_buffer = true,   -- use double buffering (reduces flicker, may not work for everyone)

  -- window alignment
  alignment = 'top_left',  -- header|middle|bottom_left|right
  gap_x = 205,
  gap_y = 553,

  -- window settings
  minimum_width = 273,      -- conky will add an extra pixel to this  
  maximum_width = 273,
  minimum_height = 1035,
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
  
  imlib_cache_flush_interval = 250,
  text_buffer_size=2096,

  -- font settings
  use_xft = false,
  draw_shades = false,      -- black shadow on text (not good if text is black)
  draw_outline = false,     -- black outline around text (not good if text is black)
  -- colors
  default_color = '[=colors.menuText]', -- regular text
  color1 = '[=colors.labels]',         -- labels
  color2 = '[=(colors.warning)?c]'         -- bar critical
};

conky.text = [[
# this conky requires:
# - the 'remote control' feature enabled in the transmission bittorrent client: edit > preferences > remote
# - the transmission.bash script running in the background
# :::::::::::: torrents overview
${if_running transmission-gt}\
<#assign y = 0, 
         header = 75, <#-- menu header -->
         body = 71,   <#-- menu window without the header -->
         width = 189, <#-- default menu width -->
         gap = 3>     <#-- empty space between windows -->
<@menu.verticalTable x=0 y=y header=header body=width-header height=body/>
<#assign y += body + gap>
${lua add_offsets 0 [=y?c]}\
<#assign inputDir = "/tmp/conky"
         peersFile = inputDir + "/transmission.peers",
         seedingFile = inputDir + "/transmission.seeding",
         downloadingFile = inputDir + "/transmission.downloading",
         idleFile = inputDir + "/transmission.idle",
         activeTorrentsFile = inputDir + "/transmission.active">
${voffset 5}${offset 5}${color1}swarm${goto 81}${color}${if_existing [=peersFile]}${lua pad ${lua get peers ${lines [=peersFile]}}} peer(s)${else}file missing${endif}
${voffset 3}${offset 5}${color1}seeding${goto 81}${color}${if_existing [=seedingFile]}${lua pad ${lines [=seedingFile]}} torrent(s)${else}file missing${endif}
${voffset 3}${offset 5}${color1}downloading${goto 81}${color}${if_existing [=downloadingFile]}${lua pad ${lines [=downloadingFile]}} torrent(s)${else}file missing${endif}
${voffset 3}${offset 5}${color1}idle${goto 81}${color}${if_existing [=idleFile]}${lua pad ${lines [=idleFile]}} torrent(s)${else}file missing${endif}
${voffset [= 7 + gap]}\
# :::::::::::: active torrents
${if_existing [=activeTorrentsFile]}\
${if_match ${lines [=activeTorrentsFile]} > 0}\
<#assign header = 19, miniWindow = 39>
<@menu.table x=0 y=y width=width header=header bottomEdges=false/>
<@menu.table x=width+gap y=y width=39 header=header bottomEdges=false/>
<@menu.table x=width+gap+miniWindow+gap y=y width=39 header=header bottomEdges=false/>
${image ~/conky/monochrome/images/[=conky]/[=image.primaryColor]-menu-peers.png -p 38,[=y+header+22]}\
${lua configure_menu [=conky] [=image.primaryColor]-menu-light-edge-bottom [=width?c] 3}\
<#assign y += header>
${lua add_offsets 0 [=header]}\
${goto 48}${color1}active torrents${goto 207}up${goto 243}down${voffset 3}
<#assign maxLines = 25>
${color}${lua_parse head [=activeTorrentsFile] [=maxLines]}${voffset [= 7 + gap]}
${lua_parse draw_bottom_edges [=width+gap] [=y?c] 39}${lua_parse draw_bottom_edges [=width+gap+miniWindow+gap] [=y?c] 39}\
${lua add_offsets 0 [=gap]}\
${endif}\
${else}\
<#assign body = 35>
<@menu.menu x=0 y=71 + gap width=width height=body/>
${lua add_offsets 0 [=body + gap]}\
${goto 17}${color}active torrents input file
${voffset 3}${goto 65}is missing
${voffset [= 7 + gap]}\
${endif}\
# :::::::::::: peers
${if_existing [=peersFile]}\
${if_match ${lua get peers} > 0}\
<@menu.table x=0 y=0 width=width header=header bottomEdges=false fixed=false/>
${lua configure_menu compact [=image.primaryColor]-menu-light-edge-bottom [=width?c] 3}\
${lua add_offsets 0 [=header]}\
${offset 5}${color1}ip address${goto 108}client${voffset 3}
<#assign maxLines = 32>
${color}${lua_parse head [=peersFile]}
${endif}\
${else}\
<@menu.menu x=0 y=0 width=width height=body fixed=false/>
${lua add_offsets 0 [=body + gap]}\
${voffset 6}${goto 14}${color}peers input file is missing
${voffset [= 7 + gap]}\
${endif}\
${endif}\
]];
