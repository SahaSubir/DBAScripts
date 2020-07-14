--EST_Set Event Status To "Attendance Pending" From "Upcoming"
Update [dbo].[ISS_tblProgramEvents] 
SET nEventStatusID=7 -- Set Event Status To "Attendance Pending" From "Upcoming"
Where nEventID in (Select nEventID FROM  [dbo].[ISS_tblProgramEvents] Where nEventStatusID=6 And Convert(Varchar,dtEventDate,101)=Convert(Varchar,GETDATE()+1,101))
GO

--EST_Delete data from destination tables
TRUNCATE TABLE [dbo].[SWHUB_ISS_PersonalInfo]
GO

TRUNCATE TABLE [dbo].[SWHUB_ISS_TeacherProfile]
GO

TRUNCATE TABLE [dbo].[SWHUB_ISS_TeacherProfileLabels]
GO

TRUNCATE TABLE [SWHUB_ISS_Emp_State_Certificates]
GO

TRUNCATE TABLE [SWHUB_ISS_Emp_City_SecondaryLicenses]
GO

TRUNCATE TABLE [dbo].[SWHUB_ISS_Programs]
GO

TRUNCATE TABLE [dbo].[SWHUB_ISS_ProgramParticipants]
GO

TRUNCATE TABLE [ISS_TRNS_Events]
GO

TRUNCATE TABLE [SWHUB_ISS_EventParticipants]
GO

TRUNCATE TABLE [SWHUB_ISS_Events]
GO

TRUNCATE TABLE [ISS_STG_ProgramEvent_PathwayNames]
GO

TRUNCATE TABLE [ISS_STG_ProgramEvent_PathwayTracking]
GO

TRUNCATE TABLE [ISS_STG_ProgramEvent_PathwayWorkshops]
GO

TRUNCATE TABLE [ISS_TRNS_Pathway_EventParticipants]
GO

TRUNCATE TABLE [SWHUB_ISS_InteractionParticipants]
GO

TRUNCATE TABLE [SWHUB_ISS_Interacted_Schools]
GO

TRUNCATE TABLE [SWHUB_ISS_Interacted_Staffs]
GO

TRUNCATE TABLE [SWHUB_ISS_Interactions]
GO

--EST_Delete all event data for events with "Delete from Hub" event status
--Connection Type: OLEDB
--Connection: ES11VDEXTESQL01.ISS_EXT.useriss
--SQL statement:

DELETE FROM [dbo].[ISS_tblEventParticipants] WHERE [nEventID] IN (SELECT DISTINCT nEventID FROM [dbo].[ISS_tblProgramEvents] where [nEventStatusID]=44)
Go
DELETE FROM [dbo].[ISS_tblProgramEvent_PathwayTracking] WHERE [nEventID] IN (SELECT DISTINCT nEventID FROM [dbo].[ISS_tblProgramEvents] where [nEventStatusID]=44)
Go
DELETE FROM [ISS_tblEventTags]WHERE [nEventID] IN (SELECT DISTINCT nEventID FROM [dbo].[ISS_tblProgramEvents] where [nEventStatusID]=44)
Go
DELETE  FROM [dbo].[OSWP_TblWHubFiles] WHERE [FileCategory_Id]IN (SELECT DISTINCT nEventID FROM [dbo].[ISS_tblProgramEvents] where [nEventStatusID]=44) and FileCategory ='Event'
Go
DELETE FROM [dbo].[ISS_tblProgramEvents] WHERE [nEventStatusID]=44
Go

--Sequence Container1
--DFT_SWHUB_ISS_PersonalInfo
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL command text:
SELECT DISTINCT a.[nEmpId],a.sEmployeeNo,a.sEISId,b.[sEmail],b.sUserID,a.sLastName,a.sFirstName,a.[Gender],a.[sSchoolDBN],a.[sOtherDBNs],b.[bIsActive],a.sEmpStatus,a.sTitleCode_Gxy,a.[sTitleDesc_Gxy],a.[sTitleCode_EIS],
a.Is_Primary_Location,a.Central_Inst_Flag,a.[sLicenceCode],a.[sLicenceDesc],a.[Seniority_YY],a.[Seniority_MM],a.[DOE_Start_Date],a.[Assignment_Code],a.[Assignment_Desc],
CASE WHEN c.sEmployeeNo IS NOT NULL THEN 'Y' ELSE 'N' END AS APE_Teacher_Flag,
a.[SSN],a.[DOB],a.[sReason_Code],a.[sReason_Desc],a.[sPMS_Status],
GETDATE() AS [DataPulledDate] 
FROM 
(
SELECT DISTINCT [nEmpId],sEmployeeNo,sEISId,sLastName,sFirstName,sEmpStatus,sTitleCode_Gxy,[sTitleDesc_Gxy],[sTitleCode_EIS],Is_Primary_Location,Central_Inst_Flag,[sSchoolDBN],[sOtherDBNs],[Gender],
[sLicenceCode],[sLicenceDesc],[Seniority_YY],[Seniority_MM],[DOE_Start_Date],[Assignment_Code],[Assignment_Desc],[SSN],[DOB],[sReason_Code],[sReason_Desc],[sPMS_Status]
FROM [ISS_tblPersonalInfo] (NOLOCK) WHERE sEmpStatus='A' AND sEmployeeNo IS NOT NULL
) a
LEFT JOIN (SELECT * FROM [dbo].[ISS_tblADUsers] (NOLOCK) WHERE bIsActive='A') b
ON a.sEmployeeNo=b.[sEmployeeNo] 
LEFT JOIN 
(SELECT a.[sEISID],a.[sEmployeeNo],a.[nComponentID],b.sComponentName,b.sComponentDesc,a.InAccurate_Flag,a.LastModifiedDate,b.Is_Active,b.Is_AutoLabel,b.Is_AutoRefresh_Flag 
FROM [dbo].[ISS_tblTeacherProfileLabels] (NOLOCK) a
INNER JOIN (SELECT * FROM [dbo].[ISS_tblTeacherLabelsLookUp] (NOLOCK) WHERE nComponentID=16 AND Is_Active='Y')b
ON a.nComponentID=b.nComponentID) c 
ON a.sEmployeeNo=c.sEmployeeNo

--Data Conversion:
Input Column		Output Alias					Data Type			Length
APE_Teacher_Flag	APE_Teacher_Flag_Convert		string[DT_STR]		1


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_ISS_PersonalInfo]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[SWHUB_ISS_PersonalInfo]') IS NOT NULL
	DROP TABLE [SWHUB_ISS_PersonalInfo]
CREATE TABLE [dbo].[SWHUB_ISS_PersonalInfo](
	[nEmpId] [numeric](18, 0) NOT NULL,
	[EmployeeNo] [varchar](20) NULL,
	[EISId] [char](7) NULL,
	[UserID] [varchar](50) NULL,
	[Email] [varchar](100) NULL,
	[LastName] [varchar](100) NULL,
	[FirstName] [varchar](100) NULL,
	[Gender] [char](1) NULL,
	[SchoolDBN] [char](6) NULL,
	[OtherDBNs] [varchar](150) NULL,
	[IsActive_AD] [char](1) NULL,
	[EmpStatus_HR] [char](1) NULL,
	[TitleCode_Gxy] [char](5) NULL,
	[TitleDesc_Gxy] [varchar](100) NULL,
	[TitleCode_EIS] [char](5) NULL,
	[Is_Primary_Location] [char](1) NULL,
	[Central_Inst_Flag] [char](1) NULL,
	[LicenceCode_Primary] [varchar](10) NULL,
	[LicenceDesc_Primary] [varchar](150) NULL,
	[Seniority_YY] [char](3) NULL,
	[Seniority_MM] [char](3) NULL,
	[DOE_Start_Date] [varchar](15) NULL,
	[Assignment_Code] [varchar](15) NULL,
	[Assignment_Desc] [varchar](300) NULL,
	[APE_Teacher_Flag] [char](1) NULL,
	[DataPulledDate] [datetime] NULL,
	[SSN] [varchar](20) NULL,
	[DOB] [varchar](20) NULL,
	[sReason_Code] [char](3) NULL,
	[sReason_Desc] [varchar](150) NULL,
	[sPMS_Status] [varchar](150) NULL
) ON [PRIMARY]
GO

--DFT_SWHUB_ISS_TeacherProfile
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL command text:
SELECT
[sEISID],
[sTitle],
[sOtherDBNs],
[sCellPhone],
[sPersonalPhone],
[sNotes],
[sLastUpdatedBy],
[dtLastUpdatedOn],
[sEmployeeNo],
[CoachNotes],
[CYSExpDate],
[CPRExpDate],
[AdminNotes],
[Phone],
[sOtherEmail],
[Is_TextMessage],
[sNoteDate],
GETDATE() AS [DataPulledDate]
FROM [dbo].[ISS_tblTeacherProfile] (NOLOCK)

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_ISS_TeacherProfile]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[SWHUB_ISS_TeacherProfile]') IS NOT NULL
	DROP TABLE [SWHUB_ISS_TeacherProfile]
