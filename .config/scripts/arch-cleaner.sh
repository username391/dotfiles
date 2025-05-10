#!/bin/bash

echo '                  -`'
echo '                 .o+`'
echo '                `ooo/'
echo '               `+oooo:'
echo '              `+oooooo:'
echo '              -+oooooo+:'
echo '            `/:-:++oooo+:'
echo '           `/++++/+++++++:'
echo '          `/++++++++++++++:'
echo '        `/+++ooooooooooooo/`'
echo '        ./ooosssso++osssssso+`'
echo '       .oossssso-````/ossssss+`'
echo '      -osssssso.      :ssssssso.'
echo '     :osssssss/        osssso+++.'
echo '    /ossssssss/        +ssssooo/-'
echo '  `/ossssso+/:-        -:/+osssso+-'
echo ' `+sso+:-`   Arch Cleaner  `.-/+oso:'
echo '`++:.                           `-/+/'
echo '.`                                 ` '

echo ''
echo ''
echo '====== Sync Database ====='
echo ''
yay -Syy


echo ''
echo "====== Optimize Pacman's Mirror ====="
echo ''
echo "This command will defrag Pacman's database, this can be harmful on SSD."
echo ''
read -p "Arch is installed on SSD [y/n] ?" choice
case "$choice" in 
  y|Y ) ;;
  n|N ) 
	sudo pacman-optimize && sync;;
  * ) ;;
esac


echo ''
echo '====== Clean Pacman Cache ====='
echo ''
echo ' Careful this eliminates the possibility of using downgrade '
echo ''
yay -Scc


echo ''
echo '====== Removing unused packages ====='
echo ''

echo $(yay -Qtdq)
read -p "Remove these packages [y/n] ?" choice
case "$choice" in 
  n|N ) ;;
  y|Y ) 
	yay -Rns $(yay -Qtdq) ;;
  * ) ;;
esac


echo ''
echo '====== Update mlocate database ====='
echo ''
sudo updatedb


echo ''
echo '====== rmshit ====='
echo ''
if [  -f rmshit.py ]; then
   python rmshit.py 
else
echo "rmshit.py not found!"
echo 'Downloading....'
echo ''
sudo curl -O https://raw.githubusercontent.com/lahwaacz/Scripts/master/rmshit.py
   python ~/.config/scripts/rmshit.py 
fi

