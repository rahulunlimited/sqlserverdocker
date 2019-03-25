RESTORE DATABASE AdventureWorks2017 FROM DISK = "/var/opt/sqldbbackup/AdventureWorks2017.bak" WITH 
MOVE "AdventureWorks2017" TO "/var/opt/mssql/data/AdventureWorks2017_Data.mdf", 
MOVE "AdventureWorks2017_Log" TO "/var/opt/mssql/data/AdventureWorks2017_Log.ldf";

