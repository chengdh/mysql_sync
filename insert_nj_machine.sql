INSERT INTO nj_machine (own_depmt_id,gps_code,in_user,in_date,bank_no,status)
select 1,epid,3,NOW(),bankno,1 FROM gis_ep
WHERE epid not in (SELECT gps_code from nj_machine);
