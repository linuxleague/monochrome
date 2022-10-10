# Monochrome Conky
A collection of graphical [conky](https://github.com/brndnmtthws/conky) interfaces to monitor your system.  
Keep tabs on your system's cpu, memory, disk, network, battery usage and device temperatures.

### Compact dock
![edition edition](images/screenshots/compact.gif)

### Glass dock
![desktop edition](images/screenshots/glass.gif)

### Widgets dock
![laptop edition](images/screenshots/widgets-small.gif)

### Widgets | large
![desktop edition](images/screenshots/widgets-large.jpg)

# Scripts
These shell scripts were written two support this conky setup:

- A launcher script for executing multiple conky configs
- A script to monitor for new package updates

For more details on these scripts [see this wiki](https://github.com/ernesto1/monochrome/wiki/Scripts).

# How to install
### Dependencies
You only require to have `conky` installed on your system.  
On **Fedora** install it by running:

```
$ sudo dnf install conky
```

**n.b.** I recommend using the conky package version `1.11.5_pre`  
more recent versions may have regressions/bugs ([issue 1](https://github.com/brndnmtthws/conky/issues/960), [issue 2](https://github.com/brndnmtthws/conky/issues/979)) that cause the theme to behave erratically.

Run the command `dnf downgrade conky` until you arrive at this version or download the RPM [from the web](https://rpm.pbone.net/info_idpl_70128821_distro_fedora32_com_conky-1.11.5-3.fc32.x86_64.rpm.html).

### Fonts
Time conkys use these fonts:

- [Promenade de la Croisette](https://www.fontspace.com/promenade-de-la-croisette-font-f23769)
- Noto Sans CJK JP Thin (default on fedora)

### Download the code for these conky scripts
Create the `~/conky` directory and clone this repository

       $ mkdir ~/conky
       $ cd ~/conky
       $ git clone https://github.com/ernesto1/monochrome.git

Alternatively you can download the latest `monochrome.zip` file from the releases page.

### Configuration
The [wiki](https://github.com/ernesto1/monochrome/wiki) outlines items that may require configuration in order to customize this conky to your system, ex. device names such as network cards and hard drives


# How to run
Run the launch script with the theme you want:

    - Glass

      $ ~/conky/monochrome/launch.bash --glass

    - Compact

      $ ~/conky/monochrome/launch.bash --compact

    - Widgets dock

      $ ~/conky/monochrome/launch.bash --widgets-dock

    - Widgets large

      $ ~/conky/monochrome/launch.bash --widgets-large
