# mil-interceptors
This is a project of database for military department. It includes a resource management system of interceptors and pilots. Study the relation schema to understand the structure and relations of entities.

* main.sql - the script with DDL/DML commands which both creates structure and inserts some test values into created tables
* pg_hba.conf - postgres configuration file with priveleges for users
* data.py - python script for sample data generation

## Relation Schema
![alt text](https://github.com/ilyamogilin/mil-interceptors/raw/master/relation_schema.jpg "Relation schema")

## Functionality
This database implements functionality of interceptors airbase. When user inserts data into Planes table, the database automatically spreads planes into two equal duties based on fuel in interceptor's tank. Also automatic order assignment is implemented: when user insert record into Orders table, the database assigns this order to pilot which is the nearest to target location. Also speed and fuel level of planes are taken into account. Two groups of users are created. First can only select data from tables, another one can only insert data into tables.

## Notes
* this code uses syntax of PostgreSQL 7.4 version (due to some restrictions) but newer version should support this code too
* pg_hba.conf should be in /var/lib/pgsql/data folder before starting postgresql service
