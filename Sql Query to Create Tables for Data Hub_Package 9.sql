--EST_Delete data from destinatination tabl
Connection: ES11VDEXTESQL01 FGR_INT FGRepUser
SQL Statement:

TRUNCATE TABLE [SWC_STG_Participants]
GO

TRUNCATE TABLE [SWC_STG_Members]
GO

TRUNCATE TABLE [SWC_STG_DBN_Resource]
GO

TRUNCATE TABLE [SWC_STG_ScorecardRating]
GO

TRUNCATE TABLE [SWC_STG_ActionPlan]
GO

TRUNCATE TABLE [SWC_STG_Budget]
GO

TRUNCATE TABLE [SWHUB_SWC_Grant_Schools]
GO

TRUNCATE TABLE [SWHUB_SWC_Active_Memebrs_withGrantStatus]
GO

TRUNCATE TABLE [SWHUB_SWC_Grant_and_NonGeant_Schools_and_Members]
GO

TRUNCATE TABLE [SWHUB_SWC_Programs_Activities_Participants]
GO

TRUNCATE TABLE [SWC_STG_TotalMembers_ActiveYear]
GO

--Sequence Container 1
--DFT_SWC_STG_Participants
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view
--Name of the table or the view: [WC_Participants]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWC_STG_Participants]
--Table creation code:

--FOR SWC Staging Tables
USE FGR_INT
IF OBJECT_ID('[SWC_STG_Participants]') IS NOT NULL
	DROP TABLE [SWC_STG_Participants]
CREATE TABLE [dbo].[SWC_STG_Participants](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WCYearId] [int] NULL,
	[DBN] [varchar](6) NULL,
	[Grant] [char](1) NULL,
	[Mentor] [bit] NULL,
	[Delete] [bit] NULL,
	[CreatedByUserId] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedByUserId] [varchar](100) NULL,
	[UpdatedDate] [datetime] NULL,
	[HE] [char](1) NULL,
	[PE] [char](1) NULL
)


--DFT_SWC_STG_Members
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL Command text: 
DECLARE @WCYearID INT
SELECT @WCYearID = WCYearId FROM WC_Admin WHERE GETDATE() BETWEEN StartDate AND EndDate
SELECT TAU.sEmployeeNo AS EmployeeNumber,WCM.[WCYearId],WCM.Aduid,WCM.FName AS FirstName,WCM.LName AS LastName,WCM.[Email],WCM.[Phone],WCM.[RoleId],WCM.[DBN],WCM.[MentorLeader],WCM.[Delete],WCM.[CreatedByUserId],
WCM.[CreatedDate],WCM.[UpdatedByUserId],WCM.[UpdatedDate],WCM.[MentorRole],WCM.[ViewerSchools],WCM.[Approved],WCM.[Cellphone],WCM.[OtherEmail],WCM.[ActiveYear],WCM.[RoleDesc]
,CASE WHEN CONVERT(VARCHAR,WCM.MentorLeader,10) = '1' AND WCM.ActiveYear = @WCYearID THEN 'Wellness Council Champion (current)' 
	WHEN CONVERT(VARCHAR,WCM.MentorLeader,10) = '1' AND WCM.ActiveYear <> @WCYearID THEN 'Wellness Council Champion (former)' 
	WHEN CONVERT(VARCHAR,WCM.MentorLeader,10) <> '1' AND WCM.ActiveYear = @WCYearID THEN 'Wellness Council Member (current)' 
	WHEN CONVERT(VARCHAR,WCM.MentorLeader,10) <> '1' AND WCM.ActiveYear <> @WCYearID THEN 'Wellness Council Member (former)' 
END AS TeacherLabel
,CASE WHEN CONVERT(VARCHAR,WCM.MentorLeader,10) = '1' AND WCM.ActiveYear = @WCYearID THEN 54
	WHEN CONVERT(VARCHAR,WCM.MentorLeader,10) = '1' AND WCM.ActiveYear <> @WCYearID THEN 55
	WHEN CONVERT(VARCHAR,WCM.MentorLeader,10) <> '1' AND WCM.ActiveYear = @WCYearID THEN 56
	WHEN CONVERT(VARCHAR,WCM.MentorLeader,10) <> '1' AND WCM.ActiveYear <> @WCYearID THEN 57
END AS TeacherLabelId		
FROM WC_members WCM LEFT JOIN ISS_tblADUsers TAU ON WCM.Aduid = TAU.sUserID
WHERE WCM.[Delete] = 0 AND WCM.ActiveYear IS NOT NULL 
ORDER BY WCM.FName,WCM.LName

--Data Conversion:
Input Column		Output Alias			Data Type				Length
EmployeeNumber		EmployeeNumber_Convert	string [DT_STR]			15	


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWC_STG_Members]
--Table creation code:
IF OBJECT_ID('[SWC_STG_Members]') IS NOT NULL
	DROP TABLE [SWC_STG_Members]
CREATE TABLE [dbo].[SWC_STG_Members](
	[Id] [int]  IDENTITY(1,1) NOT NULL,
	[DOE_EmployeeID] [CHAR](15) NULL,
	[WCYearId] [int] NULL,
	[Aduid] [varchar](100) NULL,
	[FName] [varchar](100) NULL,
	[LName] [varchar](100) NULL,
	[Email] [varchar](100) NULL,
	[Phone] [varchar](100) NULL,
	[RoleId] [int] NULL,
	[DBN] [varchar](100) NULL,
	[MentorLeader] [bit] NULL,
	[Delete] [bit] NULL,
	[CreatedByUserId] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedByUserId] [varchar](100) NULL,
	[UpdatedDate] [datetime] NULL,
	[MentorRole] [varchar](10) NULL,
	[ViewerSchools] [varchar](500) NULL,
	[Approved] [char](1) NULL,
	[Cellphone] [varchar](100) NULL,
	[OtherEmail] [varchar](100) NULL,
	[ActiveYear] [int] NULL,
	[RoleDesc] [varchar](100) NULL,
	[TeacherLabel] [varchar](100) NULL,
	[TeacherLabelId] [int] NULL
)

Note: Ignore [Id] for mapping 

--DFT_SWC_STG_DBN_Resource
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view
--Name of the table or the view: [WC_DBNResource]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWC_STG_DBN_Resource]
--Table creation code:
IF OBJECT_ID('[SWC_STG_DBN_Resource]') IS NOT NULL
	DROP TABLE [SWC_STG_DBN_Resource]
CREATE TABLE [dbo].[SWC_STG_DBN_Resource](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WCYearId] [int] NULL,
	[ResourceId] [int] NULL,
	[DBN] [varchar](6) NULL,
	[Delete] [bit] NULL,
	[CreatedByUserId] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedByUserId] [varchar](100) NULL,
	[UpdatedDate] [datetime] NULL,
	[ClubId] [int] NULL
)
Note: Ignore [Id] for mapping 

