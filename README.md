# Docker Grafana Prometheus Node_exporter

## Clone

```
git clone https://github.com/wachira90/docker-grafana.git
```

## Run

```
cd docker-grafana/
docker-compose up -d
```

## Login

```
admin/admin
```

## Install node_exporter

```sh
wget https://github.com/prometheus/node_exporter/releases/download/v1.9.1/node_exporter-1.9.1.linux-amd64.tar.gz
tar xvfz node_exporter-1.9.1.linux-amd64.tar.gz
cd node_exporter-1.9.1.linux-amd64
cp node_exporter  /usr/local/bin/node_exporter
nohup /usr/local/bin/node_exporter > /var/log/node_exporter.log 2>&1 &
```

## Influxdb

```yml
networks:
  monitoring:

services:
  influxdb:
    image: influxdb:2.3.0
    ports:
      - 8086:8086
    networks:
      - monitoring

  grafana:
    image: grafana/grafana:9.0.4
    ports:
      - 3000:3000
    networks:
      - monitoring
```

https://www.influxdata.com/blog/getting-started-influxdb-grafana/

