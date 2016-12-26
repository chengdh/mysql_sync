update gis_epstat set state=1,`desc`="离线" WHERE TIMESTAMPDIFF(MINUTE, time, NOW()) > 5;
