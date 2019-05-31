xautolock -detectsleep \
  -time 2 \
  -locker "i3lock -i /home/dan/.config/awesome/lockscreen.png" \
  -nowlocker "i3lock -i /home/dan/.config/awesome/lockscreen.png" \
  -notify 30 \
  -notifier "notify-send -u critical -t 10000 'locking in 30s'" \
  -corners -000 \
  && xautolock -time 3 -locker "systemctl suspend"