--DFT_SWC_STG_ScorecardRating
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view
--Name of the table or the view: [WC_ScorecardRating]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWC_STG_ScorecardRating]
--Table creation code:
IF OBJECT_ID('[SWC_STG_ScorecardRating]') IS NOT NULL
	DROP TABLE [SWC_STG_ScorecardRating]
CREATE TABLE [dbo].[SWC_STG_ScorecardRating](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WCYearId] [int] NULL,
	[SCItemId] [int] NULL,
	[CategoryId] [int] NULL,
	[DBN] [varchar](6) NULL,
	[Rating] [smallint] NULL,
	[Focus] [bit] NULL,
	[Submit] [char](1) NULL,
	[Delete] [bit] NULL,
	[CreatedByUserId] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedByUserId] [varchar](100) NULL,
	[UpdatedDate] [datetime] NULL,
	[Complete] [char](1) NULL,
	[SubmittedBy] [varchar](100) NULL,
	[SubmittedByDate] [datetime] NULL
)
Note: Ignore [Id] for mapping 


--DFT_SWC_STG_ActionPlan
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view
--Name of the table or the view: [WC_ActionPlan]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWC_STG_ActionPlan]
--Table creation code:
use FGR_INT
IF OBJECT_ID('[SWC_STG_ActionPlan]') IS NOT NULL
	DROP TABLE [SWC_STG_ActionPlan]
CREATE TABLE [dbo].[SWC_STG_ActionPlan](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DBN] [varchar](6) NULL,
	[PEScorecardItem] [varchar](100) NULL,
	[PEStandardPractice] [text] NULL,
	[PEActionItem] [varchar](6000) NULL,
	[PEFreeResources] [varchar](100) NULL,
	[PEPaidResources] [varchar](100) NULL,
	[PEActionPlan] [text] NULL,
	[HEScorecardItem] [varchar](100) NULL,
	[HEStandardPractice] [text] NULL,
	[HEActionItem] [varchar](6000) NULL,
	[HEFreeResources] [varchar](100) NULL,
	[HEPaidResources] [varchar](100) NULL,
	[HEActionPlan] [text] NULL,
	[Other1ScorecardItem] [varchar](100) NULL,
	[Other1StandardPractice] [text] NULL,
	[Other1ActionItem] [varchar](6000) NULL,
	[Other1FreeResource] [varchar](100) NULL,
	[Other1PaidResource] [varchar](100) NULL,
	[Other1ActionPlan] [text] NULL,
	[Other2ScorecardItem] [varchar](100) NULL,
	[Other2StandardPractice] [text] NULL,
	[Other2ActionItem] [varchar](6000) NULL,
	[Other2FreeResource] [varchar](100) NULL,
	[Other2PaidResource] [varchar](100) NULL,
	[Other2ActionPlan] [text] NULL,
	[Other3ScorecardItem] [varchar](100) NULL,
	[Other3StandardPractice] [text] NULL,
	[Other3ActionItem] [varchar](6000) NULL,
	[Other3FreeResource] [varchar](100) NULL,
	[Other3PaidResource] [varchar](100) NULL,
	[Other3ActionPlan] [text] NULL,
	[Complete] [bit] NULL,
	[Delete] [bit] NULL,
	[CreatedByUserId] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedByUserId] [varchar](100) NULL,
	[UpdateDate] [datetime] NULL,
	[Other1Category] [varchar](10) NULL,
	[Other2Category] [varchar](10) NULL,
	[Other3Category] [varchar](10) NULL,
	[WCYear] [int] NULL,
	[PECategory] [varchar](10) NULL,
	[HECategory] [varchar](10) NULL,
	[HEClub] [varchar](50) NULL,
	[PEClub] [varchar](50) NULL,
	[Other1Club] [varchar](50) NULL,
	[Other2Club] [varchar](50) NULL,
	[Other3Club] [varchar](50) NULL,
	[PEActionContact] [varchar](2000) NULL,
	[PEActionTDate] [varchar](2000) NULL,
	[PEActionStatus] [varchar](100) NULL,
	[PEActionCDate] [varchar](2000) NULL,
	[HEActionContact] [varchar](2000) NULL,
	[HEActionTDate] [varchar](2000) NULL,
	[HEActionStatus] [varchar](100) NULL,
	[HEActionCDate] [varchar](2000) NULL,
	[Other1ActionContact] [varchar](2000) NULL,
	[Other1ActionTDate] [varchar](2000) NULL,
	[Other1ActionStatus] [varchar](100) NULL,
	[Other1ActionCDate] [varchar](2000) NULL,
	[Other2ActionContact] [varchar](2000) NULL,
	[Other2ActionTDate] [varchar](2000) NULL,
	[Other2ActionStatus] [varchar](100) NULL,
	[Other2ActionCDate] [varchar](2000) NULL,
	[Other3ActionContact] [varchar](2000) NULL,
	[Other3ActionTDate] [varchar](2000) NULL,
	[Other3ActionStatus] [varchar](100) NULL,
	[Other3ActionCDate] [varchar](2000) NULL,
	[PEActionEmail] [varchar](3000) NULL,
	[HEActionEmail] [varchar](3000) NULL,
	[Other1ActionEmail] [varchar](3000) NULL,
	[Other2ActionEmail] [varchar](3000) NULL,
	[Other3ActionEmail] [varchar](3000) NULL,
	[SubmittedBy] [varchar](100) NULL,
	[SubmittedByDate] [datetime] NULL,
	[PEEstimatedCost] [decimal](10, 2) NULL,
	[HEEstimatedCost] [decimal](10, 2) NULL,
	[Othr1EstimatedCost] [decimal](10, 2) NULL,
	[Othr2EstimatedCost] [decimal](10, 2) NULL,
	[Othr3EstimatedCost] [decimal](10, 2) NULL,
)
Note: Ignore [Id] for mapping 

--DFT_SWC_STG_Budget
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view
--Name of the table or the view: [WC_Budget]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWC_STG_ActionPlan]
--Table creation code:
IF OBJECT_ID('[SWC_STG_Budget]') IS NOT NULL
	DROP TABLE [SWC_STG_Budget]
