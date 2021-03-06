# Custom Docker Image

The exercises in this Lab helps you create a Custom Container using Microsoft's standard SQL Server image and adding backup for Adventureworks database.

In order to proceed with the exercise create the following 2 subfolders in any folder
- sqldbbackup
- scripts

In the folde sqldbbackup copy a database backup file. In this exercise we have copied the AdventureWorks2017 database. However, you can chose any backup file.
If you need to download the AdventureWorks sample database, you can download from the [AdventureWorks sample databases Github Page](https://github.com/Microsoft/sql-server-samples/releases/tag/adventureworks)

### Create a DockerFile
Create a new file in a text-editor and paste the below syntax
```
# Get SQL Server Base Image - 2017
FROM mcr.microsoft.com/mssql/server:2017-latest-ubuntu

# Make a Directory for SQL Server Backup Files & Scripts
RUN mkdir /var/opt/sqldbbackup
RUN mkdir /var/opt/scripts

# Copy the backup files to container
COPY /sqldbbackup/. /var/opt/sqldbbackup

# Copy Scripts
COPY /scripts/. /scripts

# Mark the script as executable
RUN chmod +x /scripts/restore-sampledb.sh

#Normal command to run SQL Server in the background
CMD "opt/mssql/bin/sqlservr"
```

The above file performs the below steps:
1. Start with the SQL Server 2017 Base Image
2. Create folders in the container to store the backup and scripts
3. Copy the backup files placed in the subfolder /sqldbbackup to container /var/opt/sqldbbackup
4. Copy the script files to the container folder /scripts
5. Mark the script as executable
6. Command to execute SQL Server in the background on start of the container

#### Password file
In the subfolder scripts create a file **sqlserver.pwd** and enter the text **Sqlw1thD0ck3r**
> You can replace the password with any other password text as well. However please remember to start the container with the same password as here. This is required as the database is restored using the same password.

> This is not required with Microsoft's standard SQL Server image as it does not come with any sample database. And the password given at the start is configured as default sa password.

> The above password can also be modified at any later time to a more secure password

#### Database restore SQL script
Create a file **restore-db-aw.sql** in the subfolder scripts.
Copy the below text to restore the AdventureWorks database.
```
RESTORE DATABASE AdventureWorksDW2017 FROM DISK = "/var/opt/sqldbbackup/AdventureWorksDW2017.bak" WITH 
MOVE "AdventureWorksDW2017" TO "/var/opt/mssql/data/AdventureWorksDW2017.mdf", 
MOVE "AdventureWorksDW2017_log" TO "/var/opt/mssql/data/AdventureWorksDW2017_log.ldf";
```
Replace the above text in case you have copied a different SQL Server database backukp

#### Database restore script
Copy the below text for the script to start sqlcmd and execute the database restore script above
```
pwd=$(cat "/scripts/sqlserver.pwd")

#run the setup script to create the DB and the schema in the DB
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $pwd -d master -i /scripts/restore-db-aw.sql
```
The above script reads the password from the **sqlserver.pwd** file and executes the database restore script.

### Verify the files
After the above steps, you should have the below files
```
\Dockerfile
\sqldbbackup\Adventureworks2017.bak
\scripts\restore-db-aw.sql
\scripts\restore-sampledb.sh
```

### Build docker image
Execute the following script to build a docker image
```
docker build . -t rahulunlimited/sqlserver:2017-sampledb
```
You can give any name to the tag. However, if you want to upload the docker image to GitHub then the format should be as follows:
useraccount/repository:tag

### Publish the docker image to DockerHub
```
docker push rahulunlimited/sqlserver:2017-sampledb
```

If you are not already logged on to DockerHub, use the command `docker login` to log on to DockerHub

You can logout using the command `docker logout`

### Test the custom image
Run the following command to test the newly created docker image
```
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Sqlw1thD0ck3r' -p 1502:1433 --name sql2 -d rahulunlimited/sqlserver:2017-sampledb
```

### Restore Adventureworks Database
```
docker exec -it sql1 sh "/scripts/restore-sampledb.sh"
```

### Connect to container and browse the database
Connect to container using the servername localhost,1502 with the user id/password sa/Sqlw1thD0ck3r and browse the Adventureworks2017 database


# Custom Image with database restored on startup
In the following exercise we will create a new image which will automatically restore the database on starting the container


### Create a DockerFile
Create a new file in a text-editor and paste the below syntax
```
# Get SQL Server Base Image - 2017
FROM mcr.microsoft.com/mssql/server:2017-latest-ubuntu

# Make a Directory for SQL Server Backup Files & Scripts
RUN mkdir /var/opt/sqldbbackup
RUN mkdir /var/opt/scripts

# Copy the backup files to container
COPY /sqldbbackup/. /var/opt/sqldbbackup

# Copy Scripts
COPY /scripts/. /scripts

# Mark the script as executable
RUN chmod +x /scripts/db-init.sh
RUN chmod +x /scripts/restore-sampledb.sh

#Execute an entrypoint script and start SQL Server in background (from within the script)
CMD /bin/bash ./scripts/entrypoint.sh
```

The above file performs the below steps:
1. Start with the SQL Server 2017 Base Image
2. Create folders in the container to store the backup and scripts
3. Copy the backup files placed in the subfolder /sqldbbackup to container /var/opt/sqldbbackup
4. Copy the script files to the container folder /scripts
5. Mark the 2 scripts as executable
6. Command to execute the script entrypoint.sh. The script starts SQL Server in the background and restores the AdventureWorks2017 datdabase.

### entrypoint.sh
Create a new file entrypoint.sh in the \scripts folder and copy the below text for the script to start sqlcmd and execute the database restore script above
```
/scripts/db-init.sh & /opt/mssql/bin/sqlservr
```
The above script starts the SQL Server in the background and executes the db-init.sh to restore the database

### db-init.sh
Create a new file db-init.sh in the \scrips folder and copy the below text
```
#wait for the SQL Server to come up
sleep 15

pwd=$(cat "/scripts/sqlserver.pwd")

#run the setup script to create the DB and the schema in the DB
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $pwd -d master -i /scripts/restore-db-aw.sql
```
The above script sleeps for 15 seconds (to wait for SQL Server to start) and then executes the script to restore AdventureWorks2017 database. 

### Verify the files
After the above steps, you should have the below files
```
\Dockerfile
\Dockerfile.2017-awauto
\sqldbbackup\Adventureworks2017.bak
\scripts\restore-db-aw.sql
\scripts\restore-sampledb.sh
\scripts\db-init.sh
\scripts\entrypoint.sh
```

### Build docker image
Execute the following script to build a docker image
```
docker build -f Dockerfile.2017-awauto . -t rahulunlimited/sqlserver:2017-awauto
```
In the example above we specify the name of the Dockerfile instead of the default name. (Default file name is Dockerfile)

### Publish the docker image to DockerHub
```
docker push rahulunlimited/sqlserver:2017-awauto
```

### Test the custom image
Run the following command to test the newly created docker image
```
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Sqlw1thD0ck3r' -p 1503:1433 --name sql3 -d rahulunlimited/sqlserver:2017-awauto
```

### Connect to container and browse the database
Connect to container using the servername localhost,1502 with the user id/password sa/Sqlw1thD0ck3r and browse the Adventureworks2017 database.
> Notice in this case you did not had to restore the AdventureWorks2017 database and it was restored automatically on start of the container.


