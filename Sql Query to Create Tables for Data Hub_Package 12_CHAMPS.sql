--Sequence Container for Current Coach
--EST_For Current Coach Level Tasks
Connection: ES11VDEXTESQL01 FGR_INT FGRepUser
SQL Statement:
TRUNCATE TABLE [SWHUB_CHAMPS_Elementary_Schools_byActivity]
GO
TRUNCATE TABLE [SWHUB_CHAMPS_EligibleSchools]
GO
TRUNCATE TABLE [CHAMPS_TRNS_CurrentCoach]
GO
TRUNCATE TABLE [CHAMPS_TRNS_Last_Season_Coached]
GO
TRUNCATE TABLE [CHAMPS_TRNS_ProgramActivity_Coached]
GO
TRUNCATE TABLE [CHAMPS_TRNS_Last_Activity_Coached]
GO
TRUNCATE TABLE [CHAMPS_TRNS_Coached_CoachingDBNS]
GO

DELETE FROM [SWHUB_CHAMPS_CurrentCoach_Status_Archive]
WHERE nSchoolYear_4digit IN (SELECT DISTINCT nSchoolYear_4digit FROM [SWHUB_CHAMPS_CurrentCoach_Status]) AND  
sSeason=(SELECT DISTINCT sSeason FROM [SWHUB_CHAMPS_CurrentCoach_Status])
GO

TRUNCATE TABLE [SWHUB_CHAMPS_CurrentCoach_Status]
GO

