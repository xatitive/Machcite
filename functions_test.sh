#!/bin/bash

# Variscite Functions_Test - by ThatStella7922
# Shoutout to crystall1nedev, my beloved
ver="2023.315.1"

##################################################################################################
##################################################################################################
####                                                                                          ####
####   This is a testing file. Commands will be added and removed at random from this file.   ####
####                                                                                          ####
##################################################################################################
##################################################################################################

# colors
usecolors="true"
reset="\033[0m";faint="\033[37m";red="\033[38;5;196m";black="\033[38;5;244m";green="\033[38;5;46m";yellow="\033[38;5;226m";magenta="\033[35m";blue="\033[36m";default="\033[39m"
# formatting
bold="\033[1m";resetbold="\033[21m"
# message styling
init="${black}${faint}[${reset}${magenta}*${reset}${black}${faint}]${reset}"
info="${black}${faint}[${reset}${green}Info${reset}${black}${faint}]${reset}"
question="${black}${faint}[${reset}${yellow}?${reset}${black}${faint}]${reset}"
help="${black}${faint}[${reset}${green}?${reset}${black}${faint}]${reset}"
error="${black}${faint}[${reset}${red}${bold}Error${reset}${resetbold}${black}${faint}]${reset}"
warn="${black}${faint}[${reset}${yellow}!${reset}${black}${faint}]${reset}"
azule="${black}${faint}[${reset}${blue}Azule${reset}${black}${faint}]${reset}"
success="${black}${faint}[${reset}${green}√${reset}${black}${faint}]${reset}"
if [[ usecolors == "false" ]]; then
    reset="";faint="";red="";black="";green="";yellow="";magenta="";blue="";default=""
fi

# init message
echo -e "$init Variscite Functions_Test $ver"
echo -e "$init https://github.com/ThatStella7922/Variscite"
echo

### Functions
## Checks for Azule and doesn't prompt for installation. Returns 1 if Azule not found, else returns 0.
# Call with true to make it print an error.
nonInteractiveAzuleCheck () {
    if [[ ! -f "$(which azule)" ]]; then
        if [[ $1 == "true" ]]; then
            echo -e "$error Variscite couldn't locate Azule. If it's already installed, make sure that it's in the PATH."
            echo -e "$error Cannot continue without Azule."
            echo -e "$info Variscite can install Azule for you - Run Variscite with -h to learn more."
            echo -e "$info Alternatively, you can manually install it at https://github.com/Al4ise/Azule/wiki."
            return 1
        else
            return 1
        fi
    else
        return 0
    fi
}

nonInteractiveDillyCheck () {
    if [[ ! -f "$(which insert_dylib)" ]]; then
        if [[ $1 == "true" ]]; then
            echo -e "$error Variscite couldn't locate the dylib inserter. If it's already installed, make sure that it's in the PATH."
            echo -e "$error Cannot continue without inserter."
            echo -e "$info Alternatively, you can manually install it at https://github.com/tyilo/insert_dylib."
            return 1
        else
            return 1
        fi
    else
        return 0
    fi
}

## Checks for the Xcode command line tools and doesn't prompt for installation. Returns 1 if Xcode not found, else returns 0.
# Call with true to make it print an error.
nonInteractiveXcodeCltCheck () {
    if ! xcode-select -p 1>/dev/null; then
        if [[ $1 == "true" ]]; then
            echo -e "$error Variscite couldn't locate the Xcode Command Line Tools."
            echo -e "$info You can install them manually by running xcode-select --install"
            return 1
        else
            return 1
        fi
    else
        # good to go
        return 0
    fi
}

# Checks if we are running on Darwin (macOS/iOS). Returns 0 if we are, else returns 1.
checkAreWeOnDarwin () {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        return 0
    else
        return 1
    fi
}

# Checks if we are running on some type of Linux. Returns 0 if we are, else returns 1.
checkAreWeOnLinux () {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        return 0
    else
        return 1
    fi
}

## Checks if we are running on jailbroken iOS. Returns 0 if we are, else returns 1.
# Checks using the presence of apt, so this might trigger on Procursus-strapped macOS. not my problem tho :trolley:
checkAreWeOnJbIos () {
    checkAreWeOnDarwin
    if test "$?" == "0"; then
        # we are on darwin, actually check if we are on ios now
        if [[ "$(sw_vers -productName)" == "iOS" ]]; then
            return 0
        else
            # we are not on ios so stop here
            return 0
        fi
    else
        # we are not even on darwin so stop here
        return 1
    fi
}

# downloadAzule"
downloadAzule () {
    nonInteractiveCurlCheck true
    if [[ $? == "0" ]]; then
        curl -LJ#o azule.zip https://github.com/Al4ise/Azule/archive/refs/heads/main.zip
        res=$?
        if test "$res" != "0"; then
            echo -e "$error curl failed with: $res"
            exit $res
        fi
    else
        exit 1
    fi
}

