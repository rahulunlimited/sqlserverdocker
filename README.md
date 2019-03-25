# Docker Labs
The exercises in this Lab works with the custom SQL Server images created. The custom images contain AdventureWorks and WideWorldImporters database already copied in.

The first set of exercises guides you on how to use the container and custom image. 
The second set of exercises guides you on how to build custom image.


### Start Docker Container
```
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Sqlw1thD0ck3r' -p 1501:1433 --name sql1 -d rahulunlimited/sqlserver:2017-awauto
```
The password Sqlw1thD0ck3r is a default password used to restore the database the first time the container is started. The password can be modified later. However, it is required the first time.
> This is not required using the standard Microsoft images.

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


### Alternatively, you can use **sqlcmd** to connect to SQL Server
#### Enter the cotainer
```
docker exec -it sql1 bash
```

#### Start SQL Server
```
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Sqlw1thD0ck3r
```

### Connect to SQL Server using sqlcmd from outside the container
```
/opt/mssql-tools/bin/sqlcmd -S localhost,1501 -U sa -P Sqlw1thD0ck3r
```

> Note : When connecting from outside the container, the Port Number is required to be mentioned

### Enter inside Container
```
docker exec -it sql1 bash
```

#### See file/folder list in the Container using `ls`

#### If the file list is colored and not visible clearly
```
unalias ls
ls
````

#### Exit from container using `exit`


#### Restore the databases
```
./scripts/restore-sampledb.sh
```
> This will take some time as the WideWorldImporters database needs to be upgraded to the latest SQL Server version in the container.

If you have changed the password for the SQL Server, please update the password to be used for database restore
###### Update new password in the container as the default password is no longer valid
echo "Sql2017isfast1" > /scripts/sqlserver.pwd

#### Alternatively, Execute the database restore script from outside the container
```
docker exec -it sql1 sh "/scripts/restore-sampledb.sh"
```

##### If password is chaged, Copy the password file to the container before executing the above script
docker cp "<SRC_PATH>/sqlserver.pwd" sql1:/scripts/

> Please note the password needs to be updated only if you are restoring the database. To connect to SQL Server you do not need to update the password file, you can simply provide the updated password while connecting.

#### If the 


### Build docker image specifying a custom Dockerfile
```
docker build -f Dockerfile.2017-sampledb . -t rahulunlimited/sqlserver:2017-sampledb
```

### Publish Docker image
```
docker push rahulunlimited/sqlserver:2017-awauto
docker push rahulunlimited/sqlserver:2017-sampledb
```

### Start Docker Container
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Sqlw1thD0ck3r' -p 1501:1433 --name sql1 -d rahulunlimited/sqlserver:2017-awauto
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Sqlw1thD0ck3r' -p 1502:1433 --name sql2 -d rahulunlimited/sqlserver:2017-sampledb


#### Build Docker image
```
docker build . -t rahulunlimited/sqlserver:2017-sampledb
```
#### Publish Docker image
```
docker push rahulunlimited/sqlserver:2017-sampledb
```
