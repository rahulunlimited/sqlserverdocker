# Upgrade SQL Server
The following exercise guides you to start a container with SQL Server 2017. The container already has AdventureWorks DB installed. The database and SQL Server environment are migrated to initially on SQL Server 2019 Ubuntu and then to SQL Server 2019 RHEL. 
> Please note once the database is migrated it cannot be restored to previous version. You can easily switch the image from 2019 Ubuntu to RHEL and vice versa till the time they are on the same version. 

### Persist Data
Containers by nature are ephemeral meaning once the containers are removed, all data within the containers are also removed. You can persist database outside the containers using Volumes or Mounting external folders in the containers. As we want to upgrade the database(s) from SQL Server 2017 to SQL Server 2019, we need to persist the data outside the container.
