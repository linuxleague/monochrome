<#import "/lib/menu-round.ftl" as menu>

<#macro network devices mainDeviceType>
<#assign device = devices?first>
# :::: [=device.type]
${if_up [=device.name]}\
<#if device.type == "wifi">
<@wifi device/>
<#else>
<@ethernet/>
</#if>
# :: upload/download speeds
${image ~/conky/monochrome/images/widgets-dock/[=image.primaryColor]-internet.png -p 0,64}\
${template4 [=device.name] [=device.maxUp?c] [=device.maxDown?c]}
<#if devices?size gt 1>
${else}\
<@network devices[1..<devices?size] mainDeviceType/>
<#else>
${else}\
${image ~/conky/monochrome/images/widgets-dock/[=image.secondaryColor]-[=mainDeviceType]-disconnected.png -p 0,0}
${image ~/conky/monochrome/images/widgets-dock/[=image.secondaryColor]-internet-offline.png -p 0,64}\
${voffset 117}
</#if>
${endif}\
</#macro>

<#macro wifi device>
${image ~/conky/monochrome/images/widgets-dock/[=image.primaryColor]-wifi.png -p 0,0}\
${if_match ${wireless_link_qual_perc [=device.name]} == 100}${image ~/conky/monochrome/images/widgets-dock/text-box-100.png -p 114,24}${endif}\
${voffset 49}${offset 6}${color2}${if_match ${wireless_link_qual_perc [=device.name]} < 30}${color3}${endif}${wireless_link_bar 3,45 [=device.name]}
#${wireless_essid [=device.name]}
${voffset -29}${goto 67}${color}${font1}${wireless_link_qual_perc [=device.name]}${font0}%${font}${voffset 1}
</#macro>

<#macro ethernet>
${image ~/conky/monochrome/images/widgets-dock/[=image.primaryColor]-ethernet.png -p 0,0}\
# ethernet details printed on the system conky
${voffset 48}
</#macro>

<#--
  prints network details such as ip address, network name and up/down speeds

    if device 1
      if device 2
        if device 3
          else no internet
        fi
      fi
    fi
    
  if multiple devices are connected to the internet, the one at the top of the hierarchy
  is displayed
-->
<#macro networkDetails devices y width gap>
<#assign device = devices?first>
# :::: [=device.type]
${if_up [=device.name]}\
<#local height = 71>
<#if device.type == "wifi">
<@menu.verticalTable x=0 y=y header=57 body=width-57 height=height/>
${lua add_offsets 0 [=height + gap]}\
${image ~/conky/monochrome/images/[=conky]/[=image.primaryColor]-menu-horizontal-data.png -p 57,[=y]}\
<@wifiDetails device/>
<#else>
<@menu.verticalTable x=0 y=y header=75 body=width-75 height=height/>
${lua add_offsets 0 [=height + gap]}\
<@ethernetDetails device/>
</#if>
<#if devices?size gt 1>
${else}\
<@networkDetails devices=devices[1..<devices?size] y=y width=width gap=gap/>
</#if>
${endif}\
</#macro>

<#macro wifiDetails device>
${voffset 15}${offset 5}${color1}network${goto 63}${color}${wireless_essid [=device.name]}
${voffset 3}${offset 5}${color1}local ip${goto 63}${color}${addr [=device.name]}
${voffset 3}${offset 5}${color1}bitrate${goto 63}${color}${wireless_bitrate [=device.name]}
${voffset 3}${offset 5}${color1}channel${goto 63}${color}${wireless_channel [=device.name]}
</#macro>

<#macro ethernetDetails device>
${voffset 15}${offset 5}${color1}local ip${goto 81}${color}${addr [=device.name]}
${voffset 3}${offset 5}${color1}speed${goto 81}${color}${execi 180 ethtool [=device.name] 2>/dev/null | grep -i speed | cut -d ' ' -f 2}
${voffset 3}${offset 5}${color1}total up${goto 81}${color}${totalup [=device.name]}
${voffset 3}${offset 5}${color1}total down${goto 81}${color}${totaldown [=device.name]}
</#macro>
