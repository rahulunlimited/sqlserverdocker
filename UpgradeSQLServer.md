# Upgrade SQL Server
The following exercise guides you to start a container with SQL Server 2017. The container already has AdventureWorks DB installed. The database and SQL Server environment are migrated to initially on SQL Server 2019 Ubuntu and then to SQL Server 2019 RHEL. 
> Please note once the database is migrated it cannot be restored to previous version. You can easily switch the image from 2019 Ubuntu to RHEL and vice versa till the time they are on the same version. 

### Persist Data
Containers by nature are ephemeral meaning once the containers are removed, all data within the containers are also removed. You can persist database outside the containers using Volumes or Mounting external folders in the containers. As we want to upgrade the database(s) from SQL Server 2017 to SQL Server 2019, we need to persist the data outside the container.
> Data within the containers stays in between container stop and start..

## Start a container with volume to persist the data
```
docker run -v sqlvolume:/var/opt/mssql -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Sqlw1thD0ck3r' -p 1501:1433 --name sql2017 -d rahulunlimited/sqlserver:2017-awauto
```

#### Check existing volume
```
docker volume ls
```

#### Remove a volume
```
docker volume rm <<volumename>>
```

### Check SQL Server version for the container sql2017
```
docker exec -it sql2017 /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P Sqlw1thD0ck3r -Q 'SELECT @@VERSION'
```

You can also connect to container sql2017 using Azure Data Studio or SSMS and query the data, check version etc.

## Upgrade
Before you upgrade the container to SQL Server 2019, you need to stop the container as the databases in the volume are already mounted.

### Stop the container
```
docker stop sql2017
```
