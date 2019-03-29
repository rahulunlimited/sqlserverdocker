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
5. Mark the 2 scripts as executable
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

### Verify the scripts
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

You can logout using the command 'docker logout`



