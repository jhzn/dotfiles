#!/bin/bash
LOGFILE=~/tmp/notification_history.log

dbus-monitor "interface='org.freedesktop.Notifications', member='Notify'" >> "$LOGFILE"

