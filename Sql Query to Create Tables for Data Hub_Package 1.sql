--EST_Delete data from destination tables (for sequence container 1-3)
TRUNCATE TABLE [dbo].[STARS_Stg_MasterScheduleReport]
GO
TRUNCATE TABLE [dbo].[STARS_Stg_Cycle]
GO
TRUNCATE TABLE [dbo].[STARS_Stg_PersonnelTerm]
GO
TRUNCATE TABLE [dbo].[STARS_Stg_OfficialClassStudent]
GO
TRUNCATE TABLE [dbo].[STARS_Stg_Personnel]
GO
TRUNCATE TABLE [dbo].[STARS_Stg_SchoolTerm]
GO
TRUNCATE TABLE [dbo].[STARS_Stg_BellScheduleTimes]
GO
TRUNCATE TABLE [dbo].[STARS_Stg_TeachingGroupMembers]
GO
TRUNCATE TABLE [dbo].[STARS_Stg_OfficialClassTeacher]
GO
TRUNCATE TABLE [dbo].[STARS_Stg_School]
GO
TRUNCATE TABLE [dbo].[STARS_Stg_Section]
GO
TRUNCATE TABLE [dbo].[STARS_Stg_StudentRequest]
GO
TRUNCATE TABLE [dbo].[STARS_Stg_OfficialClassSubject]
GO
TRUNCATE TABLE [dbo].[STARS_Stg_TargetedService]
GO
TRUNCATE TABLE [dbo].[STARS_Stg_Course]
GO


--Sequence container 1 
--DFT_STARS_Stg_MasterScheduleReport
--OLE DB Source
--OLEDB Connection Manager: ES00VADOSQL001 STARS_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT NumericSchoolDBN, SchoolYear, TermId, CourseCode, SectionId, PeriodId, CycleDayBinaryString, 
LEN(CycledayBinaryString) AS CycleLength, 
(
CAST((SUBSTRING(cycledaybinarystring,1,1)) AS int)+
CAST((SUBSTRING(cycledaybinarystring,2,1) ) AS int)+
CAST((SUBSTRING(cycledaybinarystring,3,1)) AS int)+
CAST((SUBSTRING(cycledaybinarystring,4,1) ) AS int)+
CAST((SUBSTRING(cycledaybinarystring,5,1)) AS int)+
CAST((SUBSTRING(cycledaybinarystring,6,1)) AS int)+
CAST((SUBSTRING(cycledaybinarystring,7,1)) AS int)+
CAST((SUBSTRING(cycledaybinarystring,8,1)) AS int)+
CAST((SUBSTRING(cycledaybinarystring,9,1)) AS int)+
CAST((SUBSTRING(cycledaybinarystring,10,1) ) AS int)
) AS TotalDaysInCycle,
TeachingPersonnelTermId, Gender, RoomNumber, NextCourseCode, NextSectionId, NextCycleDayBinaryString, EffectiveDate, LinkedCourseCode, 
LinkedSectionId, GroupId, UpdatedByPID, UpdatedDate, CreatedByPID, CreatedDate, BellScheduleID
FROM  MasterScheduleReport WITH (NOLOCK)
WHERE (SchoolYear = CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE()) - 1 ELSE YEAR(GETDATE()) END)

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_STG_MasterScheduleReport]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[STARS_STG_MasterScheduleReport]') IS NOT NULL
	DROP TABLE [STARS_STG_MasterScheduleReport]
CREATE TABLE [dbo].[STARS_STG_MasterScheduleReport](
	[NumericSchoolDBN] [int] NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
	[TermId] [tinyint] NOT NULL,
	[CourseCode] [varchar](10) NOT NULL,
	[SectionId] [smallint] NOT NULL,
	[PeriodId] [smallint] NOT NULL,
	[CycleDayBinaryString] [varchar](10) NOT NULL,
	[CycleLength] [int] NULL,
	[TotalDaysInCycle] [int] NULL,
	[TeachingPersonnelTermId] [int] NOT NULL,
	[Gender] [char](1) NULL,
	[RoomNumber] [varchar](10) NULL,
	[NextCourseCode] [varchar](8) NULL,
	[NextSectionId] [smallint] NULL,
	[NextCycleDayBinaryString] [varchar](10) NULL,
	[EffectiveDate] [datetime] NULL,
	[LinkedCourseCode] [varchar](10) NOT NULL,
	[LinkedSectionId] [smallint] NOT NULL,
	[GroupId] [int] NULL,
	[UpdatedByPID] [int] NULL,
	[UpdatedDate] [datetime] NULL,
	[CreatedByPID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[BellScheduleID] [int] NULL
	) 

--DFT_STARS_Stg_OfficialClassStudent
--OLE DB Source
--OLEDB Connection Manager: ES00VADOSQL001 STARS_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT a.* FROM
(
SELECT * FROM [dbo].[OfficialClassStudent] with (TABLOCK) WHERE isActive=1 AND [StartDate] <= GETDATE() AND [EndDate] >= GETDATE()
) a
INNER JOIN (SELECT Student_ID FROM [ATSLINK].[ATS_Demo].[dbo].[BIOGDATA] WHERE STATUS='A') [ats]
ON a.StudentID=ats.Student_ID

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_STG_OfficialClassStudent]
--Table creation code:
IF OBJECT_ID('[STARS_STG_OfficialClassStudent]') IS NOT NULL
	DROP TABLE [STARS_STG_OfficialClassStudent]
