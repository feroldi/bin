#!/bin/sh

spotify_player_cmd() {
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.$1
}

spotify_play_pause_cmd() {
    spotify_player_cmd PlayPause
}

spotify_prev_cmd() {
    spotify_player_cmd Previous
}

spotify_next_cmd() {
    spotify_player_cmd Next
}

mpc_play_pause_cmd() {
    mpc status | grep -q playing && mpc pause || mpc play
}

mpc_prev_cmd() {
  mpc -q prev
}

mpc_next_cmd() {
  mpc -q next
}

player_cmd() {
    if [[ "$(pgrep -cfx /opt/spotify/spotify)" -eq 1 ]]; then
        spotify_${1}_cmd >/dev/null
        mpc pause
    else
        mpc_${1}_cmd >/dev/null
    fi
}

case "$1" in
    play-pause)
        player_cmd play_pause
        ;;
    prev)
        player_cmd prev
        ;;
    next)
        player_cmd next
        ;;
    *)
        exit 1
        ;;
esac
