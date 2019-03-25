RESTORE DATABASE WideWorldImportersDW FROM DISK = "/var/opt/sqldbbackup/WideWorldImportersDW-Full.bak" WITH 
MOVE "WWI_Primary" TO "/var/opt/mssql/data/WideWorldImportersDW.mdf", 
MOVE "WWI_UserData" TO "/var/opt/mssql/data/WideWorldImportersDW_userdata.ndf", 
MOVE "WWI_Log" TO "/var/opt/mssql/data/WideWorldImportersDW.ldf", 
MOVE "WWIDW_InMemory_Data_1" TO "/var/opt/mssql/data/WideWorldImportersDW_InMemory_Data_1";
