#!/bin/bash
SESSION=dispatcher_perf_tests

if [ "$1" == "stop" ]
then
	tmux kill-session -t $SESSION
	exit
fi

tmux kill-session -t $SESSION
tmux -2 new-session -d -s $SESSION

tmux new-window -t $SESSION:1 -n 'Logs'

tmux split-window -h

# start voip-perf server
tmux select-pane -t 0
tmux send-keys "cd /git/voip_perf/ && ./voip_perf -p 5072 --trying --ringing --thread-count=1 -d 500" C-m
tmux split-window -v

# start voip-perf server
tmux select-pane -t 1
tmux send-keys "cd /git/voip_perf/ && ./voip_perf -p 5073 --trying --ringing --thread-count=1 -d 500" C-m

# start HTOP
tmux select-pane -t 2
tmux send-keys "htop" C-m
tmux split-window -v

# start voip-perf client
tmux select-pane -t 3
tmux send-keys "cd /git/voip_perf/ && sleep 10 && ./client_1.sh <kamailio IP>:5060 5069 50000" C-m

# Set default window
tmux select-window -t $SESSION:3

# Attach to session
tmux -2 attach-session -t $SESSION
