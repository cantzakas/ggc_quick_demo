INSERT INTO basic (id, col1, col2, col3)
SELECT id, 'TEXT_'::text || id::text, id::integer, id::float4
FROM (
	SELECT GENERATE_SERIES(0, 9999) AS id) A;