CREATE TABLE [dbo].[SWHUB_ISS_TeacherProfile](
	[EISID] [varchar](7) NOT NULL,
	[EmployeeNo] [varchar](15) NULL,
	[Title] [varchar](50) NULL,
	[OtherDBNs] [varchar](300) NULL,
	[CellPhone] [varchar](20) NULL,
	[PersonalPhone] [varchar](20) NULL,
	[Notes] [varchar](1000) NULL,
	[NotesDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[CoachNotes] [varchar](1000) NULL,
	[CYSExpDate] [datetime] NULL,
	[CPRExpDate] [datetime] NULL,
	[AdminNotes] [varchar](1000) NULL,
	[Phone] [varchar](15) NULL,
	[OtherEmail] [varchar](100) NULL,
	[Is_TextMessage] [varchar](1) NULL,
	[DataPulledDate] [datetime] NULL
) ON [PRIMARY]

GO

--DFT_SWHUB_ISS_TeacherProfileLabels
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL command text:
SELECT a.[sEISID],a.[sEmployeeNo],a.[nComponentID],b.sComponentName,b.sComponentDesc,a.InAccurate_Flag,a.LastModifiedDate,
b.Is_Active,b.Is_AutoLabel,b.Is_AutoRefresh_Flag,GETDATE() AS [DataPulledDate] 
FROM [dbo].[ISS_tblTeacherProfileLabels]  (NOLOCK) a
INNER JOIN (SELECT * FROM [dbo].[ISS_tblTeacherLabelsLookUp] (NOLOCK)
)b
ON a.nComponentID=b.nComponentID

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_ISS_TeacherProfileLabels]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[SWHUB_ISS_TeacherProfileLabels]') IS NOT NULL
	DROP TABLE [SWHUB_ISS_TeacherProfileLabels]
CREATE TABLE [dbo].[SWHUB_ISS_TeacherProfileLabels](
	[EISID] [varchar](7) NULL,
	[EmployeeNo] [varchar](15) NULL,
	[ComponentID] [int] NOT NULL,
	[ComponentName] [varchar](100) NULL,
	[ComponentDesc] [varchar](100) NULL,
	[InAccurate_Flag] [char](1) NULL,
	[LastModifiedDate] [datetime] NULL,
	[Is_Active] [char](1) NULL,
	[Is_AutoLabel] [char](1) NULL,
	[Is_AutoRefresh_Flag] [char](1) NULL,
	[DataPulledDate] [datetime] NULL
	)

--DFT_SWHUB_ISS_ProgramParticipants
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL command text:
SELECT
[nProgramId],
[sParticipantSchDBN],
[sFiscalYear],
[dtLastUpdatedDate],
[sLastUpdatedBy],
[sDistrict],
[sLocationCode],
GETDATE() AS [DataPulledDate]
FROM [dbo].[ISS_tblProgramParticipants] (NOLOCK)

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_ISS_ProgramParticipants]
--Table creation code:
IF OBJECT_ID('[SWHUB_ISS_ProgramParticipants]') IS NOT NULL
	DROP TABLE [SWHUB_ISS_ProgramParticipants]
CREATE TABLE [dbo].[SWHUB_ISS_ProgramParticipants](
	[ProgramId] [numeric](18, 0) NOT NULL,
	[ParticipantSchoolDBN] [char](6) NOT NULL,
	[FiscalYear] [char](4) NOT NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [varchar](100) NULL,
	[District] [char](2) NULL,
	[LocationCode] [char](4) NULL,
	[DataPulledDate] [datetime] NULL
	)


--DFT_SWHUB_ISS_Programs
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL command text:
SELECT
[nProgramId],
[sProgramCode],
[sProgramName],
[sProgramDesc],
[sFiscalYear],
[dtProgStartDate],
[dtProgEndDate],
[nProgramCost],
[nProgramStatus],
[Is_Active],
[sLastUpdatedBy],
[dtLastUpdatedDate],
[nSupervisorID],
[sPartnerContactInfo],
[in_manager],
[ch_confirm_req],
GETDATE() AS [DataPulledDate]
FROM [dbo].[ISS_tblPrograms] (NOLOCK)

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_ISS_Programs]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[SWHUB_ISS_Programs]') IS NOT NULL
	DROP TABLE [SWHUB_ISS_Programs]
CREATE TABLE [dbo].[SWHUB_ISS_Programs](
	[ProgramId] [numeric](18, 0) NOT NULL,
	[ProgramCode] [varchar](50) NULL,
	[ProgramName] [varchar](100) NULL,
	[ProgramDesc] [varchar](5000) NULL,
	[FiscalYear] [char](4) NULL,
	[ProgStartDate] [datetime] NULL,
	[ProgEndDate] [datetime] NULL,
	[ProgramCost] [money] NULL,
	[ProgramStatus] [smallint] NULL,
	[Is_Active] [char](1) NULL,
	[LastUpdatedBy] [varchar](100) NULL,
	[LastUpdatedDate] [datetime] NULL,
	[SupervisorID] [numeric](18, 0) NULL,
	[PartnerContactInfo] [varchar](1000) NULL,
	[in_manager] [varchar](1) NULL,
	[ch_confirm_req] [bit] NULL,
	[DataPulledDate] [datetime] NULL
	)

--DFT_SWHUB_ISS_Emp_City_SecondaryLicenses
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL command text:
SELECT [PMS],
[License1],[License_Desc1],
[License2],[License_Desc2],
[License3],[License_Desc3],
[License4],[License_Desc4],
[License5],[License_Desc5],
[License6],[License_Desc6],
[License7],[License_Desc7],
[License8],[License_Desc8],
STUFF(dbo.DistinctList(SecondaryLicenseCode,','),1,1,'') AS SecondaryLicenseCode_N,STUFF(dbo.DistinctList(SecondaryLicenseDesc,','),1,1,'') AS SecondaryLicenseDesc_N,
GETDATE()  AS [DataPulledDate] 
FROM

(SELECT TEL.*,
(LTRIM(RTRIM(TEL.License1)) + ',' + LTRIM(RTRIM(TEL.License2)) + ',' + LTRIM(RTRIM(TEL.License3)) + ',' + LTRIM(RTRIM(TEL.License4)) + ',' + LTRIM(RTRIM(TEL.License5)) + ',' + LTRIM(RTRIM(TEL.License6)) + ',' + LTRIM(RTRIM(TEL.License7)) + ',' + LTRIM(RTRIM(TEL.License8))) AS SecondaryLicenseCode,
(LTRIM(RTRIM(TEL.License_Desc1)) + ',' + LTRIM(RTRIM(TEL.License_Desc2)) + ',' + LTRIM(RTRIM(TEL.License_Desc3)) + ',' + LTRIM(RTRIM(TEL.License_Desc4)) + ',' + LTRIM(RTRIM(TEL.License_Desc5)) + ',' + LTRIM(RTRIM(TEL.License_Desc6)) + ',' + LTRIM(RTRIM(TEL.License_Desc7)) + ',' + LTRIM(RTRIM(TEL.License_Desc8))) AS SecondaryLicenseDesc

FROM  [dbo].[ISS_Emp_Licenses] (NOLOCK) TEL 
)T


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_ISS_Emp_City_SecondaryLicenses]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[SWHUB_ISS_Emp_City_SecondaryLicenses]') IS NOT NULL
	DROP TABLE [SWHUB_ISS_Emp_City_SecondaryLicenses]
CREATE TABLE [dbo].[SWHUB_ISS_Emp_City_SecondaryLicenses](
	[PMS] [varchar](15) NOT NULL,
	[License1] [varchar](10) NULL,
	[License_Desc1] [varchar](500) NULL,
	[License2] [varchar](10) NULL,
	[License_Desc2] [varchar](500) NULL,
	[License3] [varchar](10) NULL,
	[License_Desc3] [varchar](500) NULL,
	[License4] [varchar](10) NULL,
	[License_Desc4] [varchar](500) NULL,
	[License5] [varchar](10) NULL,
	[License_Desc5] [varchar](500) NULL,
	[License6] [varchar](10) NULL,
	[License_Desc6] [varchar](500) NULL,
	[License7] [varchar](10) NULL,
	[License_Desc7] [varchar](500) NULL,
	[License8] [varchar](10) NULL,
	[License_Desc8] [varchar](500) NULL,
	[SecondaryLicenseCode][varchar](8000) NULL,
	[SecondaryLicenseDesc] [varchar](max) NULL,
	[DataPulledDate] [datetime] NULL
)

--DFT_SWHUB_ISS_Emp_State_Certificates
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL command text:
SELECT [PMS],
[CERT_ID1],[CERT_ID_DESC1],
[CERT_ID2],[CERT_ID_DESC2], 
[CERT_ID3],[CERT_ID_DESC3],
[CERT_ID4],[CERT_ID_DESC4],
[CERT_ID5],[CERT_ID_DESC5],
[CERT_ID6],[CERT_ID_DESC6], 
[CERT_ID7],[CERT_ID_DESC7],
[CERT_ID8],[CERT_ID_DESC8],
STUFF(dbo.DistinctList(CertificationCode,','),1,1,'') AS CertificationCode,STUFF(dbo.DistinctList(CertificationDesc,','),1,1,'') AS CertificationDesc,
GETDATE()  AS [DataPulledDate] 
FROM
(

SELECT TEC.*,
(LTRIM(RTRIM(TEC.CERT_ID1)) + ',' + LTRIM(RTRIM(TEC.CERT_ID2)) + ',' + LTRIM(RTRIM(TEC.CERT_ID3)) + ',' + LTRIM(RTRIM(TEC.CERT_ID4)) + ',' + LTRIM(RTRIM(TEC.CERT_ID5)) + ',' + LTRIM(RTRIM(TEC.CERT_ID6)) + ',' + LTRIM(RTRIM(TEC.CERT_ID7)) + ',' + LTRIM(RTRIM(TEC.CERT_ID8))) CertificationCode,
(LTRIM(RTRIM(TEC.CERT_ID_DESC1)) + ',' + LTRIM(RTRIM(TEC.CERT_ID_DESC2)) + ',' + LTRIM(RTRIM(TEC.CERT_ID_DESC3)) + ',' + LTRIM(RTRIM(TEC.CERT_ID_DESC4)) + ',' + LTRIM(RTRIM(TEC.CERT_ID_DESC5)) + ',' + LTRIM(RTRIM(TEC.CERT_ID_DESC6))+ ',' + LTRIM(RTRIM(TEC.CERT_ID_DESC7)) + ',' + LTRIM(RTRIM(TEC.CERT_ID_DESC8))) CertificationDesc
FROM  ISS_Emp_Certs (NOLOCK) TEC 
)T

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_ISS_Emp_State_Certificates]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[SWHUB_ISS_Emp_State_Certificates]') IS NOT NULL
	DROP TABLE [SWHUB_ISS_Emp_State_Certificates]
