--Sequence Container for Execute SQL Task
--EST_Delete data from destination tables
Connection: ES11VDEXTESQL01 FGR_INT FGRepUser
SQL Statement: 
TRUNCATE TABLE [STARS_TRNS_CourseSection]
GO
TRUNCATE TABLE [STARS_TRNS_CourseSection_StudentEnrollment]
GO
TRUNCATE TABLE [STARS_TRNS_MSR_PrimaryTeacher]
GO
TRUNCATE TABLE [STARS_TRNS_CourseSection_Teacher_Enrollment]
GO
TRUNCATE TABLE [STARS_TRNS_MSR_SeconderyTeacher]
GO
TRUNCATE TABLE [STARS_TRNS_Scheduling_ByStudentAndTeacher]
GO
TRUNCATE TABLE [STARS_TRNS_RefSchedulingMethod] 
GO
TRUNCATE TABLE [STARS_TRNS_RefTeacherType] 
GO

--EST_INSERT INTO STARS_TRNS_RefSchedulingMethod
Connection: ES11VDEXTESQL01 FGR_INT FGRepUser
SQL Statement: 
INSERT INTO [STARS_TRNS_RefSchedulingMethod] VALUES (1,'MasterSchedule')
INSERT INTO [STARS_TRNS_RefSchedulingMethod] VALUES (2,'OC')
INSERT INTO [STARS_TRNS_RefSchedulingMethod] VALUES (3,'Push-In')
INSERT INTO [STARS_TRNS_RefSchedulingMethod] VALUES (4,'Pull-Out')
INSERT INTO [STARS_TRNS_RefSchedulingMethod] VALUES (5,'ERROR')
INSERT INTO [STARS_TRNS_RefSchedulingMethod] VALUES (6,'ISP')
INSERT INTO [STARS_TRNS_RefSchedulingMethod] VALUES (7,'NoSchedule')

--Table creation code
USE FGR_INT
IF OBJECT_ID('[STARS_TRNS_RefSchedulingMethod]') IS NOT NULL
	DROP TABLE [STARS_TRNS_RefSchedulingMethod]
CREATE TABLE [STARS_TRNS_RefSchedulingMethod] (
	[SchedulingMethodID] INT
	,[Description] VARCHAR(50)
)




--EST_INSERT INTO STARS_TRNS_RefTeacherType
Connection: ES11VDEXTESQL01 FGR_INT FGRepUser
SQL Statement: 
INSERT INTO [STARS_TRNS_RefTeacherType] VALUES (1,'Ambiguous')
INSERT INTO [STARS_TRNS_RefTeacherType] VALUES (2,'Primary Teacher')
INSERT INTO [STARS_TRNS_RefTeacherType] VALUES (3,'Secondary Teacher')

--Table creation code
USE FGR_INT
IF OBJECT_ID('[STARS_TRNS_RefTeacherType]') IS NOT NULL
	DROP TABLE [STARS_TRNS_RefTeacherType]
CREATE TABLE [STARS_TRNS_RefTeacherType] (
	[TeacherTypeID] INT
	,[Description] VARCHAR(50)
)

--Sequence Container_MS and HS Scheduling

--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
DECLARE @SY INT; 
SET @SY = CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END; 
SELECT DISTINCT
	[ms].[NumericSchoolDBN]
	,[ms].[SchoolYear]
	,[ms].[TermID]
	,[ms].[CourseCode]
	,[ms].[SectionId]
	,CASE WHEN [time].[AvgMinWeek] IS NULL THEN 0 ELSE [time].[AvgMinWeek] END AS 'MinutesPerWeek'
	,1 AS 'SchedulingMethodID'
	,NULL AS [SP_MTI_DaysPerWeek]
	,0 AS [SP_MTI_IsMTI]
	,NULL AS [SP_MTI_MinPerWeek]
	,[ms].TeachingPersonnelTermId
	--INTO #CourseSection
FROM
	[dbo].[STARS_Stg_MasterScheduleReport] [ms] (NOLOCK)
	JOIN
		[dbo].[STARS_Stg_Section] [sec] (NOLOCK)
		ON [sec].[NumericSchoolDBN] = [ms].[NumericSchoolDBN]
		AND [sec].[SchoolYear] = [ms].[SchoolYear]
		AND [sec].[TermID] = [ms].[TermID]
		AND [sec].[CourseCode] = [ms].[CourseCode]
		AND [sec].[SectionID] = [ms].[SectionID]
	
	LEFT OUTER JOIN
		(SELECT 
				msl.NumericSchoolDBN,
				msl.SchoolYear,
				msl.TermId,
				CourseCode,
				SectionId,
				CASE WHEN [c].[MaxCycle] = 0 OR [c].[MaxCycle] IS NULL THEN 0
					ELSE (sum([Minutes])/c.MaxCycle)*5 END AS 'AvgMinWeek'
			FROM (	SELECT
					[ms].[NumericSchoolDBN],
					[ms].[SchoolYear],
					[ms].[TermId],
					[ms].[CourseCode],
					[ms].[SectionId],
					c.CycleDay AS 'CycleDay', -- STARS recognizes cycle days between 0-9
					[ms].[PeriodId],
					DATEDIFF(MINUTE, [bell].[StartTime], [bell].[EndTime]) AS 'Minutes'
				FROM
					[dbo].[STARS_Stg_MasterScheduleReport] [ms] -- master schedule line item
					INNER JOIN [dbo].[STARS_Stg_Cycle] c (NOLOCK) ON c.NumericSchoolDbn=[ms].NumericSchoolDbn AND
						c.SchoolYear=[ms].SchoolYear AND c.TermID=[ms].TermID AND
						SUBSTRING([ms].CycledayBinaryString,(c.CycleDay+1),1)='1'
					JOIN -- bell schedule to calculate minutes during a period
						[dbo].[STARS_Stg_BellScheduleTimes] [bell]
						ON [bell].[BellScheduleID] = [ms].[BellScheduleID]
						AND [bell].[CycleDay] = c.CycleDay
						AND [bell].[PeriodId] = [ms].[PeriodId]
					WHERE ms.SchoolYear = @SY
					) msl
			JOIN
				(SELECT numericschooldbn, schoolyear, termid, MAX(CycleDay) AS 'MaxCycle' FROM [dbo].[STARS_Stg_Cycle] 
				WHERE SchoolYear = @SY
				group by
				numericschooldbn, schoolyear, termid ) c
				on c.numericschooldbn = msl.numericschooldbn
				and c.schoolyear = msl.schoolyear
				and c.termid = msl.termid
			GROUP BY
				msl.NumericSchoolDBN,
				msl.SchoolYear,
				msl.TermId,
				CourseCode,
				SectionId,
				c.MaxCycle) [time]
			ON [time].[NumericSchoolDBN] = [ms].[NumericSchoolDBN]
			AND [time].[SchoolYear] = [ms].[SchoolYear]
			AND [time].[TermID] = [ms].[TermID]
			AND [time].[CourseCode] = [ms].[CourseCode]
			AND [time].[SectionID] = [ms].[SectionID]
