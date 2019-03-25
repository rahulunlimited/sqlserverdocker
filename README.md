# Docker Labs
The exercises in this Lab works with the custom SQL Server images created. The custom images contain AdventureWorks and WideWorldImporters database already copied in.

The first set of exercises guides you on how to use the container and custom image. 
The second set of exercises guides you on how to build custom image.


#### Start Docker Container
```
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Sqlw1thD0ck3r' -p 1501:1433 --name sql1 -d rahulunlimited/sqlserver:2017-awauto
```
Please note here -p is for Port. The code above maps TCP Port 1501 on the host environment to Port 1433 in the container. 
#### Use SSMS or Azure Data Studio to connect
| Field | Value |
|----------|------------|
| Server name: | localhost,1501 |
| Authentication | SQL Server Authentication |
| Login: | sa |
| Password | Sqlw1thD0ck3r |

For Server name, you can use either . or localhost or 127.0.0.1

#### Alternatively, you can use sqlcmd to connect to SQL Server
##### Enter the cotainer
```
docker exec -it sql1 bash
```

##### Start SQL Server
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Sqlw1thD0ck3r

#### Connect to SQL Server using sqlcmd from outside the container
/opt/mssql-tools/bin/sqlcmd -S localhost,1501 -U sa -P Sqlw1thD0ck3r

Note : When connecting from outside the container, the Port Number is required to be mentioned

#### Enter inside Container
```
docker exec -it sql1 bash
```

#### See file/folder list in the Container using `ls`

##### If the file list is colored and not visible clearly
```
unalias ls
ls
````

#### Exit from container using `exit`


#### Restore the databases
```
./scripts/db-init.sh
```


#### Alternatively, Execute the database restore script from outside the container
```
docker exec -it sql1 sh "/scripts/restore-sampledb.sh"
```

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