CREATE TABLE [dbo].[SWHUB_ISS_Emp_State_Certificates](
	[PMS] [varchar](15) NOT NULL,
	[CERT_ID1] [varchar](10) NULL,
	[CERT_ID_DESC1] [varchar](500) NULL,
	[CERT_ID2] [varchar](10) NULL,
	[CERT_ID_DESC2] [varchar](500) NULL,
	[CERT_ID3] [varchar](10) NULL,
	[CERT_ID_DESC3] [varchar](500) NULL,
	[CERT_ID4] [varchar](10) NULL,
	[CERT_ID_DESC4] [varchar](500) NULL,
	[CERT_ID5] [varchar](10) NULL,
	[CERT_ID_DESC5] [varchar](500) NULL,
	[CERT_ID6] [varchar](10) NULL,
	[CERT_ID_DESC6] [varchar](500) NULL,
	[CERT_ID7] [varchar](10) NULL,
	[CERT_ID_DESC7] [varchar](500) NULL,
	[CERT_ID8] [varchar](10) NULL,
	[CERT_ID_DESC8] [varchar](500) NULL,
	[CertificationCode][varchar](8000) NULL,
	[CertificationDesc] [varchar](max) NULL,
	[DataPulledDate] [datetime] NULL
)


--DFT_ISS_STG_ProgramEvent_PathwayNames
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or View
--Name of the table or the view: ISS_tblProgramEvent_PathwayNames

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_STG_ProgramEvent_PathwayNames]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[ISS_STG_ProgramEvent_PathwayNames]') IS NOT NULL
DROP TABLE [ISS_STG_ProgramEvent_PathwayNames]
CREATE TABLE [ISS_STG_ProgramEvent_PathwayNames] (
	[nPathwayID] [int] NULL,
	[sPathwayName] [varchar](50) NULL,
	[nTotalWorkshops] [int] NULL,
	[nContentID] [int] NULL
)


--DFT_ISS_STG_ProgramEvent_PathwayTracking
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or View
--Name of the table or the view: ISS_tblProgramEvent_PathwayTraking

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_STG_ProgramEvent_PathwayTracking]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[ISS_STG_ProgramEvent_PathwayTracking]') IS NOT NULL
DROP TABLE [ISS_STG_ProgramEvent_PathwayTracking]
CREATE TABLE [ISS_STG_ProgramEvent_PathwayTracking] (
	[nPathwayID] [int] NULL,
	[nEventID] [int] NULL,
	[nWorkshopNameID] [int] NULL
) 

--DFT_ISS_STG_ProgramEvent_PathwayWorkshops
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or View
--Name of the table or the view: ISS_tblProgramEvent_PathwayWorkshops

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_STG_ProgramEvent_PathwayWorkshops]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[ISS_STG_ProgramEvent_PathwayWorkshops]') IS NOT NULL
DROP TABLE [ISS_STG_ProgramEvent_PathwayWorkshops]
CREATE TABLE [ISS_STG_ProgramEvent_PathwayWorkshops] (
	[nPathwayID] [int] NULL,
	[sWorkshopName] [varchar](250) NULL,
	[nSequence] [int] NULL,
	[nRequiredWorkshopID] [int] NULL,
	[nWorkshopNameID] [int] NULL,
	[sActive] [char](1) NULL
)

--DFT_ISS_TRNS_Pathway_EventParticipants
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL command text:
SELECT DISTINCT t.sEmployeeNo,t.[sEmpStatus]
,t.[sParticipant]
,t.[sType]
,t.[sParticipantDesc],t.[nPathwayID],t.[sPathwayName]
,t.[sWorkshopName]
,t.[nSequence]
,COUNT(t.nEventID) AS [nEventsAttended] 
FROM (
SELECT DISTINCT
 ep.[nEventID]
,ep.[sParticipant]
,ep.[sType]
,ep.[sParticipantDesc]
,ep.[Is_Presenter]
,ep.[sPresenter_Name]
,ep.[sEmployeeNo]
,ep.[Participant_Status]
,ep.[EvalSurveyOpen]
,ep.[EvalSurveyComplete]
,ep.[PreSurvey1]
,ep.[PreSurvey2]
,ep.[PreSurvey3]
,pt.[nWorkshopNameID]
,pt.[nPathwayID]
,pn.[sPathwayName],pn.[nTotalWorkshops],pn.[nContentID]
,pw.[sWorkshopName],pw.[nSequence],pw.[nRequiredWorkshopID]
,pei.[sEmpStatus]
FROM 
(SELECT DISTINCT [nEventID],LOWER(CASE WHEN sParticipant like '%@schools.nyc.gov%'  THEN REPLACE(SUBSTRING(sParticipant,1,(CHARINDEX('@', sParticipant))),'@','') ELSE sParticipant END) AS [sParticipant]
,[sType],[sParticipantDesc],[Is_Presenter],[sPresenter_Name],[sEmployeeNo],[Participant_Status],[EvalSurveyOpen],[EvalSurveyComplete],[PreSurvey1],[PreSurvey2],[PreSurvey3]
FROM		[dbo].[ISS_tblEventParticipants]) ep
INNER JOIN	[dbo].[ISS_tblProgramEvents] pev ON ep.nEventID=pev.nEventID
INNER JOIN	[dbo].[ISS_tblProgramEvent_PathwayTracking] pt ON ep.nEventID=pt.nEventID
LEFT JOIN	[dbo].[ISS_tblProgramEvent_PathwayNames] pn ON pt.nPathwayID=pn.nPathwayID
LEFT JOIN	[dbo].[ISS_tblProgramEvent_PathwayWorkshops] pw ON pt.[nWorkshopNameID]=pw.[nWorkshopNameID] 
LEFT JOIN	[dbo].[ISS_tblPersonalInfo] pei ON ep.[sEmployeeNo]=pei.[sEmployeeNo]
WHERE ep.Participant_Status=26 AND ep.sType='U' AND pev.nEventStatusID=42 AND (ep.sEmployeeNo IS NOT NULL OR ep.sEmployeeNo<>'') --AND pei.[sEmpStatus] IS NOT NULL
)t
GROUP BY t.[nPathwayID],t.[sPathwayName],t.[sParticipant],t.[sEmpStatus]
,t.[sType]
,t.[sParticipantDesc]
,t.sEmployeeNo
,t.[sWorkshopName]
,t.[nSequence]
ORDER BY sEmployeeNo

--Data Conversion:
Input Column		Output Alias				Data Type			Length
sParticipant		sParticipant_Convert		string[DT_STR]		200


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_TRNS_Pathway_EventParticipants]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[SWHUB_ISS_EventParticipants]') IS NOT NULL
DROP TABLE [SWHUB_ISS_EventParticipants]
CREATE TABLE [dbo].[SWHUB_ISS_EventParticipants](
	[nEventId] [bigint] NULL,
	[sEventName] [varchar](200) NULL,
	[nEventTypeID] [int] NULL,
	[sEventType] [varchar](50) NULL,
	[nContentID] [int] NULL,
	[sContentName] [varchar](50) NULL,
	[nProgramId] [numeric](18, 0) NULL,
	[sProgramName] [varchar](100) NULL,
	[sProgramCode] [varchar](50) NULL,
	[nEventStaffID] [numeric](18, 0) NULL,
	[sPointPerson_FirstName] [varchar](50) NULL,
	[sPointPerson_LastName] [varchar](50) NULL,
	[sPointPerson_EmployeeNo] [char](10) NULL,
	[sPointPerson_EISId] [char](7) NULL,
	[sPointPerson_Email] [varchar](100) NULL,
	[dtEventDate] [datetime] NULL,
	[nSchool_Year] [int] NULL,
	[tEventStartTime] [datetime] NULL,
	[tEventEndTime] [datetime] NULL,
	[nEventStatusID] [int] NULL,
	[sEventStatus] [varchar](50) NULL,
	[sEventLocation] [varchar](300) NULL,
	[sParticipant] [varchar](200) NULL,
	[sEventParticipantType] [char](1) NULL,
	[sEventParticipantTypeDesc] [varchar](25) NULL,
	[nParticipant_Status] [int] NULL,
	[sParticipant_Status_Desc] [varchar](50) NULL,
	[sEventParticipant_SchoolDBN] [char](6) NULL,
	[sEventParticipant_FirstName] [varchar](50) NULL,
	[sEventParticipant_LastName] [varchar](50) NULL,
	[sEventParticipant_EmployeeNo] [char](10) NULL,
	[sEventParticipant_EISId] [char](7) NULL,
	[sEventParticipant_Email] [varchar](100) NULL,
	[DataPulledDate] [datetime] NULL,
	[sIs_Presenter] [char](1) NULL,
	[sPresenter_Name] [varchar](500) NULL,
	[EvalSurveyOpen] [char](10) NULL,
	[EvalSurveyComplete] [char](10) NULL,
	[PreSurvey1] [varchar](2000) NULL,
	[PreSurvey2] [varchar](2000) NULL,
	[PreSurvey3] [varchar](2000) NULL,
	[EvaluationLink] [varchar](1000) NULL
) ON [PRIMARY]

