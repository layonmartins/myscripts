# myscripts

Put this script in your .bashrc:
```
source ~/myScripts/myScripts.sh
```

## Functions

### mygrep

This function return all occurrences of the match parameter $1 sorted, unique and data/time colerful

Default option:
         - Pass a parameter or regular expression to be grepped in all files in directory
         - The grep is sorted, there are no repeated lines and date/hour is colorful

         - Example usages:
                  ex1: '~$ mygrep notification_enqueue' will return all logs with 'notification_enqueue' matchs
                  ex2: '~$ mygrep notification_enqueue|notification_canceled' will return all logs with 'notification_enqueue' or 'notification_canceled' matchs
                  ex3: '~$ mygrep notification_enqueue.*com.android.systemui' will return all logs with 'notification_enqueue' and 'com.android.systemui' matchs

Options:
    -default option : print all occurrences of the match parameter $1 sorted, unique and data/time colerful
    -appsenq : print all apps that have posted any notifications
    -help : for instructions usage

