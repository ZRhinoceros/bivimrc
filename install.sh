#!/bin/bash

IF_ERROR_RET='if [ $? -ne 0 ];then exit -1;fi'

COMMAND_NAME="";            # Personal vim command 
INSTALL_PATH="$HOME";       # Install path,default $HOME
VIM_EXE_PATH="`which vim`"  # Vim file fullpath

#Set command name
echo -n "Step-1: Enter your new vim name: "
read COMMAND_NAME
if [ -z $COMMAND_NAME ];then
	echo "new vim name"$COMMAND_NAME" invalid"
	exit -1
fi

eval $IF_ERROR_RET
echo -e "\tNew command name : $COMMAND_NAME"

#Set install path
echo -n "Step-2: Enter your install path($INSTALL_PATH): "
read INSTALL_PATH

if [ -z "$INSTALL_PATH" ]; then
	INSTALL_PATH="$HOME"
elif [ -d "$INSTALL_PATH" ]; then
	:
else
	mkdir -p $INSTALL_PATH
fi

eval $IF_ERROR_RET
echo -e "\tInstalled to path: $INSTALL_PATH"

#Set system vim path
echo -n "Step-3: Enter your vim path ($VIM_EXE_PATH): "
read VIM_EXE_PATH

if [ -z "$VIM_EXE_PATH" ]; then
	VIM_EXE_PATH="`which vim`"
elif [ -f "$VIM_EXE_PATH" ]; then
	:
else
	echo "NOT vim full path \"$VIM_EXE_PATH\""
	exit -1
fi

eval $IF_ERROR_RET
echo -e "\tUsed system vim  : $VIM_EXE_PATH"

#Copy vim resource
echo -n "Step-3: Enter your vim path ($VIM_EXE_PATH): "
echo "Step-4: Copy vim resource"
PORTABLE_VIMRC_ROOT="$INSTALL_PATH/portable_vimrc"
mkdir -p $PORTABLE_VIMRC_ROOT

cp -v vimrc $PORTABLE_VIMRC_ROOT
cp -v viminfo $PORTABLE_VIMRC_ROOT
cp -vR vim $PORTABLE_VIMRC_ROOT
cp -vR runtime $PORTABLE_VIMRC_ROOT
#Construct new vim
SET_ENV="VIM_RUNTIME=$PORTABLE_VIMRC_ROOT"
SET_RT_PATH='set runtimepath=$VIM_RUNTIME,$VIM_RUNTIME/vim,$VIM_RUNTIME/runtime'
VIM_COMMAND="$VIM_EXE_PATH -u $PORTABLE_VIMRC_ROOT/vimrc -i $PORTABLE_VIMRC_ROOT/viminfo --cmd"
alias $COMMAND_NAME="$SET_ENV;$VIM_COMMAND \"$SET_RT_PATH\""

#Set envioment alias
echo "Finish:	Copy the following to Bash init file,eg bash_profile"
echo -e ""
echo -e `alias $COMMAND_NAME`
echo -e ""

echo "Install success"
