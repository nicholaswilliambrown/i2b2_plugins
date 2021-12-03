/*******************
* 
* i2b2 familial Relationships plugin 
* Ontology cell database script
*
* This script will add the required stored procedure and concepts for familial relationships
* and will configure the CRC plugin.
* 
* Run this script in your i2b2 CRC database (i2b2demodata for a default i2b2 install)
*
* Note: You will need to change the command line and working folder paths on lines 22 and 23
*
*********************/

declare @PluginID int
select @PluginID = isnull(max(PLUGIN_ID), 0) + 1 from .[dbo].[QT_ANALYSIS_PLUGIN]
insert into [dbo].[QT_ANALYSIS_PLUGIN] (PLUGIN_ID, PLUGIN_NAME, DESCRIPTION, VERSION_CD, COMMAND_LINE, WORKING_FOLDER, STATUS_CD, GROUP_ID)
values (@PluginID, 
		'Familial_Relationship',  
		'Familial_Relationship', 
		'1.0', 
		'e:/i2b2/wildfly-10.0.0.Final/standalone/analysis_commons_launcher/bin/runSql.bat -sql=Plugin_Create_Relationship_Patient_Set', 
		'e:/i2b2/wildfly-10.0.0.Final/standalone/analysis_commons_launcher/bin', 
		'A', 
		'@')


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].Plugin_Create_Relationship_Patient_Set
	@QueryInstanceID int = null,
	@projectID varchar(max) = null,
	@domainID varchar(max) = null,
	@userID varchar(max) = null,
	@instanceID varchar(max) = null
	
AS 