WHERE
	[ms].[SchoolYear] = @SY

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_TRNS_CourseSection]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[STARS_TRNS_CourseSection]') IS NOT NULL
	DROP TABLE [STARS_TRNS_CourseSection]
CREATE TABLE [STARS_TRNS_CourseSection] (
	[ID] INT IDENTITY(1,1) NOT NULL
	,[NumericSchoolDBN] INT NULL
	,[SchoolYear] SMALLINT NULL
	,[TermID] TINYINT NULL
	,[CourseCode] VARCHAR(10) NULL
	,[SectionID] INT
	,[MinutesPerWeek] INT NULL
	,[SchedulingMethodID] INT NULL
	,[TargetedServiceID] INT
	,[SP_MTI_DaysPerWeek] INT
	,[SP_MTI_IsMTI] BIT NULL
	,[SP_MTI_MinPerWeek] INT NULL
	,TeachingPersonnelTermId INT NULL
)

Note: Ignore mapping for [ID]

--DFT_STARS_TRNS_CourseSection_StudentEnrollment
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
DECLARE @SY INT; 
SET @SY = CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END; 
SELECT
	sr.StudentID
	,cs.ID AS CourseSectionID
	,NULL AS StartDate
	,NULL AS EndDate
FROM
	STARS_TRNS_CourseSection cs
JOIN [STARS_Stg_StudentRequest] sr
ON sr.NumericSchoolDBN = cs.NumericSchoolDBN
		AND sr.SchoolYear = cs.SchoolYear
		AND sr.TermID = cs.TermID
		AND sr.[AssignedCourseCode] = cs.CourseCode
		AND sr.[AssignedSectionID] = cs.SectionID
JOIN
		[dbo].[SWHUB_ATS_Students Dimension] [ss] (NOLOCK)
		ON [ss].[Student_ID] = [sr].[StudentID]
WHERE
	[cs].[SchoolYear] = @SY

--Data Conversion:
Input Column		Output Alias			Data Type					Length
StartDate			StartDate_Convert		database date [DT_DBDATE]	
EndDate				EndDate_Convert			database date [DT_DBDATE]	

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_TRNS_CourseSection_StudentEnrollment]
--Table creation code:
IF OBJECT_ID('[STARS_TRNS_CourseSection_StudentEnrollment]') IS NOT NULL
	DROP TABLE [STARS_TRNS_CourseSection_StudentEnrollment]
CREATE TABLE [STARS_TRNS_CourseSection_StudentEnrollment] (
	StudentID [int] NULL,
	CourseSectionID [INT] NULL,
	[TermID] [tinyint] NULL,
	StartDate [date] NULL,
	EndDate [date] NULL,
)

Note: Ignore mapping for [TermID]

--DFT_STARS_TRNS_MSR_PrimaryTeacher
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
DECLARE @SY INT; 
SET @SY = CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END; 
SELECT DISTINCT 
			[NumericSchoolDBN],
			[SchoolYear],
			[TermID],
			[CourseCode],
			[SectionID], 
			[TeachingPersonnelTermId] 
			FROM [dbo].[STARS_Stg_MasterScheduleReport] (NOLOCK)
WHERE
	[SchoolYear] = @SY

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_TRNS_MSR_PrimaryTeacher]
--Table creation code:
IF OBJECT_ID('[STARS_TRNS_MSR_PrimaryTeacher]') IS NOT NULL
	DROP TABLE [STARS_TRNS_MSR_PrimaryTeacher]
CREATE TABLE [STARS_TRNS_MSR_PrimaryTeacher] (
	[NumericSchoolDBN] [int] NULL,
	[SchoolYear] [smallint]  NULL,
	[TermID] [tinyint]  NULL,
	[CourseCode] [varchar](10)  NULL,
	[SectionID] [smallint]  NULL, 
	[TeachingPersonnelTermId] [int]  NULL
	)

--DFT_STARS_TRNS_Course_Section_Teacher_Enrollment_PT
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
DECLARE @SY INT; 
SET @SY = CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END; 
SELECT 
	[pt].[PersonnelID]
	,[ms].[TeachingPersonnelTermId]
	,cs.ID AS CourseSectionID
	,2 AS TeacherTypeID
	,NULL AS StartDate
	,NULL AS EndDate
	,CASE WHEN [ms].[TeachingPersonnelTermId] IS NOT NULL THEN 'MS and HS' ELSE '' END AS Teacher_SchedulingSchool