installAzule () {
    echo -e "$info Downloading Azule..."
    rm -rf temp 2> /dev/null;mkdir temp;cd temp
    downloadAzule
    echo -e "$info Unpacking Azule..."
    unzip -q azule.zip;rm azule.zip
    echo -e "$info Installing Azule (this may require your password)..."
    if [[ ! -d ~/Applications ]]; then
        mkdir ~/Applications
    fi #check if applications folder exists at ~ so we can put Azule there
    if [[ -d ~/Applications/Azule-main ]]; then
        rm -rf ~/Applications/Azule-main
    fi #check if azule is there and if so delete it
    mv Azule-main/ ~/Applications/
    rm -rf temp
    if [[ ! -d /usr/local/bin ]]; then
        sudo mkdir /usr/local/bin
    fi #check if /usr/local/bin exists and if not, make the folder
    sudo ln -sf ~/Applications/Azule-main/azule /usr/local/bin/azule
    if [[ $? == "0" ]]; then
        echo -e "$info Azule installed succesfully. (symlinked to /usr/local/bin/azule)"
    else
        echo -e "$error Installation failed with code $?"
        exit $?
    fi
}

uninstallAzule () {
    echo -e "$info Uninstalling Azule (this may require your password)..."
    if [[ -d ~/Applications/Azule-main ]]; then
        rm -rf ~/Applications/Azule-main
    fi #check if azule is there and if so delete it
    if [[ $? == "0" ]]; then
        echo -e "$info Deleted ~/Applications/Azule-main"
    else
        echo -e "$error Failed to remove ~/Applications/Azule-main, error code $?"
        exit $?
    fi
    sudo rm -rf /usr/local/bin/azule
    if [[ $? == "0" ]]; then
        echo -e "$info Azule uninstalled succesfully."
    else
        echo -e "$error Uninstallation failed with code $?"
        exit $?
    fi
}

downloadDilly () {
    nonInteractiveCurlCheck
    if [[ $? == "0" ]]; then

        # curl is available
        git clone https://github.com/tyilo/insert_dylib.git DylibTemp
        res=$?
        if test "$res" != "0"; then
            echo -e "$error git failed with: $res"
            echo -e "$info Retrying download again using curl!"
            curl -LJ#o Dylib.zip https://github.com/tyilo/insert_dylib/archive/refs/heads/master.zip
            res=$?
            if test "$res" != "0"; then
                echo -e "$error curl failed with: $res"
                exit $res
            else
                # curl works, unzip so installer can install
                unzip -q Dylib.zip
                mv insert_dylib-master DylibTemp
                return 0
            fi
        fi
    else
        # curl is not available
        git clone https://github.com/tyilo/insert_dylib.git DylibTemp
        res=$?
        if test "$res" != "0"; then
            echo -e "$error git failed with: $res"
            echo -e "$info Cannot retry with curl as it's not installed or in the PATH."
            exit $res
        fi
        return 0
    fi
}

installDilly () {
    echo -e "$info Downloading dylib inserter..."
    rm -rf temp 2> /dev/null;mkdir temp;cd temp
    downloadDilly
    echo -e "$info Installing dylib inserter (this may require your password)..."
    if [[ ! -d ~/Applications ]]; then
        mkdir ~/Applications
    fi #check if applications folder exists at ~ so we can put Azule there
    if [[ -d ~/Applications/nsert_dylib-master ]]; then
        rm -rf ~/Applications/insert_dylib-master
    fi #check if azule is there with the old path and if so delete it
    if [[ -d ~/Applications/insert_dylib ]]; then
        rm -rf ~/Applications/insert_dylib
    fi #check if azule is there and if so delete it
    mv DylibTemp/ ~/Applications/insert_dylib-master
    cd ..
    rm -rf temp
    xcodebuild -workspace ~/Applications/insert_dylib-master/insert_dylib.xcodeproj/project.xcworkspace -scheme insert_dylib build
    if [[ ! -d /usr/local/bin ]]; then
        sudo mkdir /usr/local/bin
    fi #check if /usr/local/bin exists and if not, make the folder
    sudo ln -sf ~/Applications/insert_dylib-master/insert_dylib /usr/local/bin/insert_dylib
    if [[ $? == "0" ]]; then
        echo -e "$info Dylib inserter installed succesfully. (symlinked to /usr/local/bin/insert_dylib)"
    else
        echo -e "$error Installation failed with code $?"
        exit $?
    fi
}

