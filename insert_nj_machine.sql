INSERT INTO nj_machine (own_depmt_id,gps_code,in_user,in_date,bank_no,status,vehicle_num,owner_name)
select 2,epid,3,NOW(),bankno,1,epid,epid FROM gis_ep
WHERE epid not in (SELECT gps_code from nj_machine);
