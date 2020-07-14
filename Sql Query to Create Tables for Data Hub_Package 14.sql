--EST_To delete all labels whose expiration dates are lower than the current date
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
DELETE FROM [dbo].[ISS_tblTeacherProfileLabels] WHERE ExpirationDate<GETDATE()

--Sequence Container 31
--EST_Archive WC Members
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- Archive : Wellness Council Members
INSERT INTO ISS_tblTeacherProfileLabels_Archive(sEISID,nComponentID,sEmployeeNo,InAccurate_Flag,LastModifiedDate)
  SELECT TPL.sEISID,TPL.nComponentID,TPL.sEmployeeNo,TPL.InAccurate_Flag,GETDATE() FROM ISS_tblTeacherProfileLabels TPL INNER JOIN ISS_tblTeacherLabelsLookUp TLL ON TPL.nComponentID = TLL.nComponentID
  WHERE TLL.Is_Active = 'Y' AND TLL.Is_AutoRefresh_Flag = 'Y' AND TLL.nComponentID IN (54,55,56,57) AND
  TPL.sEmployeeNo IS NOT NULL AND (TPL.InAccurate_Flag IS NULL OR TPL.InAccurate_Flag = 'U')
  AND (CONVERT(VARCHAR,TPL.sEmployeeNo,15) + '-' + CONVERT(VARCHAR,TPL.nComponentID,5)) NOT IN (SELECT CONVERT(VARCHAR,sEmployeeNo,15) + '-' + CONVERT(VARCHAR,nComponentID,5) AS sKey FROM ISS_tblTeacherProfileLabels_Archive)


--EST_Temporarily Archive WC Members into Staging table
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- Archive : Temporarily archive Wellness Council Members into a staging table whose InAccurate_Flag IS "NOT NULL" OR [ExpirationDate] IS "NOT NULL" 
INSERT INTO ISS_tblTeacherProfileLabels_Staging(sEISID,nComponentID,sEmployeeNo,InAccurate_Flag,LastModifiedDate,ExpirationDate)
SELECT sEISID,nComponentID,sEmployeeNo,InAccurate_Flag,[LastModifiedDate],[ExpirationDate] FROM ISS_tblTeacherProfileLabels
WHERE (nComponentID IN (54,55,56,57) AND InAccurate_Flag IS NOT NULL) OR (nComponentID IN (54,55,56,57) AND [ExpirationDate] IS NOT NULL) 

--DFT_To get Wellness Council Members Dataset into a Staging table
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL Command text: 
EXEC usp_WC_GetWellnessCouncilMember

--Stored procedure creation
USE [ISS_EXT]
GO

