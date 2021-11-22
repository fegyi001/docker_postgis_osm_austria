# docker_postgis_osm_austria

## step1
```bash
docker-compose build && docker-compose up -d
```

## step2
```bash
docker exec -it docker_postgis_osm_austria_1 bash
```

## step3
```bash
./import_osm.sh
# password when asked: 'postgres'
# this will take a while...
```

## step4
Connect to database
- port: 5432
- host: localhost
- database: osm_rails_austria
- user: postgres
- password: postgres

## step5
Create table for rails
```sql
# create table
create table rails(
  osm_id int8 primary key, 
  geom geometry('linestring', 3416) 
);

# spatial index
create index gix_rails on rails using gist(geom);

# insert rails from 'planet_osm_line'
insert into rails(osm_id, geom)
	select osm_id, way
	from planet_osm_line 
	where planet_osm_line.railway='rail'
;

```

## step6
Visualize in QGIS