--DFT_SWHUB_CHAMPS_Elementary_Schools_byActivity
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.Champs_Int.ChampsUser
--Data access mode: SQL Command
--SQL Command text: 
SELECT  DISTINCT SchoolDBN,ActivityDesc,GETDATE() AS [DataPulledDate]  
--INTO #SWHUB_CHAMPS_Elementary_Schools_byActivity
FROM fh_application a 
INNER JOIN fh_programs b ON a.ProgramId=b.ProgramId
INNER JOIN FH_Activities c ON b.ActivityId=c.ActivityId
WHERE c.ActivityDesc like '%elementary%'
ORDER BY SchoolDBN

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_TblOrganizationData]
--Table creation code:
CREATE TABLE [dbo].[SWHUB_CHAMPS_Elementary_Schools_byActivity](
	[nId] [int] IDENTITY(1,1) NOT NULL,
	[sSchool_DBN] [varchar](6) NULL,
	[sActivityDesc] [varchar](100) NULL,
	[DataPulledDate] [datetime] NULL,
 CONSTRAINT [PK_SWHUB_CHAMPS_Elementary_Schools_byActivity] PRIMARY KEY CLUSTERED 
(
	[nId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

Note: Ignore [nId] for mapping

--DFT_DFT_SWHUB_CHAMPS_EligibleSchools
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL Command text: 
SELECT DISTINCT aa.[Fiscal_Year],(aa.[Fiscal_Year]-1)AS [nSchoolYear],aa.[SchoolDBN],aa.Location_Name_Long,aa.Administrative_District_Code,
aa.[Borough],aa.[Location_Type_Description],aa.[Location_Category_Description],aa.[Grades_Text],aa.[Principal_Name],aa.[Principal_Email],
aa.Principal_Phone_Number,aa.Field_Support_Center_Name,
CASE WHEN el.[sSchool_DBN] IS NOT NULL THEN 'Yes' ELSE '' END AS [Elementary_CHAMPS_Activity],
GETDATE() AS [DataPulledDate]  
FROM (
SELECT  Fiscal_Year,CAST([System_Code] AS CHAR(6)) AS SchoolDBN,Location_Name_Long, Location_Category_Code,Location_Category_Description,[Grades_Text], Location_Type_Code, Location_Type_Description, 
		Administrative_District_Code,SUBSTRING(System_Code,3,1) AS [Borough],Primary_Building_Code,Principal_Name,Principal_Phone_Number, [Principal_Email],
		COALESCE (Primary_Address_Line_1, '') + ' ' + COALESCE (Primary_Address_Line_2, '') + ' ' + COALESCE (Primary_Address_Line_3, '') AS School_Address, City, State_Code, Zip, 
		Field_Support_Center_Location_code,Field_Support_Center_Name

FROM  SUPERLINK.Supertable.dbo.Location_Supertable1 
WHERE  	System_ID = 'ats' AND Fiscal_Year = CASE WHEN month(getdate()) >= '07' THEN year(getdate()) + 1 ELSE year(getdate()) END
		AND Location_Type_Description IN ('General Academic', 'Special Education', 'Career Technical', 'Transfer School')  
		AND Status_Code = 'O' AND Administrative_District_Code IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32') 
		AND Location_Category_Description <> 'Borough' AND Location_Category_Description <> 'Central-HQ-Citywide' AND (SUBSTRING(System_Code, 4, 3) <> '444') 
		AND SUBSTRING(System_Code, 4, 3) <> '700' AND Location_Name <> 'Universal Pre-K C.B.O.' AND Location_Type_Description <> 'Home School' 
		AND Location_Type_Description <> 'Adult' AND Location_Type_Description <> 'Alternative' AND Location_Type_Description <> 'Evening'
		AND Location_Type_Description <> 'Suspension Center' AND Location_Type_Description <> 'YABC' AND Grades_Text <> ''
		AND Location_Category_Description in ('Early Childhood','Elementary','K-8','Junior High-Intermediate-Middle','Secondary School','K-12 all grades')

--only elementary and middle school grades from district 1 to 32 

UNION
SELECT  Fiscal_Year,CAST([System_Code] AS CHAR(6)) AS SchoolDBN,Location_Name_Long, Location_Category_Code,Location_Category_Description,[Grades_Text], Location_Type_Code, Location_Type_Description, 
		Administrative_District_Code,SUBSTRING(System_Code,3,1) AS [Borough],Primary_Building_Code,Principal_Name,Principal_Phone_Number, [Principal_Email],
		COALESCE (Primary_Address_Line_1, '') + ' ' + COALESCE (Primary_Address_Line_2, '') + ' ' + COALESCE (Primary_Address_Line_3, '') AS School_Address, City, State_Code, Zip, 
		Field_Support_Center_Location_code,Field_Support_Center_Name
		FROM  SUPERLINK.Supertable.dbo.Location_Supertable1 
WHERE   System_ID = 'ats' AND Fiscal_Year = CASE WHEN month(getdate()) >= '07' THEN year(getdate()) + 1 ELSE year(getdate()) END
		AND Location_Type_Description IN ('General Academic', 'Special Education', 'Career Technical', 'Transfer School')  
		AND Status_Code = 'O' AND Administrative_District_Code IN ('75') 
		AND Location_Category_Description <> 'Borough' AND Location_Category_Description <> 'Central-HQ-Citywide' AND (SUBSTRING(System_Code, 4, 3) <> '444') 
		AND SUBSTRING(System_Code, 4, 3) <> '700' AND Location_Name <> 'Universal Pre-K C.B.O.' AND Location_Type_Description <> 'Home School' 
		AND Location_Type_Description <> 'Adult' AND Location_Type_Description <> 'Alternative' AND Location_Type_Description <> 'Evening'
		AND Location_Type_Description <> 'Suspension Center' AND Location_Type_Description <> 'YABC' AND Grades_Text <> ''
	
----All school grades from district 75
) aa
LEFT JOIN (SELECT DISTINCT sSchool_DBN FROM SWHUB_CHAMPS_Elementary_Schools_byActivity) el ON aa.SchoolDBN=el.sSchool_DBN
--To get Elementary CHAMPS schools by activity

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_CHAMPS_EligibleSchools]
--Table creation code:
IF OBJECT_ID('[SWHUB_CHAMPS_EligibleSchools]') IS NOT NULL
DROP TABLE [SWHUB_CHAMPS_EligibleSchools]
CREATE TABLE [SWHUB_CHAMPS_EligibleSchools] (
                 [nSchoolYear]										int NULL
				,[nFiscal_Year]										int NULL
				,[sSchoolDBN]										varchar(6) NULL
				,[sSchool_Name]										varchar(100) NULL
				,[sDistrict]										char(2) NULL
				,[sBorough]											char(1) NULL
			    ,[sLocation_Type_Description]						varchar(100) NULL
                ,[sLocation_Category_Description]					varchar(100) NULL
                ,[sGrades_Served]									varchar(100) NULL
                ,[sPrincipal_Name]									varchar(100) NULL
                ,[sPrincipal_Email]									varchar(100) NULL   
				,[sPrincipal_Phone_Number]							varchar(15) NULL    
				,[sField_Support_Center_Name]						varchar(100) NULL
				,[DataPulledDate]										datetime NULL
				)



--DFT_CHAMPS_TRNS_CurrentCoach
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.Champs_Int.ChampsUser
--Data access mode: SQL Command
--SQL Command text: 
---Returning Coaches:  Current season's all coaches that have not coached a CHAMPS activity in the last 25 months but have coached prior to 25 months
SELECT 
c.*,
CASE WHEN EmployeeNo IS NOT NULL THEN 'Returning Coach' ELSE '' END AS [Coach_Status]   
--INTO #CHAMPS_TRNS_CurrentCoach 
FROM (
SELECT b.* FROM (
SELECT DISTINCT a.* FROM 
( 
SELECT DISTINCT app.SchoolDBN,c.[CoachFName],c.[CoachLName],c.EmployeeNo,REPLACE(SUBSTRING(c.Email,1,(CHARINDEX('@', c.Email))),'@','') AS [EmailAlias],c.[EisID],s.School_Year,
SUBSTRING(s.School_Year,1,4) AS SchoolYear_4digit,CASE WHEN CAST(app.CoachApproved AS CHAR(1))=1 THEN 'Y' ELSE 'N' END AS Coach_Approved,s.[Season],
CASE WHEN CAST(s.Active AS CHAR(1))=1 THEN 'Y' ELSE 'N' END AS [Season_Active], s.[StartDate] AS [Season_StartDate],s.[EndDate] AS [Season_EndDate],CAST(DATEPART(yyyy,s.[StartDate]) AS VARCHAR)+' '+ datename(m,s.[StartDate]) AS Season_StartMonthAndYear
FROM dbo.FH_Application app                                            
LEFT OUTER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId                                                     
LEFT OUTER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
LEFT OUTER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID AND s.Active=1                                                    
LEFT OUTER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
LEFT OUTER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
LEFT OUTER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                     
LEFT OUTER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId   
LEFT OUTER JOIN dbo.Location_Supertable ls ON app.SchoolDBN = ls.System_Code          
WHERE app.Approved=1 AND School_Year IS NOT NULL AND app.ProgramStatusId = 1 AND c.EmployeeNo IS NOT NULL AND c.EmployeeNo<>''
) a WHERE [Season_Active] = 'Y' --all current season coaches
) b WHERE EmployeeNo NOT IN 
(
SELECT DISTINCT EmployeeNo FROM ( --exclude coaches who were coached in the last 25 months period
SELECT a.* FROM (
SELECT  app.SchoolDBN,c.[CoachFName],c.[CoachLName],c.EmployeeNo,REPLACE(SUBSTRING(c.Email,1,(CHARINDEX('@', c.Email))),'@','') AS [EmailAlias],c.[EisID],s.School_Year,
SUBSTRING(s.School_Year,1,4) AS SchoolYear_4digit,CASE WHEN CAST(app.CoachApproved AS CHAR(1))=1 THEN 'Y' ELSE 'N' END AS Coach_Approved,s.[Season],
CASE WHEN CAST(s.Active AS CHAR(1))=1 THEN 'Y' ELSE 'N' END AS [Season_Active], s.[StartDate],s.[EndDate],CAST(DATEPART(yyyy,s.[StartDate]) AS VARCHAR)+' '+ DATENAME(m,s.[StartDate]) AS SeasonStart_MonthAndYear
FROM dbo.FH_Application app                                            
LEFT OUTER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId                                                     
LEFT OUTER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
LEFT OUTER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID                                                   
LEFT OUTER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
LEFT OUTER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
LEFT OUTER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                     
LEFT OUTER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId   
LEFT OUTER JOIN dbo.Location_Supertable ls ON app.SchoolDBN = ls.System_Code          
WHERE app.Approved=1 and School_Year IS NOT NULL   AND app.ProgramStatusId = 1 AND c.EmployeeNo IS NOT NULL AND c.EmployeeNo<>''-- all current season coaches
)a	WHERE a.[StartDate]>=(SELECT DATEADD(MONTH, -25, [StartDate]) AS [24MonthPriortoStartDate] FROM [dbo].[FH_Seasons] WHERE  Active=1)
		  AND 
		  [StartDate]<(SELECT DATEADD(MONTH, -1, [StartDate]) AS [1MonthPriortoStartDate] FROM [dbo].[FH_Seasons] WHERE  Active=1)
)y --active coaches who taught in last 6 seasons except the current season
) )c

WHERE EmployeeNo  IN (
SELECT DISTINCT EmployeeNo FROM ( --matching the above coaches with the coaches were coached from begining until prior to last 2 year 
SELECT a.* FROM (
SELECT  app.SchoolDBN,c.[CoachFName],c.[CoachLName],c.EmployeeNo,REPLACE(SUBSTRING(c.Email,1,(CHARINDEX('@', c.Email))),'@','') AS [EmailAlias],c.[EisID],s.School_Year,
SUBSTRING(s.School_Year,1,4) AS SchoolYear_4digit,CASE WHEN CAST(app.CoachApproved AS CHAR(1))=1 THEN 'Y' ELSE 'N' END AS Coach_Approved,s.[Season],
CASE WHEN CAST(s.Active AS CHAR(1))=1 THEN 'Y' ELSE 'N' END AS [Season_Active], s.[StartDate],s.[EndDate],cast(datepart(yyyy,s.[StartDate]) as varchar)+' '+ datename(m,s.[StartDate]) AS SeasonStart_MonthAndYear
FROM dbo.FH_Application app                                            
LEFT OUTER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId                                                     
LEFT OUTER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
LEFT OUTER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID                                                   
LEFT OUTER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
LEFT OUTER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
LEFT OUTER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                     
LEFT OUTER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId   
LEFT OUTER JOIN dbo.Location_Supertable ls ON app.SchoolDBN = ls.System_Code          
WHERE app.Approved=1 AND School_Year IS NOT NULL AND app.ProgramStatusId = 1 AND c.EmployeeNo IS NOT NULL AND c.EmployeeNo<>''-- all current season coaches
)a	WHERE a.[StartDate]>=(SELECT MIN([StartDate]) AS [BeginingStartDate] FROM [dbo].[FH_Seasons])
		  AND 
		  [StartDate]<(SELECT DATEADD(MONTH, -25, [StartDate]) AS [24MonthPriortoStartDate] FROM [dbo].[FH_Seasons] WHERE  Active=1)
 )y
)


UNION
--Recent coaches: Current season's all coaches that have coached a CHAMPS activity within the last 25 months 

SELECT b.*, CASE WHEN EmployeeNo IS NOT NULL THEN 'Recent Coach' ELSE '' END AS [Coach_Status]  FROM (
SELECT DISTINCT a.* FROM 
( 
SELECT DISTINCT app.SchoolDBN,c.[CoachFName],c.[CoachLName],c.EmployeeNo,REPLACE(SUBSTRING(c.Email,1,(CHARINDEX('@', c.Email))),'@','') AS [EmailAlias],c.[EisID],s.School_Year,
SUBSTRING(s.School_Year,1,4) AS SchoolYear_4digit,CASE WHEN CAST(app.CoachApproved AS CHAR(1))=1 THEN 'Y' ELSE 'N' END AS Coach_Approved,s.[Season],
CASE WHEN CAST(s.Active AS CHAR(1))=1 THEN 'Y' ELSE 'N' END AS [Season_Active], s.[StartDate] AS [Season_StartDate],s.[EndDate] AS [Season_EndDate],cast(datepart(yyyy,s.[StartDate]) as varchar)+' '+ datename(m,s.[StartDate]) AS Season_StartMonthAndYear
FROM dbo.FH_Application app                                            
LEFT OUTER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId                                                     
LEFT OUTER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
LEFT OUTER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID AND s.Active=1                                                    
LEFT OUTER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
LEFT OUTER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
LEFT OUTER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                     
LEFT OUTER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId   
LEFT OUTER JOIN dbo.Location_Supertable ls ON app.SchoolDBN = ls.System_Code          
WHERE app.Approved=1 AND School_Year IS NOT NULL   AND app.ProgramStatusId = 1 AND c.EmployeeNo IS NOT NULL AND c.EmployeeNo<>''
) a WHERE [Season_Active] = 'Y' -- all current season coaches
) b WHERE EmployeeNo IN (
SELECT DISTINCT EmployeeNo FROM ( --only include current coaches from the list of coaches who were taught in last 24 month except current season
SELECT a.* FROM (
SELECT  app.SchoolDBN,c.EmployeeNo,REPLACE(SUBSTRING(c.Email,1,(CHARINDEX('@', c.Email))),'@','') AS [EmailAlias],c.[EisID],s.School_Year,
SUBSTRING(s.School_Year,1,4) AS SchoolYear_4digit,CASE WHEN CAST(app.CoachApproved AS CHAR(1))=1 THEN 'Y' ELSE 'N' END AS Coach_Approved,s.[Season],
CASE WHEN CAST(s.Active AS CHAR(1))=1 THEN 'Y' ELSE 'N' END AS [Season_Active],s.[StartDate],s.[EndDate],CAST(DATEPART(yyyy,s.[StartDate]) as varchar)+' '+ DATENAME(m,s.[StartDate]) AS MonthYear
FROM dbo.FH_Application app                                            
LEFT OUTER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId                                                     
LEFT OUTER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
LEFT OUTER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID                                                   
LEFT OUTER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
LEFT OUTER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
LEFT OUTER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                     
LEFT OUTER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId   
LEFT OUTER JOIN dbo.Location_Supertable ls ON app.SchoolDBN = ls.System_Code          
WHERE app.Approved=1 AND  School_Year IS NOT NULL   AND app.ProgramStatusId = 1 AND c.EmployeeNo IS NOT NULL AND c.EmployeeNo<>''-- all current season coaches
)a	WHERE	a.[StartDate]>=(SELECT DATEADD(MONTH, -25, [StartDate]) AS [25MonthPriortoStartDate] FROM [dbo].[FH_Seasons] WHERE  Active=1)
			AND 
			[StartDate]<(SELECT DATEADD(MONTH, -1, [StartDate]) AS [1MonthPriortoStartDate] FROM [dbo].[FH_Seasons] WHERE  Active=1)
			 --current coaches who taught in last 25 month except current season (25 months considered because of getting six season 
) y 
)


UNION
--New coach: Current season's all coaches who were never coached any of the CHAMPS activity since begining

SELECT b.*, CASE WHEN EmployeeNo IS NOT NULL THEN 'New Coach' ELSE '' END AS [Coach_Status]  FROM (
SELECT  a.* FROM 
( 
SELECT DISTINCT app.SchoolDBN,c.[CoachFName],c.[CoachLName],c.EmployeeNo,REPLACE(SUBSTRING(c.Email,1,(CHARINDEX('@', c.Email))),'@','') AS [EmailAlias],c.[EisID],s.School_Year,SUBSTRING(s.School_Year,1,4) AS SchoolYear_4digit,
CASE WHEN CAST(app.CoachApproved AS CHAR(1))=1 THEN 'Y' ELSE 'N' END AS Coach_Approved,s.[Season],
CASE WHEN CAST(s.Active AS CHAR(1))=1 THEN 'Y' ELSE 'N' END AS [Season_Active], s.[StartDate] AS [Season_StartDate],s.[EndDate] AS [Season_EndDate],
CAST(DATEPART(yyyy,s.[StartDate]) AS VARCHAR)+' '+ DATENAME(m,s.[StartDate]) AS Season_StartMonthAndYear
FROM dbo.FH_Application app                                            
LEFT OUTER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId                                                     
LEFT OUTER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
LEFT OUTER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID AND s.Active=1                                                    
LEFT OUTER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
LEFT OUTER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
LEFT OUTER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                     
LEFT OUTER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId   
LEFT OUTER JOIN dbo.Location_Supertable ls ON app.SchoolDBN = ls.System_Code          
WHERE app.Approved=1 AND School_Year IS NOT NULL   AND app.ProgramStatusId = 1 AND c.EmployeeNo IS NOT NULL AND c.EmployeeNo<>''
) a WHERE [Season_Active] = 'Y' --Current season coaches
) b WHERE EmployeeNo NOT IN (SELECT DISTINCT EmployeeNo FROM ( --exclude current coaches from the list of coaches who were coached in the past any of the season since begining to prior to current season
SELECT * FROM (
SELECT  app.SchoolDBN,c.EmployeeNo,REPLACE(SUBSTRING(c.Email,1,(CHARINDEX('@', c.Email))),'@','') AS [EmailAlias],c.[EisID],s.School_Year,SUBSTRING(s.School_Year,1,4) AS SchoolYear_4digit,
CASE WHEN CAST(app.CoachApproved AS CHAR(1))=1 THEN 'Y' ELSE 'N' END AS Coach_Approved,s.[Season],CASE WHEN CAST(s.Active AS CHAR(1))=1 THEN 'Y' ELSE 'N' END AS [Season_Active], 
s.[StartDate],s.[EndDate],CAST(DATEPART(yyyy,s.[StartDate]) AS VARCHAR)+' '+ DATENAME(m,s.[StartDate]) AS MonthYear
FROM dbo.FH_Application app                                            
LEFT OUTER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId                                                     
LEFT OUTER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
LEFT OUTER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID                                                   
LEFT OUTER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
LEFT OUTER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
LEFT OUTER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                     
LEFT OUTER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId   
LEFT OUTER JOIN dbo.Location_Supertable ls ON app.SchoolDBN = ls.System_Code          
WHERE app.Approved=1 and School_Year IS NOT NULL   and app.ProgramStatusId = 1 AND c.EmployeeNo IS NOT NULL AND c.EmployeeNo<>''-- all active coaches
)a	WHERE a.[StartDate]>=(SELECT MIN([StartDate]) AS [BeginingStartDate] FROM [dbo].[FH_Seasons])
			 AND 
			[StartDate]< (SELECT DATEADD(MONTH, -1, [StartDate]) AS [1MonthPriortoStartDate] FROM [dbo].[FH_Seasons] WHERE  Active=1)
			 --coaches who coached in the past since begining to prior to current season 
) y 
)

--Data Conversion:
Input Column					Output Alias						Data Type					Length
[Season_StartMonthAndYear]		Season_StartMonthAndYear_Convert	string [DT_STR]				15
[EmailAlias]					EmailAlias_Convert					string [DT_STR]				20

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [CHAMPS_TRNS_CurrentCoach]
--Table creation code:

IF OBJECT_ID('[CHAMPS_TRNS_CurrentCoach]') IS NOT NULL
DROP TABLE [CHAMPS_TRNS_CurrentCoach]
CREATE TABLE [CHAMPS_TRNS_CurrentCoach]  (
                 [sSchoolDBN]				varchar(10) NULL
                ,[sCoachFName]				varchar(30) NULL
                ,[sCoachLName]				varchar(30) NULL
                ,[sEmployeeNo]				char(10) NULL
				,[sEmailAlias]				varchar(20) NULL
				,[sEISID]					varchar(10) NULL
				,[sSchool_Year]				varchar(9) NULL
				,[nSchoolYear_4digit]		int NULL
				,[sCoach_Approved]			char(1) NULL
				,[sSeason]					varchar(10) NULL
				,[sSeason_Active]			char(1) NULL
				,[dtSeason_StartDate]		datetime NULL
				,[dtSeason_EndDate]			datetime NULL
				,[sSeason_StartMonthAndYear] varchar(15) NULL
				,[sCoach_Status]			varchar(50) NULL
)

--DFT_CHAMPS_TRNS_Last_Season_Coached
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.Champs_Int.ChampsUser
--Data access mode: SQL Command
--SQL Command text: 
SELECT b.* 
FROM (
SELECT  DISTINCT  [EmployeeNo],Program_Season,Season_Order,
ROW_NUMBER() OVER (PARTITION BY [EmployeeNo] ORDER BY [EmployeeNo],School_Year,Season_Order) AS [RowNumber] 
FROM (
SELECT  DISTINCT  c.[EmployeeNo],s.Season,s.Active,s.SchoolYear,s.StartDate,(School_Year+'_'+Season) AS Program_Season,s.School_Year,
CASE WHEN s.Season='Fall'	THEN 1
	 WHEN s.Season='Winter'	THEN 2
	 WHEN s.Season='Spring' THEN 3 
END AS Season_Order
FROM dbo.FH_Application app                                            
INNER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId AND app.Approved=1  AND app.CoachApproved=1                                                        
INNER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
INNER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID                                               
INNER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
INNER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
INNER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                  
INNER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId
WHERE s.Active<>1 AND c.[EmployeeNo] IS NOT NULL --Excluded current active coaches
)a 
)b

--Data Conversion:
Input Column		Output Alias		Data Type								Length
[RowNumber]			RowNumber_Convert	four-byte-signed integer [DT_I4]		

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [CHAMPS_TRNS_Last_Season_Coached]
--Table creation code:
IF OBJECT_ID('[CHAMPS_TRNS_Last_Season_Coached]') IS NOT NULL
DROP TABLE [CHAMPS_TRNS_Last_Season_Coached]
CREATE TABLE  [CHAMPS_TRNS_Last_Season_Coached] (
                 [sEmployeeNo]		char(10) NULL
				,[sProgram_Season]	varchar(30) NULL
				,[nSeason_Order]	int NULL
				,[nRowNumber]		int NULL
)


--DFT_CHAMPS_TRNS_ProgramActivity_Coached
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.Champs_Int.ChampsUser
--Data access mode: SQL Command
--SQL Command text: 
SELECT  DISTINCT  c.[EmployeeNo],s.Season,
CASE WHEN CAST(s.Active AS CHAR(1))=1 THEN 'Y' ELSE 'N' END AS [Season_Active],
s.SchoolYear,s.StartDate,(School_Year+'_'+Season) AS Program_Season,s.School_Year,
CASE WHEN s.Season='Fall'	THEN 1
	 WHEN s.Season='Winter'	THEN 2
	 WHEN s.Season='Spring' THEN 3 
END AS Season_Order,a.ActivityDesc AS Program_Activity
FROM dbo.FH_Application app                                            
INNER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId AND app.Approved=1  AND app.CoachApproved=1                                                        
INNER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
INNER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID                                               
INNER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
INNER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
INNER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                  
INNER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId
WHERE s.Active<>1 AND c.[EmployeeNo] IS NOT NULL

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [CHAMPS_TRNS_ProgramActivity_Coached]
--Table creation code:
IF OBJECT_ID('[CHAMPS_TRNS_ProgramActivity_Coached]') IS NOT NULL
DROP TABLE [CHAMPS_TRNS_ProgramActivity_Coached]
CREATE TABLE [CHAMPS_TRNS_ProgramActivity_Coached]  (
                 [sEmployeeNo]			char(10) NULL
				,[sSeason]				varchar(10) NULL
				,[sSeason_Active]		char(1) NULL
				,[nSchoolYear]			int NULL
				,[dtSeason_StartDate]	datetime NULL
				,[sProgram_Season]		varchar(30) NULL
				,[sSchool_Year]			varchar(9) NULL
				,[nSeason_Order]		int NULL
				,[sProgram_Activity]	varchar(100) NULL
)


--DFT_CHAMPS_TRNS_Last_Activity_Coached
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL Command text: 
With Cte([sEmployeeNo],sProgram_Season,sSchool_Year,nSeason_Order,c_concat) AS 
(SELECT [sEmployeeNo],sProgram_Season,sSchool_Year,nSeason_Order,
(SELECT a.sProgram_Activity+',' from 
(SELECT DISTINCT [sEmployeeNo],sProgram_Season,sSchool_Year,nSeason_Order,LTRIM(sProgram_Activity) AS sProgram_Activity
FROM CHAMPS_TRNS_ProgramActivity_Coached
)
AS a    
WHERE a.[sEmployeeNo]=b.[sEmployeeNo] AND a.sProgram_Season=b.sProgram_Season AND a.nSeason_Order=b.nSeason_Order  
 for XML PATH ('') ) c_concat FROM 
(SELECT DISTINCT [sEmployeeNo],[sProgram_Season],[sSchool_Year],[nSeason_Order],LTRIM(sProgram_Activity) AS sProgram_Activity
FROM CHAMPS_TRNS_ProgramActivity_Coached
) AS b  
GROUP BY [sEmployeeNo],[sProgram_Season],[sSchool_Year],nSeason_Order) 

SELECT b.* 
FROM (
SELECT  DISTINCT  [sEmployeeNo],sProgram_Season,nSeason_Order,CAST([sProgram_Activity_Coached] AS VARCHAR(100)) AS [sProgram_Activity_Coached],
ROW_NUMBER() OVER (PARTITION BY [sEmployeeNo] ORDER BY [sEmployeeNo],[sSchool_Year],[nSeason_Order]) AS [nRowNumber] 
FROM (
SELECT [sEmployeeNo],[sProgram_Season],[sSchool_Year],[nSeason_Order],left(c_concat, len(c_concat) -1)AS [sProgram_Activity_Coached] 
FROM cte 
)a 
)b
ORDER BY [sEmployeeNo],[sProgram_Season],[nSeason_Order]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [CHAMPS_TRNS_Last_Activity_Coached]
--Table creation code:
IF OBJECT_ID('[CHAMPS_TRNS_Last_Activity_Coached]') IS NOT NULL
DROP TABLE [CHAMPS_TRNS_Last_Activity_Coached]
CREATE TABLE  [CHAMPS_TRNS_Last_Activity_Coached] (
                 [sEmployeeNo]					char(10) NULL
				,[sProgram_Season]				varchar(30) NULL
				,[nSeason_Order]				int NULL
				,[sProgram_Activity_Coached] 	varchar(100) NULL
				,[nRowNumber]					int NULL
)


--DFT_CHAMPS_TRNS_Coached_CoachingDBNS
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL Command text: 
With Cte(sCoachFName,sCoachLName,sEmployeeNo,sEmailAlias,sEisID, sSchool_Year,c_concat) as 
(SELECT sCoachFName,sCoachLName,sEmployeeNo,sEmailAlias,sEisID, sSchool_Year,
(SELECT a.sSchoolDBN+',' from 
(SELECT DISTINCT sCoachFName,sCoachLName,sEmployeeNo,sEmailAlias,sEisID, sSchool_Year,LTRIM(sSchoolDBN) AS sSchoolDBN)
AS a    
WHERE a.sEmployeeNo=b.sEmployeeNo     for XML PATH ('') ) c_concat FROM 
(SELECT DISTINCT sCoachFName,sCoachLName,sEmployeeNo,sEmailAlias,sEisID, sSchool_Year,LTRIM(sSchoolDBN) AS sSchoolDBN 
FROM CHAMPS_TRNS_CurrentCoach WHERE sCoach_Approved='Y'
		) AS b  
GROUP BY sCoachFName,sCoachLName,sEmployeeNo,sEmailAlias,sEisID, sSchool_Year,sSchoolDBN) 

SELECT sEmployeeNo,sEmailAlias,sEisID,sSchool_Year,CAST(left(c_concat, len(c_concat) -1) AS VARCHAR(100))AS [sCoaching DBNs]  

FROM cte 
ORDER BY sCoachFName,sCoachLName,sEmployeeNo,sEmailAlias,sEisID,sSchool_Year

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [CHAMPS_TRNS_Coached_CoachingDBNS]
--Table creation code:
IF OBJECT_ID('[CHAMPS_TRNS_Coached_CoachingDBNS]') IS NOT NULL
DROP TABLE [CHAMPS_TRNS_Coached_CoachingDBNS]
CREATE TABLE  [CHAMPS_TRNS_Coached_CoachingDBNS] (
                 [sEmployeeNo]		char(10) NULL
				,[sEmailAlias]		varchar(20) NULL
				,[sEISID]			varchar(10) NULL
				,[sSchool_Year]		varchar(9) NULL
				,[sCoaching_DBNS]	varchar(100) NULL
)

--DFT_SWHUB_CHAMPS_CurrentCoach_Status
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL Command text: 
SELECT w.*,x.sProgram_Season AS [sLastSeasonCoached],y.[sProgram_Activity_Coached] AS [sLastActivityCoached],z.[sCoaching_DBNs],
CASE WHEN b.[sEmployeeNo] IS NOT NULL THEN 'Y' ELSE 'N' END AS [sAttended_Orientation_in4month],
c.[dtEventDate] AS [dtLastAttendedDate] 
,GETDATE() AS [DataPulledDate]
FROM CHAMPS_TRNS_CurrentCoach w 
LEFT JOIN (
SELECT a.* FROM CHAMPS_TRNS_Last_Season_Coached a
INNER JOIN (SELECT [sEmployeeNo],MAX([nRowNumber]) AS [nRowNumber] FROM CHAMPS_TRNS_Last_Season_Coached GROUP BY [sEmployeeNo]) b 
ON a.[sEmployeeNo]=b.[sEmployeeNo] AND a.[nRowNumber]=b.[nRowNumber] 
)  x 
ON w.[sEmployeeNo]=x.[sEmployeeNo] 
LEFT JOIN (
SELECT a.* FROM CHAMPS_TRNS_Last_Activity_Coached a
INNER JOIN (SELECT [sEmployeeNo],MAX([nRowNumber]) AS [nRowNumber] FROM CHAMPS_TRNS_Last_Activity_Coached GROUP BY [sEmployeeNo]) b 
ON a.[sEmployeeNo]=b.[sEmployeeNo] AND a.[nRowNumber]=b.[nRowNumber] 
)  y
ON w.[sEmployeeNo]=y.[sEmployeeNo] 
LEFT JOIN CHAMPS_TRNS_Coached_CoachingDBNS z ON w.sEmployeeNo=z.sEmployeeNo AND w.sSchool_Year=z.sSchool_Year

LEFT JOIN (
SELECT *
FROM (
SELECT DISTINCT  [sEventParticipant_FirstName],[sEventParticipant_LastName],--[EmailAlias],
[sEmployeeNo],[sEISID],SchoolDBN,[sEventName],[dtEventDate],
ROW_NUMBER() OVER (PARTITION BY SchoolDBN,[sEmployeeNo] ORDER BY SchoolDBN,[sEmployeeNo],[dtEventDate] desc) AS RowNumber
FROM (
SELECT DISTINCT [sEventParticipant_FirstName],[sEventParticipant_LastName],
--[sParticipantEmail],REPLACE(SUBSTRING([sParticipantEmail],1,(CHARINDEX('@', [sParticipantEmail]))),'@','') AS [EmailAlias],
[sEventParticipant_EmployeeNo] AS [sEmployeeNo],[sEventParticipant_EISId] AS [sEISID],
[sEventParticipant_SchoolDBN] AS SchoolDBN,[sProgramName],[sEventName],[dtEventDate]
FROM [SWHUB_ISS_EventParticipants] 
WHERE 
([dtEventDate]>=(SELECT DISTINCT DATEADD(MONTH, -4, DATEADD(DAY, 1 - DAY(GETDATE()), GETDATE())) AS [FirstDayofMonth4PriortoToday] FROM [SWHUB_ISS_EventParticipants])
		AND 
		[dtEventDate]<GETDATE()
)
AND [sEventName] like '%NEW COACH ORIENTATION%' 
AND [sEventParticipant_EmployeeNo] IS NOT NULL 
AND [sEventParticipant_EmployeeNo]<>'' 
AND  [sEventParticipantType]='U'
--AND [sEventParticipantTypeDesc]='School Staff' 
AND [sEventParticipant_SchoolDBN] IS NOT NULL
)c
)d WHERE RowNumber=1) b ON w.[sSchoolDBN]=b.[SchoolDBN] AND w.[sEmployeeNo]=b.[sEmployeeNo]

LEFT JOIN (
SELECT * FROM (
SELECT DISTINCT  [sEventParticipant_FirstName],[sEventParticipant_LastName],--[EmailAlias],
[sEmployeeNo],[sEISID],SchoolDBN,[sEventName],[dtEventDate],
ROW_NUMBER() OVER (PARTITION BY SchoolDBN,[sEmployeeNo] ORDER BY SchoolDBN,--EmailAlias,
[dtEventDate] desc) AS RowNumber
FROM (
SELECT DISTINCT [sEventParticipant_FirstName],[sEventParticipant_LastName],
--[sParticipantEmail],REPLACE(SUBSTRING([sParticipantEmail],1,(CHARINDEX('@', [sParticipantEmail]))),'@','') AS [EmailAlias],
[sEventParticipant_EmployeeNo] AS [sEmployeeNo],[sEventParticipant_EISId] AS [sEISID],
[sEventParticipant_SchoolDBN] AS SchoolDBN,[sProgramName],[sEventName],[dtEventDate]
FROM [SWHUB_ISS_EventParticipants] 
WHERE 
[sEventName] like '%NEW COACH ORIENTATION%' 
AND [sEventParticipant_EmployeeNo] IS NOT NULL 
AND [sEventParticipant_EmployeeNo]<>'' 
AND  [sEventParticipantType]='U'
--AND [sEventParticipantTypeDesc]='School Staff' 
AND [sEventParticipant_SchoolDBN] IS NOT NULL
)c
)d WHERE RowNumber=1)c ON w.[sSchoolDBN]=c.[SchoolDBN] AND w.[sEmployeeNo]=c.[sEmployeeNo]
WHERE w.sSchoolDBN IN (SELECT DISTINCT [sSchoolDBN] FROM [dbo].[SWHUB_CHAMPS_EligibleSchools])
ORDER BY w.[sCoach_Status]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_CHAMPS_CurrentCoach_Status]
--Table creation code:
IF OBJECT_ID('[SWHUB_CHAMPS_CurrentCoach_Status]') IS NOT NULL
DROP TABLE [SWHUB_CHAMPS_CurrentCoach_Status]
CREATE TABLE [SWHUB_CHAMPS_CurrentCoach_Status]  (
                [sSchoolDBN]						varchar(10) NULL
                ,[sCoachFName]						varchar(30) NULL 
                ,[sCoachLName]						varchar(30) NULL
                ,[sEmployeeNo]						char(10) NULL
				,[sEmailAlias]						varchar(20) NULL
				,[sEISID]							varchar(10) NULL
				,[sSchool_Year]						varchar(9) NULL
				,[nSchoolYear_4digit]				int NULL
				,[sCoach_Approved]					char(1) NULL
				,[sSeason]							varchar(10) NULL
				,[sSeason_Active]					char(1) NULL
				,[dtSeason_StartDate]				datetime NULL
				,[dtSeason_EndDate]					datetime NULL
				,[sSeason_StartMonthAndYear]		varchar(15) NULL
				,[sCoach_Status]					varchar(50) NULL
				,[sLastSeasonCoached]				varchar(30) NULL
				,[sLastActivityCoached]				varchar(100) NULL
				,[sCoaching_DBNS]					varchar(100) NULL
				,[sAttended_Orientation_in4month]	char(1) NULL
				,[dtLastAttendedDate]				datetime NULL
				,[DataPulledDate]						datetime NULL
)

--DFT_SWHUB_CHAMPS_CurrentCoach_Status_Archive
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view
--Name of the table or the view: [SWHUB_CHAMPS_CurrentCoach_Status]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_CHAMPS_CurrentCoach_Status_Archive]
--Table creation code:
IF OBJECT_ID('[SWHUB_CHAMPS_CurrentCoach_Status_Archive]') IS NOT NULL
DROP TABLE [SWHUB_CHAMPS_CurrentCoach_Status_Archive]
CREATE TABLE [SWHUB_CHAMPS_CurrentCoach_Status_Archive]  (
                [sSchoolDBN]						varchar(10) NULL
                ,[sCoachFName]						varchar(30) NULL 
                ,[sCoachLName]						varchar(30) NULL
                ,[sEmployeeNo]						char(10) NULL
				,[sEmailAlias]						varchar(20) NULL
				,[sEISID]							varchar(10) NULL
				,[sSchool_Year]						varchar(9) NULL
				,[nSchoolYear_4digit]				int NULL
				,[sCoach_Approved]					char(1) NULL
				,[sSeason]							varchar(10) NULL
				,[sSeason_Active]					char(1) NULL
				,[dtSeason_StartDate]				datetime NULL
				,[dtSeason_EndDate]					datetime NULL
				,[sSeason_StartMonthAndYear]		varchar(15) NULL
				,[sCoach_Status]					varchar(50) NULL
				,[sLastSeasonCoached]				varchar(30) NULL
				,[sLastActivityCoached]				varchar(100) NULL
				,[sCoaching_DBNS]					varchar(100) NULL
				,[sAttended_Orientation_in4month]	char(1) NULL
				,[dtLastAttendedDate]				datetime NULL
				,[DataPulledDate]						datetime NULL
)


--Sequence Container for Coach & Programs & Students
--EST_For Coach and Programs Level Tasks
Connection: ES11VDEXTESQL01 FGR_INT FGRepUser
SQL Command:
TRUNCATE TABLE [CHAMPS_TRNS_Coach_Programs]
GO
TRUNCATE TABLE [CHAMPS_TRNS_NumberOfstudents_Program_Coach_School]
GO
TRUNCATE TABLE [SWHUB_CHAMPS_Coach_Programs]
GO
TRUNCATE TABLE [SWHUB_CHAMPS_Search]
GO
TRUNCATE TABLE [CHAMPS_TRNS_Students_Programs]
GO
TRUNCATE TABLE [SWHUB_CHAMPS_Students_Programs]
GO

--DFT_CHAMPS_TRNS_Coach_Programs
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.Champs_Int.ChampsUser
--Data access mode: SQL Command
--SQL Command text: 
SELECT DISTINCT y.[AppId],y.App_Approved,y.[App_CreatedDate],y.[App_ApprovedDate],y.[App_CancellationDate],
y.SchoolDBN, y.CoachID,y.CoachFName,y.CoachLName,y.EmployeeNo,y.Email,--y.[EmailAlias],
y.EISID,y.[Coach_Confirmed],y.[Coach_PE_License],y.[CPRExpDate],y.[CYSExpDate],
y.School_Year,y.Season,y.[Season_Active],y.Season_StartDate,y.Season_EndDate,y.Program_Season,y.[sProgram_Scheduled],y.ProgramId,y.Program_Activity,
y.Program_Status,y.[Campus_Program],y.[Split_Program],y.Session_Type,y.[Program_Sex],
--y.[MaxPayrollHours],
[MaxPayrollHours]=CASE WHEN y.[ProgramTAG]='ES' THEN y.[Boks] ELSE y.[MaxPayrollHours] END
,y.[HoursEntered],
(y.[MaxPayrollHours]-y.[HoursEntered]) AS [Hours_Available],[HoursApproved],
y.[ProgramTAG]
FROM (
SELECT DISTINCT x.[AppId],x.App_Approved,x.[App_CreatedDate],x.[App_ApprovedDate],x.[App_CancellationDate],
x.SchoolDBN, x.CoachID,x.CoachFName,x.CoachLName,x.EmployeeNo,x.Email,--x.[EmailAlias],
x.EISID,x.[Coach_Confirmed],x.[Coach_PE_License],x.[CPRExpDate],x.[CYSExpDate],
x.School_Year,x.Season,x.[Season_Active],x.Season_StartDate,x.Season_EndDate,x.Program_Season,x.[sProgram_Scheduled],x.ProgramId,x.Program_Activity,
x.Program_Status,x.[Campus_Program],x.[Split_Program],x.Session_Type,x.[Program_Sex],

CASE WHEN x.[Split_Program]='Y' THEN x.[MaxPayrollHours]/2 
ELSE x.[MaxPayrollHours] END AS [MaxPayrollHours],
SUM([HoursEntered]) AS [HoursEntered],
ROUND(SUM([HoursApproved]),2) AS [HoursApproved],
x.[ProgramTAG],x.[D75Hours],x.[Boks],x.[Boks_Split]
FROM(
SELECT  DISTINCT app.[AppId],ptg.[ProgramTAG],app.SchoolDBN, c.CoachID,c.CoachFName,c.CoachLName,c.EmployeeNo,c.Email,--REPLACE(SUBSTRING(c.Email,1,(CHARINDEX('@', c.Email))),'@','') AS [EmailAlias],
c.EISID,
CASE WHEN CAST(app.CoachApproved AS CHAR(1))=1 THEN 'Y' ELSE 'N' END AS [Coach_Confirmed],pel.[Coach_PE_License], c.[CPRExpDate],c.[CYSExpDate],s.School_Year,s.Season,
CASE WHEN CAST(s.Active AS CHAR(1))=1 THEN 'Y' ELSE 'N' END AS [Season_Active],s.StartDate AS Season_StartDate,s.EndDate Season_EndDate,(School_Year+'_'+Season) AS Program_Season,
psc.[sProgram_Scheduled],app.ProgramId,a.ActivityDesc AS Program_Activity,ps.[ProgramStatusDesc] AS Program_Status,CASE WHEN CAST(app.[SplitProgram] AS CHAR(1))=1 THEN 'Y' ELSE 'N' END AS [Split_Program],
CASE WHEN CAST(app.[CampusProgram] AS CHAR(1))=1 THEN 'Y' ELSE 'N' END AS [Campus_Program],CASE WHEN CAST(app.Approved AS CHAR(1))=1 THEN 'Y' ELSE 'N' END AS [App_Approved],
app.[CreatedDate] AS [App_CreatedDate],
app.[ApprovedDate] AS [App_ApprovedDate],app.[CancellationDate] AS [App_CancellationDate],ss.[SessionDesc] AS Session_Type,g.[GenderDesc] AS [Program_Sex],pay.[PayPeriodId],
pay.[HoursEntered],pay.[HoursApproved],s.[MaxPayrollHours],s.[D75Hours],s.[Boks],s.[Boks_Split]
FROM dbo.FH_Application app                                            
INNER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId                                   
INNER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
INNER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID                                                  
INNER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
INNER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
INNER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                  
INNER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId
LEFT JOIN  [dbo].[FH_Payroll]  pay ON app.[AppId]=Pay.[AppId] AND pay.CoachID=c.CoachID
LEFT JOIN (SELECT DISTINCT AppID, CASE WHEN AppID IS NOT NULL THEN 'Y' ELSE 'N' END AS [sProgram_Scheduled]  FROM [dbo].[FH_ProgramSchedule])psc ON app.[AppId]=psc.[AppID] 
LEFT JOIN (SELECT app.AppId,pt.[bokCategory] AS [ProgramTAG] FROM [FH_Application] app
INNER JOIN [dbo].[FH_ProgramTag] pt ON app.[programtag]=pt.[bokid]) ptg ON app.[AppId]=ptg.[AppID] 
LEFT JOIN (
SELECT DISTINCT EISID,LIC,LicenseShort,CASE WHEN LIC IS NOT NULL THEN 'Y' ELSE 'N' END AS [Coach_PE_License] FROM [dbo].[FH_CoachLicenses] WHERE [LIC] IN ('418B','AP39','594B','549B','756B')
) pel ON c.[EISID]=pel.[EISID] 
)x 
GROUP BY x.[AppId],x.App_Approved,x.[App_CreatedDate],x.[App_ApprovedDate],x.[App_CancellationDate],[ProgramTAG],
x.SchoolDBN, x.CoachID,x.CoachFName,x.CoachLName,x.EmployeeNo,x.Email,--x.[EmailAlias],
x.EISID,x.Coach_Confirmed,x.[Coach_PE_License],x.[CPRExpDate],x.[CYSExpDate],
x.School_Year,x.Season,x.[Season_Active],x.Season_StartDate,x.Season_EndDate,x.Program_Season,x.[sProgram_Scheduled],x.ProgramId,x.Program_Activity,
x.Program_Status,x.[Split_Program],x.[Campus_Program],x.Session_Type,x.[Program_Sex],
x.[MaxPayrollHours],x.[D75Hours],x.[Boks],x.[Boks_Split]
)y

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [CHAMPS_TRNS_Coach_Programs]
--Table creation code:
IF OBJECT_ID('[CHAMPS_TRNS_Coach_Programs]') IS NOT NULL
DROP TABLE [CHAMPS_TRNS_Coach_Programs]
CREATE TABLE [CHAMPS_TRNS_Coach_Programs]  (
				 [nAppId]								int NULL
				,[sApp_Approved]						char(1) NULL
				,[dtApp_ApprovedDate]					datetime NULL
				,[dtApp_CancellationDate]				datetime NULL
			    ,[sSchoolDBN]							varchar(10) NULL
				,[nCoachID]								int NULL
                ,[sCoachFName]							varchar(30) NULL
                ,[sCoachLName]							varchar(30) NULL
                ,[sEmployeeNo]							char(10) NULL
				,[sEmailAlias]							varchar(20) NULL
				,[sEISID]								varchar(10) NULL
				,[sCoach_Confirmed]						char(1) NULL
				,[Coach_PE_License]						char(1) NULL 
				,[dtCPRExpDate]							smalldatetime NULL 
				,[dtCYSExpDate]							smalldatetime NULL 
							
				,[sSchool_Year]							varchar(9) NULL
				,[sSeason]								varchar(10) NULL
				,[sSeason_Active]						char(1) NULL
				,[dtSeason_StartDate]					datetime NULL
				,[dtSeason_EndDate]						datetime NULL
				,[sProgram_Season]						varchar(25) NULL
				,[sProgram_Scheduled]                   char(1) NULL 
				,[nProgramId]							int NULL
				,[sProgram_Activity]					varchar(100) NULL
				,[sProgram_Status]						varchar(15) NULL
				,[sCampus_Program]						char(1) NULL
				,[sSplit_Program]						char(1) NULL
				,[sSession_Type]						varchar(10) NULL
				,[sProgram_Sex]							varchar(10) NULL
				
				,[nMaxPayrollHours]						int NULL
				,[nAttendance_Hours_Entered]			real NULL
				,[nAttendance_Hours_Available]			real NULL 
				,[nAttendance_Hours_Approved]			real NULL
				,[sProgramTAG]							varchar(50) NULL
				)



--DFT_CHAMPS_TRNS_NumberOfstudents_Program_Coach_School
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.Champs_Int.ChampsUser
--Data access mode: SQL Command
--SQL Command text: 
--To calculate # of students in each program by coach and school

SELECT nstu.[SchoolDBN],nstu.EmployeeNo,nstu.EISID,nstu.EmailAlias,nstu.Program_Activity,nstu.Program_Season,
nstu.[nNumberOfBoys_inRoster],nstu.[nNumberOfGirls_inRoster],nstu.[nNumberOfStudents_inRoster],
nstua.[nNumberOfBoys_Attended],nstua.[nNumberOfGirls_Attended],nstua.[nNumberOfStudents_Attended],
CAST(CAST(nstua.[nNumberOfBoys_Attended] AS decimal(5,2))/CAST(nstu.[nNumberOfBoys_inRoster] AS decimal(5,2))*100 AS decimal(5,2)) AS [nPercentOfBoys_Attended],
CAST(CAST(nstua.[nNumberOfGirls_Attended] AS decimal(5,2))/CAST(nstu.[nNumberOfGirls_inRoster] AS decimal(5,2))*100 AS decimal(5,2)) AS [nPercentOfGirls_Attended],
CAST(CAST(nstua.[nNumberOfStudents_Attended] AS decimal(5,2))/CAST(nstu.[nNumberOfStudents_inRoster] AS decimal(5,2))*100 AS decimal(5,2)) AS [nPercentOfStudents_Attended]
FROM (
SELECT [SchoolDBN],EmployeeNo,EISID,EmailAlias,Program_Activity,Program_Season,[Boy] AS [nNumberOfBoys_inRoster],[Girl] AS [nNumberOfGirls_inRoster]                              
,CAST((Coalesce([boy],0)+Coalesce([Girl],0)) AS FLOAT) AS [nNumberOfStudents_inRoster]

FROM (
SELECT DISTINCT y.[SchoolDBN],y.EmployeeNo,y.EISID,y.EmailAlias,y.Program_Activity,y.Program_Season,y.Student_Sex,COUNT(StudentID) AS [No of Students] 
FROM (
SELECT DISTINCT x.[AppId],x.[SchoolDBN],x.EmployeeNo,x.EISID,x.EmailAlias,x.Program_Activity,x.Program_Season,x.StudentID,
x.[GenderId],CASE WHEN CAST(x.[GenderId] AS VARCHAR(1))=1 THEN 'Boy' WHEN x.[GenderId]=2 THEN 'Girl' ELSE '' END AS Student_Sex, 
CASE WHEN x.StudentID IS NOT NULL THEN 1 ELSE 0 END AS Participated 
FROM (
SELECT  DISTINCT app.[AppId],app.SchoolDBN,c.EmployeeNo,c.EISID,REPLACE(SUBSTRING(c.Email,1,(CHARINDEX('@', c.Email))),'@','') AS [EmailAlias],s.School_Year,s.Season,
(School_Year+'_'+Season) AS Program_Season,app.ProgramId,a.ActivityDesc AS Program_Activity,si.StudentID,si.[GenderId]
FROM dbo.FH_Application app                                            
INNER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId                                                       
INNER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
INNER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID                                                  
INNER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
INNER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
INNER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                  
INNER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId
INNER JOIN [dbo].[FH_StudentInfo] si ON app.AppId=si.AppId AND app.SchoolDBN=si.SchoolDBN 
INNER JOIN dbo.FH_StudentAttendance sa ON si.StudentInfoId=sa.StudentInfoId 
INNER JOIN FH_ClassSession cs ON sa.ClassSessionId = cs.ClassSessionId
LEFT JOIN  [dbo].[FH_Payroll]  pay ON app.[AppId]=Pay.[AppId] AND pay.CoachID=c.CoachID
)x
)y
GROUP BY y.[SchoolDBN],y.EmployeeNo,y.EISID,y.EmailAlias,y.Program_Activity,y.Program_Season,y.Student_Sex
)z
PIVOT
(SUM([No of Students])
FOR [Student_Sex] IN ([Boy],[Girl])
) AS PivotedTable
) nstu
LEFT JOIN (
SELECT [SchoolDBN],EmployeeNo,EISID,EmailAlias,Program_Activity,Program_Season,[Boy] AS [nNumberOfBoys_Attended],[Girl] AS [nNumberOfGirls_Attended]                              
,CAST((Coalesce([boy],0)+Coalesce([Girl],0)) AS FLOAT) AS [nNumberOfStudents_Attended]
FROM (
SELECT DISTINCT y.[SchoolDBN],y.EmployeeNo,y.EISID,y.EmailAlias,y.Program_Activity,y.Program_Season,y.Student_Sex,COUNT(StudentID) AS [No of Students] 
FROM (
SELECT DISTINCT x.[AppId],x.[SchoolDBN],x.EmployeeNo,x.EISID,x.EmailAlias,x.Program_Activity,x.Program_Season,x.StudentID,
x.[GenderId],CASE WHEN CAST(x.[GenderId] AS VARCHAR(1))=1 THEN 'Boy' WHEN x.[GenderId]=2 THEN 'Girl' ELSE '' END AS Student_Sex, 
CASE WHEN x.StudentID IS NOT NULL THEN 1 ELSE 0 END AS Participated 
FROM (
SELECT  DISTINCT app.[AppId],app.SchoolDBN,c.EmployeeNo,c.EISID,REPLACE(SUBSTRING(c.Email,1,(CHARINDEX('@', c.Email))),'@','') AS [EmailAlias],s.School_Year,s.Season,
(School_Year+'_'+Season) AS Program_Season,app.ProgramId,a.ActivityDesc AS Program_Activity,si.StudentID,si.[GenderId]
FROM dbo.FH_Application app                                            
INNER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId                                                       
INNER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
INNER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID                                                  
INNER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
INNER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
INNER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                  
INNER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId
INNER JOIN [dbo].[FH_StudentInfo] si ON app.AppId=si.AppId AND app.SchoolDBN=si.SchoolDBN 
INNER JOIN dbo.FH_StudentAttendance sa ON si.StudentInfoId=sa.StudentInfoId AND sa.Absent <>1 --to get the students who attended
INNER JOIN FH_ClassSession cs ON sa.ClassSessionId = cs.ClassSessionId
LEFT JOIN  [dbo].[FH_Payroll]  pay ON app.[AppId]=Pay.[AppId] AND pay.CoachID=c.CoachID
)x
)y
GROUP BY y.[SchoolDBN],y.EmployeeNo,y.EISID,y.EmailAlias,y.Program_Activity,y.Program_Season,y.Student_Sex
)z
PIVOT
(SUM([No of Students])
FOR [Student_Sex] IN ([Boy],[Girl])
) AS PivotedTable
)nstua 
ON nstu.[SchoolDBN]=nstua.[SchoolDBN] AND nstu.EmployeeNo=nstua.EmployeeNo AND nstu.Program_Activity=nstua.Program_Activity AND nstu.Program_Season=nstua.Program_Season

--Data Conversion:
Input Column		Output Alias			Data Type					Length
[EmailAlias]		EmailAlias_Convert		string [DT_STR]				20

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [CHAMPS_TRNS_NumberOfstudents_Program_Coach_School]
--Table creation code:
IF OBJECT_ID('[CHAMPS_TRNS_NumberOfstudents_Program_Coach_School]') IS NOT NULL
DROP TABLE [CHAMPS_TRNS_NumberOfstudents_Program_Coach_School]
CREATE TABLE [CHAMPS_TRNS_NumberOfstudents_Program_Coach_School]  (
				 [sSchoolDBN]						varchar(10) NULL
				,[sEmployeeNo]						char(10) NULL
				,[sEISID]							varchar(10) NULL
				,[sEmailAlias]						varchar(20) NULL
				,[sProgram_Activity]				varchar(100) NULL
				,[sProgram_Season]					varchar(30) NULL
				,[nNumberOfBoys_inRoster]			int NULL
				,[nNumberOfGirls_inRoster]			int NULL
				,[nNumberOfStudents_inRoster]		int NULL
				,[nNumberOfBoys_Attended]			int NULL
				,[nNumberOfGirls_Attended]			int NULL
				,[nNumberOfStudents_Attended]		int NULL
				,[nPercentOfBoys_Attended]			decimal(5,2) NULL
				,[nPercentOfGirls_Attended]			decimal(5,2) NULL
				,[nPercentOfStudents_Attended]		decimal(5,2) NULL
				)



--DFT_SWHUB_CHAMPS_Coach_Programs
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL Command text: 
SELECT DISTINCT prog.[nAppId],prog.sApp_Approved,prog.[App_CreatedDate],prog.[dtApp_ApprovedDate],prog.[dtApp_CancellationDate],
prog.sSchoolDBN, prog.nCoachID,prog.sCoachFName,prog.sCoachLName,prog.sEmployeeNo,prog.sEmail,--prog.[sEmailAlias],
prog.[sEISID],prog.sCoach_Confirmed,
ccs.[sCoach_Status],ccs.[sLastSeasonCoached],ccs.[sLastActivityCoached],ccs.[sCoaching_DBNS],ccs.[sAttended_Orientation_in4month],ccs.[dtLastAttendedDate],
prog.[dtCPRExpDate],prog.[dtCYSExpDate],[Coach_PE_License],
prog.sSchool_Year,prog.sSeason,prog.sSeason_Active,prog.dtSeason_StartDate,prog.dtSeason_EndDate,
prog.sProgram_Season,prog.sProgram_Scheduled,prog.nProgramId,prog.sProgram_Activity,prog.sProgram_Status,prog.[sCampus_Program],prog.[sSplit_Program],
prog.sSession_Type,prog.[sProgram_Sex],
prog.[nMaxPayrollHours],prog.[nAttendance_Hours_Entered],prog.[nAttendance_Hours_Available],prog.[nAttendance_Hours_Approved],
stu.[nNumberOfBoys_inRoster],stu.[nNumberOfGirls_inRoster],stu.[nNumberOfStudents_inRoster],
stu.[nNumberOfBoys_Attended],stu.[nNumberOfGirls_Attended],stu.[nNumberOfStudents_Attended],
stu.[nPercentOfBoys_Attended],stu.[nPercentOfGirls_Attended],stu.[nPercentOfStudents_Attended],
prog.[sProgramTAG],GETDATE() AS [DataPulledDate]
FROM (
--For Program
SELECT * FROM [CHAMPS_TRNS_Coach_Programs]
)prog

INNER JOIN [SWHUB_CHAMPS_AllYearEligibleSchools_SummaryData] schAll ON prog.[sSchoolDBN]=schAll.[sSchoolDBN] AND CAST(SUBSTRING(prog.[sSchool_Year],1,4) AS int)=[nSchoolYear]

LEFT JOIN (
--To calculate # of students in each program by coach and school
SELECT [sSchoolDBN],sEmployeeNo,sEISID,sEmailAlias,sProgram_Activity,sProgram_Season,[nNumberOfBoys_inRoster],[nNumberOfGirls_inRoster],[nNumberOfStudents_inRoster],
[nNumberOfBoys_Attended],[nNumberOfGirls_Attended],[nNumberOfStudents_Attended],[nPercentOfBoys_Attended],[nPercentOfGirls_Attended],[nPercentOfStudents_Attended]
FROM [CHAMPS_TRNS_NumberOfstudents_Program_Coach_School]
) stu 
ON prog.sSchoolDBN=stu.sSchoolDBN AND prog.sEmployeeNo=stu.sEmployeeNo AND prog.sProgram_Activity=stu.sProgram_Activity AND prog.sProgram_Season=stu.sProgram_Season
LEFT JOIN (
SELECT DISTINCT sSchoolDBN,sEmployeeNo,[sSchool_Year],[sCoach_Status],[sLastSeasonCoached],[sLastActivityCoached],[sCoaching_DBNS],
[sAttended_Orientation_in4month],[dtLastAttendedDate] FROM SWHUB_CHAMPS_CurrentCoach_Status)ccs 
ON prog.sSchoolDBN=ccs.sSchoolDBN AND prog.sEmployeeNo=ccs.sEmployeeNo AND prog.[sSchool_Year]=ccs.[sSchool_Year]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_CHAMPS_Coach_Programs]
--Table creation code:
IF OBJECT_ID('[SWHUB_CHAMPS_Coach_Programs]') IS NOT NULL
DROP TABLE [SWHUB_CHAMPS_Coach_Programs]
CREATE TABLE [SWHUB_CHAMPS_Coach_Programs]  (
				 [nAppId]								int NULL
				,[sApp_Approved]						char(1) NULL
				,[dtApp_ApprovedDate]					datetime NULL
				,[dtApp_CancellationDate]				datetime NULL
			  			  
			    ,[sSchoolDBN]							varchar(10) NULL
				,[nCoachID]								int NULL
                ,[sCoachFName]							varchar(30) NULL
                ,[sCoachLName]							varchar(30) NULL
                ,[sEmployeeNo]							char(10) NULL
				,[sEmailAlias]							varchar(20) NULL
				,[sEISID]								varchar(10) NULL
				,[sCoach_Confirmed]						char(1) NULL
				,[sCoach_Status]                        varchar(50) NULL
				,[sLastSeasonCoached]					varchar(30) NULL
				,[sLastActivityCoached]					varchar(100) NULL
				,[sCoaching_DBNS]						varchar(100) NULL
				,[sAttended_Orientation_in4month]		char(1) NULL
				,[dtLastAttendedDate]					datetime NULL  
				,[dtCPRExpDate]							smalldatetime NULL 
				,[dtCYSExpDate]							smalldatetime NULL 
				,[Coach_PE_License]						char(1) NULL 
								
				,[sSchool_Year]							varchar(9) NULL
				,[sSeason]								varchar(10) NULL
				,[sSeason_Active]						char(1) NULL
				,[dtSeason_StartDate]					datetime NULL
				,[dtSeason_EndDate]						datetime NULL
				,[sProgram_Season]						varchar(25) NULL
				,[sProgram_Scheduled]                   char(1) NULL 
				,[nProgramId]							int NULL
				,[sProgram_Activity]					varchar(100) NULL
				,[sProgram_Status]						varchar(15) NULL
				,[sCampus_Program]						char(1) NULL
				,[sSplit_Program]						char(1) NULL
				,[sSession_Type]						varchar(10) NULL
				,[sProgram_Sex]							varchar(10) NULL
				
				,[nMaxPayrollHours]						int NULL
				,[nAttendance_Hours_Entered]			real NULL
				,[nAttendance_Hours_Available]			real NULL 
				,[nAttendance_Hours_Approved]			real NULL
				
				,[nNumberOfBoys_inRoster]				int NULL      
				,[nNumberOfGirls_inRoster]				int NULL 
				,[nNumberOfStudents_inRoster]			int NULL 
				,[nNumberOfBoys_Attended]				int NULL      
				,[nNumberOfGirls_Attended]				int NULL 
				,[nNumberOfStudents_Attended]			int NULL 
				,[nPercentOfBoys_Attended]				decimal(5,2) NULL    
				,[nPercentOfGirls_Attended]				decimal(5,2) NULL    
				,[nPercentOfStudents_Attended]			decimal(5,2) NULL    
				,[sProgramTAG]							varchar(50) NULL
				,[DataPulledDate]							datetime NULL
				)

