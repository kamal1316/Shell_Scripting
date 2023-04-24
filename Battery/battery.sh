#! /usr/bin/bash

while true
do
	battery=$( upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep -E "percentage" | grep -Eo "[0-9]+" )

	battery_status=$( upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep -E "state" | grep -Eo "[a-z]*ing" )

	message="No message"

	if [ "$battery_status" == "charging" -a "$battery" -gt "80" ]
	then
		# play the sound and redirects stdout and stderr to null device.
		play "/usr/share/sounds/freedesktop/stereo/bell.oga" >/dev/null 2>&1
		
		message="Remove Charger Now !!!"

	elif [ "$battery_status" = "discharging" -a "$battery" -lt "40" ]
	then
		# play the sound and redirects stdout and stderr to null device.
		play "/usr/share/sounds/freedesktop/stereo/bell.oga" >/dev/null 2>&1

		message="Battery low. Plugin Charger Now !!!"
	fi

	if [ "$message" != "No message" ]
	then
		zenity --question --text="$message" --ok-label="Disable for 1 hr" --cancel-label="Ignore"

		if [ $? -eq 0 ]
		then
			sleep 3600s
		else
			sleep 10s
		fi
	else
		sleep 60s
	fi
done