CREATE TABLE [dbo].[SWC_STG_Budget](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[WCYearId] [int] NULL,
	[ResourceId] [int] NULL,
	[VendorNo] [varchar](50) NULL,
	[DBN] [varchar](6) NULL,
	[ItemService] [varchar](200) NULL,
	[ItemNo] [varchar](50) NULL,
	[ObjectCode] [varchar](20) NULL,
	[CostperItem] [varchar](50) NULL,
	[UnitPurchase] [varchar](50) NULL,
	[TotalCost] [varchar](50) NULL,
	[Delete] [bit] NULL,
	[CreatedByUserId] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedByUserId] [varchar](100) NULL,
	[UpdatedDate] [datetime] NULL,
	[ResourceEmail] [varchar](100) NULL,
	[ResourcePhone] [varchar](100) NULL,
	[ScorecardCategory] [int] NULL,
	[ActionItem] [varchar](50) NULL,
	[DeliveryInstruction] [text] NULL,
	[PurchaserName] [varchar](100) NULL,
	[PurchaserEmail] [varchar](100) NULL,
	[PurchaserPhone] [varchar](100) NULL,
	[PurchaserAddress] [varchar](1000) NULL,
	[Complete] [char](1) NULL,
	[Documents] [text] NULL,
	[Approved] [char](1) NULL,
	[AdditionalFees] [varchar](10) NULL,
	[PONumber] [varchar](50) NULL,
	[DateReceived] [datetime] NULL,
	[DateCertified] [datetime] NULL,
	[ClubId] [int] NULL,
	[PurchaseType] [varchar](10) NULL,
	[TeacherName] [varchar](100) NULL,
	[TeacherEmail] [varchar](100) NULL,
	[TeacherPhone] [varchar](50) NULL,
	[PrincipalApproved] [char](1) NULL,
	[Comments] [text] NULL,
	[SubmittedBy] [varchar](100) NULL,
	[SubmittedDate] [datetime] NULL,
	[Imported] [char](1) NULL,
	[Imp_VendorName] [varchar](200) NULL,
	[BudgetStatus] [int] NULL,
	[BudgetComments] [varchar](5000) NULL,
	[BudgetStatusUpatedBy] [varchar](50) NULL,
	[BudgetStatusUpatedDate] [datetime] NULL,
	[ItemReplaced] [char](1) NULL,
	[Bulk] [bit] NULL
)

Note: Ignore [Id] for mapping

--Sequence Container 2
--DFT_SWHUB_SWC_Grant_Schools
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT   WCYearId AS SchoolYear, DBN AS SchoolDBN, [SWC_ProgramType]
FROM (
SELECT  DISTINCT WCYearId, DBN, 
CASE WHEN DBN IS NOT NULL THEN 'SWC Continuation Grant' END AS [SWC_ProgramType]
FROM SWC_STG_Participants WHERE [Delete] = 0 AND [GRANT]='C' 
UNION
SELECT  DISTINCT WCYearId, DBN,
CASE WHEN DBN IS NOT NULL THEN 'SWC Implementation Grant' END AS [SWC_ProgramType]
FROM SWC_STG_Participants WHERE [Delete] = 0 AND [GRANT]='I' 
UNION
SELECT  DISTINCT WCYearId, DBN,
CASE WHEN DBN IS NOT NULL THEN 'HE Focus Schools Program' END AS [SWC_ProgramType]
FROM SWC_STG_Participants WHERE [Delete] = 0 AND [HE] ='Y' 
UNION
SELECT  DISTINCT WCYearId, DBN,
CASE WHEN DBN IS NOT NULL THEN 'PE Focus Schools Program' END AS [SWC_ProgramType]
FROM SWC_STG_Participants WHERE [Delete] = 0 AND [PE] ='Y'
UNION
SELECT  DISTINCT WCYearId, DBN,
CASE WHEN DBN IS NOT NULL THEN 'Non-Award' END AS [SWC_ProgramType]
FROM SWC_STG_Participants WHERE [Delete] = 0 AND [GRANT]='NA' 
) a

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_SWC_Grant_Schools]
--Table creation code:
IF OBJECT_ID('[SWHUB_SWC_Grant_Schools]') IS NOT NULL
	DROP TABLE [SWHUB_SWC_Grant_Schools]
CREATE TABLE [dbo].[SWHUB_SWC_Grant_Schools](
	[SchoolYear] [int] NULL,
	[SchoolDBN] [varchar](6) NULL,
	[SWC_ProgramType] [varchar](100) NULL
) 


--DFT_SWHUB_SWC_Active_Memebrs_withGrantStatus
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
--All Active SWC Memebrs
SELECT  a.*,b.[SWC_ProgramType] 
FROM
(SELECT * FROM [SWC_STG_Members]) a 
LEFT JOIN (SELECT * FROM [SWHUB_SWC_Grant_Schools]) b ON a.[DBN]=b.[SchoolDBN] AND a.WCYearID=b.[SchoolYear]
ORDER BY a.WCYearID,a.DBN

--Data Conversion:
Input Column		Output Alias			Data Type					Length
[DBN]				DBN_Convert				string [DT_STR]				6

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_SWC_Active_Memebrs_withGrantStatus]
--Table creation code:
IF OBJECT_ID('[SWHUB_SWC_Active_Memebrs_withGrantStatus]') IS NOT NULL
	DROP TABLE [SWHUB_SWC_Active_Memebrs_withGrantStatus]
CREATE TABLE [dbo].[SWHUB_SWC_Active_Memebrs_withGrantStatus](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SchoolYear] [int] NULL,
	[Aduid] [varchar](100) NULL,
	[FName] [varchar](100) NULL,
	[LName] [varchar](100) NULL,
	[Email] [varchar](100) NULL,
	[Phone] [varchar](100) NULL,
	[RoleId] [int] NULL,
	[SchoolDBN] [varchar](6) NULL,
	[MentorLeader] [bit] NULL,
	[Delete] [bit] NULL,
	[CreatedByUserId] [varchar](100) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedByUserId] [varchar](100) NULL,
	[UpdatedDate] [datetime] NULL,
	[MentorRole] [varchar](10) NULL,
	[ViewerSchools] [varchar](500) NULL,
	[Approved] [char](1) NULL,
	[Cellphone] [varchar](100) NULL,
	[OtherEmail] [varchar](100) NULL,
	[ActiveYear] [int] NULL,
	[RoleDesc] [varchar](100) NULL,
	[SWC_ProgramType] [varchar](100) NULL
) 
Note: Ignore [Id] for mapping

--DFT_SWC_STG_TotalMembers_ActiveYear
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT ActiveYear,DBN AS SchoolDBN,COUNT(ActiveYear) AS [SWC_Members_N]
FROM
(SELECT * FROM [SWC_STG_Members] WHERE [Delete] = 0 AND Activeyear IS NOT NULL 
) a 
GROUP BY ActiveYear,DBN

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWC_STG_TotalMembers_ActiveYear]
--Table creation code:

USE FGR_INT
IF OBJECT_ID('[SWC_STG_TotalMembers_ActiveYear]') IS NOT NULL
	DROP TABLE [SWC_STG_TotalMembers_ActiveYear]
CREATE TABLE [dbo].[SWC_STG_TotalMembers_ActiveYear](
	[Id] [int]  IDENTITY(1,1) NOT NULL,
	[ActiveYear] [int] NULL,
	[SchoolDBN] [varchar](100) NULL,
	[SWC_Members_N] [INT] NULL
	)

