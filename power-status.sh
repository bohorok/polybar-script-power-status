#!/usr/bin/env bash

################# DEPENDENCIES ################
# acpi 1.7

pwr_time=$(acpi -b | awk '{print $5}' | awk -F":" '{print $1 ":" $2}')
let bat_status_command=$(acpi -b | awk -F", " '{gsub(/%/,""); print $2}')
power_profile=$(acpi -a | awk '{print $3}')
frgrd_end="%{F-}"
bckgd_end="%{B-}"
bckgd_frgrd_end="%{B- F-}"
##############################################################
##################### BEGIN SECTION CONFIG SCRIPT ###################
# Subtitle labels
label_plugged="  PWR AC "
label_unplugged="  PWR DC "
label_full="  FULL  "
appearance_time=" [${pwr_time}] " # don't change ${pwr_time}
bat_status=" ${bat_status_command}%" # don't change ${bat_staus_command}

# View: |only_percent | only_time | all
view="only_time"

# Colorize labels: |only_label | only_values | all
# Don't enabling background for module in polybar-config.ini
# For prawidłowego displaying Dostosuj value in keys: label-minlen =   label-maxlen = , in polybar config, 
# and settings spaces in labels in section config script  
colorize="only_values"

# background base. It's background that you settings in polybar.ini for module. 
# You disable background for module in polybar.ini  and settings this here.
bckgd_base="%{B#570000}"

# Mode lighting colors: | only_foreground | only_background | foregroud_and_background | default_polybar (defaults colors in config.ini polybar)
colors="foregroud_and_background"

# Threshold settings
# examle:
# <-----crit----|-----more-warn-----|-------warn------|---------------normal--------------------|----full---->
#                         10                                    15                             25                                                                       95                                                                                  

let value_full=95 # threshold for label_full
let normal=25
let warn=15
let more_warn=10

# lighting_status_colors: You can change color values after # 
frgrd_normal="%{F#FDB}"
frgrd_warn="%{F#FAC213}"
frgrd_more_warn="%{F#FAC213}"
frgrd_crit="%{F#FAC213}"

bckgd_normal="%{B#BF9742}"
bckgd_warn="%{B#802B24}"
bckgd_more_warn="%{B#E70}"
bckgd_crit="%{B#F00}"

########################## END SECTION CONFIG SECTION ####################
####################################################################

function colorize_mode()
{
case $colorize in
	only_label )
		user_choises+="_colorize_only_label"
		$user_choises
		;;
	only_values )
		user_choises+="_colorize_only_values"
		$user_choises
		;;
	all )
		user_choises+="_colorize_all"
		$user_choises
		;;
esac
}

