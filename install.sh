#!/bin/bash

PROG_NAME="bivimrc"
COMMAND_NAME=""  # Personal vim command 
INSTALL_PATH="$HOME"  # Install path,default $HOME
VIM_EXE="`which vim`"  # Vim file fullpath
CP=cp


IF_ERROR_RET='if [ $? -ne 0 ];then exit -1;fi'

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
echo -n "Step-3: Enter your vim path ($VIM_EXE): "
read VIM_EXE

if [ -z "$VIM_EXE" ]; then
	VIM_EXE="`which vim`"
elif [ -f "$VIM_EXE" ]; then
	:
else
	echo "NOT vim full path \"$VIM_EXE\""
	exit -1
fi

eval $IF_ERROR_RET
echo -e "\tUsed system vim  : $VIM_EXE"

#Copy vim resource

BIVIMRC_ROOT="$INSTALL_PATH/$PROG_NAME"
VIM_RT_ROOT="$BIVIMRC_ROOT/vim"
BUNDLE_ROOT="$VIM_RT_ROOT/bundle"
PREFIX_PLUGIN="plugins"
echo -n "Step-3: Enter your vim path ($VIM_EXE): "
echo "Step-4: Copy vim resource"
mkdir -p $BIVIMRC_ROOT

cp -v vimrc $BIVIMRC_ROOT
cp -v viminfo $BIVIMRC_ROOT
cp -vR vim $BIVIMRC_ROOT
cp -vR runtime $BIVIMRC_ROOT

# Install taglist
PLUG_NAME=taglist
PLUG_TARBALL=taglist.tar.gz
PLUG_DEST="$BUNDLE_ROOT/$PLUG_NAME"
PLUG_SRC="$PREFIX_PLUGIN/$PLUG_TARBALL"
mkdir -p $PLUG_DEST
tar xzvf $PLUG_SRC -C $PLUG_DEST
echo -e "\t INSTALL $PLUG_NAME SUCCESS\n"

# Install tagbar 
PLUG_NAME=tagbar
PLUG_SUFFIX=tar.gz
PLUG_TARBALL="$PLUG_NAME.$PLUG_SUFFIX"
PLUG_DEST="$BUNDLE_ROOT/$PLUG_NAME"
PLUG_SRC="$PREFIX_PLUGIN/$PLUG_TARBALL"
mkdir -p $PLUG_DEST
tar xzvf $PLUG_SRC -C $PLUG_DEST
echo -e "\t INSTALL $PLUG_NAME SUCCESS\n"

#Construct new vim
SET_ENV="VIM_RUNTIME=$BIVIMRC_ROOT"
SET_RT_PATH='set runtimepath=$VIM_RUNTIME,$VIM_RUNTIME/vim,$VIM_RUNTIME/runtime'
VIM_COMMAND="$VIM_EXE -u $BIVIMRC_ROOT/vimrc -i $BIVIMRC_ROOT/viminfo --cmd"
alias $COMMAND_NAME="$SET_ENV;$VIM_COMMAND \"$SET_RT_PATH\""

#Set envioment alias
echo "Finish:	Copy the following to Bash init file,eg bash_profile"
echo -e ""
echo -e `alias $COMMAND_NAME`
echo -e ""

echo "Install success"