Note: Ignore [Id] for mapping


--DFT_SWHUB_SWC_Grant_and_NonGeant_Schools_and_Members
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:

--New
--All schools (Non-grant & grant) with or without SWC members
--All Non-Grant Schools with SWC members
SELECT DISTINCT c.SchoolYear,c.SchoolDBN, 
CASE WHEN c.SchoolDBN IS NOT NULL THEN 'Non Grant Schools with SWC' END AS [SWC_ProgramType]
FROM [dbo].[SWHUB_SWC_Active_Memebrs_withGrantStatus] c
WHERE (c.SchoolDBN IS NOT NULL AND c.SchoolDBN<>'') AND c.[SWC_ProgramType] IS NULL 
UNION
--All Grant Schools with or without SWC members
SELECT DISTINCT a.* FROM [SWHUB_SWC_Grant_Schools] a

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWC_STG_TotalMembers_ActiveYear]
--Table creation code:
IF OBJECT_ID('[SWHUB_SWC_Grant_and_NonGeant_Schools_and_Members]') IS NOT NULL
	DROP TABLE [SWHUB_SWC_Grant_and_NonGeant_Schools_and_Members]
CREATE TABLE [dbo].[SWHUB_SWC_Grant_and_NonGeant_Schools_and_Members](
	[SchoolYear] [int] NULL,
	[SchoolDBN] [varchar](6) NULL,
	[SWC_ProgramType] [varchar](100) NULL,
	[SWC_Members_N] [INT] NULL
) 