--DFT_CHAMPS_TRNS_Students_Programs
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.Champs_Int.ChampsUser
--Data access mode: SQL Command
--SQL Command text:
SELECT at.[AppId],at.SchoolDBN,at.School_Year,at.EmployeeNo,at.Season,at.Program_Season,at.ProgramId,at.Program_Activity,at.[ProgramTAG],
at.StudentID,at.[GenderId] AS [Sex],at.[GradeLevel],at.[SessionDesc],at.[GenderDesc]AS [Program_Sex] 
,CASE WHEN at.[SplitProgram]=0 THEN 'Full' ELSE 'Split' END AS [Program]
,CASE WHEN ab.StudentID IS NOT NULL THEN 1 ELSE 0 END AS [Attended]
,CASE WHEN ab.StudentID IS NULL THEN 1 ELSE 0 END AS [Absent]
FROM 
(SELECT  DISTINCT app.[AppId],app.SchoolDBN,c.EmployeeNo,s.School_Year,s.Season,(School_Year+'_'+Season) AS Program_Season,
app.ProgramId,a.ActivityDesc AS Program_Activity,si.StudentID,si.[GenderId],si.[GradeLevel],app.[SplitProgram],ss.[SessionDesc],g.[GenderDesc],ptg.[ProgramTAG] 
FROM dbo.FH_Application app                                            
INNER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId AND app.Approved=1  AND app.CoachApproved=1                                                           
INNER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
INNER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID                                                  
INNER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
INNER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
INNER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                  
INNER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId
INNER JOIN [dbo].[FH_StudentInfo] si ON app.AppId=si.AppId AND app.SchoolDBN=si.SchoolDBN 
INNER JOIN dbo.FH_StudentAttendance sa ON si.StudentInfoId=sa.StudentInfoId
INNER JOIN FH_ClassSession cs ON sa.ClassSessionId = cs.ClassSessionId
LEFT JOIN (SELECT app.AppId,pt.[bokCategory] AS [ProgramTAG] FROM [FH_Application] app
INNER JOIN [dbo].[FH_ProgramTag] pt ON app.[programtag]=pt.[bokid]) ptg ON app.[AppId]=ptg.[AppID] 

)at
LEFT JOIN (
SELECT  DISTINCT app.[AppId],app.SchoolDBN,c.EmployeeNo,s.School_Year,s.Season,(School_Year+'_'+Season) AS Program_Season,
app.ProgramId,a.ActivityDesc AS Program_Activity,si.StudentID
FROM dbo.FH_Application app                                            
INNER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId AND app.Approved=1  AND app.CoachApproved=1                                                           
INNER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
INNER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID                                                  
INNER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
INNER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
INNER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                  
INNER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId
INNER JOIN [dbo].[FH_StudentInfo] si ON app.AppId=si.AppId AND app.SchoolDBN=si.SchoolDBN 
INNER JOIN dbo.FH_StudentAttendance sa ON si.StudentInfoId=sa.StudentInfoId AND sa.Absent <>1 --to get the students who attended
INNER JOIN FH_ClassSession cs ON sa.ClassSessionId = cs.ClassSessionId
) ab 
ON at.[AppId]=ab.[AppId] AND at.SchoolDBN=ab.SchoolDBN AND at.EmployeeNo=ab.EmployeeNo AND at.School_Year=ab.School_Year AND at.ProgramId=ab.ProgramId AND at.StudentID=ab.StudentID
 
 --OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [CHAMPS_TRNS_Students_Programs]