uninstallDilly () {
    echo -e "$info Uninstalling the dylib inserter (this may require your password)..."
    if [[ -d ~/Applications/insert_dylib-master ]]; then
        rm -rf ~/Applications/insert_dylib-master
    fi #check if azule is there with the old path and if so delete it
    if [[ -d ~/Applications/insert_dylib-master ]]; then
        rm -rf ~/Applications/insert_dylib-master
    fi #check if azule is there and if so delete it
    if [[ $? == "0" ]]; then
        echo -e "$info Deleted the Azule folder, will now remove symlink..."
    else
        echo -e "$error Failed to remove the Azule folder with error code $?, see ~/Applications/ to remove it yourself then attempt uninstallation again."
        exit $?
    fi
    sudo rm -rf /usr/local/bin/insert_dylib
    if [[ $? == "0" ]]; then
        echo -e "$info Dylib inserter uninstalled succesfully."
    else
        echo -e "$error Uninstallation failed with code $?"
        exit $?
    fi
}

# Checks that the IPA is valid, returns 0 if OK and 1 if invalid.
# Call: validateIpa PathToIpa DoIPromptForNewIpa[true/false]
validateIpa () {
    if [[ "$1" != *".ipa" ]]; then
        if [[ $2 == "true" ]]; then
            echo -e "$error The specified file doesn't appear to be a valid IPA file"
            read -p "$(echo -e "$question Specify the path of a valid IPA file: ")" ipafile
            validateIpa $ipafile true
            if [[ $? == "0" ]]; then
                return 0
            else
                return 1
            fi
        fi
        return 1
    else
        return 0
    fi
}

# Checks that the dylib is valid, returns 0 if OK and 1 if invalid.
# Call: validateDylib PathToDylib DoIPromptForNewDylib[true/false]
validateDylib () {
    if [[ "$1" != *".dylib" ]]; then
        if [[ $2 == "true" ]]; then
            echo -e "$error The specified file doesn't appear to be a valid dylib"
            read -p "$(echo -e "$question Specify the path of a valid dylib: ")" dylib
            validateDylib $dylib true
            if [[ $? == "0" ]]; then
                return 0
            else
                return 1
            fi
        fi
        return 1
    else
        return 0
    fi
}

# Checks that the folder exists, returns 0 if OK and 1 if it doesn't exist.
# Call: validatePath PathToCheck MakeFolderIfNotExist[true/false]
validatePath () {
    if [[ ! -d $1 ]]; then
        if [[ $2 == "true" ]]; then
            mkdir $1
            if [[ $? == "0" ]]; then
                return 0
            else
                echo -e "$error Folder creation at $1 failed."
                return 1
            fi
        else
            return 1
        fi
    else
        return 0
    fi
}

# Specify arguments when calling. patchIpa PathToIpa PathToDylib OutputPath
patchIpa () {
    azule -U -i $1 -o $3 -f $2 -r -v | sed -u -r "s/(\[\*\])/$(echo -e $azule)/g"
}

showHelp () {
    echo -e "##################################################################################################"
    echo -e "##################################################################################################"
    echo -e "####                                                                                          ####"
    echo -e "####   This is a testing file. Commands will be added and removed at random from this file.   ####"
    echo -e "####   Use argument syntax from Variscite.                                                    ####"
    echo -e "####                                                                                          ####"
    echo -e "##################################################################################################"
    echo -e "##################################################################################################"
}
### End of functions

### Start code
# Check for help argument
if [[ $1 == "-h"* ]] || [[ $1 == "--h"* ]]; then
    showHelp
    exit 0
fi

# Check for install Azule argument.
if [[ $1 == "-iA"* ]] || [[ $1 == "--iA"* ]]; then
    nonInteractiveAzuleCheck
    if [[ ! $? == "0" ]]; then
        installAzule
        exit $?
    else
        echo -e "$info Azule is already installed!"
    exit $?
    fi
fi

# Check for uninstall Azule argument.
if [[ $1 == "-uA"* ]] || [[ $1 == "--uA"* ]]; then
    nonInteractiveAzuleCheck
    if [[ $? == "0" ]]; then
        uninstallAzule
        exit $?
    else
        echo -e "$error Couldn't find Azule, it has likely already been uninstalled!"
        exit $?
    fi
fi

while getopts ':s:i:d:o:' OPTION
do
  case "${OPTION}" in
    s) silent=${OPTARG};;
    i) ipafile=${OPTARG};;
    m) machfile=${OPTARG};;
    d) dylib=${OPTARG};;
    o) outpath=${OPTARG};;
   \?) echo -e "$error Invalid option: -${OPTARG}" >&2; exit 1;;
    :) echo -e "$error option -${OPTARG} requires an argument" >&2; exit 1;;
  esac
done

# Start Test
echo -e "$init Beginning validation functions test"
checkAreWeOnJbIos
echo -e "exited with code $?"