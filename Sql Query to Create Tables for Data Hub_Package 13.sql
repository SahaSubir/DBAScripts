--EST_To delete all labels whose expiration dates are lower than the current date
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
DELETE FROM [dbo].[ISS_tblTeacherProfileLabels] WHERE ExpirationDate<GETDATE()

--Sequence Container 11
--EST_Archive PE & HE Teachers
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- Archive : PE HE Teachers
INSERT INTO ISS_tblTeacherProfileLabels_Archive(sEISID,nComponentID,sEmployeeNo,InAccurate_Flag,LastModifiedDate)
  SELECT TPL.sEISID,TPL.nComponentID,TPL.sEmployeeNo,TPL.InAccurate_Flag,GETDATE() FROM ISS_tblTeacherProfileLabels TPL INNER JOIN ISS_tblTeacherLabelsLookUp TLL ON TPL.nComponentID = TLL.nComponentID
  WHERE TLL.Is_Active = 'Y' AND TLL.Is_AutoRefresh_Flag = 'Y' AND TLL.nComponentID IN (49,50,51,52,63) AND
  TPL.sEmployeeNo IS NOT NULL AND (TPL.InAccurate_Flag IS NULL OR TPL.InAccurate_Flag = 'U')
  AND (CONVERT(VARCHAR,TPL.sEmployeeNo,15) + '-' + CONVERT(VARCHAR,TPL.nComponentID,5)) NOT IN (SELECT CONVERT(VARCHAR,sEmployeeNo,15) + '-' + CONVERT(VARCHAR,nComponentID,5) AS sKey FROM ISS_tblTeacherProfileLabels_Archive)

--EST_Temporarily archive PE & HE Teachers into a Staging table
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- Archive : Temporarily archive PE and HE teachers into a staging table whose InAccurate_Flag IS "NOT NULL" OR [ExpirationDate] IS "NOT NULL" 
INSERT INTO ISS_tblTeacherProfileLabels_Staging(sEISID,nComponentID,sEmployeeNo,InAccurate_Flag,LastModifiedDate,ExpirationDate)
SELECT sEISID,nComponentID,sEmployeeNo,InAccurate_Flag,[LastModifiedDate],[ExpirationDate] FROM ISS_tblTeacherProfileLabels
WHERE (nComponentID IN (49,50,51,52,63) AND InAccurate_Flag IS NOT NULL) OR (nComponentID IN (49,50,51,52,63) AND [ExpirationDate] IS NOT NULL) 

--DFT_To get PE HE teachers into a staging table
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL Command text: 
EXEC usp_SWHUB_PE_HE_Teachers_TAG

--Stored procedure creation
USE [FGR_INT]
GO