--DFT_SWHUB_SWC_Programs_Activities_Participants
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT  Z.SchoolYear
		,19 AS [Program_ID]
		,'School  Wellness Council Grant (SWC)'AS [ProgramName]
		,Z.SchoolDBN
		,Z.[SWC_ProgramType]
		,Z.[SWC_Members_N]
		,Z.Total_Resources_N
		,CASE WHEN Z.ScorecardComplete = 'Y' THEN 'Yes' WHEN Z.ScorecardComplete = 'N' THEN 'No' WHEN Z.ScorecardComplete = ''  THEN 'No' WHEN Z.ScorecardComplete IS NULL THEN 'No' END AS [Scorecard_Complete]
		,CASE WHEN Z.ActionPlanComplete = 1 THEN 'Yes' WHEN Z.ActionPlanComplete = 0 THEN 'No' WHEN Z.ActionPlanComplete IS NULL THEN 'No' END AS [Action_Plan_Complete]
		,CASE WHEN Z.BudgetComplete = 'Y' THEN 'Yes' WHEN Z.BudgetComplete = 'N' THEN 'No' WHEN Z.BudgetComplete IS NULL THEN 'No' END AS [Budget_Complete],
		Z.[SWC_Current_Champion_N],
		--CAST(Z.[Goal1_N_Steps_Completed] AS Varchar(2)) + ' ' + + 'of' + + ' ' + CAST(Z.[Goal1_Total_Steps] AS Varchar(2)) + ' ' + + 'steps'  AS [Goal1_Completed_Steps],
		Z.[Goal1_Total_Steps],	
		Z.[Goal1_N_Steps_NotStarted],
		ROUND(((CAST(Z.[Goal1_N_Steps_NotStarted] AS Float)/NULLIF(CAST(Z.[Goal1_Total_Steps] AS Float),0)) *100),0)	AS [Goal1_StepsNotStarted_Percent],
		Z.[Goal1_N_Steps_InProgress],
		ROUND(((CAST(Z.[Goal1_N_Steps_Inprogress] AS Float)/NULLIF(CAST(Z.[Goal1_Total_Steps] AS Float),0)) *100),0)	AS [Goal1_StepsInProgress_Percent],
		Z.[Goal1_N_Steps_Canceled],
		ROUND(((CAST(Z.[Goal1_N_Steps_Canceled] AS Float)/NULLIF(CAST(Z.[Goal1_Total_Steps] AS Float),0)) *100),0)		AS [Goal1_StepsCanceled_Percent],
		Z.[Goal1_N_Steps_Completed],
		ROUND(((CAST(Z.[Goal1_N_Steps_Completed] AS Float)/NULLIF(CAST(Z.[Goal1_Total_Steps] AS Float),0)) *100),0)		AS [Goal1_StepsCompleted_Percent],

		Z.[Goal2_Total_Steps],
		Z.[Goal2_N_Steps_NotStarted],
		ROUND(((CAST(Z.[Goal2_N_Steps_NotStarted] AS Float)/NULLIF(CAST(Z.[Goal2_Total_Steps] AS Float),0)) *100),0)	AS [Goal2_StepsNotStarted_Percent],
		[Goal2_N_Steps_InProgress],
		ROUND(((CAST(Z.[Goal2_N_Steps_Inprogress] AS Float)/NULLIF(CAST(Z.[Goal2_Total_Steps] AS Float),0)) *100),0)	AS [Goal2_StepsInProgress_Percent],
		[Goal2_N_Steps_Canceled],
		ROUND(((CAST(Z.[Goal2_N_Steps_Canceled] AS Float)/NULLIF(CAST(Z.[Goal2_Total_Steps] AS Float),0)) *100),0)		AS [Goal2_StepsCanceled_Percent],
		Z.[Goal2_N_Steps_Completed],
		ROUND(((CAST(Z.[Goal2_N_Steps_Completed] AS Float)/NULLIF(CAST(Z.[Goal2_Total_Steps] AS Float),0)) *100),0)		AS [Goal2_StepsCompleted_Percent],
		

		Z.[Goal3_Total_Steps],
		Z.[Goal3_N_Steps_NotStarted],
		ROUND(((CAST(Z.[Goal3_N_Steps_NotStarted] AS Float)/NULLIF(CAST(Z.[Goal3_Total_Steps] AS Float),0)) *100),0)	AS [Goal3_StepsNotStarted_Percent],
		[Goal3_N_Steps_InProgress],
		ROUND(((CAST(Z.[Goal3_N_Steps_Inprogress] AS Float)/NULLIF(CAST(Z.[Goal3_Total_Steps] AS Float),0)) *100),0)	AS [Goal3_StepsInProgress_Percent],
		[Goal3_N_Steps_Canceled],
		ROUND(((CAST(Z.[Goal3_N_Steps_Canceled] AS Float)/NULLIF(CAST(Z.[Goal3_Total_Steps] AS Float),0)) *100),0)		AS [Goal3_StepsCanceled_Percent],
		Z.[Goal3_N_Steps_Completed],
		ROUND(((CAST(Z.[Goal3_N_Steps_Completed] AS Float)/NULLIF(CAST(Z.[Goal3_Total_Steps] AS Float),0)) *100),0)		AS [Goal3_StepsCompleted_Percent],
		
		Z.[Goal4_Total_Steps],
		Z.[Goal4_N_Steps_NotStarted],
		ROUND(((CAST(Z.[Goal4_N_Steps_NotStarted] AS Float)/NULLIF(CAST(Z.[Goal4_Total_Steps] AS Float),0)) *100),0)	AS [Goal4_StepsNotStarted_Percent],
		[Goal4_N_Steps_InProgress],
		ROUND(((CAST(Z.[Goal4_N_Steps_Inprogress] AS Float)/NULLIF(CAST(Z.[Goal4_Total_Steps] AS Float),0)) *100),0)	AS [Goal4_StepsInProgress_Percent],
		[Goal4_N_Steps_Canceled],
		ROUND(((CAST(Z.[Goal4_N_Steps_Canceled] AS Float)/NULLIF(CAST(Z.[Goal4_Total_Steps] AS Float),0)) *100),0)		AS [Goal4_StepsCanceled_Percent],
		Z.[Goal4_N_Steps_Completed],
		ROUND(((CAST(Z.[Goal4_N_Steps_Completed] AS Float)/NULLIF(CAST(Z.[Goal4_Total_Steps] AS Float),0)) *100),0)		AS [Goal4_StepsCompleted_Percent],
		
		Z.[Goal5_Total_Steps],
		Z.[Goal5_N_Steps_NotStarted],
		ROUND(((CAST(Z.[Goal5_N_Steps_NotStarted] AS Float)/NULLIF(CAST(Z.[Goal5_Total_Steps] AS Float),0)) *100),0)	AS [Goal5_StepsNotStarted_Percent],
		[Goal5_N_Steps_InProgress],
		ROUND(((CAST(Z.[Goal5_N_Steps_Inprogress] AS Float)/NULLIF(CAST(Z.[Goal5_Total_Steps] AS Float),0)) *100),0)	AS [Goal5_StepsInProgress_Percent],
		[Goal5_N_Steps_Canceled],
		ROUND(((CAST(Z.[Goal5_N_Steps_Canceled] AS Float)/NULLIF(CAST(Z.[Goal5_Total_Steps] AS Float),0)) *100),0)		AS [Goal5_StepsCanceled_Percent],
		Z.[Goal5_N_Steps_Completed],
		ROUND(((CAST(Z.[Goal5_N_Steps_Completed] AS Float)/NULLIF(CAST(Z.[Goal5_Total_Steps] AS Float),0)) *100),0)		AS [Goal5_StepsCompleted_Percent],
		Z.[PE_Cohort_Name]

		FROM 
		(
SELECT WCP.SchoolYear,WCP.[SchoolDBN],WCP.[SWC_ProgramType],TMCY.[SWC_Members_N],
COUNT(DISTINCT WCR.ResourceId) AS Total_Resources_N, 
WCS.[Complete] AS ScorecardComplete,BD.Complete AS BudgetComplete, AP.Complete AS ActionPlanComplete,WCHP.[SWC_Current_Champion_N],
APGL1.[Goal1_N_Steps_NotStarted],APGL1.[Goal1_N_Steps_Inprogress],APGL1.[Goal1_N_Steps_Completed],APGL1.[Goal1_N_Steps_Canceled],APGL1.[Goal1_Total_Steps],
APGL2.[Goal2_N_Steps_NotStarted],APGL2.[Goal2_N_Steps_Inprogress],APGL2.[Goal2_N_Steps_Completed],APGL2.[Goal2_N_Steps_Canceled],APGL2.[Goal2_Total_Steps],
APGL3.[Goal3_N_Steps_NotStarted],APGL3.[Goal3_N_Steps_Inprogress],APGL3.[Goal3_N_Steps_Completed],APGL3.[Goal3_N_Steps_Canceled],APGL3.[Goal3_Total_Steps],
APGL4.[Goal4_N_Steps_NotStarted],APGL4.[Goal4_N_Steps_Inprogress],APGL4.[Goal4_N_Steps_Completed],APGL4.[Goal4_N_Steps_Canceled],APGL4.[Goal4_Total_Steps],
APGL5.[Goal5_N_Steps_NotStarted],APGL5.[Goal5_N_Steps_Inprogress],APGL5.[Goal5_N_Steps_Completed],APGL5.[Goal5_N_Steps_Canceled],APGL5.[Goal5_Total_Steps],
COH.ProgramName AS [PE_Cohort_Name]
FROM [SWHUB_SWC_Grant_and_NonGeant_Schools_and_Members] WCP
INNER JOIN  SUPERLINK.SuperTable.dbo.Location_Supertable1 LST 
ON (LST.System_Code = WCP.[SchoolDBN] AND LST.Fiscal_Year = CASE WHEN MONTH(GETDATE()) >= '07' THEN YEAR(GETDATE())  ELSE YEAR(GETDATE()+1) END AND LST.System_ID = 'ATS')
LEFT JOIN [dbo].[SWC_STG_DBN_Resource] WCR ON (WCR.[DBN] = WCP.SchoolDBN AND WCR.[Delete] = 0)-- AND WCR.WCYearId = WCP.SchoolYear)
LEFT JOIN [dbo].[SWC_STG_ScorecardRating] WCS ON (WCS.[DBN] = WCP.SchoolDBN AND WCS.[Delete] = 0 AND WCS.Complete='Y' AND WCS.WCYearId = WCP.SchoolYear)
LEFT JOIN [dbo].[SWC_STG_Budget] BD ON (BD.[DBN] = WCP.SchoolDBN AND BD.[Delete] = 0 AND BD.Complete='Y' AND BD.WCYearId = WCP.SchoolYear)
LEFT JOIN [dbo].[SWC_STG_ActionPlan] AP ON (AP.[DBN] = WCP.SchoolDBN AND AP.[Delete] = 0 AND AP.Complete=1 AND AP.WCYear = WCP.SchoolYear)

LEFT JOIN SWC_STG_TotalMembers_ActiveYear TMCY ON WCP.SchoolYear=TMCY.Activeyear AND WCP.[SchoolDBN]=TMCY.SchoolDBN

LEFT JOIN (
SELECT  a.[ProgramId],a.[ParticipantSchoolDBN],b.ProgramName FROM [dbo].[SWHUB_ISS_ProgramParticipants] a
LEFT JOIN [dbo].[SWHUB_ISS_Programs] b ON a.ProgramId=b.ProgramId WHERE b.ProgramName LIKE 'PE Works Cohort%'
) COH ON COH.[ParticipantSchoolDBN]=WCP.[SchoolDBN]


