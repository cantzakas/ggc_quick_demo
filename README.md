# Pivotal Gemfire-Greenplum Connector Demo
Quick demo on Pivotal Gemfire-Greenplum Connector setup, configuration & use

## Overview
The Pivotal GemFire®-Greenplum® Connector facilitates the two way mirroring of the entries of an entire Pivotal GemFire® region into a Pivotal Greenplum Database® (GPDB) table and vice-versa.
![Pivotal Gemfire](https://github.com/cantzakas/ggc_quick_demo/blob/master/img/Pivotal-Gemfire-Logo-FullColor.png)
![Pivotal Greenplum](https://github.com/cantzakas/ggc_quick_demo/blob/master/img/Pivotal-Greenplum-Logo-FullColor.png)

## How it works
- All transfers are initiated from and specified within GemFire.
- Data copied from GemFire to GPDB makes use of the GemFire export functionality. 
- Data copied from GPDB to GemFire makes use of the GemFire import functionality. 
- The specification of mappings of tables within GPDB to regions in GemFire are within a GemFire cache.xml file. 
- Further mappings identify which GemFire fields are to be imported from or exported to GPDB table columns. 
- A subset of the fields and columns may be specified, and then only that subset are imported or exported.

## Software components
- **Pivotal Greenplum** (required): download Pivotal Greenplum from [Pivotal Network website](https://network.pivotal.io/products/pivotal-gpdb) (requires a subscription licence from [Pivotal](http://pivotal.io) or if Licensee is licensing Software as Evaluation Software and/or as Beta Components, then such use is solely for use in a non-production environment for the Evaluation Period).
- **Pivotal Gemfire** (required): download Pivotal Gemfire from [Pivotal Network website](https://network.pivotal.io/products/pivotal-gemfire) (requires a subscription licence from [Pivotal](http://pivotal.io) or if Licensee is licensing Software as Evaluation Software and/or as Beta Components, then such use is solely for use in a non-production environment for the Evaluation Period).
- **Pivotal Gemfire-Greenplum Connector** (required): available for download along with Pivotal Gemfire from [Pivotal Network website](https://network.pivotal.io/products/pivotal-gemfire).
- **Greenplum Database JDBC Driver** (required, see [Note](README.md#Note)): available for download along with Pivotal Greenplum from [Pivotal Network website](https://network.pivotal.io/products/pivotal-gpdb).
- **PostgreSQL Database JDBC driver** (required, see [Note](README.md#Note)): available to download from [postgresql.org website](https://jdbc.postgresql.org/download.html).

#### Note: 
One may use either Greenplum Database JDBC Driver or PostgreSQL Database JDBC driver.
