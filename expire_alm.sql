//超过1天的情况下,将所有未处理的报警数据设置为过期
UPDATE nj_oil_warn SET status = 4 WHERE status = 0 AND DATE_ADD(service_time,INTERVAL 1 DAY) < NOW();
UPDATE nj_repair_warn SET status = 4 WHERE status = 0 AND DATE_ADD(service_time,INTERVAL 1 DAY) < NOW();
