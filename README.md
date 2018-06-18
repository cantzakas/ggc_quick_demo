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
- Define your Pivotal Greenplum® Parallel File Server (gpfdist) endpoint. The gpfdist protocol is used in a CREATE EXTERNAL TABLE SQL command to access external data served by the Greenplum Database gpfdist file server utility. When external data is served by gpfdist, all segments in the Pivotal Greenplum® Database system can read or write external table data in parallel. When you start a gpfdist instance you specify a listen port and the path to a directory containing files to read or where files are to be written. For example, this command runs gpfdist in the background, listening on port 8000, and serving files in the `./ggc_demo` directory log output messages and errors to a log file on the same directory:
```shell
$ gpfdist -d ./ggc_demo -p 8000 -l ./ggc_demo/log &
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
- [Edit Pivotal GemFire® `cache.xml`](https://github.com/cantzakas/ggc_quick_demo/blob/master/scripts/gcc_cache.xml). There are five (5) distinct parts one needs to edit within Pivotal Gemfire® `cache.xml` file:
  1. `xsi:schemaLocation`: make sure `http://schema.pivotal.io/gemfire/gpdb/gpdb-2.4.xsd" version="1.0"` is properly referenced,as shown below
  ```xml
  <cache xmlns="http://geode.apache.org/schema/cache"
    xmlns:gpdb="http://schema.pivotal.io/gemfire/gpdb"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://geode.apache.org/schema/cache  http://geode.apache.org/schema/cache/cache-1.0.xsd http://schema.pivotal.io/gemfire/gpdb  http://schema.pivotal.io/gemfire/gpdb/gpdb-2.4.xsd" version="1.0">
  ```
  2. `<pdx-serializer>` should be set as shown below:
  ```xml
  <pdx read-serialized="true" persistent="false">
  	<pdx-serializer>
		<class-name>org.apache.geode.pdx.ReflectionBasedAutoSerializer</class-name>
		<parameter name="classes">
			<string>io.pivotal.gemfire.demo.entity.*</string>
		</parameter>
	</pdx-serializer>
  </pdx>
  ```
  3. `<jndi-bindings>` should be set as shown below. Make sure `jdbc-driver-class`, `user-name`, `password` and `connection-url` parameters are set properly to match your Pivotal Greenplum® connection details.
  ```xml
  <jndi-bindings>
  	<jndi-binding jndi-name="DemoDatasource" type="SimpleDataSource" jdbc-driver-class="org.postgresql.Driver" user-name="gpadmin" password="pivotal" connection-url="jdbc:postgresql://gpdb-sandbox:5432/gpadmin">
  	</jndi-binding>
  </jndi-bindings>
  ```
  4. `<region>` information, should map to your Pivotal Greenplum® test table. For detailed information on how the types correspond between a Pivotal GemFire® region and a Pivotal Greenplum® (GPDB) table are described in a cache.xml file, please check [Datatype Mapping](https://ggc.docs.pivotal.io/latest/mapping.html). In our case, for the test table we defined before, it should be set as shown below:
  ```xml
  <region name="basic1">
    <region-attributes refid="PARTITION">
      <partition-attributes redundant-copies="1"/>
    </region-attributes>
    <gpdb:store datasource="DemoDatasource">
      <gpdb:types>
        <gpdb:pdx name="io.pivotal.gemfire.demo.entity.Parent" schema="public" table="basic">
        <gpdb:id field="id"/>
          <gpdb:fields>
            <gpdb:field name="id" class="java.lang.Long"/>
	    <gpdb:field name="col1" class="java.lang.String"/>
	    <gpdb:field name="col2" class="java.lang.Integer"/>
	    <gpdb:field name="col3" class="java.lang.Float"/>
	  </gpdb:fields>
	</gpdb:pdx>
      </gpdb:types>
    </gpdb:store>
  </region>
  ```
  5. `<gpdb:gpfdist>` information, should point to Pivotal Greenplum® Parallel File Server (gpfdist) you defined before:
  ```shell
  <gpdb:gpfdist port="8000"/>
  ```
  Putting everything together, your `cache.xml` file should like:
  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <cache xmlns="http://geode.apache.org/schema/cache" xmlns:gpdb="http://schema.pivotal.io/gemfire/gpdb" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://geode.apache.org/schema/cache  http://geode.apache.org/schema/cache/cache-1.0.xsd  http://schema.pivotal.io/gemfire/gpdb  http://schema.pivotal.io/gemfire/gpdb/gpdb-2.4.xsd" version="1.0">
  <pdx read-serialized="true" persistent="false">
    <pdx-serializer>
      <class-name>org.apache.geode.pdx.ReflectionBasedAutoSerializer</class-name>
      <parameter name="classes">
        <string>io.pivotal.gemfire.demo.entity.*</string>
      </parameter>
    </pdx-serializer>
   </pdx>
   <jndi-bindings>
     <jndi-binding jndi-name="DemoDatasource" type="SimpleDataSource" jdbc-driver-class="org.postgresql.Driver" user-name="gpadmin" password="pivotal" connection-url="jdbc:postgresql://gpdb-sandbox:5432/gpadmin">
     </jndi-binding>
    </jndi-bindings>
    <region name="basic1">
      <region-attributes refid="PARTITION">
        <partition-attributes redundant-copies="1"/>
      </region-attributes>
      <gpdb:store datasource="DemoDatasource">
        <gpdb:types>
          <gpdb:pdx name="io.pivotal.gemfire.demo.entity.Parent" schema="public" table="basic">
            <gpdb:id field="id"/>
            <gpdb:fields>
              <gpdb:field name="id" class="java.lang.Long"/>
              <gpdb:field name="col1" class="java.lang.String"/>
              <gpdb:field name="col2" class="java.lang.Integer"/>
              <gpdb:field name="col3" class="java.lang.Float"/>
            </gpdb:fields>
          </gpdb:pdx>
        </gpdb:types>
      </gpdb:store>
    </region>
    <gpdb:gpfdist port="8000"/>
  </cache>
  ```
- Start Pivotal GemFire® locator and server; make sure Pivotal GemFire® locator and server components are started with the --include-system-classpath option such that they use the environment variable, and can use the connector:
```shell
start locator --name=loc1 --include-system-classpath
start server --name=srv1 --cache-xml-file=~/github/pivotal-gemfire-9.3.0/config/cache.xml --include-system-classpath
```
-  To verify that the connector is available and properly configured, start `gfsh` and connect to the cluster:
```shell
gfsh>connect
```
  The output from the help import gpdb command, once connected, will identify if the connector is available. Output containing
```shell
IS AVAILABLE
    true
```
  means that the connector is available. Output containing
```shell
IS AVAILABLE
    false
```
  means that the connector is not available. If not available, either the ```gfsh help``` command was issued while not connected to the cluster, the classpath is incorrect, or a server was started without the ```--include-system-classpath``` option.

## Using Pivotal Gemfire®-Greenplum® Connector 
- Importing Data from Pivotal Greenplum® to Pivotal GemFire®
  - Availability: **Online**. You must be connected in gfsh to a JMX Manager member to use this command.
  - Syntax:
  ```shell
  import gpdb --region=regionpath
  ```
  | Name | Description |
  | :--- | :---        |
  | ‑‑region | Required. Region into which data will be imported. Prefix the region name with a slash character. |
  - Example Commands:
  ```shell
  import gpdb --region=/customers
  GemFire entries imported : 10
  Duration                 : 0.18s
  
 - Exporting Data from Pivotal GemFire® to Pivotal Greenplum®. Export a region to GPDB. Export is supported from partitioned GemFire regions only. Data cannot be exported from replicated regions.
   - Availability: **Online**. You must be connected in gfsh to a JMX Manager member to use this command.
   - Syntax:
   ```shell
   export gpdb --region=regionpath --type=value [--remove-all-entries(=value)]
   ```
   | Name | Description | Default Value |
   | :--- | :---        | :---          |
   | ‑‑region | Required. Region from which data is to be exported. Prefix the region name with a slash character. | |
   | ‑‑type | Required. Specification of the functionality implemented for the export operation. A value of UPSERT updates rows already present in the GPDB table, and it inserts rows where not already present. A value of INSERT_ALL does a GPDB insert operation for each entry in the GemFire region. A value of INSERT_MISSING does a GPDB insert operation for each GemFire region entry for which there is no corresponding GPDB row; no updates are done for existing GPDB rows. A value of UPDATE updates rows already present in the GPDB table. | |
   | ‑‑remove-all-entries | Optional boolean value that, when true, removes all GemFire entries present in the specified region when the export operation is initiated, once changes have been successfully committed to the GPDB table. All exported region entries are removed, independent of which rows are updated or inserted into the GPDB table. | false |
   - Example Commands:
   ```shell
   gfsh>export gpdb --region=/customers --type=UPSERT
   GemFire entries exported : 5
   Greenplum rows updated   : 5
   Greenplum rows inserted  : 0
   Duration                 : 0.30s
   ```
   ```shell
   gfsh>export gpdb --region=/customers --type=INSERT_ALL --remove-all-entries=true
   GemFire entries exported : 5
   GemFire entries removed  : 5
   Greenplum rows inserted  : 5
   Duration                 : 0.25s
   ```
 