--Table creation code:
IF OBJECT_ID('[CHAMPS_TRNS_Students_Programs]') IS NOT NULL
DROP TABLE [CHAMPS_TRNS_Students_Programs]
CREATE TABLE [CHAMPS_TRNS_Students_Programs]  (
				 [nAppId]								int NULL
			    ,[sSchoolDBN]							varchar(10) NULL
				,[sSchool_Year]							varchar(9) NULL
                ,[sEmployeeNo]							char(10) NULL
				,[sSeason]								varchar(10) NULL
				,[sProgram_Season]						varchar(25) NULL
				,[nProgramId]							int NULL
				,[sProgram_Activity]					varchar(100) NULL
				,[sProgramTAG]							varchar(50) NULL		
				,[nStudentID]							int NULL
				,[nSex]									tinyint NULL
				,[sGradeLevel]							varchar(2) NULL
				,[sSession_Type]						varchar(10) NULL
				,[sProgram_Sex]							varchar(10) NULL
				,[sProgram]								varchar(10) NULL
				,[nAttended]							int NULL
				,[nAbsent]								int NULL
				)


--DFT_SWHUB_CHAMPS_Students_Programs
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL Command text:
SELECT at.[nAppId],at.sSchool_Year,at.sSchoolDBN,
sch.[sDistrict],sch.[sBorough],
at.sEmployeeNo,at.sSeason,at.sProgram_Season,
at.nProgramId,at.sProgram_Activity,at.[sProgramTAG],at.nStudentID,at.[nSex],at.[sGradeLevel],at.[sSession_Type],at.[sProgram_Sex] 
,[sProgram],[nAttended],[nAbsent] 
FROM CHAMPS_TRNS_Students_Programs at
INNER JOIN [dbo].[SWHUB_CHAMPS_AllYearEligibleSchools_SummaryData] sch
ON at.sSchoolDBN=sch.sSchoolDBN AND CAST(SUBSTRING(at.[sSchool_Year],1,4) AS int)=sch.[nSchoolYear]

 --OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_CHAMPS_Students_Programs]