CREATE TABLE [dbo].[STARS_STG_OfficialClassStudent](
	[OfficialClassStudentID] [int] NOT NULL,
	[OfficialClassSubjectID] [int] NOT NULL,
	[StudentID] [int] NOT NULL,
	[CourseCode] [varchar](10) NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[IsActive] [bit] NULL,
	[Satus] [tinyint] NULL,
	[CreatedByPID] [int] NOT NULL,
	[CreatedDate][datetime] NOT NULL,
	[UpdatedByPID] [int] NULL,
	[UpdatedDate] [datetime] NULL
	)

--DFT_STARS_Stg_PersonnelTerm
--OLE DB Source
--OLEDB Connection Manager: ES00VADOSQL001 STARS_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT * FROM [dbo].[PersonnelTerm]  (NOLOCK) WHERE SchoolYear= CASE WHEN MONTH(GETDATE()) <'07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_STG_PersonnelTerm]
--Table creation code:
IF OBJECT_ID('[STARS_STG_PersonnelTerm]') IS NOT NULL
	DROP TABLE [STARS_STG_PersonnelTerm]
CREATE TABLE [dbo].[STARS_STG_PersonnelTerm](
	[PersonnelTermID] [int] NOT NULL,
	[PersonnelID] [int] NULL,
	[NumericSchoolDBN] [int] NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
	[TermId] [tinyint] NOT NULL,
	[NickName] [varchar](100) NOT NULL,
	[UpdatedByPID] [int] NULL,
	[UpdatedDate] [datetime] NULL,
	[CreatedByPID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL
	)

--DFT_STARS_Stg_Personnel
--OLE DB Source
--OLEDB Connection Manager: ES00VADOSQL001 STARS_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT * FROM [dbo].[Personnel] (NOLOCK)

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_STG_Personnel]
--Table creation code:
IF OBJECT_ID('[STARS_STG_Personnel]') IS NOT NULL
	DROP TABLE [STARS_STG_Personnel]
CREATE TABLE [dbo].[STARS_STG_Personnel](
	[PersonnelID] [int] NOT NULL,
	[ActiveDirectoryID] [varchar](100) NULL,
	[DoeEmployeeID] [varchar](50) NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[Mail] [varchar](80) NULL,
	[WindowsName] [varchar](100) NULL,
	[EisID] [varchar](30) NULL,
	[SSN] [varchar](20) NULL,
	[Source] [varchar](100) NULL,
	[UpdatedByPID] [int] NULL,
	[UpdatedDate] [datetime] NULL,
	[CreatedByPID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[Settings] [xml] NULL,
	[GUID] [uniqueidentifier] NULL
	)

--DFT_STARS_Stg_Cycle
--OLE DB Source
--OLEDB Connection Manager: ES00VADOSQL001 STARS_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT * FROM [dbo].[Cycle]  (NOLOCK) WHERE SchoolYear= CASE WHEN MONTH(GETDATE()) <'07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_STG_Cycle]
--Table creation code:
IF OBJECT_ID('[STARS_STG_Cycle]') IS NOT NULL
	DROP TABLE [STARS_STG_Cycle]
CREATE TABLE [dbo].[STARS_STG_Cycle](
	[NumericSchoolDBN] [int] NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
	[TermId] [tinyint] NOT NULL,
	[CycleDay] [smallint] NOT NULL,
	[DisplayName] [varchar](15) NOT NULL,
	[DisplayCharacter] [char](1) NOT NULL,
	[UpdatedByPID] [int] NULL,
	[UpdatedDate] [datetime] NULL,
	[CreatedByPID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL
	)


--Sequence container 2 

--DFT_STARS_Stg_TeachingGroupMembers
--OLE DB Source
--OLEDB Connection Manager: ES00VADOSQL001 STARS_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT * FROM [dbo].[TeachingGroupMembers] (NOLOCK)

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_STG_TeachingGroupMembers]
--Table creation code:
IF OBJECT_ID('[STARS_STG_TeachingGroupMembers]') IS NOT NULL
	DROP TABLE [STARS_STG_TeachingGroupMembers]
CREATE TABLE [dbo].[STARS_STG_TeachingGroupMembers](
	[GroupID] [int] NOT NULL,
	[TeachingPersonnelTermId] [int] NOT NULL
	)

--DFT_STARS_Stg_OfficialClassTeacher
--OLE DB Source
--OLEDB Connection Manager: ES00VADOSQL001 STARS_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT * FROM [dbo].[OfficialClassTeacher] (NOLOCK) WHERE isActive=1

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_STG_OfficialClassTeacher]
--Table creation code:
IF OBJECT_ID('[STARS_STG_OfficialClassTeacher]') IS NOT NULL
	DROP TABLE [STARS_STG_OfficialClassTeacher]
