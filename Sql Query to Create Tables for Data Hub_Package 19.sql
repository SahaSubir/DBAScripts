--EST_Cleanup AD staging table
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
DELETE FROM ISS_tblActive_Directory_Interface

--DFT_Load AD records into Staging Table
--OLE DB Source
--OLEDB Connection Manager: ES11VDSTARSQL01.Active_Directory.OSWPUser
--Data access mode: SQL Command
--SQL Command text: 
SELECT
[cn],
[sn],
[givenName],
[title],
[department],
[mail],
[mailNickname],
[manager],
[telephoneNumber],
[streetAddress],
[st],
[postalCode],
[facsimileTelephoneNumber],
[mobile],
[pager],
[distinguishedName],
[samAccountName],
[UserCertificate],
[AccountStatus],
[employeeID],
'N' as sProcessStatus,
getdate() as dtLastUpdated
FROM dbo.Active_Data where [samAccountName] is not null and UPPER([AccountStatus]) = 'ACTIVE' and [employeeID] is not null


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_tblActive_Directory_Interface]
--Table creation code:

CREATE TABLE [dbo].[ISS_tblActive_Directory_Interface](
	[cn] [nvarchar](500) NULL,
	[sn] [nvarchar](500) NULL,
	[givenName] [nvarchar](256) NULL,
	[title] [nvarchar](256) NULL,
	[department] [nvarchar](256) NULL,
	[mail] [nvarchar](256) NULL,
	[mailNickname] [nvarchar](256) NULL,
	[manager] [nvarchar](256) NULL,
	[telephoneNumber] [nvarchar](256) NULL,
	[streetAddress] [nvarchar](256) NULL,
	[st] [nvarchar](256) NULL,
	[postalCode] [nvarchar](256) NULL,
	[facsimileTelephoneNumber] [nvarchar](256) NULL,
	[mobile] [nvarchar](256) NULL,
	[pager] [nvarchar](256) NULL,
	[distinguishedName] [nvarchar](256) NOT NULL,
	[samAccountName] [varchar](50) NULL,
	[UserCertificate] [bit] NULL,
	[AccountStatus] [nvarchar](50) NULL,
	[employeeID] [varchar](50) NULL,
	[sProcessStatus] [char](1) NULL,
	[dtLastUpdated] [datetime] NULL
) ON [PRIMARY]

GO


--EST_Cleanup AD Main Table
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
Delete from dbo.ISS_tblADUsers

--Execute SQL Task
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
INSERT INTO ISS_tbl_Emp_Staging( [employeeID])
SELECT tmp.[employeeID] FROM dbo.ISS_tblActive_Directory_Interface tmp GROUP BY tmp.[employeeID] HAVING COUNT(tmp.[employeeID])>1

--DFT_EST_Insert new records into ISS_tblADUsers who are new and no duplicates
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL Command text: 
SELECT
	a.[samAccountName],a.[employeeID],a.[sn],a.[givenName],a.[mail],
	CASE a.[accountStatus] WHEN 'Active' THEN 'A' ELSE 'I' END AS sActive,
	'AD - Autoprocess - Insert new' AS sLastUpdatedBy,getdate() as dtLastUpdated
FROM dbo.ISS_tblActive_Directory_Interface a 
Left Outer Join ISS_tbl_Emp_Staging E On a.employeeID=E.employeeID
WHERE a.sProcessStatus='N' and a.[employeeID] is not null and a.mail is not null
AND E.employeeID is null Order by a.employeeID

--Data Conversion:
Input Column		Output Alias				Data Type			Length
[mail]				mail_Convert				string [DT_STR]		100
[sn]				sn_Convert					string [DT_STR]		100
[givenName]			givenName_Convert			string [DT_STR]		100
[employeeID]		employeeID_Convert			string [DT_STR]		20
[samAccountName]	samAccountName_Convert		string [DT_STR]		20

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_tblADUsers]
--Table creation code:

CREATE TABLE [dbo].[ISS_tblADUsers](
	[sUserID] [varchar](20) NOT NULL,
	[sEmployeeNo] [varchar](20) NULL,
	[sEmail] [varchar](100) NULL,
	[sLastName] [varchar](100) NULL,
	[sFirstName] [varchar](100) NULL,
	[bIsActive] [char](1) NULL,
	[sLastUpdatedBy] [varchar](50) NULL,
	[dtLastUpdatedDate] [datetime] NULL,
	[sChangeOfSource] [char](1) NULL
) ON [PRIMARY]

GO

Note: Ignore [sChangeOfSource] for mapping


--EST_Insert active records into ISS_tblADUsers who have duplicates
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
INSERT INTO dbo.ISS_tblADUsers(sUserID,sEmployeeNo,sLastName,sFirstName,sEmail,bIsActive,sLastUpdatedBy,dtLastUpdatedDate)
SELECT	a.[samAccountName],a.[employeeID],a.[sn],a.[givenName],a.[mail],
	CASE a.[accountStatus] WHEN 'Active' THEN 'A' ELSE 'I' END AS sActive,
	'AD - Autoprocess - Insert new' AS sLastUpdatedBy,getdate() as dtLastUpdated
FROM dbo.ISS_tblActive_Directory_Interface a 
Left Outer Join dbo.ISS_tblADUsers U ON a.[samAccountName] = U.sUserID
WHERE a.sProcessStatus='N' and a.[employeeID] is not null and a.mail is not null
	and a.[accountStatus] ='Active' AND U.sUserID is null

--Execute SQL Task 1
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
DELETE FROM ISS_tbl_Emp_Staging
GO


--Variables for this Package:

Name			Scope																	Data type			Value
PackageID		Package 19_Load Emp Records from Active Directory			 			Int32				19


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
VALUES (19,'Package 19_Load Emp Records from Active Directory')