BEGIN 
	if @instanceID is not null
	BEGIN
		select @instanceID = REPLACE(@instanceID, '-instanceID=', '')
		set @QueryInstanceID = cast(@instanceID as int)
	END

	Declare @QueryMasterID int, @ResultInstanceID int
	select @QueryMasterID = QUERY_MASTER_ID from [dbo].[QT_QUERY_INSTANCE] where QUERY_INSTANCE_ID = @QueryInstanceID
	select @ResultInstanceID = RESULT_INSTANCE_ID from [dbo].[QT_QUERY_RESULT_INSTANCE] where QUERY_INSTANCE_ID = @QueryInstanceID
	declare @QueryName varchar(250) = 'Test Query'
	declare @PatientSetCount int
	declare @ResultInstanceID1 int, @ResultInstanceID2 int, @ConceptCD varchar(50)

	declare @x xml 
	select @x = cast(request_xml as xml) from [dbo].[QT_QUERY_MASTER] where QUERY_MASTER_ID = @QueryMasterID
	;WITH XMLNAMESPACES ('http://www.i2b2.org/xsd/cell/crc/psm/analysisdefinition/1.1/' AS ns)
		select @ResultInstanceID1 = nref.value('param[@column="resultInstanceID1"][1]', 'int'),
		@ResultInstanceID2 = nref.value('param[@column="resultInstanceID2"][1]', 'int') ,
		@ConceptCD = nref.value('param[@column="relationshipType"][1]', 'varchar(250)') ,
		@QueryName = nref.value('param[@column="queryName"][1]', 'varchar(250)') 
		from @x.nodes('//ns:analysis_definition/crc_analysis_input_param[1]') as R(nref)

	select distinct b.Patient_num into #patients from [QT_PATIENT_SET_COLLECTION] a join 
		[OBSERVATION_FACT] b on a.RESULT_INSTANCE_ID = @ResultInstanceID1 and a.PATIENT_NUM = b.PATIENT_NUM and b.CONCEPT_CD = @ConceptCD
		join [QT_PATIENT_SET_COLLECTION] c on c.RESULT_INSTANCE_ID = @ResultInstanceID2 and b.NVAL_NUM = c.PATIENT_NUM

	insert into QT_PATIENT_SET_COLLECTION (RESULT_INSTANCE_ID, SET_INDEX, PATIENT_NUM)
	select @ResultInstanceID, row_number() over(order by PATIENT_NUM), PATIENT_NUM from #patients
	select @PatientSetCount = @@ROWCOUNT

	update [dbo].[QT_QUERY_MASTER] set 
		NAME = @QueryName
		where QUERY_MASTER_ID = @QueryMasterID

	update [dbo].[QT_QUERY_RESULT_INSTANCE] set
		RESULT_TYPE_ID = (select top 1 RESULT_TYPE_ID from [dbo].[QT_QUERY_RESULT_TYPE] where Name = 'PATIENTSET'),
		SET_SIZE = (select count (*) from #patients),
		END_DATE = GETDATE(),
		STATUS_TYPE_ID = (select STATUS_TYPE_ID from [dbo].[QT_QUERY_STATUS_TYPE] where NAME = 'FINISHED'),
		MESSAGE = '',
		DESCRIPTION = 'Patient Set for ' + @QueryName,
		REAL_SET_SIZE = (select count (*) from #patients),
		OBFUSC_METHOD = ''
		where RESULT_INSTANCE_ID = @ResultInstanceID

	update [dbo].[QT_QUERY_INSTANCE] set
		END_DATE = GETDATE(),
		STATUS_TYPE_ID = (select STATUS_TYPE_ID from [dbo].[QT_QUERY_STATUS_TYPE] where NAME = 'FINISHED'),
		MESSAGE = ''
		where QUERY_INSTANCE_ID = @QueryInstanceID

	Insert into [dbo].[QT_XML_RESULT] ([RESULT_INSTANCE_ID],[XML_VALUE])
		values (@ResultInstanceID, '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
										<ns10:i2b2_result_envelope xmlns:ns6="http://www.i2b2.org/xsd/cell/crc/psm/querydefinition/1.1/" xmlns:ns5="http://www.i2b2.org/xsd/hive/msg/1.1/" xmlns:ns8="http://www.i2b2.org/xsd/cell/pm/1.1/" xmlns:ns7="http://www.i2b2.org/xsd/cell/crc/psm/analysisdefinition/1.1/" xmlns:ns9="http://www.i2b2.org/xsd/cell/ont/1.1/" xmlns:ns10="http://www.i2b2.org/xsd/hive/msg/result/1.1/" xmlns:ns2="http://www.i2b2.org/xsd/hive/pdo/1.1/" xmlns:ns4="http://www.i2b2.org/xsd/cell/crc/psm/1.1/" xmlns:ns3="http://www.i2b2.org/xsd/cell/crc/pdo/1.1/">
											<body>
												<ns10:result name="PATIENT_COUNT_XML">
													<data type="int" column="patient_count">' + cast(@PatientSetCount as varchar(50)) + '</data>
												</ns10:result>
											</body>
										</ns10:i2b2_result_envelope>')

END
GO


insert into CONCEPT_DIMENSION (CONCEPT_PATH, CONCEPT_CD, NAME_CHAR, CONCEPT_BLOB, SOURCESYSTEM_CD)
values ('\i2b2\Familial Relationship\Has Child in Database\', 'FAMREL:HasChildinDatabase', 'Has Child in Database', '', 'Family_relationship')
insert into CONCEPT_DIMENSION (CONCEPT_PATH, CONCEPT_CD, NAME_CHAR, CONCEPT_BLOB, SOURCESYSTEM_CD)
values ('\i2b2\Familial Relationship\Has Mother in Database\', 'FAMREL:HasMotherinDatabase', 'Has Mother in Database', '', 'Family_relationship')
insert into CONCEPT_DIMENSION (CONCEPT_PATH, CONCEPT_CD, NAME_CHAR, CONCEPT_BLOB, SOURCESYSTEM_CD)
values ('\i2b2\Familial Relationship\Has Father in Database\', 'FAMREL:HasFatherinDatabase', 'Has Father in Database', '', 'Family_relationship')
insert into CONCEPT_DIMENSION (CONCEPT_PATH, CONCEPT_CD, NAME_CHAR, CONCEPT_BLOB, SOURCESYSTEM_CD)
values ('\i2b2\Familial Relationship\Has Spouce in Database\', 'FAMREL:HasSpouceinDatabase', 'Has Spouce in Database', '', 'Family_relationship')
insert into CONCEPT_DIMENSION (CONCEPT_PATH, CONCEPT_CD, NAME_CHAR, CONCEPT_BLOB, SOURCESYSTEM_CD)
values ('\i2b2\Familial Relationship\Has Sibling in Database\', 'FAMREL:HasSiblinginDatabase', 'Has Sibling in Database', '', 'Family_relationship')
insert into CONCEPT_DIMENSION (CONCEPT_PATH, CONCEPT_CD, NAME_CHAR, CONCEPT_BLOB, SOURCESYSTEM_CD)
values ('\i2b2\Familial Relationship\Has Sibling in Database\Has Twin in Database\', 'FAMREL:HasTwininDatabase', 'Has Twin in Database', '', 'Family_relationship')
insert into CONCEPT_DIMENSION (CONCEPT_PATH, CONCEPT_CD, NAME_CHAR, CONCEPT_BLOB, SOURCESYSTEM_CD)
values ('\i2b2\Familial Relationship\Has Sibling in Database\Has Twin in Database\Has Fraternal Twin in Database\', 'FAMREL:HasFraternalTwininDatabase', 'Has Fraternal Twin in Database', '', 'Family_relationship')
insert into CONCEPT_DIMENSION (CONCEPT_PATH, CONCEPT_CD, NAME_CHAR, CONCEPT_BLOB, SOURCESYSTEM_CD)
values ('\i2b2\Familial Relationship\Has Sibling in Database\Has Twin in Database\Has Identical Twin in Database\', 'FAMREL:HasIdenticalTwininDatabase', 'Has Identical Twin in Database', '', 'Family_relationship')

--delete from CONCEPT_DIMENSION where SOURCESYSTEM_CD = 'Family_relationship'