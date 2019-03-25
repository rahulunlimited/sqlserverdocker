pwd=$(cat "/scripts/sqlserver.pwd")

#run the setup script to create the DB and the schema in the DB
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $pwd -d master -i /scripts/restore-db/restore-db-aw.sql
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $pwd -d master -i /scripts/restore-db/restore-db-awdw.sql
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $pwd -d master -i /scripts/restore-db/restore-db-wwi.sql
/opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $pwd -d master -i /scripts/restore-db/restore-db-wwidw.sql
