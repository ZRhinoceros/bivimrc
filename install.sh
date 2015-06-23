#!/bin/bash

PROG_NAME="bivimrc"
COMMAND_NAME=""  # Personal vim command 
INSTALL_PATH="$HOME"  # Install path,default $HOME
VIM_EXE="`which vim`"  # Vim file fullpath
PLUG_ROOT="plugins"

#Help functions
setup_base ()
{
    bivimrc_home=$1

    mkdir -p $bivimrc_home
    cp -R vimrc $bivimrc_home
    cp -R viminfo $bivimrc_home
    cp -R vim $bivimrc_home
    cp -R runtime $bivimrc_home

    return 0
}

do_ins ()
{
    plug_root=$1
    plug_home=$2

    cd $plug_root

    for f in ./*
    do
        if [ -d $f ];then
            plug_name=${f##*/}
            echo $plug_name
            echo -n "Install plugin <$plug_name>(y/n)? : y " 
            read c
            if [ -z $c -o "y"="$c" ];then
                cd $f
                chmod +x ins.sh
                . ins.sh $plug_home
                if [ 0 -ne $? ];then
                    echo "Install vim plugin <$plug_name> failed"
                    return -1
                fi
                cd ..
            fi
        fi
    done

    cd ..

    return 0
}

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

BIVIMRC_HOME="$INSTALL_PATH/$PROG_NAME"
VIM_RT_ROOT="$BIVIMRC_HOME/vim"
PLUG_HOME="$VIM_RT_ROOT/bundle"
PREFIX_PLUGIN="plugins"

#Install basic vim resource
echo -e "Step-3\tInstall VIM basic resource"
setup_base $BIVIMRC_HOME
eval $IF_ERROR_RET

# Install plugins
echo -e "Step-4:\tInstall VIM Plugins"
do_ins $PLUG_ROOT $PLUG_HOME
eval $IF_ERROR_RET

#Construct new vim
SET_ENV="VIM_RUNTIME=$BIVIMRC_HOME"
SET_RT_PATH='set runtimepath=$VIM_RUNTIME,$VIM_RUNTIME/vim,$VIM_RUNTIME/runtime'
VIM_COMMAND="$VIM_EXE -u $BIVIMRC_HOME/vimrc -i $BIVIMRC_HOME/viminfo --cmd"
alias $COMMAND_NAME="$SET_ENV;$VIM_COMMAND \"$SET_RT_PATH\""

#Set envioment alias
echo "Finish:	Copy the following to Bash init file,eg bash_profile"
echo -e ""
echo -e `alias $COMMAND_NAME`
echo -e ""

echo "Install success"