function view_percent_colorize_only_label()
{
	if [[ $bat_status_command -ge $value_full ]]
		 then
		 	case $colors in
  			"only_foreground" ) echo "${frgrd_normal}${current_power_profile}${frgrd_end}${bckgd_base}${label_full}" ;;
  			"only_background" ) echo "${bckgd_normal}${current_power_profile}${bckgd_end}${bckgd_base}${label_full}" ;;
  			"foregroud_and_background" ) echo "${bckgd_normal}${frgrd_normal}${current_power_profile}${bckgd_frgrd_end}${bckgd_base}${label_full}" ;;
  			"default_polybar" ) echo "${current_power_profile}${label_full}" ;;
			esac
		
		elif [[ $bat_status_command -ge $normal && $bat_status_command -lt $value_full ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_normal}${current_power_profile}${frgrd_end}${bckgd_base}${bat_status}" ;;
  				"only_background" ) echo "${bckgd_normal}${current_power_profile}${bckgd_end}${bckgd_base}${bat_status}" ;;
  				"foregroud_and_background") echo "${bckgd_normal}${frgrd_normal}${current_power_profile}${bckgd_frgrd_end}${bckgd_base}${bat_status}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}" ;;
				esac
		
		elif [[ $bat_status_command -ge $warn && $bat_status_command -lt $normal ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_warn}${current_power_profile}${frgrd_end}${bckgd_base}${bat_status}" ;;
  				"only_background" ) echo "${bckgd_warn }${current_power_profile}${bckgd_end}${bckgd_base}${bat_status}" ;;
  				"foregroud_and_background") echo "${bckgd_warn }${frgrd_warn}${current_power_profile}${bckgd_frgrd_end}${bckgd_base}${bat_status}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}" ;;
				esac

		elif [[ $bat_status_command -ge $more_warn && $bat_status_command -lt $warn ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_more_warn}${current_power_profile}${frgrd_end}${bckgd_base}${bat_status}" ;;
  				"only_background" ) echo "${bckgd_more_warn }${current_power_profile}${bckgd_end}${bckgd_base}${bat_status}" ;;
  				"foregroud_and_background") echo "${bckgd_more_warn }${frgrd_more_warn}${current_power_profile}${bckgd_frgrd_end}${bckgd_base}${bat_status}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}" ;;
				esac

		elif [[ $bat_status_command -lt $more_warn ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_crit}${current_power_profile}${frgrd_end}${bckgd_base}${bat_status}" ;;
  				"only_background" ) echo "${bckgd_crit }${current_power_profile}${bckgd_end}${bckgd_base}${bat_status}" ;;
  				"foregroud_and_background") echo "${bckgd_crit }${frgrd_crit}${current_power_profile}${bckgd_frgrd_end}${bckgd_base}${bat_status}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}" ;;
				esac
		fi	
}

function view_percent_colorize_only_values()
{
	if [[ $bat_status_command -ge $value_full ]]
		 then
		 	case $colors in
  			"only_foreground" ) echo " ${bckgd_base}${current_power_profile}${bckgd_end}${frgrd_normal}${label_full}${frgrd_end}" ;;
  			"only_background" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_normal}${label_full}${bckgd_end}" ;;
  			"foregroud_and_background") echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_normal}${frgrd_normal}${label_full}${bckgd_frgrd_end}" ;;
  			"default_polybar" ) echo "${current_power_profile}${label_full}" ;;
			esac
		
		elif [[ $bat_status_command -ge $normal && $bat_status_command -lt $value_full ]]
			then
				case $colors in
  				"only_foreground" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${frgrd_normal} ${bat_status}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_normal}${bat_status}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_normal}${frgrd_normal}${bat_status}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}" ;;
				esac
		
		elif [[ $bat_status_command -ge $warn && $bat_status_command -lt $normal ]]
			then
				case $colors in
  				"only_foreground" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${frgrd_warn}${bat_status}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_warn}${bat_status}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_warn}${frgrd_warn}${bat_status}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}" ;;
				esac

		elif [[ $bat_status_command -ge $more_warn && $bat_status_command -lt $warn ]]
			then
				case $colors in
  				"only_foreground" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${frgrd_more_warn}${bat_status}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_more_warn}${bat_status}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_more_warn}${frgrd_more_warn}${bat_status}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}" ;;
				esac

		elif [[ $bat_status_command -lt $more_warn ]]
			then
				case $colors in
  				"only_foreground" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${frgrd_crit}${bat_status}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_crit}${bat_status}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_crit}${frgrd_crit}${bat_status}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}" ;;
				esac
	fi
}

