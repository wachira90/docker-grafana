#!/bin/bash
# node_exporter_ctl.sh
NODE_EXPORTER_BIN="/usr/local/bin/node_exporter"
NODE_EXPORTER_LOG="/var/log/node_exporter.log"
NODE_EXPORTER_PID_FILE="/var/run/node_exporter.pid"
check_status() {
    if [ -f "$NODE_EXPORTER_PID_FILE" ]; then
        PID=$(cat "$NODE_EXPORTER_PID_FILE")
        if ps -p "$PID" > /dev/null; then
            echo "node_exporter is running with PID: $PID"
            return 0
        else
            echo "node_exporter PID file found ($PID), but process not running. Cleaning up PID file."
            rm -f "$NODE_EXPORTER_PID_FILE"
            return 1
        fi
    else
        echo "node_exporter is not running."
        return 1
    fi
}
start_node_exporter() {
    check_status
    if [ $? -eq 0 ]; then
        echo "node_exporter is already running."
        exit 0
    fi
    echo "Starting node_exporter..."
    nohup "$NODE_EXPORTER_BIN" > "$NODE_EXPORTER_LOG" 2>&1 &
    PID=$!
    echo "$PID" > "$NODE_EXPORTER_PID_FILE"
    sleep 2

    check_status
    if [ $? -eq 0 ]; then
        echo "node_exporter started successfully."
    else
        echo "Failed to start node_exporter. Check $NODE_EXPORTER_LOG for details."
        exit 1
    fi
}
stop_node_exporter() {
    check_status
    if [ $? -eq 1 ]; then
        echo "node_exporter is not running."
        exit 0
    fi
    echo "Stopping node_exporter..."
    PID=$(cat "$NODE_EXPORTER_PID_FILE")
    kill "$PID"
    rm -f "$NODE_EXPORTER_PID_FILE"
    sleep 2
    check_status
    if [ $? -eq 1 ]; then
        echo "node_exporter stopped successfully."
    else
        echo "Failed to stop node_exporter."
        exit 1
    fi
}
restart_node_exporter() {
    echo "Restarting node_exporter..."
    stop_node_exporter
    start_node_exporter
}
case "$1" in
    start)
        start_node_exporter
        ;;
    stop)
        stop_node_exporter
        ;;
    restart)
        restart_node_exporter
        ;;
    status)
        check_status
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac
exit 0
