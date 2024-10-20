#!/bin/bash

########################### TOKEN AND ID #############################
CHAT_ID="0123456789"
BOT_TOKEN="0123456789:k86F13bOyoY7D6cEMzDW13Onb9qQCrw42Ln"

########################### DO NOT CHANGE ############################
########################### ENV_VARIABLES ############################
DESKTOP_PATH="$HOME/Desktop"
BKUP_DIR="$HOME/.bkup"
DATE="$(date -u)"
ARCHIVE="$(date +%Y%m%d)_42Bkup.tar.gz"
FFSEND_HISTORY="$HOME/.bkup/logs.txt"
UPFILE="$BKUP_DIR/$ARCHIVE"
# ---------------- FUPLOAD vairable in bkup function ---------------- #

######################### available storage ##########################
Storage=$(df -h "$HOME" | grep "$HOME" | awk '{print($4)}' | tr 'i' 'B')
if [ "$Storage" == "0BB" ];
then
        Storage="0B"
fi
echo -e "\033[31m----$Storage----\033[0m"
# ----------------- end available storage function ----------------- #

############ create archive of desktop and subdirectories ############
function archive {
        if [ -d "$DESKTOP_PATH" ]; then
                mkdir -p "$BKUP_DIR"
                tar -czf "$BKUP_DIR/$ARCHIVE" "$DESKTOP_PATH"
                echo -e "@"
        else
                echo -e "!"
        fi
}
# -------------------- end of archive function -------------------- #

########################## argument handling #########################

########################## print debug info ##########################
should_log=0
if [[ "$1" == "-pr" || "$1" == "--print" ]]; then
        should_log=1
fi

######################## bkup for data backup ########################
bkup=0
if [[ "$1" == "-b" || "$1" == "--bkup" ]]; then
        bkup=1
fi

if [ $bkup -eq 1 ]; then
        archive
        FUPLOAD=$(ffsend -q upload "$UPFILE")
        MESSAGE="DATE: $DATE \
        NAME: $ARCHIVE \
        LINK: $FUPLOAD"
        
        echo -e "\033[95m################################### $DATE ###################################\033[0m\n" >> $FFSEND_HISTORY
        curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
                -d "chat_id=$CHAT_ID" \
                -d "text=$MESSAGE" >> $FFSEND_HISTORY
        echo -e  "\n" >> $FFSEND_HISTORY
        echo -e  "#"
fi

pass=0
if [[ "$1" == "-p" || "$1" == "--pass" ]]; then
        pass=1
fi

if [ $pass -eq 1 ]; then
        read -p "Password: " -s password
        echo -e  "\n"
        archive
        FUPLOAD=$(ffsend -q upload "$UPFILE" --password "$password")
        MESSAGE="DATE: $DATE \
                NAME: $ARCHIVE \
                LINK: $FUPLOAD"

        echo -e  "\033[95m################################### $DATE ###################################\033[0m\n" >> $FFSEND_HISTORY
        curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
                -d "chat_id=$CHAT_ID" \
                -d "text=$MESSAGE" >> $FFSEND_HISTORY
        echo -e  "\n" >> $FFSEND_HISTORY
        echo -e  "#"
fi
# ---------------- end of argument handling & bkup ----------------- #

########################### WIPE function ############################
function wipe {
        # don't do anything if argument count is zero (unmatched glob).
        if [ -z "$1" ]; then
                return 0
        fi

        if [ $should_log -eq 1 ]; then
                for arg in "$@"; do
                        du -sh "$arg" 2>/dev/null
                done
        fi

        /bin/rm -rf "$@" &>/dev/null

        return 0
}
# ---------------------- end of wipe function ---------------------- #

########################### remove function ###########################
function remove {
        # to avoid printing empty lines
        # or unnecessarily calling /bin/rm
        # we resolve unmatched globs as empty strings.
        shopt -s nullglob

        echo -ne "\033[38;5;208m"

        # 42 Caches
        wipe "$HOME"/Library/*.42*
        wipe "$HOME"/*.42*
        wipe "$HOME"/.zcompdump*
        wipe "$HOME"/.cocoapods.42_cache_bak*

        # Trash
        wipe "$HOME"/.Trash/*

        # General Caches files
        # access rights on Homebrew caches, script deletes them
        /bin/chmod -R 777 "$HOME"/Library/Caches/Homebrew &>/dev/null
        wipe "$HOME"/Library/Caches/*
        wipe "$HOME"/Library/Application\ Support/Caches/*

        # Slack, VSCode, Discord and Chrome Caches
        wipe "$HOME"/Library/Application\ Support/Slack/Service\ Worker/CacheStorage/*
        wipe "$HOME"/Library/Application\ Support/Slack/Cache/*
        wipe "$HOME"/Library/Application\ Support/discord/Cache/*
        wipe "$HOME"/Library/Application\ Support/discord/Code\ Cache/js*
        wipe "$HOME"/Library/Application\ Support/discord/Crashpad/completed/*
        wipe "$HOME"/Library/Application\ Support/Code/Cache/*
        wipe "$HOME"/Library/Application\ Support/Code/CachedData/*
        wipe "$HOME"/Library/Application\ Support/Code/Crashpad/completed/*
        wipe "$HOME"/Library/Application\ Support/Code/User/workspaceStorage/*
        wipe "$HOME"/Library/Application\ Support/Google/Chrome/Profile\ [0-9]/Service\ Worker/CacheStorage/*
        wipe "$HOME"/Library/Application\ Support/Google/Chrome/Default/Service\ Worker/CacheStorage/*
        wipe "$HOME"/Library/Application\ Support/Google/Chrome/Profile\ [0-9]/Application\ Cache/*
        wipe "$HOME"/Library/Application\ Support/Google/Chrome/Default/Application\ Cache/*
        wipe "$HOME"/Library/Application\ Support/Google/Chrome/Crashpad/completed/*

        # .DS_Store files
        wipe "$HOME"/Desktop/**/*/.DS_Store
        wipe "$HOME"/Desktop/.DS_Store
        wipe "$HOME"/Desktop/42/.DS_Store

        # browser downloaded tmp files
        wipe "$HOME"/Library/Application\ Support/Chromium/Default/File\ System
        wipe "$HOME"/Library/Application\ Support/Chromium/Profile\ [0-9]/File\ System
        wipe "$HOME"/Library/Application\ Support/Google/Chrome/Default/File\ System
        wipe "$HOME"/Library/Application\ Support/Google/Chrome/Profile\ [0-9]/File\ System

        echo -ne "\033[0m"
}
remove
# --------------------- end of remove function --------------------- #

if [ $should_log -eq 1 ]; then
        echo -e  "dingus khan"
	$(FUPLOAD)
fi

#################### available storage after wipe ####################
Storage=$(df -h "$HOME" | grep "$HOME" | awk '{print($4)}' | tr 'i' 'B')
if [ "$Storage" == "0BB" ];
then
        Storage="0B"
fi
echo -e "\033[32m----$Storage----\033[0m"

############################ clear history ############################
# echo  " " > ~/$FFSEND_HISTORY # uncomment if you do not want the logs to be saved
echo  "man man" > ~/.zsh_history
