INSERT INTO nj_machine (own_depmt_id,gps_code,in_user,in_date)
select 1,epid,3,NOW() FROM gis_ep WHERE epid not in (SELECT gps_code from nj_machine);
