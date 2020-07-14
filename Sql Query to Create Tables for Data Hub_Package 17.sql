--EST_Cleanup ISS_TblPersonalInfo_Hub Interface in ISS_EXT
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
Delete From [dbo].[ISS_tblPersonalInfo_Hub_Interface]

--DFT_Load Active EMP data From DB2 to ISS_TblPersonalInfo_Hub Interface Table
--OLE DB Source
--OLEDB Connection Manager: PDB1.summerp
--Data access mode: Table or view
--Name of the table or view: ES1P1.DOE_ACTIVE_STAFF

--Data Conversion:
Input Column		Output Alias				Data Type			Length
[PMS]				Copy of PMS					string [DT_STR]		7
[EISID]				Copy of EISID				string [DT_STR]		7
[LastName]			Copy of LastName			string [DT_STR]		15
[FirstName]			Copy of FirstName			string [DT_STR]		14
[DBN]				Copy of DBN					string [DT_STR]		6
[Title1]			Copy of Title1				string [DT_STR]		5
[Title_DESCR]		Copy of Title_DESCR			string [DT_STR]		30
[License]			Copy of License				string [DT_STR]		4
[License_DESCR]		Copy of License_DESCR		string [DT_STR]		35
[Central_FLAG]		Copy of Central_FLAG		string [DT_STR]		1
[DBN_ALL]			Copy of DBN_ALL				string [DT_STR]		34
[GENDER]			Copy of GENDER				string [DT_STR]		1
[SENIORITY_YY]		Copy of SENIORITY_YY		string [DT_STR]		2
[SENIORITY_MM]		Copy of SENIORITY_MM		string [DT_STR]		2
[DOE_START_DATE]	Copy of DOE_START_DATE		string [DT_STR]		10
[ASSIGNMENT_CODE]	Copy of ASSIGNMENT_CODE		string [DT_STR]		4
[ASSIGNMENT_DESCR]	Copy of ASSIGNMENT_DESCR	string [DT_STR]		35
[DOB]				Copy of DOB					string [DT_STR]		10
[SSN]				Copy of SSN					string [DT_STR]		4

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_tblPersonalInfo_Hub_Interface]
--Table creation code:

CREATE TABLE [dbo].[ISS_tblPersonalInfo_Hub_Interface](
	[sEmployeeNo] [char](10) NULL,
	[sEISId] [char](7) NULL,
	[sName] [varchar](100) NULL,
	[sSchoolDBN] [char](6) NULL,
	[sEmpStatus] [char](1) NULL,
	[sTitleCode] [char](5) NULL,
	[sTitleDesc] [varchar](100) NULL,
	[sLicenceCode] [char](5) NULL,
	[sLicenceDesc] [varchar](100) NULL,
	[sOtherDBNs] [varchar](100) NULL,
	[Is_Primary_Location] [char](1) NULL,
	[Central_Inst_Flag] [char](1) NULL,
	[dtLastUpdatedDate] [datetime] NULL,
	[sLastUpdatedBy] [varchar](50) NULL,
	[sChangeOfSource] [char](1) NULL,
	[sLastName] [varchar](100) NULL,
	[sFirstName] [varchar](100) NULL
) ON [PRIMARY]
SET ANSI_PADDING ON
ALTER TABLE [dbo].[ISS_tblPersonalInfo_Hub_Interface] ADD [Gender] [char](1) NULL
ALTER TABLE [dbo].[ISS_tblPersonalInfo_Hub_Interface] ADD [Seniority_YY] [char](3) NULL
ALTER TABLE [dbo].[ISS_tblPersonalInfo_Hub_Interface] ADD [Seniority_MM] [char](3) NULL
ALTER TABLE [dbo].[ISS_tblPersonalInfo_Hub_Interface] ADD [DOE_Start_Date] [varchar](15) NULL
ALTER TABLE [dbo].[ISS_tblPersonalInfo_Hub_Interface] ADD [Assignment_Code] [varchar](15) NULL
ALTER TABLE [dbo].[ISS_tblPersonalInfo_Hub_Interface] ADD [Assignment_Desc] [varchar](300) NULL
ALTER TABLE [dbo].[ISS_tblPersonalInfo_Hub_Interface] ADD [SSN] [varchar](20) NULL
ALTER TABLE [dbo].[ISS_tblPersonalInfo_Hub_Interface] ADD [DOB] [varchar](20) NULL
ALTER TABLE [dbo].[ISS_tblPersonalInfo_Hub_Interface] ADD [sReason_Code] [char](3) NULL
ALTER TABLE [dbo].[ISS_tblPersonalInfo_Hub_Interface] ADD [sReason_Desc] [varchar](150) NULL
ALTER TABLE [dbo].[ISS_tblPersonalInfo_Hub_Interface] ADD [sPMS_Status] [varchar](150) NULL

