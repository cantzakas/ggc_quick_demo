# Importing our sample data from Pivotal Greenplum® test table to Pivotal GemFire®

First, using either psql or your favorite SQL client, let's run some SQL queries to confirm the number of data points available in our Pivotal Greenplum® test table
```sql
$ psql -c "SELECT COUNT(*) FROM basic;"
 count 
-------
 10000
(1 row)

```

Now, lets import these entries into Pivotal GemFire®, using the `gfsh import` command:
```shell
gfsh>import gpdb --region=/basic1
GemFire entries imported : 10000
Duration                 : 0.41s
```

And let's also test, that the sample data have been succesfully loaded into the Pivotal GemFire® `\basic1` region:
```shell
gfsh>query --query="SELECT COUNT(*) FROM /basic1"
Result : true
Rows   : 1

Result
------
10000
```

We can actually run directly from `gfsh` some more complex queries, such as:
```shell
gfsh>query --query="SELECT COUNT(*) FROM /basic1 WHERE id>100 AND id<=2002"
Result : true
Rows   : 1

Result
------
1902
```

How about we add some more rows into the sample data table and try again:
```sql
INSERT INTO basic (id, col1, col2, col3)
SELECT id, 'TEXT_'::text || id::text, id::integer, id::float4
FROM (
	SELECT GENERATE_SERIES(10000, 19999) AS id ORDER BY random() LIMIT 5000) A;
 ```
 ```sql
$ psql -c "SELECT COUNT(*) FROM basic;"
 count 
-------
 15000
(1 row)
```
```shell
gfsh>query --query="SELECT COUNT(*) FROM /basic1"
Result : true
Rows   : 1

Result
------
15000
```

### Next lab
[Exporting data from Pivotal GemFire® to the Pivotal Greenplum® test table](https://github.com/cantzakas/ggc_quick_demo/blob/master/GGC_EXPORT.md)
