################### external hard drive
${if_mounted /run/media/ernesto/MAXTOR}\
${image ~/conky/monochrome/images/glass/[=image.primaryColor]-disk.png -p 0,0}\
# speeds | read: 24MiB  write: 24MiB (the usb2 max speed)
${template5 sdg1 6000 52000}
${template6 maxtor\ HD /run/media/ernesto/MAXTOR}
${else}\
${image ~/conky/monochrome/images/glass/[=image.secondaryColor]-disk-disconnected.png -p 0,0}\
${voffset 12}${alignc}${color}${font0}maxtor HD
${voffset 103}${alignc}${color}${font}device is not
${alignc}connected
${endif}\
