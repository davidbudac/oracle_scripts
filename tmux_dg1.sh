tmux new-session -d -s dg1 -n dg1

tmux split-window -h -p 30

tmux select-pane -t 0
tmux send-keys "ssh -p 2201 oracle@localhost" C-m
tmux send-keys "export ORAENV_ASK=NO && export ORACLE_SID=cdb1 && . oraenv" C-m
tmux send-keys "dgmgrl / \"show configuration lag \"" C-m

tmux select-pane -t 1
tmux send-keys "ssh -p 2201 oracle@localhost" C-m
tmux send-keys "export ORAENV_ASK=NO && export ORACLE_SID=cdb1 && . oraenv" C-m
tmux send-keys "alog" C-m

tmux select-pane -t 0


# Attach to the session
tmux attach-session -t dg1