CREATE TABLE [dbo].[STARS_STG_OfficialClassTeacher](
	[OfficialClassTeacherID] [int] NOT NULL,
	[OfficialClassSubjectID] [int] NOT NULL,
	[TeacherID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[CreatedByPID] [int] NOT NULL,
	[CreatedDate][datetime] NOT NULL,
	[UpdatedByPID] [int]  NULL,
	[UpdatedDate] [datetime] NULL
	)

--DFT_STARS_Stg_BellScheduleTimes
--OLE DB Source
--OLEDB Connection Manager: ES00VADOSQL001 STARS_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT * FROM [dbo].[BellScheduleTimes] (NOLOCK)

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_STG_BellScheduleTimes]
--Table creation code:
IF OBJECT_ID('[STARS_STG_BellScheduleTimes]') IS NOT NULL
	DROP TABLE [STARS_STG_BellScheduleTimes]
CREATE TABLE [dbo].[STARS_STG_BellScheduleTimes](
	[BellScheduleID] [int] NOT NULL,
	[CycleDay] [smallint] NOT NULL,
	[PeriodId] [tinyint] NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NOT NULL,
	[UpdatedByPID] [int] NULL,
	[UpdatedDate] [datetime] NULL,
	[CreatedByPID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL
	)

--DFT_STARS_Stg_Course
--OLE DB Source
--OLEDB Connection Manager: ES00VADOSQL001 STARS_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
DECLARE @SY INT; 
SET @SY = CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END; 
SELECT [NumericSchoolDBN],[SchoolYear],[TermId],[CourseCode],[CourseName],[ExamType],[Credits] FROM [dbo].[Course]  (NOLOCK) WHERE [SchoolYear]=@SY

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_STG_Course]
--Table creation code:
IF OBJECT_ID('[STARS_STG_Course]') IS NOT NULL
	DROP TABLE [STARS_STG_Course]
CREATE TABLE [STARS_STG_Course] (
		[NumericSchoolDBN] [int] NOT NULL,
		[SchoolYear] [smallint] NOT NULL,
		[TermId] [tinyint] NOT NULL,
		[CourseCode] [varchar](10) NOT NULL,
		[ExamType] [tinyint] NOT NULL,
		[Credits] [decimal] (4,2) NULL,
		[CourseName]	[varchar](40) null
		)

--DFT_STARS_Stg_Section
--OLE DB Source
--OLEDB Connection Manager: ES00VADOSQL001 STARS_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT * FROM [Section]  (NOLOCK) WHERE SchoolYear= CASE WHEN MONTH(GETDATE()) <'07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_STG_Section]
--Table creation code:
IF OBJECT_ID('[STARS_STG_Section]') IS NOT NULL
	DROP TABLE [STARS_STG_Section]
CREATE TABLE [dbo].[STARS_STG_Section](
	[NumericSchoolDBN] [int] NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
	[TermId] [tinyint] NOT NULL,
	[CourseCode] [varchar](10) NOT NULL,
	[SectionId] [smallint] NOT NULL,
	[Capacity] [int] NULL,
	[IsCTT] [bit] NULL,
	[IsSelfContained] [bit] NULL,
	[VirtualClassTypeID] [smallint] NULL,
	[UpdatedByPID] [int] NULL,
	[UpdatedDate] [datetime] NULL,
	[CreatedByPID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[InstructionalModelID] [tinyint] NULL,
	[Settings] [xml] NULL
	)



--Sequence container 3 
--DFT_STARS_Stg_OfficialClassSubject
--OLE DB Source
--OLEDB Connection Manager: ES00VADOSQL001 STARS_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT * FROM [dbo].[OfficialClassSubject]  (NOLOCK) WHERE SchoolYear= CASE WHEN MONTH(GETDATE()) <'07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END AND isActive=1

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_STG_OfficialClassSubject]
--Table creation code:
IF OBJECT_ID('[STARS_STG_OfficialClassSubject]') IS NOT NULL
	DROP TABLE [STARS_STG_OfficialClassSubject]
