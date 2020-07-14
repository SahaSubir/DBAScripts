--Sequence Container for FGR_INT
--EST_Delete data from destination tables
TRUNCATE TABLE [Supertable_Stg_CampusSchools]
GO

TRUNCATE TABLE [SWHUB_Supertable_Schools Dimension]
GO

--DFT_Supertable_CampusSchools
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
With Cte(Primary_Building_Code,cConcat) as 
(SELECT Primary_Building_Code,
(SELECT a.System_code+',' from 
(SELECT DISTINCT Primary_Building_Code, RTRIM(LTRIM(System_Code)) AS System_Code
FROM  SUPERLINK.Supertable.dbo.Location_Supertable1
WHERE		Status_Code='O' AND System_id='ats'
		AND Fiscal_Year = CASE WHEN month(getdate()) >= '07' THEN year(getdate()) + 1 ELSE year(getdate()) END
		AND Administrative_District_Code IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75','84') 
--		AND Location_Type_Description<>'Transfer School'
		AND Location_Type_Description<>'Home School' 
--		AND Location_Category_Description<>'Ungraded' 
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
		AND Learning_Community_Name='School'
)
AS a    
WHERE a.Primary_Building_Code=b.Primary_Building_Code     for XML PATH ('') ) cconcat FROM 
(SELECT DISTINCT Primary_Building_Code, RTRIM(LTRIM(System_Code)) AS System_Code
FROM  SUPERLINK.Supertable.dbo.Location_Supertable1
WHERE		Status_Code='O' AND System_id='ats'
		AND Fiscal_Year = CASE WHEN month(getdate()) >= '07' THEN year(getdate()) + 1 ELSE year(getdate()) END
		AND Administrative_District_Code IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75','84') 
--		AND Location_Type_Description<>'Transfer School'
		AND Location_Type_Description<>'Home School' 
--		AND Location_Category_Description<>'Ungraded' 
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
		AND Learning_Community_Name='School'
		) AS b  
GROUP BY Primary_Building_Code) 

SELECT Primary_Building_Code,left(cConcat, len(cConcat) -1)AS [DBNs in the Campus] FROM cte 
ORDER BY Primary_Building_Code

--Data Conversion:
Input Column			Output Alias					Data Type					Length
DBNs in the Campus		Converted_DBNs in the Campus	Unicode string[DT_WSTR]		60

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [Supertable_Stg_CampusSchools]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[Supertable_Stg_CampusSchools]') IS NOT NULL
	DROP TABLE [Supertable_Stg_CampusSchools]
CREATE TABLE [dbo].[Supertable_Stg_CampusSchools](
	[Primary_Building_Code] [char](4) NULL,
	[DBNs in the Campus] [nvarchar](60) NULL
)	


--DFT_Schools and Enrollment
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: SQL Command
--SQL command text:
SELECT a.*,
c.[Total Students Enrolled],
c.[Enrolled Grade PK],
c.[Enrolled Grade K],
c.[Enrolled Grade 1],
c.[Enrolled Grade 2],
c.[Enrolled Grade 3],
c.[Enrolled Grade 4],
c.[Enrolled Grade 5],
c.[Enrolled Grade 6],
c.[Enrolled Grade 7],
c.[Enrolled Grade 8],
c.[Enrolled Grade 9],
c.[Enrolled Grade 10],
c.[Enrolled Grade 11],
c.[Enrolled Grade 12],
d.[Campus School Flag],
d.[No of Schools in the Campus],
e.[DBNs in the Campus],
f.[NumericSchoolDBN],
f.[TermModelID],
g.ProgramName AS [PE_Cohort_Name],
hewc.ProgramName AS [HE_Cohort_Name],
s.[nEvents_Attended_bySchool],ss.[nEvents_Attended_bySchoolStaff],
t.[nInterection_Attended_bySchool],tt.[nInterection_Attended_bySchoolStaff],
pewf.[sPEWorksFunded],
cap.[nTotal_CAPTrained],
peli.[nTotal_PELicensed],
heli.[nTotal_HELicensed],
pete.[nTotal_PE_Teachers_STARS],
hete.[nTotal_HE_Teachers_STARS],
pecert.[nTotal_PE NYS_Certified],
hecert.[nTotal_HE NYS_Certified],
ape.[nTotal_APE_Teachers],
ocp.[Name]	AS [OSWP_Contact_Person],
GETDATE() AS [DataPulledDate] 
FROM 
(
--From Super Table
SELECT DISTINCT Fiscal_Year,System_ID,
CAST([System_Code] AS CHAR(6)) AS [System_Code], 
Administrative_District_Code,
Administrative_District_Name,
Location_Code,
Location_Name_Long, 
Location_Type_Code,
Location_Type_Description,
Location_Category_Code,
Location_Category_Description,
Grades_Text,
Grades_Final_Text,
Open_Date,
Status_Code,
Status_Descriptions,
Primary_Building_Code,
Title_1_School_Flag,
X_Coordinate,
Y_Coordinate,
Latitude,
Longitude,
COALESCE (Primary_Address_Line_1, '') + ' ' + COALESCE (Primary_Address_Line_2, '') + ' ' + COALESCE (Primary_Address_Line_3, '') AS School_Address,
City,
State_Code,
ZIP,
Principal_Name,
Principal_Phone_Number,
[Principal_Email],
Fax_Number,
Geographical_District_Code,
Tier_3_Support_Location_Code, --[BCO Location Code]
Tier_3_Support_Location_Name, --[BCO Location Name]
Tier_3_Support_Leader_Name,   --[BCO Executive Director]
Tier_3_Support_Leader_Phone, -- [BCO Executive Director Phone]
Tier_3_Support_Leader_Email, -- [BCO Executive Director Email]

--[Field_Support_Center_Location_code],
--[Field_Support_Center_Name],
--[Field_Support_Center_Leader_Name],
--[Field_Support_Center_Leader_Phone],
--[Field_Support_Center_Leader_Email],
[Community_School_Sup_Name],
[HighSchool_Network_Superintendent],
(CASE  WHEN (ISNULL(Location_Category_Description, '') = 'Early Childhood' OR
			ISNULL(Location_Category_Description, '') = 'Elementary' OR
			ISNULL(Location_Category_Description, '') = 'Junior High-Intermediate-Middle' OR
			ISNULL(Location_Category_Description, '') = 'K-8') THEN Community_School_Sup_Name 
	  --WHEN (ISNULL(Location_Category_Description, '') = 'High school') THEN HighSchool_Network_Superintendent 
	  WHEN (ISNULL(Location_Category_Description, '') = 'Collaborative or Multi-graded' OR ISNULL(Location_Category_Description, '') = 'Ungraded') THEN '' 
	  WHEN (ISNULL(Location_Category_Description, '') = 'High school')  OR (ISNULL(Location_Category_Description, '') = 'Secondary School' OR ISNULL(Location_Category_Description, '') = 'K-12 all grades') THEN 
			CASE WHEN (ISNULL(HighSchool_Network_Superintendent, '') = '') THEN Community_School_Sup_Name ELSE HighSchool_Network_Superintendent END 
END
) AS Superintendent, 


(CASE WHEN (ISNULL(Location_Category_Description, '') = 'Early Childhood' OR
			ISNULL(Location_Category_Description, '') = 'Elementary' OR
			ISNULL(Location_Category_Description, '') = 'Junior High-Intermediate-Middle' OR
			ISNULL(Location_Category_Description, '') = 'K-8') THEN Community_School_Sup_Email 
	  --WHEN (ISNULL(Location_Category_Description, '') = 'High school') THEN HighSchool_Network_Superintendent_Email 
	  WHEN (ISNULL(Location_Category_Description, '') = 'Collaborative or Multi-graded' OR ISNULL(Location_Category_Description, '') = 'Ungraded') THEN '' 
	  WHEN (ISNULL(Location_Category_Description, '') = 'High school')  OR (ISNULL(Location_Category_Description, '') = 'Secondary School' OR  ISNULL(Location_Category_Description, '') = 'K-12 all grades') THEN 
			CASE WHEN (ISNULL(HighSchool_Network_Superintendent_Email, '') = '') THEN Community_School_Sup_Email ELSE HighSchool_Network_Superintendent_Email END 
	END
) AS [Superintendent_Email],
[Executive_Superintendent_Name],	--[Executive Superintendent Name]	
[Executive_Superintendent_Email]	--[Executive Superintendent Email]

FROM  SUPERLINK.Supertable.dbo.Location_Supertable1
WHERE		System_ID = 'ats' 
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
		AND Learning_Community_Name='School'
) a