GO

Note: Ignore [sName],,[sEmpStatus],[Is_Primary_Location],[dtLastUpdateDate],[dtLastUpdateBy],[sChangeOfSource],[sReason_Code],[sReasone_Desc],[sPMS_Status] for mapping


--EST_Cleanup ISS_tblDB2_DOE_Inactive_Staff _Staging in ISS_EXT 1
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
DELETE FROM [dbo].[ISS_tblDB2_DOE_INACTIVE_STAFF_Staging]

--DFT_Load Inactive EMP data From DB2 to ISS_tblDB2_DOE_Inactive_Staff Table
--OLE DB Source
--OLEDB Connection Manager: PDB1.summerp
--Data access mode: Table or view
--Name of the table or view: [RS1P1.DOE_INACTIVE_STAFF]

--Data Conversion:
Input Column		Output Alias				Data Type			Length
[PMS]				Copy of PMS					string [DT_STR]		7
[EISID]				Copy of EISID				string [DT_STR]		7
[LastName]			Copy of LastName			string [DT_STR]		15
[FirstName]			Copy of FirstName			string [DT_STR]		14
[DBN]				Copy of DBN					string [DT_STR]		6
[Title1]			Copy of Title1				string [DT_STR]		5
[Title_DESCR]		Copy of Title_DESCR			string [DT_STR]		30
[License]			Copy of License				string [DT_STR]		4
[License_DESCR]		Copy of License_DESCR		string [DT_STR]		35
[Central_FLAG]		Copy of Central_FLAG		string [DT_STR]		1
[DBN_ALL]			Copy of DBN_ALL				string [DT_STR]		34
[GENDER]			Copy of GENDER				string [DT_STR]		1
[SENIORITY_YY]		Copy of SENIORITY_YY		string [DT_STR]		2
[SENIORITY_MM]		Copy of SENIORITY_MM		string [DT_STR]		2
[DOE_START_DATE]	Copy of DOE_START_DATE		string [DT_STR]		10
[ASSIGNMENT_CODE]	Copy of ASSIGNMENT_CODE		string [DT_STR]		4
[ASSIGNMENT_DESCR]	Copy of ASSIGNMENT_DESCR	string [DT_STR]		35
[DOB]				Copy of DOB					string [DT_STR]		10
[SSN]				Copy of SSN					string [DT_STR]		4
[REASON_CODE]		Copy of REASON_CODE			string [DT_STR]		3
[PMS_STATUS]		Copy of PMS_STATUS			string [DT_STR]		3


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_tblDB2_DOE_Inactive_Staff_Staging]
--Table creation code:
CREATE TABLE [dbo].[ISS_tblDB2_DOE_Inactive_Staff_Staging](
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
	[SSN] [varchar](20) NULL,
	[DOB] [varchar](20) NULL,
	[sReason_Code] [char](3) NULL,
	[sReason_Desc] [varchar](150) NULL,
	[sPMS_Status] [varchar](150) NULL
) ON [PRIMARY]

GO
Note: Ignore [dtLastUpdateDate],[dtLastUpdateBy],[sChangeOfSource],[sTitleCode_EIS] for mapping


--EST_Cleanup ISS_TblPersonalInfo_Gxy Interface Table in ISS_EXT
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
Delete from dbo.ISS_tblPersonalInfo_Gxy_Interface


--DFT_Get all records from ISS_TblPersonalInfo_Hub Interface table to ISS_TblPersonalInfo_Gxy Interfacetable
--OLE DB Source
--OLEDB Connection Manager: PDB1.summerp
--Data access mode: Table or view
--Name of the table or view: [ISS_tblPersonalInfo_Hub_Interface]

--Data Conversion:
Input Column		Output Alias				Data Type			Length
[sLastName]			sLastName_Convert			string [DT_STR]		50
[sFirstName]		sFirstName_Convert			string [DT_STR]		50


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_tblPersonalInfo_Gxy_Interface]
--Table creation code:

Note: Ignore [sName],[sTitleCode_EIS] for mapping


--EST_Update already existing records if any changes took place since last upload
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
--Step 5 - Now start updating already existing records if any changes took place since last upload - Process only Active people
--But no duplicates