--Table creation code:
IF OBJECT_ID('[SWHUB_CHAMPS_Students_Programs]') IS NOT NULL
DROP TABLE [SWHUB_CHAMPS_Students_Programs]
CREATE TABLE [SWHUB_CHAMPS_Students_Programs]  (
				 [nAppId]								int NULL
				,[sSchool_Year]							varchar(9) NULL
				,[sSchoolDBN]							varchar(10) NULL
				,[sDistrict]							char(2) NULL
				,[sBorough]								char(1) NULL
				,[sEmployeeNo]							char(10) NULL
				,[sSeason]								varchar(10) NULL
				,[sProgram_Season]						varchar(25) NULL
				,[nProgramId]							int NULL
				,[sProgram_Activity]					varchar(100) NULL
				,[sProgramTAG]							varchar(50) NULL		
				,[nStudentID]							int NULL
				,[nSex]									tinyint NULL
				,[sGradeLevel]							varchar(2) NULL
				,[sSession_Type]						varchar(10) NULL
				,[sProgram_Sex]							varchar(10) NULL
				,[sProgram]								varchar(10) NULL
				,[nAttended]								int NULL
				,[nAbsent]								int NULL
				)


--Sequence Container for Schools
--EST_For CHAMPS Eligible School Level Tasks
Connection:ES11VDEXTESQL01 FGR_INT FGRepUser
SQL Statement:
TRUNCATE TABLE [CHAMPS_TRNS_PayRollSecretary]
GO
TRUNCATE TABLE [CHAMPS_TRNS_NumberOf_FULL_ProgramsInSeason]
GO
TRUNCATE TABLE [CHAMPS_TRNS_NumberOf_SPLIT_ProgramsInSeason]
GO
TRUNCATE TABLE [CHAMPS_TRNS_NumberOf_Unique_Students]
GO
TRUNCATE TABLE [CHAMPS_TRNS_NumberOf_NonUnique_Students]
GO
TRUNCATE TABLE [SWHUB_CHAMPS_EligibleSchools]
GO
TRUNCATE TABLE [SWHUB_CHAMPS_AllYearEligibleSchools_SummaryData]
GO

