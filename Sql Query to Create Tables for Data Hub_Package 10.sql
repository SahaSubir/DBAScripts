--EST_Delete data from destination table
Connection: ES11VDEXTESQL01 FGR_INT FGRepUser
SQL Statement:
TRUNCATE TABLE [ISS_TRNS_TblStaffData]
GO

TRUNCATE TABLE [SWHUB_TblStaffData]
GO

--DFT_ISS_TRNS_TblStaffData
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL Command text: 
SELECT Y.*,STUFF(dbo.DistinctList(CertificationCode,','),1,1,'') AS CertificationCode_N,STUFF(dbo.DistinctList(CertificationDesc,','),1,1,'') AS CertificationDesc_N,STUFF(dbo.DistinctList(SecondaryLicenseCode,','),1,1,'') AS SecondaryLicenseCode_N,STUFF(dbo.DistinctList(SecondaryLicenseDesc,','),1,1,'') AS SecondaryLicenseDesc_N 
,Z.sProgramName AS [Cohort_Name],
CASE WHEN ape.[sEmployeeNo] IS NOT NULL THEN 'Y' ELSE 'N' END AS APE_Teacher_Flag,
GETDATE() AS [DataPulledDate]
FROM
(SELECT TPI.[sEmployeeNo],TPI.[sEISId],TPI.[sLastName],TPI.[sFirstName],TPI.[sSchoolDBN],TPI.[sEmpStatus],TPI.[sTitleCode_Gxy],TPI.[sTitleDesc_Gxy],TPI.[sTitleCode_EIS],TPI.[Is_Primary_Location],TPI.[Central_Inst_Flag],TPI.[dtLastUpdatedDate],
TPI.[sLastUpdatedBy],TPI.[sChangeOfSource],TPI.[sLicenceCode],TPI.[sLicenceDesc],TPI.[sOtherDBNs],TPI.[Gender],TPI.[Seniority_YY],TPI.[Seniority_MM],TPI.[DOE_Start_Date],TPI.[Assignment_Code],TPI.[Assignment_Desc]
,TTP.sTitle,TTP.sOtherDBNs AS ProfileDBNS,TTP.sCellPhone,TTP.sPersonalPhone,TTP.sNotes,TTP.CoachNotes,TTP.CYSExpDate,
TTP.CPRExpDate,TTP.AdminNotes,TTP.Phone,TTP.sOtherEmail,TTP.Is_TextMessage,STS.LabelCount,STS.LabelID,STS.StaffLabels,
(LTRIM(RTRIM(TEL.License1)) + ',' + LTRIM(RTRIM(TEL.License2)) + ',' + LTRIM(RTRIM(TEL.License3)) + ',' + LTRIM(RTRIM(TEL.License4)) + ',' + LTRIM(RTRIM(TEL.License5)) + ',' + LTRIM(RTRIM(TEL.License6)) + ',' + LTRIM(RTRIM(TEL.License7)) + ',' + LTRIM(RTRIM(TEL.License8))) AS SecondaryLicenseCode,
(LTRIM(RTRIM(TEL.License_Desc1)) + ',' + LTRIM(RTRIM(TEL.License_Desc2)) + ',' + LTRIM(RTRIM(TEL.License_Desc3)) + ',' + LTRIM(RTRIM(TEL.License_Desc4)) + ',' + LTRIM(RTRIM(TEL.License_Desc5)) + ',' + LTRIM(RTRIM(TEL.License_Desc6)) + ',' + LTRIM(RTRIM(TEL.License_Desc7)) + ',' + LTRIM(RTRIM(TEL.License_Desc8))) AS SecondaryLicenseDesc,

(LTRIM(RTRIM(TEC.CERT_ID1)) + ',' + LTRIM(RTRIM(TEC.CERT_ID2)) + ',' + LTRIM(RTRIM(TEC.CERT_ID3)) + ',' + LTRIM(RTRIM(TEC.CERT_ID4)) + ',' + LTRIM(RTRIM(TEC.CERT_ID5)) + ',' + LTRIM(RTRIM(TEC.CERT_ID6)) + ',' + LTRIM(RTRIM(TEC.CERT_ID7)) + ',' + LTRIM(RTRIM(TEC.CERT_ID8))) CertificationCode,
(LTRIM(RTRIM(TEC.CERT_ID_DESC1)) + ',' + LTRIM(RTRIM(TEC.CERT_ID_DESC2)) + ',' + LTRIM(RTRIM(TEC.CERT_ID_DESC3)) + ',' + LTRIM(RTRIM(TEC.CERT_ID_DESC4)) + ',' + LTRIM(RTRIM(TEC.CERT_ID_DESC5)) + ',' + LTRIM(RTRIM(TEC.CERT_ID_DESC6))+ ',' + LTRIM(RTRIM(TEC.CERT_ID_DESC7)) + ',' + LTRIM(RTRIM(TEC.CERT_ID_DESC8))) CertificationDesc
,AD.[sEmail]
,TPI.[SSN],TPI.[DOB]
,TPI.[sReason_Code],TPI.[sReason_Desc],TPI.[sPMS_Status]
FROM ISS_tblPersonalInfo (NOLOCK)TPI
LEFT JOIN (SELECT * FROM [dbo].[ISS_tblADUsers] (NOLOCK) WHERE (bIsActive='A' OR bIsActive IS NULL)) AD -- Change Made - Krishna
ON TPI.sEmployeeNo=AD.[sEmployeeNo] 
LEFT JOIN ISS_tblTeacherProfile (NOLOCK)TTP ON TPI.[sEISID] = TTP.[sEISID]
LEFT JOIN
(SELECT  sEmployeeNo
              ,COUNT(ncomponentid) AS LabelCount 
       ,STUFF((SELECT ', ' + CAST(TPL.ncomponentid AS VARCHAR(10)) [text()]
         FROM ISS_tblTeacherProfileLabels (NOLOCK)TPL
         WHERE TPL.sEmployeeNo = t.sEmployeeNo
         FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,2,' ') AS LabelID, 
              STUFF((SELECT ', ' + CAST(TLL.sComponentName AS VARCHAR(50)) [text()]
         FROM ISS_tblTeacherProfileLabels (NOLOCK)TPL INNER JOIN ISS_tblTeacherLabelsLookUp (NOLOCK) TLL ON TPL.ncomponentid = TLL.nComponentID
         WHERE TPL.sEmployeeNo = t.sEmployeeNo
         FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,2,' ') AS StaffLabels
FROM ISS_tblTeacherProfileLabels (NOLOCK)t
GROUP BY sEmployeeNo) STS ON TPI.sEmployeeNo = STS.sEmployeeNo

LEFT JOIN ISS_Emp_Certs (NOLOCK)TEC ON TPI.sEmployeeNo = TEC.PMS
LEFT JOIN ISS_Emp_Licenses (NOLOCK) TEL ON TPI.sEmployeeNo = TEL.PMS
)Y

LEFT JOIN (
SELECT  a.[nProgramId],a.[sParticipantSchDBN],b.sProgramName FROM [ISS_EXT].[dbo].[ISS_tblProgramParticipants] (NOLOCK)a
LEFT JOIN [ISS_tblPrograms](NOLOCK) b ON a.nProgramId=b.nProgramId WHERE b.sProgramName LIKE 'PE Works Cohort%' 
) Z ON Y.[sSchoolDBN]=Z.[sParticipantSchDBN]

LEFT JOIN 
(SELECT a.[sEISID],a.[sEmployeeNo],a.[nComponentID],b.sComponentName,b.sComponentDesc,a.InAccurate_Flag,
a.LastModifiedDate,b.Is_Active,b.Is_AutoLabel,b.Is_AutoRefresh_Flag FROM [dbo].[ISS_tblTeacherProfileLabels] (NOLOCK) a
INNER JOIN (SELECT * FROM [dbo].[ISS_tblTeacherLabelsLookUp] (NOLOCK) WHERE nComponentID=16 AND Is_Active='Y')b
ON a.nComponentID=b.nComponentID) ape 
ON Y.[sEmployeeNo]=ape.[sEmployeeNo]


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_TRNS_TblStaffData]
--Table creation code:
CREATE TABLE [dbo].[ISS_TRNS_TblStaffData](
	[nEmpId] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[sEmployeeNo] [char](10) NULL,
	[sEISId] [char](7) NULL,
	[sLastName] [varchar](50) NULL,
	[sFirstName] [varchar](50) NULL,
	[sSchoolDBN] [char](6) NULL,
	[sEmpStatus] [char](1) NULL,
	[sTitleCode_Gxy] [char](5) NULL,
	[sTitleDesc_Gxy] [varchar](100) NULL,
	[sTitleCode_EIS] [char](5) NULL,
	[Is_Primary_Location] [char](1) NULL,
	[Central_Inst_Flag] [char](1) NULL,
	[dtLastUpdatedDate] [datetime] NULL,
	[sLastUpdatedBy] [varchar](100) NULL,
	[sChangeOfSource] [char](1) NULL,
	[sLicenceCode] [varchar](10) NULL,
	[sLicenceDesc] [varchar](150) NULL,
	[sOtherDBNs] [varchar](150) NULL,
	[Gender] [char](1) NULL,
	[Seniority_YY] [char](3) NULL,
	[Seniority_MM] [char](3) NULL,
	[DOE_Start_Date] [varchar](15) NULL,
	[Assignment_Code] [varchar](15) NULL,
	[Assignment_Desc] [varchar](300) NULL,
	[sTitle] [varchar](50) NULL,
	[ProfileDBNS] [varchar](300) NULL,
	[sCellPhone] [varchar](20) NULL,
	[sPersonalPhone] [varchar](20) NULL,
	[sNotes] [varchar](1000) NULL,
	[CoachNotes] [varchar](1000) NULL,
	[CYSExpDate] [datetime] NULL,
	[CPRExpDate] [datetime] NULL,
	[AdminNotes] [varchar](1000) NULL,
	[Phone] [varchar](15) NULL,
	[sOtherEmail] [varchar](100) NULL,
	[Is_TextMessage] [varchar](1) NULL,
	[LabelCount] [int] NULL,
	[LabelID] [nvarchar](max) NULL,
	[StaffLabels] [nvarchar](max) NULL,
	[SecondaryLicenseCode] [varchar](8000) NULL,
	[SecondaryLicenseDesc] [varchar](max) NULL,
	[CertificationCode] [varchar](8000) NULL,
	[CertificationDesc] [varchar](max) NULL,
	[sEmail] [varchar](100) NULL,
	[PE_Cohort_Name] [varchar](50) NULL,
	[APE_Teacher_Flag] [char](1) NULL,
	[DataPulledDate] [datetime] NULL,
	[SSN] [varchar](20) NULL,
	[DOB] [varchar](20) NULL,
	[sReason_Code] [char](3) NULL,
	[sReason_Desc] [varchar](150) NULL,
	[sPMS_Status] [varchar](150) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

Note: Ignore [nEmpID] for mapping

--DFT_SWHUB_Tbl_StaffData
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL Command text: 
SELECT DISTINCT staff.[nEmpId],staff.[sEmployeeNo],staff.[sEISId],staff.[sLastName],staff.[sFirstName],staff.[sSchoolDBN],staff.[sEmpStatus],
staff.[sTitleCode_Gxy],staff.[sTitleDesc_Gxy],staff.[sTitleCode_EIS],staff.[Is_Primary_Location],staff.[Central_Inst_Flag],staff.[dtLastUpdatedDate]
,staff.[sLastUpdatedBy],staff.[sChangeOfSource],staff.[sLicenceCode],staff.[sLicenceDesc],staff.[sOtherDBNs],staff.[Gender],staff.[Seniority_YY]
,staff.[Seniority_MM],staff.[DOE_Start_Date],staff.[Assignment_Code],staff.[Assignment_Desc],staff.[sTitle],staff.[ProfileDBNS],staff.[sCellPhone]
,staff.[sPersonalPhone],staff.[sNotes],staff.[CoachNotes],staff.[AdminNotes],staff.[Phone],staff.[sOtherEmail]
,staff.[Is_TextMessage],staff.[SecondaryLicenseCode],staff.[SecondaryLicenseDesc]
,staff.[CertificationCode],staff.[CertificationDesc],staff.[sEmail],staff.[PE_Cohort_Name],staff.[APE_Teacher_Flag],
Ev.[nEvents_Attended],
Inp.[nInterection_Attended],	

CASE WHEN mtiT.[sMTI_Trained]='Y' THEN 'YES' 
	 WHEN mtiT.[sMTI_Trained]='N' THEN 'NO' ELSE 'N/A' END AS [sMTI_Trained]

,CASE WHEN mtiTTT.[MTI TTT]='Y' THEN 'YES' 
	  WHEN mtiTTT.[MTI TTT]='N' THEN 'NO' ELSE '' END AS [sMTI_TTT_Trained]

,staff.[LabelCount],staff.[LabelID],staff.[StaffLabels],
staff.[CYSExpDate],staff.[CPRExpDate],
CASE 
	WHEN 
	(staff.[LabelID] LIKE '%6%' OR 
	 staff.[LabelID] LIKE '%16%' OR 
	 staff.[LabelID] LIKE '%19%' OR 
	 staff.[LabelID] LIKE '%25%' OR 
	 staff.[LabelID] LIKE '%26%' OR 
	 staff.[LabelID] LIKE '%49%' OR 
	 staff.[LabelID] LIKE '%50%' OR 
	 staff.[LabelID] LIKE '%63%') AND 
	 (GETDATE() <= staff.[CPRExpDate] AND GETDATE()<=staff.[CYSExpDate])
	 THEN 'Certified'
	 
	 WHEN 
	 (staff.[LabelID] LIKE '%6%' OR 
	  staff.[LabelID] LIKE '%16%' OR 
	  staff.[LabelID] LIKE '%19%' OR 
	  staff.[LabelID] LIKE '%25%' OR 
	  staff.[LabelID] LIKE '%26%' OR 
	  staff.[LabelID] LIKE '%49%' OR 
	  staff.[LabelID] LIKE '%50%' OR 
	  staff.[LabelID] LIKE '%63%') AND  
	 (GETDATE()>staff.[CPRExpDate] AND GETDATE()>staff.[CYSExpDate]) THEN 'Needed' 
	 
	 
	  WHEN 
	 (staff.[LabelID] LIKE '%6%' OR 
	  staff.[LabelID] LIKE '%16%' OR 
	  staff.[LabelID] LIKE '%19%' OR 
	  staff.[LabelID] LIKE '%25%' OR 
	  staff.[LabelID] LIKE '%26%' OR 
	  staff.[LabelID] LIKE '%49%' OR 
	  staff.[LabelID] LIKE '%50%' OR 
	  staff.[LabelID] LIKE '%63%')AND  
	 (staff.[CPRExpDate] IS NULL OR staff.[CYSExpDate] IS NULL) THEN 'Needed' 
	
	WHEN 
	 (staff.[LabelID] LIKE '%6%' OR 
	  staff.[LabelID] LIKE '%16%' OR 
	  staff.[LabelID] LIKE '%19%' OR 
	  staff.[LabelID] LIKE '%25%' OR 
	  staff.[LabelID] LIKE '%26%' OR 
	  staff.[LabelID] LIKE '%49%' OR 
	  staff.[LabelID] LIKE '%50%' OR 
	  staff.[LabelID] LIKE '%63%')AND  
	 (GETDATE()>=staff.[CPRExpDate] AND GETDATE()<staff.[CYSExpDate]) THEN 'Needed' 
	
	WHEN 
	 (staff.[LabelID] LIKE '%6%' OR  
	  staff.[LabelID] LIKE '%16%' OR 
	  staff.[LabelID] LIKE '%19%' OR 
	  staff.[LabelID] LIKE '%25%' OR 
	  staff.[LabelID] LIKE '%26%' OR 
	  staff.[LabelID] LIKE '%49%' OR 
	  staff.[LabelID] LIKE '%50%' OR 
	  staff.[LabelID] LIKE '%63%')AND  
	 (GETDATE()<staff.[CPRExpDate] AND GETDATE()>=staff.[CYSExpDate]) THEN 'Needed' 

	 END AS sAEDCYSCertStatus

,sch.[Location_Category_Description],sch.[Principal_Name],sch.[Principal_Email]
,staff.[SSN],staff.[DOB],staff.[sReason_Code],staff.[sReason_Desc],staff.[sPMS_Status]
,staff.[DataPulledDate]
FROM [dbo].[ISS_TRNS_TblStaffData] (NOLOCK) staff
LEFT JOIN (SELECT DISTINCT sParticipant,COUNT(nEventID) AS [nEvents_Attended] FROM (
SELECT DISTINCT nEventID,sEventParticipant_SchoolDBN,sParticipant,sEventParticipant_EmployeeNo,sEventParticipant_EISId 
FROM [SWHUB_ISS_EventParticipants](NOLOCK) WHERE sEventStatus NOT IN ('Cancelled,Postponed') AND [sEventParticipantType]='U' AND sParticipant IS NOT NULL
) a
GROUP BY sParticipant) Ev
ON REPLACE(SUBSTRING(staff.sEmail,1,(CHARINDEX('@', staff.sEmail))),'@','')=Ev.sParticipant
LEFT JOIN (
SELECT DISTINCT sInterectionParticipant_EmployeeNo ,COUNT([nProgStaffInteractID]) AS [nInterection_Attended] 
FROM(
SELECT DISTINCT a.sInterectionParticipant_SchoolDBN,a.sInterectionParticipant_EmployeeNo,a.sInterectionParticipant_EISId,a.[sParticipant],a.[nProgStaffInteractID]
FROM(
SELECT inp.*,
PI.SchoolDBN AS sInterectionParticipant_SchoolDBN,
PI.FirstName AS sInterectionParticipant_FirstName,
PI.LastName AS sInterectionParticipant_LastName,
PI.[EmployeeNo] AS sInterectionParticipant_EmployeeNo,
PI.[EISId] AS sInterectionParticipant_EISId
FROM (
SELECT DISTINCT [sParticipant],[nProgStaffInteractID],[sInteractionName] FROM [SWHUB_ISS_InteractionParticipants] (NOLOCK) 
WHERE [sInteractionStatus] NOT IN ('Cancelled','Postponed') AND [sInterectionParticipantType]='U' AND sParticipant IS NOT NULL
) inp
INNER JOIN [dbo].[SWHUB_ISS_PersonalInfo] (NOLOCK)PI ON inp.sParticipant =PI.nEmpId AND pi.SchoolDBN IS NOT NULL
) a 
)b
GROUP BY  sInterectionParticipant_EmployeeNo
) Inp ON staff.[sEmployeeNo]=inp.sInterectionParticipant_EmployeeNo
LEFT JOIN (SELECT DISTINCT sEmployeeNo,[sEISId],sSchoolDBN,[sMTI_Trained],[MTI TTT] FROM [SWHUB_MTI_Eligible_Teachers](NOLOCK))  mtiT ON staff.[sEISID]=mtit.[sEISID]
LEFT JOIN (SELECT DISTINCT sEmployeeNo,[sEISId],sSchoolDBN,[sMTI_Trained],[MTI TTT] FROM [SWHUB_MTI_Eligible_Teachers](NOLOCK))  mtiTTT ON staff.[sEISID]=mtiTTT.[sEISID]
LEFT join [dbo].[SWHUB_Supertable_Schools Dimension](NOLOCK) SCH on STAFF.SsCHOOLdbn=sch.[System_Code]
WHERE staff.sEISID IS NOT NULL OR staff.sEmployeeNo IS NOT NULL

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_TblStaffData]
--Table creation code:
USE [FGR_INT]
IF OBJECT_ID('SWHUB_TblStaffData') IS NOT NULL
	DROP TABLE [SWHUB_TblStaffData]
CREATE TABLE [dbo].[SWHUB_TblStaffData](
	[nEmpId] [numeric](18, 0) IDENTITY(1,1) NOT NULL,
	[sEmployeeNo] [char](10) NULL,
	[sEISId] [char](7) NULL,
	[sLastName] [varchar](50) NULL,
	[sFirstName] [varchar](50) NULL,
	[sSchoolDBN] [char](6) NULL,
	[sEmpStatus] [char](1) NULL,
	[sTitleCode_Gxy] [char](5) NULL,
	[sTitleDesc_Gxy] [varchar](100) NULL,
	[sTitleCode_EIS] [char](5) NULL,
	[Is_Primary_Location] [char](1) NULL,
	[Central_Inst_Flag] [char](1) NULL,
	[dtLastUpdatedDate] [datetime] NULL,
	[sLastUpdatedBy] [varchar](100) NULL,
	[sChangeOfSource] [char](1) NULL,
	[sLicenceCode] [varchar](10) NULL,
	[sLicenceDesc] [varchar](150) NULL,
	[sOtherDBNs] [varchar](150) NULL,
	[Gender] [char](1) NULL,
	[Seniority_YY] [char](3) NULL,
	[Seniority_MM] [char](3) NULL,
	[DOE_Start_Date] [varchar](15) NULL,
	[Assignment_Code] [varchar](15) NULL,
	[Assignment_Desc] [varchar](300) NULL,
	[sTitle] [varchar](50) NULL,
	[ProfileDBNS] [varchar](300) NULL,
	[sCellPhone] [varchar](20) NULL,
	[sPersonalPhone] [varchar](20) NULL,
	[sNotes] [varchar](1000) NULL,
	[CoachNotes] [varchar](1000) NULL,
	[CYSExpDate] [datetime] NULL,
	[CPRExpDate] [datetime] NULL,
	[AdminNotes] [varchar](1000) NULL,
	[Phone] [varchar](15) NULL,
	[sOtherEmail] [varchar](100) NULL,
	[Is_TextMessage] [varchar](1) NULL,
	[LabelCount] [int] NULL,
	[LabelID] [nvarchar](max) NULL,
	[StaffLabels] [nvarchar](max) NULL,
	[SecondaryLicenseCode] [varchar](8000) NULL,
	[SecondaryLicenseDesc] [varchar](max) NULL,
	[CertificationCode] [varchar](8000) NULL,
	[CertificationDesc] [varchar](max) NULL,
	[sEmail] [varchar](100) NULL,
	[PE_Cohort_Name] [varchar](50) NULL,
	[APE_Teacher_Flag] [char](1) NULL,
	[nEvents_Attended] [int] NULL,
	[nInterection_Attended] [int] NULL,
	[sMTI_Trained] [char](3) NULL,
	[Location_Category_Description] [varchar](35) NULL,
	[Principal_Name] [varchar](50) NULL,
	[Principal_Email] [varchar](100) NULL,
	[DataPulledDate] [datetime] NULL,
	[sMTI_TTT_Trained] [char](3) NULL,
	[sAEDCYSCertStatus] [varchar](10) NULL,
	[SSN] [varchar](20) NULL,
	[DOB] [varchar](20) NULL,
	[sReason_Code] [char](3) NULL,
	[sReason_Desc] [varchar](150) NULL,
	[sPMS_Status] [varchar](150) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO




--EST_Delete the existing quick search data
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
DELETE FROM OSWP_TblGSeacrhData
GO

--DFT_Insert data to OSWP_TblGSeacrhData
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL Command text: 

EXEC usp_OSWP_GSearchData

--Creation of stored procedure
USE [ISS_EXT]
GO

/****** Object:  StoredProcedure [dbo].[usp_OSWP_GSearchData]    Script Date: 12/4/2019 10:25:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_OSWP_GSearchData]
AS
SET NOCOUNT ON

	DECLARE @FiscalYear AS INT
	IF MONTH(GETDATE()) < 7
		SET @FiscalYear = YEAR(GETDATE())
	ELSE
		SET @FiscalYear = YEAR(GETDATE()) + 1

	SELECT 
				'1' AS sCatId,
				'BindSchoolProfile' + '~' + System_Code AS id,
				System_Code + '  ' + REPLACE(Location_Name,'-','') AS sName
	FROM 
				SUPERLINK.SuperTable.dbo.Location_Supertable1 
	WHERE 
				Fiscal_Year = @FiscalYear
				AND LEN(System_Code) = 6   
				AND system_id = 'ats'
	UNION ALL

	SELECT
				'2' AS sCatId,
				'BindStaffProfile' + '~' + ISS_tblPersonalInfo.sEmployeeNo AS Id,
				(REPLACE(ISS_tblPersonalInfo.sFirstName,'-','') + ' ' + REPLACE(ISS_tblPersonalInfo.sLastName,'-','') + ' (' + ISS_tblADUsers.sUserId + ')') AS sName
	FROM 
				ISS_tblPersonalInfo
				INNER JOIN 
				ISS_tblADUsers ON ISS_tblPersonalInfo.sEmployeeNo = ISS_tblADUsers.sEmployeeNo
	WHERE
				sEmpStatus = 'A'
	UNION ALL

	SELECT 
		'3' AS  sCatId,
		'BindOrganizationProfile' + '~' + CAST(Id AS VARCHAR(10)) AS id,
		REPLACE([Name],'-','') AS sName
	FROM 
		WC_ResourcesList
	WHERE
		[Delete] = 0
		AND
		Approved = 'Y'
		AND
		(Archived = 'N' OR Archived IS NULL)

GO

--Data Conversion:
Input Column		Output Alias			Data Type					Length
[sName]				sName_Convert			string [DT_STR]				300
[id]				id_Convert				string [DT_STR]				100

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [OSWP_TblGSearchData]
--Table creation code:
CREATE TABLE [dbo].[OSWP_TblGSeacrhData](
	[sCatId] [varchar](1) NOT NULL,
	[id] [varchar](100) NULL,
	[sName] [varchar](300) NULL
) ON [PRIMARY]

GO

--Variables for this Package:

Name			Scope							Data type			Value
PackageID		Package 10_Get Staff Data 		Int32				10


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
VALUES (10,'Package 10_Get Staff Data')