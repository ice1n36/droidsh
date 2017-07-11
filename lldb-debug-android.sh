#!/bin/bash

check_exes_on_path() {
    hash adb 2>/dev/null || { echo >&2 "adb not on PATH.  Aborting."; exit 1; }
    hash lldb 2>/dev/null || { echo >&2 "lldb not on PATH.  Aborting."; exit 1; }
}

create_tmp_dir() {
    adb shell mkdir "$1"
    adb shell chmod 777 "$1"
}

remove_tmp_dir() {
    adb shell rm -rf "$1"
}

LLDBSERVER_TMP_DIR=/data/local/tmp/lldb-server-dir
LLDBSERVER_PATH=/opt/android-sdk/lldb/2.2/android/armeabi/lldb-server
LLDBSERVER_PORT=3636

check_exes_on_path

remove_tmp_dir $LLDBSERVER_TMP_DIR
create_tmp_dir $LLDBSERVER_TMP_DIR

adb push $LLDBSERVER_PATH $LLDBSERVER_TMP_DIR
adb shell $LLDBSERVER_TMP_DIR/lldb-server platform --listen *:$LLDBSERVER_PORT&

lldb -s lldb-android-setup

adb shell killall lldb-server
remove_tmp_dir $LLDBSERVER_TMP_DIR
