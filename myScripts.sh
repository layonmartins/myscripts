################################################################################
# layonf script


################################################################################
# Other Scripts should be insert here below:

#Function to print Hello Word myScript concatenated is variable $1
myHello(){
    echo "Hello World $1"
}

################################################################################
#Function to test -parameter
myTest() {
    if [ "$1" == "-Hi" ]
    then
        myHello mano
    fi
}


###############################################################################
# Function to print mygrep usage #
mygrepusage() {
    echo "######################## mygrep HELP: ########################"
    echo "Version 1.0"
    echo

    echo "Default option: "
    echo "      - Pass a parameter or regular expression to be grepped in all files in directory "
    echo "      - The grep is sorted, there are no repeated lines and date/hour is colorful"
    echo
    echo "      - Example usages: "
    echo "              e.g1: '~$ mygrep notification_enqueue' will return all logs with 'notification_enqueue' matchs"
    echo "              e.g2: '~$ mygrep notification_enqueue|notification_canceled' will return all logs with 'notification_enqueue' or 'notification_canceled' matchs"
    echo "              e.g3: '~$ mygrep notification_enqueue.*com.android.systemui' will return all logs with 'notification_enqueue' and 'com.android.systemui' matchs"
    echo
    echo "-appsenq: | --appsenqueue "
    echo "      - Will return all apps that have posted any 'x' notifications and frenquence of the posting"
    echo "              e.g: '~$ mygrep -appsenq"
    echo
    echo "-notilist: | --notificationlist "
    echo "      - Will print the bugreport.txt 'notification list:' - that is a notificationRecord info of all notifications in statusbar"
    echo "              e.g: mygrep -notilist"
    echo
    echo "-channels | --notificationchannels "
    echo "      - Will print the bugreport.txt 'notification channels of all apk:' - AppSettings"
    echo "              e.g: mygrep -channels"
    echo
    echo "-activenoti | --activenotifications "
    echo "      - Will print the bugreport.txt 'active/inactive notification list:' - AppSettings"
    echo "              e.g: mygrep -activenoti"

}

###############################################################################
# mygrep options functions: #
appsenq() {
    echo
    echo "################# mygrep -appsenq option result: ###################"
    echo "These are the packages that have posted any 'X' notifications: "
    echo
    echo "Packages List:"
    grep -F -h "notification_enqueue: [" *events.txt | cut -d, -f3 | sort | uniq -c
    echo
}


notilist() {
    
    # TODO pass a parameter and return specifif notificationRecord info from the package or channel

    echo
    echo "################# mygrep -notilist option result: ###################"
    echo "These are the 'notification list:' of DUMP OF SERVICE CRITICAL notification: "
    echo
    echo "Notification List:"

    # get the head and tail line number OF DUMP OF SERVICE CRITICAL notification logs 
    local start=$(grep -n "DUMP OF SERVICE CRITICAL notification" bugreport.txt | grep -Eo '^[^:]+');
    local end=$(grep -n -m 1 "was the duration of dumpsys notification" bugreport.txt | grep -Eo '^[^:]+');

    sed -n "${start},${end}p" bugreport.txt;

    echo
}

channels() {

    # TODO pass a parameter and return specifif channels from the package or channelname

    echo
    echo "################# mygrep -channels option result: ###################"
    echo "These are all notification channels - DUMP OF SERVICE notification: "
    echo
    echo "Notification List:"

    # get the head and tail line number OF DUMP OF SERVICE CRITICAL notification logs 
    local start=$(grep -n "Notification Preferences:" bugreport.txt | grep -Eo '^[^:]+');
    local end=$(grep -n "Restored without uid:" bugreport.txt | grep -Eo '^[^:]+');
    end=$((end-1))

    sed -n "${start},${end}p" bugreport.txt;

    echo
}

activenoti() {
    
    # TODO pass a parameter and return specifif notification

    echo
    echo "################# mygrep -activenoti option result: ###################"
    echo "These are the 'active notifications: X' of DUMP OF SERVICE notification: "
    echo
    
    #doesn't needed
    # get the numbers of active notification
    #active=$(grep -h " active notifications:" bugreport.txt | cut -d: -f2);
    # get the numbers of inactive notification
    #inactive=$(grep -h "inactive notifications:" bugreport.txt | cut -d: -f2);
    #echo "active notifications: ${active}"

    # get the start and end line
    local start=$(grep -n -m 1 " active notifications:" bugreport.txt | grep -Eo '^[^:]+');
    local end=$(grep -n -m 1 "HeadsUpManagerPhone state:" bugreport.txt | grep -Eo '^[^:]+');
    end=$((end-1))
    sed -n "${start},${end}p" bugreport.txt;
    echo
}