/****** Object:  StoredProcedure [dbo].[usp_SWHUB_PE_HE_Teachers_TAG]    Script Date: 12/5/2019 10:58:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Author:		<Subir Saha>
-- Create date: <6/27/2017>
-- Description:	<To get Elementary, Middle and High schools' Physical and Health education teachers from STARS scheduling data >

CREATE PROCEDURE [dbo].[usp_SWHUB_PE_HE_Teachers_TAG]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @SY INT; 
SET @SY = CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END; 

--ME PE Teachers
SELECT DISTINCT  a.[DOE_EmployeeID] AS [EmployeeNumber],REPLACE(SUBSTRING(a.[Teacher_Email],1,(CHARINDEX('@', a.[Teacher_Email]))),'@','') AS [EmailAlias],
CASE WHEN  [DOE_EmployeeID] IS NOT NULL THEN 'MS PE Teacher (STARS)' END AS 'TeacherLabel',
CASE WHEN  [DOE_EmployeeID] IS NOT NULL THEN 49 END AS 'TeacherLabelId'
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

UNION
--HS PE Teachers
SELECT DISTINCT a.[DOE_EmployeeID] AS [EmployeeNumber],REPLACE(SUBSTRING(a.[Teacher_Email],1,(CHARINDEX('@', a.[Teacher_Email]))),'@','') AS [EmailAlias],
CASE WHEN  [DOE_EmployeeID] IS NOT NULL THEN 'HS PE Teacher (STARS)' END AS 'TeacherLabel',
CASE WHEN  [DOE_EmployeeID] IS NOT NULL THEN 50 END AS 'TeacherLabelId'
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

UNION
--MS HE teachers
SELECT DISTINCT a.[DOE_EmployeeID] AS [EmployeeNumber],REPLACE(SUBSTRING(a.[Teacher_Email],1,(CHARINDEX('@', a.[Teacher_Email]))),'@','') AS [EmailAlias],
CASE WHEN  [DOE_EmployeeID] IS NOT NULL THEN 'MS HE Teacher (STARS)' END AS 'TeacherLabel' ,
CASE WHEN  [DOE_EmployeeID] IS NOT NULL THEN 51 END AS 'TeacherLabelId'
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

UNION
--HS HE Teachers
SELECT DISTINCT a.[DOE_EmployeeID] AS [EmployeeNumber],REPLACE(SUBSTRING(a.[Teacher_Email],1,(CHARINDEX('@', a.[Teacher_Email]))),'@','') AS [EmailAlias],
CASE WHEN  [DOE_EmployeeID] IS NOT NULL THEN 'HS HE Teacher (STARS)' END AS 'TeacherLabel',
CASE WHEN  [DOE_EmployeeID] IS NOT NULL THEN 52 END AS 'TeacherLabelId' 
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

UNION
--Elementary PE Teachers by Class,Course 
SELECT d.[DOE_EmployeeID] AS [EmployeeNumber],REPLACE(SUBSTRING(d.[Teacher_Email],1,(CHARINDEX('@', d.[Teacher_Email]))),'@','') AS [EmailAlias],
CASE WHEN  d.[DOE_EmployeeID] IS NOT NULL THEN 'ES PE Teacher (STARS)' END AS 'TeacherLabel',
CASE WHEN  d.[DOE_EmployeeID] IS NOT NULL THEN 63 END AS 'TeacherLabelId'  
FROM (
SELECT a.SchoolYear,a.SchoolDBN,a.[Teacher_Email],a.[EisID],a.[DOE_EmployeeID],a.[ES - Total Official Classes (STARS)],
b.[ES - Total PE Courses (STARS)],  
CASE WHEN (a.[ES - Total Official Classes (STARS)]>=3 OR b.[ES - Total PE Courses (STARS)]>=3) THEN 'Yes' END AS 'ES - PE Teacher (STARS)'
FROM  
(SELECT DISTINCT cc.SchoolYear,cc.SchoolDBN,cc.[Teacher_Email],cc.[EisID],cc.[DOE_EmployeeID],COUNT(cc.[OfficialClass]) AS [ES - Total Official Classes (STARS)]
FROM (
SELECT DISTINCT a.SchoolYear,a.SchoolDBN,a.[Teacher_Email],a.[EisID],a.[DOE_EmployeeID],a.[OfficialClass] FROM [dbo].[SWHUB_STARS_FACT_Scheduling_ByStudentAndTeacher] a
INNER JOIN [dbo].[SWHUB_ISS_PersonalInfo] b ON a.[DOE_EmployeeID]=b.[EmployeeNo]
WHERE 
a.SchoolYear = @SY					AND
a.[DOE_EmployeeID] IS NOT NULL		AND 
SUBSTRING(a.CourseCode,1,1) = 'P'	AND 
SUBSTRING(a.coursecode,2,1)<>'H'	AND SUBSTRING(coursecode,2,1)<>'E' AND
SUBSTRING(a.coursecode,4,1) = 'J'	AND  
SUBSTRING (a.SchoolDBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', 
'18', '19', '20', '21', '22', '23', '24','25', '26', '27', '28', '29', '30', '31', '32','75') 
)cc
GROUP BY cc.SchoolYear,cc.SchoolDBN,cc.[Teacher_Email],cc.[EisID],cc.[DOE_EmployeeID] 
)a

LEFT JOIN
(SELECT DISTINCT cc.SchoolYear,cc.SchoolDBN,cc.[Teacher_Email],cc.[EisID],cc.[DOE_EmployeeID],COUNT(cc.CourseCode) AS [ES - Total PE Courses (STARS)]
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
)cc
GROUP BY cc.SchoolYear,cc.SchoolDBN,cc.[Teacher_Email],cc.[EisID],cc.[DOE_EmployeeID]
)b ON a.SchoolDBN=b.SchoolDBN AND a.DOE_EmployeeID=b.DOE_EmployeeID
)d WHERE [ES - PE Teacher (STARS)]='Yes' 
END

GO

--Data Conversion:
Input Column		Output Alias				Data Type			Length
[EmployeeNumber]	EmployeeNumber_Convert		string [DT_STR]		15
[EmailAlias]		EmailAlias_Convert			string [DT_STR]		100


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [OSWP_tblOSWPStaff_Staging]
--Table creation code:

CREATE TABLE [dbo].[OSWP_tblOSWPStaff_Staging](
	[sEmployeeNo] [varchar](15) NULL,
	[EmailAlias] [varchar](100) NULL,
	[TeacherLabel] [varchar](100) NULL,
	[TeacherLabelId] [int] NULL
) ON [PRIMARY]

GO


--EST_Delete PE HE Teachers
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- For delete : PE HE Teachers
DELETE FROM ISS_tblTeacherProfileLabels 
WHERE nComponentID IN (49,50,51,52,63)

--DFT_ISS_tblTeacherProfileLabels
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL Command text: 
--INSERT into table ISS_tblTeacherProfileLabels
SELECT DISTINCT PeHe.[sEmployeeNo],PeI.[sEISID],PeHe.[TeacherLabelId] AS [nComponentID],GETDATE() AS [LastModifiedDate] FROM 
(SELECT * FROM [dbo].[OSWP_tblOSWPStaff_Staging] WHERE [TeacherLabelId] IS NOT NULL) PeHe
INNER JOIN (SELECT DISTINCT[sEmployeeNo],[sEISID] FROM [dbo].[ISS_tblPersonalInfo]) PeI ON  PeHe.[sEmployeeNo]=PeI.[sEmployeeNo]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_tblTeacherProfileLabels]
--Table creation code:
CREATE TABLE [dbo].[ISS_tblTeacherProfileLabels](
	[sEISID] [varchar](7) NULL,
	[nComponentID] [int] NOT NULL,
	[sEmployeeNo] [varchar](15) NULL,
	[InAccurate_Flag] [char](1) NULL,
	[LastModifiedDate] [datetime] NULL,
	[ExpirationDate] [datetime] NULL
) ON [PRIMARY]

GO

Note: Ignore [InAccurate_Flag],[ExpirationDate] for the mapping


--EST_To update EISID when NULL
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
UPDATE [ISS_tblTeacherProfileLabels]
SET sEISID='NA'
WHERE sEISID IS NULL AND nComponentID IN (49,50,51,52,63)

--EST_To update InAccurate_Flag and ExpirationDate
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
UPDATE TPL 
SET TPL.[InAccurate_Flag] = TPLS.[InAccurate_Flag], 
TPL.[ExpirationDate]=TPLS.[ExpirationDate]
FROM  [ISS_tblTeacherProfileLabels] TPL
INNER JOIN [ISS_tblTeacherProfileLabels_Staging] TPLS
ON TPL.[sEmployeeNo] = TPLS.[sEmployeeNo] AND TPL.[nComponentID]=TPLS.[nComponentID]


--EST_Delete records from Staging Tables
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
--Delete
DELETE FROM  [dbo].[ISS_tblTeacherProfileLabels_Staging]
GO
DELETE FROM  [dbo].[OSWP_tblOSWPStaff_Staging]
GO


--Sequence Container 21
--EST_Archive CHAMPS Coach
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- Archive : CHAMPS Coach
INSERT INTO ISS_tblTeacherProfileLabels_Archive(sEISID,nComponentID,sEmployeeNo,InAccurate_Flag,LastModifiedDate)
  SELECT TPL.sEISID,TPL.nComponentID,TPL.sEmployeeNo,TPL.InAccurate_Flag,GETDATE() FROM ISS_tblTeacherProfileLabels TPL INNER JOIN ISS_tblTeacherLabelsLookUp TLL ON TPL.nComponentID = TLL.nComponentID
  WHERE TLL.Is_Active = 'Y' AND TLL.Is_AutoRefresh_Flag = 'Y' AND TLL.nComponentID IN (25,53) AND
  TPL.sEmployeeNo IS NOT NULL AND (TPL.InAccurate_Flag IS NULL OR TPL.InAccurate_Flag = 'U')
  AND (CONVERT(VARCHAR,TPL.sEmployeeNo,15) + '-' + CONVERT(VARCHAR,TPL.nComponentID,5)) NOT IN (SELECT CONVERT(VARCHAR,sEmployeeNo,15) + '-' + CONVERT(VARCHAR,nComponentID,5) AS sKey FROM ISS_tblTeacherProfileLabels_Archive)

--EST_Archive CHAMPS Coach
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- Archive : Temporarily archive CHAMPS Coaches into a staging table whose InAccurate_Flag IS "NOT NULL" OR [ExpirationDate] IS "NOT NULL" 
INSERT INTO ISS_tblTeacherProfileLabels_Staging(sEISID,nComponentID,sEmployeeNo,InAccurate_Flag,LastModifiedDate,ExpirationDate)
SELECT sEISID,nComponentID,sEmployeeNo,InAccurate_Flag,[LastModifiedDate],[ExpirationDate] FROM ISS_tblTeacherProfileLabels
WHERE (nComponentID IN (25,53) AND InAccurate_Flag IS NOT NULL) OR (nComponentID IN (25,53) AND [ExpirationDate] IS NOT NULL) 

--DFT_To get CHAMPS Coaches into a staging table
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.Champs_Int.ChampsUser
--Data access mode: SQL Command
--SQL Command text: 
EXEC FH_GetCoachStatusInformation

--Stored procedure creation
USE [Champs_Int]
GO

/****** Object:  StoredProcedure [dbo].[FH_GetCoachStatusInformation]    Script Date: 12/5/2019 11:20:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- exec FH_CoachStatusInformation
CREATE PROCEDURE [dbo].[FH_GetCoachStatusInformation]
	
AS
BEGIN
SELECT DISTINCT EmployeeNo,[EmailAlias],
CASE WHEN  EmployeeNo IS NOT NULL THEN 'CHAMPS Coach (former)' END AS 'TeacherLabel',
CASE WHEN  EmployeeNo IS NOT NULL THEN 53 END AS 'TeacherLabelId'
FROM ( 
SELECT  c.EmployeeNo,REPLACE(SUBSTRING(c.Email,1,(CHARINDEX('@', c.Email))),'@','') AS [EmailAlias],s.School_Year,
substring(s.School_Year,1,4) AS SchoolYear
FROM dbo.FH_Application app                                            
LEFT OUTER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId                                                     
LEFT OUTER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
LEFT OUTER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID                                                   
LEFT OUTER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
LEFT OUTER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
LEFT OUTER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                     
LEFT OUTER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId   
LEFT OUTER JOIN dbo.Location_Supertable ls ON app.SchoolDBN = ls.System_Code          
WHERE app.Approved=1 and app.CoachApproved=1 and School_Year IS NOT NULL   and app.ProgramStatusId = 1 AND c.EmployeeNo IS NOT NULL AND c.EmployeeNo<>''
) a -- All active coaches for different years
WHERE [EmployeeNo] NOT in (SELECT DISTINCT EmployeeNo FROM  ----exclude current active year coaches to get the past coaches only

(SELECT DISTINCT EmployeeNo,[EmailAlias] FROM 
( 
SELECT DISTINCT c.EmployeeNo,REPLACE(SUBSTRING(c.Email,1,(CHARINDEX('@', c.Email))),'@','') AS [EmailAlias],s.School_Year,
substring(s.School_Year,1,4) AS SchoolYear
FROM dbo.FH_Application app                                            
LEFT OUTER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId                                                     
LEFT OUTER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
LEFT OUTER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID                                                   
LEFT OUTER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
LEFT OUTER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
LEFT OUTER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                     
LEFT OUTER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId   
LEFT OUTER JOIN dbo.Location_Supertable ls ON app.SchoolDBN = ls.System_Code          
WHERE app.Approved=1 and app.CoachApproved=1 and 
School_Year IS NOT NULL   and app.ProgramStatusId = 1 AND c.EmployeeNo IS NOT NULL AND c.EmployeeNo<>''
) a
WHERE SchoolYear = CASE WHEN month(getdate()) >= '07' THEN year(getdate())  ELSE year(getdate())-1  END --Current coaches
)c )

UNION --to add current active coaches

SELECT DISTINCT EmployeeNo,[EmailAlias],
CASE WHEN  EmployeeNo IS NOT NULL THEN 'CHAMPS Coach (current)' END AS 'TeacherLabel',
CASE WHEN  EmployeeNo IS NOT NULL THEN 25 END AS 'TeacherLabelId'
FROM ( 
SELECT DISTINCT c.EmployeeNo,REPLACE(SUBSTRING(c.Email,1,(CHARINDEX('@', c.Email))),'@','') AS [EmailAlias],s.School_Year,
substring(s.School_Year,1,4) AS SchoolYear
FROM dbo.FH_Application app                                            
LEFT OUTER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId                                                     
LEFT OUTER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
LEFT OUTER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID                                                   
LEFT OUTER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
LEFT OUTER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
LEFT OUTER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                     
LEFT OUTER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId   
LEFT OUTER JOIN dbo.Location_Supertable ls ON app.SchoolDBN = ls.System_Code          
WHERE app.Approved=1 and app.CoachApproved=1 and 
School_Year IS NOT NULL   and app.ProgramStatusId = 1 AND c.EmployeeNo IS NOT NULL AND c.EmployeeNo<>''
) a
WHERE SchoolYear = CASE WHEN month(getdate()) >= '07' THEN year(getdate())  ELSE year(getdate())-1  END 


END

GO

--Data Conversion:
Input Column		Output Alias				Data Type			Length
[EmailAlias]		EmailAlias_Convert			string [DT_STR]		100

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [OSWP_tblOSWPStaff_Staging]
--Table creation code:
Table created before


--EST_Delete CHAMPS Coaches
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- For delete : CHAMPS Coaches
DELETE FROM ISS_tblTeacherProfileLabels 
WHERE nComponentID IN (25,53)

--DFT_ISS_tblTeacherProfileLabels
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.Champs_Int.ChampsUser
--Data access mode: SQL Command
--SQL Command text: 
--INSERT into table ISS_tblTeacherProfileLabels
SELECT DISTINCT chp.[sEmployeeNo],PeI.[sEISID],chp.[TeacherLabelId] AS [nComponentID],GETDATE() AS [LastModifiedDate] FROM 
(SELECT * FROM [dbo].[OSWP_tblOSWPStaff_Staging] WHERE [TeacherLabelId] IS NOT NULL) chp
INNER JOIN (SELECT DISTINCT[sEmployeeNo],[sEISID] FROM [dbo].[ISS_tblPersonalInfo]) PeI ON  chp.[sEmployeeNo]=PeI.[sEmployeeNo]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_tblTeacherProfileLabels]
--Table creation code:
Table created before

Note: Ignore [InAccurate_Flag],[ExpirationDate] for the mapping


--EST_To update EISID when NULL
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
UPDATE [ISS_tblTeacherProfileLabels]
SET sEISID='NA'
WHERE sEISID IS NULL AND nComponentID IN (25,53)

--EST_To update InAccurate_Flag and ExpirationDate
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
UPDATE TPL 
SET TPL.[InAccurate_Flag] = TPLS.[InAccurate_Flag], 
TPL.[ExpirationDate]=TPLS.[ExpirationDate]
FROM  [ISS_tblTeacherProfileLabels] TPL
INNER JOIN [ISS_tblTeacherProfileLabels_Staging] TPLS
ON TPL.[sEmployeeNo] = TPLS.[sEmployeeNo] AND TPL.[nComponentID]=TPLS.[nComponentID]


--EST_Delete records from Staging Tables
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
--Delete
DELETE FROM  [dbo].[ISS_tblTeacherProfileLabels_Staging]
GO
DELETE FROM  [dbo].[OSWP_tblOSWPStaff_Staging]
GO

--Sequence Container 
--EST_Archive PE HE NYC License
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- Archive : PE HE NYC License
INSERT INTO ISS_tblTeacherProfileLabels_Archive(sEISID,nComponentID,sEmployeeNo,InAccurate_Flag,LastModifiedDate)
  SELECT TPL.sEISID,TPL.nComponentID,TPL.sEmployeeNo,TPL.InAccurate_Flag,GETDATE() FROM ISS_tblTeacherProfileLabels TPL INNER JOIN ISS_tblTeacherLabelsLookUp TLL ON TPL.nComponentID = TLL.nComponentID
  WHERE TLL.Is_Active = 'Y' AND TLL.Is_AutoRefresh_Flag = 'Y' AND TLL.nComponentID IN (61,62,26) AND
  TPL.sEmployeeNo IS NOT NULL AND (TPL.InAccurate_Flag IS NULL OR TPL.InAccurate_Flag = 'U')
  AND (CONVERT(VARCHAR,TPL.sEmployeeNo,15) + '-' + CONVERT(VARCHAR,TPL.nComponentID,5)) NOT IN (SELECT CONVERT(VARCHAR,sEmployeeNo,15) + '-' + CONVERT(VARCHAR,nComponentID,5) AS sKey FROM ISS_tblTeacherProfileLabels_Archive)


--DFT_To get PE HE NYC License teachers into a staging table
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.FGR_INT.FGRepUser
--Data access mode: SQL Command
--SQL Command text: 
EXEC usp_OSWP_PEHELicensed

--Stored procedure creation
USE [FGR_INT]
GO

/****** Object:  StoredProcedure [dbo].[usp_OSWP_PEHELicensed]    Script Date: 12/5/2019 11:33:46 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_OSWP_PEHELicensed]
AS
	BEGIN
		SELECT sEmployeeNo AS EmployeeNumber,REPLACE(SUBSTRING(sEmail,1,(CHARINDEX('@', sEmail))),'@','') AS [EmailAlias],--sEmail AS Aduid,
		'PE NYC Licensed' AS TeacherLabel,61 AS TeacherLabelId 
		FROM SWHUB_TblStaffData WHERE --sEmpStatus = 'A' AND 
		(sLicenceCode IN ('418B','AP39','594B','549B','756B') OR 
		([SecondaryLicenseCode] LIKE '%418B%' OR [SecondaryLicenseCode] LIKE '%AP39%' OR [SecondaryLicenseCode] LIKE '%594B%' OR [SecondaryLicenseCode] LIKE '%549B%' OR [SecondaryLicenseCode] LIKE '%756B%')
		)
		UNION ALL
		SELECT sEmployeeNo AS EmployeeNumber,REPLACE(SUBSTRING(sEmail,1,(CHARINDEX('@', sEmail))),'@','') AS [EmailAlias],--sEmail AS Aduid,
		'HE NYC Licensed' AS TeacherLabel,62 AS TeacherLabelId 
		FROM SWHUB_TblStaffData WHERE --sEmpStatus = 'A' AND 
		(sLicenceCode IN ('703B','533B','735B') OR 
		([SecondaryLicenseCode] LIKE '%703B%' OR [SecondaryLicenseCode] LIKE '%533B%' OR [SecondaryLicenseCode] LIKE '%735B%')
		) 
		UNION ALL
		SELECT sEmployeeNo AS EmployeeNumber,REPLACE(SUBSTRING(sEmail,1,(CHARINDEX('@', sEmail))),'@','') AS [EmailAlias],--sEmail AS Aduid,
		'Supervisor HE/PE' AS TeacherLabel,26 AS TeacherLabelId 
		FROM SWHUB_TblStaffData WHERE sLicenceCode IN ('AP39') --AND sEmpStatus = 'A'
	END
GO

--Data Conversion:
Input Column		Output Alias				Data Type			Length
[EmployeeNumber]	EmployeeNumber_Convert		string [DT_STR]		15
[EmailAlias]		EmailAlias_Convert			string [DT_STR]		100

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [OSWP_tblOSWPStaff_Staging]
--Table creation code:
Table created before


--EST_Delete PE HE NYC License teachers
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- For delete : CHAMPS Coaches
-- For delete : PE HE NYC License teachers
DELETE FROM ISS_tblTeacherProfileLabels 
WHERE nComponentID IN (61,62,26)


--DFT_ISS_tblTeacherProfileLabels
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL Command text: 
--INSERT into table ISS_tblTeacherProfileLabels
SELECT DISTINCT a.[sEmployeeNo],b.[sEISID],a.[TeacherLabelId] AS [nComponentID],'V' AS [InAccurate_Flag],GETDATE() AS [LastModifiedDate] FROM [OSWP_tblOSWPStaff_Staging] a
INNER JOIN (SELECT DISTINCT[sEmployeeNo],[sEISID] FROM [dbo].[ISS_tblPersonalInfo]) b ON  a.[sEmployeeNo]=b.[sEmployeeNo] AND a.[TeacherLabelId] IS NOT NULL

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_tblTeacherProfileLabels]
--Table creation code:
Table created before

Note: Ignore [ExpirationDate] for the mapping


--EST_To update EISID when NULL
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
UPDATE [ISS_tblTeacherProfileLabels]
SET sEISID='NA'
WHERE sEISID IS NULL AND nComponentID IN (61,62,26)

--EST_Delete records from Staging Tables

Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
--Delete
DELETE FROM  [dbo].[ISS_tblTeacherProfileLabels_Staging]
GO
DELETE FROM  [dbo].[OSWP_tblOSWPStaff_Staging]
GO


--Sequence Container 81
--EST_Archive NYS Certification
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- Archive : PE HE NYS Certification
INSERT INTO ISS_tblTeacherProfileLabels_Archive(sEISID,nComponentID,sEmployeeNo,InAccurate_Flag,LastModifiedDate)
  SELECT TPL.sEISID,TPL.nComponentID,TPL.sEmployeeNo,TPL.InAccurate_Flag,GETDATE() FROM ISS_tblTeacherProfileLabels TPL INNER JOIN ISS_tblTeacherLabelsLookUp TLL ON TPL.nComponentID = TLL.nComponentID
  WHERE TLL.Is_Active = 'Y' AND TLL.Is_AutoRefresh_Flag = 'Y' AND TLL.nComponentID IN (74,75) AND
  TPL.sEmployeeNo IS NOT NULL AND (TPL.InAccurate_Flag IS NULL OR TPL.InAccurate_Flag = 'U')
  AND (CONVERT(VARCHAR,TPL.sEmployeeNo,15) + '-' + CONVERT(VARCHAR,TPL.nComponentID,5)) NOT IN (SELECT CONVERT(VARCHAR,sEmployeeNo,15) + '-' + CONVERT(VARCHAR,nComponentID,5) AS sKey FROM ISS_tblTeacherProfileLabels_Archive)


--DFT_To get PE HE NYS Certificate teachers into a staging table
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.FGR_INT.FGRepUser
--Data access mode: SQL Command
--SQL Command text: 
EXEC usp_OSWP_PEHE_NYS_Certified

--Stored procedure creation
USE [FGR_INT]
GO

/****** Object:  StoredProcedure [dbo].[usp_OSWP_PEHE_NYS_Certified]    Script Date: 12/5/2019 11:41:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_OSWP_PEHE_NYS_Certified]
AS
BEGIN
SELECT sEmployeeNo AS EmployeeNumber,REPLACE(SUBSTRING(sEmail,1,(CHARINDEX('@', sEmail))),'@','') AS [EmailAlias],--sEmail AS Aduid,
'PE NYS Certified' AS TeacherLabel,74 AS TeacherLabelId 
FROM SWHUB_TblStaffData WHERE --sEmpStatus = 'A' AND 
([CertificationCode] LIKE '%6160%' OR [CertificationCode] LIKE '%6170%')
UNION ALL
SELECT sEmployeeNo AS EmployeeNumber,REPLACE(SUBSTRING(sEmail,1,(CHARINDEX('@', sEmail))),'@','') AS [EmailAlias],--sEmail AS Aduid,
'HE NYS Certified' AS TeacherLabel,75 AS TeacherLabelId 
FROM SWHUB_TblStaffData WHERE --sEmpStatus = 'A' AND 
([CertificationCode] LIKE '%6120%' OR [CertificationCode] LIKE '%6121%')
END

GO


--Data Conversion:
Input Column		Output Alias				Data Type			Length
[EmployeeNumber]	EmployeeNumber_Convert		string [DT_STR]		15
[EmailAlias]		EmailAlias_Convert			string [DT_STR]		100

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [OSWP_tblOSWPStaff_Staging]
--Table creation code:
Table created before


--EST_Delete PE HE NYS Certificate teachers
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
DELETE FROM ISS_tblTeacherProfileLabels 
WHERE nComponentID IN (74,75)


--DFT_ISS_tblTeacherProfileLabels
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL Command text: 
--INSERT into table ISS_tblTeacherProfileLabels
SELECT DISTINCT a.[sEmployeeNo],b.[sEISID],a.[TeacherLabelId] AS [nComponentID],'V' AS [InAccurate_Flag],GETDATE() AS [LastModifiedDate] FROM [OSWP_tblOSWPStaff_Staging] a
INNER JOIN (SELECT DISTINCT[sEmployeeNo],[sEISID] FROM [dbo].[ISS_tblPersonalInfo]) b ON  a.[sEmployeeNo]=b.[sEmployeeNo] AND a.[TeacherLabelId] IS NOT NULL

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_tblTeacherProfileLabels]
--Table creation code:
Table created before

Note: Ignore [ExpirationDate] for the mapping


--EST_To update EISID when NULL
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
UPDATE [ISS_tblTeacherProfileLabels]
SET sEISID='NA'
WHERE sEISID IS NULL AND nComponentID IN (74,75)

--EST_Delete records from Staging Tables
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
--Delete
DELETE FROM  [dbo].[ISS_tblTeacherProfileLabels_Staging]
GO
DELETE FROM  [dbo].[OSWP_tblOSWPStaff_Staging]
GO


--Sequence Container 91
--EST_Archive NewPETeacher_DanceTeacher_AsstPrincip
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- Archive : NewPETeacher_DanceTeacher_AsstPrincipal
INSERT INTO ISS_tblTeacherProfileLabels_Archive(sEISID,nComponentID,sEmployeeNo,InAccurate_Flag,LastModifiedDate)
  SELECT TPL.sEISID,TPL.nComponentID,TPL.sEmployeeNo,TPL.InAccurate_Flag,GETDATE() FROM ISS_tblTeacherProfileLabels TPL INNER JOIN ISS_tblTeacherLabelsLookUp TLL ON TPL.nComponentID = TLL.nComponentID
  WHERE TLL.Is_Active = 'Y' AND TLL.Is_AutoRefresh_Flag = 'Y' AND TLL.nComponentID IN (82,24,17) AND
  TPL.sEmployeeNo IS NOT NULL AND (TPL.InAccurate_Flag IS NULL OR TPL.InAccurate_Flag = 'U')
  AND (CONVERT(VARCHAR,TPL.sEmployeeNo,15) + '-' + CONVERT(VARCHAR,TPL.nComponentID,5)) NOT IN (SELECT CONVERT(VARCHAR,sEmployeeNo,15) + '-' + CONVERT(VARCHAR,nComponentID,5) AS sKey FROM ISS_tblTeacherProfileLabels_Archive)

--Temporarily archive NewPETeacher_DanceTeacher_AsstPrincipal into a staging table
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- Archive : Temporarily archive NewPETeacher_DanceTeacher_AsstPrincipal into a staging table whose InAccurate_Flag IS "NOT NULL" OR [ExpirationDate] IS "NOT NULL" 
INSERT INTO ISS_tblTeacherProfileLabels_Staging(sEISID,nComponentID,sEmployeeNo,InAccurate_Flag,LastModifiedDate,ExpirationDate)
SELECT sEISID,nComponentID,sEmployeeNo,InAccurate_Flag,[LastModifiedDate],[ExpirationDate] FROM ISS_tblTeacherProfileLabels
WHERE (nComponentID IN (82,24,17) AND InAccurate_Flag IS NOT NULL) OR (nComponentID IN (82,24,17) AND [ExpirationDate] IS NOT NULL) 


--DFT_To get NewPETeacher_DanceTeacher_AsstPrincipal into a staging table
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.FGR_INT.FGRepUser
--Data access mode: SQL Command
--SQL Command text: 
EXEC [usp_OSWP_NewPETeacher_DanceTeacher_AsstPrincipal]

--Stored procedure creation
USE [FGR_INT]
GO

/****** Object:  StoredProcedure [dbo].[usp_OSWP_NewPETeacher_DanceTeacher_AsstPrincipal]    Script Date: 12/5/2019 11:46:49 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_OSWP_NewPETeacher_DanceTeacher_AsstPrincipal] 
AS
BEGIN
--New PE Teacher
SELECT EmployeeNumber,[EmailAlias],TeacherLabel,TeacherLabelId FROM (
SELECT DISTINCT TPI.sEmployeeNo AS EmployeeNumber,
REPLACE(SUBSTRING(sEmail,1,(CHARINDEX('@', sEmail))),'@','') AS [EmailAlias],
--sEmail AS Aduid,
'New PE Teacher' AS TeacherLabel,82 AS TeacherLabelId FROM 
(SELECT DISTINCT TS.sEmployeeNo,TS.[sEISId],TS.sEmail,TS.sLicenceCode,TS.[sLicenceDesc],TS.[SecondaryLicenseCode],TS.[SecondaryLicenseDesc],TS.[Assignment_Code],TS.[Assignment_Desc],TS.[sTitleCode_Gxy],TS.[sTitleDesc_Gxy],
CAST(GETDATE() AS DATE) AS Todays_Date,CAST([DOE_Start_Date] AS DATE) AS DOE_StartDate, 
DATEDIFF(M,CAST([DOE_Start_Date] AS DATE),CAST(GETDATE() AS DATE)) AS [Months_BetweenCurrent_AND_DOEStartDate] 
FROM SWHUB_TblStaffData TS WHERE 
		 (DATEDIFF(M,CAST([DOE_Start_Date] AS DATE),CAST(GETDATE() AS DATE))>=0 AND  DATEDIFF(M,CAST([DOE_Start_Date] AS DATE),CAST(GETDATE() AS DATE))<=18) 
) TPI
INNER JOIN (SELECT  DISTINCT [EmployeeNo] FROM [dbo].[SWHUB_ISS_TeacherProfileLabels] WHERE [ComponentID] IN (49, 50, 61, 63,74)) TL ON TPI.[sEmployeeNo]=TL.[EmployeeNo] 
) NWPT

UNION ALL
--Dance Teacher
SELECT DISTINCT TPI.sEmployeeNo AS EmployeeNumber,
REPLACE(SUBSTRING(sEmail,1,(CHARINDEX('@', sEmail))),'@','') AS [EmailAlias],
--sEmail AS Aduid,
'Dance Teacher' AS TeacherLabel, 24 AS TeacherLabelId FROM 
(SELECT DISTINCT TS.sEmployeeNo,TS.[sEISId],TS.sEmail,TS.sLicenceCode,TS.[sLicenceDesc],TS.[SecondaryLicenseCode],TS.[SecondaryLicenseDesc],TS.[Assignment_Code],TS.[Assignment_Desc],TS.[sTitleCode_Gxy],TS.[sTitleDesc_Gxy]
FROM SWHUB_TblStaffData TS WHERE 
		[sLicenceDesc] LIKE 'DANCE' OR [SecondaryLicenseDesc] LIKE 'DANCE'
) TPI


UNION ALL
--Assistant Principal
SELECT DISTINCT TPI.sEmployeeNo AS EmployeeNumber,
REPLACE(SUBSTRING(sEmail,1,(CHARINDEX('@',sEmail))),'@','') AS [EmailAlias],
--sEmail AS Aduid,
'Assistant Principal' AS TeacherLabel,17 AS TeacherLabelId FROM 
(SELECT DISTINCT TS.sEmployeeNo,TS.[sEISId],TS.sEmail,TS.sLicenceCode,TS.[sLicenceDesc],TS.[SecondaryLicenseCode],TS.[SecondaryLicenseDesc],TS.[Assignment_Code],TS.[Assignment_Desc],TS.[sTitleCode_Gxy],TS.[sTitleDesc_Gxy]
FROM SWHUB_TblStaffData TS WHERE [sTitleDesc_Gxy] LIKE '%ASSISTANT PRINCIPAL%' 
) TPI

END


GO



--Data Conversion:
Input Column		Output Alias				Data Type			Length
[EmailAlias]		EmailAlias_Convert			string [DT_STR]		100

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [OSWP_tblOSWPStaff_Staging]
--Table creation code:
Table created before


--EST_Delete NewPETeacher_DanceTeacher_AsstPrincipal
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- For delete : NewPETeacher_DanceTeacher_AsstPrincipal
DELETE FROM ISS_tblTeacherProfileLabels 
WHERE nComponentID IN (82,24,17)


--DFT_ISS_tblTeacherProfileLabels
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL Command text: 
--INSERT into table ISS_tblTeacherProfileLabels
SELECT DISTINCT new.[sEmployeeNo],PeI.[sEISID],new.[TeacherLabelId] AS [nComponentID],GETDATE() AS [LastModifiedDate] FROM 
(SELECT * FROM [dbo].[OSWP_tblOSWPStaff_Staging] WHERE [TeacherLabelId] IS NOT NULL) new
INNER JOIN (SELECT DISTINCT[sEmployeeNo],[sEISID] FROM [dbo].[ISS_tblPersonalInfo]) PeI ON  new.[sEmployeeNo]=PeI.[sEmployeeNo]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_tblTeacherProfileLabels]
--Table creation code:
Table created before

Note: Ignore [InAccurate_Flag],[ExpirationDate] for the mapping


--EST_To update EISID when NULL
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
UPDATE [ISS_tblTeacherProfileLabels]
SET sEISID='NA'
WHERE sEISID IS NULL AND nComponentID IN (82,24,17)

--EST_To update InAccurate_Flag and ExpirationDate
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
UPDATE TPL 
SET TPL.[InAccurate_Flag] = TPLS.[InAccurate_Flag], 
TPL.[ExpirationDate]=TPLS.[ExpirationDate]
FROM  [ISS_tblTeacherProfileLabels] TPL
INNER JOIN [ISS_tblTeacherProfileLabels_Staging] TPLS
ON TPL.[sEmployeeNo] = TPLS.[sEmployeeNo] AND TPL.[nComponentID]=TPLS.[nComponentID]


--EST_Delete records from Staging Tables
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
--Delete
DELETE FROM  [dbo].[ISS_tblTeacherProfileLabels_Staging]
GO
DELETE FROM  [dbo].[OSWP_tblOSWPStaff_Staging]
GO


--Variables for this Package:

Name			Scope								Data type			Value
PackageID		Package 13_OSWPAutolabel			Int32				13


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
VALUES (13,'Package 13_OSWPAutolabel')


