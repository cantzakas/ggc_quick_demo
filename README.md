# Pivotal Gemfire-Greenplum Connector Demo
Quick demo on Pivotal Gemfire-Greenplum Connector setup, configuration & use

## Overview
The Pivotal GemFire®-Greenplum® Connector facilitates the two way mirroring of the entries of an entire Pivotal GemFire® region into a Pivotal Greenplum Database® (GPDB) table and vice-versa.
![Pivotal Gemfire®](https://github.com/cantzakas/ggc_quick_demo/blob/master/img/Pivotal-Gemfire-Logo-FullColor.png)
![Pivotal Greenplum®](https://github.com/cantzakas/ggc_quick_demo/blob/master/img/Pivotal-Greenplum-Logo-FullColor.png)

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
- Pivotal Greenplum®
  - Download Pivotal Greenplum® from [Pivotal Network website](https://network.pivotal.io/products/pivotal-gpdb) and then follow the instructions on [Pivotal Greenplum® Database Installation Guide](http://gpdb.docs.pivotal.io/580/install_guide/install_guide.html) for installing and configuring Greenplum Database software and configuring Greenplum Database host machines.
  - [Prepare test table and load sample data](https://github.com/cantzakas/ggc_quick_demo/blob/master/GPDB-LOAD.md)
  - [Test JDBC connectivity]
- Pivotal GemFire® & the Pivotal GemFire®-Greenplum® connector
  - Install Pivotal GemFire®
  - Setup Environment parameters
  - Setup **CLASSPATH**
  - Edit Pivotal GemFire® `cache.xml`
  - Start Pivotal GemFire® locator, server and verify if the connector is available

## Using Pivotal Gemfire®-Greenplum® Connector 
- Importing Data from Pivotal Greenplum® to Pivotal GemFire®
- Exporting Data from Pivotal GemFire® to Pivotal Greenplum®