LEFT JOIN (
SELECT [ActiveYear],DBN,COUNT(DOE_EmployeeID) AS [SWC_Current_Champion_N] FROM
(SELECT DISTINCT [ActiveYear],[DBN],[DOE_EmployeeID],[FName],[LName],[Email],[TeacherLabel]FROM [dbo].[SWC_STG_Members] 
WHERE TeacherLabel='Wellness Council Champion (current)' AND DBN IS NOT NULL AND DBN <>'') ch
GROUP BY [ActiveYear],DBN
) WCHP 
ON WCHP.[ActiveYear]=WCP.[SchoolYear] AND WCHP.DBN=WCP.SchoolDBN

LEFT JOIN (
SELECT GL1.WCYear,GL1.[DBN],GL1.PEActionStatus,GL1.[Goal1_N_Steps_NotStarted],GL1.[Goal1_N_Steps_Inprogress],GL1.[Goal1_N_Steps_Completed],GL1.[Goal1_N_Steps_Canceled],GL1.[Goal1_Total_Steps] FROM (
SELECT DISTINCT WCYear,[DBN],PEActionStatus,
LEN(PEActionStatus) - LEN(REPLACE(PEActionStatus, '0', '')) AS [Goal1_N_Steps_NotStarted], 
LEN(PEActionStatus) - LEN(REPLACE(PEActionStatus, '1', '')) AS [Goal1_N_Steps_Inprogress], 
LEN(PEActionStatus) - LEN(REPLACE(PEActionStatus, '2', '')) AS [Goal1_N_Steps_Completed], 
LEN(PEActionStatus) - LEN(REPLACE(PEActionStatus, '3', '')) AS [Goal1_N_Steps_Canceled], 
CASE WHEN (LEN(PEActionStatus) - LEN(REPLACE(PEActionStatus, '~', '')))>=1 THEN LEN(PEActionStatus) - LEN(REPLACE(PEActionStatus, '~', ''))+1
ELSE NULL END AS [Goal1_Total_Steps]
FROM [dbo].[SWC_STG_ActionPlan] WHERE [Delete]=0 AND Complete=1 
) GL1 WHERE [Goal1_Total_Steps] IS NOT NULL 
) APGL1 ON (APGL1.[DBN] = WCP.SchoolDBN AND APGL1.WCYear = WCP.SchoolYear)

LEFT JOIN (
SELECT GL2.WCYear,GL2.[DBN],GL2.HEActionStatus,GL2.[Goal2_N_Steps_NotStarted],GL2.[Goal2_N_Steps_Inprogress],GL2.[Goal2_N_Steps_Completed],GL2.[Goal2_N_Steps_Canceled],GL2.[Goal2_Total_Steps] FROM (
SELECT DISTINCT WCYear,[DBN],HEActionStatus,
LEN(HEActionStatus) - LEN(REPLACE(HEActionStatus, '0', '')) AS [Goal2_N_Steps_NotStarted], 
LEN(HEActionStatus) - LEN(REPLACE(HEActionStatus, '1', '')) AS [Goal2_N_Steps_Inprogress], 
LEN(HEActionStatus) - LEN(REPLACE(HEActionStatus, '2', '')) AS [Goal2_N_Steps_Completed], 
LEN(HEActionStatus) - LEN(REPLACE(HEActionStatus, '3', '')) AS [Goal2_N_Steps_Canceled], 
CASE WHEN (LEN(HEActionStatus) - LEN(REPLACE(HEActionStatus, '~', '')))>=1 THEN LEN(HEActionStatus) - LEN(REPLACE(HEActionStatus, '~', ''))+1
ELSE NULL END AS [Goal2_Total_Steps]
FROM [dbo].[SWC_STG_ActionPlan] WHERE [Delete]=0 AND Complete=1 
) GL2 WHERE [Goal2_Total_Steps] IS NOT NULL 
) APGL2 ON (APGL2.[DBN] = WCP.SchoolDBN AND APGL2.WCYear = WCP.SchoolYear)

LEFT JOIN (
SELECT GL3.WCYear,GL3.[DBN],GL3.Other1ActionStatus,GL3.[Goal3_N_Steps_NotStarted],GL3.[Goal3_N_Steps_Inprogress],GL3.[Goal3_N_Steps_Completed],GL3.[Goal3_N_Steps_Canceled],GL3.[Goal3_Total_Steps] FROM (
SELECT DISTINCT WCYear,[DBN],Other1ActionStatus,
LEN(Other1ActionStatus) - LEN(REPLACE(Other1ActionStatus, '0', '')) AS [Goal3_N_Steps_NotStarted], 
LEN(Other1ActionStatus) - LEN(REPLACE(Other1ActionStatus, '1', '')) AS [Goal3_N_Steps_Inprogress], 
LEN(Other1ActionStatus) - LEN(REPLACE(Other1ActionStatus, '2', '')) AS [Goal3_N_Steps_Completed], 
LEN(Other1ActionStatus) - LEN(REPLACE(Other1ActionStatus, '3', '')) AS [Goal3_N_Steps_Canceled], 
CASE WHEN (LEN(Other1ActionStatus) - LEN(REPLACE(Other1ActionStatus, '~', '')))>=1 THEN LEN(Other1ActionStatus) - LEN(REPLACE(Other1ActionStatus, '~', ''))+1
ELSE NULL END AS [Goal3_Total_Steps]
FROM [dbo].[SWC_STG_ActionPlan] WHERE [Delete]=0 AND Complete=1 
) GL3 WHERE [Goal3_Total_Steps] IS NOT NULL 
) APGL3 ON (APGL3.[DBN] = WCP.SchoolDBN AND APGL3.WCYear = WCP.SchoolYear)


LEFT JOIN (
SELECT GL4.WCYear,GL4.[DBN],GL4.Other2ActionStatus,GL4.[Goal4_N_Steps_NotStarted],GL4.[Goal4_N_Steps_Inprogress],GL4.[Goal4_N_Steps_Completed],GL4.[Goal4_N_Steps_Canceled],GL4.[Goal4_Total_Steps] FROM (
SELECT DISTINCT WCYear,[DBN],Other2ActionStatus,
LEN(Other2ActionStatus) - LEN(REPLACE(Other2ActionStatus, '0', '')) AS [Goal4_N_Steps_NotStarted], 
LEN(Other2ActionStatus) - LEN(REPLACE(Other2ActionStatus, '1', '')) AS [Goal4_N_Steps_Inprogress], 
LEN(Other2ActionStatus) - LEN(REPLACE(Other2ActionStatus, '2', '')) AS [Goal4_N_Steps_Completed], 
LEN(Other2ActionStatus) - LEN(REPLACE(Other2ActionStatus, '3', '')) AS [Goal4_N_Steps_Canceled], 
CASE WHEN (LEN(Other2ActionStatus) - LEN(REPLACE(Other2ActionStatus, '~', '')))>=1 THEN LEN(Other2ActionStatus) - LEN(REPLACE(Other2ActionStatus, '~', ''))+1
ELSE NULL END AS [Goal4_Total_Steps]
FROM [dbo].[SWC_STG_ActionPlan] WHERE [Delete]=0 AND Complete=1 
) GL4 WHERE [Goal4_Total_Steps] IS NOT NULL 
) APGL4 ON (APGL4.[DBN] = WCP.SchoolDBN AND APGL4.WCYear = WCP.SchoolYear)

