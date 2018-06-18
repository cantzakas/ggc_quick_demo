DROP TABLE IF EXISTS basic;
CREATE TABLE basic (
	id	bigint,
	col1 	text,
	col2	integer,
	col3	float4
) DISTRIBUTED BY (id);
