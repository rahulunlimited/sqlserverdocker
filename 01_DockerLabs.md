# Docker Labs
The exercises in this Lab works with the custom SQL Server images created. The custom images contain AdventureWorks and WideWorldImporters database already copied in.
There are 2 images available on the [Docker Hub](https://hub.docker.com/r/rahulunlimited/sqlserver/tags) page:
- 2017-awauto : Image with AdventureWorks database already available. Also has the backups of AdventureWorks and WideWorldImporters.
- 2017-sampledb : Image with backups of AdventureWorks and WideWorldImporters. The backups needs to be restored after the container is created.


### Start Docker Container
```
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Sqlw1thD0ck3r' -p 1501:1433 --name sql1 -d rahulunlimited/sqlserver:2017-awauto
```
The password Sqlw1thD0ck3r is the default password used to restore the database the first time the container is started. The password can be modified later. However, the default password is required the first time.
> This is not required using the standard Microsoft images.

The code above will check if the images **rahulunlimited/sqlserver:2017-awauto** exists on the computer. If the image does not exist, it will download the image first.

You can manually download the iamage using the following command:
```
docker pull rahulunlimited/sqlserver:2017-awauto
```

Please note here -p is for Port. The code above maps TCP Port 1501 on the host environment to Port 1433 in the container. 
### Use SSMS or Azure Data Studio to connect
| Field | Value |
|----------|------------|
| Server name | localhost,1501 |
| Authentication | SQL Server Authentication |
| Login | sa |
| Password | Sqlw1thD0ck3r |

For Server name, you can use either *.* or *localhost* or *127.0.0.1* if you are connecting from the host computer.
If you are connecting from a different computer, then find the IP Address before connecting.

> Please note in the examples below sql1 is the name of the container. It could be any name that you chose to give to the container.

You can also connect to the container using the IP Address of the container. (This can be done only from the host computer)

#### Ports
Use Port 1501 when using the IP Address from the host
Use Port 1433 when using the IP Address from container

#### Get Container's IP Address from host computer
```
docker inspect sql1 | grep IPAddress
```
#### Get Container's Port from host computer
```
docker inspect sql1 | grep Port
```
#### Get Host's IP Address
##### Linux
```
ifconfig
ip addr
```

##### Windows
```
ipconfig
```

### Alternatively, you can use **sqlcmd** to connect to SQL Server
#### Enter the cotainer
```
docker exec -it sql1 bash
```

#### Optional : Check Docker OS version
```
cat /etc/os-release
```

#### Start SQL Server using sqlcmd
```
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Sqlw1thD0ck3r
```

### Connect to SQL Server using sqlcmd from outside the container
```
/opt/mssql-tools/bin/sqlcmd -S localhost,1501 -U sa -P Sqlw1thD0ck3r
```

> Note : When connecting from outside the container, the Port Number is required to be mentioned



### Start an interactive shell inside the container
```
docker exec -it sql1 bash
```

#### See file/folder list in the Container using `ls`

#### If the file list is colored and not visible clearly
```
unalias ls
ls
````

#### You can exit from container anytime using `exit`


#### Restore the databases
Both images contain a folder /sqldbbackup with backups for AdventureWorks and WideWorldImporters databases:
- AdventureWorks2017.bak
- AdventureWorksDW2017.bak
- WideWorldImportersDW-Full.bak
- WideWorldImporters-Full.bak

You can restore the backups using the following script
```
./scripts/restore-sampledb.sh
```
> This will take some time as the WideWorldImporters database needs to be upgraded to the latest SQL Server version in the container.

If you have changed the password for the SQL Server, please update the password to be used for database restore
##### Update new password in the container as the default password is no longer valid
```
echo "Sql2017isfast1" > /scripts/sqlserver.pwd
```
#### Alternatively, Execute the database restore script from outside the container
```
docker exec -it sql1 sh "/scripts/restore-sampledb.sh"
```

##### If password is chaged, you can copy the updated password file to the container before executing the above script
```
docker cp "<SRC_PATH>/sqlserver.pwd" sql1:/scripts/
```
> Please note the password needs to be updated only if you are restoring the database. To connect to SQL Server you do not need to update the password file, you can simply provide the updated password while connecting.

### Stop the container
```
docker stop sql1
```

### Start the container
```
docker start sql1
```

### Check the list of all containers
```
docker ps --all
docker ps -a
docker ls -a
```

### Checkc the list of all images
```
docker images --all
```

### Remove a container
```
docker rm sql1
docker rm xx
```
The xx above could be the initial 1, 2 or more characters for the container id which uniquely identifies the container
> The container should be stopped before it is removed
> Add data in the container will be lost, once the container is removed. We will look at how to persist data from container so that it is not lost even after the container is removed.

### Check logs from Docker, This is very helpful if there are any errors while starting the container
```
docker logs sql1
```

### Check SQL Server version 
```
docker exec -it sql1 /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P Sqlw1thD0ck3r -Q 'SELECT @@VERSION'
```
