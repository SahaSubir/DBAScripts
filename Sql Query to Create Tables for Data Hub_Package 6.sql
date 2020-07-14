--EST_Delete Temporary Tables
Connection: ES11VDEXTESQL01 FGR_INT FGRepUser
SQL Statement:
DELETE FROM [SWHUB_STARS_FACT_Scheduling_ByStudentAndTeacher] WHERE SchoolYear IN (SELECT MAX(SchoolYear) FROM [STARS_TRNS_Scheduling_ByStudentAndTeacher])
GO

DELETE FROM STARS_TRNS_ListOfTeachers_ByGradesServing
GO

DELETE FROM SWHUB_STARS_ListOfTeachers_ByGradesServing
GO

--DFT-1_SWHUB_STARS_FACT_Scheduling_ByStudentAndTeacher
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view
--Name of the table or the view: [STARS_TRNS_Scheduling_ByStudentAndTeacher]
Table created before

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_STARS_FACT_Scheduling_ByStudentAndTeacher]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[SWHUB_STARS_FACT_Scheduling_ByStudentAndTeacher]') IS NOT NULL
	DROP TABLE [SWHUB_STARS_FACT_Scheduling_ByStudentAndTeacher]
CREATE TABLE [SWHUB_STARS_FACT_Scheduling_ByStudentAndTeacher] (
	[SchoolYear] [SMALLINT] NULL
	,[SchoolDBN] [varchar](6) NULL
	,[TermID] [TINYINT] NULL
	,[TermBeginDate] [datetime] NULL
	,[TermEndDate] [datetime] NULL
	,[SchedulingMethodID] [INT] NULL
	,[CourseCode] [VARCHAR](10) NULL
	,[SectionID] [INT] NULL
	,[CourseSectionID] [INT] NULL
	,[Avg_CycleLength] [int] NULL
	,[Avg_NoOfDays_PerCoursePerCycle] [int] NULL
	,[CourseCredits] [decimal](4,2) NULL
	,[StudentID] [INT] NULL
	,[GradeLevel] [varchar](2) NULL
	,[OfficialClass] [varchar](3) NULL
	,[Course MinPerWeek] [INT] NULL
	,[IsMTI] [CHAR](1) NULL
	,[MTI DaysPerWeek] [INT] NULL
	,[MTI MinPerWeek] [INT] NULL
	,[Teacher_Email] [VARCHAR](100) NULL
	,[EISID] [VARCHAR](30) NULL
	,[DOE_EmployeeID] [CHAR](50) NULL
	,[TeacherTypeID] [INT] NULL
	,[DataPulledDate] DateTime NULL
	)

ALTER TABLE [SWHUB_STARS_FACT_Scheduling_ByStudentAndTeacher]
ALTER COLUMN [EISID] [VARCHAR](30) NULL


ALTER TABLE [SWHUB_STARS_FACT_Scheduling_ByStudentAndTeacher]
ALTER COLUMN [DOE_EmployeeID] [CHAR](50) NULL

--DFT_STARS_TRNS_ListOfTeachers_ByGradesServing
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
DECLARE @SY INT; 
SET @SY = CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END; 
With Cte([SchoolDBN],[Teacher_Email],[EISID],[DOE_EmployeeID],cConcat) as 
(SELECT [SchoolDBN],[Teacher_Email],[EISID],[DOE_EmployeeID],
(SELECT a.Grade_Level+',' FROM 
(SELECT DISTINCT [SchoolDBN],[Teacher_Email],[EISID],[DOE_EmployeeID],RTRIM(LTRIM([GradeLevel])) AS Grade_Level
FROM [dbo].[SWHUB_STARS_FACT_Scheduling_ByStudentAndTeacher] 
WHERE [DOE_EmployeeID] IS NOT NULL AND SUBSTRING([SchoolDBN],1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', 
'15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') AND [SchoolYear]=@SY
) AS a    
WHERE a.[SchoolDBN]=b.[SchoolDBN] AND a.[DOE_EmployeeID]=b.[DOE_EmployeeID]     for XML PATH ('') ) cconcat FROM 
(SELECT DISTINCT [SchoolDBN],[Teacher_Email],[EISID],[DOE_EmployeeID], RTRIM(LTRIM([GradeLevel])) AS Grade_Level
FROM [dbo].[SWHUB_STARS_FACT_Scheduling_ByStudentAndTeacher]
WHERE [DOE_EmployeeID] IS NOT NULL AND SUBSTRING([SchoolDBN],1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', 
'15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') AND [SchoolYear]=@SY
) AS b  
GROUP BY [SchoolDBN],[Teacher_Email],[EISID],[DOE_EmployeeID]) 