LEFT JOIN (
SELECT GL5.WCYear,GL5.[DBN],GL5.Other3ActionStatus,GL5.[Goal5_N_Steps_NotStarted],GL5.[Goal5_N_Steps_Inprogress],GL5.[Goal5_N_Steps_Completed],GL5.[Goal5_N_Steps_Canceled],GL5.[Goal5_Total_Steps] FROM (
SELECT DISTINCT WCYear,[DBN],Other3ActionStatus,
LEN(Other3ActionStatus) - LEN(REPLACE(Other3ActionStatus, '0', '')) AS [Goal5_N_Steps_NotStarted], 
LEN(Other3ActionStatus) - LEN(REPLACE(Other3ActionStatus, '1', '')) AS [Goal5_N_Steps_Inprogress], 
LEN(Other3ActionStatus) - LEN(REPLACE(Other3ActionStatus, '2', '')) AS [Goal5_N_Steps_Completed], 
LEN(Other3ActionStatus) - LEN(REPLACE(Other3ActionStatus, '3', '')) AS [Goal5_N_Steps_Canceled], 
CASE WHEN (LEN(Other3ActionStatus) - LEN(REPLACE(Other3ActionStatus, '~', '')))>=1 THEN LEN(Other3ActionStatus) - LEN(REPLACE(Other3ActionStatus, '~', ''))+1
ELSE NULL END AS [Goal5_Total_Steps]
FROM [dbo].[SWC_STG_ActionPlan] 
WHERE [Delete]=0 AND Complete=1 
) GL5 WHERE [Goal5_Total_Steps] IS NOT NULL 
) APGL5 ON (APGL5.[DBN] = WCP.SchoolDBN AND APGL5.WCYear = WCP.SchoolYear)

GROUP BY WCP.SchoolYear,WCP.SchoolDBN,WCP.[SWC_ProgramType],TMCY.[SWC_Members_N],
WCS.[Complete],AP.Complete,
BD.Complete,
APGL1.[Goal1_N_Steps_NotStarted],APGL1.[Goal1_N_Steps_Inprogress],APGL1.[Goal1_N_Steps_Completed],APGL1.[Goal1_N_Steps_Canceled],APGL1.[Goal1_Total_Steps],
APGL2.[Goal2_N_Steps_NotStarted],APGL2.[Goal2_N_Steps_Inprogress],APGL2.[Goal2_N_Steps_Completed],APGL2.[Goal2_N_Steps_Canceled],APGL2.[Goal2_Total_Steps],
APGL3.[Goal3_N_Steps_NotStarted],APGL3.[Goal3_N_Steps_Inprogress],APGL3.[Goal3_N_Steps_Completed],APGL3.[Goal3_N_Steps_Canceled],APGL3.[Goal3_Total_Steps],
APGL4.[Goal4_N_Steps_NotStarted],APGL4.[Goal4_N_Steps_Inprogress],APGL4.[Goal4_N_Steps_Completed],APGL4.[Goal4_N_Steps_Canceled],APGL4.[Goal4_Total_Steps],
APGL5.[Goal5_N_Steps_NotStarted],APGL5.[Goal5_N_Steps_Inprogress],APGL5.[Goal5_N_Steps_Completed],APGL5.[Goal5_N_Steps_Canceled],APGL5.[Goal5_Total_Steps],
WCHP.[SWC_Current_Champion_N],COH.ProgramName 
)Z

GROUP BY Z.SchoolYear,Z.SchoolDBN,Z.[SWC_ProgramType],Z.[SWC_Members_N],Z.Total_Resources_N,
Z.ScorecardComplete,Z.ActionPlanComplete,
Z.BudgetComplete,		
Z.[Goal1_N_Steps_NotStarted],Z.[Goal1_N_Steps_InProgress],Z.[Goal1_N_Steps_Completed],Z.[Goal1_N_Steps_Canceled],Z.[Goal1_Total_Steps],
Z.[Goal2_N_Steps_NotStarted],Z.[Goal2_N_Steps_InProgress],Z.[Goal2_N_Steps_Completed],Z.[Goal2_N_Steps_Canceled],Z.[Goal2_Total_Steps],
Z.[Goal3_N_Steps_NotStarted],Z.[Goal3_N_Steps_InProgress],Z.[Goal3_N_Steps_Completed],Z.[Goal3_N_Steps_Canceled],Z.[Goal3_Total_Steps],
Z.[Goal4_N_Steps_NotStarted],Z.[Goal4_N_Steps_InProgress],Z.[Goal4_N_Steps_Completed],Z.[Goal4_N_Steps_Canceled],Z.[Goal4_Total_Steps],
Z.[Goal5_N_Steps_NotStarted],Z.[Goal5_N_Steps_InProgress],Z.[Goal5_N_Steps_Completed],Z.[Goal5_N_Steps_Canceled],Z.[Goal5_Total_Steps],Z.[SWC_Current_Champion_N],Z.[PE_Cohort_Name]
ORDER BY Z.SchoolYear,Z.SchoolDBN


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_SWC_Programs_Activities_Participants]
--Table creation code:
IF OBJECT_ID('[SWHUB_SWC_Programs_Activities_Participants]') IS NOT NULL
	DROP TABLE [SWHUB_SWC_Programs_Activities_Participants]
