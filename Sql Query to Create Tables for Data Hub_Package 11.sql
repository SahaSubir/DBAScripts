--EST_Delete Destination Table Records
Connection: ES11VDEXTESQL01 FGR_INT FGRepUser
SQL Statement:
TRUNCATE TABLE [SWHUB_TblOrganizationData]
GO

--DFT_SWHUB_TblOrganizationData
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL Command text: 
SELECT 
        RL.Id,
        RL.Name,
        RL.DBN,
        RL.WCCtgryId,
        STUFF(
        (
        SELECT ',' +  D.[Type] AS [text()]
        FROM  (
                        SELECT A.[id],  
                                        Split.a.value('.', 'VARCHAR(100)') AS DeptId  
                        FROM  
                                        (SELECT [id],  
                                                        CAST ('<M>' + REPLACE(WCCtgryId, ',', '</M><M>') + '</M>' AS XML) AS String  
                                        FROM  WC_ResourcesList
                        ) AS A 
        CROSS APPLY String.nodes ('/M') AS Split(a)) A 
        JOIN lkup_Category D ON A.DeptId = D.Id
        WHERE RL.Id = A.Id
        FOR XML PATH('')
        ), 1, 1, '') AS SCCategories,
        RL.Gradelevel,
        RL.LocationId,
        STUFF(
        (
        SELECT ',' +  D.[Location] AS [text()]
        FROM  (
                        SELECT A.[id],  
                                        Split.a.value('.', 'VARCHAR(100)') AS DeptId  
                        FROM  
                                        (SELECT [id],  
                                                        CAST ('<M>' + REPLACE(LocationId, ',', '</M><M>') + '</M>' AS XML) AS String  
                                        FROM  WC_ResourcesList
                        ) AS A 
        CROSS APPLY String.nodes ('/M') AS Split(a)) A 
        JOIN lkup_Location D ON A.DeptId = D.Id
        WHERE RL.Id = A.Id
        FOR XML PATH('')
        ), 1, 1, '') AS Locations,

        RL.OrgTypeId,
        STUFF(
        (
        SELECT ',' +  D.[Type] AS [text()]
        FROM  (
                        SELECT A.[id],  
                                        Split.a.value('.', 'VARCHAR(100)') AS DeptId  
                        FROM  
                                        (SELECT [id],  
                                                        CAST ('<M>' + REPLACE(OrgTypeId, ',', '</M><M>') + '</M>' AS XML) AS String  
                                        FROM  WC_ResourcesList
                        ) AS A 
        CROSS APPLY String.nodes ('/M') AS Split(a)) A 
        JOIN lkup_OrganizationType D ON A.DeptId = D.Id
        WHERE RL.Id = A.Id
        FOR XML PATH('')
        ), 1, 1, '') AS OrgStatus,
        RL.ContactName,
        RL.Phone,
        RL.Email,
        RL.WebsiteURL,
        RL.VendorNo,
        CASE WHEN LEN(RL.Monetarycost) = 1 AND RL.Monetarycost = '$' THEN REPLACE (RL.Monetarycost,'$','') ELSE RL.Monetarycost END AS Monetarycost,
        RL.CostId,
        CT.[Type] AS Pricing,
        RL.WCOptyId,
        STUFF(
        (
        SELECT ',' +  D.[Type] AS [text()]
        FROM  (
                        SELECT A.[id],  
                                        Split.a.value('.', 'VARCHAR(100)') AS DeptId  
                        FROM  
                                        (SELECT [id],  
                                                        CAST ('<M>' + REPLACE(WCOptyId, ',', '</M><M>') + '</M>' AS XML) AS String  
                                        FROM  WC_ResourcesList
                        ) AS A 
        CROSS APPLY String.nodes ('/M') AS Split(a)) A 
        JOIN lkup_Opportunity D ON A.DeptId = D.Id
        WHERE RL.Id = A.Id
        FOR XML PATH('')
        ), 1, 1, '') AS Offerings,
        CASE WHEN RL.Approved = 'Y' THEN 'Yes'
        ELSE 'No'
        END AS Approved,
        CASE WHEN RL.Locked = 'Y' THEN 'Yes'
        ELSE 'No'
        END AS Locked,
        'False' AS ClubYes,
        REPLACE(RL.TargetAudience,'%','All Grades') AS TargetAudience,
        RL.ArchivedDate,
        CONVERT(VARCHAR,RL.Memo,8000) AS ResourceNotes,
        RL.CreatedByRole,
        RL.UpdatedBy,
        ISNULL(CONVERT(DECIMAL(10,1),RR.AverageRating),0) AS AverageRating,
        RR.RatingsCount,
        COUNT(DISTINCT DR.DBN) AS ResSchools,
		GETDATE() AS [DataPulledDate]

