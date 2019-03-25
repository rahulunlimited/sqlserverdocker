#wait for the SQL Server to come up
sleep 15

pwd=$(cat "/scripts/sqlserver.pwd")

#run the setup script to create the DB and the schema in the DB
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $pwd -d master -i /scripts/restore-db/restore-db-awdw.sql