CREATE TABLE [dbo].[STARS_STG_OfficialClassSubject](
	[OfficialClassSubjectID] [int] NOT NULL,
	[NumericSchoolDBN] [int] NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
	[TermID] [tinyint] NOT NULL,
	[OfficialClass] [varchar](10) NOT NULL,
	[SubjectId] [smallint] NOT NULL,
	[MinutesPerWeek] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[Settings] [xml] NOT NULL,
	[CreatedByPID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedByPID] [int] NULL,
	[UpdatedDate] [datetime] NULL
	)

--DFT_STARS_Stg_StudentRequest
--OLE DB Source
--OLEDB Connection Manager: ES00VADOSQL001 STARS_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT a.* FROM 
(SELECT       NumericSchoolDBN, SchoolYear, TermId, StudentID, CourseCode, AssignedCourseCode, AssignedSectionId, LockAssignedRequest, UpdatedByPID, UpdatedDate, 
              CreatedByPID, CreatedDate, AuditCommentId, DebugTrace, EffectiveDate
FROM            StudentRequest WITH (NOLOCK)
WHERE        (SchoolYear = CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE()) - 1 ELSE YEAR(GETDATE()) END)
)a
INNER JOIN (SELECT Student_ID FROM [ATSLINK].[ATS_Demo].[dbo].[BIOGDATA] WHERE STATUS='A') [ats]
ON a.StudentID=ats.Student_ID

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_STG_StudentRequest]
--Table creation code:
IF OBJECT_ID('[STARS_STG_StudentRequest]') IS NOT NULL
	DROP TABLE [STARS_STG_StudentRequest]
CREATE TABLE [dbo].[STARS_STG_StudentRequest] (
	[NumericSchoolDBN] [int] NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
	[TermId] [tinyint] NOT NULL,
	[StudentID] [int] NOT NULL,
	[CourseCode] [varchar](10) NOT NULL,
	[AssignedCourseCode] [varchar](10) NOT NULL,
	[AssignedSectionId] [smallint] NOT NULL,
	[LockAssignedRequest] [bit] NOT NULL,
	[UpdatedByPID] [int] NULL,
	[UpdatedDate] [datetime] NULL,
	[CreatedByPID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[AuditCommentId] [smallint] NOT NULL,
	[DebugTrace] [varchar](100) NULL,
	[EffectiveDate] [datetime] NULL
	)


--DFT_STARS_Stg_SchoolTerm
--OLE DB Source
--OLEDB Connection Manager: ES00VADOSQL001 STARS_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT *,1 AS 'IsCurrent'
FROM [dbo].[SchoolTerm] (NOLOCK)
WHERE [SchoolYear] = CASE WHEN MONTH(GETDATE()) <'07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_STG_SchoolTerm]
--Table creation code:
IF OBJECT_ID('[STARS_STG_SchoolTerm]') IS NOT NULL
	DROP TABLE [STARS_STG_SchoolTerm]
CREATE TABLE [dbo].[STARS_STG_SchoolTerm](
	[NumericSchoolDBN] [int] NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
	[TermId] [tinyint] NOT NULL,
	[TermBeginDate] [datetime] NULL,
	[TermEndDate] [datetime] NULL,
	[CurrentTermInd] [bit] NULL,
	[RunInd] [char](1) NULL,
	[Isfinalized] [bit] NULL,
	[AttendanceSource] [char](1) NULL,
	[UpdatedByPID] [int] NULL,
	[UpdatedDate] [datetime] NULL,
	[CreatedByPID] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[TermName] [varchar](12) NOT NULL,
	[IsCurrent] [int] NULL
	)


--DFT_STARS_Stg_TargetedService
--OLE DB Source
--OLEDB Connection Manager: ES00VADOSQL001 STARS_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT * FROM [dbo].[TargetedService]  (NOLOCK) WHERE SchoolYear= CASE WHEN MONTH(GETDATE()) <'07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END
AND [StartDate] <= GETDATE() AND [EndDate] >= GETDATE()

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_STG_TargetedService]
--Table creation code:
SELECT * FROM [dbo].[TargetedService]  (NOLOCK) WHERE SchoolYear= CASE WHEN MONTH(GETDATE()) <'07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END
AND [StartDate] <= GETDATE() AND [EndDate] >= GETDATE()
IF OBJECT_ID('[STARS_STG_TargetedService]') IS NOT NULL
	DROP TABLE [STARS_STG_TargetedService]
CREATE TABLE [dbo].[STARS_STG_TargetedService](
	[TargetedServiceID] [bigint] NOT NULL,
	[NumericSchoolDBN] [int] NOT NULL,
	[SchoolYear] [smallint] NOT NULL,
	[TermId] [tinyint] NOT NULL,
	[PersonnelID] [int] NOT NULL,
	[StudentID] [int] NOT NULL,
	[ServiceTypeID] [tinyint] NOT NULL,
	[CourseCode] [varchar](10) NOT NULL,
	[MinutesPerWeek] [int] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedByPID] [int] NOT NULL,
	[CreatedDate][datetime] NOT NULL,
	[UpdatedByPID] [int] NULL,
	[UpdatedDate] [datetime] NULL,
	[Settings] [xml] NULL,
	[CourseSectionStudentId] [int] NULL
	)

