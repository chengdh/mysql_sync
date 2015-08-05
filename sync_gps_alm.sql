INSERT INTO  nj_oil_warn
(gis_id,machine_id,gps_code,service_time,reptime,gps_time,longitude,latitude,direction,speed,mileage,flags,in_date,in_user,status)
SELECT alm.id,m.id,epid,NOW(),reptime,gpstime,longitude,latitude,direction,speed,mileage,flags,NOW(),3,0 FROM nj_machine m,gis_alm alm
WHERE m.gps_code = alm.epid
AND alm.type=5
AND alm.id NOT IN (SELECT gis_id FROM nj_oil_warn);

INSERT INTO  nj_repair_warn
(gis_id,machine_id,gps_code,service_time,reptime,gps_time,longitude,latitude,direction,speed,mileage,flags,in_date,in_user,status)
SELECT alm.id,m.id,epid,NOW(),reptime,gpstime,longitude,latitude,direction,speed,mileage,flags,NOW(),3,0 FROM nj_machine m,gis_alm alm
WHERE m.gps_code = alm.epid
AND alm.type=4
AND alm.id NOT IN (SELECT gis_id FROM nj_repair_warn);