FROM
        WC_ResourcesList RL
        LEFT JOIN
        WC_ScorecardResource SR
        ON
        (SR.ResourceId = RL.Id
        AND
        SR.DBN = RL.DBN
        AND
        SR.WCYearId = 2016)
        LEFT JOIN
        lkup_Costs CT
        ON RL.CostId = CT.Id 
        LEFT JOIN
        (SELECT ResourceId,isnull(sum(Rating)/count(Rating), 0) as AverageRating,Count(Rating) AS RatingsCount FROM WC_ResourcesReviews WHERE [Delete] = 'N' Group By ResourceId) RR
        ON RL.Id=RR.ResourceId
        LEFT JOIN
        WC_DBNResource DR
        ON (RL.Id = DR.ResourceId AND DR.[Delete]=0)
WHERE
        RL.[Delete] = 0
        AND RL.[Name] <> ''
        AND (RL.Archived = 'N' OR RL.Archived IS NULL)
                                                                                                                                                
GROUP BY 
        RL.Id,
        RL.Name,
        RL.DBN,
        RL.WCCtgryId,
        RL.Gradelevel,
        RL.LocationId,
        RL.OrgTypeId,
        RL.ContactName,
        RL.Phone,
        RL.Email,
        RL.WebsiteURL,
        RL.VendorNo,
        RL.Monetarycost,
        RL.CostId,
        CT.[Type],
        RL.WCOptyId,
        RL.Approved,
        RL.Locked,
        RL.TargetAudience,
        RL.ArchivedDate,
        CreatedByRole,
        UpdatedBy,
        CONVERT(VARCHAR,RL.Memo,8000),
        RR.AverageRating,
        RR.RatingsCount

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_TblOrganizationData]
--Table creation code:

IF OBJECT_ID('[SWHUB_TblOrganizationData]') IS NOT NULL
	DROP TABLE [SWHUB_TblOrganizationData]
CREATE TABLE [dbo].[SWHUB_TblOrganizationData](
	[Id] [int] NOT NULL,
	[Name] [varchar](300) NULL,
	[DBN] [varchar](300) NULL,
	[WCCtgryId] [varchar](50) NULL,
	[SCCategories] [nvarchar](max) NULL,
	[Gradelevel] [varchar](50) NULL,
	[LocationId] [varchar](50) NULL,
	[Locations] [nvarchar](max) NULL,
	[OrgTypeId] [varchar](50) NULL,
	[OrgStatus] [nvarchar](max) NULL,
	[ContactName] [varchar](100) NULL,
	[Phone] [varchar](100) NULL,
	[Email] [varchar](100) NULL,
	[WebsiteURL] [varchar](200) NULL,
	[VendorNo] [varchar](20) NULL,
	[Monetarycost] [varchar](8000) NULL,
	[CostId] [int] NULL,
	[Pricing] [varchar](300) NULL,
	[WCOptyId] [varchar](50) NULL,
	[Offerings] [nvarchar](max) NULL,
	[Approved] [varchar](3) NOT NULL,
	[Locked] [varchar](3) NOT NULL,
	[ClubYes] [varchar](5) NOT NULL,
	[TargetAudience] [varchar](8000) NULL,
	[ArchivedDate] [datetime] NULL,
	[ResourceNotes] [varchar](30) NULL,
	[CreatedByRole] [varchar](50) NULL,
	[UpdatedBy] [varchar](50) NULL,
	[AverageRating] [decimal](10, 1) NULL,
	[RatingsCount] [int] NULL,
	[ResSchools] [int] NULL,
	[DataPulledDate] [datetime] NULL,
 CONSTRAINT [PK_SWHUB_TblOrganizationData] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


--Variables for this Package:

Name			Scope										Data type			Value
PackageID		Package 11_Get Organizational Data 			Int32				11


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
VALUES (11,'Package 11_Get Organizational Data')