--DFT_STARS_Stg_School
--OLE DB Source
--OLEDB Connection Manager: ES00VADOSQL001 STARS_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:

SELECT [NumericSchoolDBN],[SchoolDBN],[TermModelID],[IsSchoolActive] FROM [School] (NOLOCK)

--Data Conversion
Input Column: SchoolDBN, Output Alias: Converted_SchoolDBN, Data Type: string[DT_STR], Length: 6

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [STARS_STG_School]
--Table creation code:
IF OBJECT_ID('[STARS_STG_School]') IS NOT NULL
	DROP TABLE [STARS_STG_School]
CREATE TABLE [STARS_STG_School] (
[NumericSchoolDBN] [int] NOT NULL,
[SchoolDBN] [varchar](6) NULL,
[TermModelID] [tinyint] NULL,
[IsSchoolActive] [bit] NOT NULL
)


--EST_Delete from destination table 
TRUNCATE TABLE [SWHUB_STARS_CurrentSchoolYear_SchedulingByDay_Search]
GO

--Sequence container 4

--DFT_SWHUB_STARS_CurrentSchoolYear_SchedulingByDay_Search for Middle and High School
--OLE DB Source
--OLEDB Connection Manager: ES00VADOSQL001 STARS_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:

DECLARE @SY INT; 
SET @SY = CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END; 
SELECT  DISTINCT a.SchoolYear,
a.SchoolDBN,
COUNT(a.StudentID) AS TotalStudents,
a.GradeLevel,
a.TermId,
a.BeginDate,
a.EndDate,
a.CurrentTermind,
a.CourseCode,
CASE WHEN (SUBSTRING(a.CourseCode,1,1)='P' AND SUBSTRING(a.CourseCode,2,1)<>'H' AND SUBSTRING(a.CourseCode,2,1)<>'E') THEN 'Physical Ed.' 
	 WHEN (SUBSTRING(a.CourseCode,1,2)='PH' OR SUBSTRING(a.CourseCode,1,2)<>'PE') THEN 'Health Ed.' END AS [CourseType],
a.CourseName, 
a.SectionID, 
a.PeriodId, 
a.[RoomNumber],
a.CycledayBinaryString, 
a.CycleDay,
a.DisplayName,
a.StartTime,
a.EndTime,
a.[Duration_Minutes],
a.Credits, 
a.BellScheduleID,
a.TeachingPersonnelTermId,
a.PersonnelID,
a.EISId,
a.DoeEmployeeID AS [DOE_EmployeeID],
a.FirstName,
a.LastName,
a.Mail,
NULL AS [OfficialClass_ES],
NULL AS [Course MinPerWeek_ES],
NULL AS [IsMTI_ES],
NULL AS [MTI DaysPerWeek_ES],
NULL AS [MTI MinPerWeek],
GETDATE() AS [DataPulledDate]

