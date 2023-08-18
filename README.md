##### POLYBAR SCRIPT POWER STATUS
configurable module in the form of a bash script displaying information about the power status for polybar.
For use width laptops. Displays the output in colors, depending on the acquired values with a status of.
Colors for four leves value are configurable.

##### PRESENTATION
![script in working](media/presentation.gif  "presentation")

##### DEPENDENCIES
* Installed and working bar polybar
* acpi version 1.7
The script has been tested with version 1.7, but it will probably work correctly with other versions

##### EXAMPLE CONFIGURATION OF THE MODULE IN THE POLYBAR CONFIGURATION FILE (CONFIG.INI)
```
module/power-status]
type = custom/script
exec = $HOME/.config/polybar/scripts/power/power-status.sh
interval = 10
format = <label>
label = %output%
label-minlen = 62
label-maxlen = 62
label-alignment = right
```
script have different lenght output depending on the configuration, therefore lenght in
keys:
label-minlen
label-maxlen
belongs this should be determined experimentally.

##### CONFIGURABLE SCRIPT OUTPUT
When you add a script to the bar, the data generated and its appearance will depend on the 
configuration in the script. All available configuration options are available inside the 
script in the section config script
