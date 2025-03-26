#!/bin/bash

# A doc de instalação está dentro da pasta quando o arquivo é baixado no arquivo INSTALL
#Dependencia de compilação HAproxy
sudo apt-get update
sudo apt-get install build-essential -y
sudo apt install libssl-dev libpcre3-dev zlib1g-dev -y

#Download HAproxy
sudo wget https://www.haproxy.org/download/3.1/src/haproxy-3.1.5.tar.gz -O /tmp/haproxy.tar.gz
sudo tar xvzf /tmp/haproxy.tar.gz -C /tmp

#Compilar e instalar HAproxy
sudo make TARGET=generic USE_PCRE=1 USE_OPENSSL=1 USE_ZLIB=1 USE_CRYPT_H=1 USE_LIBCRYPT=1 USE_SYSTEMD=1 -C /tmp/haproxy-3.1.5/
sudo make install -C /tmp/haproxy-3.1.5/

# USE_PCRE=1   #Suporte a expressões regulares
# USE_OPENSSL=1 #Suporte a SSL
# USE_ZLIB=1 #Suporte a compressão
# USE_CRYPT_H=1 #Suporte a criptografia
# USE_LIBCRYPT=1 #Suporte a criptografia
# USE_SYSTEMD=1 #Suporte a systemd

#Criar diretório de configuração

#Criar arquivo.service

sudo cat <<EOF > /etc/systemd/system/haproxy.service

[Unit]
Description=HAProxy Load Balancer
After=network-online.target
Wants=network-online.target

[Service]
Environment="CONFIG=/etc/haproxy/haproxy.cfg" "PIDFILE=/run/haproxy.pid"
EnvironmentFile=/etc/default/haproxy
ExecStartPre=/usr/local/sbin/haproxy -f $CONFIG -c -q $OPTIONS
ExecStart=/usr/local/sbin/haproxy -Ws -f $CONFIG -p $PIDFILE $OPTIONS
ExecReload=/usr/local/sbin/haproxy -f $CONFIG -c -q $OPTIONS
ExecReload=/bin/kill -USR2 $MAINPID
SuccessExitStatus=143
KillMode=mixed
Type=notify

[Install]
WantedBy=multi-user.target
EOF

#Criar arquivo de configuração /etc/haproxy/haproxy.cfg
sudo mkdir -p /etc/haproxy
sudo cp /tmp/haproxy-3.1.5/haproxy /usr/local/sbin/
sudo mkdir -p /var/lib/haproxy/dev
sudo touch /etc/default/haproxy  #armazena as variáveis de ambiente do serviço HAproxy


sudo cat <<EOF > /etc/haproxy/haproxy.cfg

global
    log /dev/log local0
    chroot /var/lib/haproxy
    user haproxy
    group haproxy
    daemon
    maxconn 256
    stats socket /var/lib/haproxy/stats level admin
defaults
    log global
    option dontlognull
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    timeout check           10s
    maxconn                 3000


frontend front-cp
    default_backend back-cp

backend back-cp
    balance roundrobin
    server cp1 10.0.2.0:80 check

EOF

sudo groupadd haproxy
sudo useradd -g haproxy haproxy

sudo systemctl daemon-reload
sudo systemctl enable haproxy
sudo systemctl start haproxy

#configuração de logs

sudo cat <<- EOF > /etc/rsyslog.d/haproxy.conf
\$AddUnixListenSocket /var/lib/haproxy/dev/log

# Send HAProxy messages to a dedicated logfile
:programname, startswith, "haproxy" {
  /var/log/haproxy.log
  stop
}

EOF

sudo systemctl restart rsyslog
sudo systemctl restart haproxy