GO


--Sequence Container2
--DFT_ISS_TRNS_Events
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL command text:
--For Events
SELECT 
E.nEventID
,E.sEventName
,E.nEventStaffID
,PPD.sFirstName AS sPointPerson_FirstName
,PPD.sLastName AS sPointPerson_LastName
,PPD.[sEmployeeNo] AS sPointPerson_EmployeeNo
,PPD.[sEISID] AS sPointPerson_EISId
,CAST (PPD.EmailAlias AS VARCHAR(100)) AS sPointPerson_Email
,E.[nProgramId]
,TP.sProgramName
,TP.sProgramCode
,E.dtEventDate
,CAST (CASE WHEN MONTH(E.dtEventDate) < '07' THEN YEAR(E.dtEventDate)-1  ELSE YEAR(E.dtEventDate) END AS INT)  AS nSchool_Year
,E.tEventStartTime
,E.tEventEndTime
,E.[nEventStatusID]
,ST.sStatusMedDesc-- as EventStatus
,L.SiteName-- AS sEventLocation
,E.[sCity]
,E.[ZipCode]
,E.[TotalTeachers]
,E.[TotlaStudents]
,E.[TotalCost]
,E.[sLastUpdatedBy]
,E.[dtLastUpdatedDate]
,E.[nActivityID]
,AL.[sActivityName]
,E.[nTotalMetroCards]
,E.[nTotalBuses]
,E.[sSupportDocument]
,E.[nEventTypeID]
,ET.[EventType]
,E.[nContentID]
,EC.[ContentName]
,E.[CTLEeligible]
,E.[CTLEAgendaLink]
,E.[CTLECreditHrs]
--,E.[PedagogyContent]
,PC.[sActivityName] AS [PedagogyContent]
,E.[EvaluationLink]
,E.[nTotalCount]
,E.[IsWaitList]
,E.[nWaitListNo]
,E.[ShareSupportLink]
,E.[ShareFiles]
,E.[Related_Label_ID]
--INTO SWHUB_ISS_Events
FROM dbo.ISS_tblProgramEvents E
INNER JOIN dbo.ISS_tblPrograms TP ON E.nProgramId = TP.nProgramId
INNER JOIN ISS_tblAllSchoolsAndParks L ON E.sEventLocation=L.ID
LEFT OUTER JOIN ISS_tblStatusAll_Desc ST ON E.nEventStatusID=ST.nStatusID
LEFT JOIN [dbo].[ISS_tblActivityLkup] AL ON E.[nActivityID]=AL.[nActivityID]
LEFT JOIN [dbo].[lkup_EventContent] EC ON E.[nContentID]=EC.[ContentID]
LEFT JOIN [dbo].[lkup_EventType] ET ON E.[nEventTypeID]=ET.[EventTypeID]
LEFT JOIN [dbo].[ISS_tblAreasOfActivity_Lkup] PC ON E.[PedagogyContent]=PC.[nActivityID]
LEFT JOIN ( --This part to get Point persons' EmployeeNo, EISId, Email
SELECT DISTINCT k.nEventStaffID,l.[sEmployeeNo],l.[sEISID],l.EmailAlias,l.sEmail,l.sFirstName,l.sLastName FROM ISS_tblProgramEvents K
INNER JOIN (
SELECT a.*,b.EmailAlias,b.sEmail FROM (
(SELECT * FROM [dbo].[ISS_tblPersonalInfo] WHERE sSchoolDBN IS NOT NULL AND sEmployeeNo IS NOT NULL) a
INNER JOIN (SELECT *, REPLACE(SUBSTRING([sEmail],1,(CHARINDEX('@', [sEmail]))),'@','') AS EmailAlias FROM dbo.[ISS_tblADUsers] WHERE bIsActive='A')b ON a.sEmployeeNo=b.sEmployeeNo)
)L ON K.nEventStaffID=L.nEmpId
)PPD ON E.nEventStaffID =PPD.nEventStaffID

--Data Conversion:
Input Column		Output Alias				Data Type			Length
SiteName			sEventLocation_Convert		string[DT_STR]		255
EventType			sEventType_Convert			string[DT_STR]		50
Related_Label_ID	Related_Label_ID_Convert	string[DT_STR]		10

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_ISS_TRNS_Events]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[ISS_TRNS_Events]') IS NOT NULL
DROP TABLE [ISS_TRNS_Events]
CREATE TABLE [dbo].[ISS_TRNS_Events](
	[nEventID] [bigint] NOT NULL,
	[sEventName] [varchar](200) NULL,
	[nEventStaffID] [numeric](18, 0) NULL,
	[sPointPerson_FirstName] [varchar](50) NULL,
	[sPointPerson_LastName] [varchar](50) NULL,
	[sPointPerson_EmployeeNo] [char](10) NULL,
	[sPointPerson_EISId] [char](7) NULL,
	[sPointPerson_Email] [varchar](100) NULL,
	[nProgramId] [numeric](18, 0) NULL,
	[sProgramName] [varchar](50) NULL,
	[sProgramCode] [varchar](50) NULL,
	[dtEventDate] [datetime] NULL,
	[nSchool_Year] [int] NULL,
	[tEventStartTime] [datetime] NULL,
	[tEventEndTime] [datetime] NULL,
	[nEventStatusID] [int] NULL,
	[sEventStatus] [varchar](50) NULL,
	[sEventLocation] [varchar](255) NULL,
	[sCity] [varchar](50) NULL,
	[nZipCode] [int] NULL,
	[nTotalTeachers] [int] NULL,
	[nTotlaStudents] [int] NULL,
	[nTotalCost] [int] NULL,
	[sLastUpdatedBy] [varchar](100) NULL,
	[dtLastUpdatedDate] [datetime] NULL,
	[nActivityID] [int] NULL,
	[sActivityName] [varchar](100) NULL,
	[nTotalMetroCards] [int] NULL,
	[nTotalBuses] [int] NULL,
	[sSupportDocument] [varchar](500) NULL,
	[nEventTypeID] [int] NULL,
	[sEventType] [varchar](50) NULL,
	[nContentID] [int] NULL,
	[sContentName] [varchar](50) NULL,
	[sCTLEeligible] [varchar](50) NULL,
	[sCTLEAgendaLink] [varchar](500) NULL,
	[nCTLECreditHrs] [int] NULL,
	[sPedagogyContent] [varchar](100) NULL,
	[sEvaluationLink] [varchar](1000) NULL,
	[nTotalCount] [int] NULL,
	[sIsWaitList] [char](1) NULL,
	[nWaitListNo] [int] NULL,
	[sShareSupportLink] [char](1) NULL,
	[sShareFiles] [char](1) NULL,
	[sRelated_Label_ID] [char](10) NULL
) ON [PRIMARY]

GO

--DFT_SWHUB_ISS_EventParticipants
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL command text:
--For Event Participants
--For Event Participants
USE ISS_EXT
SELECT 
 W.nEventID
,W.sEventName
,W.[nEventTypeID]
,W.[EventType]
,W.[nContentID]
,W.[ContentName]
,W.[nProgramId]
,W.sProgramName
,W.[sProgramCode]
,W.nEventStaffID
,W.sPointPerson_FirstName
,W.sPointPerson_LastName
,W.sPointPerson_EmployeeNo
,W.sPointPerson_EISId
,W.sPointPerson_Email
,W.dtEventDate
,W.nSchool_Year
,W.tEventStartTime
,W.tEventEndTime
,W.nEventStatusID
,W.sEventStatus
,W.sEventLocation
,W.sParticipant
,W.sType
,W.sEventParticipantTypeDesc
,W.[Participant_Status]
,W.[Participant_Status_Desc]
,W.Is_Presenter
,W.sPresenter_Name

