#! /bin/bash
echo -ne '                    [0%]\r'
sleep 2

#Creating the prometheus user
sudo useradd --no-create-home --shell /bin/false prometheus 2> /dev/null

echo -ne '##                  [10%]\r'
sleep 2


echo -ne '###                 [15%]\r'
sleep 2

#Creating directories and assigning ownership to user prometheus
sudo mkdir /etc/prometheus 2> /dev/null  #to store the YAML Config File
sudo chown prometheus:prometheus /etc/prometheus

sudo mkdir /var/lib/prometheus 2> /dev/null #to store the executables
sudo chown prometheus:prometheus /var/lib/prometheus
echo -ne '####                [20%]\r'
sleep 2

echo -ne '#####               [25%]\r'
sleep 2

echo -ne '######              [30%]\r'
sleep 2

#Downloading prometheus binaries
wget -q https://github.com/prometheus/prometheus/releases/download/v2.41.0/prometheus-2.41.0.linux-amd64.tar.gz

#Unzipping file
tar -xvf prometheus-2.41.0.linux-amd64.tar.gz > /dev/null

cd prometheus-2.41.0.linux-amd64/

#Copying files to required directories and assigning ownership to user prometheus
sudo cp prometheus /usr/local/bin 2> /dev/null
sudo chown prometheus:prometheus /usr/local/bin/prometheus
echo -ne '#######             [35%]\r'
sleep 2

sudo cp promtool /usr/local/bin 2> /dev/null
sudo chown prometheus:prometheus /usr/local/bin/promtool

sudo cp -r consoles /etc/prometheus 2> /dev/null
sudo chown -R prometheus:prometheus /etc/prometheus/consoles
echo -ne '########            [40%]\r'
sleep 2
sudo cp -r console_libraries /etc/prometheus 2> /dev/null
sudo chown -R prometheus:prometheus /etc/prometheus/console_libraries

sudo cp prometheus.yml /etc/prometheus/prometheus.yml 2> /dev/null
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml
echo -ne '#########           [45%]\r'
sleep 2

#Cleaning traces of downloaded files
cd ..
sudo rm -rf prometheus-*-amd64.*

echo -ne '##########          [50%]\r'
sleep 2


echo -ne '###########         [55%]\r'
sleep 2

echo -ne '############        [60%]\r'
sleep 5

#Creating service file with the below configuration
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

echo -ne '#############       [65%]\r'
sleep 2

#Reloading the daemon
sudo systemctl daemon-reload
echo -ne '##############      [70%]\r'
sleep 2

echo -ne '###############     [75%]\r'
sleep 2

echo -ne '################    [80%]\r'
sleep 2

#Starting prometheus service through systemd
sudo systemctl start prometheus 2> /dev/null

echo -ne '#################   [85%]\r'
sleep 2

#Making sure prometheus service starts at boot
sudo systemctl enable prometheus 2> /dev/null

echo -ne '##################  [90%]\r'
sleep 5

#Printing the status of the prometheus service
sudo systemctl status prometheus --no-pager

echo -ne '################### [95%]\r'
sleep 2

echo -ne '####################[100%] PROMETHEUS SETUP SUCCESSFUL\r'
echo -ne '\n'