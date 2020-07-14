\--Sequence Container
--EST_Delete from SWHUB_FG_SchoolCompletionReport
Connection: ES11VDEXTESQL01 FGR_INT FGRepUser
SQL Statement:
TRUNCATE TABLE [SWHUB_FG_SchoolCompletionReport]
GO

--DFT_SWHUB_FG_SchoolCompletionReport
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FITNESSGRAM.FGUser
--Data access mode: SQL Command
--SQL Command text: 
USE FITNESSGRAM
DECLARE @TestID INT
SELECT @TestID = TestId FROM FG_Test WHERE GETDATE() BETWEEN StartDate AND EndDate

SELECT 
(a.Fiscal_Year-1) AS nSchool_Year, 
b.TestID AS nTestID,
CAST(a.System_Code AS VARCHAR(6)) AS [sSchool_DBN], 
a.Location_Type_Description, 
a.Location_Category_Description,
a.Superintendent,
b.[nTotal_Students],
b.[nNoOfStudents_Exempted],
b.[nNoOfStudents_Eligible],
b.[nNoOfStudents_CompletedAssessments],
b.[nNoOfStudents_Remaining],
GETDATE() AS [DataPulledDate]
--into ##tt
FROM (
SELECT 
System_Code,
Fiscal_Year,
System_ID,
Location_Name,
Location_Type_Description,
Location_Category_Description,
[Community_School_Sup_Name],
HighSchool_Network_Superintendent,
(CASE  WHEN (ISNULL(Location_Category_Description, '') = 'Early Childhood' OR
			ISNULL(Location_Category_Description, '') = 'Elementary' OR
			ISNULL(Location_Category_Description, '') = 'Junior High-Intermediate-Middle' OR
			ISNULL(Location_Category_Description, '') = 'K-8') THEN Community_School_Sup_Name 
	  WHEN (ISNULL(Location_Category_Description, '') = 'Collaborative or Multi-graded' OR ISNULL(Location_Category_Description, '') = 'Ungraded') THEN '' 
	  WHEN (ISNULL(Location_Category_Description, '') = 'High school')  OR (ISNULL(Location_Category_Description, '') = 'Secondary School' OR ISNULL(Location_Category_Description, '') = 'K-12 all grades') THEN 
			CASE WHEN (ISNULL(HighSchool_Network_Superintendent, '') = '') THEN Community_School_Sup_Name ELSE HighSchool_Network_Superintendent END 
END
) AS Superintendent, 
Administrative_District_Code,
Principal_Email,
Status_Code,
Grades_Text,
Learning_Community_Name 
FROM  SUPERLINK.Supertable.dbo.Location_Supertable1 
WHERE       Fiscal_Year = CASE WHEN month(getdate()) >= '07' THEN year(getdate()) + 1 ELSE year(getdate()) END 
        AND System_ID = 'ats' 
        AND Status_Code='O'
		AND Administrative_District_Code IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') 
        AND Location_Type_Description<>'Home School' 
        AND Location_Category_Description<>'Borough' 
        AND Location_Category_Description<>'Central-HQ-Citywide' 
        AND Location_Name <> 'Universal Pre-K C.B.O.'
        AND Location_Type_Description <>'Adult'
        AND Location_Type_Description <>'Alternative'
        AND Location_Type_Description <>'Evening'
        AND Location_Type_Description <>'Suspension Center'
        AND Location_Type_Description <>'YABC'
        AND Grades_Text <>''
		AND Location_Name NOT LIKE '%Hospital Schools%'
		AND Learning_Community_Name='School'

)a
INNER JOIN 
(SELECT SchoolDBN,TestId,TotalCount AS [nTotal_Students],FgExemptionCount AS [nNoOfStudents_Exempted],
(Totalcount-FgExemptionCount) AS [nNoOfStudents_Eligible],
Completedcount AS [nNoOfStudents_CompletedAssessments],
((TotalCount-FgExemptionCount)-CompletedCount)AS [nNoOfStudents_Remaining],
LastModifiedDate 
FROM fg_SchoolCompletionReport  WHERE TestID=@TestID
)b ON a.System_Code=b.SchoolDBN


--Data Conversion:
Input Column		Output Alias			Data Type					Length
[sSchool_DBN]		sSchool_DBN_Convert		string [DT_STR]				6


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_FG_SchoolCompletionReport]
--Table creation code:
CREATE TABLE [dbo].[SWHUB_FG_SchoolCompletionReport](
	[nSchool_Year] [int] NOT NULL,
	[nTestID] [int] NOT NULL,
	[sSchool_DBN] [varchar](6) NOT NULL,
	[sLocation_Type_Description] [varchar](100) NULL,
	[sLocation_Category_Description] [varchar](100) NULL,
	[sSuperintendent] [varchar](100) NULL,
	[nTotal_Students] [int] NULL,
	[nNoOfStudents_Exempted] [int] NULL,
	[nNoOfStudents_Eligible] [int] NULL,
	[nNoOfStudents_CompletedAssessments] [int] NULL,
	[nNoOfStudents_Remaining] [int] NULL,
	[DataPulledDate] [datetime] NULL,
 CONSTRAINT [PK_SWHUB_FG_SchoolCompletionReport] PRIMARY KEY CLUSTERED 
(
	[nSchool_Year] ASC,
	[sSchool_DBN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

--EST_Delete from SWHUB_FG_SchoolCompletionReport_Archive
Connection: ES11VDEXTESQL01 FGR_INT FGRepUser
SQL Statement:
DELETE [dbo].[SWHUB_FG_SchoolCompletionReport_Archive] FROM [dbo].[SWHUB_FG_SchoolCompletionReport_Archive] SCA 
INNER JOIN [SWHUB_FG_SchoolCompletionReport] SC ON (SCA.NTestId = SC.NTestId AND SCA.[sSchool_DBN] = SC.[sSchool_DBN])

--DFT_SWHUB_FG_SchoolCompletionReport_Archive
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view
--Name of the table or view: [SWHUB_FG_SchoolCompletionReport]


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_FG_SchoolCompletionReport_Archive]
--Table creation code:
CREATE TABLE [dbo].[SWHUB_FG_SchoolCompletionReport_Archive](
	[nSchool_Year] [int] NOT NULL,
	[nTestID] [int] NOT NULL,
	[sSchool_DBN] [varchar](6) NOT NULL,
	[sLocation_Type_Description] [varchar](100) NULL,
	[sLocation_Category_Description] [varchar](100) NULL,
	[sSuperintendent] [varchar](100) NULL,
	[nTotal_Students] [int] NULL,
	[nNoOfStudents_Exempted] [int] NULL,
	[nNoOfStudents_Eligible] [int] NULL,
	[nNoOfStudents_CompletedAssessments] [int] NULL,
	[nNoOfStudents_Remaining] [int] NULL,
	[DataPulledDate] [datetime] NULL,
 CONSTRAINT [PK_SWHUB_FG_SchoolCompletionReport_Archive] PRIMARY KEY CLUSTERED 
(
	[nSchool_Year] ASC,
	[sSchool_DBN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


--Variables for this Package:

Name			Scope											Data type			Value
PackageID		Package 16_FG_SchoolCompletionReport 			Int32				16


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
VALUES (16,'Package 16_FG_SchoolCompletionReport')