function view_percent_colorize_all()
{
	if [[ $bat_status_command -ge $value_full ]]
		 then
		 	case $colors in
  			"only_foreground" ) echo "${frgrd_normal}${current_power_profile}${label_full}${frgrd_end}" ;;
  			"only_background" ) echo "${bckgd_normal}${current_power_profile}${label_full}${bckgd_end}" ;;
  			"foregroud_and_background") echo "${bckgd_normal}${frgrd_normal}${current_power_profile}${label_full}${bckgd_frgrd_end}" ;;
  			"default_polybar" ) echo "${current_power_profile}${label_full}" ;;
			esac
		
		elif [[ $bat_status_command -ge $normal && $bat_status_command -lt $value_full ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_normal}${current_power_profile}${bat_status}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_normal}${current_power_profile}${bat_status}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_normal}${frgrd_normal}${current_power_profile}${bat_status}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}" ;;
				esac
		
		elif [[ $bat_status_command -ge $warn && $bat_status_command -lt $normal ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_warn}${current_power_profile}${bat_status}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_warn}${current_power_profile}${bat_status}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_warn }${frgrd_warn}${current_power_profile}${bat_status}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}" ;;
				esac

		elif [[ $bat_status_command -ge $more_warn && $bat_status_command -lt $warn ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_more_warn}${current_power_profile}${bat_status}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_more_warn}${current_power_profile}${bat_status}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_more_warn}${frgrd_more_warn}${current_power_profile}${bat_status}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}" ;;
				esac

		elif [[ $bat_status_command -lt $more_warn ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_crit}${current_power_profile}${bat_status}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_crit}${current_power_profile}${bat_status}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_crit}${frgrd_crit}${current_power_profile}${bat_status}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}" ;;
				esac
	fi
}

function view_time_colorize_only_label()
{
	if [[ $bat_status_command -ge $value_full ]]
		 then
		 	case $colors in
  			"only_foreground" ) echo "${frgrd_normal}${current_power_profile}${frgrd_end}${bckgd_base}${label_full}" ;;
  			"only_background" ) echo "${bckgd_normal}${current_power_profile}${bckgd_end}${bckgd_base}${label_full}" ;;
  			"foregroud_and_background" ) echo "${bckgd_normal}${frgrd_normal}${current_power_profile}${bckgd_frgrd_end}${bckgd_base}${label_full}" ;;
  			"default_polybar" ) echo "${current_power_profile}${label_full}" ;;
			esac
		
		elif [[ $bat_status_command -ge $normal && $bat_status_command -lt $value_full ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_normal}${current_power_profile}${frgrd_end}${bckgd_base}${appearance_time}" ;;
  				"only_background" ) echo "${bckgd_normal}${current_power_profile}${bckgd_end}${bckgd_base}${appearance_time}" ;;
  				"foregroud_and_background") echo "${bckgd_normal}${frgrd_normal}${current_power_profile}${bckgd_frgrd_end}${bckgd_base}${appearance_time}" ;;
  				"default_polybar" ) echo "${current_power_profile}${appearance_time}" ;;
				esac
		
		elif [[ $bat_status_command -ge $warn && $bat_status_command -lt $normal ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_warn}${current_power_profile}${frgrd_end}${bckgd_base}${appearance_time}" ;;
  				"only_background" ) echo "${bckgd_warn }${current_power_profile}${bckgd_end}${bckgd_base}${appearance_time}" ;;
  				"foregroud_and_background") echo "${bckgd_warn}${frgrd_warn}${current_power_profile}${bckgd_frgrd_end}${bckgd_base}${appearance_time}" ;;
  				"default_polybar" ) echo "${current_power_profile}${appearance_time}" ;;
				esac

		elif [[ $bat_status_command -ge $more_warn && $bat_status_command -lt $warn ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_more_warn}${current_power_profile}${frgrd_end}${bckgd_base}${appearance_time}" ;;
  				"only_background" ) echo "${bckgd_more_warn}${current_power_profile}${bckgd_end}${bckgd_base}${appearance_time}" ;;
  				"foregroud_and_background") echo "${bckgd_more_warn}${frgrd_more_warn}${current_power_profile}${bckgd_frgrd_end}${bckgd_base}${appearance_time}" ;;
  				"default_polybar" ) echo "${current_power_profile}${appearance_time}" ;;
				esac

		elif [[ $bat_status_command -lt $more_warn ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_crit}${current_power_profile}${frgrd_end}${bckgd_base}${appearance_time}" ;;
  				"only_background" ) echo "${bckgd_crit }${current_power_profile}${bckgd_end}${bckgd_base}${appearance_time}" ;;
  				"foregroud_and_background") echo "${bckgd_crit}${frgrd_crit}${current_power_profile}${bckgd_frgrd_end}${bckgd_base}${appearance_time}" ;;
  				"default_polybar" ) echo "${current_power_profile}${appearance_time}" ;;
				esac
		fi	
}

