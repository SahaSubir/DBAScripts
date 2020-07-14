--EST_Delete data from destination tables
TRUNCATE TABLE [SWHUB_ATS_Students Dimension]
GO

--DFT_SWHUB_ATS_Students Dimension
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT [STUDENT_ID]
      ,[First_Nam]
      ,[Last_Nam]
      ,[SCHOOL_DBN]
      ,[SCHOOL_NUM]
      ,[SCHOOL_DISTRICT]
      ,[GRADE_LEVEL]
      ,[BIRTH_DTE]
      ,[SEX]
      ,[HOME_LANG]
      ,[ETHNIC_CDE]
      ,[MEAL_CDE]
      ,[GEO_CDE]
      ,[POB_CDE]
      ,[ELA_PROFICIENCY]
	  ,[ESL_FLG] 
	  ,[LEP_FLG] 
	  ,[IEP_SPEC_ED_FLG] 
      ,[YTD_ATTEND_ABS]
      ,[YTD_ATTEND_LATE]
      ,[YTD_ATTEND_PRES]
      ,[YTD_ATTEND_RATE]
      ,[YTD_ATTEND_REL]
      ,[OFFICIAL_CLASS]
      ,[STATUS]
      ,[TEST_MOD]
      ,[ADMISSION_DTE]
      ,[DISC_DTE]
      ,[DISC_CDE]
      ,[DISC_TYPE_CDE]
      ,[RECTYPE]
      ,CASE WHEN MONTH(GETDATE()) <'07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END AS [SchoolYear]
FROM [ATSLINK].[ATS_Demo].[dbo].[BIOGDATA] [ats]
WHERE 
	RECTYPE='STUDENT' AND 
	(STATUS='A' OR (DISC_CDE IN('21','22' ,' 23 ','24',' 25','26','27'))) AND [STUDENT_ID] IS NOT NULL


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_ATS_Students Dimension]
--Table creation code:

USE FGR_INT
IF OBJECT_ID('[SWHUB_ATS_Students Dimension]') IS NOT NULL
	DROP TABLE [SWHUB_ATS_Students Dimension]	
CREATE TABLE [dbo].[SWHUB_ATS_Students Dimension](
	[STUDENT_ID] [int] NOT NULL,
	[First_Nam] [varchar](15) NULL,
	[Last_Nam] [varchar](15) NULL,
	[SCHOOL_DBN] [varchar](6) NULL,
	[SCHOOL_NUM] [varchar](8) NULL,
	[SCHOOL_DISTRICT] [varchar](7) NULL,
	[GRADE_LEVEL] [varchar](2) NULL,
	[BIRTH_DTE] [varchar](50) NULL,
	[SEX] [varchar](1) NULL,
	[HOME_LANG] [varchar](2) NULL,
	[ETHNIC_CDE] [varchar](10) NULL,
	[MEAL_CDE] [varchar](10) NULL,
	[GEO_CDE] [varchar](2) NULL,
	[POB_CDE] [varchar](2) NULL,
	[ELA_PROFICIENCY] [varchar](1) NULL,
	[ESL_FLG] [varchar](1) NULL,
	[LEP_FLG] [varchar](1) NULL,
	[IEP_SPEC_ED_FLG] [char](1) NULL,
	[YTD_ATTEND_ABS] [int] NULL,
	[YTD_ATTEND_LATE] [int] NULL,
	[YTD_ATTEND_PRES] [int] NULL,
	[YTD_ATTEND_RATE] [varchar](2) NULL,
	[YTD_ATTEND_REL] [int] NULL,
	[OFFICIAL_CLASS] [varchar](3) NULL,
	[STATUS] [varchar](1) NULL,
	[TEST_MOD] [varchar](1) NULL,
	[ADMISSION_DTE] [int] NULL,
	[DISC_DTE] [varchar](8) NULL,
	[DISC_CDE] [varchar](2) NULL,
	[DISC_TYPE_CDE] [varchar](10) NULL,
	[RECTYPE] [varchar](7) NULL,
	[SchoolYear] [int] NULL
) ON [PRIMARY]


--Variables for this Package:

Name			Scope																Data type			Value
PackageID		Package 03_Get Students Data from ATS Biogdata into SWHUB			Int32				3


--Event Handlers
On Error
--Execute SQL Task
SQL Statement:
UPDATE SWHUB_SSIS_PackageTransactionLog
SET ErrorDescription=?
	,[EndTime]=GETDATE()
WHERE ID=?

Parameter Mapping: 
Variable Name					Direction		Data Type		Parameter Name		Parameter Size
System:: Error Description		Input			NVARCHAR		0					-1
User: PackageID					Input			LONG			1					-1

OnPreExecute
--Execute SQL Task
UPDATE SWHUB_SSIS_PackageTransactionLog
SET [StartTime]=GETDATE()
,ErrorDescription=NULL
WHERE ID=?

Parameter Mapping: 
Variable Name					Direction		Data Type		Parameter Name		Parameter Size
User: PackageID					Input			LONG			0					-1

OnPostExecute
--Execute SQL Task
UPDATE SWHUB_SSIS_PackageTransactionLog
SET [EndTime]=GETDATE()
WHERE ID=?

Parameter Mapping: 
Variable Name					Direction		Data Type		Parameter Name		Parameter Size
User: PackageID					Input			LONG			0					-1


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
 (3,'Package 03_Get Students Data from ATS Biogdata into SWHUB')