,W.[EvalSurveyOpen]
,W.[EvalSurveyComplete]
,W.[PreSurvey1]
,W.[PreSurvey2]
,W.[PreSurvey3]
,W.[EvaluationLink]
,EPD.sSchoolDBN AS sEventParticipant_SchoolDBN
,EPD.sFirstName AS sEventParticipant_FirstName
,EPD.sLastName AS sEventParticipant_LastName
,CAST(W.sEmployeeNo AS char(10)) AS sEventParticipant_EmployeeNo
,EPD.[sEISId] AS sEventParticipant_EISId
,EPD.sEmail AS sEventParticipant_Email
,GETDATE() AS [DataPulledDate]
FROM (
SELECT 
 E.nEventID
,E.sEventName
,E.[nEventTypeID]
,ET.[EventType]
,E.[nContentID]
,EC.[ContentName]
,E.[nProgramId]
,TP.sProgramName
,TP.[sProgramCode]
,E.nEventStaffID
,PPD.sFirstName AS sPointPerson_FirstName
,PPD.sLastName AS sPointPerson_LastName
,PPD.[sEmployeeNo] AS sPointPerson_EmployeeNo
,PPD.[sEISId] AS sPointPerson_EISId
,PPD.sEmail AS sPointPerson_Email
,E.dtEventDate
,CAST (CASE WHEN MONTH(E.dtEventDate) < '07' THEN YEAR(E.dtEventDate)-1  ELSE YEAR(E.dtEventDate) END AS INT)  AS nSchool_Year
,E.tEventStartTime
,E.tEventEndTime
,E.[nEventStatusID]
,STA.sStatusMedDesc as sEventStatus
,L.SiteName AS sEventLocation
,EP.sParticipant
,EP.sType,
case EP.[sType]
when 'D' then 'School'
when 'E' then 'Event Supporting Staff'
when 'U' then 'DOE Staff Member'
when 'S' then 'DOE Staff Member'
when 'N' then 'Network'
when 'O' then 'Others'
when 'K' then 'Speaker/Presenter'
when 'P' then 'Organization'
else ''
end AS sEventParticipantTypeDesc
,EP.[Participant_Status]
,STAD.[sStatusMedDesc] AS [Participant_Status_Desc]
,EP.sEmployeeNo
,EP.Is_Presenter
,EP.sPresenter_Name
,EP.[EvalSurveyOpen]
,EP.[EvalSurveyComplete]
,EP.[PreSurvey1]
,EP.[PreSurvey2]
,EP.[PreSurvey3]
,E.[EvaluationLink]
FROM dbo.ISS_tblProgramEvents E
INNER JOIN dbo.ISS_tblPrograms TP ON E.nProgramId = TP.nProgramId
INNER JOIN ISS_tblAllSchoolsAndParks L ON E.sEventLocation=L.ID
INNER JOIN dbo.ISS_tblEventParticipants EP ON E.nEventID=EP.nEventID 
INNER JOIN dbo.ISS_tblPersonalInfo P ON E.nEventStaffID=P.nEmpid
LEFT OUTER JOIN ISS_tblStatusAll_Desc STA ON E.nEventStatusID=STA.nStatusID -- to get Event status description
LEFT OUTER JOIN ISS_tblStatusAll_Desc STAD ON EP.[Participant_Status]=STAD.[nStatusID]  -- to get Event Participants status description
LEFT JOIN [dbo].[lkup_EventType] ET ON E.[nEventTypeID]=ET.[EventTypeID]
LEFT JOIN [dbo].[lkup_EventContent] EC ON E.[nContentID]=EC.[ContentID]

LEFT JOIN ( --This part to get Point persons' EmployeeNo, EISId, Email
SELECT DISTINCT k.nEventStaffID,l.[sEmployeeNo],l.[sEISID],l.EmailAlias,l.sEmail,l.sFirstName,l.sLastName FROM ISS_tblProgramEvents K
INNER JOIN (
SELECT a.*,b.EmailAlias,b.sEmail FROM 
(SELECT * FROM [dbo].[ISS_tblPersonalInfo] WHERE sSchoolDBN IS NOT NULL AND sEmployeeNo IS NOT NULL) a
LEFT JOIN (SELECT *, REPLACE(SUBSTRING([sEmail],1,(CHARINDEX('@', [sEmail]))),'@','') AS EmailAlias FROM dbo.[ISS_tblADUsers] WHERE bIsActive='A')b ON a.sEmployeeNo=b.sEmployeeNo
)L ON K.nEventStaffID=L.nEmpId
)PPD ON E.nEventStaffID =PPD.nEventStaffID 
) W 

LEFT JOIN ( --This part is to get Event Participants' EmployeeNo,EISId,Name,DBN
SELECT DISTINCT a.sEmployeeNo,a.sEISID,sSchoolDBN,a.sFirstName,a.sLastName,b.EmailAlias,b.sEmail FROM 
(SELECT * FROM [dbo].[ISS_tblPersonalInfo] WHERE sSchoolDBN IS NOT NULL AND sEmployeeNo IS NOT NULL) a
LEFT JOIN (SELECT *, REPLACE(SUBSTRING([sEmail],1,(CHARINDEX('@', [sEmail]))),'@','') AS EmailAlias FROM dbo.[ISS_tblADUsers] WHERE bIsActive='A')b
ON a.sEmployeeNo=b.sEmployeeNo
)EPD ON W.sEmployeeNo=EPD.[sEmployeeNo] WHERE W.sType IN ('U','S','E','K')

UNION 

SELECT 
 W.nEventID
,W.sEventName
,W.[nEventTypeID]
,W.[EventType]
,W.[nContentID]
,W.[ContentName]
,W.[nProgramId]
,W.sProgramName
,W.[sProgramCode]
,W.nEventStaffID
,W.sPointPerson_FirstName
,W.sPointPerson_LastName
,W.sPointPerson_EmployeeNo
,W.sPointPerson_EISId
,W.sPointPerson_Email
,W.dtEventDate
,W.nSchool_Year
,W.tEventStartTime
,W.tEventEndTime
,W.nEventStatusID
,W.sEventStatus
,W.sEventLocation
,W.sParticipant
,W.sType
,W.sEventParticipantTypeDesc
,W.[Participant_Status]
,W.[Participant_Status_Desc]
,W.Is_Presenter
,W.sPresenter_Name

,W.[EvalSurveyOpen]
,W.[EvalSurveyComplete]
,W.[PreSurvey1]
,W.[PreSurvey2]
,W.[PreSurvey3]
,W.[EvaluationLink]
,EPD.[sSchoolDBN] AS sEventParticipant_SchoolDBN
,NULL AS sEventParticipant_FirstName
,NULL AS sEventParticipant_LastName
,NULL AS sEventParticipant_EmployeeNo
,NULL AS sEventParticipant_EISId
,NULL AS sEventParticipant_Email
,GETDATE() AS [DataPulledDate]
FROM (
SELECT DISTINCT
 E.nEventID
,E.sEventName
,E.[nEventTypeID]
,ET.[EventType]
,E.[nContentID]
,EC.[ContentName]
,E.[nProgramId]
,TP.sProgramName
,TP.[sProgramCode]
,E.nEventStaffID
,PPD.sFirstName AS sPointPerson_FirstName
,PPD.sLastName AS sPointPerson_LastName
,PPD.[sEmployeeNo] AS sPointPerson_EmployeeNo
,PPD.[sEISId] AS sPointPerson_EISId
,PPD.sEmail AS sPointPerson_Email
,E.dtEventDate
,CAST (CASE WHEN MONTH(E.dtEventDate) < '07' THEN YEAR(E.dtEventDate)-1  ELSE YEAR(E.dtEventDate) END AS INT)  AS nSchool_Year
,E.tEventStartTime
,E.tEventEndTime
,E.[nEventStatusID]
,STA.sStatusMedDesc as sEventStatus
,L.SiteName AS sEventLocation
,EP.sParticipant
,EP.sType,
case EP.[sType]
when 'D' then 'School'
when 'E' then 'Event Supporting Staff'
when 'U' then 'DOE Staff Member'
when 'S' then 'DOE Staff Member'
when 'N' then 'Network'
when 'O' then 'Others'
when 'K' then 'Speaker/Presenter'
when 'P' then 'Organization'
else ''
end AS sEventParticipantTypeDesc
,EP.[Participant_Status]
,STAD.[sStatusMedDesc] AS [Participant_Status_Desc]
,EP.sEmployeeNo
,EP.Is_Presenter
,EP.sPresenter_Name
,EP.[EvalSurveyOpen]
,EP.[EvalSurveyComplete]
,EP.[PreSurvey1]
,EP.[PreSurvey2]
,EP.[PreSurvey3]
,E.[EvaluationLink]
FROM dbo.ISS_tblProgramEvents E
INNER JOIN dbo.ISS_tblPrograms TP ON E.nProgramId = TP.nProgramId
INNER JOIN ISS_tblAllSchoolsAndParks L ON E.sEventLocation=L.ID
INNER JOIN dbo.ISS_tblEventParticipants EP ON E.nEventID=EP.nEventID 
INNER JOIN dbo.ISS_tblPersonalInfo P ON E.nEventStaffID=P.nEmpid
LEFT OUTER JOIN ISS_tblStatusAll_Desc STA ON E.nEventStatusID=STA.nStatusID -- to get Event status description
LEFT OUTER JOIN ISS_tblStatusAll_Desc STAD ON EP.[Participant_Status]=STAD.[nStatusID]  -- to get Event Participants status description
LEFT JOIN [dbo].[lkup_EventType] ET ON E.[nEventTypeID]=ET.[EventTypeID]
LEFT JOIN [dbo].[lkup_EventContent] EC ON E.[nContentID]=EC.[ContentID]


LEFT JOIN ( --This part to get Point persons' EmployeeNo, EISId, Email
SELECT DISTINCT k.nEventStaffID,l.[sEmployeeNo],l.[sEISID],l.EmailAlias,l.sEmail,l.sFirstName,l.sLastName FROM ISS_tblProgramEvents K
INNER JOIN (
SELECT a.*,b.EmailAlias,b.sEmail FROM 
(SELECT * FROM [dbo].[ISS_tblPersonalInfo] WHERE sSchoolDBN IS NOT NULL AND sEmployeeNo IS NOT NULL) a
LEFT JOIN (SELECT *, REPLACE(SUBSTRING([sEmail],1,(CHARINDEX('@', [sEmail]))),'@','') AS EmailAlias FROM dbo.[ISS_tblADUsers] WHERE bIsActive='A')b ON a.sEmployeeNo=b.sEmployeeNo
)L ON K.nEventStaffID=L.nEmpId
)PPD ON E.nEventStaffID =PPD.nEventStaffID 
) W 

LEFT JOIN (--This part is to get Event Participants' DBN and details
SELECT DISTINCT 
Fiscal_Year,
System_ID,
CAST([System_Code] AS CHAR(6)) AS [sSchoolDBN], 
Administrative_District_Code,
Administrative_District_Name,
Location_Code,
Location_Name_Long, 
Location_Type_Code,
Location_Type_Description,
Location_Category_Code,
Location_Category_Description
FROM SUPERLINK.Supertable.dbo.Location_Supertable1
WHERE	System_ID = 'ats' 
		AND Status_Code='O'
		AND Fiscal_Year = CASE WHEN month(getdate()) >= '07' THEN year(getdate()) + 1 ELSE year(getdate()) END
		AND Administrative_District_Code IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') 
		AND Location_Type_Description<>'Home School' 
		AND Location_Category_Description<>'Borough' 
		AND Location_Category_Description<>'Central-HQ-Citywide' 
		AND substring(System_Code,4,3)<>'444' 
		AND substring(System_Code,4,3)<>'700'
		AND Location_Name <> 'Universal Pre-K C.B.O.'
		AND Location_Type_Description <>'Adult'
		AND Location_Type_Description <>'Alternative'
		AND Location_Type_Description <>'Evening'
		AND Location_Type_Description <>'Suspension Center'
		AND Location_Type_Description <>'YABC'
		AND Grades_Text <>''
		AND Location_Name NOT LIKE '%Hospital Schools%'
)EPD ON W.sParticipant=EPD.sSchoolDBN WHERE W.sType IN ('D','P','N','O')