UPDATE ISS_tblPersonalInfo_Gxy_Interface SET Central_Inst_flag= CASE Central_Inst_flag WHEN 'Y' THEN 'C' ELSE 'I' END, Is_Primary_Location='Y',[sEmpStatus]='A',dtLastUpdatedDate=getdate()

--first update only central staff and null
UPDATE c
	SET c.sLastUpdatedBy='HR HUB-ISS Autoprocess C - Update',
		c.dtLastUpdatedDate=getdate(),
		c.sChangeOfSource='G',
		c.Central_Inst_flag=a.Central_Inst_flag
	FROM dbo.ISS_tblPersonalInfo c 
	INNER JOIN dbo.ISS_tblPersonalInfo_Gxy_Interface a ON a.sEmployeeNo=c.sEmployeeNo
	WHERE ((c.Central_Inst_flag IS NULL) AND (a.Central_Inst_flag='C'))

--second update only instructional and null
UPDATE c
	SET c.sLastUpdatedBy='HR HUB-ISS Autoprocess C - Update',
		c.dtLastUpdatedDate=getdate(),
		c.sChangeOfSource='G',
		c.Central_Inst_flag=a.Central_Inst_flag
	FROM dbo.ISS_tblPersonalInfo c 
	INNER JOIN dbo.ISS_tblPersonalInfo_Gxy_Interface a ON a.sEmployeeNo=c.sEmployeeNo
	WHERE ((c.Central_Inst_flag IS NULL) AND (a.Central_Inst_flag='I'))

--third
UPDATE c
	SET c.sLastName=a.sLastName,
		c.sFirstName=a.sFirstName,
		c.sEISId=a.sEISId,
		c.sTitleCode_Gxy=a.sTitleCode_Gxy,		
		c.sTitleDesc_Gxy=a.sTitleDesc_Gxy,
		c.sSchoolDBN=a.sSchoolDBN,
		c.Is_Primary_Location=a.Is_Primary_Location,
		c.sEmpStatus=a.sEmpStatus,
		c.Central_Inst_flag=a.Central_Inst_flag,
		c.sLastUpdatedBy='HR HUB-ISS AutoprocessNCI - Update',
		c.dtLastUpdatedDate=getdate(),
		c.sChangeOfSource='G',
		c.[sLicenceCode]=a.[sLicenceCode],
		c.[sLicenceDesc]=a.[sLicenceDesc],
		c.[sOtherDBNs]=a.[sOtherDBNs],
		c.Gender=a.Gender,
		c.[Seniority_YY]=a.[Seniority_YY],
		c.[Seniority_MM]=a.[Seniority_MM],
		c.[DOE_Start_Date]=a.[DOE_Start_Date],
		c.[Assignment_Code]=a.[Assignment_Code],
		c.[Assignment_Desc]=a.[Assignment_Desc],
		c.[SSN]=a.[SSN],
		C.[DOB]=a.[DOB],
		C.[sReason_Code]=a.[sReason_Code],
		C.[sReason_Desc]=a.[sReason_Desc],
		C.[sPMS_Status]=a.[sPMS_Status]
FROM dbo.ISS_tblPersonalInfo c 
INNER JOIN dbo.ISS_tblPersonalInfo_Gxy_Interface a ON a.sEmployeeNo=c.sEmployeeNo
WHERE (c.sLastName<>a.sLastName OR c.sFirstName<>a.sFirstName)
			OR c.sEISId<>a.sEISId
			OR c.sTitleCode_Gxy<>a.sTitleCode_Gxy			
			OR c.sSchoolDBN<>a.sSchoolDBN
			OR isnull(c.[sLicenceCode],'')<>isnull(a.[sLicenceCode],'')			
			OR c.Central_Inst_flag<>a.Central_Inst_flag
			OR c.sEmpStatus<>a.sEmpStatus
			OR isnull(c.[Seniority_YY],'')<>isnull(a.[Seniority_YY],'')
			OR isnull(c.[Seniority_MM],'')<>isnull(a.[Seniority_MM],'')
			OR isnull(c.[DOE_Start_Date],'')<>isnull(a.[DOE_Start_Date],'')
			OR isnull(c.[Assignment_Code],'')<>isnull(a.[Assignment_Code],'')
			OR isnull(c.[Assignment_Desc],'')<>isnull(a.[Assignment_Desc],'')
			OR isnull(c.[sOtherDBNs],'')<>isnull(a.[sOtherDBNs],'')
			OR isnull(c.[SSN],'')<>isnull(a.[SSN],'')
			OR isnull(c.[DOB],'')<>isnull(a.[DOB],'')
			OR isnull(c.[sReason_Code],'')<>isnull(a.[sReason_Code],'')
			OR isnull(c.[sReason_Desc],'')<>isnull(a.[sReason_Desc],'')
			OR isnull(c.[sPMS_Status],'')<>isnull(a.[sPMS_Status],'')

