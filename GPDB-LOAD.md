# Prepare Pivotal Greenplum® test table and load data
Assuming you have already succesfully installed and configured user connection to a Pivotal Greenplum® database cluster, now it's time to create a test table and load it with sample data.

- [Create a test table](https://github.com/cantzakas/ggc_quick_demo/blob/master/scripts/sql_create_gpdb_table.sql)
```sql
DROP TABLE IF EXISTS basic;
CREATE TABLE basic (	
	id	bigint,
	col1 	text,
	col2	integer,
	col3	float4
) DISTRIBUTED BY (id);
```
- [Load test table with sample data](https://github.com/cantzakas/ggc_quick_demo/blob/master/scripts/sql_load_gpdb_data.sql)
```sql
INSERT INTO basic (id, col1, col2, col3)
SELECT id, 'TEXT_'::text || id::text, id::integer, id::float4
FROM (
	SELECT GENERATE_SERIES(0, 9999) AS id) A;
```

| Previous | Up       | Next     |
| :------- | :------- | :------- |
| [Download & Install Pivotal Greenplum®](https://github.com/cantzakas/ggc_quick_demo/#setup--configuration) | [Pivotal Gemfire-Greenplum Connector Demo](https://github.com/cantzakas/ggc_quick_demo/#pivotal-gemfire-greenplum-connector-demo) | [Test JDBC connectivity](https://github.com/cantzakas/ggc_quick_demo/GPDB-JDBC.md) |
