--GTI machine database v.1 - Richard Griffiths
--SQL Server version.
--alter table Machine_Asset_History drop constraint fk_AssetHist_MachineID
--alter table Machine_Telemetry drop constraint fk_Telemetry_MachineID
--alter table InvalidScans drop constraint fk_InvalidScans_MachineID
--alter table InvalidScans drop constraint fk_InvalidScans_ResultID
--drop table machines
--drop table Machine_telemetry
--drop table servicestatus
--drop table Faultcodes
--drop table locations
--drop table Machine_asset_history
--drop table Resultcodes
--drop table invalidscans
--drop table usermessages
--go



 
-- MachineID is the real world key for this table, it would ideally be the serial
Create Table Machines (MachineID INT identity Primary key, 
					ServiceStatus INT)
--In operation, To be repaired, In Transit and so on. 
Create Table ServiceStatus (StatusCode INT,
							Description nvarchar(255))
Create Table FaultCodes(Code int,
						Description nvarchar(255))
-- Discuss how we deal with locations -> client Account - client Addresses!  
Create Table Locations(LocationID int identity Primary key) --STUB
--Where has the client or ourselves moved this machine over time, if End_date > date_now OR some far distant date, then it's the current location.
Create Table Machine_Asset_History(MachineID int constraint fk_AssetHist_MachineID Foreign Key references Machines(MachineID), 
								   LocationID int constraint fk_tableid Foreign Key references Locations(LocationID), 
								   StartDate DateTime, 
								   EndDate DateTime) 
--History of machine's heart beat data. This is the simple version for now, there may be a need to archive data using a stored procedure depending how big the tables get.
Create Table Machine_Telemetry(MachineID int constraint fk_Telemetry_MachineID Foreign Key references Machines(MachineID), 
							   TakenTime DateTime, 
							   Temp decimal, 
							   Humidity int, 
							   Tamper1 int, 
							   Tamper2 int) 
--Likely to need discussion!
Create Table ResultCodes(ResultID INT identity Primary key,
						 Description nvarchar(255))
--Invalid Serials : naming here might be vague; 
Create Table InvalidScans(TransactionID int, 
						  QRScanned int, MachineID int constraint fk_InvalidScans_MachineID Foreign Key references Machines(MachineID), 
						  ScannedTimeDate DateTime, 
						  ResultCode int constraint fk_InvalidScans_ResultID Foreign Key references ResultCodes(ResultID))
--There will be matters of character codes to consider, such as chinese, arabic and so on. Right now, all the messages can be called via a message number & country code query
Create Table UserMessages(MessageNumber nvarchar(255), 
						  English_Message nvarchar(1024),
						  Native_Message nvarchar(1024), 
						  countryISOCode nvarchar(3)) 
 