function view_time_colorize_only_values()
{
if [[ $bat_status_command -ge $value_full ]]
		 then
		 	case $colors in
  			"only_foreground" ) echo " ${bckgd_base}${current_power_profile}${bckgd_end}${frgrd_normal}${label_full}${frgrd_end}" ;;
  			"only_background" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_normal}${label_full}${bckgd_end}" ;;
  			"foregroud_and_background") echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_normal}${frgrd_normal}${label_full}${bckgd_frgrd_end}" ;;
  			"default_polybar" ) echo "${current_power_profile}${label_full}" ;;
			esac
		
		elif [[ $bat_status_command -ge $normal && $bat_status_command -lt $value_full ]]
			then
				case $colors in
  				"only_foreground" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${frgrd_normal} ${appearance_time}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_normal}${appearance_time}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_normal}${frgrd_normal}${appearance_time}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${appearance_time}" ;;
				esac
		
		elif [[ $bat_status_command -ge $warn && $bat_status_command -lt $normal ]]
			then
				case $colors in
  				"only_foreground" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${frgrd_warn}${appearance_time}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_warn}${appearance_time}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_warn}${frgrd_warn}${appearance_time}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${appearance_time}" ;;
				esac

		elif [[ $bat_status_command -ge $more_warn && $bat_status_command -lt $warn ]]
			then
				case $colors in
  				"only_foreground" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${frgrd_more_warn}${appearance_time}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_more_warn}${appearance_time}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_more_warn}${frgrd_more_warn}${appearance_time}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${appearance_time}" ;;
				esac

		elif [[ $bat_status_command -lt $more_warn ]]
			then
				case $colors in
  				"only_foreground" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${frgrd_crit}${appearance_time}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_crit}${appearance_time}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_crit}${frgrd_crit}${appearance_time}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${appearance_time}" ;;
				esac
	fi
}

function view_time_colorize_all()
{
if [[ $bat_status_command -ge $value_full ]]
		 then
		 	case $colors in
  			"only_foreground" ) echo "${frgrd_normal}${current_power_profile}${label_full}${frgrd_end}" ;;
  			"only_background" ) echo "${bckgd_normal}${current_power_profile}${label_full}${bckgd_end}" ;;
  			"foregroud_and_background") echo "${bckgd_normal}${frgrd_normal}${current_power_profile}${label_full}${bckgd_frgrd_end}" ;;
  			"default_polybar" ) echo "${current_power_profile}${label_full}" ;;
			esac
		
		elif [[ $bat_status_command -ge $normal && $bat_status_command -lt $value_full ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_normal}${current_power_profile}${appearance_time}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_normal}${current_power_profile}${appearance_time}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_normal}${frgrd_normal}${current_power_profile}${appearance_time}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${appearance_time}" ;;
				esac
		
		elif [[ $bat_status_command -ge $warn && $bat_status_command -lt $normal ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_warn}${current_power_profile}${appearance_time}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_warn }${current_power_profile}${appearance_time}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_warn}${frgrd_warn}${current_power_profile}${appearance_time}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${appearance_time}" ;;
				esac

		elif [[ $bat_status_command -ge $more_warn && $bat_status_command -lt $warn ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_more_warn}${current_power_profile}${appearance_time}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_more_warn}${current_power_profile}${appearance_time}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_more_warn}${frgrd_more_warn}${current_power_profile}${appearance_time}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${appearance_time}" ;;
				esac

		elif [[ $bat_status_command -lt $more_warn ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_crit}${current_power_profile}${appearance_time}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_crit}${current_power_profile}${appearance_time}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_crit}${frgrd_crit}${current_power_profile}${appearance_time}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${appearance_time}" ;;
				esac
	fi
}

