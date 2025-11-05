1) установить права:
sudo install -m 0755 /usr/local/bin/monitor-test-simple.sh /usr/local/bin/monitor-test-simple.sh
sudo touch /var/log/monitoring.log
sudo chmod 0644 /var/log/monitoring.log

2) в crontab добавить:
sudo crontab -e
1 * * * * /usr/local/bin/monitor-test-simple.sh

3) Создать юнит systemd
vi /etc/systemd/system/monitor-test.service

[Unit]
Description=Simple monitor for process 'test'

[Service]
Type=oneshot
ExecStart=/usr/local/bin/monitor-test-simple.sh


 vi /etc/systemd/system/monitor-test.timer

[Unit]
Description=Run monitor-test every minute

[Timer]
OnBootSec=30s
OnUnitActiveSec=60s
Unit=monitor-test.service

[Install]
WantedBy=timers.target


4) включить автозапуск
sudo systemctl daemon-reload
sudo systemctl enable --now monitor-test.timer