--Data Conversion:
Input Column		Output Alias				Data Type			Length
sEventLocation		sEventLocation_Convert		string[DT_STR]		255
EventType			sEventType_Convert			string[DT_STR]		50

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_ISS_TRNS_Events]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[SWHUB_ISS_EventParticipants]') IS NOT NULL
DROP TABLE [SWHUB_ISS_EventParticipants]
CREATE TABLE [dbo].[SWHUB_ISS_EventParticipants](
	[nEventId] [bigint] NULL,
	[sEventName] [varchar](200) NULL,
	[nEventTypeID] [int] NULL,
	[sEventType] [varchar](50) NULL,
	[nContentID] [int] NULL,
	[sContentName] [varchar](50) NULL,
	[nProgramId] [numeric](18, 0) NULL,
	[sProgramName] [varchar](100) NULL,
	[sProgramCode] [varchar](50) NULL,
	[nEventStaffID] [numeric](18, 0) NULL,
	[sPointPerson_FirstName] [varchar](50) NULL,
	[sPointPerson_LastName] [varchar](50) NULL,
	[sPointPerson_EmployeeNo] [char](10) NULL,
	[sPointPerson_EISId] [char](7) NULL,
	[sPointPerson_Email] [varchar](100) NULL,
	[dtEventDate] [datetime] NULL,
	[nSchool_Year] [int] NULL,
	[tEventStartTime] [datetime] NULL,
	[tEventEndTime] [datetime] NULL,
	[nEventStatusID] [int] NULL,
	[sEventStatus] [varchar](50) NULL,
	[sEventLocation] [varchar](300) NULL,
	[sParticipant] [varchar](200) NULL,
	[sEventParticipantType] [char](1) NULL,
	[sEventParticipantTypeDesc] [varchar](25) NULL,
	[nParticipant_Status] [int] NULL,
	[sParticipant_Status_Desc] [varchar](50) NULL,
	[sEventParticipant_SchoolDBN] [char](6) NULL,
	[sEventParticipant_FirstName] [varchar](50) NULL,
	[sEventParticipant_LastName] [varchar](50) NULL,
	[sEventParticipant_EmployeeNo] [char](10) NULL,
	[sEventParticipant_EISId] [char](7) NULL,
	[sEventParticipant_Email] [varchar](100) NULL,
	[DataPulledDate] [datetime] NULL,
	[sIs_Presenter] [char](1) NULL,
	[sPresenter_Name] [varchar](500) NULL,
	[EvalSurveyOpen] [char](10) NULL,
	[EvalSurveyComplete] [char](10) NULL,
	[PreSurvey1] [varchar](2000) NULL,
	[PreSurvey2] [varchar](2000) NULL,
	[PreSurvey3] [varchar](2000) NULL,
	[EvaluationLink] [varchar](1000) NULL
) ON [PRIMARY]


--SWHUB_ISS_Events
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
--FOR SWHUB_ISS_Events
USE FGR_INT
SELECT a.*
,b.[School],c.[School] AS [School_Registered],d.[School] AS [School_Attended]
,b.[DOE Staff Member] AS [DOE Staff],c.[DOE Staff Member] AS [DOE_Staff_Registered],d.[DOE Staff Member] AS [DOE_Staff_Attended]
,b.[Event Supporting Staff] AS [Event_Supporting_Staff],c.[Event Supporting Staff] AS [Event_Supporting_Staff_Registered],d.[Event Supporting Staff] AS [Event_Supporting_Staff_Attended]
,b.[Speaker/Presenter] AS [Speaker_Presenter]--,c.[Speaker/Presenter] AS [Speaker_Presenter_Registered],d.[Speaker/Presenter] AS [Speaker_Presenter_Attended]
,b.[Organization],c.[Organization] AS [Organization_Registered],d.[Organization] AS [Organization_Attended]
,b.[Others],c.[Others] AS [Others_Registered],d.[Others] AS [Others_Attended]
,GETDATE() AS [DataPulledDate]  FROM [ISS_TRNS_Events] a

LEFT JOIN (
SELECT * FROM (
SELECT 
nEventID
,[nEventStaffID]
,[nProgramId]
,[sProgramCode]
,[dtEventDate]
,[tEventStartTime]
,[tEventEndTime]
,[nEventStatusID]
,[sEventLocation]
,[sEventParticipantTypeDesc]
,COUNT([nEventStaffID]) AS [No of Participants]
FROM(
SELECT 
nEventID
,[nEventStaffID]
,[nProgramId]
,[sProgramCode]
,[dtEventDate]
,[tEventStartTime]
,[tEventEndTime]
,[nEventStatusID]
,[sEventLocation]
,[sEventParticipantTypeDesc]
FROM [SWHUB_ISS_EventParticipants])ep
GROUP BY 
nEventID
,[nEventStaffID]
,[nProgramId]
,[sProgramCode]
,[dtEventDate]
,[tEventStartTime]
,[tEventEndTime]
,[nEventStatusID]
,[sEventLocation]
,[sEventParticipantTypeDesc]
)pv
PIVOT
(SUM([No of Participants])
FOR [sEventParticipantTypeDesc] IN (
[School],[DOE Staff Member],[Event Supporting Staff],[Speaker/Presenter],[Organization],[Others]) 
) AS PivotedTable
)b ON a.nEventID=b.nEventID

LEFT JOIN (
SELECT * FROM (
SELECT 
nEventID
,[nEventStaffID]
,[nProgramId]
,[sProgramCode]
,[dtEventDate]
,[tEventStartTime]
,[tEventEndTime]
,[nEventStatusID]
,[sEventLocation]
,[sEventParticipantTypeDesc]
,COUNT([nEventStaffID]) AS [No of Participants]
FROM(
SELECT 
nEventID
,[nEventStaffID]
,[nProgramId]
,[sProgramCode]
,[dtEventDate]
,[tEventStartTime]
,[tEventEndTime]
,[nEventStatusID]
,[sEventLocation]
,[sEventParticipantTypeDesc]
FROM [SWHUB_ISS_EventParticipants] WHERE [sParticipant_Status_Desc]='Registered')ep
GROUP BY 
nEventID
,[nEventStaffID]
,[nProgramId]
,[sProgramCode]
,[dtEventDate]
,[tEventStartTime]
,[tEventEndTime]
,[nEventStatusID]
,[sEventLocation]
,[sEventParticipantTypeDesc]
)pv
PIVOT
(SUM([No of Participants])
FOR [sEventParticipantTypeDesc] IN (
[School],[DOE Staff Member],[Event Supporting Staff],[Speaker/Presenter],[Organization],[Others]) 
) AS PivotedTable
)c ON a.nEventID=c.nEventID