FROM
	[dbo].STARS_TRNS_CourseSection cs 
	JOIN
		[dbo].[STARS_TRNS_MSR_PrimaryTeacher] ms
		ON ms.NumericSchoolDBN = cs.NumericSchoolDBN
		AND ms.SchoolYear = cs.SchoolYear
		AND ms.TermID = cs.TermID
		AND ms.[CourseCode] = cs.CourseCode
		AND ms.[SectionID] = cs.SectionID
	
	JOIN
		[dbo].[STARS_Stg_PersonnelTerm] [pt] 
		ON [pt].[NumericSchoolDBN] = [ms].[NumericSchoolDBN]
		AND [pt].[SchoolYear] = [ms].[SchoolYear]
		AND [pt].[TermId] = [ms].[TermId]
		AND [pt].[PersonnelTermId] = [ms].[TeachingPersonnelTermId]
WHERE
	[cs].[SchoolYear] = @SY

--Data Conversion:
Input Column		Output Alias			Data Type					Length
StartDate			StartDate_Convert		database date [DT_DBDATE]	
EndDate				EndDate_Convert			database date [DT_DBDATE]	

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_TRNS_CourseSection_Teacher_Enrollment]
--Table creation code:
IF OBJECT_ID('[STARS_TRNS_CourseSection_Teacher_Enrollment]') IS NOT NULL
	DROP TABLE [STARS_TRNS_CourseSection_Teacher_Enrollment]
CREATE TABLE [STARS_TRNS_CourseSection_Teacher_Enrollment] (
	[PersonnelID] INT NULL
	,[PersonnelTermID] INT NULL
	,[CourseSectionID] INT NULL
	,[TermID] [tinyint] NULL
	,[TeacherTypeID] INT NULL
	,[StartDate] DATE NULL
	,[EndDate] DATE NULL
	,Teacher_SchedulingSchool VARCHAR(50) NULL
	)

Note: Ignore mapping for [termID]

--DFT_STARS_TRNS_MSR_SeconderyTeacher
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
DECLARE @SY INT; 
SET @SY = CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END; 
SELECT DISTINCT 
			[NumericSchoolDBN],
			[SchoolYear],
			[TermID],
			[CourseCode],
			[SectionID], 
			[GroupID] 
			FROM [dbo].[STARS_Stg_MasterScheduleReport] (NOLOCK)
WHERE
	[SchoolYear] = @SY

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_TRNS_MSR_SeconderyTeacher]
--Table creation code:
IF OBJECT_ID('[STARS_TRNS_MSR_SeconderyTeacher]') IS NOT NULL
	DROP TABLE [STARS_TRNS_MSR_SeconderyTeacher]
CREATE TABLE [dbo].[STARS_TRNS_MSR_SeconderyTeacher] (
	[NumericSchoolDBN] [int] NULL,
	[SchoolYear] [smallint] NULL,
	[TermID] [tinyint] NULL,
	[CourseCode] [varchar](10) NULL,
	[SectionID] [smallint] NULL, 
	[GroupID] [int] NULL
	)

--DFT_STARS_TRNS_Course_Section_Teacher_Enrollment_ST
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
DECLARE @SY INT; 
SET @SY = CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END; 
SELECT 
	[pt].[PersonnelID]
	,[tgm].[TeachingPersonnelTermId]
	,cs.ID AS CourseSectionID
	,3 AS TeacherTypeID
	,NULL AS StartDate
	,NULL AS EndDate
	,CASE WHEN [tgm].[TeachingPersonnelTermId] IS NOT NULL THEN 'MS and HS' ELSE '' END AS Teacher_SchedulingSchool
	--INTO #CourseSection_TeacherEnrollment

FROM
	[dbo].[STARS_TRNS_CourseSection] cs (NOLOCK)
	JOIN
		[dbo].[STARS_TRNS_MSR_SeconderyTeacher] ms
		ON ms.NumericSchoolDBN = cs.NumericSchoolDBN
		AND ms.SchoolYear = cs.SchoolYear
		AND ms.TermID = cs.TermID
		AND ms.[CourseCode] = cs.CourseCode
		AND ms.[SectionID] = cs.SectionID
	JOIN
		[dbo].[STARS_Stg_TeachingGroupMembers] [tgm] 
		ON [tgm].[GroupID] = ms.[GroupID]
	JOIN
		[dbo].[STARS_Stg_PersonnelTerm] [pt] 
		ON [pt].[NumericSchoolDBN] = cs.[NumericSchoolDBN]
		AND [pt].[SchoolYear] = cs.[SchoolYear]
		AND [pt].[TermId] = cs.[TermId]
		AND [pt].[PersonnelTermId] = [tgm].[TeachingPersonnelTermId]
WHERE
	[cs].[SchoolYear] = @SY

--Data Conversion:
Input Column		Output Alias			Data Type					Length
StartDate			StartDate_Convert		database date [DT_DBDATE]	
EndDate				EndDate_Convert			database date [DT_DBDATE]	

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_TRNS_CourseSection_Teacher_Enrollment]
--Table creation code:
Table created before
Note: Ignore mapping for [termID]