FROM (
SELECT s.SchoolYear,
sch.SchoolDBN,
sc.StudentID,
stt.GradeLevel,
msr.TermId,
st.BeginDate,
st.EndDate,
st.CurrentTermind,
msr.CourseCode,
c.CourseName, 
msr.SectionID, 
msr.PeriodId, 
msr.[RoomNumber],
msr.CycledayBinaryString, 
cy.CycleDay,
cy.DisplayName,
bst.StartTime,
bst.EndTime,
datediff(mi,bst.StartTime,bst.EndTime) AS [Duration_Minutes],
c.Credits, 
msr.BellScheduleID,
msr.TeachingPersonnelTermId,
pt.PersonnelID,
p.EISId,
p.DoeEmployeeID,
p.FirstName,
p.LastName,
p.Mail
FROM dbo.MasterScheduleReport msr (NOLOCK)

INNER JOIN dbo.School sch (NOLOCK) ON sch.NumericSchoolDbn=msr.NumericSchoolDbn

INNER JOIN dbo.SchoolTerm st (NOLOCK) ON msr.NumericSchoolDbn=st.NumericSchoolDbn AND
       msr.SchoolYear=st.SchoolYear AND msr.TermId=st.TermId

INNER JOIN dbo.Cycle cy (NOLOCK) ON cy.NumericSchoolDbn=msr.NumericSchoolDbn AND
       cy.SchoolYear=msr.SchoolYear AND cy.TermId=msr.TermId AND
       SUBSTRING(msr.CycledayBinaryString,(cy.CycleDay+1),1)='1' 

INNER JOIN dbo.Section s (NOLOCK) ON msr.NumericSchoolDbn=s.NumericSchoolDbn AND
       msr.SchoolYear=s.SchoolYear AND msr.TermId=s.TermId AND
       msr.CourseCode=s.CourseCode AND msr.SectionId=s.SectionId

INNER JOIN dbo.Course c (NOLOCK) ON s.NumericSchoolDbn=c.NumericSchoolDbn AND
       s.SchoolYear=c.SchoolYear AND s.TermId=c.TermId AND s.CourseCode=c.CourseCode

INNER JOIN dbo.StudentRequest sc (NOLOCK) on s.NumericSchoolDbn=sc.NumericSchoolDbn AND
       s.SchoolYear=sc.SchoolYear AND s.TermId=sc.TermId AND s.CourseCode=sc.assignedCourseCode AND
       s.sectionid=sc.assignedsectionid 

INNER JOIN dbo.StudentTerm stt (NOLOCK) ON stt.NumericSchoolDbn=sc.NumericSchoolDbn AND
       stt.SchoolYear=sc.SchoolYear AND stt.TermId=sc.TermId AND stt.StudentID=sc.StudentID AND stt.[IsActive]=1

INNER JOIN dbo.BellScheduleTimes bst (NOLOCK) ON bst.BellScheduleID=msr.BellScheduleID AND
       bst.CycleDay=cy.CycleDay AND bst.PeriodId=msr.PeriodID

INNER JOIN dbo.PersonnelTerm pt (NOLOCK) on msr.TeachingPersonnelTermId=pt.personnelTermId

LEFT OUTER JOIN dbo.Personnel p (NOLOCK) ON pt.Personnelid=p.Personnelid

WHERE 
		[msr].[SchoolYear] = @SY 
	AND [stt].IsActive=1 
	AND SUBSTRING(msr.CourseCode,1,1)='P' AND SUBSTRING(msr.CourseCode,4,1)<>'J' AND substring(msr.coursecode,7,1) <> 'R' 
	AND SUBSTRING (sch.schooldbn,1,1)<>'8' 
	) a
GROUP BY a.SchoolYear,
a.SchoolDBN,
a.GradeLevel,
a.TermId,
a.BeginDate,
a.EndDate,
a.CurrentTermind,
a.CourseCode,
a.CourseName, 
a.SectionID, 
a.PeriodId, 
a.[RoomNumber],
a.CycledayBinaryString, 
a.CycleDay,
a.DisplayName,
a.StartTime,
a.EndTime,
a.[Duration_Minutes],
a.Credits, 
a.BellScheduleID,
a.TeachingPersonnelTermId,
a.PersonnelID,
a.EISId,
a.DoeEmployeeID,
a.FirstName,
a.LastName,
a.Mail

--Data Conversion:
Input Column	Output Alias		Data Type			Length
EISId			EISId_Convert		string[DT_STR]		15
SchoolDBN		SchoolDBN_Convert	string[DT_STR]		6
GradeLevel		GradeLevel_Convert	string[DT_STR]		2

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_STARS_CurrentSchoolYear_SchedulingByDay_Search]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[SWHUB_STARS_CurrentSchoolYear_SchedulingByDay_Search]') IS NOT NULL
DROP TABLE [SWHUB_STARS_CurrentSchoolYear_SchedulingByDay_Search]
CREATE TABLE [SWHUB_STARS_CurrentSchoolYear_SchedulingByDay_Search] (
 [nId] [int]					IDENTITY(1,1) NOT NULL
,[nSchoolYear]					smallint null
,[sSchoolDBN]					varchar(6) null
,[nTotalStudents]				int null
,[sGradeLevel]					varchar(2) null
,[nTermId]						tinyint null
,[dtTermBeginDate]				datetime
,[dtTermEndDate]				datetime
,[nCurrentTermInd]				bit
,[sCourseCode]					varchar(10) null
,[sCourseName]					varchar(40) null
,[sCourseType]					varchar(40) null
,[nSectionID]					int
,[nPeriodId]					smallint null
,[sRoomNumber]					varchar(10) null
,[sCycledayBinaryString]		varchar(10) null
,[nCycleDay]					smallint null
,[sDisplayName]					varchar(15) null
,[tStartTime]					datetime
,[tEndTime]						datetime
,[nDuration_Minutes]			int
,[nCourseCredits]				decimal(4,2) null
,[nBellScheduleID]				int
,[nTeachingPersonnelTermId]		int
,[nPersonnelID]					int null
,[sEISId]						varchar(15) null
,[sTeacher_FirstName]			varchar(50) null
,[sTeacher_LastName]			varchar(50) null
,[sTeacher_Emai]				varchar(100) null
,[DataPullDate]					datetime null
)

--Note: in the mapping ignore [nId] column mapping


