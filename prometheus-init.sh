#! /bin/bash
echo -ne '                    [0%] CREATING PROMETHEUS USER\r'
sleep 5

sudo useradd --no-create-home --shell /bin/false prometheus 2> /dev/null

echo -ne '##                  [10%] PROMETHEUS USER CREATED SUCCESSFULLY\r'
sleep 5


echo -ne '###                 [15%] SETTING UP DIRECTORIES\r'
sleep 5
sudo mkdir /etc/prometheus 2> /dev/null  #to store the YAML Config File
sudo chown prometheus:prometheus /etc/prometheus

sudo mkdir /var/lib/prometheus 2> /dev/null #to store the executables
sudo chown prometheus:prometheus /var/lib/prometheus
echo -ne '####                [20%] SETTING UP DIRECTORIES\r'
sleep 5

echo -ne '#####               [25%] DIRECTORIES SET UP SUCCESSFULLY\r'
sleep 5

echo -ne '######              [30%] DOWNLOADING PROMETHEUS\r'
sleep 2
echo -ne '######              [30%] DOWNLOADING PROMETHEUS\r'
wget -q https://github.com/prometheus/prometheus/releases/download/v2.41.0/prometheus-2.41.0.linux-amd64.tar.gz
tar xvf prometheus-2.41.0.linux-amd64.tar.gz > /dev/null

cd prometheus-2.41.0.linux-amd64/

sudo cp prometheus /usr/local/bin 2> /dev/null
sudo chown prometheus:prometheus /usr/local/bin/prometheus
echo -ne '#######             [35%] SETTING UP PERMISSIONS\r'
sleep 2

sudo cp promtool /usr/local/bin 2> /dev/null
sudo chown prometheus:prometheus /usr/local/bin/promtool

sudo cp -r consoles /etc/prometheus 2> /dev/null
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
echo -ne '########            [40%] SETTING UP PERMISSIONS\r'
sleep 2
sudo cp -r console_libraries /etc/prometheus 2> /dev/null
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries

sudo cp prometheus.yml /etc/prometheus/prometheus.yml 2> /dev/null
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml
echo -ne '#########           [45%] SETTING UP PERMISSIONS\r'
sleep 2

cd ..
sudo rm -rf prometheus-2.41.0.linux-*
echo -ne '##########          [50%] REMOVING TRACE FILES\r'
sleep 5


echo -ne '###########         [55%] PROMETHEUS DOWNLOADED SUCCESSFULLY\r'
sleep 10

echo -ne '############        [60%] SETTING UP PROMETHEUS\r'
sleep 5
sudo echo "

[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \\
    --config.file /etc/prometheus/prometheus.yml \\
    --storage.tsdb.path /var/lib/prometheus \\
    --web.console.templates=/etc/prometheus/consoles \\
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/prometheus.service > /dev/null
echo -ne '#############       [65%] CONFIGURING SYSTEMD\r'
sleep 2

sudo systemctl daemon-reload
echo -ne '##############      [70%] CONFIGURING SYSTEMD\r'
sleep 2

echo -ne '###############     [75%] PROMETHEUS SET UP SUCCESSFULLY\r'
sleep 5

echo -ne '################    [80%] STARTING PROMETHEUS\r'
sleep 2
sudo systemctl start prometheus 2> /dev/null

echo -ne '#################   [85%] STARTING PROMETHEUS\r'
sleep 2
sudo systemctl enable prometheus 2> /dev/null

echo -ne '##################  [90%] CHECKING STATUS OF SERVICE\r'
sleep 10
sudo systemctl status prometheus --no-pager

echo -ne '################### [95%] STATUS CHECK COMPLETE\r'
sleep 10

echo -ne '####################[100%] PROMETHEUS STARTED SUCCESSFULLY\r'
echo -ne '\n'