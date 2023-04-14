#!/bin/bash


enumAppInfoList() {
    appInfoList=()
    apps="/opt/apps"
    list=$(ls $apps)
    for appID in $list; do
        appInfoList+=("$appID")
    done
    echo "${appInfoList[@]}"
}
LinkApp() {
    appID=$1
    appEntriesDir="/opt/apps/$appID/entries"
    appLibsDir="/opt/apps/$appID/files/lib"
    autoStartDir="$appEntriesDir/autostart"

    if [ -d "$autoStartDir" ]; then
        linkDir "$autoStartDir" "/etc/xdg/autostart"
    fi

    # link application
    sysShareDir="/usr/share"
    for folder in "$appEntriesDir/applications" "$appEntriesDir/icons" "$appEntriesDir/mime" "$appEntriesDir/glib-2.0" "$appEntriesDir/services" "$appEntriesDir/GConf" "$appEntriesDir/help" "$appEntriesDir/locale" "$appEntriesDir/fcitx"; do
        if [ ! -d "$folder" ]; then
            continue
        fi
        if [ "$folder" = "$appEntriesDir/polkit" ]; then
            linkDir "$folder" "/usr/share/polkit-1"
        elif [ "$folder" = "$appEntriesDir/fonts/conf" ]; then
            linkDir "$folder" "/etc/fonts/conf.d"
        else
            linkDir "$folder" "$sysShareDir/${folder##*/}"
        fi
    done
}


# execute linkApp function for each app and print output
for app in $(enumAppInfoList); do
    linkApp "$app"

    if [ "$1" = "--debug" ]; then
        echo "Linking complete for $app"
    fi
# remove broken links in /usr/share
find /usr/share -xtype l -delete

done

