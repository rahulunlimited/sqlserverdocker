# sqlserverdocker
My repository for SQL Server with Docker


## Build docker image
```
docker build . -t rahulunlimited/sqlserver:2017-awauto
```

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


