#!/bin/zsh

# The uninstall script needs to be run as the `root` user to delete from `/Applications`
if [ "$(id -u)" -ne 0 ]; then
   echo "Uninstalling Mac Monitor must be done with root permissions. Please re-run with elevation." 1>&2
   exit 1
fi

# Open the app with the deactivation flag. The user will have 60 seconds to enter their password.
/usr/bin/open -a "/Applications/Mac Monitor.app" --args --deactivate-security-extension

# We're going to keep checking to see if the Red Canary Security Extension is activated
# If it is we need to wait because the user is entering their password
# If we've been waiting for more than a minute bail
counter=0
uninstall_success=true
while true; do
    output=$(systemextensionsctl list)
    echo "$output" | grep -E "Mac Monitor Security Extension.*\[activated enabled\]" > /dev/null
    if [ $? -ne 0 ]; then
        echo "Security Extension uninstall successful"
        break
    fi

    sleep 1
    counter=$((counter+1))

    if [ $counter -eq 60 ]; then
        echo "User interaction timeout"
        uninstall_success=false
        break
    fi
done

# Kill the app
/usr/bin/killall "Mac Monitor"

sleep 1

# Forcefully delete
if [ "$uninstall_success" = true ]; then
    /bin/rm -rf "/Applications/Mac Monitor.app" && echo "App successfully deleted"
fi