/****** Object:  StoredProcedure [dbo].[usp_WC_GetWellnessCouncilMember]    Script Date: 12/5/2019 11:59:31 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[usp_WC_GetWellnessCouncilMember]
AS
	BEGIN
		DECLARE @WCYearID INT
		SELECT @WCYearID = WCYearId FROM WC_Admin WHERE GETDATE() BETWEEN StartDate AND EndDate
		
		SELECT WC.EmployeeNumber, WC.Aduid,WC.TeacherLabel,CAST(WC.TeacherLabelId AS INT) AS TeacherLabelId,FirstName,LastName,WCYearId FROM (

		SELECT TAU.sEmployeeNo AS EmployeeNumber, WCM.Aduid
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
		  ,WCM.FName AS FirstName,WCM.LName AS LastName,WCM.WCYearId
		FROM WC_members WCM INNER JOIN ISS_tblADUsers TAU ON WCM.Aduid = TAU.sUserID
		WHERE WCM.[Delete] = 0 AND WCM.ActiveYear IS NOT NULL
						)wc
        ORDER BY WC.FirstName,WC.LastName
		--Old
		--SELECT TAU.sEmployeeNo AS EmployeeNumber, WCM.Aduid
		--,CASE WHEN CONVERT(VARCHAR,WCM.MentorLeader,10) = '1' AND WCM.ActiveYear = @WCYearID THEN 'Wellness Council Champion (current)' 
		--	  WHEN CONVERT(VARCHAR,WCM.MentorLeader,10) = '1' AND WCM.ActiveYear <> @WCYearID THEN 'Wellness Council Champion (former)' 
		--	  WHEN CONVERT(VARCHAR,WCM.MentorLeader,10) <> '1' AND WCM.ActiveYear = @WCYearID THEN 'Wellness Council Member (current)' 
		--	  WHEN CONVERT(VARCHAR,WCM.MentorLeader,10) <> '1' AND WCM.ActiveYear <> @WCYearID THEN 'Wellness Council Member (former)' 
		--  END AS TeacherLabel
		--  ,CASE WHEN CONVERT(VARCHAR,WCM.MentorLeader,10) = '1' AND WCM.ActiveYear = @WCYearID THEN 54
		--	  WHEN CONVERT(VARCHAR,WCM.MentorLeader,10) = '1' AND WCM.ActiveYear <> @WCYearID THEN 55
		--	  WHEN CONVERT(VARCHAR,WCM.MentorLeader,10) <> '1' AND WCM.ActiveYear = @WCYearID THEN 56
		--	  WHEN CONVERT(VARCHAR,WCM.MentorLeader,10) <> '1' AND WCM.ActiveYear <> @WCYearID THEN 57
		--  END AS TeacherLabelId		
		--  ,WCM.FName AS FirstName,WCM.LName AS LastName,WCM.WCYearId
		--FROM WC_members WCM INNER JOIN ISS_tblADUsers TAU ON WCM.Aduid = TAU.sUserID
		--WHERE WCM.[Delete] = 0 AND WCM.ActiveYear IS NOT NULL

  --      ORDER BY WCM.FName,WCM.LName
	END

	



GO




--Data Conversion:
Input Column		Output Alias				Data Type			Length
[EmployeeNumber]	EmployeeNumber_Convert		string [DT_STR]		15


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [OSWP_tblOSWPStaff_Staging]
--Table creation code:

CREATE TABLE [dbo].[OSWP_tblOSWPStaff_Staging](
	[sEmployeeNo] [varchar](15) NULL,
	[EmailAlias] [varchar](100) NULL,
	[TeacherLabel] [varchar](100) NULL,
	[TeacherLabelId] [int] NULL
) ON [PRIMARY]

GO


--EST_Delete WC Members
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- For delete : Wellness Council Members
DELETE FROM ISS_tblTeacherProfileLabels 
WHERE nComponentID IN (54,55,56,57)


--DFT_ISS_tblTeacherProfileLabels
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL Command text: 
--INSERT into table ISS_tblTeacherProfileLabels
SELECT DISTINCT WCM.[sEmployeeNo],PeI.[sEISID],WCM.[TeacherLabelId] AS [nComponentID],GETDATE() AS [LastModifiedDate] FROM 
(SELECT * FROM [dbo].[OSWP_tblOSWPStaff_Staging] WHERE [TeacherLabelId] IS NOT NULL) WCM
INNER JOIN (SELECT DISTINCT[sEmployeeNo],[sEISID] FROM [dbo].[ISS_tblPersonalInfo]) PeI ON  WCM.[sEmployeeNo]=PeI.[sEmployeeNo]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_tblTeacherProfileLabels]
--Table creation code:
CREATE TABLE [dbo].[ISS_tblTeacherProfileLabels](
	[sEISID] [varchar](7) NULL,
	[nComponentID] [int] NOT NULL,
	[sEmployeeNo] [varchar](15) NULL,
	[InAccurate_Flag] [char](1) NULL,
	[LastModifiedDate] [datetime] NULL,
	[ExpirationDate] [datetime] NULL
) ON [PRIMARY]

GO

Note: Ignore [InAccurate_Flag],[ExpirationDate] for the mapping


--EST_To update EISID when NULL
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
UPDATE [ISS_tblTeacherProfileLabels]
SET sEISID='NA'
WHERE sEISID IS NULL AND nComponentID IN (54,55,56,57)

--EST_To update InAccurate_Flag and ExpirationDate
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
UPDATE TPL 
SET TPL.[InAccurate_Flag] = TPLS.[InAccurate_Flag], 
TPL.[ExpirationDate]=TPLS.[ExpirationDate]
FROM  [ISS_tblTeacherProfileLabels] TPL
INNER JOIN [ISS_tblTeacherProfileLabels_Staging] TPLS
ON TPL.[sEmployeeNo] = TPLS.[sEmployeeNo] AND TPL.[nComponentID]=TPLS.[nComponentID]

--EST_Delete records from Staging Tables
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
--Delete
DELETE FROM  [dbo].[ISS_tblTeacherProfileLabels_Staging]
GO
DELETE FROM  [dbo].[OSWP_tblOSWPStaff_Staging]
GO


--Sequence Container 41
--EST_Archive Principals
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- Archive : Principal
INSERT INTO ISS_tblTeacherProfileLabels_Archive(sEISID,nComponentID,sEmployeeNo,InAccurate_Flag,LastModifiedDate)
  SELECT TPL.sEISID,TPL.nComponentID,TPL.sEmployeeNo,TPL.InAccurate_Flag,GETDATE() FROM ISS_tblTeacherProfileLabels TPL INNER JOIN ISS_tblTeacherLabelsLookUp TLL ON TPL.nComponentID = TLL.nComponentID
  WHERE TLL.Is_Active = 'Y' AND TLL.Is_AutoRefresh_Flag = 'Y' AND TLL.nComponentID IN (59) AND
  TPL.sEmployeeNo IS NOT NULL AND (TPL.InAccurate_Flag IS NULL OR TPL.InAccurate_Flag = 'U')
  AND (CONVERT(VARCHAR,TPL.sEmployeeNo,15) + '-' + CONVERT(VARCHAR,TPL.nComponentID,5)) NOT IN (SELECT CONVERT(VARCHAR,sEmployeeNo,15) + '-' + CONVERT(VARCHAR,nComponentID,5) AS sKey FROM ISS_tblTeacherProfileLabels_Archive)


--DFT_To get Principals Dataset from Supertable into a Staging table
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL Command text: 
EXEC usp_Autolabel_GetSchoolPrincipals

--Stored procedure creation
USE [ISS_EXT]
GO

/****** Object:  StoredProcedure [dbo].[usp_Autolabel_GetSchoolPrincipals]    Script Date: 12/5/2019 12:05:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_Autolabel_GetSchoolPrincipals]
AS
	BEGIN

		SELECT b.sEmployeeNo AS EmployeeNumber,b.sUserID AS EmailAlias,'Principal' AS TeacherLabel, 59 AS TeacherLabelId,a.Principal_Name,a.Principal_Email
		FROM SUPERLINK.SuperTable.dbo.Location_Supertable1 a
		INNER JOIN ISS_tblADUsers b ON b.sEmail = a.Principal_Email
		WHERE         
			  b.bIsActive = 'A' AND 
			  Status_Code='O' AND System_id='ats'
              AND (a.Fiscal_Year = CASE WHEN month(getdate()) >= '07' THEN year(getdate()) + 1 ELSE year(getdate()) END)
              AND a.Administrative_District_Code IN ('01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32','75') 
--            AND a.Location_Type_Description<>'Transfer School'
              AND a.Location_Type_Description<>'Home School' 
--            AND a.Location_Category_Description<>'Ungraded' 
              AND a.Location_Category_Description<>'Borough' 
              AND a.Location_Category_Description<>'Central-HQ-Citywide' 
              AND substring(a.System_Code,4,3)<>'444' 
              AND substring(a.System_Code,4,3)<>'700'
              AND a.Location_Name <> 'Universal Pre-K C.B.O.'
              AND a.Location_Type_Description <>'Adult'
              AND a.Location_Type_Description <>'Alternative'
              AND a.Location_Type_Description <>'Evening'
              AND a.Location_Type_Description <>'Suspension Center'
              AND a.Location_Type_Description <>'YABC'
              AND a.Grades_Text <>''
              AND a.Location_Name NOT LIKE '%Hospital Schools%'

		--SELECT Z.EmployeeNumber,Replace(Z.email,'@schools.nyc.gov','') AS EmailAlias,'Principal' AS TeacherLabel, 59 AS TeacherLabelId FROM 
		--(SELECT a.System_Code AS dbn, b.[first name] as firstname, b.[last name] as lastname, b.email as email, b.title as title , b.[Employee ID] AS EmployeeNumber,c.sEISId
		--			  FROM SUPERLINK.SuperTable.dbo.Location_Supertable1 a
		--						inner join superlink.supertable.dbo.view_StaffInfo b
		--						left join ISS_tblPersonalInfo c on c.sEmployeeNo=b.[Employee ID]
		--					 on a.system_code=b.dbn
		--					 --inner join iss_ext_tblPersonalinfo c on c.employeeid=a.employeeid
		--					 --inner join iss_ext_tbladusers d on 
		--			  WHERE  (a.Fiscal_Year = CASE WHEN month(getdate()) >= '07' THEN year(getdate()) + 1 ELSE year(getdate()) END) AND (System_ID = 'ats') AND 
		--					 (a.Location_Type_Description IN ('General Academic', 'Special Education', 'Career Technical', 'Transfer School')) AND (a.Status_Code = 'O') AND 
		--					 (a.Administrative_District_Code IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 75)) AND 
		--					 (a.Location_Category_Description <> 'Borough') AND (Location_Category_Description <> 'Central-HQ-Citywide') AND (SUBSTRING(System_Code, 4, 3) <> '444') AND 
		--					 (SUBSTRING(a.System_Code, 4, 3) <> '700') AND (a.Location_Name <> 'Universal Pre-K C.B.O.') AND (a.Location_Type_Description <> 'Home School') AND 
		--					 (a.Location_Type_Description <> 'Adult') AND (a.Location_Type_Description <> 'Alternative') AND (a.Location_Type_Description <> 'Evening') AND 
		--					 (a.Location_Type_Description <> 'Suspension Center') AND (a.Location_Type_Description <> 'YABC') AND (a.Grades_Text <> ''))Z
		END





GO




--Data Conversion:
Input Column		Output Alias				Data Type			Length
[EmployeeNumber]	EmployeeNumber_Convert		string [DT_STR]		15

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [OSWP_tblOSWPStaff_Staging]
--Table creation code:
Table created before


--EST_Delete Principals
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
DELETE FROM ISS_tblTeacherProfileLabels 
WHERE nComponentID=59
   

--DFT_ISS_tblTeacherProfileLabels
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL Command text: 
SELECT DISTINCT a.[sEmployeeNo],b.[sEISID],a.[TeacherLabelId] AS [nComponentID],'V' AS [InAccurate_Flag],GETDATE() AS [LastModifiedDate] FROM [OSWP_tblOSWPStaff_Staging] a
INNER JOIN (SELECT DISTINCT[sEmployeeNo],[sEISID] FROM [dbo].[ISS_tblPersonalInfo]) b ON  a.[sEmployeeNo]=b.[sEmployeeNo] AND a.[TeacherLabelId] IS NOT NULL


--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_tblTeacherProfileLabels]
--Table creation code:
Table created before

Note: Ignore [ExpirationDate] for the mapping


--EST_To update EISID when NULL
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
UPDATE [ISS_tblTeacherProfileLabels]
SET sEISID='NA'
WHERE sEISID IS NULL AND nComponentID=59


--EST_Delete records from Staging Tables
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
--Delete
DELETE FROM  [dbo].[OSWP_tblOSWPStaff_Staging]
GO


--Sequence Container 51
--EST_Archive OSWP Staff
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- Archive : OSWP staff
INSERT INTO ISS_tblTeacherProfileLabels_Archive(sEISID,nComponentID,sEmployeeNo,InAccurate_Flag,LastModifiedDate)
  SELECT TPL.sEISID,TPL.nComponentID,TPL.sEmployeeNo,TPL.InAccurate_Flag,GETDATE() FROM ISS_tblTeacherProfileLabels TPL INNER JOIN ISS_tblTeacherLabelsLookUp TLL ON TPL.nComponentID = TLL.nComponentID
  WHERE TLL.Is_Active = 'Y' AND TLL.Is_AutoRefresh_Flag = 'Y' AND TLL.nComponentID=60 AND
  TPL.sEmployeeNo IS NOT NULL AND (TPL.InAccurate_Flag IS NULL OR TPL.InAccurate_Flag = 'U')
  AND (CONVERT(VARCHAR,TPL.sEmployeeNo,15) + '-' + CONVERT(VARCHAR,TPL.nComponentID,5)) NOT IN (SELECT CONVERT(VARCHAR,sEmployeeNo,15) + '-' + CONVERT(VARCHAR,nComponentID,5) AS sKey FROM ISS_tblTeacherProfileLabels_Archive)



--DFT_To get OSWP Staff Members Dataset into a Staging table
--OLE DB Source
--OLEDB Connection Manager: ES11VDSTARSQL01.Active_Directory.OSWPUser
--Data access mode: SQL Command
--SQL Command text: 
SELECT DISTINCT AD.employeeID AS EmployeeNumber,AD.mailNickname AS EmailAlias,'OSWP Staff' AS TeacherLabel, 60 AS TeacherLabelId
FROM memberGROUPS MG INNER JOIN ACTIVE_DATA AD ON AD.distinguishedName = MG.member
WHERE MG.cn = 'OfficeofSchoolWellnessProgramsStaff' AND AD.employeeID IS NOT NULL ORDER BY AD.mailNickname



--Data Conversion:
Input Column		Output Alias				Data Type							Length
[EmployeeNumber]	EmployeeNumber_Convert		string [DT_STR]						15
[EmailAlias]		EmailAlias_Convert			string [DT_STR]						100
[TeacherLabel]		TeacherLabel_Convert		string [DT_STR]						100
[TeacherLabelId]	TeacherLabelId_Convert		four-byte signed integer9DT_I4]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [OSWP_tblOSWPStaff_Staging]
--Table creation code:
Table created before


--EST_Delete OSWP Staff
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- For delete : OSWP staff
DELETE FROM ISS_tblTeacherProfileLabels 
WHERE nComponentID=60  

--DFT_ISS_tblTeacherProfileLabels
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL Command text: 
SELECT DISTINCT a.[sEmployeeNo],b.[sEISID],a.[TeacherLabelId] AS [nComponentID],'V' AS [InAccurate_Flag],GETDATE() AS [LastModifiedDate] FROM [OSWP_tblOSWPStaff_Staging] a
INNER JOIN (SELECT DISTINCT[sEmployeeNo],[sEISID] FROM [dbo].[ISS_tblPersonalInfo]) b ON  a.[sEmployeeNo]=b.[sEmployeeNo] AND a.[TeacherLabelId] IS NOT NULL

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_tblTeacherProfileLabels]
--Table creation code:
Table created before

Note: Ignore [ExpirationDate] for the mapping


--EST_To update EISID when NULL
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
UPDATE [ISS_tblTeacherProfileLabels]
SET sEISID='NA'
WHERE sEISID IS NULL AND nComponentID=60

--EST_Delete records from Staging Tables

Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
DELETE FROM  [dbo].[OSWP_tblOSWPStaff_Staging]
GO

--Sequence Container 61
--EST_Archive Event Participants
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- Archive : Event Participants
INSERT INTO ISS_tblTeacherProfileLabels_Archive(sEISID,nComponentID,sEmployeeNo,InAccurate_Flag,LastModifiedDate)
  SELECT TPL.sEISID,TPL.nComponentID,TPL.sEmployeeNo,TPL.InAccurate_Flag,GETDATE() FROM ISS_tblTeacherProfileLabels TPL INNER JOIN ISS_tblTeacherLabelsLookUp TLL ON TPL.nComponentID = TLL.nComponentID
  WHERE TLL.Is_Active = 'Y' AND TLL.Is_AutoRefresh_Flag = 'Y' AND TLL.nComponentID IN (6,7,27,28,32,33,40,46,47,67,71,72) AND
  TPL.sEmployeeNo IS NOT NULL AND (TPL.InAccurate_Flag IS NULL OR TPL.InAccurate_Flag = 'U')
  AND (CONVERT(VARCHAR,TPL.sEmployeeNo,15) + '-' + CONVERT(VARCHAR,TPL.nComponentID,5)) NOT IN (SELECT CONVERT(VARCHAR,sEmployeeNo,15) + '-' + CONVERT(VARCHAR,nComponentID,5) AS sKey FROM ISS_tblTeacherProfileLabels_Archive)

--EST_Temporarily Archive Event Participants into Staging table
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- Archive : Temporarily archive Event Participants into a staging table [ISS_tblTeacherProfileLabels_Staging] whose InAccurate_Flag IS "NOT NULL" OR [ExpirationDate] IS "NOT NULL" 
INSERT INTO ISS_tblTeacherProfileLabels_Staging(sEISID,nComponentID,sEmployeeNo,InAccurate_Flag,LastModifiedDate,ExpirationDate)
SELECT sEISID,nComponentID,sEmployeeNo,InAccurate_Flag,[LastModifiedDate],[ExpirationDate] FROM ISS_tblTeacherProfileLabels
WHERE (nComponentID IN (6,7,27,28,32,33,40,46,47,67,71,72) AND InAccurate_Flag IS NOT NULL) OR (nComponentID IN (6,7,27,28,32,33,40,46,47,67,71,72) AND [ExpirationDate] IS NOT NULL) 



--DFT_To get Wellness Event Participants Dataset into a Staging table
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL Command text: 
--To get Event Participants into a Staging table [OSWP_tblOSWPStaff_Staging]
EXEC usp_OSWP_WellnessEventParticipants

--Stored procedure creation
USE [ISS_EXT]
GO

/****** Object:  StoredProcedure [dbo].[usp_OSWP_WellnessEventParticipants]    Script Date: 12/5/2019 12:16:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_OSWP_WellnessEventParticipants]
AS
	BEGIN
		--SELECT TEP.sParticipant AS EmployeeNumber, TAU.sUserID AS Aduid,'CONDOM AVAILABILITY PROGRAM (CAP) TRAINING' AS TeacherLabel,40 AS TeacherLabelId
		
		
		----CASE WHEN TPE.sEventName = 'CONDOM AVAILABILITY PROGRAM (CAP) TRAINING' THEN 'CAP Trained'
		----	 WHEN TPE.sEventName = 'Physical Best' THEN 'Physical Best Trained'
		---- END AS TeacherLabel,


		-- --CASE WHEN TPE.sEventName = 'CONDOM AVAILABILITY PROGRAM (CAP) TRAINING' THEN 40
		--	--  WHEN TPE.sEventName = 'Physical Best' THEN 28
		-- --END AS TeacherLabelId



		--FROM ISS_tblEventParticipants TEP LEFT JOIN ISS_tblADUsers TAU ON TEP.sParticipant = TAU.sEmployeeNo
		--INNER JOIN ISS_tblProgramEvents TPE ON TEP.nEventId = TPE.nEventId
		--WHERE TPE.sEventName = 'CONDOM AVAILABILITY PROGRAM (CAP) TRAINING' AND TEP.sType = 'E'

		--UNION ALL

		--SELECT TEP.sParticipant AS EmployeeNumber, TAU.sUserID AS Aduid, 'Physical Best Trained' AS TeacherLabel,28 AS TeacherLabelId
		
		----CASE WHEN TPE.sEventName = 'CONDOM AVAILABILITY PROGRAM (CAP) TRAINING' THEN 'CAP Trained'
		----	 WHEN TPE.sEventName = 'Physical Best' THEN 'Physical Best Trained'
		---- END AS TeacherLabel,

		-- --CASE WHEN TPE.sEventName = 'CONDOM AVAILABILITY PROGRAM (CAP) TRAINING' THEN 40
		--	--  WHEN TPE.sEventName = 'Physical Best' THEN 28
		-- --END AS TeacherLabelId

		--FROM ISS_tblEventParticipants TEP LEFT JOIN ISS_tblADUsers TAU ON TEP.sParticipant = TAU.sEmployeeNo
		--INNER JOIN ISS_tblProgramEvents TPE ON TEP.nEventId = TPE.nEventId
		--WHERE TPE.sEventName LIKE 'Physical Best%' AND TEP.sType = 'E'


		--SELECT 
		--	TAU.sEmployeeNo AS EmployeeNumber,
		--	TAU.sUserID AS Aduid, 
		--	'Physical Best Trained' AS TeacherLabel,
		--	28 AS TeacherLabelId
		--FROM ISS_tblEventParticipants TEP INNER JOIN ISS_tblADUsers TAU ON TEP.sParticipant = TAU.sUserID
		--	INNER JOIN ISS_tblProgramEvents TPE ON TEP.nEventId = TPE.nEventId
		--WHERE TPE.sEventName LIKE '%Physical Best%' AND TEP.sType IN ('S','U') AND TAU.sEmployeeNo IS NOT NULL 

		--UNION ALL

		--SELECT 
		--	TAU.sEmployeeNo AS EmployeeNumber,
		--	TAU.sUserID AS Aduid,
		--	'CONDOM AVAILABILITY PROGRAM (CAP) TRAINING' AS TeacherLabel,
		--	40 AS TeacherLabelId
		--FROM ISS_tblEventParticipants TEP INNER JOIN ISS_tblADUsers TAU ON TEP.sParticipant = TAU.sUserID
		--	INNER JOIN ISS_tblProgramEvents TPE ON TEP.nEventId = TPE.nEventId
		--WHERE TPE.sEventName LIKE '%(CAP)%' AND TEP.sType IN ('S','U') AND TAU.sEmployeeNo IS NOT NULL 

		--UNION ALL

		--SELECT 
		--	TAU.sEmployeeNo AS EmployeeNumber, 
		--	TAU.sUserID AS Aduid, 
		--	'BFS Trained' AS TeacherLabel,
		--	71 AS TeacherLabelId
		--FROM ISS_tblEventParticipants TEP INNER JOIN ISS_tblADUsers TAU ON TEP.sParticipant = TAU.sUserID
		--	INNER JOIN ISS_tblProgramEvents TPE ON TEP.nEventId = TPE.nEventId
		--WHERE TPE.sEventName LIKE '%Bigger%' AND TEP.sType IN ('S','U') AND TAU.sEmployeeNo IS NOT NULL 

		--UNION ALL

		--SELECT 
		--	TAU.sEmployeeNo AS EmployeeNumber, 
		--	TAU.sUserID AS Aduid, 
		--	'HIV/AIDS PD' AS TeacherLabel,
		--	32 AS TeacherLabelId
		--FROM ISS_tblEventParticipants TEP INNER JOIN ISS_tblADUsers TAU ON TEP.sParticipant = TAU.sUserID
		--	INNER JOIN ISS_tblProgramEvents TPE ON TEP.nEventId = TPE.nEventId
		--WHERE TPE.sEventName LIKE '%HIV%' AND TEP.sType IN ('S','U') AND TAU.sEmployeeNo IS NOT NULL 

		SELECT P.sEmployeeNo AS EmployeeNumber,P.sParticipant AS Aduid,'Event Participant' AS TeacherLabel,
		CONVERT(INT,E.Related_Label_ID) AS TeacherLabelId
		FROM ISS_tblEventParticipants P INNER JOIN ISS_tblProgramEvents E ON E.nEventId = P.nEventId
		INNER JOIN ISS_tblTeacherLabelsLookUp T ON T.nComponentID = E.Related_Label_ID

		WHERE P.sEmployeeNo IS NOT NULL AND P.sType = 'U' AND P.Participant_Status = 26 AND E.Related_Label_ID IS NOT NULL

	END



GO





--Data Conversion:
Input Column		Output Alias				Data Type			Length
[AduId]				AduId_Convert				string [DT_STR]		50

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [OSWP_tblOSWPStaff_Staging]
--Table creation code:
Table created before


--EST_DeleteEvent Participants
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
-- For delete : Delete Event Participants from [ISS_tblTeacherProfileLabels] table
DELETE FROM ISS_tblTeacherProfileLabels 
WHERE nComponentID IN (6,7,27,28,32,33,40,46,47,67,71,72)


--DFT_ISS_tblTeacherProfileLabels
--OLE DB Source
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: SQL Command
--SQL Command text: 
--INSERT Event Participants into table [ISS_tblTeacherProfileLabels]
SELECT DISTINCT EP.[sEmployeeNo],PeI.[sEISID],EP.[TeacherLabelId] AS [nComponentID],GETDATE() AS [LastModifiedDate] FROM 
(SELECT * FROM [dbo].[OSWP_tblOSWPStaff_Staging] WHERE [TeacherLabelId] IS NOT NULL)EP
INNER JOIN (SELECT DISTINCT[sEmployeeNo],[sEISID] FROM [dbo].[ISS_tblPersonalInfo]) PeI ON  EP.[sEmployeeNo]=PeI.[sEmployeeNo]

--OLE DB Destination
--OLEDB Connection Manager: ES11VDEXTESQL01.ISS_EXT.useriss
--Data access mode: Table or view-fast load
--Name of the table or the view: [ISS_tblTeacherProfileLabels]
--Table creation code:
Table created before

Note: Ignore [InAccurate_Flag],[ExpirationDate] for the mapping


--EST_To update EISID when NULL
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
--UPDATES
UPDATE [ISS_tblTeacherProfileLabels]
SET sEISID='NA'
WHERE sEISID IS NULL AND nComponentID IN (6,7,27,28,32,33,40,46,47,67,71,72)


--EST_To update InAccurate_Flag and ExpirationDate
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
--UPDATES table [ISS_tblTeacherProfileLabels] with data from table [ISS_tblTeacherProfileLabels_Staging]
UPDATE TPL 
SET TPL.[InAccurate_Flag] = TPLS.[InAccurate_Flag], 
TPL.[ExpirationDate]=TPLS.[ExpirationDate]
FROM  [ISS_tblTeacherProfileLabels] TPL
INNER JOIN [ISS_tblTeacherProfileLabels_Staging] TPLS
ON TPL.[sEmployeeNo] = TPLS.[sEmployeeNo] AND TPL.[nComponentID]=TPLS.[nComponentID];


--EST_Delete records from Staging Tables
Connection: ES11VDEXTESQL01.ISS_EXT.useriss
SQL Statement:
--Delete
DELETE FROM  [dbo].[ISS_tblTeacherProfileLabels_Staging]
GO
DELETE FROM  [dbo].[OSWP_tblOSWPStaff_Staging]
GO




--Variables for this Package:

Name			Scope								Data type			Value
PackageID		Package 14_OSWPAutolabel_1			Int32				14


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
VALUES (14,'Package 14_OSWPAutolabel_1')