--Sequence Container_OC Scheduling
--DFT_STARS_TRNS_CourseSection
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
DECLARE @SY INT; 
SET @SY = CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END; 
SELECT DISTINCT
	[ocsub].[NumericSchoolDBN]
	,[ocsub].[SchoolYear]
	,[ocsub].[TermID]
	,[ocstu].[CourseCode]
	,CAST(ASCII(SUBSTRING([ocsub].[OfficialClass], 1, 1)) AS VARCHAR(3)) + 
	 CAST(ASCII(SUBSTRING([ocsub].[OfficialClass], 2, 1)) AS VARCHAR(3)) +
	 CAST(ASCII(SUBSTRING([ocsub].[OfficialClass], 3, 1)) AS VARCHAR(3))
	 AS 'SectionID'
	,[ocsub].[MinutesPerWeek]
	
	,2 AS 'SchedulingMethodID'
	,[ocsub].[Settings].value('(/Settings//MTI/DaysPerWeek/node())[1]','INT') AS [SP_MTI_DaysPerWeek]
	,CASE
		WHEN [ocsub].[Settings].value('(/Settings//MTI/IsMti/node())[1]','varchar(5)') = 'true' THEN 1
		WHEN [ocsub].[Settings].value('(/Settings//MTI/IsMti/node())[1]','varchar(5)') = 'yes' THEN 1
		ELSE 0
	END AS [SP_MTI_IsMTI]
	,[ocsub].[Settings].value('(/Settings//MTI/MtiMinutesPerWeek/node())[1]','INT') AS [SP_MTI_MinPerWeek]
	, NULL AS [TeachingPersonnelTermId]
FROM
	[dbo].[STARS_Stg_OfficialClassSubject] [ocsub] (NOLOCK)
	JOIN
		[dbo].[STARS_Stg_OfficialClassStudent] [ocstu] (NOLOCK)
		ON [ocsub].[OfficialClassSubjectID] = [ocstu].[OfficialClassSubjectID]
	JOIN
		[dbo].[STARS_Stg_School] [sch] (NOLOCK)
		ON [sch].[NumericSchoolDBN] = [ocsub].[NumericSchoolDBN]
	JOIN
		[dbo].[SWHUB_ATS_Students Dimension] [ss] (NOLOCK)
	ON [ss].[Student_ID] = [ocstu].[StudentID]	
WHERE
	[ocsub].[SchoolYear] = @SY
	AND [ocsub].[IsActive] = 1 
	AND [ocstu].[IsActive] = 1

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_TRNS_CourseSection]
--Table creation code:
Table created before
Note: Ignore mapping for [ID]

--DFT_STARS_TRNS_CourseSection_StudentEnrollment
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT
	 oc.StudentID
	,cs.ID AS CourseSectionID
	,NULL AS StartDate
	,NULL AS EndDate
FROM
	[dbo].[STARS_TRNS_CourseSection] cs
	JOIN
		(SELECT DISTINCT 
			[NumericSchoolDBN],
			[SchoolYear],
			[TermID],
			[CourseCode],
			[OfficialClass],
			[StudentID] 
		FROM
			[dbo].[STARS_Stg_OfficialClassSubject] [ocsub] (NOLOCK)
			JOIN
				[dbo].[STARS_Stg_OfficialClassStudent] [ocstu] (NOLOCK)
				ON [ocsub].[OfficialClassSubjectID] = [ocstu].[OfficialClassSubjectID]
		WHERE 
			[ocsub].[IsActive] = 1 
			AND [ocstu].[IsActive] = 1
		) oc
		ON oc.NumericSchoolDBN = cs.NumericSchoolDBN
		AND oc.SchoolYear = cs.SchoolYear
		AND oc.TermID = cs.TermID
		AND oc.[CourseCode] = cs.CourseCode
		AND 
		CAST(ASCII(SUBSTRING(oc.[OfficialClass], 1, 1)) AS VARCHAR(3)) + 
		CAST(ASCII(SUBSTRING(oc.[OfficialClass], 2, 1)) AS VARCHAR(3)) +
		CAST(ASCII(SUBSTRING(oc.[OfficialClass], 3, 1)) AS VARCHAR(3)) = cs.SectionID
	JOIN
		[dbo].[SWHUB_ATS_Students Dimension] [ss] (NOLOCK)
		ON [ss].[Student_ID] = oc.[StudentID]

--Data Conversion:
Input Column		Output Alias			Data Type					Length
StartDate			StartDate_Convert		database date [DT_DBDATE]	
EndDate				EndDate_Convert			database date [DT_DBDATE]	

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_TRNS_CourseSection_StudentEnrollment]
--Table creation code:
Table created before
Note: Ignore mapping for [termID]

--DFT_STARS_TRNS_CourseSection_TeacherEnrollment_PT
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT 
[OC].[TeacherID] AS PersonnelID
	,NULL AS PersonnelTermID
	,cs.ID AS CourseSectionID
	,1 AS TeacherTypeID
	,NULL AS StartDate
	,NULL AS EndDate
	,CASE WHEN [OC].[TeacherID] IS NOT NULL THEN 'ES' ELSE '' END AS Teacher_SchedulingSchool
FROM
	[dbo].[STARS_TRNS_CourseSection] cs (NOLOCK)
	JOIN
		(SELECT DISTINCT 
			[NumericSchoolDBN],
			[SchoolYear],
			[TermID],
			[CourseCode],
			[OfficialClass],
			[TeacherID] 
			FROM [dbo].[STARS_Stg_OfficialClassSubject] [ocsub] (NOLOCK)
			LEFT OUTER JOIN
				[dbo].[STARS_Stg_OfficialClassTeacher] [oct] (NOLOCK)
				ON [ocsub].[OfficialClassSubjectID] = [oct].[OfficialClassSubjectID]
			JOIN
				[dbo].[STARS_Stg_OfficialClassStudent] [ocstu] (NOLOCK)
				ON [ocsub].[OfficialClassSubjectID] = [ocstu].[OfficialClassSubjectID]
		WHERE [ocsub].[IsActive] = 1 and [oct].[IsActive] = 1 ) OC
		ON oc.NumericSchoolDBN = cs.NumericSchoolDBN
		AND oc.SchoolYear = cs.SchoolYear
		AND oc.TermID = cs.TermID
		AND oc.[CourseCode] = cs.CourseCode
		AND 
		CAST(ASCII(SUBSTRING(oc.[OfficialClass], 1, 1)) AS VARCHAR(3)) + 
		CAST(ASCII(SUBSTRING(oc.[OfficialClass], 2, 1)) AS VARCHAR(3)) +
		CAST(ASCII(SUBSTRING(oc.[OfficialClass], 3, 1)) AS VARCHAR(3)) = cs.SectionID