--DFT_CHAMPS_TRNS_PayRollSecretary
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.Champs_Int.ChampsUser
--Data access mode: SQL Command
--SQL Command text:
SELECT DISTINCT[SchoolDBN],[PayRollSecName],[EmployeeNo] AS [Payroll_Secretary_EmployeeNo],[EISID] AS [Payroll_Secretary_EISID],
[EISUserName] AS [Payroll_Secretary_EISUserName],
[EISEmail] AS [Payroll_Secretary_EISEmail],[UpdatedDate]  FROM [dbo].[FH_SchoolCHAMPS]


--Data Conversion:
Input Column						Output Alias									Data Type					Length
[Payroll_Secretary_EmployeeNo]		Payroll_Secretary_EmployeeNo_Convert			string [DT_STR]				10


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [CHAMPS_TRNS_PayRollSecretary]
--Table creation code:
IF OBJECT_ID('[CHAMPS_TRNS_PayRollSecretary]') IS NOT NULL
DROP TABLE [CHAMPS_TRNS_PayRollSecretary]
CREATE TABLE [CHAMPS_TRNS_PayRollSecretary]  (
		         [sSchoolDBN]							varchar(6) NULL
				,[sPayRollSecName]						varchar(60) NULL
				,[sPayroll_Secretary_EmployeeNo]		char(10) NULL
				,[sPayroll_Secretary_EISID]				varchar(10) NULL
				,[Payroll_Secretary_EISUserName]		varchar(30) NULL
                ,[sPayroll_Secretary_EISEmail]			varchar(50) NULL
				,[dtPayroll_Secretary_UpdatedDate]		datetime NULL
				)

--DFT_CHAMPS_TRNS_NumberOf_FULL_ProgramsInSeason
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.Champs_Int.ChampsUser
--Data access mode: SQL Command
--SQL Command text:
SELECT DISTINCT [SchoolDBN],School_Year,[Fall] AS [nNumberOf_FULL_Programs_inFall] ,[Winter] AS [nNumberOf_FULL_Programs_inWinter],[Spring] AS [nNumberOf_FULL_Programs_inSpring]
FROM(
SELECT  DISTINCT pr.SchoolDBN,pr.School_Year,pr.Season,COUNT(pr.ProgramId) AS [No of Programs]
FROM (
SELECT  DISTINCT prog.SchoolDBN,prog.School_Year,prog.Season,prog.Program_Season,prog.ProgramId,Program_Activity FROM (
SELECT  DISTINCT app.[AppId],app.SchoolDBN,s.SchoolYear,s.School_Year,s.Season,(School_Year+'_'+Season) AS Program_Season,
app.ProgramId,a.ActivityDesc AS Program_Activity,sc.StudentID,sc.[GenderId]
FROM dbo.FH_Application app                                            
INNER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId AND app.Approved=1  AND app.CoachApproved=1 AND app.[SplitProgram]<>1                                                                                                         
INNER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
INNER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID                              
INNER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
INNER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
INNER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                  
INNER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId
LEFT JOIN (
SELECT si.[AppId],si.[SchoolDBN],si.[StudentInfoId],si.StudentID,si.[GenderId] FROM  [dbo].[FH_StudentInfo] si 
INNER JOIN (SELECT * FROM dbo.FH_StudentAttendance WHERE Absent <>1) sa ON si.StudentInfoId=sa.StudentInfoId 
INNER JOIN FH_ClassSession cs ON cs.ClassSessionId = sa.ClassSessionId 
)sc ON app.AppId=sc.AppId AND app.SchoolDBN=sc.SchoolDBN 
)prog
) pr 
GROUP BY pr.SchoolDBN,pr.School_Year,pr.Season
)q
PIVOT
(SUM([No of programs])
FOR Season IN (
[Fall],[Winter],[Spring]) 
) AS PivotedTable
ORDER BY SchoolDBN,School_Year


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [CHAMPS_TRNS_NumberOf_FULL_ProgramsInSeason]
--Table creation code:
IF OBJECT_ID('[CHAMPS_TRNS_NumberOf_FULL_ProgramsInSeason]') IS NOT NULL
DROP TABLE [CHAMPS_TRNS_NumberOf_FULL_ProgramsInSeason]
CREATE TABLE [CHAMPS_TRNS_NumberOf_FULL_ProgramsInSeason]  (
			     [sSchoolDBN]							varchar(6) NULL
				,[School_Year]							varchar(9) NULL
				,[nNumberOf_FULL_Programs_inFall]		int NULL
				,[nNumberOf_FULL_Programs_inWinter]		int NULL
                ,[nNumberOf_FULL_Programs_inSpring]		int NULL
				)

--DFT_CHAMPS_TRNS_NumberOf_SplitProgramsParticipated
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.Champs_Int.ChampsUser
--Data access mode: SQL Command
--SQL Command text:
SELECT DISTINCT [SchoolDBN],School_Year,[Fall] AS [nNumberOf_SPLIT_Programs_inFall],[Winter] AS [nNumberOf_SPLIT_Programs_inWinter],[Spring] AS [nNumberOf_SPLIT_Programs_inSpring]
FROM (
SELECT DISTINCT [SchoolDBN],School_Year,Season,COUNT ([SchoolDBN]) AS NoOfSPLITProgramsParticipated 
FROM 
(SELECT  DISTINCT app.SchoolDBN, s.Season,s.SchoolYear,
(School_Year+'_'+Season) AS Program_Season,s.School_Year,app.ProgramId,a.ActivityDesc,app.[ProgramStatusId], ps.[ProgramStatusDesc],app.[SplitProgram] 
FROM dbo.FH_Application app                                            
INNER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId AND app.Approved=1  AND app.CoachApproved=1     
AND app.[SplitProgram]=1                                                        
INNER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
INNER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID                                     
INNER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
INNER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
INNER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                  
INNER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId 
LEFT JOIN  [dbo].[FH_Payroll]  pay ON app.[AppId]=Pay.[AppId] AND pay.CoachID=c.CoachID
) aa
GROUP BY [SchoolDBN],School_Year,Season
)q
PIVOT
(SUM(NoOfSPLITProgramsParticipated)
FOR Season IN (
[Fall],[Winter],[Spring]) 
) AS PivotedTable 
ORDER BY [SchoolDBN],School_Year

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [CHAMPS_TRNS_NumberOf_SPLIT_ProgramsInSeason]
--Table creation code:
IF OBJECT_ID('[CHAMPS_TRNS_NumberOf_SPLIT_ProgramsInSeason]') IS NOT NULL
DROP TABLE [CHAMPS_TRNS_NumberOf_SPLIT_ProgramsInSeason]
CREATE TABLE [CHAMPS_TRNS_NumberOf_SPLIT_ProgramsInSeason]  (
			     [sSchoolDBN]								varchar(6) NULL
				,[School_Year]								varchar(9) NULL
				,[nNumberOf_SPLIT_Programs_inFall]			int NULL
				,[nNumberOf_SPLIT_Programs_inWinter]		int NULL
				,[nNumberOf_SPLIT_Programs_inSpring]		int NULL
				)


--DFT_CHAMPS_TRNS_NumberOf_Unique_Students
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.Champs_Int.ChampsUser
--Data access mode: SQL Command
--SQL Command text:
SELECT DISTINCT ustu.[SchoolDBN],ustu.[School_Year],ustu.[nNumberOf_Unique_Students_inFall],ustu.[nNumberOf_Unique_Students_inWinter],ustu.[nNumberOf_Unique_Students_inSpring],
ustua.[nNumberOf_Unique_Students_Attended_inFall],ustua.[nNumberOf_Unique_Students_Attended_inWinter],ustua.[nNumberOf_Unique_Students_Attended_inSpring],
CAST(CAST(ustua.[nNumberOf_Unique_Students_Attended_inFall] AS decimal(5,2))/CAST(ustu.[nNumberOf_Unique_Students_inFall] AS decimal(5,2))*100 AS decimal(5,2)) AS [nPercentOf_Unique_Students_Attended_inFall],
CAST(CAST(ustua.[nNumberOf_Unique_Students_Attended_inWinter] AS decimal(5,2))/CAST(ustu.[nNumberOf_Unique_Students_inWinter] AS decimal(5,2))*100 AS decimal(5,2)) AS [nPercentOf_Unique_Students_Attended_inWinter],
CAST(CAST(ustua.[nNumberOf_Unique_Students_Attended_inSpring] AS decimal(5,2))/CAST(ustu.[nNumberOf_Unique_Students_inSpring] AS decimal(5,2))*100 AS decimal(5,2)) AS [nPercentOf_Unique_Students_Attended_inSpring]
FROM (
SELECT DISTINCT [SchoolDBN],School_Year,[Fall] AS [nNumberOf_Unique_Students_inFall],[Winter] AS [nNumberOf_Unique_Students_inWinter],[Spring] AS [nNumberOf_Unique_Students_inSpring]
FROM (
SELECT DISTINCT [SchoolDBN],School_Year,Season,COUNT(StudentID) AS [No of Students]  FROM (
SELECT DISTINCT [SchoolDBN],School_Year,Season,StudentID FROM ( --this step is to get the unique students
SELECT  DISTINCT app.[AppId],app.SchoolDBN,c.EmployeeNo,s.School_Year,s.Season,(School_Year+'_'+Season) AS Program_Season,
app.ProgramId,a.ActivityDesc AS Program_Activity,si.StudentID,si.[GenderId]
FROM dbo.FH_Application app                                            
INNER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId AND app.Approved=1  AND app.CoachApproved=1                                                           
INNER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
INNER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID                                                  
INNER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
INNER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
INNER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                  
INNER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId
INNER JOIN [dbo].[FH_StudentInfo] si ON app.AppId=si.AppId AND app.SchoolDBN=si.SchoolDBN 
INNER JOIN dbo.FH_StudentAttendance sa ON si.StudentInfoId=sa.StudentInfoId
INNER JOIN FH_ClassSession cs ON sa.ClassSessionId = cs.ClassSessionId
LEFT JOIN  [dbo].[FH_Payroll]  pay ON app.[AppId]=Pay.[AppId] AND pay.CoachID=c.CoachID
)a
)r GROUP BY [SchoolDBN],School_Year,Season
)q
PIVOT
(SUM([No of Students])
FOR Season IN (
[Fall],[Winter],[Spring]) 
) AS PivotedTable 
)ustu
LEFT JOIN (
SELECT DISTINCT [SchoolDBN],School_Year,[Fall] AS [nNumberOf_Unique_Students_Attended_inFall],[Winter] AS [nNumberOf_Unique_Students_Attended_inWinter],[Spring] AS [nNumberOf_Unique_Students_Attended_inSpring]
FROM (
SELECT DISTINCT [SchoolDBN],School_Year,Season,COUNT(StudentID) AS [No of Students]  FROM (
SELECT DISTINCT [SchoolDBN],School_Year,Season,StudentID FROM ( --this step is to get the unique students
SELECT  DISTINCT app.[AppId],app.SchoolDBN,c.EmployeeNo,s.School_Year,s.Season,(School_Year+'_'+Season) AS Program_Season,
app.ProgramId,a.ActivityDesc AS Program_Activity,si.StudentID,si.[GenderId]
FROM dbo.FH_Application app                                            
INNER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId AND app.Approved=1  AND app.CoachApproved=1                                                           
INNER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
INNER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID                                                  
INNER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
INNER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
INNER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                  
INNER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId
INNER JOIN [dbo].[FH_StudentInfo] si ON app.AppId=si.AppId AND app.SchoolDBN=si.SchoolDBN 
INNER JOIN dbo.FH_StudentAttendance sa ON si.StudentInfoId=sa.StudentInfoId AND sa.Absent <>1 --to get the students who attended
INNER JOIN FH_ClassSession cs ON sa.ClassSessionId = cs.ClassSessionId
LEFT JOIN  [dbo].[FH_Payroll]  pay ON app.[AppId]=Pay.[AppId] AND pay.CoachID=c.CoachID
)a
)r GROUP BY [SchoolDBN],School_Year,Season
)q
PIVOT
(SUM([No of Students])
FOR Season IN (
[Fall],[Winter],[Spring]) 
) AS PivotedTable
)ustua 
ON ustu.[SchoolDBN]=ustua.[SchoolDBN] AND ustu.[School_Year]=ustua.[School_Year]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [CHAMPS_TRNS_NumberOf_Unique_Students]
--Table creation code:
IF OBJECT_ID('[CHAMPS_TRNS_NumberOf_Unique_Students]') IS NOT NULL
DROP TABLE [CHAMPS_TRNS_NumberOf_Unique_Students]
CREATE TABLE [CHAMPS_TRNS_NumberOf_Unique_Students]  (
			     [sSchoolDBN]										varchar(6) NULL
				,[School_Year]										varchar(9) NULL
				,[nNumberOf_Unique_Students_inFall]					int NULL
				,[nNumberOf_Unique_Students_inWinter]				int NULL
                ,[nNumberOf_Unique_Students_inSpring]				int NULL
				,[nNumberOf_Unique_Students_Attended_inFall]		int NULL
				,[nNumberOf_Unique_Students_Attended_inWinter]		int NULL
                ,[nNumberOf_Unique_Students_Attended_inSpring]		int NULL
				,[nPercentOf_Unique_Students_Attended_inFall]		decimal(5,2) NULL
				,[nPercentOf_Unique_Students_Attended_inWinter]		decimal(5,2) NULL
				,[nPercentOf_Unique_Students_Attended_inSpring]		decimal(5,2) NULL
				)


