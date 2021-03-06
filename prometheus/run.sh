#!/bin/bash
service supervisor restart
a2enmod proxy_wstunnel && \
a2enmod rewrite && \
a2enmod wsgi && \
a2enmod proxy proxy_http && \
sudo a2ensite ws_domain.conf &&\
a2ensite PromCnf && \
sed -i.bak 's/.*Listen 80.*/Listen '9089' \nListen '8001' /' /etc/apache2/ports.conf
service apache2 restart 
#python /opt/Monitoring/tornadoWS/son_mon_ws.py &
python /opt/Monitoring/prometheus/alertMng/alertmanager.py &
/opt/Monitoring/prometheus/prometheus -config.file=/opt/Monitoring/prometheus/prometheus.yml -storage.local.retention 680h0m0s  -storage.remote.influxdb-url http://influx:8086 -storage.remote.influxdb.database "prometheus" -storage.remote.influxdb.retention-policy "default" >/dev/null 2>&1