function view_all_colorize_only_label()
{
if [[ $bat_status_command -ge $value_full ]]
		 then
		 	case $colors in
  			"only_foreground" ) echo "${frgrd_normal}${current_power_profile}${frgrd_end}${bckgd_base}${label_full}" ;;
  			"only_background" ) echo "${bckgd_normal}${current_power_profile}${bckgd_end}${bckgd_base}${label_full}" ;;
  			"foregroud_and_background" ) echo "${bckgd_normal}${frgrd_normal}${current_power_profile}${bckgd_frgrd_end}${bckgd_base}${label_full}" ;;
  			"default_polybar" ) echo "${current_power_profile}${label_full}" ;;
			esac
		
		elif [[ $bat_status_command -ge $normal && $bat_status_command -lt $value_full ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_normal}${current_power_profile}${frgrd_end}${bckgd_base}${bat_status}${appearance_time}" ;;
  				"only_background" ) echo "${bckgd_normal}${current_power_profile}${bckgd_end}${bckgd_base}${bat_status}${appearance_time}" ;;
  				"foregroud_and_background") echo "${bckgd_normal}${frgrd_normal}${current_power_profile}${bckgd_frgrd_end}${bckgd_base}${bat_status}${appearance_time}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}${appearance_time}" ;;
				esac
		
		elif [[ $bat_status_command -ge $warn && $bat_status_command -lt $normal ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_warn}${current_power_profile}${frgrd_end}${bckgd_base}${bat_status}${appearance_time}" ;;
  				"only_background" ) echo "${bckgd_warn }${current_power_profile}${bckgd_end}${bckgd_base}${bat_status}${appearance_time}" ;;
  				"foregroud_and_background") echo "${bckgd_warn}${frgrd_warn}${current_power_profile}${bckgd_frgrd_end}${bckgd_base}${bat_status}${appearance_time}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}${appearance_time}" ;;
				esac

		elif [[ $bat_status_command -ge $more_warn && $bat_status_command -lt $warn ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_more_warn}${current_power_profile}${frgrd_end}${bckgd_base}${bat_status}${appearance_time}" ;;
  				"only_background" ) echo "${bckgd_more_warn}${current_power_profile}${bckgd_end}${bckgd_base}${bat_status}${appearance_time}" ;;
  				"foregroud_and_background") echo "${bckgd_more_warn}${frgrd_more_warn}${current_power_profile}${bckgd_frgrd_end}${bckgd_base}${bat_status}${appearance_time}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}${appearance_time}" ;;
				esac

		elif [[ $bat_status_command -lt $more_warn ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_crit}${current_power_profile}${frgrd_end}${bckgd_base}${bat_status}${appearance_time}" ;;
  				"only_background" ) echo "${bckgd_crit }${current_power_profile}${bckgd_end}${bckgd_base}${bat_status}${appearance_time}" ;;
  				"foregroud_and_background") echo "${bckgd_crit }${frgrd_crit}${current_power_profile}${bckgd_frgrd_end}${bckgd_base}${bat_status}${appearance_time}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}${appearance_time}" ;;
				esac
		fi	
}

