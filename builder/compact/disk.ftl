# -------------- disk
${image ~/conky/monochrome/images/compact/[=image.primaryColor]-disk.png -p 0,0}\
${template5 sda 60000 60000}
${voffset 6}${template6 fedora /}
${image ~/conky/monochrome/images/compact/[=image.primaryColor]-filesystem.png -p 0,103}\
${template6 home /home}