--DFT_SWHUB_STARS_CurrentSchoolYear_SchedulingByDay_Search for Elementary School
--OLE DB Source
--OLEDB Connection Manager: ES00VADOSQL001 STARS_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
DECLARE @SY INT; 
SET @SY = CASE WHEN MONTH(GETDATE()) < '07' THEN YEAR(GETDATE())-1  ELSE YEAR(GETDATE()) END; 
SELECT DISTINCT
	[SchoolYear]
	,[SchoolDBN]
	,COUNT([StudentID]) AS TotalStudents
	,[GradeLevel]
	,[TermID]
	,[dtTermBeginDate]
	,[dtTermEndDate]
	,CurrentTermind
	,[CourseCode]
	,CourseName
	,[CourseType]
	,NULL AS [SectionID]
	,[nPeriodId]
	,[RoomNumber]
	,[sCycledayBinaryString]
	,[nCycleDay]
	,[sDisplayName]
	,[tStartTime]
	,[tEndTime]
	,[nDuration_Minutes]
	,[nCourseCredits]
	,[nBellScheduleID]
	,[nTeachingPersonnelTermId]
	,[PersonnelID]
	,[EisID]
	,[DOEEmployeeID] AS [DOE_EmployeeID]
	,[FirstName] AS [Teacher_FirstName]
	,[LastName] AS [Teacher_LastName]
	,[Mail]

	,[OfficialClass] AS [OfficialClass_ES]	
	,AVG([MinutesPerWeek]) AS [Course MinPerWeek_ES]
	,[IsMTI] AS [IsMTI_ES]
	,AVG([MTI DaysPerWeek]) AS [SP_MTI_DaysPerWeek_ES]
	,AVG([MTI MinPerWeek]) AS [SP_MTI_MinPerWeek_ES]	
	,GETDATE() AS [DataPulledDate] 

	FROM (SELECT DISTINCT
	[ocsub].[SchoolYear]
	,[sch].[SchoolDBN]
	,[ocstu].[StudentID]
	,[stt].[GradeLevel]
	,[ocsub].[TermID]
	,[ocstu].[StartDate]
	,[ocstu].[EndDate]
	,st.BeginDate AS [dtTermBeginDate]
	,st.EndDate AS [dtTermEndDate]
	,st.CurrentTermind
	,[ocstu].[CourseCode]
	,[c].CourseName
	,CASE WHEN (SUBSTRING([ocstu].CourseCode,1,1)='P' AND SUBSTRING([ocstu].CourseCode,2,1)<>'H' AND SUBSTRING([ocstu].CourseCode,2,1)<>'E') THEN 'ES Physical Ed.' 
	 WHEN (SUBSTRING([ocstu].CourseCode,1,2)='PH' OR SUBSTRING([ocstu].CourseCode,1,2)<>'PE') THEN 'ES Health Ed.' END AS [CourseType]
	,NULL AS [nPeriodId]
	,NULL AS [RoomNumber]
	,NULL AS [sCycledayBinaryString]
	,NULL AS [nCycleDay]
	,NULL AS [sDisplayName]
	,NULL AS [tStartTime]
	,NULL AS [tEndTime]
	,NULL AS [nDuration_Minutes]
	,NULL AS [nCourseCredits]
	,NULL AS [nBellScheduleID]
	,NULL AS [nTeachingPersonnelTermId]
	,p.[PersonnelID]
	,[p].[EisID]
	,[p].[DoeEmployeeID]
	,[p].[FirstName] 
	,[p].[LastName] 
	,[p].[Mail]
	
	,[ocsub].[OfficialClass]
	,[ocsub].[MinutesPerWeek]
	,CASE
			WHEN [ocsub].[Settings].value('(/Settings//MTI/IsMti/node())[1]','varchar(5)') = 'true' THEN 1
			WHEN [ocsub].[Settings].value('(/Settings//MTI/IsMti/node())[1]','varchar(5)') = 'yes' THEN 1
		ELSE 0
	END AS [IsMTI]	
	,[ocsub].[Settings].value('(/Settings//MTI/DaysPerWeek/node())[1]','INT') AS [MTI DaysPerWeek]
	,[ocsub].[Settings].value('(/Settings//MTI/MtiMinutesPerWeek/node())[1]','INT') AS [MTI MinPerWeek]

FROM [dbo].[OfficialClassSubject] [ocsub] (NOLOCK)

INNER JOIN [dbo].[OfficialClassStudent] [ocstu] (NOLOCK) ON [ocsub].[OfficialClassSubjectID] = [ocstu].[OfficialClassSubjectID]

INNER JOIN [dbo].[OfficialClassTeacher] [oct] (NOLOCK)  ON [ocsub].[OfficialClassSubjectID] = [oct].[OfficialClassSubjectID]

INNER JOIN  [dbo].[School] [sch] (NOLOCK) ON [sch].[NumericSchoolDBN] = [ocsub].[NumericSchoolDBN]
		
INNER JOIN dbo.SchoolTerm st (NOLOCK) ON [sch].NumericSchoolDbn=st.NumericSchoolDbn AND [ocsub].SchoolYear=st.SchoolYear AND [ocsub].TermId=st.TermId 

INNER JOIN dbo.Course c (NOLOCK) ON [sch].NumericSchoolDbn=c.NumericSchoolDbn AND [ocsub].SchoolYear=c.SchoolYear AND [ocsub].TermId=c.TermId AND [ocstu].CourseCode=c.CourseCode

INNER JOIN [dbo].[Personnel] p ON [oct].[TeacherID]=p.[PersonnelID]

INNER JOIN [dbo].[OfficialClass] oc On [sch].NumericSchoolDBN=oc.NumericSchoolDBN AND [ocsub].[SchoolYear]=[oc].[SchoolYear] AND [ocsub].TermId=oc.TermId AND [ocsub].[OfficialClass]=oc.[OfficialClass]

INNER JOIN dbo.StudentTerm stt (NOLOCK) ON [sch].NumericSchoolDbn=stt.NumericSchoolDbn AND
       [ocsub].SchoolYear=stt.SchoolYear AND [ocsub].TermId=stt.TermId AND [ocstu].StudentID=stt.StudentID AND stt.[IsActive]=1

WHERE
	[ocsub].[SchoolYear] = @SY
	AND [ocsub].[IsActive] = 1 
	AND [ocstu].[IsActive] = 1
	and [oct].[IsActive] = 1
	AND SUBSTRING([ocstu].CourseCode,1,1)='P' AND SUBSTRING([ocstu].CourseCode,4,1)='J' 
	AND SUBSTRING (sch.schooldbn,1,1)<>'8'
	)a
