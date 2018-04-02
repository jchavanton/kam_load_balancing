#!/bin/bash
SESSION=$USER

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

# start stress
tmux select-pane -t 3
# tmux resize-pane -D 10
tmux send-keys "sleep 20 && stress --cpu 5 --io 4 --vm 2 --vm-bytes 128M --timeout 10s && sleep 20 && stress --cpu 10 --io 8 --vm 4 --vm-bytes 128M --timeout 10s " C-m
# tmux send-keys "cd /git/voip_perf/ && sleep 20 && ./client_new.sh 127.0.0.1:5072 5062 15000" C-m
tmux split-window -v

tmux select-pane -t 4
tmux send-keys "cd /git/voip_perf/ && sleep 1 && ./client_3.sh 127.0.0.1:5073 5063 50000 150" C-m


# Set default window
tmux select-window -t $SESSION:3

# Attach to session
tmux -2 attach-session -t $SESSION