--Data Conversion:
Input Column		Output Alias			Data Type					Length
StartDate			StartDate_Convert		database date [DT_DBDATE]	
EndDate				EndDate_Convert			database date [DT_DBDATE]	

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_TRNS_CourseSection_Teacher_Enrollment]
--Table creation code:
Table created before
Note: Ignore mapping for [termID]

--Sequence Container_ISP and PIPO Scheduling
--DFT_STARS_TRNS_CourseSection
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
DECLARE @SY INT; 
SET @SY = CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END; 

SELECT DISTINCT
	[ts].[NumericSchoolDBN]
	,[ts].[SchoolYear]
	,[ts].[TermID]
	,[ts].[CourseCode]
	,CAST([pers].[EisID] AS VARCHAR(7)) + CAST([ts].[ServiceTypeID] AS VARCHAR(1)) AS 'SectionID'
	,[ts].[MinutesPerWeek]
	,CASE
		WHEN [ts].[ServiceTypeID] = 1 THEN 3--'Push-In'
		WHEN [ts].[ServiceTypeID] = 2 THEN 4--'Pull-Out'
		WHEN [ts].[ServiceTypeID] = 3 THEN 6--'ISP'
		ELSE 5--'Unknown PIPO'
	END AS 'SchedulingMethodID'
	,[ts].[TargetedServiceID] AS 'TargetedServiceID'
	,[ts].[Settings].value('(/Settings//MTI/DaysPerWeek/node())[1]','INT') AS [SP_MTI_DaysPerWeek]
	,CASE
		WHEN [ts].[Settings].value('(/Settings//MTI/IsMti/node())[1]','varchar(5)') = 'true' THEN 1
		WHEN [ts].[Settings].value('(/Settings//MTI/IsMti/node())[1]','varchar(5)') = 'yes' THEN 1
		ELSE 0
	END AS [SP_MTI_IsMTI]
	,[ts].[Settings].value('(/Settings//MTI/MtiMinutesPerWeek/node())[1]','INT') AS [SP_MTI_MinPerWeek]
	, NULL AS [TeachingPersonnelTermId]
FROM
	[dbo].[STARS_Stg_TargetedService] [ts] (NOLOCK)
	LEFT OUTER JOIN -- to get the EisID
		[dbo].[STARS_Stg_Personnel] [pers] (NOLOCK)
		ON [pers].[PersonnelID] = [ts].[PersonnelID]
	JOIN
		[dbo].[SWHUB_ATS_Students Dimension] [ss] (NOLOCK)
		ON [ss].[Student_ID] = [ts].[StudentID]
WHERE
	[ts].[SchoolYear] = @SY
	AND [ts].[IsActive] = 1

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_TRNS_CourseSection]
--Table creation code:
Table created before
Note: Ignore mapping for [ID]

--DFT_STARS_TRNS_CourseSection_StudentEnrollment
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT
	ts.StudentID
	,cs.ID AS CourseSectionID
	,[ts].[StartDate] AS StartDate
	,[ts].[EndDate] AS EndDate

FROM
	[dbo].[STARS_TRNS_CourseSection] cs
	JOIN
		(SELECT DISTINCT 
			[TargetedServiceId]
			,[StudentID]
			,[StartDate]
			,[EndDate]
		FROM
			[dbo].[STARS_Stg_TargetedService] (NOLOCK)) [ts]
		ON [ts].[TargetedServiceID] = [cs].[TargetedServiceID]

--Data Conversion:
Input Column		Output Alias			Data Type					Length
StartDate			StartDate_Convert		database date [DT_DBDATE]	
EndDate				EndDate_Convert			database date [DT_DBDATE]	

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_TRNS_CourseSection_StudentEnrollment]
--Table creation code:
Table created before
Note: Ignore mapping for [termID]

--DFT_STARS_TRNS_Course_Section_Teacher_Enrollment_PT
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT 
		[ts].[PersonnelID]
		,NULL AS PersonnelTermID
		,cs.ID AS CourseSectionID
		,1 AS TeacherTypeID
		,[ts].[StartDate] AS StartDate
		,[ts].[EndDate] AS EndDate
		,CASE WHEN [ts].[PersonnelID] IS NOT NULL THEN 'ES' ELSE '' END AS Teacher_SchedulingSchool
FROM
	[dbo].[STARS_TRNS_CourseSection] cs (NOLOCK)
	JOIN
		(SELECT DISTINCT 
			[TargetedServiceId]
			,[PersonnelID]
			,[StartDate]
			,[EndDate]
		FROM
			[dbo].[STARS_Stg_TargetedService] (NOLOCK)) [ts]
		ON [ts].[TargetedServiceID] = [cs].[TargetedServiceID]


--Data Conversion:
Input Column		Output Alias			Data Type					Length
StartDate			StartDate_Convert		database date [DT_DBDATE]	
EndDate				EndDate_Convert			database date [DT_DBDATE]	

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_TRNS_CourseSection_Teacher_Enrollment]
--Table creation code:
Table created before
Note: Ignore mapping for [termID]

