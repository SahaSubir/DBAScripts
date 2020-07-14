--For SSIS Package Transaction Log
USE FGR_INT

IF OBJECT_ID('[SWHUB_SSIS_PackageTransactionLog]') IS NOT NULL
DROP TABLE [SSIS_PackageTransactionLog]
CREATE TABLE [SWHUB_SSIS_PackageTransactionLog] (
	 ID INT NULL
	,[PackageName] VARCHAR(100) NULL
	,[StartTime] DATETIME NULL
	,[EndTime] DATETIME NULL
	,ErrorDescription NVARCHAR(MAX) NULL
)

INSERT INTO SWHUB_SSIS_PackageTransactionLog (ID,[PackageName])
VALUES 
 (1,'Package 01_Get STARS Data into Staging'),
 (2,'Package 02_Get HR data from ISS_EXT into SWHUB'),
 (3,'Package 03_Get Students Data from ATS Biogdata into SWHUB'),
 (4,'Package 04_Get School Dimensional Data from Supertable to SWHUB'),
 (5,'Package 05_Manipulate STARS Data from Staging Tables'),
 (6,'Package 06_Upload STARS Scheduling Data into SWHUB'),
 (7,'Package 07_MTI Report'),
 (8,'Package 08_Elementary Middle and High School PE and HE Teachers'),
 (9,'Package 09_Get SWC Summary Data'),
 (10,'Package 10_Get Staff Data'),
 (11,'Package 11_Get Organizational Data'),
 (12,'Package 12_CHAMPS'),
 (13,'Package 13_OSWPAutolabel')

USE FGR_INT
INSERT INTO SWHUB_SSIS_PackageTransactionLog (ID,[PackageName])
VALUES (13,'Package 13_OSWPAutolabel')

USE FGR_INT
INSERT INTO SWHUB_SSIS_PackageTransactionLog (ID,[PackageName])
VALUES (14,'Package 14_OSWPAutolabel_1')

USE FGR_INT
INSERT INTO SWHUB_SSIS_PackageTransactionLog (ID,[PackageName])
VALUES (15,'Package 15_Pathway_Report')

USE FGR_INT
INSERT INTO SWHUB_SSIS_PackageTransactionLog (ID,[PackageName])
VALUES (16,'Package 16_FG_SchoolCompletionReport')

USE FGR_INT
INSERT INTO SWHUB_SSIS_PackageTransactionLog (ID,[PackageName])
VALUES (17,'Package 17_Load HR Personal Info Records from DB2')

USE FGR_INT
INSERT INTO SWHUB_SSIS_PackageTransactionLog (ID,[PackageName])
VALUES (18,'Package 18_Load Emp Certificate and License Records from DB2')

USE FGR_INT
INSERT INTO SWHUB_SSIS_PackageTransactionLog (ID,[PackageName])
VALUES (19,'Package 19_Load Emp Records from Active Directory')



SELECT * FROM [SWHUB_SSIS_PackageTransactionLog]

--Capture Error/On Error
UPDATE SWHUB_SSIS_PackageTransactionLog
SET ErrorDescription=?
,[EndTime]=GETDATE()
WHERE ID=?

--Update Start Time/On Pre Execute
UPDATE SWHUB_SSIS_PackageTransactionLog
SET [StartTime]=GETDATE()
,ErrorDescription=NULL
WHERE ID=?

--Update End Time/On Post Execute
UPDATE SWHUB_SSIS_PackageTransactionLog
SET [EndTime]=GETDATE()
WHERE ID=?

TRUNCATE TABLE SWHUB_SSIS_PackageTransactionLog

/**To apply the above Event handlers code:
First create an user variable e.g. PackageID on Control flow page, by selecting Variablers after right clicking on mouse. Choose Datatype and Value.
Click Event handlers-
For OnError-after putting the above code click on Parameter Mapping and click on ADD button to choose a variable name. From Variable name choose System:: Error Description, Direction=Input, DataType=NVARCHAR, Parameter=0, Parameter Size=-1 and Click Add.

For OnPreExecute-after putting the above code click on Parameter Mapping and click on ADD button to choose a variable name. From Variable name choose  User::PackageID, Direction=Input, DataType=LONG, Parameter=0,Parameter Size=-1 and click Add

For OnPostExecute-after putting the above code click on Parameter Mapping and click on ADD button to choose a variable name. From Variable name choose  User::PackageID, Direction=Input, DataType=LONG, Parameter=0, Parameter Size=-1 and click Add