CREATE TABLE SWHUB_SWC_Programs_Activities_Participants (
	 [SchoolYear] [int] NULL
	,[Program_ID] [numeric](18,0) NULL
	,[ProgramName] [varchar](100) NULL
	,[SchoolDBN] [varchar](6) NULL
	,[SWC_ProgramType] [varchar](100) NULL
	,[SWC_Members_N] [INT] NULL
	,[Total_Resources_N] [INT] NULL
	,[SWC_Current_Champions_N] [INT] NULL
	,[Scorecard_Complete] [varchar](3) NULL
	,[Action_Plan_Complete] [varchar](3) NULL
	,[Budget_Complete] [varchar](3) NULL
	,[Goal1_Total_Steps] [INT] NULL
	,[Goal1_N_Steps_NotStarted] [INT] NULL
	,[Goal1_StepsNotStarted_Percent] [INT] NULL
	,[Goal1_N_Steps_InProgress] [INT] NULL
	,[Goal1_StepsInProgress_Percent] [INT] NULL
	,[Goal1_N_Steps_Canceled] [INT] NULL
	,[Goal1_StepsCanceled_Percent] [INT] NULL
	,[Goal1_N_Steps_Completed] [INT] NULL
	,[Goal1_StepsCompleted_Percent] [INT] NULL	
	
	,[Goal2_Total_Steps] [INT] NULL
	,[Goal2_N_Steps_NotStarted] [INT] NULL
	,[Goal2_StepsNotStarted_Percent] [INT] NULL
	,[Goal2_N_Steps_InProgress] [INT] NULL
	,[Goal2_StepsInProgress_Percent] [INT] NULL
	,[Goal2_N_Steps_Canceled] [INT] NULL
	,[Goal2_StepsCanceled_Percent] [INT] NULL
	,[Goal2_N_Steps_Completed] [INT] NULL
	,[Goal2_StepsCompleted_Percent] [INT] NULL	
	
	,[Goal3_Total_Steps] [INT] NULL
	,[Goal3_N_Steps_NotStarted] [INT] NULL
	,[Goal3_StepsNotStarted_Percent] [INT] NULL
	,[Goal3_N_Steps_InProgress] [INT] NULL
	,[Goal3_StepsInProgress_Percent] [INT] NULL
	,[Goal3_N_Steps_Canceled] [INT] NULL
	,[Goal3_StepsCanceled_Percent] [INT] NULL
	,[Goal3_N_Steps_Completed] [INT] NULL
	,[Goal3_StepsCompleted_Percent] [INT] NULL	
	
	,[Goal4_Total_Steps] [INT] NULL
	,[Goal4_N_Steps_NotStarted] [INT] NULL
	,[Goal4_StepsNotStarted_Percent] [INT] NULL
	,[Goal4_N_Steps_InProgress] [INT] NULL
	,[Goal4_StepsInProgress_Percent] [INT] NULL
	,[Goal4_N_Steps_Canceled] [INT] NULL
	,[Goal4_StepsCanceled_Percent] [INT] NULL
	,[Goal4_N_Steps_Completed] [INT] NULL
	,[Goal4_StepsCompleted_Percent] [INT] NULL	
	
	,[Goal5_Total_Steps] [INT] NULL
	,[Goal5_N_Steps_NotStarted] [INT] NULL
	,[Goal5_StepsNotStarted_Percent] [INT] NULL
	,[Goal5_N_Steps_InProgress] [INT] NULL
	,[Goal5_StepsInProgress_Percent] [INT] NULL
	,[Goal5_N_Steps_Canceled] [INT] NULL
	,[Goal5_StepsCanceled_Percent] [INT] NULL
	,[Goal5_N_Steps_Completed] [INT] NULL
	,[Goal5_StepsCompleted_Percent] [INT] NULL
	,[PE_Cohort_Name] [VARCHAR](50) NULL	
	)

--Created below table for archive but didn't use yet
USE FGR_INT
IF OBJECT_ID('[SWHUB_SWC_Programs_Activities_Participants_Archive]') IS NOT NULL
	DROP TABLE [SWHUB_SWC_Programs_Activities_Participants_Archive]
	CREATE TABLE [dbo].[SWHUB_SWC_Programs_Activities_Participants_Archive](
	[SchoolYear] [int] NULL,
	[Program_ID] [numeric](18, 0) NULL,
	[ProgramName] [varchar](100) NULL,
	[SchoolDBN] [varchar](6) NULL,
	[SWC_ProgramType] [varchar](100) NULL,
	[SWC_Members_N] [int] NULL,
	[Total_Resources_N] [int] NULL,
	[SWC_Current_Champions_N] [int] NULL,
	[Scorecard_Complete] [varchar](3) NULL,
	[Action_Plan_Complete] [varchar](3) NULL,
	[Budget_Complete] [varchar](3) NULL,
	[Goal1_Total_Steps] [int] NULL,
	[Goal1_N_Steps_NotStarted] [int] NULL,
	[Goal1_StepsNotStarted_Percent] [int] NULL,
	[Goal1_N_Steps_InProgress] [int] NULL,
	[Goal1_StepsInProgress_Percent] [int] NULL,
	[Goal1_N_Steps_Canceled] [int] NULL,
	[Goal1_StepsCanceled_Percent] [int] NULL,
	[Goal1_N_Steps_Completed] [int] NULL,
	[Goal1_StepsCompleted_Percent] [int] NULL,
	[Goal2_Total_Steps] [int] NULL,
	[Goal2_N_Steps_NotStarted] [int] NULL,
	[Goal2_StepsNotStarted_Percent] [int] NULL,
	[Goal2_N_Steps_InProgress] [int] NULL,
	[Goal2_StepsInProgress_Percent] [int] NULL,
	[Goal2_N_Steps_Canceled] [int] NULL,
	[Goal2_StepsCanceled_Percent] [int] NULL,
	[Goal2_N_Steps_Completed] [int] NULL,
	[Goal2_StepsCompleted_Percent] [int] NULL,
	[Goal3_Total_Steps] [int] NULL,
	[Goal3_N_Steps_NotStarted] [int] NULL,
	[Goal3_StepsNotStarted_Percent] [int] NULL,
	[Goal3_N_Steps_InProgress] [int] NULL,
	[Goal3_StepsInProgress_Percent] [int] NULL,
	[Goal3_N_Steps_Canceled] [int] NULL,
	[Goal3_StepsCanceled_Percent] [int] NULL,
	[Goal3_N_Steps_Completed] [int] NULL,
	[Goal3_StepsCompleted_Percent] [int] NULL,
	[Goal4_Total_Steps] [int] NULL,
	[Goal4_N_Steps_NotStarted] [int] NULL,
	[Goal4_StepsNotStarted_Percent] [int] NULL,
	[Goal4_N_Steps_InProgress] [int] NULL,
	[Goal4_StepsInProgress_Percent] [int] NULL,
	[Goal4_N_Steps_Canceled] [int] NULL,
	[Goal4_StepsCanceled_Percent] [int] NULL,
	[Goal4_N_Steps_Completed] [int] NULL,
	[Goal4_StepsCompleted_Percent] [int] NULL,
	[Goal5_Total_Steps] [int] NULL,
	[Goal5_N_Steps_NotStarted] [int] NULL,
	[Goal5_StepsNotStarted_Percent] [int] NULL,
	[Goal5_N_Steps_InProgress] [int] NULL,
	[Goal5_StepsInProgress_Percent] [int] NULL,
	[Goal5_N_Steps_Canceled] [int] NULL,
	[Goal5_StepsCanceled_Percent] [int] NULL,
	[Goal5_N_Steps_Completed] [int] NULL,
	[Goal5_StepsCompleted_Percent] [int] NULL,
	[PE_Cohort_Name] [varchar](100) NULL
) 


--Variables for this Package:

Name			Scope										Data type			Value
PackageID		Package 09_Get SWC Summary Data 			Int32				9


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
VALUES (9,'Package 09_Get SWC Summary Data')