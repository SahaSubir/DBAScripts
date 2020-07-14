--Sequence Container for Employee Certificate
--EST_Cleanup Staging table
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
Delete From [dbo].[ISS_Emp_Certs_Staging]

--DFT_Certificate Records From DB2 to Staging Table
--OLE DB Source
--OLEDB Connection Manager: PDB1.summerp
--Data access mode: Table or view
--Name of the table or view: RS1P1.WELL_ACT_CERTS

--Data Conversion:
Input Column		Output Alias				Data Type			Length
[PMS]				Copy of PMS					string [DT_STR]		7
[CERTCD1]			Copy of CERTCD1				string [DT_STR]		4
[CERT_DESCR1]		Copy of CERT_DESCR1			string [DT_STR]		45
[CERTCD2]			Copy of CERTCD2				string [DT_STR]		4
[CERT_DESCR2]		Copy of CERT_DESCR2			string [DT_STR]		45
[CERTCD3]			Copy of CERTCD3				string [DT_STR]		4
[CERT_DESCR3]		Copy of CERT_DESCR3			string [DT_STR]		45
[CERTCD4]			Copy of CERTCD4				string [DT_STR]		4
[CERT_DESCR4]		Copy of CERT_DESCR4			string [DT_STR]		45
[CERTCD5]			Copy of CERTCD5				string [DT_STR]		4
[CERT_DESCR5]		Copy of CERT_DESCR5			string [DT_STR]		45
[CERTCD6]			Copy of CERTCD6				string [DT_STR]		4
[CERT_DESCR6]		Copy of CERT_DESCR6			string [DT_STR]		45
[CERTCD7]			Copy of CERTCD7				string [DT_STR]		4
[CERT_DESCR7]		Copy of CERT_DESCR7			string [DT_STR]		45
[CERTCD8]			Copy of CERTCD8				string [DT_STR]		4
[CERT_DESCR8]		Copy of CERT_DESCR8			string [DT_STR]		45

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_Emp_Certs_Staging]
--Table creation code:

CREATE TABLE [dbo].[ISS_Emp_Certs_Staging](
	[PMS] [varchar](15) NULL,
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
	[CERT_ID_DESC8] [varchar](500) NULL
) ON [PRIMARY]

GO


--EST_Cleanup ISS_Emp_Certs Table
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
Delete From [dbo].[ISS_Emp_Certs]


--DFT_Load Certs data to Main table from Staging table
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view
--Name of the table or view: [ISS_Emp_Certs_Staging]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_Emp_Certs]
--Table creation code:

CREATE TABLE [dbo].[ISS_Emp_Certs](
	[PMS] [varchar](15) NULL,
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
	[CERT_ID_DESC8] [varchar](500) NULL
) ON [PRIMARY]

GO

--Sequence Container for Employee License
--EST_Cleanup Staging table
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
Delete From [dbo].[ISS_Emp_Licenses_Staging]

--DFT_Load License Records From DB2 to Staging Table
--OLE DB Source
--OLEDB Connection Manager: PDB1.summerp
--Data access mode: Table or view
--Name of the table or view: RS1P1.WELL_ACT_LICENSE

--Data Conversion:
Input Column		Output Alias				Data Type			Length
[PMS]				Copy of PMS					string [DT_STR]		7
[LICENSE1]			Copy of LICENSE1			string [DT_STR]		4
[LICENSE1_DESC]		Copy of LICENSE1_DESC		string [DT_STR]		35
[LICENSE2]			Copy of LICENSE2			string [DT_STR]		4
[LICENSE2_DESC]		Copy of LICENSE2_DESC		string [DT_STR]		35
[LICENSE3]			Copy of LICENSE3			string [DT_STR]		4
[LICENSE3_DESC]		Copy of LICENSE3_DESC		string [DT_STR]		35
[LICENSE4]			Copy of LICENSE4			string [DT_STR]		4
[LICENSE4_DESC]		Copy of LICENSE4_DESC		string [DT_STR]		35
[LICENSE5]			Copy of LICENSE5			string [DT_STR]		4
[LICENSE5_DESC]		Copy of LICENSE5_DESC		string [DT_STR]		35
[LICENSE6]			Copy of LICENSE6			string [DT_STR]		4
[LICENSE6_DESC]		Copy of LICENSE6_DESC		string [DT_STR]		35
[LICENSE7]			Copy of LICENSE7			string [DT_STR]		4
[LICENSE7_DESC]		Copy of LICENSE7_DESC		string [DT_STR]		35
[LICENSE8]			Copy of LICENSE8			string [DT_STR]		4
[LICENSE8_DESC]		Copy of LICENSE8_DESC		string [DT_STR]		35

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_Emp_Licenses_Staging]
--Table creation code:
CREATE TABLE [dbo].[ISS_Emp_Licenses_Staging](
	[PMS] [varchar](15) NULL,
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
	[License_Desc8] [varchar](500) NULL
) ON [PRIMARY]

GO

--EST_Cleanup ISS_Emp_License Table
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
Delete From [dbo].[ISS_Emp_Licenses]


--DFT_Load License data to Main table from Staging table
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view
--Name of the table or view: [ISS_Emp_Licenses_Staging]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_Emp_Licenses]
--Table creation code:
CREATE TABLE [dbo].[ISS_Emp_Licenses](
	[PMS] [varchar](15) NULL,
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
	[License_Desc8] [varchar](500) NULL
) ON [PRIMARY]

GO


--Variables for this Package:

Name			Scope																	Data type			Value
PackageID		Package 18_Load Emp Certificate and License Records from DB2 			Int32				18


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
VALUES (18,'Package 18_Load Emp Certificate and License Records from DB2')


