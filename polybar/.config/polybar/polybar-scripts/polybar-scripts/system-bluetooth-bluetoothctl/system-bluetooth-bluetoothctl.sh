#!/bin/sh

bluetooth_print() {
    bluetoothctl | while read -r; do
        if [ "$(systemctl is-active "bluetooth.service")" = "active" ]; then
            if [ "$(bluetoothctl show | grep Powered | cut -c11-)" = "yes" ]; then
                          echo "󰂯"
                #printf ''
            #fi

              devices_paired=$(bluetoothctl paired-devices | grep Device | cut -d ' ' -f 2)
              counter=0

              echo "$devices_paired" | while read -r line; do
                  device_info=$(bluetoothctl info "$line")

                  if echo "$device_info" | grep -q "Connected: yes"; then
                      #device_alias=$(echo "$device_info" | grep "Alias" | cut -d ' ' -f 2-)

                      #if [ $counter -gt 0 ]; then
                          ##printf ", %s" "$device_alias"
                          #print "󰂱"
                      #else
                          ##printf " %s" "$device_alias"
                          #print "󰂯"
                      #fi

                      counter=$((counter + 1))
                      if [ $counter -gt 0 ]; then
                          echo "󰂱"
                      else
                          #printf " %s" "$device_alias"
                          echo "󰂯"
                      fi
                  fi

                  #printf '\n'
              done
          else
            printf "󰂲\n"
          fi
        else
            echo "󰂭"
        fi
    done
}

bluetooth_toggle() {
    if bluetoothctl show | grep -q "Powered: no"; then
        bluetoothctl power on >> /dev/null
        sleep 1

        devices_paired=$(bluetoothctl paired-devices | grep Device | cut -d ' ' -f 2)
        echo "$devices_paired" | while read -r line; do
            bluetoothctl connect "$line" >> /dev/null
        done
    else
        devices_paired=$(bluetoothctl paired-devices | grep Device | cut -d ' ' -f 2)
        echo "$devices_paired" | while read -r line; do
            bluetoothctl disconnect "$line" >> /dev/null
        done

        bluetoothctl power off >> /dev/null
    fi
}

case "$1" in
    --toggle)
        bluetooth_toggle
        ;;
    *)
        bluetooth_print
        ;;
esac
