# docker-grafana
docker-grafana

## clone

```
git clone https://github.com/wachira90/docker-grafana.git
```

## run

```
cd docker-grafana/
docker-compose up -d
```

## login

```
admin/admin
```

## influxdb

```yml
version: "3"

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