--DFT_CHAMPS_TRNS_NumberOf_NonUnique_Students
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.Champs_Int.ChampsUser
--Data access mode: SQL Command
--SQL Command text:
SELECT DISTINCT nustu.[SchoolDBN],nustu.[School_Year],nustu.[nNumberOf_NonUnique_Students_inFall],nustu.[nNumberOf_NonUnique_Students_inWinter],nustu.[nNumberOf_NonUnique_Students_inSpring],
nustua.[nNumberOf_NonUnique_Students_Attended_inFall],nustua.[nNumberOf_NonUnique_Students_Attended_inWinter],nustua.[nNumberOf_NonUnique_Students_Attended_inSpring],
CAST(CAST(nustua.[nNumberOf_NonUnique_Students_Attended_inFall] AS decimal(5,2))/CAST(nustu.[nNumberOf_NonUnique_Students_inFall] AS decimal(5,2))*100 AS decimal(5,2)) AS [nPercentOf_NonUnique_Students_Attended_inFall],
CAST(CAST(nustua.[nNumberOf_NonUnique_Students_Attended_inWinter] AS decimal(5,2))/CAST(nustu.[nNumberOf_NonUnique_Students_inWinter] AS decimal(5,2))*100 AS decimal(5,2)) AS [nPercentOf_NonUnique_Students_Attended_inWinter],
CAST(CAST(nustua.[nNumberOf_NonUnique_Students_Attended_inSpring] AS decimal(5,2))/CAST(nustu.[nNumberOf_NonUnique_Students_inSpring] AS decimal(5,2))*100 AS decimal(5,2)) AS [nPercentOf_NonUnique_Students_Attended_inSpring]
FROM (
SELECT DISTINCT [SchoolDBN],School_Year,[Fall] AS [nNumberOf_NonUnique_Students_inFall],[Winter] AS [nNumberOf_NonUnique_Students_inWinter],[Spring] AS [nNumberOf_NonUnique_Students_inSpring]
FROM (
SELECT DISTINCT [SchoolDBN],School_Year,Season,COUNT(StudentID) AS [No of Students]  FROM ( --one step omited here to get the non-unique students
SELECT  DISTINCT app.[AppId],app.SchoolDBN,c.EmployeeNo,s.School_Year,s.Season,(School_Year+'_'+Season) AS Program_Season,
app.ProgramId,a.ActivityDesc AS Program_Activity,si.StudentID,si.[GenderId]
FROM dbo.FH_Application app                                            
INNER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId  AND app.Approved=1  AND app.CoachApproved=1                                                          
INNER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
INNER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID                                                  
INNER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
INNER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
INNER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                  
INNER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId
INNER JOIN [dbo].[FH_StudentInfo] si ON app.AppId=si.AppId AND app.SchoolDBN=si.SchoolDBN 
INNER JOIN dbo.FH_StudentAttendance sa ON si.StudentInfoId=sa.StudentInfoId 
INNER JOIN FH_ClassSession cs ON sa.ClassSessionId = cs.ClassSessionId
LEFT JOIN  [dbo].[FH_Payroll]  pay ON app.[AppId]=Pay.[AppId] AND pay.CoachID=c.CoachID
)r GROUP BY [SchoolDBN],School_Year,Season
)q
PIVOT
(SUM([No of Students])
FOR Season IN (
[Fall],[Winter],[Spring]) 
) AS PivotedTable 
)nustu
LEFT JOIN (
SELECT DISTINCT [SchoolDBN],School_Year,[Fall] AS [nNumberOf_NonUnique_Students_Attended_inFall],[Winter] AS [nNumberOf_NonUnique_Students_Attended_inWinter],[Spring] AS [nNumberOf_NonUnique_Students_Attended_inSpring]
FROM (
SELECT DISTINCT [SchoolDBN],School_Year,Season,COUNT(StudentID) AS [No of Students]  FROM ( --one step omited here to get the non-unique students
SELECT  DISTINCT app.[AppId],app.SchoolDBN,c.EmployeeNo,s.School_Year,s.Season,(School_Year+'_'+Season) AS Program_Season,
app.ProgramId,a.ActivityDesc AS Program_Activity,si.StudentID,si.[GenderId]
FROM dbo.FH_Application app                                            
INNER JOIN dbo.FH_Programs p ON app.ProgramId = p.ProgramId  AND app.Approved=1  AND app.CoachApproved=1                                                          
INNER JOIN dbo.FH_Activities a ON a.ActivityId = p.ActivityId                                                               
INNER JOIN dbo.FH_Seasons s ON p.SeasonID = s.SeasonID                                                  
INNER JOIN dbo.FH_Coach c ON c.CoachId = app.CoachId                                               
INNER JOIN dbo.FH_Gender g ON app.GenderID = g.GenderID                                                                
INNER JOIN dbo.FH_Session ss ON app.SessionID = ss.SessionID                                  
INNER JOIN dbo.FH_ProgramStatus ps ON app.ProgramStatusId = ps.ProgramStatusId
INNER JOIN [dbo].[FH_StudentInfo] si ON app.AppId=si.AppId AND app.SchoolDBN=si.SchoolDBN 
INNER JOIN dbo.FH_StudentAttendance sa ON si.StudentInfoId=sa.StudentInfoId AND sa.Absent <>1 --to get the students who attended
INNER JOIN FH_ClassSession cs ON sa.ClassSessionId = cs.ClassSessionId
LEFT JOIN  [dbo].[FH_Payroll]  pay ON app.[AppId]=Pay.[AppId] AND pay.CoachID=c.CoachID
)r GROUP BY [SchoolDBN],School_Year,Season
)q
PIVOT
(SUM([No of Students])
FOR Season IN (
[Fall],[Winter],[Spring]) 
) AS PivotedTable
)nustua ON nustu.[SchoolDBN]=nustua.[SchoolDBN] AND nustu.[School_Year]=nustua.[School_Year]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [CHAMPS_TRNS_NumberOf_NonUnique_Students]
--Table creation code:
IF OBJECT_ID('[CHAMPS_TRNS_NumberOf_NonUnique_Students]') IS NOT NULL
DROP TABLE [CHAMPS_TRNS_NumberOf_NonUnique_Students]
CREATE TABLE [CHAMPS_TRNS_NumberOf_NonUnique_Students]  (
			     [sSchoolDBN]											varchar(6) NULL
				,[School_Year]											varchar(9) NULL
				,[nNumberOf_NonUnique_Students_inFall]					int NULL
				,[nNumberOf_NonUnique_Students_inWinter]				int NULL
                ,[nNumberOf_NonUnique_Students_inSpring]				int NULL
				,[nNumberOf_NonUnique_Students_Attended_inFall]			int NULL
				,[nNumberOf_NonUnique_Students_Attended_inWinter]		int NULL
                ,[nNumberOf_NonUnique_Students_Attended_inSpring]		int NULL
				,[nPercentOf_NonUnique_Students_Attended_inFall]		decimal(5,2) NULL
				,[nPercentOf_NonUnique_Students_Attended_inWinter]		decimal(5,2) NULL
				,[nPercentOf_NonUnique_Students_Attended_inSpring]		decimal(5,2) NULL
				)


--DFT_SWHUB_CHAMPS_AllYearEligibleSchools_SummaryData
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL Command text:
SELECT sch.[nSchoolYear],sch.[Fiscal_Year] AS [nFiscal_Year],[SchoolDBN] AS [sSchoolDBN],sch.Location_Name_Long AS [sSchool_Name],sch.Administrative_District_Code AS sDistrict,sch.[Borough] AS [sBorough],
sch.[Location_Type_Description] AS [sLocation_Type_Description],sch.[Location_Category_Description] AS [sLocation_Category_Description],sch.[Grades_Text] AS [sGrades_Served],sch.[Principal_Name] AS [sPrincipal_Name],sch.[Principal_Email] AS [sPrincipal_Email],
sch.Principal_Phone_Number AS sPrincipal_Phone_Number,sch.Field_Support_Center_Name AS [sField_Support_Center_Name],
pay.[sPayRollSecName],pay.[sPayroll_Secretary_EmployeeNo],pay.[sPayroll_Secretary_EISID],[Payroll_Secretary_EISUserName],[sPayroll_Secretary_EISEmail],[dtPayroll_Secretary_UpdatedDate],sd.[Total_Students_Enrolled] AS [nSchool_Enrollment],
nfp.[nNumberOf_FULL_Programs_inFall],nfp.[nNumberOf_FULL_Programs_inWinter],nfp.[nNumberOf_FULL_Programs_inSpring],
nsp.[nNumberOf_SPLIT_Programs_inFall],nsp.[nNumberOf_SPLIT_Programs_inWinter],nsp.[nNumberOf_SPLIT_Programs_inSpring]

,us.[nNumberOf_Unique_Students_inFall],us.[nNumberOf_Unique_Students_inWinter],us.[nNumberOf_Unique_Students_inSpring]
,us.[nNumberOf_Unique_Students_Attended_inFall],us.[nNumberOf_Unique_Students_Attended_inWinter],us.[nNumberOf_Unique_Students_Attended_inSpring]
,us.[nPercentOf_Unique_Students_Attended_inFall],us.[nPercentOf_Unique_Students_Attended_inWinter],us.[nPercentOf_Unique_Students_Attended_inSpring]

,nus.[nNumberOf_NonUnique_Students_inFall],nus.[nNumberOf_NonUnique_Students_inWinter],nus.[nNumberOf_NonUnique_Students_inSpring]
,nus.[nNumberOf_NonUnique_Students_Attended_inFall],nus.[nNumberOf_NonUnique_Students_Attended_inWinter],nus.[nNumberOf_NonUnique_Students_Attended_inSpring]
,nus.[nPercentOf_NonUnique_Students_Attended_inFall],nus.[nPercentOf_NonUnique_Students_Attended_inWinter],nus.[nPercentOf_NonUnique_Students_Attended_inSpring],GETDATE() AS [DataPulledDate]
FROM (SELECT DISTINCT [Fiscal_Year],([Fiscal_Year]-1)AS [nSchoolYear],[SchoolDBN],Location_Name_Long,Administrative_District_Code,[Borough],[Location_Type_Description],[Location_Category_Description],[Grades_Text],[Principal_Name],[Principal_Email],Principal_Phone_Number,Field_Support_Center_Name 
FROM (
SELECT  Fiscal_Year,CAST([System_Code] AS CHAR(6)) AS SchoolDBN,Location_Name_Long, Location_Category_Code,Location_Category_Description,[Grades_Text], Location_Type_Code, Location_Type_Description, 
		Administrative_District_Code,SUBSTRING(System_Code,3,1) AS [Borough],Primary_Building_Code,Principal_Name,Principal_Phone_Number, [Principal_Email],
		COALESCE (Primary_Address_Line_1, '') + ' ' + COALESCE (Primary_Address_Line_2, '') + ' ' + COALESCE (Primary_Address_Line_3, '') AS School_Address, City, State_Code, Zip, 
		Field_Support_Center_Location_code,Field_Support_Center_Name

FROM  SUPERLINK.Supertable.dbo.Location_Supertable1 
WHERE  	System_ID = 'ats' 
		AND Location_Type_Description IN ('General Academic', 'Special Education', 'Career Technical', 'Transfer School')  
		AND Status_Code = 'O' AND Administrative_District_Code IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32') 
		AND Location_Category_Description <> 'Borough' AND Location_Category_Description <> 'Central-HQ-Citywide' AND (SUBSTRING(System_Code, 4, 3) <> '444') 
		AND SUBSTRING(System_Code, 4, 3) <> '700' AND Location_Name <> 'Universal Pre-K C.B.O.' AND Location_Type_Description <> 'Home School' 
		AND Location_Type_Description <> 'Adult' AND Location_Type_Description <> 'Alternative' AND Location_Type_Description <> 'Evening'
		AND Location_Type_Description <> 'Suspension Center' AND Location_Type_Description <> 'YABC' AND Grades_Text <> ''
		AND Location_Category_Description in ('Early Childhood','Elementary','K-8','Junior High-Intermediate-Middle','Secondary School','K-12 all grades')

--only elementary and middle school grades from district 1 to 32 

UNION
SELECT  Fiscal_Year,CAST([System_Code] AS CHAR(6)) AS SchoolDBN,Location_Name_Long, Location_Category_Code,Location_Category_Description,[Grades_Text], Location_Type_Code, Location_Type_Description, 
		Administrative_District_Code,SUBSTRING(System_Code,3,1) AS [Borough],Primary_Building_Code,Principal_Name,Principal_Phone_Number, [Principal_Email],
		COALESCE (Primary_Address_Line_1, '') + ' ' + COALESCE (Primary_Address_Line_2, '') + ' ' + COALESCE (Primary_Address_Line_3, '') AS School_Address, City, State_Code, Zip, 
		Field_Support_Center_Location_code,Field_Support_Center_Name
		FROM  SUPERLINK.Supertable.dbo.Location_Supertable1 
WHERE   System_ID = 'ats' 
		AND Location_Type_Description IN ('General Academic', 'Special Education', 'Career Technical', 'Transfer School')  
		AND Status_Code = 'O' AND Administrative_District_Code IN ('75') 
		AND Location_Category_Description <> 'Borough' AND Location_Category_Description <> 'Central-HQ-Citywide' AND (SUBSTRING(System_Code, 4, 3) <> '444') 
		AND SUBSTRING(System_Code, 4, 3) <> '700' AND Location_Name <> 'Universal Pre-K C.B.O.' AND Location_Type_Description <> 'Home School' 
		AND Location_Type_Description <> 'Adult' AND Location_Type_Description <> 'Alternative' AND Location_Type_Description <> 'Evening'
		AND Location_Type_Description <> 'Suspension Center' AND Location_Type_Description <> 'YABC' AND Grades_Text <> ''
	
----All school grades from district 75
) aa
)sch
LEFT JOIN [dbo].[CHAMPS_TRNS_PayRollSecretary] pay ON sch.[SchoolDBN]=pay.[sSchoolDBN]
LEFT JOIN [dbo].[CHAMPS_TRNS_NumberOf_FULL_ProgramsInSeason] nfp ON sch.[SchoolDBN]=nfp.[sSchoolDBN] AND sch.[nSchoolYear]=CAST(SUBSTRING(nfp.[School_Year],1,4) AS int)
LEFT JOIN [dbo].[CHAMPS_TRNS_NumberOf_SPLIT_ProgramsInSeason] nsp ON sch.[SchoolDBN]=nsp.[sSchoolDBN] AND sch.[nSchoolYear]=CAST(SUBSTRING(nsp.[School_Year],1,4) AS int)
LEFT JOIN [dbo].[CHAMPS_TRNS_NumberOf_Unique_Students] us ON sch.[SchoolDBN]=us.[sSchoolDBN] AND sch.[nSchoolYear]=CAST(SUBSTRING(us.[School_Year],1,4) AS int)
LEFT JOIN [dbo].[CHAMPS_TRNS_NumberOf_NonUnique_Students] nus ON sch.[SchoolDBN]=nus.[sSchoolDBN] AND sch.[nSchoolYear]=CAST(SUBSTRING(nus.[School_Year],1,4) AS int)
LEFT JOIN [dbo].[SWHUB_Supertable_Schools Dimension] sd  ON sch.[SchoolDBN]=sd.[System_Code] AND sch.[nSchoolYear]=sd.[Fiscal_Year]-1

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_CHAMPS_AllYearEliginleSchools_SummaryData]
--Table creation code:
IF OBJECT_ID('[SWHUB_CHAMPS_AllYearEliginleSchools_SummaryData]') IS NOT NULL
DROP TABLE [SWHUB_CHAMPS_AllYearEliginleSchools_SummaryData]
CREATE TABLE [SWHUB_CHAMPS_AllYearEliginleSchools_SummaryData] (
                 [nSchoolYear]										int NULL
				,[nFiscal_Year]										int NULL
				,[sSchoolDBN]										varchar(6) NULL
				,[sSchool_Name]										varchar(50) NULL
				,[sDistrict]										char(2) NULL
				,[sBorough]											char(1) NULL
			    ,[sLocation_Type_Description]						varchar(100) NULL
                ,[sLocation_Category_Description]					varchar(100) NULL
                ,[sGrades_Served]									varchar(100) NULL
                ,[sPrincipal_Name]									varchar(100) NULL
                ,[sPrincipal_Email]									varchar(100) NULL   
				,[sPrincipal_Phone_Number]							varchar(15) NULL    
				,[sField_Support_Center_Name]						varchar(100) NULL
				
				,[sPayRollSecName]									varchar(60) NULL 
				,[sPayroll_Secretary_EmployeeNo]					char(10) NULL 
				,[sPayroll_Secretary_EISID]							varchar(10) NULL 
				,[sPayroll_Secretary_EISUserName]					varchar(30)	NULL 
				,[sPayroll_Secretary_EISEmail]						varchar(50)	NULL 
				,[dtPayroll_Secretary_UpdatedDate]					datetime NULL
				,[nSchool_Enrollment]								int NULL


				,[nNumberOf_FULL_Programs_inFall]					int NULL
				,[nNumberOf_FULL_Programs_inWinter]					int NULL
                ,[nNumberOf_FULL_Programs_inSpring]					int NULL

				,[nNumberOf_SPLIT_Programs_inFall]					int NULL
				,[nNumberOf_SPLIT_Programs_inWinter]				int NULL
                ,[nNumberOf_SPLIT_Programs_inSpring]				int NULL

				,[nNumberOf_Unique_Students_inFall]					int NULL 
				,[nNumberOf_Unique_Students_inWinter]				int NULL 
				,[nNumberOf_Unique_Students_inSpring]				int NULL 

				,[nNumberOf_Unique_Students_Attended_inFall]		int NULL 
				,[nNumberOf_Unique_Students_Attended_inWinter]		int NULL 
				,[nNumberOf_Unique_Students_Attended_inSpring]		int NULL 

				,[nPercentOf_Unique_Students_Attended_inFall]		decimal(5,2) NULL 
				,[nPercentOf_Unique_Students_Attended_inWinter]		decimal(5,2) NULL 
				,[nPercentOf_Unique_Students_Attended_inSpring]		decimal(5,2) NULL 

				,[nNumberOf_NonUnique_Students_inFall]				int NULL 
				,[nNumberOf_NonUnique_Students_inWinter]			int NULL 
				,[nNumberOf_NonUnique_Students_inSpring]			int NULL 

				,[nNumberOf_NonUnique_Students_Attended_inFall]		int NULL 
				,[nNumberOf_NonUnique_Students_Attended_inWinter]	int NULL 
				,[nNumberOf_NonUnique_Students_Attended_inSpring]	int NULL 

				,[nPercentOf_NonUnique_Students_Attended_inFall]	decimal(5,2) NULL 
				,[nPercentOf_NonUnique_Students_Attended_inWinter]	decimal(5,2) NULL 
				,[nPercentOf_NonUnique_Students_Attended_inSpring]	decimal(5,2) NULL
				,[DataPulledDate]										datetime NULL 
	)


