#!/bin/bash

function get_this_scripts_path() {
    SCRIPT=$(readlink -f "$0")
    SCRIPT_PATH=$(dirname "$SCRIPT")
    echo $SCRIPT_PATH
}
SCRIPT_PATH=$(get_this_scripts_path)
VIRTUALENV_NAME=rte_venv
WORKON_HOME=~/.virtualenvs # Where virtual environments will be stored
FRESH=true
pip install virtualenv

function set_up_virtual_envionment() {
    echo "Setting up virtual environment"
    if [ $FRESH ]; then
        pip install virtualenv
        pip install virtualenvwrapper
        if ! grep -Fq "export WORKON_HOME=$WORKON_HOME" ~/.bash_profile ; then
            echo "export WORKON_HOME=$WORKON_HOME" >> ~/.bash_profile;
        fi

        if ! grep -Fq 'source /usr/local/bin/virtualenvwrapper.sh' ~/.bashrc ; then
            echo 'source /usr/local/bin/virtualenvwrapper.sh' >> ~/.bashrc;
        fi

        rm -rf ~/.autoenv
        git clone git://github.com/kennethreitz/autoenv.git ~/.autoenv
        if ! grep -Fq 'source ~/.autoenv/activate.sh' ~/.bashrc ; then
            echo 'source ~/.autoenv/activate.sh' >> ~/.bashrc;
        fi

        source /usr/local/bin/virtualenvwrapper.sh
        rmvirtualenv $VIRTUALENV_NAME
        mkvirtualenv $VIRTUALENV_NAME
    fi
    chown -R $THIS_USER:$THIS_USER $WORKON_HOME
    su $THIS_USER -c "$WORKON_HOME/$VIRTUALENV_NAME/bin/pip install -r '$SCRIPT_PATH/../config/requirements.txt'"
}
set_up_virtual_envionment
