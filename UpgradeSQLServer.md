# Upgrade SQL Server
The following exercise guides you to start a container with SQL Server 2017. The container already has AdventureWorks DB installed. The database and SQL Server environment are migrated to initially on SQL Server 2019 Ubuntu and then to SQL Server 2019 RHEL. 
> Please note once the database is migrated it cannot be restored to previous version. You can easily switch the image from 2019 Ubuntu to RHEL and vice versa till the time they are on the same version. 

### Persist Data
Containers by nature are ephemeral meaning once the containers are removed, all data within the containers are also removed. You can persist database outside the containers using Volumes or Mounting external folders in the containers. As we want to upgrade the database(s) from SQL Server 2017 to SQL Server 2019, we need to persist the data outside the container.
> Data within the containers stays in between container stop and start.

> If you are trying the below exercises on Linux you may have to prefix all the command with `sudo` for e.g. 'sudo docker ps --all`

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

## Upgrade to SQL Server 2019
Before you upgrade the container to SQL Server 2019, you need to stop the container as the databases in the volume are already mounted.

### Stop the container
```
docker stop sql2017
```

### Start a container with SQL Server 2019 Ubuntu image with the same volume
```
docker run -v sqlvolume:/var/opt/mssql -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Sqlw1thD0ck3r' -p 1501:1433 --name sql2019ubuntu -d mcr.microsoft.com/mssql/server:2019-CTP2.4-ubuntu
```
If you immediately try to connect to the container, you may get error connecting as the database needs to be upgraded first to SQL Server 2019.
You can check the updates looking at the container logs
####
docker logs sql2019ubuntu
####

### Check SQL Server version for the container sql2017
```
docker exec -it sql2019ubuntu /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P Sqlw1thD0ck3r -Q 'SELECT @@VERSION'
```
The output shows that the server is now upgraded to **SQL Server 2019** and the version is Developer Edition (64-bit) on **Linux (Ubuntu 16.04.6 LTS) <X64>**

## Upgrade to SQL Server 2019 RHEL
If you want you can now update the version to SQL Server 2019 RHEL

### Stop the container
```
docker stop sql2019ubuntu
```

### Start a container with SQL Server 2019 RHEL image with the same volume
```
docker run -v sqlvolume:/var/opt/mssql -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Sqlw1thD0ck3r' -p 1501:1433 --name sql2019rhel -d mcr.microsoft.com/mssql/rhel/server:2019-CTP2.4
```
Similar to pervious step there could be error connecting immediately
####
docker logs sql2019rhel
####

### Check SQL Server version for the container sql2017
```
docker exec -it sql2019rhel /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P Sqlw1thD0ck3r -Q 'SELECT @@VERSION'
```
The output shows that the server is now upgraded to **SQL Server 2019** and the version is Developer Edition (64-bit) on **Linux (Red Hat Enterprise Linux Server 7.6 (Maipo))** <X64>

## Revert to SQL Server 2019 Ubuntu

### Stop the sql2019rhel container
```
docker stop sql2019rhel
```

### Start the sql2019ubuntu container
```
docker start sql2019ubuntu
```

## Cleanup

### Check existing containers
```
docker ps --all
```
### Stop the currently running container
```
docker stop sql2019rhel
```

### Remove the containers
```
docker rm sql2017 sql2019ubuntu sql2019rhel
```

You can also remove the containers giving the initial 1 or 2 characters of Container ID. (Please make sure that the string uniquely identifies the container
```
docker rm bb 4e b4
```

### Check any Volumes
```
docker volume ls
```

### Remove the volume
```
docker volume rm sqlvolume
```

### Check the current images
```
docker images --all
```

### Remove any image (or leave it there for future exercises)
> If you remove the image, then the next time you use the image it will download again
```
docker image rm <<imageid>>
#docker image rm REPOSITORY:TAG
docker image rm mcr.microsoft.com/mssql/server:2019-CTP2.4-ubuntu
```