GROUP BY 	
	 [SchoolYear]
	,[SchoolDBN]
	,[GradeLevel]
	,[TermID]
	,[dtTermBeginDate]
	,[dtTermEndDate]
	,[CurrentTermind]
	,[CourseCode]
	,[CourseName]
	,[CourseType]
	,[nPeriodId]
	,[RoomNumber]
	,[sCycledayBinaryString]
	,[nCycleDay]
	,[sDisplayName]
	,[tStartTime]
	,[tEndTime]
	,[nDuration_Minutes]
	,[nCourseCredits]
	,[nBellScheduleID]
	,[nTeachingPersonnelTermId]
	,[PersonnelID]
	,[EisID]
	,[DoeEmployeeID] 
	,[FirstName]
	,[LastName]
	,[Mail]
	,[OfficialClass]
	,[IsMTI]


--Data Conversion:
Input Column	Output Alias		Data Type			Length
EISId			EISId_Convert		string[DT_STR]		15
SchoolDBN		SchoolDBN_Convert	string[DT_STR]		6
GradeLevel		GradeLevel_Convert	string[DT_STR]		2

--OLE DB Destination ( destination table is the same as previous one)
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_STARS_CurrentSchoolYear_SchedulingByDay_Search]
--Table creation code:

USE FGR_INT
IF OBJECT_ID('[SWHUB_STARS_CurrentSchoolYear_SchedulingByDay_Search]') IS NOT NULL
DROP TABLE [SWHUB_STARS_CurrentSchoolYear_SchedulingByDay_Search]
CREATE TABLE [SWHUB_STARS_CurrentSchoolYear_SchedulingByDay_Search] (
 [nId] [int]					IDENTITY(1,1) NOT NULL
,[nSchoolYear]					smallint null
,[sSchoolDBN]					varchar(6) null
,[nTotalStudents]				int null
,[sGradeLevel]					varchar(2) null
,[nTermId]						tinyint null
,[dtTermBeginDate]				datetime
,[dtTermEndDate]				datetime
,[nCurrentTermInd]				bit
,[sCourseCode]					varchar(10) null
,[sCourseName]					varchar(40) null
,[sCourseType]					varchar(40) null
,[nSectionID]					int
,[nPeriodId]					smallint null
,[sRoomNumber]					varchar(10) null
,[sCycledayBinaryString]		varchar(10) null
,[nCycleDay]					smallint null
,[sDisplayName]					varchar(15) null
,[tStartTime]					datetime
,[tEndTime]						datetime
,[nDuration_Minutes]			int
,[nCourseCredits]				decimal(4,2) null
,[nBellScheduleID]				int
,[nTeachingPersonnelTermId]		int
,[nPersonnelID]					int null
,[sEISId]						varchar(15) null
,[sTeacher_FirstName]			varchar(50) null
,[sTeacher_LastName]			varchar(50) null
,[sTeacher_Emai]				varchar(100) null
,[DataPullDate]					datetime null
)

--Note: in the mapping ignore [nId] column mapping


--Variables for this Package:

Name			Scope											Data type			Value
PackageID		Package 01_Get STARS Data into Staging			Int32				1


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
 (1,'Package 01_Get STARS Data into Staging')