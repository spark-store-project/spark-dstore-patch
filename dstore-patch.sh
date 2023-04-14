#!/bin/bash

echo "----------------Running Spark DStore Patch----------------"
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
linkDir() {
    ensureTargetDir() {
        targetFile=$1
        t=$(dirname "$targetFile")
        mkdir -p "$t"
    }

    source=$1
    target=$2
    sourceDir=$(dirname "$source")
    targetDir=$(dirname "$target")
    find "$source" -type f | while read sourceFile; do
        targetFile="$targetDir/${sourceFile#$sourceDir/}"
        if [ -L "$targetFile" ] && [ "$(readlink "$targetFile")" = "$sourceFile" ]; then
            continue
        else
            rm -f "$targetFile"
        fi

        ensureTargetDir "$targetFile"
        ln -s "$sourceFile" "$targetFile"
    done
}

linkApp() {
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

done
find /usr/share -xtype l -delete
find /etc/fonts/conf.d -xtype l -delete

echo "----------------Finished----------------"