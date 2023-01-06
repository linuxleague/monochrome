################### network
# if on wifi
${if_up wlp4s0}\
${image ~/conky/monochrome/images/glass/[=image.primaryColor]-network-wifi.png -p 0,0}\
${image ~/conky/monochrome/images/glass/[=image.primaryColor]-network-internet.png -p 0,57}\
${voffset 12}${offset 5}${color1}${font0}wifi
${voffset -9}${alignr}${color}${font2}${wireless_link_qual_perc wlp4s0}${font3}% 
${voffset -2}${offset 16}${color2}${if_match ${wireless_link_qual_perc wlp4s0} < 30}${color3}${endif}${wireless_link_bar 3,93 wlp4s0}
${voffset -4}${offset 5}${color}${font4}ch. ${wireless_channel wlp4s0}${alignr}${wireless_bitrate wlp4s0} ${voffset 0}
${template4 wlp4s0 3000 60000}
${else}\
# is the ethernet up?
${if_up enp6s0}\
${image ~/conky/monochrome/images/glass/[=image.primaryColor]-network-ethernet.png -p 0,0}\
${image ~/conky/monochrome/images/glass/[=image.primaryColor]-network-internet.png -p 0,57}\
${template3 enp6s0}
${template4 enp6s0 3000 60000}
${else}\
# no network/internet
${image ~/conky/monochrome/images/glass/[=image.secondaryColor]-network-internet-disconnected-wifi.png -p 0,0}\
${voffset 12}${offset 5}${color1}${font0}network
${voffset 143}${alignc}${color}${font4}no network
${alignc}connection
${voffset -10}
${endif}\
${endif}\