#!/bin/sh

## This script installs the python version of Wrye Bash to the Wine prefix of your choice
# it then gives you a choice of how you wanna run Wrye Bash, CLI or .desktop file
# TODO add repo choosing somewhere

clear
cat << "EOF"
 __          __                ____            _     
 \ \        / /               |  _ \          | |    
  \ \  /\  / / __ _   _  ___  | |_) | __ _ ___| |__  
   \ \/  \/ / '__| | | |/ _ \ |  _ < / _` / __| '_ \ 
    \  /\  /| |  | |_| |  __/ | |_) | (_| \__ \ | | |
     \/  \/_|_|   \__, |\___| |____/_\__,_|___/_| |_|
        |_   _|    __/ || |      | | |               
          | |  _ _|___/_| |_ __ _| | | ___ _ __      
          | | | '_ \/ __| __/ _` | | |/ _ \ '__|     
         _| |_| | | \__ \ || (_| | | |  __/ |        
        |_____|_| |_|___/\__\__,_|_|_|\___|_|        
EOF

echo ""
echo -e "This will install current Wrye Bash dev files to a Wine prefix\n"

echo "Note: Use '$HOME' instead of '~/' if its in your home directory"
read -p "Enter the Wine prefix in question : " wineprefix
export WINEPREFIX="$wineprefix"
export WINEDEBUG=-all
export WINEDLLOVERRIDES=winemenubuilder.exe=d
previous_dir=$(pwd)
flag_download=1
check_prefix()
{
	## Wine can spam stderr
	ERRLOG=/tmp/dllerrlog.log

	WINESYSDIR=$(winepath -u c:\\windows\\system32 2> $ERRLOG )    
	if [[ ${WINESYSDIR} == *"/system32" ]]; then
		echo "Prefix is 32 bit, Wrye Bash no longer supports 32-bit. Exiting..."
		exit 1
	elif [[ ${WINESYSDIR} == *"/syswow64"* ]]; then
		echo "Prefix is 64 bit"
		install_python
		echo ""
	else
		echo "Unknown wine architecture. Exiting..."
		exit 1
	fi
}
install_python()
{
	WINEPYDIR=$(winepath -u c:\\Python27)
	ERRLOG=/tmp/dllerrlog.log
	echo ""
	if [ -d "$WINEPYDIR" ]; then
		echo "Python already installed, skipping"
	else
		echo "Python not installed, installing now"
		cat << "EOF"
______      _   _                   _____          _        _ _ 
| ___ \    | | | |                 |_   _|        | |      | | |
| |_/ /   _| |_| |__   ___  _ __     | | _ __  ___| |_ __ _| | |
|  __/ | | | __| '_ \ / _ \| '_ \    | || '_ \/ __| __/ _` | | |
| |  | |_| | |_| | | | (_) | | | |  _| || | | \__ \ || (_| | | |
\_|   \__, |\__|_| |_|\___/|_| |_|  \___/_| |_|___/\__\__,_|_|_|
       __/ |                                                    
      |___/
EOF
		winetricks python27 > "$ERRLOG"
	fi
	echo ""
	get_wrye
}

wrye="$wineprefix/drive_c/wrye-bash"
get_wrye()
{
	if [ -d "$wrye" ]; then
		read -n 1 '-d ' -sp "Wrye Bash already downloaded, updated? (y/n)" wryemenu
		echo ""
		if [[ "$wryemenu" == y ]]; then
			git config pull.rebase false
			git pull origin
			echo "Wrye Bash updated"
		elif [[ "$wryemenu" == n ]]; then
			echo "Wrye Bash not updated"
		else
			echo "No option picked, defaulting to no update"
		fi
		echo ""
	else
		cd "$wineprefix/drive_c"
		cat << "EOF"
 _    _                  ______           _     
| |  | |                 | ___ \         | |    
| |  | |_ __ _   _  ___  | |_/ / __ _ ___| |__  
| |/\| | '__| | | |/ _ \ | ___ \/ _` / __| '_ \ 
\  /\  / |  | |_| |  __/ | |_/ / (_| \__ \ | | |
_\/__\/|_|   \__, |\___| \____/ \__,_|___/_|_|_|
|  _  \       __/ |      | |               | |  
| | | |_____ |___/___ __ | | ___   __ _  __| |  
| | | / _ \ \ /\ / / '_ \| |/ _ \ / _` |/ _` |  
| |/ / (_) \ V  V /| | | | | (_) | (_| | (_| |  
|___/ \___/ \_/\_/ |_| |_|_|\___/ \__,_|\__,_|
EOF
		git clone "https://github.com/wrye-bash/wrye-bash.git"
		flag_download=2
	fi
	cd "$wrye"
	sed -i '/\x23 Compile/,$d' "requirements.txt"
	install_wrye
}

install_wrye()
{
	cd "$wrye"
	if [[ $flag_download == 2 ]]; then
		wine C:/Python27/python.exe -m pip install -r requirements.txt
	else
		read -n 1 '-d ' -sp "Would you like to install Python requirements? (y/n)" wryereq
		echo ""
		if [[ "$wryereq" == y ]]; then
			wine C:/Python27/python.exe -m pip install -r requirements.txt
		elif [[ "$wryereq" == n ]]; then
			echo "Requirements not installed"
		else
			echo "No option picked, defaulting to no requirements installation"
		fi
		echo ""
		if [ -f "$HOME/.local/share/applications/wrye-bash-install.desktop" ]; then
			echo ".desktop file already exists"
		else
			read -p "Installing a .desktop file for Wrye-Bash, pick a name: " wryename
			cat > "$HOME/.local/share/applications/wrye-bash-installer.desktop" << EOF
[Desktop Entry]
Comment=
Exec=WINEPREFIX="$wineprefix" WINEDEBUG=-all wine C:/Python27/python.exe C:/wrye-bash/Mopy/Wrye\ Bash\ Launcher.pyw
GenericName=Wrye Bash for modding
Icon="$wrye/Oblivion/Mopy/bash.ico"
Name="$wryename"
NoDisplay=false
Path[$e]=
StartupNotify=true
Terminal=0
TerminalOptions=
Type=Application
X-KDE-SubstituteUID=false
X-KDE-Username=
EOF
		fi
	fi

	echo "Wrye Bash has been installed/updated"

}

check_prefix