--EST_ISP Business Rules Scheduling
Connection: ES11VDEXTESQL01 FGR_INT FGRepUser
SQL Statement:
-- If an ISP record exists, it should override any OC records for the same school/year/term/student/subject.
-- If there is a matching OC record already in the table, delete the OC record (so only the ISP record remains)
-- e.g. A student could be scheduled in 1st Grade Math in OC, and in ISP. We only want to honor the ISP record.
DECLARE @ISPCancellation BIT;
DECLARE @T1 DATETIME;
DECLARE @T2 DATETIME;
IF @ISPCancellation = 1 
BEGIN
	SET @T1 = GETDATE();
	SELECT
		[cs].[ID]
		,css.studentid
	INTO #temp
	FROM
		[dbo].[STARS_TRNS_CourseSection] [cs]
		JOIN
			[dbo].[STARS_TRNS_CourseSection_StudentEnrollment] [css]
			ON [css].[CourseSectionId] = [cs].[ID] AND [css].[TermID] = [cs].[TermID]
		JOIN -- student/courses in question; oc records exist
			(SELECT DISTINCT
				[cs].[NumericSchoolDBN]
				,[cs].[SchoolYear]
				,[cs].[TermId]
				,[cs].[CourseCode]
				,[css].[StudentID]
			FROM
				[dbo].[STARS_TRNS_CourseSection] [cs]
				JOIN
					[dbo].[STARS_TRNS_CourseSection_StudentEnrollment] [css]
					ON [css].[CourseSectionId] = [cs].[ID]  AND [css].[TermID] = [cs].[TermID] 
			WHERE	
				[SchedulingMethodID] = 2) [oc]
			ON [oc].[NumericSchoolDBN] = [cs].[NumericSchoolDBN]
			AND [oc].[SchoolYear] = [cs].[SchoolYear]
			AND [oc].[TermId] = [cs].[TermId]
			AND [oc].[CourseCode] = [cs].[CourseCode]
			AND [oc].[StudentId] = [css].[StudentId]
		JOIN -- student/courses in question; isp records exist
			(SELECT DISTINCT
				[cs].[NumericSchoolDBN]
				,[cs].[SchoolYear]
				,[cs].[TermId]
				,[cs].[CourseCode]
				,[css].[StudentID]
			FROM
				[dbo].[STARS_TRNS_CourseSection] [cs]
				JOIN
					[dbo].[STARS_TRNS_CourseSection_StudentEnrollment] [css]
					ON [css].[CourseSectionId] = [cs].[ID] AND [css].[TermID] = [cs].[TermID] 
			WHERE	
				[SchedulingMethodID] = 6) [isp]
			ON [isp].[NumericSchoolDBN] = [cs].[NumericSchoolDBN]
			AND [isp].[SchoolYear] = [cs].[SchoolYear]
			AND [isp].[TermId] = [cs].[TermId]
			AND [isp].[CourseCode] = [cs].[CourseCode]
			AND [isp].[StudentId] = [css].[StudentId]
		WHERE
			[cs].[SchedulingMethodID] = 2 -- target the OC record

	DELETE [dbo].[STARS_TRNS_CourseSection_StudentEnrollment]
	FROM [dbo].[STARS_TRNS_CourseSection_StudentEnrollment] [css] (NOLOCK)
	JOIN 
		#temp [t] (NOLOCK)
		ON [t].[StudentId] = [css].[StudentID]
		AND [t].[ID] = [css].[CourseSectionID];

	DROP TABLE #temp;

END

--EST_Record Exclusions
Connection: ES11VDEXTESQL01 FGR_INT FGRepUser
SQL Statement:
-- remove Z codes, except ZY and ZJ
SELECT ID INTO #temp2 FROM [dbo].[STARS_TRNS_CourseSection] WHERE [CourseCode] LIKE 'Z%' AND [CourseCode] NOT LIKE 'ZY%' AND [CourseCode] NOT LIKE 'ZJ%';
DELETE [dbo].[STARS_TRNS_CourseSection_StudentEnrollment] FROM [dbo].[STARS_TRNS_CourseSection_StudentEnrollment] [css] (NOLOCK) JOIN #temp2 [temp2] (NOLOCK) ON [css].[CourseSectionID] = [temp2].[ID]
DELETE [dbo].[STARS_TRNS_CourseSection_Teacher_Enrollment] FROM [dbo].[STARS_TRNS_CourseSection_Teacher_Enrollment] [cst] (NOLOCK) JOIN #temp2 [temp2] (NOLOCK) ON [cst].[CourseSectionID] = [temp2].[ID]
DELETE [dbo].[STARS_TRNS_CourseSection] FROM [dbo].[STARS_TRNS_CourseSection] [cs] (NOLOCK) JOIN #temp2 [temp2] (NOLOCK) ON [cs].[ID] = [temp2].[ID]
DROP TABLE #temp2;


-- remove exam codes
SELECT ID INTO #temp3 FROM [dbo].[STARS_TRNS_CourseSection] [cs]
JOIN 
		[dbo].[STARS_Stg_Course] [c]
		ON [cs].[NumericSchoolDBN] = [c].[NumericSchoolDBN]
		AND [cs].[SchoolYear] = [c].[SchoolYear]
		AND [cs].[TermId] = [c].[TermId]
		AND [cs].[CourseCode] = [c].[CourseCode]
WHERE
	[c].[ExamType] <> 1