################################################################################
#Function mygrep to use my formatation "[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9].[0-9][0-9][0-9]”
#this regular expression "[0-9][0-9].." will colorful the time and other $1's of the logs.
mygrep(){
    
    #Print help

    #return the apps that post any notification enqueued
    #if [ "$1" == "-help" ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]
    #then
     #   mygrepusage
    #fi

    case $1 in

    # print helper usage:
    -help | --help | -h | --h | -H ) mygrepusage ;;

    # print all apps that have posted any notifications
    -appsenq | --appsenqueue ) appsenq ;;

    # print the bugreport.txt 'notification list:' - that is a notificationRecord info of all notifications in statusbar
    -notilist | --notificationlist ) notilist ;;

    # print the bugreport.txt 'notification channels of all apk:' - AppSettings
    -channels | --notificationchannels ) channels ;;

    # print the active/inactive notifications
    -activenoti | --activenotifications ) activenoti ;;
    
    # default option
    *)
    echo "####### mygrep default option result: ########"
    egrep -i -h "$1" ./* | sort -u | egrep -i "[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9].[0-9][0-9][0-9]|=|{|}|:|(|)|<|>|/|$1"
    esac
}

################################################################################
#Function mygrep to use my formatation "[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9].[0-9][0-9][0-9]”
#this regular expression "[0-9][0-9].." will colorful the time and other $1's of the logs and remove BatteryTrace logs.
mygrepB(){
    egrep -i -h "$1" ./* | sort -u | egrep -v "BatteryTracer" | egrep -v "PowerManagerService" | egrep -i "[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9].[0-9][0-9][0-9]|=|{|}|:|(|)|<|>|/|$1"
}

################################################################################
#Function mygrepl to use my formatation "[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9].[0-9][0-9][0-9]”
#this regular expression "[0-9][0-9].." will colorful the time and other $1's of the logs.
#this function not user a filename or directory, it is to use on line.
mygrepl(){
    egrep -i -h "$1" | egrep -i "[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9].[0-9][0-9][0-9]|=|{|}|:|(|)|<|>|/|$1"
}


#Function mygrepcat is the same that mygrep, so the diff is that prepar to work in one file in cat.
mygrepcat(){
    egrep -i -h -A1 -B5 "$1" | sort -u | egrep -i "[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9].[0-9][0-9][0-9]|=|{|}|:|(|)|<|>|/|$1"
}

################################################################################
#Function mygrep to use my formatation "[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9].[0-9][0-9][0-9]”
#this regular expression "[0-9][0-9].." will colorful the time and other $1's of the logs.
#and add -A and -B parameters
mygrepAB(){
    egrep -i -h -A10 -B10 "$1" ./* | sort -u | egrep -i "[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9].[0-9][0-9][0-9]|=|{|}|:|(|)|<|>|/|$1"
}

################################################################################
#Function myextractb2gs access the local directory and for each zip file create a directory
#with the same name of the file zip without extension ".zip" and move this file
#to new folder created and rename for log.zip too. For last this zip is extracted
#inside this new directory.
myextractb2gs(){
    local f;
    local i=0;
    for f in *;
        do 
            i=$((i+1));
            dir=${f%.*};
            mkdir $dir;
            mv $f $dir;
            cd $dir;
            mv $dir.zip log.zip;
            unzip log.zip;
            rm log.zip;
            cd .. ;
        done
    clear;
    ls -la;
    echo "############################################################"
    echo "#### All #$i# files have been successfully extracted :) ####"
    echo "############################################################"
}


################################################################################
#Function mygrepb2gs access all logs b2g directories and cat matchs with grep
#and save in $res.
#parameters-> $1 is the grep "matchs"
mygrepb2gs(){
    echo > result.txt;
    res=$(pwd)/result.txt;
    for d in */ ;
        do
            cd $d;
            echo "Directory -> $d{" >> $res;
            egrep -i -h -A10 -B10 $1 ./* >> $res;
            echo "}" >> $res;
            cd ..;
        done
    clear;
    filename=${res##*/};
    echo "####################################################";
    echo "The file $filename has been update with success :p";
    read -p "Do you want see the $filename (y/n)? -> " answer;
    if [ "$answer" = "y" ]; then
        cat $res | egrep -i -h -A5 -B5 "$1" | sort -u | egrep -i "[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9].[0-9][0-9][0-9]|=|{|}|:|(|)|<|>|/|-|$1"
    else
        echo "ok, tchau!"
    fi
}


################################################################################
#Test if else ternary
myif2(){
    read -p "(y/n) -> " answer;   
    [[ "$answer" = "y" ]] && echo "yes" || echo "no"   
}


################################################################################
# hl is a hilghlight() function
# Added unbuffered flag to sed so that streaming inputs can still be ch
# Print the matchs with other colors
# use -> egrep -i  "ZenLog" ./* | hl green "allowCallsFrom" | hl red "ZenLog"
function hl() {
	declare -A fg_color_map
	fg_color_map[black]=30
	fg_color_map[red]=31
	fg_color_map[green]=32
	fg_color_map[yellow]=33
	fg_color_map[blue]=34
	fg_color_map[magenta]=35
	fg_color_map[cyan]=36
	 
	fg_c=$(echo -e "\e[1;${fg_color_map[$1]}m")
	c_rs=$'\e[0m'
	sed -u s"/$2/$fg_c\0$c_rs/g"
}


