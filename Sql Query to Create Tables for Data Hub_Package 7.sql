--DFT_SWHUB_MTI_TRNS_Report
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view
--Name of the table or the view: [SWHUB_MTI Report]
--Table creation code:
Table will be created later

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_MTI_TRNS_Report]
--Table creation code:
IF OBJECT_ID('[SWHUB_MTI_TRNS_Report]') IS NOT NULL
	DROP TABLE SWHUB_MTI_TRNS_Report
CREATE TABLE SWHUB_MTI_TRNS_Report (
	[nSchoolYear] [int] NOT NULL,
	[sSchoolMonth] [nvarchar](15) NOT NULL,
	[nProgramID] [int] NULL,
	[sProgramName] [varchar](100) NULL,
	[sSchoolDBN] [varchar](6) NOT NULL,
	[sAdministrative District Code] [varchar](2) NULL,
	[sLocation Name] [varchar](100) NULL,
	[sLocation Category Description] [varchar](35) NULL,
	[sGrades Served] [varchar](45) NULL,
	[# of MTI Eligible Teachers] [int] NULL,
	[85% of MTI Eligible Teachers] [int] NULL,
	[# of Teachers Needed to Reach 85%] [int] NULL,
	[MTI TTT] [int] NULL,
	[% MTI TTT] [float] NULL,
	[MTI PE Teacher Led] [int] NULL,
	[% MTI PE Teacher Led] [float] NULL,
	[MTI K-5] [int] NULL,
	[% MTI K-5] [float] NULL,
	[Combined MTI Trained] [int] NULL,
	[% Combined MTI] [float] NULL,
	[# of License PE Teachers] [int] NULL,
	[sMTI_Program_Status] [varchar](100) NULL,
	[# of Teachers MTI Trained (STARS)] [int] NULL,
	[# of Classes as MTI (STARS)] [int] NULL,
	[Avg Min entered in (STARS)] [int] NULL,
	[# of Dedicated PE Teachers_3 or More PE Courses (STARS)] [int] NULL,
	[Total Students Enrolled] [int] NULL,
	[# Enrolled in Grade PK] [int] NULL,
	[# Enrolled in Grade K] [int] NULL,
	[# Enrolled in Grade 1] [int] NULL,
	[# Enrolled in Grade 2] [int] NULL,
	[# Enrolled in Grade 3] [int] NULL,
	[# Enrolled in Grade 4] [int] NULL,
	[# Enrolled in Grade 5] [int] NULL,
	[# Enrolled in Grade 6] [int] NULL,
	[# Enrolled in Grade 7] [int] NULL,
	[# Enrolled in Grade 8] [int] NULL,
	[# Enrolled in Grade 9] [int] NULL,
	[# Enrolled in Grade 10] [int] NULL,
	[# Enrolled in Grade 11] [int] NULL,
	[# Enrolled in Grade 12] [int] NULL,
	[sPE_Cohort_Name] [varchar](100) NULL,
	[DataPulledDate] [datetime] NULL,
	[All_Star_Date] [datetime] NULL,
	[sTTT_Teachers] [nvarchar](500) NULL,
	[# of Untrained MTI Eligible Teachers] int null, 
	[sPreviousAllStar] CHAR(3) NULL,
	[sPreviousAllStarSchoolYears] VARCHAR(100) NULL,
	CONSTRAINT [PK_SWHUB_MTI_TRNS_Report] PRIMARY KEY CLUSTERED 
(
	[nSchoolYear] ASC,
	[sSchoolMonth] ASC,
	[sSchoolDBN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]





--EST_Delete records from destination tables
Connection: ES11VDEXTESQL01 FGR_INT FGRepUser
SQL Statement:
TRUNCATE TABLE [SWHUB_MTI_Eligible_Teachers]
GO
TRUNCATE TABLE [SWHUB_MTI_TrainTheTeachers_TTT]
GO
TRUNCATE TABLE [SWHUB_MTI Report]
GO

--DFT_SWHUB_MTI_Eligible_Teachers
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:

--For MTI Eligible Teachers
SELECT DISTINCT
	e.[sSchoolDBN],
	e.[sEmployeeNo],
	e.[sEISId],
	e.[sEmail],
	e.[sLastName],
	e.[sFirstName],
	e.[sEmpStatus_HR],
	e.[sIsActive_AD],
	e.[sTitleCode_Gxy],
	e.[sTitleDesc_Gxy],
	e.[sIs_Primary_Location],
	e.[sCentral_Inst_Flag],
	e.[sLicenceCode_Primary],
	e.[sLicenceDesc_Primary],
	e.[sAPE_Teacher_Flag],
	e.[sAssignment_Desc],
	e.[sLocation_Category_Description],
	e.[sGrades_Text],
	e.[sTeaching_PK_or_6andAboveGrade_STARS],
	e.[sMTI_Trained],
	e.[MTI K-5],
	e.[MTI TTT],
	e.[MTI PE Teacher Led],
	GETDATE() AS [DataPulledDate] 
FROM (
SELECT a.*,c.Assignment_Desc AS [sAssignment_Desc],b.Location_Category_Description AS [sLocation_Category_Description],b.Grades_Text AS [sGrades_Text],
CASE WHEN d.[sTeaching_PK_or_6andAboveGrade_STARS]='Y' THEN 'Y'
WHEN d.[sTeaching_PK_or_6andAboveGrade_STARS]='N' THEN 'N'
ELSE 'Not exist in STARS' END AS [sTeaching_PK_or_6andAboveGrade_STARS],
CASE WHEN mt.EISID IS NOT NULL THEN 'Y' ELSE 'N' END AS [sMTI_Trained],
mt.[MTI K-5],mt.[MTI TTT],mt.[MTI PE Teacher Led] 
FROM 
(SELECT DISTINCT 
	[EmployeeNo] AS [sEmployeeNo],
	[EISId] AS [sEISId],
	[Email] AS [sEmail],
	[LastName] AS [sLastName],
	[FirstName] AS [sFirstName],
	[EmpStatus_HR] AS [sEmpStatus_HR],
	[IsActive_AD] AS [sIsActive_AD],
	[TitleCode_Gxy] AS [sTitleCode_Gxy],
	[TitleDesc_Gxy] AS [sTitleDesc_Gxy],
	[Is_Primary_Location] AS [sIs_Primary_Location],
	[Central_Inst_Flag] AS [sCentral_Inst_Flag],
	[SchoolDBN] AS [sSchoolDBN],
	[LicenceCode_Primary] AS [sLicenceCode_Primary],
	[LicenceDesc_Primary] AS [sLicenceDesc_Primary],
	[APE_Teacher_Flag] AS [sAPE_Teacher_Flag]
FROM [dbo].[SWHUB_ISS_PersonalInfo] 
WHERE 
	[TitleDesc_Gxy] = 'TEACHER' 
OR  [TitleDesc_Gxy] = 'TEACHER - ADAPTIVE PHYS ED (LINE 3101)'
OR  [TitleDesc_Gxy] = 'TEACHER - BILINGUAL' 
OR  [TitleDesc_Gxy] = 'TEACHER - LEAD SPECIAL ED' 
OR  [TitleDesc_Gxy] = 'TEACHER - LEAD TEACHER' 
OR  [TitleDesc_Gxy] = 'TEACHER - REGULAR GRADES' 
OR  [TitleDesc_Gxy] = 'TEACHER - REGULAR GRADES (LINE 3101 DIST 97)' 
OR  [TitleDesc_Gxy] = 'TEACHER - REGULAR GRADES - ESL' 
OR  [TitleDesc_Gxy] = 'TEACHER - SPECIAL ED (LINE 3101)' 
OR  [TitleDesc_Gxy] = 'TEACHER – MODEL' 
OR  [TitleDesc_Gxy] = 'TEACHER SPECIAL EDUCATION'
)a
INNER JOIN 
(SELECT DISTINCT
	System_Code,
	Location_Category_Description,
	Grades_Text 
FROM  [dbo].[SWHUB_Supertable_Schools Dimension]
WHERE Location_Category_Description NOT IN ('District Pre-K Center','Secondary School','Junior High-Intermediate-Middle','High school') 
) b
ON a.[sSchoolDBN]=b.System_Code
LEFT JOIN [SWHUB_ISS_PersonalInfo] c ON a.sEmployeeNo=c.EmployeeNo
LEFT JOIN (SELECT DISTINCT *,CASE WHEN 
	Grade_0K IS NULL 
AND Grade_01 IS NULL
AND Grade_02 IS NULL 
AND Grade_03 IS NULL 
AND Grade_04 IS NULL 
AND Grade_05 IS NULL
AND GradesServed<>'06,' THEN 'Y' ELSE 'N' END AS [sTeaching_PK_or_6andAboveGrade_STARS] --Note that if only teaching in grade 6 that considered as N means they are eligible
FROM SWHUB_STARS_ListOfTeachers_ByGradesServing 
) d ON a.sEmployeeNo=d.DOE_EmployeeID AND a.[sSchoolDBN]=d.[SchoolDBN]
LEFT JOIN (SELECT DISTINCT EISID,[MTI K-5],[MTI TTT],[MTI PE Teacher Led] FROM 
(SELECT DISTINCT EISID,ComponentName,CASE WHEN EISID IS NOT NULL THEN 'Y' ELSE 'N' END AS [sMTI_Trained] 
FROM [dbo].[SWHUB_ISS_TeacherProfileLabels] WHERE [ComponentID] in( 33,46,47) AND Is_Active='Y'
)z
PIVOT
(MAX([sMTI_Trained])
FOR ComponentName IN ([MTI K-5],[MTI TTT],[MTI PE Teacher Led])
) AS PivotedTable
) mt ON a.sEISID=mt.EISID
) e
WHERE e.sAssignment_Desc NOT IN (
'Pre Kindergarten Teacher',
'SPEECH LANGUAGE PATHOLOGIST TE',     
'FINE ARTS',                          
'SPEECH IMPROVEMENT',                 
'VOCAL MUSIC',                        
'TEACHER OF LIBRARY',                 
'PERF THEATRE ARTS - DRAMA',          
'MUSIC',                              
'PEER COLLABORATIVE TEACHER',         
'ORCHESTRAL MUSIC',                   
'COMPUTER TECHNOLOGY',                
'LEARNING SPECIALIST',                
'LIBRARY',                            
'INTERVENTION PREVENTION',            
'BIL CB SUBJECTS (MANDARIN)',         
'ENRICHMENT',                         
'BILINGUAL ECC CHINESE MANDARIN',     
'GEN SCIENCE HS SPC',                 
'DEAN',                               
'LITERACY COACH',                     
'SWD SOCIAL STUDIES',                 
'TECHNOLOGY EDUCATION',               
'BILINGUAL EC FRENCH',                
'BIL SPEECH IMPROVEMENT SPANISH',     
'HUMANITIES',                         
'COACH-SPECIAL EDUCATION',            
'STAFF DEVELOP TO GENER GRADES',      
'GENERAL SCIENCE HS',                 
'BIOLOGY AND GENERAL SCIENCE',        
'BIL COMMON BRANCHES FRENCH',         
'EARTH SCIENCE AND GEN SCIENCE',      
'EARLY INTERVENTION',                 
'CONFLICT RESOLUTION',                
'BIL SPEECH PATHOLOGIST SPANISH',     
'SWD GENERAL SCIENCE',                
'MATH COACH',                         
'BIL SPECIAL EDUCATION YIDDISH',      
'BIL FINE ARTS SPANISH DAY SCHL',     
'BIL EARLY CHILDHOOD RUSSIAN',        
'WORK STUDY',                         
'MULTIPLE ASSIGNMENTS FOUND',         
'BIL COMM BRANCHES SUB RUSSIAN',      
'SWD BIOLOGY',                        
'PROGRAM SPECIALIST',                 
'PHYSICS AND GENERAL SCIENCE',        
'FRENCH',                             
'COORDINATOR - LITERACY',             
'CHINESE',                            
'CHEMISTRY AND GENERAL SCIENCE',      
'BILINGUAL MATHEMATICS SPANISH',      
'BIL COMMON BRANCHES KOREAN',         
'BIL COMMON BRANCHES CANTONESE',      
'BIL CB AMERICAN SIGN LANGUAGE',      
'PERFORMING ARTS DANCE MODERN',       
'ORGANIZATIONAL STUDY SKILLS',        
'MENTOR - REGULAR ED',                
'MASTER TEACHER',                     
'ITALIAN',                            
'FL - ALL OTHER',                     
'CRISIS INTERVENTION TEACHER',        
'CONSULTANT TEACHER',                 
'BIL SOCIAL STUDIES SPANISH',         
'BIL GENERAL SCIENCE SPANISH',        
'BIL ECC CHINESE CANTONESE',          
'WORK',                               
'SWD SPANISH',                        
'SPECIAL INSTRUCT ENVIRONMENT 3',     
'RECREATION EXTRACURRICULAR',         
'DEAF AND HARD OF HEARING',           
'BILINGUAL SPECIAL ED MANDARIN',      
'BILINGUAL LIBRARY SPANISH',          
'BILINGUAL ECC HAITIAN CREOLE',       
'BIL SPEECH PATHOLOGIST RUSSIAN',     
'BIL SPEECH PATHOLOGIST MANDARI',     
'BIL SPECIAL EDUCATION HEBREW',       
'BIL SPECIAL EDUCATION FRENCH',       
'BIL SPECIAL EDUCATION CANTONE',      
'BIL SPECIAL EDUCATION ARABIC',       
'BIL SPECIAL ED AMER SIGN LANG',      
'BIL SPCH IMPROVEMENT CANTON',        
'BIL SOCIAL STUDIES HAIT CREOL',      
'BIL MUSIC MANDARIN DAY SCHL',        
'BIL EARLY CHILDHOOD CL KOREAN',      
'BIL DANCE MANDARIN DAY SCHL',        
'BIL COMMON BRANCHES ITALIAN',        
'BIL COMMON BRANCHES HAIT CRE',       
'BIL COMMON BRANCHES DUTCH',          
'AMERICAN SIGN LANGUAGE'             
 ) 
AND e.[sTeaching_PK_or_6andAboveGrade_STARS]<>'Y' 

UNION
--Below part is for to get the MTI train the trainer (TTT) who has not to fall in the eligible criteria. 

SELECT DISTINCT
	e.[sSchoolDBN],
	e.[sEmployeeNo],
	e.[sEISId],
	e.[sEmail],
	e.[sLastName],
	e.[sFirstName],
	e.[sEmpStatus_HR],
	e.[sIsActive_AD],
	e.[sTitleCode_Gxy],
	e.[sTitleDesc_Gxy],
	e.[sIs_Primary_Location],
	e.[sCentral_Inst_Flag],
	e.[sLicenceCode_Primary],
	e.[sLicenceDesc_Primary],
	e.[sAPE_Teacher_Flag],
	e.[sAssignment_Desc],
	e.[sLocation_Category_Description],
	e.[sGrades_Text],
	e.[sTeaching_PK_or_6andAboveGrade_STARS],
	e.[sMTI_Trained],
	e.[MTI K-5],
	e.[MTI TTT],
	e.[MTI PE Teacher Led],
	GETDATE() AS [DataPulledDate] 
FROM (
SELECT a.*,c.Assignment_Desc AS [sAssignment_Desc],b.Location_Category_Description AS [sLocation_Category_Description],b.Grades_Text AS [sGrades_Text],
CASE WHEN d.[sTeaching_PK_or_6andAboveGrade_STARS]='Y' THEN 'Y'
WHEN d.[sTeaching_PK_or_6andAboveGrade_STARS]='N' THEN 'N'
ELSE 'Not exist in STARS' END AS [sTeaching_PK_or_6andAboveGrade_STARS],
CASE WHEN mt.EISID IS NOT NULL THEN 'Y' ELSE 'N' END AS [sMTI_Trained],
mt.[MTI K-5],mt.[MTI TTT],mt.[MTI PE Teacher Led] 
FROM 
(SELECT DISTINCT 
	[EmployeeNo] AS [sEmployeeNo],
	[EISId] AS [sEISId],
	[Email] AS [sEmail],
	[LastName] AS [sLastName],
	[FirstName] AS [sFirstName],
	[EmpStatus_HR] AS [sEmpStatus_HR],
	[IsActive_AD] AS [sIsActive_AD],
	[TitleCode_Gxy] AS [sTitleCode_Gxy],
	[TitleDesc_Gxy] AS [sTitleDesc_Gxy],
	[Is_Primary_Location] AS [sIs_Primary_Location],
	[Central_Inst_Flag] AS [sCentral_Inst_Flag],
	[SchoolDBN] AS [sSchoolDBN],
	[LicenceCode_Primary] AS [sLicenceCode_Primary],
	[LicenceDesc_Primary] AS [sLicenceDesc_Primary],
	[APE_Teacher_Flag] AS [sAPE_Teacher_Flag]
FROM [dbo].[SWHUB_ISS_PersonalInfo] 
WHERE [EmployeeNo] IN (SELECT DISTINCT EmployeeNo FROM [dbo].[SWHUB_ISS_TeacherProfileLabels] WHERE ComponentID=46 AND EmployeeNo IS NOT NULL)
)a
INNER JOIN 
(SELECT DISTINCT
	System_Code,
	Location_Category_Description,
	Grades_Text 
FROM  [dbo].[SWHUB_Supertable_Schools Dimension]
WHERE Location_Category_Description NOT IN ('District Pre-K Center','Secondary School','Junior High-Intermediate-Middle','High school') 
) b
ON a.[sSchoolDBN]=b.System_Code
LEFT JOIN [SWHUB_ISS_PersonalInfo] c ON a.sEmployeeNo=c.EmployeeNo
LEFT JOIN (SELECT DISTINCT *,CASE WHEN 
	Grade_0K IS NULL 
AND Grade_01 IS NULL
AND Grade_02 IS NULL 
AND Grade_03 IS NULL 
AND Grade_04 IS NULL 
AND Grade_05 IS NULL
AND GradesServed<>'06,' THEN 'Y' ELSE 'N' END AS [sTeaching_PK_or_6andAboveGrade_STARS] --Note that if only teaching in grade 6 that considered as N means they are eligible
FROM SWHUB_STARS_ListOfTeachers_ByGradesServing 
) d ON a.sEmployeeNo=d.DOE_EmployeeID AND a.[sSchoolDBN]=d.[SchoolDBN]
LEFT JOIN (SELECT DISTINCT EISID,[MTI K-5],[MTI TTT],[MTI PE Teacher Led] FROM 
(SELECT DISTINCT EISID,ComponentName,CASE WHEN EISID IS NOT NULL THEN 'Y' ELSE 'N' END AS [sMTI_Trained] 
FROM [dbo].[SWHUB_ISS_TeacherProfileLabels] WHERE [ComponentID] in( 33,46,47) AND Is_Active='Y'
)z
PIVOT
(MAX([sMTI_Trained])
FOR ComponentName IN ([MTI K-5],[MTI TTT],[MTI PE Teacher Led])
) AS PivotedTable
) mt ON a.sEISID=mt.EISID
) e

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_MTI_Eligible_Teachers]
--Table creation code:

--USE FGR_INT
--DELETE FROM [SWHUB_MTI_Eligible_Teachers]
--GO

--DELETE FROM [SWHUB_MTI Report_Archive]
--WHERE nSchoolYear=(SELECT DISTINCT MAX(nSchoolYear) FROM [SWHUB_MTI Report]) AND sSchoolMonth=(SELECT DISTINCT sSchoolMonth FROM [SWHUB_MTI Report]) 
--GO

--DELETE FROM [SWHUB_MTI Report]
--GO


USE FGR_INT
IF OBJECT_ID('[SWHUB_MTI_Eligible_Teachers]') IS NOT NULL
	DROP TABLE [SWHUB_MTI_Eligible_Teachers]
CREATE TABLE [SWHUB_MTI_Eligible_Teachers](
	[sSchoolDBN] [char](6) NULL,
	[sEmployeeNo] [varchar](20) NOT NULL,
	[sEISId] [char](7) NULL,
	[sEmail] [varchar](100) NULL,
	[sLastName] [varchar](100) NULL,
	[sFirstName] [varchar](100) NULL,
	[sIsActive_AD] [char](1) NULL,
	[sEmpStatus_HR] [char](1) NULL,
	[sTitleCode_Gxy] [char](5) NULL,
	[sTitleDesc_Gxy] [varchar](100) NULL,
	[sIs_Primary_Location] [char](1) NULL,
	[sCentral_Inst_Flag] [char](1) NULL,
	[sLicenceCode_Primary] [varchar](10) NULL,
	[sLicenceDesc_Primary] [varchar](150) NULL,
	[sAPE_Teacher_Flag] [char](1) NULL,
	[sAssignment_Desc] [varchar](300) NULL,
	[sLocation_Category_Description] [varchar](35) NULL,
	[sGrades_Text] [varchar](45) NULL,
	[sTeaching_PK_or_6andAboveGrade_STARS] [char](1) NULL,
	[sMTI_Trained] [char](1) NULL,
	[MTI K-5] [char](1) NULL,
	[MTI TTT] [char](1) NULL,
	[MTI PE Teacher Led] [char](1) NULL,
	[DataPulledDate] [datetime] NULL,	
	)

--DFT_SWHUB_MTI_TrainTheTeachers_TTT
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
--- FOR MTI TTT Trained Teachers
With Cte([sSchoolDBN],cConcat) AS 
(SELECT [sSchoolDBN],
(SELECT a.[TTT Trained Teacher]+',' from 
(SELECT [sSchoolDBN],RTRIM(LTRIM(Names)) AS [TTT Trained Teacher] FROM (
SELECT DISTINCT [sSchoolDBN],sEmployeeNo,sEISId,
 (UPPER(LEFT(sFirstName, 1)) + LOWER(RIGHT(sFirstName, LEN(sFirstName) - 1)) 
 +' '+ 
  UPPER(LEFT(sLastName, 1)) + LOWER(RIGHT(sLastName, LEN(sLastName) - 1))
 ) AS Names,
[MTI TTT] FROM [SWHUB_MTI_Eligible_Teachers] WHERE [MTI TTT]='Y'
)aa)
AS a    
WHERE a.[sSchoolDBN]=b.[sSchoolDBN]     for XML PATH ('') ) cconcat FROM 
(SELECT [sSchoolDBN],RTRIM(LTRIM(Names)) AS [TTT Trained Teacher] FROM (
SELECT DISTINCT [sSchoolDBN],sEmployeeNo,sEISId,
 (UPPER(LEFT(sFirstName, 1)) + LOWER(RIGHT(sFirstName, LEN(sFirstName) - 1)) 
 +' '+ 
  UPPER(LEFT(sLastName, 1)) + LOWER(RIGHT(sLastName, LEN(sLastName) - 1))
 ) AS Names,
[MTI TTT] FROM [SWHUB_MTI_Eligible_Teachers] WHERE [MTI TTT]='Y'
		)bb) AS b  
GROUP BY [sSchoolDBN]) 

SELECT [sSchoolDBN],left(cConcat, len(cConcat) -1)AS [sTTT_Teachers] 
FROM cte 
ORDER BY [sSchoolDBN]

--Data Conversion:
Input Column		Output Alias				Data Type					Length
sTTT_Teachers		sTTT_Teachers_Convert		Unicode string [DT_WSTR]	500

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_MTI_TrainTheTeachers_TTT]
--Table creation code:
CREATE TABLE [dbo].[SWHUB_MTI_TrainTheTeachers_TTT](
	[sSchoolDBN] [varchar](6) NOT NULL,
	[sTTT_Teachers] [nvarchar](500) NULL
) ON [PRIMARY]
GO

--DFT_SWHUB_MTI_PreviousAllStar
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
--Previous All-Star years: it will pull only prior 3 years data except current year
With Cte([sSchoolDBN],cConcat) as 
(SELECT [sSchoolDBN],
(SELECT a.[SchoolYear]+ ', ' from 
(SELECT DISTINCT CONVERT(VARCHAR(4),[nSchoolYear])+'-'+SUBSTRING(CONVERT(VARCHAR(4),[nSchoolYear]+1),3,2)  AS  SchoolYear, RTRIM(LTRIM([sSchoolDBN])) AS [sSchoolDBN]
FROM [SWHUB_MTI Report_Archive] 
WHERE [sMTI_Program_Status]='All-Star' AND 
[nSchoolYear]>= (CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END)-3 AND
[nSchoolYear]<CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END 
AND sSchoolMonth='June'  		)
AS a    
WHERE a.[sSchoolDBN]=b.[sSchoolDBN]     for XML PATH ('') ) cconcat FROM 
(SELECT DISTINCT CONVERT(VARCHAR(4),[nSchoolYear])+'-'+SUBSTRING(CONVERT(VARCHAR(4),[nSchoolYear]+1),3,2)  AS  SchoolYear, RTRIM(LTRIM([sSchoolDBN])) AS [sSchoolDBN]
FROM [SWHUB_MTI Report_Archive] 
WHERE [sMTI_Program_Status]='All-Star' AND 
[nSchoolYear]>= (CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END)-3 AND
[nSchoolYear]<CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END 
AND sSchoolMonth='June'  		) AS b  
GROUP BY [sSchoolDBN]) 
SELECT [sSchoolDBN], CONVERT( VARCHAR (100),left(cConcat, len(cConcat) -1) ) AS [sSchoolYears] 
--INTO ##PreviousAllStar
FROM cte 
ORDER BY [sSchoolDBN]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_MTI_PreviousAllStar]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[SWHUB_MTI_PreviousAllStar]]') IS NOT NULL
	DROP TABLE [SWHUB_MTI_PreviousAllStar]
CREATE TABLE [SWHUB_MTI_PreviousAllStar] 
		(
       [sSchoolDBN] varchar(6) NOT NULL,
	   [sPreviousAllStarSchoolYears] varchar(100) NULL
	    )

--DFT_SWHUB_MTI Report
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
--For MTI Report
USE FGR_INT
DECLARE @SY INT; 
SET @SY = CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END; 
SELECT 
nn.[nSchoolYear]
,nn.[sSchoolMonth]
,nn.[nProgramID]
,nn.[sProgramName]
,nn.[sSchoolDBN]
,nn.[sAdministrative District Code]
,nn.[sLocation Name]
,nn.[sLocation Category Description]
,nn.[sGrades Served]
,nn.[# of MTI Eligible Teachers]
,nn.[85% of MTI Eligible Teachers]
,nn.[# of Teachers Needed to Reach 85%]
,nn.[# of Untrained MTI Eligible Teachers]
,nn.[MTI TTT]
,nn.[sTTT_Teachers]
,nn.[% MTI TTT]
,nn.[MTI PE Teacher Led]
,nn.[% MTI PE Teacher Led]
,nn.[MTI K-5]
,nn.[% MTI K-5]
,nn.[Combined MTI Trained]
,nn.[% Combined MTI]
,nn.[# of License PE Teachers]
,nn.[sMTI_Program_Status]
,nn.[# of Teachers MTI Trained (STARS)]
,nn.[# of Classes as MTI (STARS)]
,nn.[Avg Min entered in (STARS)]
,nn.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]
,nn.[Total Students Enrolled]
,nn.[# Enrolled in Grade PK]
,nn.[# Enrolled in Grade K]
,nn.[# Enrolled in Grade 1]
,nn.[# Enrolled in Grade 2]
,nn.[# Enrolled in Grade 3]
,nn.[# Enrolled in Grade 4]
,nn.[# Enrolled in Grade 5]
,nn.[# Enrolled in Grade 6]
,nn.[# Enrolled in Grade 7]
,nn.[# Enrolled in Grade 8]
,nn.[# Enrolled in Grade 9]
,nn.[# Enrolled in Grade 10]
,nn.[# Enrolled in Grade 11]
,nn.[# Enrolled in Grade 12]
,nn.[sPE_Cohort_Name]
,[DataPulledDate]
,[All_Star_Date]=CASE WHEN nn.[sMTI_Program_Status]='All-Star' AND nn.[All_Star_Date] IS NULL THEN GETDATE() ELSE nn.[All_Star_Date] END,
CASE WHEN pals.[sPreviousAllStarSchoolYears] IS NOT NULL THEN 'Yes' ELSE '' END AS [PreviousAllStar],
pals.[sPreviousAllStarSchoolYears] 
FROM (
SELECT mm.*,
CASE   WHEN (mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN) AND (ms.[sMTI_Program_Status] IS NULL OR ms.[sMTI_Program_Status]='') AND mm.[% Combined MTI]>=85 AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]>=1 AND DATENAME(MONTH,GETDATE()) IN ('July','August','September','October','November','December','January') THEN 'All-Star' 
              WHEN (mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN) AND (ms.[sMTI_Program_Status] IS NULL OR ms.[sMTI_Program_Status]='') AND mm.[% Combined MTI]>=85 AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]>=1 AND DATENAME(MONTH,GETDATE()) IN ('February','March','April','May','June') THEN 'Eligible'
              WHEN (mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN) AND ms.[sMTI_Program_Status]='All-Star' AND mm.[% Combined MTI]>= 85 AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]>=1  THEN 'All-Star'
              WHEN (mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN) AND ms.[sMTI_Program_Status]='Eligible' AND mm.[% Combined MTI]>= 85 AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]>=1 THEN 'Eligible'

              WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star' AND mm.[% Combined MTI]< 85 AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]<=1 THEN 'All-Star: Needs Review'
              WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star' AND mm.[% Combined MTI]< 85 AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]>=1 THEN 'All-Star: Needs Review'
              WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star' AND mm.[% Combined MTI]>= 85 AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]<1 THEN 'All-Star: Needs Review' --change
              WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star' AND mm.[% Combined MTI]< 85 AND (mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)] IS NULL OR mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]='') THEN 'All-Star: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star' AND mm.[% Combined MTI]>= 85 AND (mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)] IS NULL OR mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]='') THEN 'All-Star: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star' AND mm.[% Combined MTI] IS NULL AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)] IS NULL THEN 'All-Star: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star' AND mm.[% Combined MTI]='' AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]='' THEN 'All-Star: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star' AND mm.[% Combined MTI] IS NULL AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]>=1 THEN 'All-Star: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star' AND mm.[% Combined MTI]='' AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]>=1 THEN 'All-Star: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star' AND mm.[% Combined MTI] IS NULL AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]<=1 THEN 'All-Star: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star' AND mm.[% Combined MTI]='' AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]<=1 THEN 'All-Star: Needs Review'
              
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star: Needs Review' AND mm.[% Combined MTI]< 85 AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]<=1 THEN 'All-Star: Needs Review'
              WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star: Needs Review' AND mm.[% Combined MTI]< 85 AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]>=1 THEN 'All-Star: Needs Review'
              WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star: Needs Review' AND mm.[% Combined MTI]>= 85 AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]<1 THEN 'All-Star: Needs Review'--change
              WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star: Needs Review' AND mm.[% Combined MTI]< 85 AND (mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)] IS NULL OR mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]='') THEN 'All-Star: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star: Needs Review' AND mm.[% Combined MTI]>= 85 AND (mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)] IS NULL OR mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]='') THEN 'All-Star: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star: Needs Review' AND mm.[% Combined MTI] IS NULL AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)] IS NULL THEN 'All-Star: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star: Needs Review' AND mm.[% Combined MTI]='' AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]='' THEN 'All-Star: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star: Needs Review' AND mm.[% Combined MTI] IS NULL AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]>=1 THEN 'All-Star: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star: Needs Review' AND mm.[% Combined MTI]='' AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]>=1 THEN 'All-Star: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star: Needs Review' AND mm.[% Combined MTI] IS NULL AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]<=1 THEN 'All-Star: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star: Needs Review' AND mm.[% Combined MTI]='' AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]<=1 THEN 'All-Star: Needs Review'

			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='All-Star: Needs Review' AND mm.[% Combined MTI]>= 85 AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]>=1  THEN 'All-Star'

			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible' AND mm.[% Combined MTI]< 85 AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]<=1 THEN 'Eligible: Needs Review'
              WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible' AND mm.[% Combined MTI]< 85 AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]>=1 THEN 'Eligible: Needs Review'
              WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible' AND mm.[% Combined MTI]>= 85 AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]<1 THEN 'Eligible: Needs Review' --change
              WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible' AND mm.[% Combined MTI]< 85 AND (mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)] IS NULL OR mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]='') THEN 'Eligible: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible' AND mm.[% Combined MTI]>= 85 AND (mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)] IS NULL OR mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]='') THEN 'Eligible: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible' AND mm.[% Combined MTI] IS NULL AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)] IS NULL THEN 'Eligible: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible' AND mm.[% Combined MTI]='' AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]='' THEN 'Eligible: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible' AND mm.[% Combined MTI] IS NULL AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]>=1 THEN 'Eligible: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible' AND mm.[% Combined MTI]='' AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]>=1 THEN 'Eligible: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible' AND mm.[% Combined MTI] IS NULL AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]<=1 THEN 'Eligible: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible' AND mm.[% Combined MTI]='' AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]<=1 THEN 'Eligible: Needs Review'

			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible: Needs Review' AND mm.[% Combined MTI]< 85 AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]<=1 THEN 'Eligible: Needs Review'
              WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible: Needs Review' AND mm.[% Combined MTI]< 85 AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]>=1 THEN 'Eligible: Needs Review'
              WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible: Needs Review' AND mm.[% Combined MTI]>= 85 AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]<1 THEN 'Eligible: Needs Review' --change
              WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible: Needs Review' AND mm.[% Combined MTI]< 85 AND (mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)] IS NULL OR mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]='') THEN 'Eligible: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible: Needs Review' AND mm.[% Combined MTI]>= 85 AND (mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)] IS NULL OR mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]='') THEN 'Eligible: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible: Needs Review' AND mm.[% Combined MTI] IS NULL AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)] IS NULL THEN 'Eligible: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible: Needs Review' AND mm.[% Combined MTI]='' AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]='' THEN 'Eligible: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible: Needs Review' AND mm.[% Combined MTI] IS NULL AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]>=1 THEN 'Eligible: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible: Needs Review' AND mm.[% Combined MTI]='' AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]>=1 THEN 'Eligible: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible: Needs Review' AND mm.[% Combined MTI] IS NULL AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]<=1 THEN 'Eligible: Needs Review'
			  WHEN mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN AND ms.[sMTI_Program_Status]='Eligible: Needs Review' AND mm.[% Combined MTI]='' AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]<=1 THEN 'Eligible: Needs Review'

			  WHEN (mm.nSchoolYear=ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN ) AND ms.[sMTI_Program_Status]='Eligible: Needs Review' AND mm.[% Combined MTI]>= 85 AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]>=1 THEN 'Eligible'

              WHEN (mm.nSchoolYear<>ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN) AND mm.[% Combined MTI]>=85 AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]>=1 AND DATENAME(MONTH,GETDATE()) IN ('July','August','September','October','November','December','January') THEN 'All-Star' 
              WHEN (mm.nSchoolYear<>ms.nSchoolYear AND mm.sSchoolDBN=ms.sSchoolDBN) AND mm.[% Combined MTI]>=85 AND mm.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)]>=1  AND DATENAME(MONTH,GETDATE()) IN ('February','March','April','May','June') THEN 'Eligible'
ELSE '' 
END AS [sMTI_Program_Status]

,[All_Star_Date]
FROM (
SELECT @SY AS nSchoolYear,
DATENAME(MONTH,GETDATE()) AS sSchoolMonth,
8 AS [nProgramID],
'Move to Improve (MTI)'AS [sProgramName],
a.[System_Code] AS [sSchoolDBN],
a.[Administrative_District_Code] AS [sAdministrative District Code],
a.[Location_Name] AS [sLocation Name],
a.[Location_Category_Description] AS [sLocation Category Description],
a.[Grades_Text] AS [sGrades Served],

ab.[Total_No_of_MTI_Eligible_Teachers] AS [# of MTI Eligible Teachers],

CEILING(ab.[Total_No_of_MTI_Eligible_Teachers] *0.85) AS [85% of MTI Eligible Teachers],

CASE WHEN g.[Combined MTI Trained] IS NOT NULL THEN 
(CEILING(ab.[Total_No_of_MTI_Eligible_Teachers]*0.85)-g.[Combined MTI Trained])
ELSE CEILING(ab.[Total_No_of_MTI_Eligible_Teachers]*0.85)
END AS [# of Teachers Needed to Reach 85%], 

CASE WHEN g.[Combined MTI Trained] IS NOT NULL THEN 
(CEILING(ab.[Total_No_of_MTI_Eligible_Teachers])-g.[Combined MTI Trained])
ELSE CEILING(ab.[Total_No_of_MTI_Eligible_Teachers])
END AS [# of Untrained MTI Eligible Teachers], 

e.[MTI TTT],
ttt.[sTTT_Teachers],
FLOOR(((CAST(e.[MTI TTT] AS Float)/CAST(ab.[Total_No_of_MTI_Eligible_Teachers] AS Float))*100)) AS [% MTI TTT],

f.[MTI PE Teacher Led],
FLOOR(((CAST(f.[MTI PE Teacher Led] AS Float)/CAST(ab.[Total_No_of_MTI_Eligible_Teachers] AS Float))*100)) AS [% MTI PE Teacher Led],

d.[MTI K-5],

FLOOR(((CAST(d.[MTI K-5] AS Float)/CAST(ab.[Total_No_of_MTI_Eligible_Teachers] AS Float))*100)) AS [% MTI K-5] ,  

g.[Combined MTI Trained],
FLOOR(((CAST(g.[Combined MTI Trained] AS Float)/CAST(ab.[Total_No_of_MTI_Eligible_Teachers] AS Float))*100))  AS [% Combined MTI],

h.[No of License PE Teacher] AS [# of License PE Teachers],

j.[# of Teachers MTI Trained (STARS)],
k.[# of Classes as MTI (STARS)],
k.[Avg Min entered in (STARS)],
l.[# of Dedicated PE Teachers_3 or More PE Courses (STARS)],

a.[Total_Students_Enrolled] AS [Total Students Enrolled],
a.[Enrolled_Grade_PK] AS [# Enrolled in Grade PK],
a.[Enrolled_Grade_K] AS [# Enrolled in Grade K],
a.[Enrolled_Grade_1] AS [# Enrolled in Grade 1],
a.[Enrolled_Grade_2] AS [# Enrolled in Grade 2],
a.[Enrolled_Grade_3] AS [# Enrolled in Grade 3],
a.[Enrolled_Grade_4] AS [# Enrolled in Grade 4],
a.[Enrolled_Grade_5] AS [# Enrolled in Grade 5],
a.[Enrolled_Grade_6] AS [# Enrolled in Grade 6],
a.[Enrolled_Grade_7] AS [# Enrolled in Grade 7],
a.[Enrolled_Grade_8] AS [# Enrolled in Grade 8],
a.[Enrolled_Grade_9] AS [# Enrolled in Grade 9],
a.[Enrolled_Grade_10] AS [# Enrolled in Grade 10],
a.[Enrolled_Grade_11] AS [# Enrolled in Grade 11],
a.[Enrolled_Grade_12] AS [# Enrolled in Grade 12],
a.[PE_Cohort_Name] AS [sPE_Cohort_Name],
GETDATE() AS [DataPulledDate]
FROM [dbo].[SWHUB_Supertable_Schools Dimension] (NOLOCK) a 

LEFT JOIN (
SELECT  aa.sSchoolDBN, COUNT(aa.sEmployeeNo) AS [Total_No_of_MTI_Eligible_Teachers] FROM [SWHUB_MTI_Eligible_Teachers] (NOLOCK) aa
GROUP BY aa.sSchoolDBN 
)ab ON a.[System_Code]=ab.sSchoolDBN  

LEFT JOIN (
SELECT  dd.sSchoolDBN, COUNT(dd.sEmployeeNo) AS [MTI K-5] FROM 
(SELECT DISTINCT [sSchoolDBN],sEmployeeNo,sEISId,sFirstName,sLastName,[MTI K-5] FROM [SWHUB_MTI_Eligible_Teachers] (NOLOCK) WHERE [MTI K-5]='Y') dd
GROUP BY dd.sSchoolDBN 
)d ON a.[System_Code]=d.sSchoolDBN

LEFT JOIN (
SELECT  ee.sSchoolDBN, COUNT(ee.sEmployeeNo) AS [MTI TTT] FROM 
(SELECT DISTINCT [sSchoolDBN],sEmployeeNo,sEISId,sFirstName,sLastName,[MTI TTT] FROM [SWHUB_MTI_Eligible_Teachers] (NOLOCK) WHERE [MTI TTT]='Y') ee
GROUP BY ee.sSchoolDBN 
)e ON a.[System_Code]=e.sSchoolDBN

LEFT JOIN (
SELECT DISTINCT [sSchoolDBN],[sTTT_Teachers] FROM [dbo].[SWHUB_MTI_TrainTheTeachers_TTT] (NOLOCK)
) ttt ON a.[System_Code]=ttt.[sSchoolDBN]

LEFT JOIN (
SELECT  ff.sSchoolDBN, COUNT(ff.sEmployeeNo) AS [MTI PE Teacher Led] FROM 
(SELECT DISTINCT [sSchoolDBN],sEmployeeNo,sEISId,sFirstName,sLastName,[MTI PE Teacher Led] FROM [SWHUB_MTI_Eligible_Teachers] (NOLOCK) WHERE [MTI PE Teacher Led]='Y') ff
GROUP BY ff.sSchoolDBN 
)f ON a.[System_Code]=f.sSchoolDBN

LEFT JOIN (
SELECT gg.sSchoolDBN, COUNT(gg.sEmployeeNo) AS [Combined MTI Trained] FROM 
(SELECT DISTINCT [sSchoolDBN],sEmployeeNo,sEISId,sFirstName,sLastName,[sMTI_Trained] FROM [SWHUB_MTI_Eligible_Teachers] (NOLOCK) WHERE [sMTI_Trained]='Y') gg
GROUP BY gg.sSchoolDBN 
)g ON a.[System_Code]=g.sSchoolDBN

LEFT JOIN (
SELECT hh.sSchoolDBN, COUNT(hh.sEmployeeNo) AS [No of License PE Teacher] FROM 
(SELECT DISTINCT [sSchoolDBN],sEmployeeNo,sEISId,sFirstName,sLastName,[sMTI_Trained] FROM [SWHUB_MTI_Eligible_Teachers] (NOLOCK)
WHERE  [sLicenceDesc_Primary] LIKE '%PHYSICAL%' OR [sLicenceDesc_Primary] LIKE '%SWIMM%' 
 )hh
GROUP BY hh.sSchoolDBN
) h  ON a.[System_Code]=h.sSchoolDBN

LEFT JOIN
(
SELECT  DISTINCT SchoolDBN,COUNT([Teacher_Email])AS [# of Teachers MTI Trained (STARS)] FROM (
SELECT DISTINCT SchoolDBN,[Teacher_Email] FROM [dbo].[SWHUB_STARS_FACT_Scheduling_ByStudentAndTeacher] (NOLOCK)
WHERE IsMTI='Y' AND [Teacher_Email] IS NOT NULL AND [Teacher_Email]<>'<Unavailable>' AND SchoolYear = @SY 
)ac
GROUP BY SchoolDBN
)j ON a.[System_Code]=j.SchoolDBN
LEFT JOIN
(
SELECT  distinct SchoolDBN,COUNT(OfficialClass)AS [# of Classes as MTI (STARS)],AVG([MTI MinPerWeek])AS [Avg Min entered in (STARS)]
FROM (
SELECT distinct SchoolDBN,[MTI MinPerWeek],IsMTI,OfficialClass FROM [dbo].[SWHUB_STARS_FACT_Scheduling_ByStudentAndTeacher] (NOLOCK)
WHERE IsMTI='Y' AND SchoolYear = @SY
)ad
GROUP BY SchoolDBN
)k ON a.[System_Code]=k.SchoolDBN

LEFT JOIN
(SELECT SchoolDBN, COUNT([DOE_EmployeeID]) AS [# of Dedicated PE Teachers_3 or More PE Courses (STARS)] 
FROM (
SELECT DISTINCT SchoolDBN,[Teacher_Email],[EisID],[DOE_EmployeeID] FROM 
(SELECT DISTINCT c.SchoolYear,c.SchoolDBN,c.[Teacher_Email],c.[EisID],c.[DOE_EmployeeID],COUNT(c.CourseCode) AS [ES - Total PE Courses (STARS)],
CASE WHEN  [Teacher_Email] IS NOT NULL THEN 'Yes' END AS 'ES - PE Teacher (STARS)',
CASE WHEN COUNT(CourseCode)>=3 THEN 'Yes' END AS 'ES - 3+ PE Courses (STARS)' 
FROM (
SELECT DISTINCT a.SchoolYear,a.SchoolDBN,a.[Teacher_Email],a.[EisID],a.[DOE_EmployeeID],a.[CourseCode] FROM [dbo].[SWHUB_STARS_FACT_Scheduling_ByStudentAndTeacher](NOLOCK) a
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
UNION
SELECT [SchoolDBN],[Email] AS [Teacher_Email],[EisID],[EmployeeNo] AS [DOE_EmployeeID] FROM [SWHUB_ISS_PersonalInfo] (NOLOCK)
WHERE [EmployeeNo] IN (SELECT DISTINCT [EmployeeNo] FROM [dbo].[SWHUB_ISS_TeacherProfileLabels] WHERE [ComponentID]=6) --These are manually addaded teachers who didn't exist in STARS schedule or didn't follow any criterias
	)e
GROUP BY e.SchoolDBN
)l ON a.[System_Code]=l.SchoolDBN
WHERE a.Location_Category_Description NOT IN ('District Pre-K Center','Secondary School','Junior High-Intermediate-Middle','High school') 
)mm
LEFT JOIN [dbo].[SWHUB_MTI_TRNS_Report] (NOLOCK) ms 
ON mm.[sSchoolDBN]=ms.[sSchoolDBN] 
)nn  
LEFT JOIN (SELECT * FROM SWHUB_MTI_PreviousAllStar) pals ON nn.[sSchoolDBN]=pals.[sSchoolDBN] 
ORDER BY nn.sSchoolDBN	



--Data Conversion:
Input Column			Output Alias					Data Type					Length
sSchool_Month			sSchool_Month_Convert			Unicode string [DT_WSTR]	15
sMTI_Program_Status		sMTI_Program_Status_Convert		string [DT_STR]				100

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_MTI Report]
--Table creation code:
IF OBJECT_ID('[SWHUB_MTI Report]') IS NOT NULL
	DROP TABLE [SWHUB_MTI Report]
CREATE TABLE [SWHUB_MTI Report] (
	[nSchoolYear] [int] NOT NULL,
	[sSchoolMonth] [nvarchar](15) NOT NULL,
	[nProgramID] [int] NULL,
	[sProgramName] [varchar](100) NULL,
	[sSchoolDBN] [varchar](6) NOT NULL,
	[sAdministrative District Code] [varchar](2) NULL,
	[sLocation Name] [varchar](100) NULL,
	[sLocation Category Description] [varchar](35) NULL,
	[sGrades Served] [varchar](45) NULL,
	[# of MTI Eligible Teachers] [int] NULL,
	[85% of MTI Eligible Teachers] [int] NULL,
	[# of Teachers Needed to Reach 85%] [int] NULL,
	[MTI TTT] [int] NULL,
	[% MTI TTT] [float] NULL,
	[MTI PE Teacher Led] [int] NULL,
	[% MTI PE Teacher Led] [float] NULL,
	[MTI K-5] [int] NULL,
	[% MTI K-5] [float] NULL,
	[Combined MTI Trained] [int] NULL,
	[% Combined MTI] [float] NULL,
	[# of License PE Teachers] [int] NULL,
	[sMTI_Program_Status] [varchar](100) NULL,
	[# of Teachers MTI Trained (STARS)] [int] NULL,
	[# of Classes as MTI (STARS)] [int] NULL,
	[Avg Min entered in (STARS)] [int] NULL,
	[# of Dedicated PE Teachers_3 or More PE Courses (STARS)] [int] NULL,
	[Total Students Enrolled] [int] NULL,
	[# Enrolled in Grade PK] [int] NULL,
	[# Enrolled in Grade K] [int] NULL,
	[# Enrolled in Grade 1] [int] NULL,
	[# Enrolled in Grade 2] [int] NULL,
	[# Enrolled in Grade 3] [int] NULL,
	[# Enrolled in Grade 4] [int] NULL,
	[# Enrolled in Grade 5] [int] NULL,
	[# Enrolled in Grade 6] [int] NULL,
	[# Enrolled in Grade 7] [int] NULL,
	[# Enrolled in Grade 8] [int] NULL,
	[# Enrolled in Grade 9] [int] NULL,
	[# Enrolled in Grade 10] [int] NULL,
	[# Enrolled in Grade 11] [int] NULL,
	[# Enrolled in Grade 12] [int] NULL,
	[sPE_Cohort_Name] [varchar](100) NULL,
	[DataPulledDate] [datetime] NULL,
	[All_Star_Date] [datetime] NULL,
	[sTTT_Teachers] [nvarchar](500) NULL,
	[# of Untrained MTI Eligible Teachers] int null, 
	[sPreviousAllStar] CHAR(3) NULL,
	[sPreviousAllStarSchoolYears] VARCHAR(100) NULL,
	CONSTRAINT [PK_SWHUB_MTI_Report] PRIMARY KEY CLUSTERED 
(
	[nSchoolYear] ASC,
	[sSchoolMonth] ASC,
	[sSchoolDBN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

--EST_Delete from SWHUB_MTI Report_Archive
Connection: ES11VDEXTESQL01 FGR_INT FGRepUser
SQL Statement: 
DELETE FROM [SWHUB_MTI Report_Archive]
WHERE nSchoolYear=(SELECT DISTINCT MAX(nSchoolYear) FROM [SWHUB_MTI Report]) AND sSchoolMonth=(SELECT DISTINCT sSchoolMonth FROM [SWHUB_MTI Report]) 
GO

--DFT_SWHUB_MTI Report_Archive
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or View
--Name of the table or the view:[SWHUB_MTI_Report]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_MTI Report_Archive]
--Table creation code:
IF OBJECT_ID('[SWHUB_MTI Report_Archive]') IS NOT NULL
	DROP TABLE [SWHUB_MTI Report_Archive]
CREATE TABLE [dbo].[SWHUB_MTI Report_Archive](
	[nSchoolYear] [int] NOT NULL,
	[sSchoolMonth] [nvarchar](15) NOT NULL,
	[nProgramID] [int] NULL,
	[sProgramName] [varchar](100) NULL,
	[sSchoolDBN] [varchar](6) NOT NULL,
	[sAdministrative District Code] [varchar](2) NULL,
	[sLocation Name] [varchar](100) NULL,
	[sLocation Category Description] [varchar](35) NULL,
	[sGrades Served] [varchar](45) NULL,
	[# of MTI Eligible Teachers] [int] NULL,
	[85% of MTI Eligible Teachers] [int] NULL,
	[# of Teachers Needed to Reach 85%] [int] NULL,
	[MTI TTT] [int] NULL,
	[% MTI TTT] [float] NULL,
	[MTI PE Teacher Led] [int] NULL,
	[% MTI PE Teacher Led] [float] NULL,
	[MTI K-5] [int] NULL,
	[% MTI K-5] [float] NULL,
	[Combined MTI Trained] [int] NULL,
	[% Combined MTI] [float] NULL,
	[# of License PE Teachers] [int] NULL,
	[sMTI_Program_Status] [varchar](100) NULL,
	[# of Teachers MTI Trained (STARS)] [int] NULL,
	[# of Classes as MTI (STARS)] [int] NULL,
	[Avg Min entered in (STARS)] [int] NULL,
	[# of Dedicated PE Teachers_3 or More PE Courses (STARS)] [int] NULL,
	[Total Students Enrolled] [int] NULL,
	[# Enrolled in Grade PK] [int] NULL,
	[# Enrolled in Grade K] [int] NULL,
	[# Enrolled in Grade 1] [int] NULL,
	[# Enrolled in Grade 2] [int] NULL,
	[# Enrolled in Grade 3] [int] NULL,
	[# Enrolled in Grade 4] [int] NULL,
	[# Enrolled in Grade 5] [int] NULL,
	[# Enrolled in Grade 6] [int] NULL,
	[# Enrolled in Grade 7] [int] NULL,
	[# Enrolled in Grade 8] [int] NULL,
	[# Enrolled in Grade 9] [int] NULL,
	[# Enrolled in Grade 10] [int] NULL,
	[# Enrolled in Grade 11] [int] NULL,
	[# Enrolled in Grade 12] [int] NULL,
	[sPE_Cohort_Name] [varchar](100) NULL,
	[DataPulledDate] [datetime] NULL,
	[All_Star_Date] [datetime] NULL,
	[sTTT_Teachers] [nvarchar](500) NULL,
	[# of Untrained MTI Eligible Teachers] int null, 
	[sPreviousAllStar] CHAR(3) NULL,
	[sPreviousAllStarSchoolYears] VARCHAR(100) NULL,
	CONSTRAINT [PK_SWHUB_MTI Report_Archive] PRIMARY KEY CLUSTERED 
(
	[nSchoolYear] ASC,
	[sSchoolMonth] ASC,
	[sSchoolDBN] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]	


--EST_Truncate Table SWHUB_MTI_TRNS_Report
Connection: ES11VDEXTESQL01 FGR_INT FGRepUser
SQL Statement:
TRUNCATE TABLE [dbo].[SWHUB_MTI_TRNS_Report]
GO



--Variables for this Package:

Name			Scope							Data type			Value
PackageID		Package 07_MTI Report 			Int32				7


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
VALUES (7,'Package 07_MTI Report')