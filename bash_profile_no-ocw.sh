# if rlwrap exists, use it for everything
if command -v rlwrap &> /dev/null; then
  alias sqlplus='rlwrap sqlplus'
  alias rman='rlwrap rman'
  alias dgmgrl='rlwrap dgmgrl'
fi

alias sps='sqlplus / as sysdba'
alias lsl='ls -altr'
alias listat='lsnrctl status'
alias alog='tail -f -n 100 $al'

# silly attempt to extract unique name from the spfile
# and set path to alertlog
function get_oracle_db_unique_name {
    ORACLE_SPFILE_PATH="$ORACLE_HOME/dbs/spfile$ORACLE_SID.ora"

    # Check if the SPFILE exists
    if [ -f "$ORACLE_SPFILE_PATH" ]; then
        # Attempt to extract db_unique_name from spfile
        ORACLE_DB_UNIQUE_NAME=$(strings $ORACLE_SPFILE_PATH | grep "\*\.db_unique_name" | grep -o -P "'.*?'" | sed "s/'//g")
        # Check if db_unique_name was found
        if [ -n "$ORACLE_DB_UNIQUE_NAME" ]; then
            echo "\$ORACLE_DB_UNIQUE_NAME set to: $ORACLE_DB_UNIQUE_NAME"

            # and set path to alertlog:
            export ald="$ORACLE_BASE/diag/rdbms/$ORACLE_DB_UNIQUE_NAME/$ORACLE_SID/trace"
            
        else
            echo "Unable to extract DB_UNIQUE_NAME from SPFILE."
            export ald="$ORACLE_BASE/diag/rdbms/$ORACLE_SID/$ORACLE_SID/trace"
            
        fi
        
        export al="$ald/alert_$ORACLE_SID.log"
        # and other paths:
        export tnsnames=$ORACLE_HOME/network/admin/tnsnames.ora
        export sqlnet=$ORACLE_HOME/network/admin/sqlnet.ora
            
    else
        echo "Error: SPFILE not found at $ORACLE_SPFILE_PATH"
    fi
}

# oraenv, ignore all the commented lines and blank lines
# then set the path to alert log
alias oe='cat /etc/oratab | grep -vE "^(#|$)" ; . oraenv ; get_oracle_db_unique_name'