SELECT [SchoolDBN],[Teacher_Email],[EISID],[DOE_EmployeeID],cConcat AS GradesServed,--left(cConcat,len(cConcat)-1)AS GradesServed,
CASE WHEN cConcat LIKE '%PK%' THEN 'Y' END AS [Grade_PK],
CASE WHEN cConcat LIKE '%0K%' THEN 'Y' END AS [Grade_0K],
CASE WHEN cConcat LIKE '%01%' THEN 'Y' END AS [Grade_01],
CASE WHEN cConcat LIKE '%02%' THEN 'Y' END AS [Grade_02], 
CASE WHEN cConcat LIKE '%03%' THEN 'Y' END AS [Grade_03],
CASE WHEN cConcat LIKE '%04%' THEN 'Y' END AS [Grade_04],
CASE WHEN cConcat LIKE '%05%' THEN 'Y' END AS [Grade_05],
CASE WHEN cConcat LIKE '%06%' THEN 'Y' END AS [Grade_06],
CASE WHEN cConcat LIKE '%07%' THEN 'Y' END AS [Grade_07], 
CASE WHEN cConcat LIKE '%08%' THEN 'Y' END AS [Grade_08],
CASE WHEN cConcat LIKE '%09%' THEN 'Y' END AS [Grade_09],
CASE WHEN cConcat LIKE '%10%' THEN 'Y' END AS [Grade_10],
CASE WHEN cConcat LIKE '%11%' THEN 'Y' END AS [Grade_11],
CASE WHEN cConcat LIKE '%12%' THEN 'Y' END AS [Grade_12]
FROM cte 
ORDER BY [SchoolDBN],[Teacher_Email],[EISID],[DOE_Em

--Data Conversion:
Input Column		Output Alias				Data Type					Length
GradesServed		GradesServed_Convert		Unicode string [DT_WSTR]	100


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_TRNS_ListOfTeachers_ByGradesServing]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[STARS_TRNS_ListOfTeachers_ByGradesServing]') IS NOT NULL
	DROP TABLE [STARS_TRNS_ListOfTeachers_ByGradesServing]
CREATE TABLE [STARS_TRNS_ListOfTeachers_ByGradesServing] (
	 [SchoolDBN] [varchar](6) NULL
	,[Teacher_Email] [varchar](100) NULL
	,[EISID] [varchar](15) NULL
	,[DOE_EmployeeID] [varchar](15) NULL
	,[GradesServed] [nvarchar](100) NULL
	,[Grade_PK] [char](1) NULL
	,[Grade_0K] [char](1) NULL
	,[Grade_01] [char](1) NULL
	,[Grade_02] [char](1) NULL
	,[Grade_03] [char](1) NULL
	,[Grade_04] [char](1) NULL
	,[Grade_05] [char](1) NULL
	,[Grade_06] [char](1) NULL
	,[Grade_07] [char](1) NULL
	,[Grade_08] [char](1) NULL
	,[Grade_09] [char](1) NULL
	,[Grade_10] [char](1) NULL
	,[Grade_11] [char](1) NULL
	,[Grade_12] [char](1) NULL
	)


--DFT_SWHUB_STARS_ListOfTeachers_ByGradesServing
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:

SELECT *, CASE WHEN 
	[Grade_PK] IS NOT NULL
OR	[Grade_0K] IS NOT NULL
OR	[Grade_01] IS NOT NULL 
OR  [Grade_02] IS NOT NULL
OR  [Grade_03] IS NOT NULL
OR  [Grade_04] IS NOT NULL
OR  [Grade_05] IS NOT NULL
AND [Grade_06] IS NULL
AND [Grade_07] IS NULL
AND [Grade_08] IS NULL
AND [Grade_09] IS NULL
AND [Grade_10] IS NULL
AND [Grade_11] IS NULL
AND [Grade_12] IS NULL THEN 'Y' ELSE '' END AS 'Teachers_PK_5',

