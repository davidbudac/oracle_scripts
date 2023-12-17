# if rlwrap exists, use it for everything
if command -v rlwrap &> /dev/null; then
  alias sqlplus='rlwrap sqlplus'
  alias rman='rlwrap rman'
  alias dgmgrl='rlwrap dgmgrl'
  alias asmcmd='rlwrap asmcmd'
fi

alias sps='sqlplus / as sysdba'
alias lsl='ls -altr'
alias listat='lsnrctl status'

# this function is called after oraenv to set some paths into variables
function set_log_path_variables() {
  # set path to alertlog
  # thanks to Maxim Demenko for this awesome idea (https://github.com/Maxim4711)
  export al=$(echo $(adrci exec="set home  $ORACLE_SID; show base;"|awk -F '"' '{print $2}')"/"$(adrci exec="set home  $ORACLE_SID;show tracefile alert%log")|tr -d " ")
    
  # crs log
  export crsl=$(echo $(adrci exec="set home crs; show base;"|awk -F '"' '{print $2}')"/"$(adrci exec="set home crs;show tracefile alert%log")|tr -d " ")
  
  # and other paths:
  if [ -f $ORACLE_HOME/network/admin/tnsnames.ora ]; then
    export tnsnames=$ORACLE_HOME/network/admin/tnsnames.ora
  fi
  
  if [ -f $ORACLE_HOME/network/admin/sqlnet.ora ]; then
    export sqlnet=$ORACLE_HOME/network/admin/sqlnet.ora
  fi
}

# oraenv, ignore all the commented lines and blank lines
# then set the path to alert log
alias oe='cat /etc/oratab | grep -vE "^(#|$)" ; . oraenv ; set_log_path_variables'

alias alog='tail -f -n 100 $al'
alias crslog='tail -f -n 100 $crsl'

# prompt
# https://scriptim.github.io/bash-prompt-generator/
# for production - highlight SID in red
if [[ $ORACLE_SID =~ ^prod ]]; then
        PS1='\[\e[0m\][\[\e[0m\]\u\[\e[0m\]@\[\e[0m\]\h\[\e[0m\]/\[\e[0;1;4;41m\]$(echo $ORACLE_SID)\[\e[0m\] \w\[\e[0m\]]\[\e[0m\]# \[\e[0m\]'
else
        PS1='\[\e[0m\][\[\e[0m\]\u\[\e[0m\]@\[\e[0m\]\h\[\e[0m\]/\[\e[0;1m\]$(echo $ORACLE_SID) \[\e[0m\]\w\[\e[0m\]]\[\e[0m\]# \[\e[0m\]'
fi



export al=$(
  echo $(
    adrci exec="set home  $ORACLE_SID; show base;"|awk -F '"' '{print $2}')"/"$(adrci exec="set home  $ORACLE_SID;show tracefile alert%log")|tr -d " ")