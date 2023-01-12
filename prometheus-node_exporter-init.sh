#! /bin/bash
echo -ne '                    [0%]\r'
sleep 5

#Creating the node_exporter user
sudo useradd --no-create-home --shell /bin/false node_exporter 2> /dev/null

echo -ne '####                [20%]\r'
sleep 5

echo -ne '########            [40%]\r'
sleep 2
echo -ne '##########          [50%]\r'

#Downloading the node_exporter binaries
wget -q https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz

#Unzipping file
tar -xvf node_exporter-1.5.0.linux-amd64.tar.gz > /dev/null

cd node_exporter-1.5.0.linux-amd64/

echo -ne '###########         [55%]\r'
sleep 2

#Copying files to required directories and assigning ownership to user node_exporter
sudo cp node_exporter /usr/local/bin 2> /dev/null
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter

#Cleaning traces of downloaded files
cd ..
sudo rm -rf node_exporter-*-amd64.*

echo -ne '############        [60%]\r'
sleep 5


echo -ne '#############       [65%]\r'
sleep 10

echo -ne '##############      [70%]\r'
sleep 5

#Creating service file with the below configuration
sudo echo "

[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target" | sudo tee -a /etc/systemd/system/node_exporter.service > /dev/null

echo -ne '###############     [75%]\r'
sleep 2

#Reloading the daemon
sudo systemctl daemon-reload

echo -ne '################    [80%]\r'
sleep 2

echo -ne '#################   [85%]\r'
sleep 5

echo -ne '##################  [90%]\r'
sleep 2

#Starting node_exporter service through systemd
sudo systemctl start node_exporter 2> /dev/null

echo -ne '##################  [90%]\r'
sleep 2

#Making sure node_exporter service starts at boot
sudo systemctl enable node_exporter 2> /dev/null

echo -ne '################### [95%]\r'
sleep 10

#Printing the status of the node_exporter service
sudo systemctl status node_exporter --no-pager

echo -ne '################### [95%]\r'
sleep 10

echo -ne '####################[100%] NODE_EXPORTER SETUP SUCCESSFUL\r'
echo -ne '\n'