CASE WHEN 
	[Grade_PK] IS NOT NULL
OR	[Grade_0K] IS NOT NULL
OR	[Grade_01] IS NOT NULL 
OR  [Grade_02] IS NOT NULL
OR  [Grade_03] IS NOT NULL
OR  [Grade_04] IS NOT NULL
OR  [Grade_05] IS NOT NULL
OR  [Grade_06] IS NOT NULL
AND [Grade_07] IS NULL
AND [Grade_08] IS NULL
AND [Grade_09] IS NULL
AND [Grade_10] IS NULL
AND [Grade_11] IS NULL
AND [Grade_12] IS NULL THEN 'Y' ELSE '' END AS 'Teachers_PK_6',

CASE WHEN 
	[Grade_06] IS NOT NULL
OR	[Grade_07] IS NOT NULL
OR  [Grade_08] IS NOT NULL
OR  [Grade_09] IS NOT NULL
OR  [Grade_10] IS NOT NULL
OR  [Grade_11] IS NOT NULL
OR  [Grade_12] IS NOT NULL
AND	[Grade_PK] IS NULL
AND	[Grade_0K] IS NULL
AND	[Grade_01] IS NULL 
AND [Grade_02] IS NULL
AND [Grade_03] IS NULL
AND [Grade_04] IS NULL
AND [Grade_05] IS NULL
THEN 'Y' ELSE '' END AS 'Teachers_6_12',

CASE WHEN 
	[Grade_07] IS NOT NULL
OR  [Grade_08] IS NOT NULL
OR  [Grade_09] IS NOT NULL
OR  [Grade_10] IS NOT NULL
OR  [Grade_11] IS NOT NULL
OR  [Grade_12] IS NOT NULL
AND	[Grade_PK] IS NULL
AND	[Grade_0K] IS NULL
AND	[Grade_01] IS NULL 
AND [Grade_02] IS NULL
AND [Grade_03] IS NULL
AND [Grade_04] IS NULL
AND [Grade_05] IS NULL
AND [Grade_06] IS NULL
THEN 'Y' ELSE '' END AS 'Teachers_7_12'

FROM [dbo].[STARS_TRNS_ListOfTeachers_ByGradesServing]


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_STARS_ListOfTeachers_ByGradesServing]
--Table creation code:

IF OBJECT_ID('[SWHUB_STARS_ListOfTeachers_ByGradesServing]') IS NOT NULL
	DROP TABLE [SWHUB_STARS_ListOfTeachers_ByGradesServing]
CREATE TABLE [SWHUB_STARS_ListOfTeachers_ByGradesServing] (
	 [SchoolDBN] [varchar](6) NULL
	,[Teacher_Email] [varchar](100) NULL
	,[EISID] [varchar](15) NULL
	,[DOE_EmployeeID] [varchar](15) NULL
	,[GradesServed] [nvarchar](100) NULL
	,[Grade_PK] [char](1) NULL
	,[Grade_0K] [char](1) NULL
	,[Grade_01] [char](1) NULL
	,[Grade_02] [char](1) NULL
	,[Grade_03] [char](1) NULL
	,[Grade_04] [char](1) NULL
	,[Grade_05] [char](1) NULL
	,[Grade_06] [char](1) NULL
	,[Grade_07] [char](1) NULL
	,[Grade_08] [char](1) NULL
	,[Grade_09] [char](1) NULL
	,[Grade_10] [char](1) NULL
	,[Grade_11] [char](1) NULL
	,[Grade_12] [char](1) NULL
	,[Teacher_PK_5] [char](1) NULL
	,[Teacher_PK_6] [char](1) NULL
	,[Teacher_6_12] [char](1) NULL
	,[Teacher_7_12] [char](1) NULL
	)


--Variables for this Package:

Name			Scope														Data type			Value
PackageID		Package 06_Upload STARS Scheduling Data into SWHUB 			Int32				6


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
INSERT INTO SWHUB_SSIS_PackageTransactionLog (ID,[PackageName])
VALUES (6,'Package 06_Upload STARS Scheduling Data into SWHUB')