LEFT JOIN  
(
--From ATS BiogData
SELECT DISTINCT a.SCHOOL_DBN,
	a.[Total Students Enrolled],
	d.[Enrolled Grade PK],
	e.[Enrolled Grade K],
	f.[Enrolled Grade 1],
	g.[Enrolled Grade 2],
	h.[Enrolled Grade 3],
	i.[Enrolled Grade 4],
	j.[Enrolled Grade 5],
	k.[Enrolled Grade 6],
	l.[Enrolled Grade 7],
	m.[Enrolled Grade 8],
	n.[Enrolled Grade 9],
	o.[Enrolled Grade 10],
	p.[Enrolled Grade 11],
	q.[Enrolled Grade 12]
FROM (
SELECT SCHOOL_DBN,COUNT(STUDENT_ID) AS [Total Students Enrolled] FROM  [ATSLINK].ATS_Demo.dbo.BIOGDATA biogdata_1  
WHERE  STATUS='A' AND SUBSTRING(SCHOOL_DBN,1,2) IS NOT NULL 
AND SUBSTRING(SCHOOL_DBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') 
GROUP BY SCHOOL_DBN
) a

LEFT JOIN
(
SELECT SCHOOL_DBN,COUNT(STUDENT_ID) AS [Enrolled Grade PK] FROM [ATSLINK].ATS_Demo.dbo.BIOGDATA biogdata_1  
WHERE  GRADE_LEVEL IN ('PK') 
AND STATUS='A' AND SUBSTRING(SCHOOL_DBN,1,2) IS NOT NULL 
AND SUBSTRING(SCHOOL_DBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') 
GROUP BY SCHOOL_DBN
)d
ON a.SCHOOL_DBN=d.SCHOOL_DBN 

LEFT JOIN
(
SELECT SCHOOL_DBN,COUNT(STUDENT_ID) AS [Enrolled Grade K] FROM [ATSLINK].ATS_Demo.dbo.BIOGDATA biogdata_1   
WHERE  GRADE_LEVEL IN ('0K') 
AND STATUS='A' AND SUBSTRING(SCHOOL_DBN,1,2) IS NOT NULL 
AND SUBSTRING(SCHOOL_DBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') 
GROUP BY SCHOOL_DBN
) e
ON a.SCHOOL_DBN=e.SCHOOL_DBN 
LEFT JOIN
(
SELECT SCHOOL_DBN,COUNT(STUDENT_ID) AS [Enrolled Grade 1] FROM [ATSLINK].ATS_Demo.dbo.BIOGDATA biogdata_1     
WHERE  GRADE_LEVEL IN ('01') 
AND STATUS='A' AND SUBSTRING(SCHOOL_DBN,1,2) IS NOT NULL 
AND SUBSTRING(SCHOOL_DBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') 
GROUP BY SCHOOL_DBN
) f
ON a.SCHOOL_DBN=f.SCHOOL_DBN 
LEFT JOIN
(
SELECT SCHOOL_DBN, COUNT(STUDENT_ID) AS [Enrolled Grade 2] FROM [ATSLINK].ATS_Demo.dbo.BIOGDATA biogdata_1  
WHERE  GRADE_LEVEL IN ('02') 
AND STATUS='A' AND SUBSTRING(SCHOOL_DBN,1,2) IS NOT NULL 
AND SUBSTRING(SCHOOL_DBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') 
GROUP BY SCHOOL_DBN
) g
ON a.SCHOOL_DBN=g.SCHOOL_DBN 
LEFT JOIN
(
SELECT SCHOOL_DBN,COUNT(STUDENT_ID) AS [Enrolled Grade 3] FROM [ATSLINK].ATS_Demo.dbo.BIOGDATA biogdata_1   
WHERE  GRADE_LEVEL IN ('03') 
AND STATUS='A' AND SUBSTRING(SCHOOL_DBN,1,2) IS NOT NULL 
AND SUBSTRING(SCHOOL_DBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') 
GROUP BY SCHOOL_DBN
) h
ON a.SCHOOL_DBN=h.SCHOOL_DBN
LEFT JOIN
(
SELECT SCHOOL_DBN,COUNT(STUDENT_ID) AS [Enrolled Grade 4] FROM [ATSLINK].ATS_Demo.dbo.BIOGDATA biogdata_1    
WHERE  GRADE_LEVEL IN ('04') 
AND STATUS='A' AND SUBSTRING(SCHOOL_DBN,1,2) IS NOT NULL 
AND SUBSTRING(SCHOOL_DBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') 
GROUP BY SCHOOL_DBN
) i
ON a.SCHOOL_DBN=i.SCHOOL_DBN 
LEFT JOIN
(
SELECT SCHOOL_DBN,COUNT(STUDENT_ID) AS [Enrolled Grade 5] FROM [ATSLINK].ATS_Demo.dbo.BIOGDATA biogdata_1     
WHERE  GRADE_LEVEL IN ('05') 
AND STATUS='A' AND SUBSTRING(SCHOOL_DBN,1,2) IS NOT NULL 
AND SUBSTRING(SCHOOL_DBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') 
GROUP BY SCHOOL_DBN
) j
ON a.SCHOOL_DBN=j.SCHOOL_DBN 
LEFT JOIN
(
SELECT SCHOOL_DBN, COUNT(STUDENT_ID) AS [Enrolled Grade 6] FROM [ATSLINK].ATS_Demo.dbo.BIOGDATA biogdata_1  
WHERE  GRADE_LEVEL IN ('06') 
AND STATUS='A' AND SUBSTRING(SCHOOL_DBN,1,2) IS NOT NULL 
AND SUBSTRING(SCHOOL_DBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') 
GROUP BY SCHOOL_DBN
) k
ON a.SCHOOL_DBN=k.SCHOOL_DBN 
LEFT JOIN
(
SELECT SCHOOL_DBN,COUNT(STUDENT_ID) AS [Enrolled Grade 7] FROM [ATSLINK].ATS_Demo.dbo.BIOGDATA biogdata_1  
WHERE  GRADE_LEVEL IN ('07') 
AND STATUS='A' AND SUBSTRING(SCHOOL_DBN,1,2) IS NOT NULL 
AND SUBSTRING(SCHOOL_DBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') 
GROUP BY SCHOOL_DBN
) l
ON a.SCHOOL_DBN=l.SCHOOL_DBN 
LEFT JOIN
(
SELECT SCHOOL_DBN,COUNT(STUDENT_ID) AS [Enrolled Grade 8] FROM [ATSLINK].ATS_Demo.dbo.BIOGDATA biogdata_1    
WHERE  GRADE_LEVEL IN ('08') 
AND STATUS='A' AND SUBSTRING(SCHOOL_DBN,1,2) IS NOT NULL 
AND SUBSTRING(SCHOOL_DBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') 
GROUP BY SCHOOL_DBN
) m
ON a.SCHOOL_DBN=m.SCHOOL_DBN 
LEFT JOIN
(
SELECT SCHOOL_DBN,COUNT(STUDENT_ID) AS [Enrolled Grade 9] FROM [ATSLINK].ATS_Demo.dbo.BIOGDATA biogdata_1    
WHERE  GRADE_LEVEL IN ('09') 
AND STATUS='A' AND SUBSTRING(SCHOOL_DBN,1,2) IS NOT NULL 
AND SUBSTRING(SCHOOL_DBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') 
GROUP BY SCHOOL_DBN
) n
ON a.SCHOOL_DBN=n.SCHOOL_DBN 
LEFT JOIN
(
SELECT SCHOOL_DBN,COUNT(STUDENT_ID) AS [Enrolled Grade 10] FROM [ATSLINK].ATS_Demo.dbo.BIOGDATA biogdata_1    
WHERE  GRADE_LEVEL IN ('10') 
AND STATUS='A' AND SUBSTRING(SCHOOL_DBN,1,2) IS NOT NULL 
AND SUBSTRING(SCHOOL_DBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') 
GROUP BY SCHOOL_DBN
) o
ON a.SCHOOL_DBN=o.SCHOOL_DBN 
LEFT JOIN
(
SELECT SCHOOL_DBN,COUNT(STUDENT_ID) AS [Enrolled Grade 11] FROM [ATSLINK].ATS_Demo.dbo.BIOGDATA biogdata_1  
WHERE  GRADE_LEVEL IN ('11') 
AND STATUS='A' AND SUBSTRING(SCHOOL_DBN,1,2) IS NOT NULL 
AND SUBSTRING(SCHOOL_DBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') 
GROUP BY SCHOOL_DBN
) p
ON a.SCHOOL_DBN=p.SCHOOL_DBN 

LEFT JOIN
(
SELECT SCHOOL_DBN,COUNT(STUDENT_ID) AS [Enrolled Grade 12] FROM [ATSLINK].ATS_Demo.dbo.BIOGDATA biogdata_1  
WHERE  GRADE_LEVEL IN ('12') 
AND STATUS='A' AND SUBSTRING(SCHOOL_DBN,1,2) IS NOT NULL 
AND SUBSTRING(SCHOOL_DBN,1,2) IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') 
GROUP BY SCHOOL_DBN
) q
ON a.SCHOOL_DBN=q.SCHOOL_DBN 
) c
ON a.[System_Code]=c.[School_DBN]
INNER JOIN 
(SELECT DISTINCT Primary_Building_Code, CASE WHEN COUNT(System_Code)>1 THEN 'Yes' ELSE '' END AS [Campus School Flag],COUNT(System_Code) AS [No of Schools in the Campus]
FROM  SUPERLINK.Supertable.dbo.Location_Supertable1
WHERE		Status_Code='O' AND system_id='ats'
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
		AND Learning_Community_Name='School'
GROUP BY Primary_Building_Code
) d
ON a.[Primary_Building_Code]=d.Primary_Building_Code
LEFT JOIN [dbo].[Supertable_Stg_CampusSchools] e
ON a.[Primary_Building_Code]=e.Primary_Building_Code
LEFT JOIN [dbo].[STARS_Stg_School] f
ON a.System_Code=f.SchoolDBN
LEFT JOIN (
SELECT DISTINCT a.[ProgramId],a.[ParticipantSchoolDBN],b.ProgramName FROM [dbo].[SWHUB_ISS_ProgramParticipants] a
LEFT JOIN [dbo].[SWHUB_ISS_Programs] b ON a.ProgramId=b.ProgramId WHERE b.ProgramName LIKE 'PE Works Cohort%' 
) g ON a.[System_Code]=g.[ParticipantSchoolDBN]

--# of events for school table

LEFT JOIN (
SELECT sParticipant AS sSchoolDBN,COUNT(nEventID) AS [nEvents_Attended_bySchool] FROM (
SELECT DISTINCT nEventID,sParticipant FROM [SWHUB_ISS_EventParticipants] WHERE sEventStatus NOT IN ('Cancelled,Postponed') AND [sEventParticipantType]='D' AND sParticipant IS NOT NULL
) a
GROUP BY sParticipant
)s ON a.[System_Code]=s.sSchoolDBN

LEFT JOIN (
SELECT sEventParticipant_SchoolDBN AS sSchoolDBN,COUNT(nEventID) AS [nEvents_Attended_bySchoolStaff] 
FROM (
SELECT DISTINCT nEventID,sEventParticipant_SchoolDBN,sParticipant,sEventParticipant_EmployeeNo,sEventParticipant_EISId 
FROM [SWHUB_ISS_EventParticipants] WHERE sEventStatus NOT IN ('Cancelled,Postponed') AND [sEventParticipantType]='U' AND sParticipant IS NOT NULL
) a
GROUP BY sEventParticipant_SchoolDBN
) ss ON a.[System_Code]=ss.sSchoolDBN

----# of interection for school table
LEFT JOIN (
SELECT [sParticipant] AS sSchoolDBN,COUNT([sParticipant]) AS [nInterection_Attended_bySchool] FROM (
SELECT DISTINCT [sParticipant],[nProgStaffInteractID] FROM [SWHUB_ISS_InteractionParticipants]  
WHERE [sInteractionStatus] NOT IN ('Cancelled','Postponed') AND [sInterectionParticipantType]='D' AND sParticipant IS NOT NULL
) a
GROUP BY [sParticipant]
)t ON a.[System_Code]=t.sSchoolDBN

LEFT JOIN (
SELECT DISTINCT sInterectionParticipant_SchoolDBN AS sSchoolDBN ,COUNT([nProgStaffInteractID]) AS [nInterection_Attended_bySchoolStaff] 
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
SELECT DISTINCT [sParticipant],[nProgStaffInteractID],[sInteractionName] FROM [SWHUB_ISS_InteractionParticipants]  
WHERE [sInteractionStatus] NOT IN ('Cancelled','Postponed') AND [sInterectionParticipantType]='U' AND sParticipant IS NOT NULL
) inp
INNER JOIN [dbo].[SWHUB_ISS_PersonalInfo] PI ON inp.sParticipant =PI.nEmpId AND pi.SchoolDBN IS NOT NULL
) a 
)b
GROUP BY  sInterectionParticipant_SchoolDBN
) tt ON a.[System_Code]=tt.sSchoolDBN

LEFT JOIN (
SELECT DISTINCT a.[ParticipantSchoolDBN],b.ProgramName AS [sPEWorksFunded] FROM [dbo].[SWHUB_ISS_ProgramParticipants] a
LEFT JOIN [dbo].[SWHUB_ISS_Programs] b ON a.ProgramId=b.ProgramId WHERE b.ProgramName LIKE 'PE Works Funding%' 
) pewf ON a.[System_Code]=pewf.[ParticipantSchoolDBN]

LEFT JOIN (
SELECT c.[SchoolDBN], COUNT(c.[EmployeeNo]) AS [nTotal_CAPTrained] FROM (
SELECT b.[SchoolDBN],a.[EmployeeNo]--,a.[ComponentID],a.[ComponentName] 
FROM [dbo].[SWHUB_ISS_TeacherProfileLabels] a
INNER JOIN [dbo].[SWHUB_ISS_PersonalInfo]b
ON a.[EmployeeNo]=b.[EmployeeNo] 
WHERE a.ComponentID=40) AS c
GROUP BY c.[SchoolDBN]
) cap ON a.[System_Code]=cap.[SchoolDBN]

LEFT JOIN (
SELECT c.[SchoolDBN], COUNT(c.[EmployeeNo]) AS [nTotal_PELicensed] FROM (
SELECT DISTINCT b.[SchoolDBN],a.[EmployeeNo]--,a.[ComponentID],a.[ComponentName] 
FROM [dbo].[SWHUB_ISS_TeacherProfileLabels] a
INNER JOIN [dbo].[SWHUB_ISS_PersonalInfo]b
ON a.[EmployeeNo]=b.[EmployeeNo] 
WHERE a.ComponentID=61) AS c
GROUP BY c.[SchoolDBN]
) peli ON a.[System_Code]=peli.[SchoolDBN]

LEFT JOIN (
SELECT c.[SchoolDBN], COUNT(c.[EmployeeNo]) AS [nTotal_HELicensed] FROM (
SELECT DISTINCT b.[SchoolDBN],a.[EmployeeNo]--,a.[ComponentID],a.[ComponentName] 
FROM [dbo].[SWHUB_ISS_TeacherProfileLabels] a
INNER JOIN [dbo].[SWHUB_ISS_PersonalInfo]b
ON a.[EmployeeNo]=b.[EmployeeNo] 
WHERE a.ComponentID=62) AS c
GROUP BY c.[SchoolDBN]
) heli ON a.[System_Code]=heli.[SchoolDBN]

LEFT JOIN (
SELECT c.[SchoolDBN], COUNT(c.[EmployeeNo]) AS [nTotal_PE NYS_Certified] FROM (
SELECT DISTINCT b.[SchoolDBN],a.[EmployeeNo]--,a.[ComponentID],a.[ComponentName] 
FROM [dbo].[SWHUB_ISS_TeacherProfileLabels] a
INNER JOIN [dbo].[SWHUB_ISS_PersonalInfo]b
ON a.[EmployeeNo]=b.[EmployeeNo] 
WHERE a.ComponentID=74) AS c
GROUP BY c.[SchoolDBN]
) pecert ON a.[System_Code]=pecert.[SchoolDBN] 

LEFT JOIN (
SELECT c.[SchoolDBN], COUNT(c.[EmployeeNo]) AS [nTotal_HE NYS_Certified] FROM (
SELECT DISTINCT b.[SchoolDBN],a.[EmployeeNo]--,a.[ComponentID],a.[ComponentName] 
FROM [dbo].[SWHUB_ISS_TeacherProfileLabels] a
INNER JOIN [dbo].[SWHUB_ISS_PersonalInfo]b
ON a.[EmployeeNo]=b.[EmployeeNo] 
WHERE a.ComponentID=75) AS c
GROUP BY c.[SchoolDBN]
) hecert ON a.[System_Code]=hecert.[SchoolDBN] 

LEFT JOIN (
SELECT c.[SchoolDBN], COUNT(c.[EmployeeNo]) AS [nTotal_PE_Teachers_STARS] FROM (
SELECT DISTINCT b.[SchoolDBN],a.[EmployeeNo] FROM [dbo].[SWHUB_ISS_TeacherProfileLabels] a
INNER JOIN [dbo].[SWHUB_ISS_PersonalInfo] b
ON a.[EmployeeNo]=b.[EmployeeNo] 
WHERE a.ComponentID IN (49,50,63)) AS c
GROUP BY c.[SchoolDBN]
) pete ON a.[System_Code]=pete.[SchoolDBN]

LEFT JOIN (
SELECT c.[SchoolDBN], COUNT(c.[EmployeeNo]) AS [nTotal_HE_Teachers_STARS] FROM (
SELECT DISTINCT b.[SchoolDBN],a.[EmployeeNo] FROM [dbo].[SWHUB_ISS_TeacherProfileLabels] a
INNER JOIN [dbo].[SWHUB_ISS_PersonalInfo] b
ON a.[EmployeeNo]=b.[EmployeeNo] 
WHERE a.ComponentID IN (51,52)) AS c
GROUP BY c.[SchoolDBN]
) hete ON a.[System_Code]=hete.[SchoolDBN]

LEFT JOIN (
SELECT c.[SchoolDBN], COUNT(c.[EmployeeNo]) AS [nTotal_APE_Teachers] FROM (
SELECT DISTINCT b.[SchoolDBN],a.[EmployeeNo]--,ComponentID,[ComponentName] 
FROM [dbo].[SWHUB_ISS_TeacherProfileLabels] a
INNER JOIN [dbo].[SWHUB_ISS_PersonalInfo]b
ON a.[EmployeeNo]=b.[EmployeeNo] 
WHERE a.ComponentID IN (16)) AS c
GROUP BY c.[SchoolDBN]
) ape ON a.[System_Code]=ape.[SchoolDBN]
LEFT JOIN (
SELECT DISTINCT a.[ProgramId],a.[ParticipantSchoolDBN],b.ProgramName FROM [dbo].[SWHUB_ISS_ProgramParticipants] a
LEFT JOIN [dbo].[SWHUB_ISS_Programs] b ON a.ProgramId=b.ProgramId WHERE b.ProgramName in  
('Health Ed Works Cohort 1/CDC 1807 (2018-19)','Health Ed Works Cohort 2 (2019-20)','Health Ed Works Cohort 3 (2020-21)')
) hewc ON a.[System_Code]=hewc.[ParticipantSchoolDBN]
LEFT JOIN (SELECT DISTINCT [DBN],[Title],[Name],[Email]  FROM [dbo].[OSWP_TblLiaisonsList]) ocp ON a.[System_Code]=ocp.[DBN]


--Data Conversion:
Input Column			Output Alias			Data Type			Length
Principal_Email		Converted_Principal_Email	string[DT_STR]		100
Principal_Name		Converted_Principal_Name	string[DT_STR]		50
System_Code			Converted_System_Code		string[DT_STR]		6


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01 FGR_INT FGRepUser
--Data access mode: Table or view-fast load
--Name of the table or the view: [SWHUB_Supertable_Schools Dimension]
--Table creation code:
USE FGR_INT
IF OBJECT_ID('[SWHUB_Supertable_Schools Dimension]') IS NOT NULL
	DROP TABLE [SWHUB_Supertable_Schools Dimension]
CREATE TABLE [dbo].[SWHUB_Supertable_Schools Dimension](
	[Fiscal_Year] [int] NOT NULL,
	[System_Code] [char](6) NOT NULL,
	[System_ID] [char](5) NOT NULL,
	[Location_Code] [char](4) NOT NULL,
	[Location_Name] [varchar](100) NULL,
	[Administrative_District_Code] [char](2) NULL,
	[Administrative_District_Name] [varchar](50) NULL,
	[Geographical_District_Code] [varchar](50) NULL,
	[Location_Type_Code] [char](2) NULL,
	[Location_Type_Description] [varchar](35) NULL,
	[Location_Category_Code] [char](2) NULL,
	[Location_Category_Description] [varchar](35) NULL,
	[Grades_Text] [varchar](45) NULL,
	[Grades_Final_Text] [varchar](45) NULL,
	[Open_Date] [datetime] NULL,
	[Status_Code] [char](1) NULL,
	[Status_Descriptions] [varchar](30) NULL,
	[Primary_Building_Code] [char](4) NULL,
	[Title_1_School_Flag] [char](1) NULL,
	[X_Coordinate] [numeric](12, 2) NULL,
	[Y_Coordinate] [numeric](12, 2) NULL,
	[Latitude] [numeric](10, 6) NULL,
	[Longitude] [numeric](10, 6) NULL,
	[School_Address] [varchar](200) NULL,
	[City] [varchar](50) NULL,
	[State_Code] [char](2) NULL,
	[ZIP] [int] NULL,
	[Principal_Name] [varchar](50) NULL,
	[Principal_Phone_Number] [varchar](15) NULL,
	[Principal_Email] [varchar](100) NULL,
	[Fax_Number] [varchar](15) NULL,
	[Field_Support_Center_Location_code] [char](4) NULL,
	[Field_Support_Center_Name] [varchar](100) NULL,
	[Field_Support_Center_Leader_Name] [varchar](100) NULL,
	[Field_Support_Center_Leader_Phone] [varchar](15) NULL,
	[Field_Support_Center_Leader_Email] [varchar](100) NULL,
	[Community_School_Sup_Name] [varchar](100) NULL,
	[HighSchool_Network_Superintendent] [varchar](100) NULL,
	[Superintendent] [varchar](100) NULL,
	[Superintendent_Email] [varchar](100) NULL,
	[Total_Students_Enrolled] [int] NULL,
	[Enrolled_Grade_PK] [int] NULL,
	[Enrolled_Grade_K] [int] NULL,
	[Enrolled_Grade_1] [int] NULL,
	[Enrolled_Grade_2] [int] NULL,
	[Enrolled_Grade_3] [int] NULL,
	[Enrolled_Grade_4] [int] NULL,
	[Enrolled_Grade_5] [int] NULL,
	[Enrolled_Grade_6] [int] NULL,
	[Enrolled_Grade_7] [int] NULL,
	[Enrolled_Grade_8] [int] NULL,
	[Enrolled_Grade_9] [int] NULL,
	[Enrolled_Grade_10] [int] NULL,
	[Enrolled_Grade_11] [int] NULL,
	[Enrolled_Grade_12] [int] NULL,
	[Campus_School_Flag] [char](3) NULL,
	[NoSchools_in the Campus] [int] NULL,
	[DBNs in the Campus] [nvarchar](60) NULL,
	[NumericSchoolDBN] [int] NULL,
	[TermModelID] [tinyint] NULL,
	[PE_Cohort_Name] [varchar](100) NULL,
	[nEvents_Attended_bySchool] [int] NULL,
	[nEvents_Attended_bySchoolStaff] [int] NULL,
	[nInterection_Attended_bySchool] [int] NULL,
	[nInterection_Attended_bySchoolStaff] [int] NULL,
	[sPEWorksFunded] [varchar](100) NULL,
	[nTotal_CAPTrained] [int] NULL,
	[nTotal_APE_Teachers] [int] NULL,
	[nTotal_PE_Teachers_STARS] [int] NULL,
	[nTotal_HE_Teachers_STARS] [int] NULL,
	[nTotal_PE_NYC_Licensed] [int] NULL,
	[nTotal_HE_NYC_Licensed] [int] NULL,
	[nTotal_PE NYS_Certified] [int] NULL,
	[nTotal_HE NYS_Certified] [int] NULL,
	[DataPulledDate] [datetime] NULL,
	[HE_Cohort_Name] [varchar](100) NULL,
	[Executive_Superintendent_Name] [varchar](100) NULL,
	[Executive_Superintendent_Email] [varchar](100) NULL,
	[OSWP_Contact_Person] [varchar](100) NULL,
 CONSTRAINT [PK_SWHUB_Supertable_Schools_Dimension] PRIMARY KEY CLUSTERED 
(
	[Fiscal_Year] ASC,
	[Location_Code] ASC,
	[System_ID] ASC,
	[System_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

--Sequence Container for ISS_EXT
--EST_Cleanup Location Staging Table in ISS_EXT
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
DELETE FROM dbo.ISS_tblLookUp_LocationSupertable_Staging

--DFT_Load data from LCGMS super table to ISS_tblLookUp_LocationSupertable_Staging table
--OLE DB Source
--OLEDB Connection Manager: ES11vSINFAG02,4433.Supertable.super
--Data access mode: SQL Command
--SQL command text:
SELECT DISTINCT 
Fiscal_Year, 
Location_Code, 
System_ID, 
System_Code, 
Location_Name_Long, 
Location_Type_Code, 
Location_Category_Code, 
Location_Category_Description, 
Borough_Code, 
Geographical_District_Code, 
Geographical_District_Name, 
Financial_District_Code, 
Financial_District_Name, 
Payroll_District_Code, 
Payroll_District_Name, 
Responsible_District_Code, 
Responsible_District_Name, 
Administrative_District_Code, 
Administrative_District_Name, 
Status_Code, 
Principal_Name, 
Temporary_Reporting_Code, 
Grades_Text, 
Principal_Email, 
Primary_Address_Line_1, 
Primary_Address_Line_2, 
Primary_Address_Line_3, 
City, 
State_Code, 
Zip, 
Learning_Community_Code, 
Principal_Phone_Number, 
Fax_Number, 
Managed_By_Code, 
Managed_By_Name, 
[Admin_District_Location_Code],
Tier_3_Support_Location_Code,--equivalent old name: [Field_Support_Center_Location_code],
Tier_3_Support_Location_Name, --equivalent old name:[Field_Support_Center_Name],
Tier_3_Support_Leader_Name, --equivalent old name:[Field_Support_Center_Leader_Name],
Tier_3_Support_Leader_Title, --equivalent old name:[Field_Support_Center_Leader_Title],
Tier_3_Support_Leader_Phone, --equivalent old name:[Field_Support_Center_Leader_Phone],
Tier_3_Support_Leader_Email, --equivalent old name:[Field_Support_Center_Leader_Email],
Tier_2_Support_Location_Code, --equivalent old name:[School_Support_Team_location_code],
Tier_2_Support_Location_Name,--equivalent old name:[School_Support_Team_Name],
Community_School_Sup_Name ,
Community_School_Sup_Email ,
HighSchool_Network_Superintendent ,
HighSchool_Network_Superintendent_Email,
GETDATE() AS dtLastUpdated
FROM dbo.Location_Supertable1
WHERE(System_ID = 'LCMS') AND (Fiscal_Year = (Select CASE WHEN MONTH(GETDATE()) > 7 Then  Convert(Varchar,YEAR(GETDATE())+1)  ELSE  Convert(Varchar,YEAR(GETDATE())) END))

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_tblLookUp_LocationSupertable_Staging]
--Table creation code:
USE ISS_EXT
IF OBJECT_ID('[ISS_tblLookUp_LocationSupertable_Staging]') IS NOT NULL
	DROP TABLE [ISS_tblLookUp_LocationSupertable_Staging]
CREATE TABLE [dbo].[ISS_tblLookUp_LocationSupertable_Staging](
	[Fiscal_Year] [char](4) NOT NULL,
	[Location_Code] [char](4) NOT NULL,
	[System_ID] [char](5) NOT NULL,
	[System_Code] [char](12) NOT NULL,
	[Location_Name] [varchar](250) NULL,
	[Location_Type_Code] [char](2) NULL,
	[Location_Category_Code] [char](2) NULL,
	[Location_Category_description] [varchar](35) NULL,
	[Borough_Code] [char](1) NULL,
	[Geographical_District_Code] [char](2) NULL,
	[Geographical_District_Name] [varchar](50) NULL,
	[Financial_District_Code] [char](2) NULL,
	[Financial_District_Name] [varchar](50) NULL,
	[Payroll_District_Code] [char](2) NULL,
	[Payroll_District_Name] [varchar](50) NULL,
	[Responsible_District_Code] [char](2) NULL,
	[Responsible_District_Name] [varchar](50) NULL,
	[Administrative_District_Code] [char](2) NULL,
	[Administrative_District_Name] [varchar](50) NULL,
	[Status_Code] [char](1) NULL,
	[PRINCIPAL_NAME] [varchar](100) NULL,
	[Temporary_Reporting_Code] [char](2) NULL,
	[Grades_Text] [varchar](45) NULL,
	[PRINCIPAL_EMAIL] [varchar](100) NULL,
	[sPrimaryaddress1] [varchar](50) NULL,
	[sPrimaryaddress2] [varchar](50) NULL,
	[sPrimaryaddress3] [varchar](50) NULL,
	[sCity] [varchar](50) NULL,
	[sState] [char](2) NULL,
	[sZip] [char](10) NULL,
	[Learning_Community_Code] [char](1) NULL,
	[Principal_Phone_Number] [varchar](15) NULL,
	[Fax_Number] [varchar](15) NULL,
	[Managed_By_Code] [char](2) NULL,
	[Managed_By_Name] [varchar](50) NULL,
	[Admin_District_Location_Code],
	[Tier_3_Support_Location_Code] [varchar](10) NULL,--equivalent old name: [Field_Support_Center_Location_code],
	[Tier_3_Support_Location_Name] [varchar](100) NULL, --equivalent old name:[Field_Support_Center_Name],
	[Tier_3_Support_Leader_Name] [varchar](100) NULL, --equivalent old name:[Field_Support_Center_Leader_Name],
	[Tier_3_Support_Leader_Title] [varchar](100) NULL, --equivalent old name:[Field_Support_Center_Leader_Title],
	[Tier_3_Support_Leader_Phone] [varchar](15) NULL, --equivalent old name:[Field_Support_Center_Leader_Phone],
	[Tier_3_Support_Leader_Email] [varchar](100) NULL, --equivalent old name:[Field_Support_Center_Leader_Email],
	[Tier_2_Support_Location_Code] [varchar](10) NULL, --equivalent old name:[School_Support_Team_location_code],
	[Tier_2_Support_Location_Name] [varchar](100) NULL,--equivalent old name:[School_Support_Team_Name],
	[Community_School_Sup_Name] [varchar](100) NULL,
	[Community_School_Sup_Email] [varchar](100) NULL,
	[HighSchool_Network_Superintendent] [varchar](100) NULL,
	[HighSchool_Network_Superintendent_Email] [varchar](100) NULL,

	[Field_Support_Center_Location_code] [varchar](10) NULL,
	[Field_Support_Center_Name] [varchar](100) NULL,
	[Field_Support_Center_Leader_Name] [varchar](100) NULL,
	[Field_Support_Center_Leader_Title] [varchar](100) NULL,
	[Field_Support_Center_Leader_Phone] [varchar](15) NULL,
	[Field_Support_Center_Leader_Email] [varchar](100) NULL,
	[School_Support_Team_location_code] [varchar](10) NULL,
	[School_Support_Team_Name] [varchar](100) NULL,
	[School_Support_Team_Leader_Name] [varchar](100) NULL,
	[School_Support_Team_Leader_Title] [varchar](100) NULL,
	[School_Support_Team_Leader_Phone] [varchar](15) NULL,
	[School_Support_Team_Leader_Email] [varchar](100) NULL,

 CONSTRAINT [PK_ISS_tblLookUp_LocationSupertable_Staging] PRIMARY KEY CLUSTERED 
(
	[Fiscal_Year] ASC,
	[Location_Code] ASC,
	[System_ID] ASC,
	[System_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

--EST_Cleanup Main Location Super Table in ISS_EXT
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
DELETE FROM dbo.ISS_tblLookUp_LocationSupertable WHERE FISCAL_YEAR=(Select CASE WHEN MONTH(GETDATE()) > 7 Then  Convert(Varchar,YEAR(GETDATE())+1)  ELSE  Convert(Varchar,YEAR(GETDATE())) END)

--DFT_Load all records from Staging table to Actual table
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or View
--Name of the table or the view: [ISS_tblLookUp_LocationSupertable_Staging]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_tblLookUp_LocationSupertable]
--Table creation code:
USE ISS_EXT
IF OBJECT_ID('[ISS_tblLookUp_LocationSupertable]') IS NOT NULL
	DROP TABLE [ISS_tblLookUp_LocationSupertable]
CREATE TABLE [dbo].[ISS_tblLookUp_LocationSupertable](
	[Fiscal_Year] [char](4) NOT NULL,
	[Location_Code] [char](4) NOT NULL,
	[System_ID] [char](5) NOT NULL,
	[System_Code] [char](12) NOT NULL,
	[Location_Name] [varchar](250) NULL,
	[Location_Type_Code] [char](2) NULL,
	[Location_Category_Code] [char](2) NULL,
	[Location_Category_description] [varchar](35) NULL,
	[Borough_Code] [char](1) NULL,
	[Geographical_District_Code] [char](2) NULL,
	[Geographical_District_Name] [varchar](50) NULL,
	[Financial_District_Code] [char](2) NULL,
	[Financial_District_Name] [varchar](50) NULL,
	[Payroll_District_Code] [char](2) NULL,
	[Payroll_District_Name] [varchar](50) NULL,
	[Responsible_District_Code] [char](2) NULL,
	[Responsible_District_Name] [varchar](50) NULL,
	[Administrative_District_Code] [char](2) NULL,
	[Administrative_District_Name] [varchar](50) NULL,
	[Status_Code] [char](1) NULL,
	[PRINCIPAL_NAME] [varchar](100) NULL,
	[Temporary_Reporting_Code] [char](2) NULL,
	[Grades_Text] [varchar](45) NULL,
	[PRINCIPAL_EMAIL] [varchar](100) NULL,
	[sPrimaryaddress1] [varchar](50) NULL,
	[sPrimaryaddress2] [varchar](50) NULL,
	[sPrimaryaddress3] [varchar](50) NULL,
	[sCity] [varchar](50) NULL,
	[sState] [char](2) NULL,
	[sZip] [char](10) NULL,
	[Learning_Community_Code] [char](1) NULL,
	[Principal_Phone_Number] [varchar](15) NULL,
	[Fax_Number] [varchar](15) NULL,
	[Managed_By_Code] [char](2) NULL,
	[Managed_By_Name] [varchar](50) NULL,
	[Admin_District_Location_Code],
	[Tier_3_Support_Location_Code] [varchar](10) NULL,--equivalent old name: [Field_Support_Center_Location_code],
	[Tier_3_Support_Location_Name] [varchar](100) NULL, --equivalent old name:[Field_Support_Center_Name],
	[Tier_3_Support_Leader_Name] [varchar](100) NULL, --equivalent old name:[Field_Support_Center_Leader_Name],
	[Tier_3_Support_Leader_Title] [varchar](100) NULL, --equivalent old name:[Field_Support_Center_Leader_Title],
	[Tier_3_Support_Leader_Phone] [varchar](15) NULL, --equivalent old name:[Field_Support_Center_Leader_Phone],
	[Tier_3_Support_Leader_Email] [varchar](100) NULL, --equivalent old name:[Field_Support_Center_Leader_Email],
	[Tier_2_Support_Location_Code] [varchar](10) NULL, --equivalent old name:[School_Support_Team_location_code],
	[Tier_2_Support_Location_Name] [varchar](100) NULL,--equivalent old name:[School_Support_Team_Name],
	[Community_School_Sup_Name] [varchar](100) NULL,
	[Community_School_Sup_Email] [varchar](100) NULL,
	[HighSchool_Network_Superintendent] [varchar](100) NULL,
	[HighSchool_Network_Superintendent_Email] [varchar](100) NULL,

	[Field_Support_Center_Location_code] [varchar](10) NULL,
	[Field_Support_Center_Name] [varchar](100) NULL,
	[Field_Support_Center_Leader_Name] [varchar](100) NULL,
	[Field_Support_Center_Leader_Title] [varchar](100) NULL,
	[Field_Support_Center_Leader_Phone] [varchar](15) NULL,
	[Field_Support_Center_Leader_Email] [varchar](100) NULL,
	[School_Support_Team_location_code] [varchar](10) NULL,
	[School_Support_Team_Name] [varchar](100) NULL,
	[School_Support_Team_Leader_Name] [varchar](100) NULL,
	[School_Support_Team_Leader_Title] [varchar](100) NULL,
	[School_Support_Team_Leader_Phone] [varchar](15) NULL,
	[School_Support_Team_Leader_Email] [varchar](100) NULL,

 CONSTRAINT [PK_ISS_tblLookUp_LocationSupertable] PRIMARY KEY CLUSTERED 
(
	[Fiscal_Year] ASC,
	[Location_Code] ASC,
	[System_ID] ASC,
	[System_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


--EST_Load Superintendents
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
exec [ISS_SprocLoadSuperintendents]

--Stored proc creation code
USE [ISS_EXT]
GO
/****** Object:  StoredProcedure [dbo].[ISS_SprocLoadSuperintendents]    Script Date: 12/3/2019 10:11:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[ISS_SprocLoadSuperintendents]
AS
BEGIN
DELETE FROM [dbo].[ISS_tblSuperintendents]
INSERT INTO [dbo].[ISS_tblSuperintendents]
           ([Location]
		   ,[NAME]
		   ,[Email])
    
SELECT DISTINCT  Administrative_District_Code, (CASE WHEN (ISNULL(LS.Location_Category_Description, '') = 'Early Childhood' OR
ISNULL(LS.Location_Category_Description, '') = 'Elementary' OR
ISNULL(LS.Location_Category_Description, '') = 'Junior High-Intermediate-Middle' OR
ISNULL(LS.Location_Category_Description, '') = 'K-8') THEN LS.Community_School_Sup_Name WHEN (ISNULL(LS.Location_Category_Description, '') 
= 'High school') THEN LS.HighSchool_Network_Superintendent WHEN (ISNULL(LS.Location_Category_Description, '') 
 = 'Collaborative or Multi-graded' OR
 ISNULL(LS.Location_Category_Description, '') = 'Ungraded') THEN '' WHEN (ISNULL(LS.Location_Category_Description, '') = 'Secondary School' OR
 ISNULL(LS.Location_Category_Description, '') = 'K-12 all grades') THEN CASE WHEN (ISNULL(LS.HighSchool_Network_Superintendent, '') = '') 
 THEN LS.Community_School_Sup_Name ELSE LS.HighSchool_Network_Superintendent END END) AS Superintendent, 
(CASE WHEN (ISNULL(LS.Location_Category_Description, '') = 'Early Childhood' OR
 ISNULL(LS.Location_Category_Description, '') = 'Elementary' OR
ISNULL(LS.Location_Category_Description, '') = 'Junior High-Intermediate-Middle' OR
 ISNULL(LS.Location_Category_Description, '') = 'K-8') THEN LS.Community_School_Sup_Email WHEN (ISNULL(LS.Location_Category_Description, '') 
 = 'High school') THEN LS.HighSchool_Network_Superintendent_Email WHEN (ISNULL(LS.Location_Category_Description, '') 
 = 'Collaborative or Multi-graded' OR
 ISNULL(LS.Location_Category_Description, '') = 'Ungraded') THEN '' WHEN (ISNULL(LS.Location_Category_Description, '') = 'Secondary School' OR
 ISNULL(LS.Location_Category_Description, '') = 'K-12 all grades') THEN CASE WHEN (ISNULL(LS.HighSchool_Network_Superintendent_Email, '') = '') 
 THEN LS.Community_School_Sup_Email ELSE LS.HighSchool_Network_Superintendent_Email END END) AS [Superintendent Email]
FROM         dbo.ISS_tblLookUp_LocationSupertable AS LS
WHERE     Fiscal_Year = (SELECT sFiscalYear as sFyscalYear FROM dbo.ISS_tblLCGMS_FiscalYear WHERE (bIsCurrent = 'Y'))


DELETE FROM [dbo].[ISS_tblSuperintendents] WHERE ISNULL([NAME],'') ='' 

DELETE FROM [dbo].[ISS_tblSuperintendents] WHERE UPPER([Name])=UPPER('Contact Superintendent')

END


--Variables for this Package:

Name			Scope																		Data type			Value
PackageID		Package 04_Get School Dimensional Data from Supertable to SWHUB 			Int32				4


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
VALUES (4,'Package 04_Get School Dimensional Data from Supertable to SWHUB')