LEFT JOIN (
SELECT * FROM (
SELECT 
nEventID
,[nEventStaffID]
,[nProgramId]
,[sProgramCode]
,[dtEventDate]
,[tEventStartTime]
,[tEventEndTime]
,[nEventStatusID]
,[sEventLocation]
,[sEventParticipantTypeDesc]
,COUNT([nEventStaffID]) AS [No of Participants]
FROM(
SELECT 
nEventID
,[nEventStaffID]
,[nProgramId]
,[sProgramCode]
,[dtEventDate]
,[tEventStartTime]
,[tEventEndTime]
,[nEventStatusID]
,[sEventLocation]
,[sEventParticipantTypeDesc]
FROM [SWHUB_ISS_EventParticipants] WHERE [sParticipant_Status_Desc]='Attended')ep
GROUP BY 
nEventID
,[nEventStaffID]
,[nProgramId]
,[sProgramCode]
,[dtEventDate]
,[tEventStartTime]
,[tEventEndTime]
,[nEventStatusID]
,[sEventLocation]
,[sEventParticipantTypeDesc]
)pv
PIVOT
(SUM([No of Participants])
FOR [sEventParticipantTypeDesc] IN (
[School],[DOE Staff Member],[Event Supporting Staff],[Organization],[Others]) --[Speaker/Presenter],
) AS PivotedTable
)d ON a.nEventID=d.nEventID
ORDER BY a.nEventID
,a.[nEventStaffID]
,a.[nProgramId]
,a.[sProgramCode]
,a.[dtEventDate]
,a.[tEventStartTime]
,a.[tEventEndTime]
,a.[nEventStatusID]
,a.[sEventLocation]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_ISS_Events]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[SWHUB_ISS_Events]') IS NOT NULL
DROP TABLE [SWHUB_ISS_Events]
CREATE TABLE [dbo].[SWHUB_ISS_Events](
	[nEventID] [bigint] NOT NULL,
	[sEventName] [varchar](200) NULL,
	[nEventStaffID] [numeric](18, 0) NULL,
	[sPointPerson_FirstName] [varchar](50) NULL,
	[sPointPerson_LastName] [varchar](50) NULL,
	[sPointPerson_EmployeeNo] [char](10) NULL,
	[sPointPerson_EISId] [char](7) NULL,
	[sPointPerson_Email] [varchar](100) NULL,
	[nProgramId] [numeric](18, 0) NULL,
	[sProgramName] [varchar](50) NULL,
	[sProgramCode] [varchar](50) NULL,
	[dtEventDate] [datetime] NULL,
	[nSchool_Year] [int] NULL,
	[tEventStartTime] [datetime] NULL,
	[tEventEndTime] [datetime] NULL,
	[nEventStatusID] [int] NULL,
	[sEventStatus] [varchar](50) NULL,
	[sEventLocation] [varchar](255) NULL,
	[sCity] [varchar](50) NULL,
	[nZipCode] [int] NULL,
	[nTotalTeachers] [int] NULL,
	[nTotlaStudents] [int] NULL,
	[nTotalCost] [int] NULL,
	[sLastUpdatedBy] [varchar](100) NULL,
	[dtLastUpdatedDate] [datetime] NULL,
	[nActivityID] [int] NULL,
	[sActivityName] [varchar](100) NULL,
	[nTotalMetroCards] [int] NULL,
	[nTotalBuses] [int] NULL,
	[sSupportDocument] [varchar](500) NULL,
	[nEventTypeID] [int] NULL,
	[sEventType] [varchar](50) NULL,
	[nContentID] [int] NULL,
	[sContentName] [varchar](50) NULL,
	[sCTLEeligible] [varchar](50) NULL,
	[sCTLEAgendaLink] [varchar](500) NULL,
	[nCTLECreditHrs] [int] NULL,
	[sPedagogyContent] [varchar](100) NULL,
	[sEvaluationLink] [varchar](1000) NULL,
	[nTotalCount] [int] NULL,
	[sIsWaitList] [char](1) NULL,
	[nWaitListNo] [int] NULL,
	[sShareSupportLink] [char](1) NULL,
	[sShareFiles] [char](1) NULL,
	[sRelated_Label_ID] [char](10) NULL,
	[#Schools] [int] NULL,
	[#DOE_Staff] [int] NULL,
	[#Event_Supporting_Staff] [int] NULL,
	[#Speaker_Presenter] [int] NULL,
	[#Organizations] [int] NULL,
	[#Others] [int] NULL,
	[DataPulledDate] [datetime] NULL,
	[#Schools_Registered] [int] NULL,
	[#Schools_Attended] [int] NULL,
	[#DOE_Staff_Registered] [int] NULL,
	[#DOE_Staff_Attended] [int] NULL,
	[#Event_Supporting_Staff_Registered] [int] NULL,
	[#Event_Supporting_Staff_Attended] [int] NULL,
	[#Organizations_Registered] [int] NULL,
	[#Organizations_Attended] [int] NULL,
	[#Others_Registered] [int] NULL,
	[#Others_Attended] [int] NULL
) ON [PRIMARY]

GO


--Sequence Container3
--DFT_SWHUB_ISS_InteractionParticipants
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL command text:
SELECT  DISTINCT 
I.nProgStaffInteractID,
ISNULL(I.sInteractionName,I.nProgStaffInteractID) as sInteractionName,
dtInteractionDate,
--Convert(varchar,dtInteractionDate,101) as InteractionDate,
I.[sLastUpdatedBy],
I.[dtLastUpdatedDate],
I.nLiasonID,
EL.sFirstName AS sLiason_FirstName,
EL.sLastName AS sLiason_LastName,
EL.sEmployeeNo AS sLiason_EmployeeNo,
EL.sEISId AS sLiason_EISId,
I.sComments, 
I.tStartTime AS tInterection_StartTime,
I.tEndTime AS tInterection_EndTime,
I.sLocation AS sInterection_Location,
I.sFiscalYear,
ISNULL(I.nInteractionStatusID,0) as nInteractionStatusID,  
S.sStatusMedDesc AS sInteractionStatus,
rtrim(P.sProgramName) sProgFullName,  
O.sOfficeName,
ocl.sOpCategoryName,
D.sInteractionTypeDescs AS[sInteractionTypeDesc],
IP.[sType] AS sInterectionParticipantType,
CASE IP.[sType]
WHEN 'D' THEN 'School'
WHEN 'U' THEN 'School Staff'
WHEN 'S' THEN 'Staff Member'
WHEN 'P' THEN 'Organizations'
WHEN 'O' THEN 'Others'
ELSE
''
END AS sInterectionParticipantTypeDesc,
IP.sParticipant,
PeI.[sEmployeeNo] AS sParticipant_EmployeeNo,
PeI.[sFirstName] AS sParticipant_FirstName,
PeI.[sLastName]AS sParticipant_LastName,
istl.[nSupportTypeID],
istl.sSupportTypeName AS [sSupport_Provided_To],
I.[nContentAreaId],LEC.[ContentName] AS [sContentName],
GETDATE() AS [DataPulledDate]
FROM dbo.ISS_tblProgramStaffInteractions I  
LEFT JOIN (SELECT DISTINCT[nProgStaffInteractID],CAST((LOWER(CASE WHEN sParticipant like '%@schools.nyc.gov%'  THEN REPLACE(SUBSTRING(sParticipant,1,(CHARINDEX('@', sParticipant))),'@','') ELSE sParticipant END)) AS VARCHAR(200)) AS [sParticipant],
[sLastUpdatedBy],[dtLastUpdatedDate],[sType] FROM ISS_tblInteractionParticipants) IP ON I.nProgStaffInteractID=IP.nProgStaffInteractID
LEFT JOIN dbo.ISS_tblProgramStaffInteractionTypesWithDescs D ON D.nProgStaffInteractID=I.nProgStaffInteractID
LEFT JOIN dbo.ISS_tblPrograms P ON I.nProgramID=P.nProgramID
LEFT JOIN dbo.ISS_tblProgramOffices PO ON P.nProgramID=PO.nProgramID  
LEFT JOIN dbo.ISS_tblOffices_Lkup O ON PO.nOfficeID=O.nOfficeID AND O.Is_Active='Y'  

LEFT JOIN dbo.ISS_tblPersonalInfo EL ON I.nLiasonID =EL.nEmpID
LEFT JOIN dbo.ISS_tblPersonalInfo PeI ON IP.sParticipant=CONVERT(varchar(18),PeI.nEmpId)

LEFT  JOIN dbo.ISS_tblStatusAll_Desc S ON I.nInteractionStatusID=S.nStatusID  
LEFT JOIN dbo.ISS_tblInteractionSupportType_Lkup istl ON I.nSupportTypeID=istl.nSupportTypeID  
LEFT JOIN dbo.ISS_tblOperationalCategory_Lkup ocl ON I.nOpCategoryID=ocl.nOpCategoryID and ocl.Is_Active='Y'
LEFT JOIN [dbo].[lkup_EventContent] LEC ON I.[nContentAreaId]=LEC.[ContentID]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [[SWHUB_ISS_InterectionParticipants]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[SWHUB_ISS_InterectionParticipants]') IS NOT NULL
DROP TABLE [SWHUB_ISS_InterectionParticipants]
CREATE TABLE [dbo].[SWHUB_ISS_InteractionParticipants](
	[nProgStaffInteractID] [numeric](18, 0) NULL,
	[sInteractionName] [varchar](100) NULL,
	[dtInteractionDate] [datetime] NULL,
	[sLastUpdatedBy] [varchar](100) NULL,
	[dtLastUpdatedDate] [datetime] NULL,
	[nLiasonID] [bigint] NULL,
	[sLiason_FirstName] [varchar](75) NULL,
	[sLiason_LastName] [varchar](75) NULL,
	[sLiason_EmployeeNo] [char](10) NULL,
	[sLiason_EISId] [char](7) NULL,
	[sComments] [varchar](4500) NULL,
	[tInterection_StartTime] [datetime] NULL,
	[tInterection_EndTime] [datetime] NULL,
	[sInterection_Location] [varchar](100) NULL,
	[sFiscalYear] [char](4) NULL,
	[nInteractionStatusID] [int] NULL,
	[sInteractionStatus] [varchar](50) NULL,
	[sProgFullName] [varchar](100) NULL,
	[sOfficeName] [varchar](100) NULL,
	[sOpCategoryName] [varchar](100) NULL,
	[sInteractionTypeDesc] [varchar](4000) NULL,
	[sInterectionParticipantType] [char](1) NULL,
	[sInterectionParticipantTypeDesc] [varchar](200) NULL,
	[sParticipant] [varchar](200) NULL,
	[sParticipant_EmployeeNo] [char](10) NULL,
	[sParticipant_FirstName] [varchar](50) NULL,
	[sParticipant_LastName] [varchar](50) NULL,
	[nSupportTypeID] [int] NULL,
	[sSupport_Provided_To] [varchar](100) NULL,
	[nContentAreaId] [int] NULL,
	[sContentName] [varchar](50) NULL,
	[DataPulledDate] [datetime] NULL
) ON [PRIMARY]

GO

--DFT_SWHUB_ISS_Interacted_Schools
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
--Part2: SchoolDBNs
With Cte(nProgStaffInteractID,sInterectionParticipantTypeDesc,cConcat) as 
(SELECT nProgStaffInteractID,sInterectionParticipantTypeDesc,
(SELECT a.[SchoolDBN]+',' FROM 
(SELECT DISTINCT nProgStaffInteractID, sInterectionParticipantTypeDesc,RTRIM(LTRIM(sParticipant)) AS [SchoolDBN]
FROM SWHUB_ISS_InteractionParticipants WHERE sInterectionParticipantTypeDesc='School' AND sParticipant IS NOT NULL
)
AS a    
WHERE a.nProgStaffInteractID=b.nProgStaffInteractID     for XML PATH ('') ) cconcat FROM 
(SELECT DISTINCT nProgStaffInteractID,sInterectionParticipantTypeDesc,RTRIM(LTRIM(sParticipant)) AS [SchoolDBN]
FROM SWHUB_ISS_InteractionParticipants WHERE sInterectionParticipantTypeDesc='School' AND sParticipant IS NOT NULL
)AS b  
GROUP BY nProgStaffInteractID,sInterectionParticipantTypeDesc) 

SELECT CONVERT(INT,nProgStaffInteractID) AS nProgStaffInteractID,sInterectionParticipantTypeDesc,CONVERT(VARCHAR(100),left(cConcat, len(cConcat) -1))AS [sSchool_DBNs] 
--INTO ##SWHUB_ISS_Interacted_Schools 
FROM cte 
ORDER BY nProgStaffInteractID

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_ISS_InterectedSchools]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[SWHUB_ISS_Interacted_Schools]') IS NOT NULL
DROP TABLE [SWHUB_ISS_Interacted_Schools]
CREATE TABLE [dbo].[SWHUB_ISS_Interacted_Schools](
	[nProgStaffInteractID] [int] NULL,
	[sInterectionParticipantTypeDesc] [varchar](200) NULL,
	[sSchool_DBNs] [varchar](100) NULL
) ON [PRIMARY]
GO

--[SWHUB_ISS_Interacted_Schools]
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
--Part3: Staff Names
With Cte(nProgStaffInteractID,sInterectionParticipantTypeDesc,cConcat) as 
(SELECT nProgStaffInteractID,sInterectionParticipantTypeDesc,
(SELECT a.sParticipant_Name+',' FROM 
(SELECT DISTINCT nProgStaffInteractID, sInterectionParticipantTypeDesc,
UPPER(LEFT([sParticipant_FirstName], 1))+LOWER(RIGHT([sParticipant_FirstName], LEN([sParticipant_FirstName])- 1))+' '+
UPPER(LEFT([sParticipant_LastName], 1)) +LOWER(RIGHT([sParticipant_LastName], LEN([sParticipant_LastName]) - 1)) AS sParticipant_Name
FROM SWHUB_ISS_InteractionParticipants WHERE sInterectionParticipantTypeDesc='School Staff' AND ([sParticipant_FirstName]+' '+[sParticipant_LastName]) IS NOT NULL
)
AS a    
WHERE a.nProgStaffInteractID=b.nProgStaffInteractID     for XML PATH ('') ) cconcat FROM 
(SELECT DISTINCT nProgStaffInteractID,sInterectionParticipantTypeDesc,
UPPER(LEFT([sParticipant_FirstName], 1))+LOWER(RIGHT([sParticipant_FirstName], LEN([sParticipant_FirstName])- 1))+' '+
UPPER(LEFT([sParticipant_LastName], 1)) +LOWER(RIGHT([sParticipant_LastName], LEN([sParticipant_LastName]) - 1)) AS sParticipant_Name
FROM SWHUB_ISS_InteractionParticipants WHERE sInterectionParticipantTypeDesc='School Staff' AND ([sParticipant_FirstName]+' '+[sParticipant_LastName]) IS NOT NULL
)AS b  
GROUP BY nProgStaffInteractID,sInterectionParticipantTypeDesc) 

SELECT CONVERT(INT,nProgStaffInteractID) AS nProgStaffInteractID,sInterectionParticipantTypeDesc,CONVERT(VARCHAR(100),LEFT(cConcat, LEN(cConcat)-1)) AS [sSchool_Staff_Names] 
--INTO ##SWHUB_ISS_Interacted_Staffs  
FROM cte 
ORDER BY nProgStaffInteractID

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_ISS_InterectedSchools]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[SWHUB_ISS_Interacted_Staffs]') IS NOT NULL
DROP TABLE [SWHUB_ISS_Interacted_Staffs]
CREATE TABLE [dbo].[SWHUB_ISS_Interacted_Staffs](
	[nProgStaffInteractID] [int] NULL,
	[sInterectionParticipantTypeDesc] [varchar](200) NULL,
	[sSchool_Staff_NameS] [varchar](200) NULL
) ON [PRIMARY]
GO

--DFT_SWHUB_ISS_Interactions
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT CONVERT(INT,c.nProgStaffInteractID) AS nProgStaffInteractID,
c.sInteractionName,
--replace(replace(c.sInteractionName, char(10), ''), char(13), '') AS sInteractionName,
c.nLiasonID,
CONVERT(VARCHAR(150),c.sLiason_Name) AS sLiason_Name,
c.sProgFullName,
c.dtInteractionDate,
c.tInterection_StartTime,
c.tInterection_EndTime,
c.[sLastUpdatedBy],
c.[dtLastUpdatedDate],
c.[sInteractionTypeDesc],
c.[sSupport_Provided_To],
c.sInteractionStatus,
c.[sCategory],
--replace(replace(c.[sCategory], char(10), ''), char(13), '') AS [sCategory],
--replace(replace(c.sComments, char(10), ''), char(13), '') AS sComments,
c.sComments,
c.[sContentName],
--replace(replace(c.[sContentName], char(10), ''), char(13), '') AS [sContentName],
c.[# School],
UPPER(d.[sSchool_DBNs]) AS [sSchool_DBNs],
c.[# School Staff],
e.[sSchool_Staff_Names],
c.[# Staff Member],
c.[# Organizations],
c.[# Others]  
,GETDATE() AS [DataPulledDate]
FROM (
SELECT 
nProgStaffInteractID,
sInteractionName,
nLiasonID,
sLiason_Name,
sProgFullName,
dtInteractionDate,
tInterection_StartTime,
tInterection_EndTime,
[sLastUpdatedBy],
[dtLastUpdatedDate],
sComments,
[sContentName],
[sInteractionTypeDesc],
[sSupport_Provided_To],
sOpCategoryName AS [sCategory],
sInteractionStatus,
[School] AS [# School],
[School Staff] AS [# School Staff],
[Staff Member] AS [# Staff Member],
[Organizations] AS [# Organizations],
[Others] AS [# Others] 
FROM (
SELECT nProgStaffInteractID,sInteractionName,nLiasonID,
UPPER(LEFT([sLiason_FirstName], 1))+LOWER(RIGHT([sLiason_FirstName], LEN([sLiason_FirstName])- 1))+' '+
UPPER(LEFT([sLiason_LastName], 1)) +LOWER(RIGHT([sLiason_LastName], LEN([sLiason_LastName]) - 1)) AS sLiason_Name,sProgFullName,dtInteractionDate,
tInterection_StartTime,tInterection_EndTime,[sLastUpdatedBy],[dtLastUpdatedDate],sComments,[sContentName],
[sInteractionTypeDesc],[sSupport_Provided_To],sOpCategoryName,sInterectionParticipantTypeDesc,sInteractionStatus,COUNT(nProgStaffInteractID) AS [# of Interections] 
FROM SWHUB_ISS_InteractionParticipants
GROUP BY nProgStaffInteractID,sInteractionName,nLiasonID,sLiason_FirstName,sLiason_LastName,sProgFullName,dtInteractionDate,tInterection_StartTime,tInterection_EndTime,
[sLastUpdatedBy],[dtLastUpdatedDate],sComments,[sContentName],
[sInteractionTypeDesc],[sSupport_Provided_To],sOpCategoryName,sInterectionParticipantTypeDesc,sInteractionStatus
)pv
PIVOT
(SUM([# of Interections])
FOR sInterectionParticipantTypeDesc IN (
[School],[School Staff],[Staff Member],[Organizations],[Others]) 
) AS PivotedTable
)c
LEFT JOIN (SELECT DISTINCT nProgStaffInteractID,sSchool_DBNS FROM SWHUB_ISS_Interacted_Schools) d ON c.nProgStaffInteractID=d.nProgStaffInteractID 

LEFT JOIN (SELECT DISTINCT nProgStaffInteractID,[sSchool_Staff_Names] FROM SWHUB_ISS_Interacted_Staffs) e ON c.nProgStaffInteractID=e.nProgStaffInteractID 
ORDER BY c.nProgStaffInteractID

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_ISS_InterectedSchools]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[SWHUB_ISS_Interactions]') IS NOT NULL
DROP TABLE [SWHUB_ISS_Interactions]
CREATE TABLE [dbo].[SWHUB_ISS_Interactions](
	[nProgStaffInteractID] [int] NULL,
	[sInteractionName] [varchar](100) NULL,
	[nLiasonID] [bigint] NULL,
	[sLiason_Name] [varchar](150) NULL,
	[sProgFullName] [varchar](100) NULL,
	[dtInteractionDate] [datetime] NULL,
	[tInterection_StartTime] [datetime] NULL,
	[tInterection_EndTime] [datetime] NULL,
	[sLastUpdatedBy] [varchar](100) NULL,
	[dtLastUpdatedDate] [datetime] NULL,
	[sInteractionTypeDesc] [varchar](4000) NULL,
	[sSupport_Provided_To] [varchar](100) NULL,
	[sInteractionStatus] [varchar](50) NULL,
	[sCategory] [varchar](100) NULL,
	[sComments] [varchar](4500) NULL,
	[sContentName] [varchar](50) NULL,
	[# School] [int] NULL,
	[sSchool_DBNs] [varchar](100) NULL,
	[# School Staff] [int] NULL,
	[sSchool_Staff_NameS] [varchar](200) NULL,
	[# Staff Member] [int] NULL,
	[# Organizations] [int] NULL,
	[# Others] [int] NULL,
	[DataPulledDate] [datetime] NULL
) ON [PRIMARY]
GO


--Variables for this Package:

Name			Scope													Data type			Value
PackageID		Package 02_Get HR data from ISS_EXT into SWHUB			Int32				2


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
 (3,'Package 02_Get HR data from ISS_EXT into SWHUB')







