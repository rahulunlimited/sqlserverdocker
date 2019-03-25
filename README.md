# Docker Lab
The exercises in this Lab works with the custom SQL Server images created. The images contain AdventureWorks and WideWorldImporters database already copied in.

The first set of exercises guides you on how to use the container and custom image. 
The second set of exercises guides you on how to build custom image.


#### Build Docker image
```
docker build . -t rahulunlimited/sqlserver:2017-sampledb
```
#### Publish Docker image
```
docker push rahulunlimited/sqlserver:2017-sampledb
```

#### Start Docker Container
```
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Sqlw1thD0ck3r' -p 1501:1433 --name sql1 -d rahulunlimited/sqlserver:2017-sampledb
```

#### Enter inside Container
```
docker exec -it sql1 bash
```

#### See file/folder list in the Container
```
ls
```
##### If the file list is colored and not visible clearly
```
unalias ls
ls
````


#### Restore the databases
```
./scripts/db-init.sh
```

#### Exit from container
```
exit
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


