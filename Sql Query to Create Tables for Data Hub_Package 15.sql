--EST_Truncate_SWHUB_ISS_Pathway_Report
Connection: ES11VDEXTESQL01 FGR_INT FGRepUser
SQL Statement:
TRUNCATE TABLE SWHUB_ISS_Pathway_Report
GO

TRUNCATE TABLE [dbo].[SWHUB_ISS_Pathway_PETeachers_NotAttended_Workshop]
GO

TRUNCATE TABLE [dbo].[SWHUB_ISS_Pathway_HETeachers_NotAttended_Workshop]
GO

--DFT_SWHUB_ISS_Pathway_Report
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL Command text: 
SELECT DISTINCT pp.sEventParticipant_SchoolDBN
,pp.sEventParticipant_FirstName
,pp.sEventParticipant_LastName
,pp.sEmpStatus 
,pp.sEventParticipant_EmployeeNo
,pp.sEventParticipant_EISId
,pp.sEventParticipant_Email
,pp.sType
,pp.[nPathwayID],pp.sPathwayName
,CAST(ns.[nTotalWorkshops] AS int) AS [nTotalEvents_inSequence]
,pp.[# of events in Sequence1]
,pp.[# of events in Sequence2]
,pp.[# of events in Sequence3]
,pp.[# of events in Sequence4]
,pp.[# of events in Sequence5]
,CAST((Coalesce(pp.S1,0)+Coalesce(pp.S2,0)+Coalesce(pp.S3,0)+Coalesce(pp.S4,0)+Coalesce(pp.S5,0)) AS int) AS [# of Sequence Completed]

,CAST ((CAST((Coalesce(pp.S1,0)+Coalesce(pp.S2,0)+Coalesce(pp.S3,0)+Coalesce(pp.S4,0)+Coalesce(pp.S5,0)) AS decimal(3,1))/CAST(ns.[nTotalWorkshops] AS decimal(3,1))*100) AS int) 
 AS [% of Sequence Completed]
 ,pp.[Administrative_District_Code],pp.[Grades_Text],pp.[Grades_Final_Text],pp.[sPE_Cohort_Name],pp.[sMTI_Program_Status],
 pp.[sPEWorksFunded],stf.[sPE_NYS_Certified],stf.[sHE_NYS_Certified],stf.[sPE_NYC_Licensed],stf.[sHE_NYC_Licensed],stf.[StaffLabels] AS sStaff_Tags
,GETDATE()-1 AS [dtLastUpdatedDate]

FROM (
SELECT DISTINCT pv.[nPathwayID],pv.sPathwayName,pv.sType--,pv.sParticipant
,EPD.sEventParticipant_SchoolDBN
,EPD.sEventParticipant_FirstName
,EPD.sEventParticipant_LastName
,pv.sEmployeeNo AS [sEventParticipant_EmployeeNo]
,pv.sEmpStatus 
,EPD.sEventParticipant_EISId
,EPD.sEventParticipant_Email
,pv.[# of events in Sequence1]
,pv.[# of events in Sequence2]
,pv.[# of events in Sequence3]
,pv.[# of events in Sequence4]
,pv.[# of events in Sequence5]

,CASE WHEN pv.[# of events in Sequence1] IS NULL THEN 0 
	 WHEN pv.[# of events in Sequence1] ='' THEN 0 
ELSE 1 
END AS S1

,CASE WHEN pv.[# of events in Sequence2] IS NULL THEN 0 
	 WHEN pv.[# of events in Sequence2] ='' THEN 0 
ELSE 1 
END AS S2

,CASE WHEN pv.[# of events in Sequence3] IS NULL THEN 0 
	 WHEN pv.[# of events in Sequence3] ='' THEN 0 
ELSE 1 
END AS S3

,CASE WHEN pv.[# of events in Sequence4] IS NULL THEN 0 
	 WHEN pv.[# of events in Sequence4] ='' THEN 0 
ELSE 1 
END AS S4

,CASE WHEN pv.[# of events in Sequence5] IS NULL THEN 0 
	 WHEN pv.[# of events in Sequence5] ='' THEN 0 
ELSE 1 
END AS S5
,sch.[Administrative_District_Code],sch.[Grades_Text],sch.[Grades_Final_Text],mti.[sPE_Cohort_Name],mti.[sMTI_Program_Status],sch.[sPEWorksFunded]
FROM (
SELECT DISTINCT [nPathwayID],sPathwayName,sType,sEmployeeNo,sEmpStatus
,[1] AS [# of events in Sequence1]
,[2] AS [# of events in Sequence2]
,[3] AS [# of events in Sequence3]
,[4] AS [# of events in Sequence4]
,[5] AS [# of events in Sequence5]
FROM
(
SELECT DISTINCT [nPathwayID],sPathwayName,sType,sEmployeeNo,sEmpStatus,nSequence,[nEventsAttended] FROM ISS_TRNS_Pathway_EventParticipants
--,sParticipant
)ab
PIVOT
(SUM([nEventsAttended])
FOR nSequence IN (
[1],[2],[3],[4],[5]
) 
) AS PivotedTable
) pv

LEFT JOIN [SWHUB_ISS_EventParticipants] epd ON pv.sEmployeeNo=epd.[sEventParticipant_EmployeeNo] 

LEFT JOIN [dbo].[SWHUB_Supertable_Schools Dimension] sch ON epd.sEventParticipant_SchoolDBN=sch.[System_Code]

LEFT JOIN [dbo].[SWHUB_MTI Report] mti ON epd.sEventParticipant_SchoolDBN=mti.[sSchoolDBN]
)pp

LEFT JOIN (SELECT *  FROM [ISS_STG_ProgramEvent_PathwayNames]) ns ON pp.[nPathwayID]=ns.[nPathwayID]

LEFT JOIN 
(
SELECT sEmployeeNo,sEmail,[StaffLabels],[CertificationCode],sLicenceCode,[SecondaryLicenseCode],
CASE WHEN	([CertificationCode] LIKE '%6160%' OR [CertificationCode] LIKE '%6170%') THEN 'Y' END AS [sPE_NYS_Certified],
CASE WHEN ([CertificationCode] LIKE '%6120%' OR [CertificationCode] LIKE '%6121%') THEN 'Y' END AS [sHE_NYS_Certified], 
CASE WHEN	sLicenceCode IN ('418B','AP39','594B','549B','756B') OR 
			([SecondaryLicenseCode] LIKE '%418B%' OR [SecondaryLicenseCode] LIKE '%AP39%' OR 
			 [SecondaryLicenseCode] LIKE '%594B%' OR [SecondaryLicenseCode] LIKE '%549B%' OR 
			 [SecondaryLicenseCode] LIKE '%756B%') THEN 'Y' END AS [sPE_NYC_Licensed],

CASE WHEN	sLicenceCode IN ('703B','533B','735B') OR 
			([SecondaryLicenseCode] LIKE '%703B%' OR [SecondaryLicenseCode] LIKE '%533B%' OR 
			 [SecondaryLicenseCode] LIKE '%735B%') THEN 'Y' END AS [sHE_NYC_Licensed]
FROM SWHUB_TblStaffData ) stf ON pp.[sEventParticipant_EmployeeNo]=stf.sEmployeeNo 
ORDER BY pp.sEventParticipant_EmployeeNo,pp.[nPathwayID]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_ISS_Pathway_Report]
--Table creation code:
CREATE TABLE [dbo].[SWHUB_ISS_Pathway_Report](
	[sEventParticipant_SchoolDBN] [char](6) NULL,
	[sEventParticipant_FirstName] [varchar](50) NULL,
	[sEventParticipant_LastName] [varchar](50) NULL,
	[sEmpStatus] [char](1) NULL,
	[sEventParticipant_EmployeeNo] [char](15) NULL,
	[sEventParticipant_EISId] [char](7) NULL,
	[sEventParticipant_Email] [varchar](100) NULL,
	[sType] [char](1) NULL,
	[nPathwayID] [int] NULL,
	[sPathwayName] [varchar](50) NULL,
	[nTotalEvents_inSequence] [int] NULL,
	[# of events in Sequence1] [int] NULL,
	[# of events in Sequence2] [int] NULL,
	[# of events in Sequence3] [int] NULL,
	[# of events in Sequence4] [int] NULL,
	[# of events in Sequence5] [int] NULL,
	[# of Sequence Completed] [int] NULL,
	[% of Sequence Completed] [float] NULL,
	[sAdministrative_District_Code] [char](2) NULL,
	[sGrades_Text] [varchar](45) NULL,
	[sGrades_Final_Text] [varchar](45) NULL,
	[sPE_Cohort_Name] [varchar](100) NULL,
	[sMTI_Program_Status] [varchar](100) NULL,
	[sPEWorksFunded] [varchar](100) NULL,
	[sPE_NYS_Certified] [char](1) NULL,
	[sHE_NYS_Certified] [char](1) NULL,
	[sPE_NYC_Licensed] [char](1) NULL,
	[sHE_NYC_Licensed] [char](1) NULL,
	[sStaff_Tags] [nvarchar](max) NULL,
	[dtLastUpdatedDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

--DFT_SWHUB_ISS_Pathway_PETeachers_NotAttended_Workshop
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL Command text: 
--For PE teachers who didn't participate Pathway Workshop
SELECT DISTINCT 
staff.[sSchoolDBN],
staff.[sFirstName],
staff.[sLastName],
staff.[sEmpStatus],
staff.[sEmployeeNo],
staff.[sEISId],
staff.[sEmail],

sch.[Administrative_District_Code],
sch.[Grades_Text],
sch.[Grades_Final_Text],
mti.[sPE_Cohort_Name],
mti.[sMTI_Program_Status],
sch.[sPEWorksFunded],

CASE WHEN	(staff.[CertificationCode] LIKE '%6160%' OR staff.[CertificationCode] LIKE '%6170%') THEN 'Y' END AS [sPE_NYS_Certified],
CASE WHEN (staff.[CertificationCode] LIKE '%6120%' OR staff.[CertificationCode] LIKE '%6121%') THEN 'Y' END AS [sHE_NYS_Certified], 
CASE WHEN	staff.sLicenceCode IN ('418B','AP39','594B','549B','756B') OR 
			(staff.[SecondaryLicenseCode] LIKE '%418B%' OR staff.[SecondaryLicenseCode] LIKE '%AP39%' OR 
			 staff.[SecondaryLicenseCode] LIKE '%594B%' OR staff.[SecondaryLicenseCode] LIKE '%549B%' OR 
			 staff.[SecondaryLicenseCode] LIKE '%756B%') THEN 'Y' END AS [sPE_NYC_Licensed],

CASE WHEN	staff.sLicenceCode IN ('703B','533B','735B') OR 
			(staff.[SecondaryLicenseCode] LIKE '%703B%' OR staff.[SecondaryLicenseCode] LIKE '%533B%' OR 
			staff.[SecondaryLicenseCode] LIKE '%735B%') THEN 'Y' END AS [sHE_NYC_Licensed]

,staff.[StaffLabels] AS sStaff_Tags
,GETDATE()-1 AS [dtLastUpdatedDate]
FROM [dbo].[SWHUB_TblStaffData] staff (NOLOCK)

LEFT JOIN [dbo].[SWHUB_Supertable_Schools Dimension] (NOLOCK) sch ON staff.sSchoolDBN=sch.[System_Code]

LEFT JOIN [dbo].[SWHUB_MTI Report] (NOLOCK) mti ON staff.sSchoolDBN=mti.[sSchoolDBN]

WHERE staff.[sEmpStatus]='A' AND staff.[sEmployeeNo] IN ( --PE teachers who didn't participate any Pathway Workshop
SELECT DISTINCT EmployeeNo FROM [dbo].[SWHUB_ISS_TeacherProfileLabels] (NOLOCK) WHERE ComponentID in (6,16,18,49,50,63) 
AND EmployeeNo NOT IN (
SELECT DISTINCT [sEventParticipant_EmployeeNo] FROM [dbo].[SWHUB_ISS_Pathway_Report] (NOLOCK) where npathwayID IN (1,2)) 
)

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_ISS_Pathway_Report]
--Table creation code:
CREATE TABLE [dbo].[SWHUB_ISS_Pathway_PETeachers_NotAttended_Workshop](
	[sSchoolDBN] [char](6) NULL,
	[sFirstName] [varchar](50) NULL,
	[sLastName] [varchar](50) NULL,
	[sEmpStatus] [char](1) NULL,
	[sEmployeeNo] [char](10) NULL,
	[sEISId] [char](7) NULL,
	[sEmail] [varchar](100) NULL,
	[sAdministrative_District_Code] [char](2) NULL,
	[sGrades_Text] [varchar](45) NULL,
	[sGrades_Final_Text] [varchar](45) NULL,
	[sPE_Cohort_Name] [varchar](100) NULL,
	[sMTI_Program_Status] [varchar](100) NULL,
	[sPEWorksFunded] [varchar](100) NULL,
	[sPE_NYS_Certified] [char](1) NULL,
	[sHE_NYS_Certified] [char](1) NULL,
	[sPE_NYC_Licensed] [char](1) NULL,
	[sHE_NYC_Licensed] [char](1) NULL,
	[sStaff_Tags] [nvarchar](max) NULL,
	[dtLastUpdatedDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


--DFT_SWHUB_ISS_Pathway_HETeachers_NotAttended_Workshop
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL Command text: 
--For HE teachers who didn't participate Pathway Workshop
SELECT DISTINCT 
staff.[sSchoolDBN],
staff.[sFirstName],
staff.[sLastName],
staff.[sEmpStatus],
staff.[sEmployeeNo],
staff.[sEISId],
staff.[sEmail],

sch.[Administrative_District_Code],
sch.[Grades_Text],
sch.[Grades_Final_Text],
mti.[sPE_Cohort_Name],
mti.[sMTI_Program_Status],
sch.[sPEWorksFunded],

CASE WHEN	(staff.[CertificationCode] LIKE '%6160%' OR staff.[CertificationCode] LIKE '%6170%') THEN 'Y' END AS [sPE_NYS_Certified],

CASE WHEN (staff.[CertificationCode] LIKE '%6120%' OR staff.[CertificationCode] LIKE '%6121%') THEN 'Y' END AS [sHE_NYS_Certified],
 
CASE WHEN	staff.sLicenceCode IN ('418B','AP39','594B','549B','756B') OR 
			(staff.[SecondaryLicenseCode] LIKE '%418B%' OR staff.[SecondaryLicenseCode] LIKE '%AP39%' OR 
			 staff.[SecondaryLicenseCode] LIKE '%594B%' OR staff.[SecondaryLicenseCode] LIKE '%549B%' OR 
			 staff.[SecondaryLicenseCode] LIKE '%756B%') THEN 'Y' END AS [sPE_NYC_Licensed],

CASE WHEN	staff.sLicenceCode IN ('703B','533B','735B') OR 
			(staff.[SecondaryLicenseCode] LIKE '%703B%' OR staff.[SecondaryLicenseCode] LIKE '%533B%' OR 
			staff.[SecondaryLicenseCode] LIKE '%735B%') THEN 'Y' END AS [sHE_NYC_Licensed]

,staff.[sLicenceDesc],staff.[SecondaryLicenseDesc],staff.[CertificationDesc]
,staff.[StaffLabels] AS sStaff_Tags
,GETDATE()-1 AS [dtLastUpdatedDate]
FROM [dbo].[SWHUB_TblStaffData] (NOLOCK) staff

LEFT JOIN [dbo].[SWHUB_Supertable_Schools Dimension] (NOLOCK) sch ON staff.sSchoolDBN=sch.[System_Code]

LEFT JOIN [dbo].[SWHUB_MTI Report] (NOLOCK) mti ON staff.sSchoolDBN=mti.[sSchoolDBN]

WHERE staff.[sEmpStatus]='A' AND staff.[sEmployeeNo] IN ( --HE teachers who didn't participate any Pathway Workshop
SELECT DISTINCT EmployeeNo FROM [dbo].[SWHUB_ISS_TeacherProfileLabels] (NOLOCK) WHERE ComponentID in (7,51,52)
AND EmployeeNo NOT IN (
SELECT DISTINCT [sEventParticipant_EmployeeNo] FROM [dbo].[SWHUB_ISS_Pathway_Report] (NOLOCK) where npathwayID IN (3,4,5))
)

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_ISS_Pathway_HETeachers_NotAttended_Workshop]
--Table creation code:
CREATE TABLE [dbo].[SWHUB_ISS_Pathway_HETeachers_NotAttended_Workshop](
	[sSchoolDBN] [char](6) NULL,
	[sFirstName] [varchar](50) NULL,
	[sLastName] [varchar](50) NULL,
	[sEmpStatus] [char](1) NULL,
	[sEmployeeNo] [char](10) NULL,
	[sEISId] [char](7) NULL,
	[sEmail] [varchar](100) NULL,
	[sAdministrative_District_Code] [char](2) NULL,
	[sGrades_Text] [varchar](45) NULL,
	[sGrades_Final_Text] [varchar](45) NULL,
	[sPE_Cohort_Name] [varchar](100) NULL,
	[sMTI_Program_Status] [varchar](100) NULL,
	[sPEWorksFunded] [varchar](100) NULL,
	[sPE_NYS_Certified] [char](1) NULL,
	[sHE_NYS_Certified] [char](1) NULL,
	[sPE_NYC_Licensed] [char](1) NULL,
	[sHE_NYC_Licensed] [char](1) NULL,
	[sStaff_Tags] [nvarchar](max) NULL,
	[dtLastUpdatedDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


--Variables for this Package:

Name			Scope								Data type			Value
PackageID		Package 15_Pathway_Report 			Int32				15


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
VALUES (15,'Package 15_Pathway_Report')