DELETE [dbo].[STARS_TRNS_CourseSection_StudentEnrollment] FROM [dbo].[STARS_TRNS_CourseSection_StudentEnrollment] [css] (NOLOCK) JOIN #temp3 [temp3] (NOLOCK) ON [css].[CourseSectionID] = [temp3].[ID]
DELETE [dbo].[STARS_TRNS_CourseSection_Teacher_Enrollment] FROM [dbo].[STARS_TRNS_CourseSection_Teacher_Enrollment] [cst] (NOLOCK) JOIN #temp3 [temp3] (NOLOCK) ON [cst].[CourseSectionID] = [temp3].[ID]
DELETE [dbo].[STARS_TRNS_CourseSection] FROM [dbo].[STARS_TRNS_CourseSection] [cs] (NOLOCK) JOIN #temp3 [temp3] (NOLOCK) ON [cs].[ID] = [temp3].[ID]
DROP TABLE #temp3;


-- remove classes without student enrollments (irrelevant!)
SELECT ID INTO #temp4 FROM [dbo].[STARS_TRNS_CourseSection] [cs]
LEFT OUTER JOIN 
		[dbo].[STARS_TRNS_CourseSection_StudentEnrollment] [css] ON [cs].[ID] = [css].[CourseSectionID]
WHERE
	[css].[CourseSectionID] IS NULL
DELETE [dbo].[STARS_TRNS_CourseSection_Teacher_Enrollment] FROM [dbo].[STARS_TRNS_CourseSection_Teacher_Enrollment] [cst] (NOLOCK) JOIN #temp4 [temp4] (NOLOCK) ON [cst].[CourseSectionID] = [temp4].[ID]
DELETE [dbo].[STARS_TRNS_CourseSection] FROM [dbo].[STARS_TRNS_CourseSection] [cs] (NOLOCK) JOIN #temp4 [temp4] (NOLOCK) ON [cs].[ID] = [temp4].[ID]
DROP TABLE #temp4;

--DFT_STARS_TRNS_Scheduling_ByStudentAndTeacher
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
DECLARE @SY INT; 
SET @SY = CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END; 
SELECT DISTINCT
	[cs].[SchoolYear]
	,[sch].[SchoolDBN]
	,[cs].[TermID],ct.[TermBeginDate],ct.[TermEndDate]
	,cs.[SchedulingMethodID]
	,[cs].[CourseCode]
	,[cs].[SectionID]
	,[css].[CourseSectionID]
	,[css].[StudentID]
	--,[s].[First_Nam] AS [Student_FirstName]
	--,[s].[Last_Nam] AS [Student_LastName]
	,[s].[Grade_Level]
	,[s].[Official_Class] AS [OfficialClass]
	,[cs].[MinutesPerWeek] AS 'Course MinPerWeek'
	,CASE
		WHEN [cs].[SP_MTI_IsMTI] = 1 THEN 'Y'
		ELSE 'N'
	END AS 'IsMTI'
	,[cs].[SP_MTI_DaysPerWeek] AS 'MTI DaysPerWeek'
	,[cs].[SP_MTI_MinPerWeek] AS 'MTI MinPerWeek'

	,cs.[TeachingPersonnelTermId]
	,te.PersonnelID
	--,te.PersonnelTermID
	,te.TeacherTypeID
	,pe.[DOEEmployeeID] AS [DOE_EmployeeID]
	,pe.EISId
	--,pe.FirstName AS [Teacher_FirstName]
	--,pe.LastName AS [Teacher_LastName]
	,pe.Mail AS [Teacher_Email]
	,d.[Avg_CycleLength],d.[Avg_NoOfDays_PerCoursePerCycle],d.[CourseCredits]
	,GETDATE() AS [DataPulledDate] 
FROM
	[dbo].[STARS_TRNS_CourseSection] [cs]
	JOIN 
		[dbo].[STARS_Stg_School] [sch]
		ON [sch].[NumericSchoolDBN] = [cs].[NumericSchoolDBN]
	JOIN
		[dbo].[STARS_TRNS_CourseSection_StudentEnrollment] [css]
		ON [css].[CourseSectionID] = [cs].[ID]
	JOIN (
		SELECT [NumericSchoolDBN],[SchoolYear],[TermId],[TermBeginDate],[TermEndDate],[IsCurrent] FROM [dbo].[STARS_Stg_SchoolTerm] (NOLOCK)
		WHERE [SchoolYear] = @SY
		) [ct] 		
		ON [ct].[NumericSchoolDBN] = [cs].[NumericSchoolDBN] 
		AND [ct].[SchoolYear] = [cs].[SchoolYear] 
		AND [ct].[TermId] = [cs].[TermID]
	JOIN
		[dbo].[SWHUB_ATS_Students Dimension] [s]
		ON [s].[Student_ID] = [css].[StudentID]

	 JOIN [dbo].[STARS_TRNS_CourseSection_Teacher_Enrollment] te
		ON css.CourseSectionID=te.CourseSectionID

	 JOIN [dbo].[STARS_STG_Personnel] pe (NOLOCK) 
		 ON te.Personnelid=pe.Personnelid

	 LEFT JOIN [dbo].[STARS_Stg_Course] cr (NOLOCK) 
		ON  cs.NumericSchoolDBn=cr.NumericSchoolDBN 
		AND cs.SchoolYear=cr.SchoolYear 
		AND cs.TermId=cr.TermId 
		AND cs.CourseCode=cr.CourseCode