--EST_Copy new records to ISS_tblPersonalInfo Table
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
INSERT INTO [dbo].[ISS_tblPersonalInfo]
           ([sEmployeeNo],[sEISId] ,[sLastName] ,[sFirstName]
           ,[sSchoolDBN],[sEmpStatus],[sTitleCode_Gxy],[sTitleDesc_Gxy]
           ,[Is_Primary_Location] ,[Central_Inst_Flag],[sLastUpdatedBy]
           ,[dtLastUpdatedDate]           
           ,[sChangeOfSource]
           ,[sLicenceCode],[sLicenceDesc],[sOtherDBNs],Gender
		   ,[Seniority_YY],[Seniority_MM],[DOE_Start_Date],[Assignment_Code],[Assignment_Desc],[SSN],[DOB])
    
           (SELECT G.sEmployeeNo,G.sEISId,G.sLastName,G.sFirstName,G.[sSchoolDBN],G.[sEmpStatus],G.[sTitleCode_Gxy],G.[sTitleDesc_Gxy]
		   ,G.[Is_Primary_Location] ,G.[Central_Inst_Flag]
		   ,'HR-HUB-ISS Autoprocess',getdate(),'G',G.[sLicenceCode],G.[sLicenceDesc],G.[sOtherDBNs],G.Gender
		   ,G.[Seniority_YY],G.[Seniority_MM],G.[DOE_Start_Date],G.[Assignment_Code],G.[Assignment_Desc],G.[SSN],G.[DOB]	
			FROM dbo.ISS_tblPersonalInfo_Gxy_Interface	G
			Left Outer Join dbo.ISS_tblPersonalInfo c on G.sEmployeeNo=c.sEmployeeNo	
			WHERE c.sEmployeeNo  is null)
GO


--EST_Update Employee table to cleanup the records exist in ISS_EXT but not in HR HUB
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
GO

--Step7, 
--Execute T-SQL - Update ISS_tblPersonalInfo table to make 'R' for the people exist in ISS but not in HR HUB
UPDATE b
 SET b.sEmpStatus='R',
  b.Is_primary_location='N',
  b.sLastUpdatedBy='WT Autoprocess - Not In HR HUB',
  b.dtLastUpdatedDate=getdate()
 FROM dbo.ISS_tblPersonalInfo b
 Left Outer Join dbo.ISS_tblPersonalInfo_Gxy_Interface x ON b.sEmployeeNo=x.sEmployeeNo
WHERE b.sEmpStatus<>'R' AND b.sChangeOfSource='G'
AND x.sEmployeeNo is null


-- Update  emp status from AD table
Update P
SET P.sEmpStatus= CASE When G.[bIsActive]='A' THEN 'A' ELSE 'R' END 

FROM [dbo].[ISS_tblPersonalInfo] P
Inner join [dbo].[ISS_tblADUsers] G ON P.sEmployeeNo=G.sEmployeeNo
Where P.sEmpStatus is null


-- Update  emp status to 'R' if any nulls left 

Update  [dbo].[ISS_tblPersonalInfo]  SET sEmpStatus='R' where sEmpStatus is null

GO


--EST_Update ISS_tblPersonalInfo table by sReason_Code, Description and sPMS_Status from ISS_tblDB2_DOE_Inactive_Staff table
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
--Update ISS_tblPersonalInfo by sReason_Code and sPMS_Status from ISS_tblDB2_DOE_Inactive_Staff table

UPDATE c
	SET c.[sReason_Code]=a.[sReason_Code],
		c.[sReason_Desc]=a.[sReason_Desc],
		c.[sPMS_Status]=a.[sPMS_Status]
		FROM dbo.ISS_tblPersonalInfo c 
	INNER JOIN [dbo].[ISS_tblDB2_DOE_Inactive_Staff_Staging] a ON c.sEmployeeNo=a.sEmployeeNo AND c.sEmpStatus='R'



--Variables for this Package:

Name			Scope														Data type			Value
PackageID		Package 17_Load HR Personal Info Records from DB2 			Int32				17


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
VALUES (17,'Package 17_Load HR Personal Info Records from DB2')


