--EST_Delete data from destination table
Connection: ES11VDEXTESQL01 FGR_INT FGRepUser
SQL Statement:
TRUNCATE TABLE [SWHUB_STARS_Elementary_Middle_High School PE and HE Teachers]
GO

--DFT_Get Elementary Middle and High School PE and HE Teachers
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
DECLARE @SY INT; 
SET @SY = CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END; 
SELECT DISTINCT a.[SchoolYear],a.[SchoolDBN],a.[TeacherFirstName],a.[TeacherLastName],a.[Teacher_Email],a.[DOE_EmployeeID],a.[EisID],
h.[ES - PE Teacher (STARS)],
h.[ES - 3+ PE Courses (STARS)], 
h.[ES - Total PE Courses (STARS)],
d.[MS - PE Teacher (STARS)],
CASE WHEN d.[MS - Total PE Courses (STARS)]>=3 THEN 'Yes' END AS 'MS - 3+ PE Courses (STARS)' , 
d.[MS - Total PE Courses (STARS)],
e.[HS - PE Teacher (STARS)],
CASE WHEN e.[HS - Total PE Courses (STARS)]>=3 THEN 'Yes' END AS 'HS - 3+ PE Courses (STARS)',  
e.[HS - Total PE Courses (STARS)],
f.[MS - HE Teacher (STARS)],
CASE WHEN f.[MS - Total HE Courses (STARS)]>=3 THEN 'Yes' END AS 'MS - 3+ HE Courses (STARS)',  
f.[MS - Total HE Courses (STARS)],
g.[HS - HE Teacher (STARS)],
CASE WHEN g.[HS - Total HE Courses (STARS)]>=3 THEN 'Yes' END AS 'HS - 3+ HE Courses (STARS)',  
g.[HS - Total HE Courses (STARS)]

FROM 
(
--All Teachers in STARS who has PE or HE classes setup
SELECT DISTINCT a.SchoolYear,a.SchoolDBN,b.[FirstName] AS [TeacherFirstName],b.[LastName] AS [TeacherLastName],
a.[Teacher_Email],a.[EisID],a.[DOE_EmployeeID] 
FROM [dbo].[SWHUB_STARS_FACT_Scheduling_ByStudentAndTeacher] (NOLOCK) a
INNER JOIN [dbo].[SWHUB_ISS_PersonalInfo] b ON a.[DOE_EmployeeID]=b.[EmployeeNo]
WHERE 
a.SchoolYear = @SY							AND 
a.[DOE_EmployeeID] IS NOT NULL				AND 
SUBSTRING(a.[CourseCode],1,1) = 'P'			AND 
SUBSTRING (a.SchoolDBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', 
'18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') 
) a
LEFT JOIN 
(
--MS PE Teachers 

SELECT DISTINCT cc.SchoolYear,cc.SchoolDBN,cc.[Teacher_Email],cc.[EisID],cc.[DOE_EmployeeID],Count(cc.[CourseCode]) AS [MS - Total PE Courses (STARS)],
CASE WHEN  cc.[Teacher_Email] IS NOT NULL THEN 'Yes' END AS 'MS - PE Teacher (STARS)'
FROM (
SELECT DISTINCT  a.SchoolYear,a.SchoolDBN,a.[Teacher_Email],a.[EisID],a.[DOE_EmployeeID],a.[CourseCode],
CASE WHEN  [Teacher_Email] IS NOT NULL THEN 'MS PE Teacher (STARS)' END AS 'TeacherLabel'
FROM [dbo].[SWHUB_STARS_FACT_Scheduling_ByStudentAndTeacher] (NOLOCK) a
INNER JOIN [dbo].[SWHUB_ISS_PersonalInfo] b ON a.[DOE_EmployeeID]=b.[EmployeeNo]
WHERE 
a.[SchoolYear]=@SY 						AND
a.[DOE_EmployeeID] IS NOT NULL			AND 
SUBSTRING(a.[CourseCode],1,1) ='P'		AND 
SUBSTRING(a.[CourseCode],2,1) <>'H'		AND SUBSTRING(a.[CourseCode],2,1) <>'E'		AND
(SUBSTRING(a.[CourseCode],4,1) = 'M'	OR	SUBSTRING(a.[CourseCode],4,2) = 'J6')	AND 
SUBSTRING(a.[CourseCode],7,1) <> 'R'	AND 
a.[DOE_EmployeeID] IS NOT NULL			AND 
a.[DOE_EmployeeID]<>''					AND 
SUBSTRING (a.SchoolDBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', 
'18', '19', '20', '21', '22', '23', '24','25', '26', '27', '28', '29', '30', '31', '32','75') 
)cc
GROUP BY cc.SchoolYear,cc.SchoolDBN,cc.[Teacher_Email],cc.[EisID],cc.[DOE_EmployeeID]
) d 
ON  a.SchoolDBN=d.SchoolDBN AND a.[Teacher_Email]=d.[Teacher_Email]

