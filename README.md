# Pivotal Gemfire-Greenplum Connector Demo
Quick demo on Pivotal Gemfire-Greenplum Connector setup, configuration & use
![Pivotal Gemfire®](https://github.com/cantzakas/ggc_quick_demo/blob/master/img/Pivotal-Gemfire-Logo-FullColor.png)
![Pivotal Greenplum®](https://github.com/cantzakas/ggc_quick_demo/blob/master/img/Pivotal-Greenplum-Logo-FullColor.png)

## Overview
The Pivotal GemFire®-Greenplum® Connector facilitates the two way mirroring of the entries of an entire Pivotal GemFire® region into a Pivotal Greenplum Database® (GPDB) table and vice-versa.

## How it works
- All transfers are initiated from and specified within Pivotal GemFire®.
- Data copied from Pivotal GemFire® to Pivotal Greenplum® makes use of the Pivotal GemFire® export functionality. 
- Data copied from Pivotal Greenplum® to Pivotal GemFire® makes use of the Pivotal GemFire® import functionality. 
- The specification of mappings of tables within Pivotal Greenplum® to regions in Pivotal GemFire® are within a GemFire cache.xml file. 
- Further mappings identify which Pivotal GemFire® fields are to be imported from or exported to GPDB table columns. 
- A subset of the fields and columns may be specified, and then only that subset are imported or exported.

## Software components
- **Pivotal Greenplum®]** (required): download Pivotal Greenplum® from [Pivotal Network website](https://network.pivotal.io/products/pivotal-gpdb) (requires a subscription licence from [Pivotal](http://pivotal.io) or if Licensee is licensing Software as Evaluation Software and/or as Beta Components, then such use is solely for use in a non-production environment for the Evaluation Period).
- **Pivotal GemFire®** (required): download Pivotal GemFire® from [Pivotal Network website](https://network.pivotal.io/products/pivotal-gemfire) (requires a subscription licence from [Pivotal](http://pivotal.io) or if Licensee is licensing Software as Evaluation Software and/or as Beta Components, then such use is solely for use in a non-production environment for the Evaluation Period).
- **Pivotal Gemfire®-Greenplum® Connector** (required): available for download along with Pivotal Gemfire® from [Pivotal Network website](https://network.pivotal.io/products/pivotal-gemfire).
- **Pivotal Greenplum® Database JDBC Driver** (required, see [Note](https://github.com/cantzakas/ggc_quick_demo/blob/master/README.md#note) below): available for download along with Pivotal Greenplum® from [Pivotal Network website](https://network.pivotal.io/products/pivotal-gpdb).
- **PostgreSQL Database JDBC driver** (required, see [Note](https://github.com/cantzakas/ggc_quick_demo/blob/master/README.md#note) below): available to download from [postgresql.org website](https://jdbc.postgresql.org/download.html).

#### Note: 
One may use either Pivotal Greenplum® Database JDBC Driver or PostgreSQL Database JDBC driver.

## Setup & Configuration
- Download Pivotal Greenplum® from [Pivotal Network website](https://network.pivotal.io/products/pivotal-gpdb) and then follow the instructions on [Pivotal Greenplum® Database Installation Guide](http://gpdb.docs.pivotal.io/580/install_guide/install_guide.html) for installing and configuring Pivotal Greenplum® Database software and host machines.
- Connect to your Pivotal Greenplum® database cluster using either [psql](https://gpdb.docs.pivotal.io/latest/utility_guide/client_utilities/psql.html) command-line interface or your favorite SQL client, i.e. [gpAdmin](https://www.pgadmin.org/) or any similar
```shell
psql -h <host> -p <port_number> -U <user_name> <database_name>
```
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
- Test JDBC connectivity. You would need either the Pivotal Greenplum® Database JDBC Driver which is available for download along with Pivotal Greenplum® from [Pivotal Network website](https://network.pivotal.io/products/pivotal-gpdb) or the PostgreSQL Database JDBC driver, which is available to download from [postgresql.org website](https://jdbc.postgresql.org/download.html). Then follow the procedure outlined in the Pivotal Greenplum Knowledge Base article [How to test JDBC and Greenplum Datadirect JDBC](https://discuss.pivotal.io/hc/en-us/articles/202912073-How-to-test-JDBC-and-Greenplum-Datadirect-JDBC).
- Download and install Pivotal GemFire® from [Pivotal Network website](https://network.pivotal.io/products/pivotal-gemfire) and then follow the instructions on [Installing Pivotal GemFire](http://gemfire.docs.pivotal.io/93/gemfire/getting_started/installation/install_intro.html). Also from the same [repo](https://network.pivotal.io/products/pivotal-gemfire), download the Pivotal Gemfire®-Greenplum® Connector .jar file.
- [Setup Environment parameters](https://github.com/cantzakas/ggc_quick_demo/blob/master/scripts/set_env.sh). There is a number of parameters that need to be setup before you start Pivotal GemFire® and Pivotal Gemfire®-Greenplum® Connector, similar to those shown below:
```shell
# Customize environment variables et al
export CLASSPATH=$CLASSPATH:~/github/pivotal-gemfire-9.3.0/gemfire-greenplum-3.1.1.jar:~/github/postgresql-42.2.2.jar
#export JAVA_HOME=$JAVA_HOME:/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home
export GEMFIRE=~/github/pivotal-gemfire-9.3.0
export GF_JAVA=$JAVA_HOME/bin/java
export PATH=$PATH:$JAVA_HOME/bin:GEMFIRE/bin

# Customize this settings for custom Gemfire/Geode
## check if locator port has been set otherwise set to default
export GEODE_LOCATOR_PORT="${GEODE_LOCATOR_PORT:-10334}"
export GEODE_IP=localhost
export GEODE_SERVERIP=$GEODE_IP

# Customize this settings for custom Greenplum
#export GREENPLUM_HOST=gpdb-sandbox
#export GREENPLUM_USER=gpadmin
#export GREENPLUM_DB=gpadmin
#export GREENPLUM_DB_PWD=changeme
#export PGPASSWORD=${GREENPLUM_DB_PWD}
```
- Cross-check whether `CLASSPATH`, `GEMFIRE`, `GF_JAVA` and `PATH` have been properly set, especially the Pivotal Gemfire®-Greenplum® Connector jar (i.e. `gemfire-greenplum-3.1.1.jar`) and Pivotal Greenplum® Database JDBC Driver (or the PostgreSQL Database JDBC driver) (i.e. `postgresql-42.2.2.jar`) __should be__ properly defined in _**CLASSPATH**_
- [Edit Pivotal GemFire® `cache.xml`](https://github.com/cantzakas/ggc_quick_demo/blob/master/scripts/gcc_cache.xml)
- Start Pivotal GemFire® locator, server and verify if the connector is available

## Using Pivotal Gemfire®-Greenplum® Connector 
- Importing Data from Pivotal Greenplum® to Pivotal GemFire®
- Exporting Data from Pivotal GemFire® to Pivotal Greenplum®