function view_all_colorize_only_values()
{
if [[ $bat_status_command -ge $value_full ]]
		 then
		 	case $colors in
  			"only_foreground" ) echo " ${bckgd_base}${current_power_profile}${bckgd_end}${frgrd_normal}${label_full}${frgrd_end}" ;;
  			"only_background" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_normal}${label_full}${bckgd_end}" ;;
  			"foregroud_and_background") echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_normal}${frgrd_normal}${label_full}${bckgd_frgrd_end}" ;;
  			"default_polybar" ) echo "${current_power_profile}${label_full}" ;;
			esac
		
		elif [[ $bat_status_command -ge $normal && $bat_status_command -lt $value_full ]]
			then
				case $colors in
  				"only_foreground" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${frgrd_normal} ${bat_status}${appearance_time}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_normal}${bat_status}${appearance_time}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_normal}${frgrd_normal}${bat_status}${appearance_time}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}${appearance_time}" ;;
				esac
		
		elif [[ $bat_status_command -ge $warn && $bat_status_command -lt $normal ]]
			then
				case $colors in
  				"only_foreground" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${frgrd_warn}${bat_status}${appearance_time}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_warn}${bat_status}${appearance_time}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_warn}${frgrd_warn}${bat_status}${appearance_time}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${bckgd_base}${current_power_profile}${bat_status}${appearance_time}" ;;
				esac

		elif [[ $bat_status_command -ge $more_warn && $bat_status_command -lt $warn ]]
			then
				case $colors in
  				"only_foreground" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${frgrd_more_warn}${bat_status}${appearance_time}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_more_warn}${bat_status}${appearance_time}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_more_warn}${frgrd_more_warn}${bat_status}${appearance_time}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}${appearance_time}" ;;
				esac

		elif [[ $bat_status_command -lt $more_warn ]]
			then
				case $colors in
  				"only_foreground" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${frgrd_crit}${bat_status}${appearance_time}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_crit}${bat_status}${appearance_time}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_base}${current_power_profile}${bckgd_end}${bckgd_crit}${frgrd_crit}${bat_status}${appearance_time}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}${appearance_time}" ;;
				esac
	fi
}

function view_all_colorize_all()
{
if [[ $bat_status_command -ge $value_full ]]
		 then
		 	case $colors in
  			"only_foreground" ) echo "${frgrd_normal}${current_power_profile}${label_full}${frgrd_end}" ;;
  			"only_background" ) echo "${bckgd_normal}${current_power_profile}${label_full}${bckgd_end}" ;;
  			"foregroud_and_background") echo "${bckgd_normal}${frgrd_normal}${current_power_profile}${label_full}${bckgd_frgrd_end}" ;;
  			"default_polybar" ) echo "${current_power_profile}${label_full}" ;;
			esac
		
		elif [[ $bat_status_command -ge $normal && $bat_status_command -lt $value_full ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_normal}${current_power_profile}${bat_status}${appearance_time}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_normal}${current_power_profile}${bat_status}${appearance_time}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_normal}${frgrd_normal}${current_power_profile}${bat_status}${appearance_time}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile} ${bat_status}${appearance_time}" ;;
				esac
		
		elif [[ $bat_status_command -ge $warn && $bat_status_command -lt $normal ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_warn}${current_power_profile}${bat_status}${appearance_time}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_warn}${current_power_profile}${bat_status}${appearance_time}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_warn }${frgrd_warn}${current_power_profile}${bat_status}${appearance_time}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}${appearance_time}" ;;
				esac

		elif [[ $bat_status_command -ge $more_warn && $bat_status_command -lt $warn ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_more_warn}${current_power_profile}${bat_status}${appearance_time}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_more_warn}${current_power_profile}${bat_status}${appearance_time}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_more_warn}${frgrd_more_warn}${current_power_profile}${bat_status}${appearance_time}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}${appearance_time}" ;;
				esac

		elif [[ $bat_status_command -lt $more_warn ]]
			then
				case $colors in
  				"only_foreground" ) echo "${frgrd_crit}${current_power_profile}${bat_status}${appearance_time}${frgrd_end}" ;;
  				"only_background" ) echo "${bckgd_crit}${current_power_profile}${bat_status}${appearance_time}${bckgd_end}" ;;
  				"foregroud_and_background") echo "${bckgd_crit}${frgrd_crit}${current_power_profile}${bat_status}${appearance_time}${bckgd_frgrd_end}" ;;
  				"default_polybar" ) echo "${current_power_profile}${bat_status}${appearance_time}" ;;
				esac
	fi
}

user_choises=""

if [[ $power_profile = "on-line" ]]
then
	current_power_profile="${label_plugged}"
elif [[ $power_profile = "off-line" ]]
	then
	current_power_profile="${label_unplugged}"
fi

case $view in
	"only_percent" ) 
		user_choises+="view_percent"
		colorize_mode
		 ;;
	"only_time" )
		user_choises+="view_time"
		colorize_mode
		 ;;
	"all" )
		user_choises+="view_all"
		colorize_mode
		 ;;
esac