LEFT JOIN 
( 
--HS PE Teachers
SELECT DISTINCT bb.[SchoolYear],bb.[SchoolDBN],bb.[Teacher_Email],bb.[EisID],bb.[DOE_EmployeeID],Count(bb.[CourseCode]) AS [HS - Total PE Courses (STARS)],
CASE WHEN  bb.[Teacher_Email] IS NOT NULL THEN 'Yes' END AS 'HS - PE Teacher (STARS)'
FROM (
SELECT DISTINCT a.[SchoolYear],a.[SchoolDBN],a.[Teacher_Email],a.EisID,a.[DOE_EmployeeID],a.[CourseCode]
FROM [dbo].[SWHUB_STARS_FACT_Scheduling_ByStudentAndTeacher] (NOLOCK) a
INNER JOIN [dbo].[SWHUB_ISS_PersonalInfo] b ON a.[DOE_EmployeeID]=b.[EmployeeNo]
WHERE 
a.SchoolYear = @SY							AND
a.[DOE_EmployeeID] IS NOT NULL				AND 
SUBSTRING(a.[CourseCode],1,1) ='P'			AND 
SUBSTRING(a.[CourseCode],2,1) <>'H'			AND SUBSTRING(a.[CourseCode],2,1) <>'E'	AND 
SUBSTRING(a.[CourseCode],4,1) <> 'M'		AND 
SUBSTRING(a.[CourseCode],4,1) <> 'J'		AND 
SUBSTRING(a.[CourseCode],7,1) <> 'R'		AND 
SUBSTRING (a.SchoolDBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', 
'18', '19', '20', '21', '22', '23', '24','25', '26', '27', '28', '29', '30', '31', '32','75') 
)bb
GROUP BY bb.[SchoolYear],bb.SchoolDBN,bb.[Teacher_Email],bb.EisID,bb.[DOE_EmployeeID]
)e ON  a.SchoolDBN=e.SchoolDBN AND a.[Teacher_Email]=e.[Teacher_Email]

LEFT JOIN 
(
--MS HE teachers
SELECT DISTINCT cc.SchoolDBN,cc.[Teacher_Email],cc.[EisID],cc.[DOE_EmployeeID],Count(cc.[CourseCode]) AS [MS - Total HE Courses (STARS)],
CASE WHEN  cc.[Teacher_Email] IS NOT NULL THEN 'Yes' END AS 'MS - HE Teacher (STARS)'
FROM (
SELECT DISTINCT a.[SchoolYear],a.[SchoolDBN],a.[Teacher_Email],a.[EisID],a.[DOE_EmployeeID],a.[CourseCode]
FROM [dbo].[SWHUB_STARS_FACT_Scheduling_ByStudentAndTeacher] (NOLOCK) a
INNER JOIN [dbo].[SWHUB_ISS_PersonalInfo] b ON a.[DOE_EmployeeID]=b.[EmployeeNo]
WHERE  
[SchoolYear] = @SY							AND
a.[DOE_EmployeeID] IS NOT NULL				AND 
(SUBSTRING(a.[CourseCode],1,2) ='PH'		OR	SUBSTRING(a.[CourseCode],1,2) ='PE')	AND 
(SUBSTRING(a.[CourseCode],4,1) = 'M'		OR	SUBSTRING(a.[CourseCode],4,2) = 'J6')	AND 
SUBSTRING(a.[CourseCode],7,1) <> 'R'		AND 
SUBSTRING (a.SchoolDBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', 
'18', '19', '20', '21', '22', '23', '24','25', '26', '27', '28', '29', '30', '31', '32','75')
)cc 
GROUP BY cc.[SchoolYear],cc.[SchoolDBN],cc.[Teacher_Email],cc.[EisID],cc.[DOE_EmployeeID]
)f ON  a.SchoolDBN=f.SchoolDBN AND a.[Teacher_Email]=f.[Teacher_Email]
LEFT JOIN
(
--HS HE Teachers
SELECT DISTINCT dd.SchoolDBN,dd.[Teacher_Email],dd.[EisID],dd.[DOE_EmployeeID],Count(dd.[CourseCode]) AS [HS - Total HE Courses (STARS)],
CASE WHEN  dd.[Teacher_Email] IS NOT NULL THEN 'Yes' END AS 'HS - HE Teacher (STARS)'
FROM (
SELECT DISTINCT a.SchoolDBN,a.[Teacher_Email],a.[EisID],a.[DOE_EmployeeID],a.[CourseCode]
FROM [dbo].[SWHUB_STARS_FACT_Scheduling_ByStudentAndTeacher] (NOLOCK) a
INNER JOIN [dbo].[SWHUB_ISS_PersonalInfo] b ON a.[DOE_EmployeeID]=b.[EmployeeNo]
WHERE  
SchoolYear = @SY							AND
a.[DOE_EmployeeID] IS NOT NULL				AND 
(SUBSTRING(a.[CourseCode],1,2) ='PH'		OR	SUBSTRING(a.[CourseCode],1,2) ='PE')	AND 
SUBSTRING(a.[CourseCode],4,1) <> 'M'		AND 
SUBSTRING(a.[CourseCode],4,1) <> 'J'		AND 
SUBSTRING(a.[CourseCode],7,1) <> 'R'		AND 
SUBSTRING (a.SchoolDBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', 
'18', '19', '20', '21', '22', '23', '24','25', '26', '27', '28', '29', '30', '31', '32','75')
)dd 
GROUP BY dd.SchoolDBN,dd.[Teacher_Email],dd.[EisID],dd.[DOE_EmployeeID]
)g ON  a.SchoolDBN=g.SchoolDBN AND a.[Teacher_Email]=g.[Teacher_Email]

