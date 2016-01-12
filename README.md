# shell-tools

A collection of ready-to-use command line tools. Includes searchjar, setw/cdw, etc. Can be used both on
Linux and Cygwin systems.

## Installation


    cd ~/bin
    git clone git@github.com:NovaOrdis/shell-tools.git

Alternatively, read only access is available for an arbitrary Git account:

    git clone https://<git-account>@github.com/NovaOrdis/shell-tools.git


Then edit ~/.bashrc as follows:

    ...
    
    alias cdw='. cdwi'
    export PATH=~/bin/shell-tools:${PATH}
    
   
