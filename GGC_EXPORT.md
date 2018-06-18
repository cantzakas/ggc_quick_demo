# Exporting data from Pivotal GemFire® to the Pivotal Greenplum® test table
So far we have loaded our sample data from a Pivotal Greenplum® test table called `basic` to a Pivotal GemFire® region named `\basics1`. First, let's check the row counts in each:
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

Then, let's delete all data from the test table in Pivotal Greenplum®
```sql
$ psql -c "DELETE FROM basic;"
DELETE 15000
```
, confirm the row count
```sql
$ psql -c "SELECT COUNT(*) FROM basic;"
 count 
-------
     0
(1 row)
```

, and finally export all data available on Pivotal GemFire®, back to the Pivotal Greenplum® test table
```shell
gfsh>export gpdb --region=/basic1 --type=INSERT_ALL
GemFire entries exported : 15000
Greenplum rows inserted  : 15000
Duration                 : 0.18s
```

How about, we delete some random rows from the Pivotal Greenplum® test table as shown here
```sql
$ psql -c "DELETE FROM basic
WHERE ID IN (
	SELECT ID 
	FROM basic 
	ORDER BY random() 
	LIMIT 1500)"

DELETE 1500
```
, confirm the row count
```sql
$ psql -c "SELECT COUNT(*) FROM basic;"
 count 
-------
 13500
(1 row)
```
, and finally export __*only*__ the missing data from the Pivotal GemFire® region, back to the Pivotal Greenplum® test table, as following:
```shell
gfsh>export gpdb --region=/basic1 --type=INSERT_MISSING
GemFire entries exported : 15000
Greenplum rows inserted  : 1500
Greenplum rows skipped   : 13500
Duration                 : 0.31s
```

Finally, let's remove delete all data from the test table in Pivotal Greenplum®
```sql
$ psql -c "DELETE FROM basic;"
DELETE 15000
```
, confirm the row count
```sql
$ psql -c "SELECT COUNT(*) FROM basic;"
 count 
-------
     0
(1 row)
```
, and finally, let's __*upsert*__ the missing data from the Pivotal GemFire® region, re-hydrate the Pivotal Greenplum® test table and also __*remove all*__ GemFire entries present in the specified region, as following:
```shell
gfsh>export gpdb --region=/basic1 --type=UPSERT --remove-all-entries=true
GemFire entries exported : 15000
GemFire entries removed  : 15000
Greenplum rows updated   : 0
Greenplum rows inserted  : 15000
Duration                 : 0.45s

gfsh>query --query="SELECT COUNT(*) FROM /basic1"
Result : true
Rows   : 1

Result
------
0

```
```sql
$ psql -c "SELECT COUNT(*) FROM basic;"
 count 
-------
 15000
(1 row)

```