LEFT JOIN
(
SELECT DISTINCT c.[SchoolDBN],a.[NumericSchoolDBN],a.[SchoolYear],a.[TermId],a.CourseCode,a.[SectionId],Avg_CycleLength,Avg_NoOfDays_PerCoursePerCycle,b.Credits AS CourseCredits
FROM 
(
SELECT DISTINCT [NumericSchoolDBN],[SchoolYear],[TermId],CourseCode,[SectionId],AVG(CycleLength) AS Avg_CycleLength,Avg(TotalDaysInCycle) AS Avg_NoOfDays_PerCoursePerCycle
FROM [dbo].[STARS_Stg_MasterScheduleReport] (NOLOCK)
GROUP BY [NumericSchoolDBN],[SchoolYear],[TermId],CourseCode,[SectionId]
)a
LEFT JOIN [dbo].[STARS_Stg_Course] b (NOLOCK) 
ON a.NumericSchoolDBn=b.NumericSchoolDBN AND
a.SchoolYear=b.SchoolYear AND 
a.TermId=b.TermId AND 
a.CourseCode=b.CourseCode
INNER JOIN [dbo].[STARS_Stg_School] (NOLOCK) c
ON a.NumericSchoolDBN=c.NumericSchoolDBN
) d
ON cs.[NumericSchoolDBN]=d.[NumericSchoolDBN]	AND 
cs.[SchoolYear]=d.[SchoolYear]	AND 
cs.[TermId]=d.[TermId]			AND 
cs.[CourseCode]=d.[CourseCode]	AND 
cs.[SectionId]=d.[SectionId]
ORDER BY
	[sch].[SchoolDBN]
	,[cs].[TermID]
	,[cs].[CourseCode]
	,[cs].[SectionID]


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_TRNS_Scheduling_ByStudentAndTeacher]
--Table creation code:
IF OBJECT_ID('[STARS_TRNS_Scheduling_ByStudentAndTeacher]') IS NOT NULL
	DROP TABLE [STARS_TRNS_Scheduling_ByStudentAndTeacher]
CREATE TABLE [STARS_TRNS_Scheduling_ByStudentAndTeacher] (
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
			,[DOE_EmployeeID] [VARCHAR](50) NULL
			,[TeacherTypeID] [INT] NULL
			,[DataPulledDate] DateTime
			)



--IF OBJECT_ID('[STARS_TRNS_Student_Teacher_Course_Minutes]') IS NOT NULL
--	DROP TABLE STARS_TRNS_Student_Teacher_Course_Minutes
--CREATE TABLE STARS_TRNS_Student_Teacher_Course_Minutes(
--	[SchoolDBN] [varchar](6) NULL
--	,[SchoolYear] [SMALLINT] NULL
--	,[TermID] [TINYINT] NULL
--	,[TermBeginDate] [datetime] NULL
--	,[TermEndDate] [datetime] NULL
--	,[SchedulingMethodID] [INT] NULL
--	,[CourseCode] [VARCHAR](10) NULL
--	,[SectionID] [INT] NULL
--	,[CourseSectionID] [INT] NULL
--	,[StudentID] [INT] NULL
--	,[Student_FirstName] [varchar](15) NULL
--	,[Student_LastName] [varchar](15) NULL
--	,[GradeLevel] [varchar](2) NULL
--	,[OfficialClass] [varchar](3) NULL
--	,[Course MinPerWeek] [INT] NULL
--	,[IsMTI] [CHAR](1) NULL
--	,[MTI DaysPerWeek] [INT] NULL
--	,[MTI MinPerWeek] [INT] NULL
--	,[TeachingPersonnelTermId] [INT] NULL
--	,PersonnelID [INT] NULL
--	,TeacherTypeID INT NULL
--	,[DOE_EmployeeID]  [varchar](50) NULL
--	,EISId [char](30) NULL
--	,[Teacher_FirstName] [varchar](100) NULL
--	,[Teacher_LastName] [varchar](100) NULL
--	,[Teacher_Email] [varchar](100) NULL
--	)



--IF OBJECT_ID('[STARS_TRNS_Student_Teacher_Course]') IS NOT NULL
--	DROP TABLE [STARS_TRNS_Student_Teacher_Course]
--CREATE TABLE [STARS_TRNS_Student_Teacher_Course] (
--	[StudentID] [INT]
--	,[CourseSectionID] [INT] NULL
--	,[PersonnelID] [INT]  NULL
--	,[PersonnelTermID] [INT] NULL
--	,[TeacherTypeID] [INT] NULL
--	,[Teacher_Email] [VARCHAR](100) NULL
--	,[EISID] [CHAR](15) NULL
--	,[DOE_EmployeeID] [VARCHAR](15) NULL
--	)

		

--IF OBJECT_ID('[STARS_TRNS_Student_Teacher_Course_Minutes]') IS NOT NULL
--	DROP TABLE [STARS_TRNS_Student_Teacher_Course_Minutes]
--CREATE TABLE [STARS_TRNS_Student_Teacher_Course_Minutes] (
--		[SchoolYear] [SMALLINT] NULL
--	,[SchoolDBN] [varchar](6) NULL
--	,[TermID] [TINYINT] NULL
--	,[TermBeginDate] [datetime] NULL
--	,[TermEndDate] [datetime] NULL
--	,[SchedulingMethodID] [INT] NULL
--	,[CourseCode] [VARCHAR](10) NULL
--	,[SectionID] [INT] NULL
--	,[CourseSectionID] [INT] NULL
--	,[StudentID] [INT] NULL
--	,[GradeLevel] [varchar](2) NULL
--	,[OfficialClass] [varchar](3) NULL
--	,[Course MinPerWeek] [INT] NULL
--	,[IsMTI] [CHAR](1) NULL
--	,[MTI DaysPerWeek] [INT] NULL
--	,[MTI MinPerWeek] [INT] NULL
--	,[Teacher_Email] [VARCHAR](100) NULL
--	,[EISID] [VARCHAR](15) NULL
--	,[DOE_EmployeeID] [CHAR](15) NULL
--	,[TeacherTypeID] [INT] NULL
--	)



--Variables for this Package:

Name			Scope															Data type			Value
PackageID		Package 05_Manipulate STARS Data from Staging Tables 			Int32				5


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
VALUES (5,'Package 05_Manipulate STARS Data from Staging Tables')
