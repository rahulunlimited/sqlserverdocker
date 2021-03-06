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

#Normal command to run SQL Server in the background
CMD "opt/mssql/bin/sqlservr"