--Outside of the sequence Container
--DFT_SWHUB_CHAMPS_Search
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL Command text:
SELECT DISTINCT a.sSchool_Year,a.sSeason,a.[nAppId],a.sApp_Approved,a.[dtApp_CreatedDate],a.[dtApp_ApprovedDate],a.[dtApp_CancellationDate],

a.sSchoolDBN,sch.[sSchool_Name],sch.[sDistrict],sch.[sBorough],sch.[sField_Support_Center_Name],sch.[sLocation_Type_Description],sch.[sLocation_Category_Description],sch.[sGrades_Served],
sch.[sPrincipal_Name],sch.[sPrincipal_Email],sch.[sPrincipal_Phone_Number],sch.[sPayRollSecName],sch.[sPayroll_Secretary_EmployeeNo],sch.[sPayroll_Secretary_EISID],sch.[sPayroll_Secretary_EISUserName],sch.[sPayroll_Secretary_EISEmail],
sch.[dtPayroll_Secretary_UpdatedDate],sch.[nSchool_Enrollment],

a.nCoachID,a.sCoachFName,a.sCoachLName,a.sEmployeeNo,a.sEmail,--a.[sEmailAlias],
a.[sEISID],a.sCoach_Confirmed,ccs.[sCoach_Status],ccs.[sLastSeasonCoached],
ccs.[sLastActivityCoached],ccs.[sCoaching_DBNS],ccs.[sAttended_Orientation_in4month],ccs.[dtLastAttendedDate],a.[dtCPRExpDate],a.[dtCYSExpDate],
--a.[Coach_PE_License],  --this is considered only primary license and got from champs databse table
peli.[Coach_PE_License],  --this is considered both primary and secondary license
a.sSeason_Active,a.dtSeason_StartDate,a.dtSeason_EndDate,

a.[sProgram_Scheduled],a.nProgramId,a.sProgram_Activity,a.sProgram_Status,a.sProgram_Season,a.[sCampus_Program],a.[sSplit_Program],
a.sSession_Type,a.[sProgram_Sex],
a.[nMaxPayrollHours],a.[nAttendance_Hours_Entered],a.[nAttendance_Hours_Available],a.[nAttendance_Hours_Approved],
a.[nNumberOfBoys_inRoster],a.[nNumberOfGirls_inRoster],a.[nNumberOfStudents_inRoster],
a.[nNumberOfBoys_Attended],a.[nNumberOfGirls_Attended],a.[nNumberOfStudents_Attended],
a.[nPercentOfBoys_Attended],a.[nPercentOfGirls_Attended],a.[nPercentOfStudents_Attended],
a.[sProgramTAG],

sch.[nNumberOf_FULL_Programs_inFall],sch.[nNumberOf_FULL_Programs_inWinter],sch.[nNumberOf_FULL_Programs_inSpring],
sch.[nNumberOf_SPLIT_Programs_inFall],sch.[nNumberOf_SPLIT_Programs_inWinter],sch.[nNumberOf_SPLIT_Programs_inSpring]
,sch.[nNumberOf_Unique_Students_inFall],sch.[nNumberOf_Unique_Students_inWinter],sch.[nNumberOf_Unique_Students_inSpring]
,sch.[nNumberOf_Unique_Students_Attended_inFall],sch.[nNumberOf_Unique_Students_Attended_inWinter],sch.[nNumberOf_Unique_Students_Attended_inSpring]
,sch.[nPercentOf_Unique_Students_Attended_inFall],sch.[nPercentOf_Unique_Students_Attended_inWinter],sch.[nPercentOf_Unique_Students_Attended_inSpring]
,sch.[nNumberOf_NonUnique_Students_inFall],sch.[nNumberOf_NonUnique_Students_inWinter],sch.[nNumberOf_NonUnique_Students_inSpring]
,sch.[nNumberOf_NonUnique_Students_Attended_inFall],sch.[nNumberOf_NonUnique_Students_Attended_inWinter],sch.[nNumberOf_NonUnique_Students_Attended_inSpring]
,sch.[nPercentOf_NonUnique_Students_Attended_inFall],sch.[nPercentOf_NonUnique_Students_Attended_inWinter],sch.[nPercentOf_NonUnique_Students_Attended_inSpring]
,GETDATE() AS [DataPulledDate]

FROM [dbo].[SWHUB_CHAMPS_Coach_Programs] a
INNER JOIN [dbo].[SWHUB_CHAMPS_AllYearEligibleSchools_SummaryData] sch ON CAST(SUBSTRING(a.[sSchool_Year],1,4) AS int)=sch.[nSchoolYear] AND a.sSchoolDBN=sch.sSchoolDBN  
LEFT JOIN [dbo].[SWHUB_CHAMPS_CurrentCoach_Status] ccs ON a.[sSchoolDBN]=ccs.[sSchoolDBN] AND a.[sSchool_Year]=ccs.[sSchool_Year] AND 
a.[sEmployeeNo]=ccs.[sEmployeeNo] AND a.sProgram_Season=(ccs.sSchool_Year+'_'+ccs.sSeason)

LEFT JOIN ( --For coach PE license: Included primary and secondary licenses 
SELECT DISTINCT sEmployeeNo,sEmail,sLicenceCode,'Y' AS [Coach_PE_License] FROM SWHUB_TblStaffData WHERE 
sLicenceCode IN ('418B','AP39','594B','549B','756B') OR 
([SecondaryLicenseCode] LIKE '%418B%' OR [SecondaryLicenseCode] LIKE '%AP39%' OR [SecondaryLicenseCode] LIKE '%594B%' OR [SecondaryLicenseCode] LIKE '%549B%' OR [SecondaryLicenseCode] LIKE '%756B%')
)peli ON a.[sEmployeeNo]=peli.sEmployeeNo

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_CHAMPS_Search]
--Table creation code:
IF OBJECT_ID('[SWHUB_CHAMPS_Search]') IS NOT NULL
DROP TABLE [SWHUB_CHAMPS_Search]
CREATE TABLE [SWHUB_CHAMPS_Search]  (
--Below section's fields are for application information
[sSchool_Year]										varchar(9) NULL 
,[sSeason]											varchar(10) NULL 
,[nAppId]											int NULL 
,[sApp_Approved]									char(1) NULL 
,[dtApp_ApprovedDate]								datetime NULL 
,[dtApp_CancellationDate]							datetime NULL 

--Below section's fields are for school information
,[sSchoolDBN]										varchar(10) NULL 
,[sSchool_Name]										varchar(50) NULL
,[sDistrict]										char(2) NULL
,[sBorough]											char(1) NULL
,[sField_Support_Center_Name]						varchar(100) NULL
,[sLocation_Type_Description]						varchar(100) NULL
,[sLocation_Category_Description]					varchar(100) NULL
,[sGrades_Served]									varchar(100) NULL
,[sPrincipal_Name]									varchar(100) NULL
,[sPrincipal_Email]									varchar(100) NULL      
,[sPrincipal_Phone_Number]							varchar(15) NULL    
,[sPayRollSecName]									varchar(60) NULL 
,[sPayroll_Secretary_EmployeeNo]					char(10) NULL 
,[sPayroll_Secretary_EISID]							varchar(10) NULL 
,[sPayroll_Secretary_EISUserName]					varchar(30)	NULL 
,[sPayroll_Secretary_EISEmail]						varchar(50)	NULL 
,[dtPayroll_Secretary_UpdatedDate]					datetime NULL
,[nSchool_Enrollment]								int NULL
				
--Below section's fields are for coach level data				
,[nCoachID]											int NULL 
,[sCoachFName]										varchar(30) NULL 
,[sCoachLName]										varchar(30) NULL 
,[sEmployeeNo]										char(10) NULL 
,[sEmailAlias]										varchar(20) NULL 
,[sEISID]											varchar(10) NULL 
,[sCoach_Confirmed]									char(1) NULL 
,[sCoach_Status]									varchar(50) NULL
,[sLastSeasonCoached]								varchar(30) NULL
,[sLastActivityCoached]								varchar(100) NULL
,[sCoaching_DBNS]									varchar(100) NULL
,[sAttended_Orientation_in4month]					char(1) NULL
,[dtLastAttendedDate]								datetime NULL  
,[dtCPRExpDate]										smalldatetime NULL 
,[dtCYSExpDate]										smalldatetime NULL 
,[Coach_PE_License]									char(1) NULL 
,[sSeason_Active]									char(1) NULL 
,[dtSeason_StartDate]								datetime NULL 
,[dtSeason_EndDate]									datetime NULL 
				
--Below section's fields are for program level data
,[sProgram_Scheduled]								char(1) NULL 
,[nProgramId]										int NULL 
,[sProgram_Activity]								varchar(100) NULL 
,[sProgram_Status]									varchar(15) NULL 
,[sProgram_Season]									varchar(25) NULL 
,[sCampus_Program]									char(1) NULL 
,[sSplit_Program]									char(1) NULL 
,[sSession_Type]									varchar(10) NULL 
,[sProgram_Sex]										varchar(10) NULL 
,[nMaxPayrollHours]									int NULL 
,[nAttendance_Hours_Entered]						real NULL 
,[nAttendance_Hours_Available]						real NULL 
,[nAttendance_Hours_Approved]						real NULL
,[nNumberOfBoys_inRoster]							int NULL 	
,[nNumberOfGirls_inRoster]							int NULL 
,[nNumberOfStudents_inRoster]						int NULL 
,[nNumberOfBoys_Attended]							int NULL 	
,[nNumberOfGirls_Attended]							int NULL 
,[nNumberOfStudents_Attended]						int NULL 
,[nPercentOfBoys_Attended]							decimal(5,2) NULL 	
,[nPercentOfGirls_Attended]							decimal(5,2) NULL 
,[nPercentOfStudents_Attended]						decimal(5,2) NULL 
,[sProgramTAG]										varchar(50) NULL			   

--Below section's fields are for school level data
,[nNumberOf_FULL_Programs_inFall]					int NULL 
,[nNumberOf_FULL_Programs_inWinter]					int NULL 
,[nNumberOf_FULL_Programs_inSpring]					int NULL 

,[nNumberOf_SPLIT_Programs_inFall]					int NULL 
,[nNumberOf_SPLIT_Programs_inWinter]				int NULL 
,[nNumberOf_SPLIT_Programs_inSpring]				int NULL 

,[nNumberOf_Unique_Students_inFall]					int NULL 
,[nNumberOf_Unique_Students_inWinter]				int NULL 
,[nNumberOf_Unique_Students_inSpring]				int NULL 

,[nNumberOf_Unique_Students_Attended_inFall]		int NULL 
,[nNumberOf_Unique_Students_Attended_inWinter]		int NULL 
,[nNumberOf_Unique_Students_Attended_inSpring]		int NULL 

,[nPercentOf_Unique_Students_Attended_inFall]		decimal(5,2) NULL 
,[nPercentOf_Unique_Students_Attended_inWinter]		decimal(5,2) NULL 
,[nPercentOf_Unique_Students_Attended_inSpring]		decimal(5,2) NULL 

,[nNumberOf_NonUnique_Students_inFall]				int NULL 
,[nNumberOf_NonUnique_Students_inWinter]			int NULL 
,[nNumberOf_NonUnique_Students_inSpring]			int NULL 

,[nNumberOf_NonUnique_Students_Attended_inFall]		int NULL 
,[nNumberOf_NonUnique_Students_Attended_inWinter]	int NULL 
,[nNumberOf_NonUnique_Students_Attended_inSpring]	int NULL 

,[nPercentOf_NonUnique_Students_Attended_inFall]	decimal(5,2) NULL 
,[nPercentOf_NonUnique_Students_Attended_inWinter]	decimal(5,2) NULL 
,[nPercentOf_NonUnique_Students_Attended_inSpring]	decimal(5,2) NULL 
,[DataPulledDate]									datetime NULL
)




--Variables for this Package:

Name			Scope						Data type			Value
PackageID		Package 12_Champs 			Int32				12


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
VALUES (12,'Package 12_CHAMPS')