LEFT JOIN 
--All elementary PE teachers who has 3 or more  PE classes
(
SELECT * FROM (
SELECT DISTINCT c.SchoolYear,c.SchoolDBN,c.[Teacher_Email],c.[EisID],c.[DOE_EmployeeID],COUNT(c.CourseCode) AS [ES - Total PE Courses (STARS)],
CASE WHEN  [Teacher_Email] IS NOT NULL THEN 'Yes' END AS 'ES - PE Teacher (STARS)',
CASE WHEN COUNT(CourseCode)>=3 THEN 'Yes' END AS 'ES - 3+ PE Courses (STARS)' 
FROM (
SELECT DISTINCT a.SchoolYear,a.SchoolDBN,a.[Teacher_Email],a.[EisID],a.[DOE_EmployeeID],a.[CourseCode] FROM [dbo].[SWHUB_STARS_FACT_Scheduling_ByStudentAndTeacher] a
INNER JOIN [dbo].[SWHUB_ISS_PersonalInfo] b ON a.[DOE_EmployeeID]=b.[EmployeeNo]
WHERE 
a.SchoolYear = @SY					AND
a.[DOE_EmployeeID] IS NOT NULL		AND 
SUBSTRING(a.CourseCode,1,1) = 'P'	AND 
SUBSTRING(a.coursecode,2,1)<>'H'	AND SUBSTRING(coursecode,2,1)<>'E' AND
SUBSTRING(a.coursecode,4,1) = 'J'	AND  
SUBSTRING (a.SchoolDBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', 
'18', '19', '20', '21', '22', '23', '24','25', '26', '27', '28', '29', '30', '31', '32','75') 
)c 
GROUP BY c.SchoolYear,c.SchoolDBN,c.[Teacher_Email],c.[EisID],c.[DOE_EmployeeID]
) d WHERE [ES - 3+ PE Courses (STARS)]='Yes' 
)h ON a.SchoolDBN=h.SchoolDBN AND a.[Teacher_Email]=h.[Teacher_Email]
INNER JOIN [dbo].[SWHUB_Supertable_Schools Dimension] i
ON a.SchoolDBn=i.System_Code

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_STARS_Elementary_Middle_High School PE and HE Teachers]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[SWHUB_STARS_Elementary_Middle_High School PE and HE Teachers]') IS NOT NULL
	DROP TABLE [SWHUB_STARS_Elementary_Middle_High School PE and HE Teachers]
CREATE TABLE [SWHUB_STARS_Elementary_Middle_High School PE and HE Teachers] (
    [SchoolYear] smallint,
    [SchoolDBN] varchar(6),
    [TeacherFirstName] varchar(100),
    [TeacherLastName] varchar(100),
  	[Teacher_Email] varchar(100),
    [DOE_EmployeeID] varchar(15),
    [EisID] varchar(15),
	[ES - PE Teacher (STARS)] varchar(3),
    [ES - 3+ PE Courses (STARS)] varchar(3),
	[ES - Total PE Courses (STARS)] int,
    [MS - PE Teacher (STARS)] varchar(3),
    [MS - 3+ PE Courses (STARS)] varchar(3),
    [MS - Total PE Courses (STARS)] int,
    [HS - PE Teacher (STARS)] varchar(3),
    [HS - 3+ PE Courses (STARS)] varchar(3),
    [HS - Total PE Courses (STARS)] int,
    [MS - HE Teacher (STARS)] varchar(3),
    [MS - 3+ HE Courses (STARS)] varchar(3),
    [MS - Total HE Courses (STARS)] int,
    [HS - HE Teacher (STARS)] varchar(3),
    [HS - 3+ HE Courses (STARS)] varchar(3),
    [HS - Total HE Courses (STARS)] int
)


--Variables for this Package:

Name			Scope																		Data type			Value
PackageID		Package 08_Elementary Middle and High School PE and HE Teachers 			Int32				8


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
VALUES (8,'Package 08_Elementary Middle and High School PE and HE Teachers')