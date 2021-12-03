/*******************
* 
* i2b2 familial Relationships plugin 
* Ontology cell database script
*
* This script will create ontology terms for Familial Relationship data
* 
* Run this script in your i2b2 ontology database (i2b2metadata for a default i2b2 install)
*
*********************/


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FamilialRelationship](
	[C_HLEVEL] [int] NOT NULL,
	[C_FULLNAME] [varchar](700) NOT NULL,
	[C_NAME] [varchar](2000) NOT NULL,
	[C_SYNONYM_CD] [char](1) NOT NULL,
	[C_VISUALATTRIBUTES] [char](3) NOT NULL,
	[C_TOTALNUM] [int] NULL,
	[C_BASECODE] [varchar](50) NULL,
	[C_METADATAXML] [text] NULL,
	[C_FACTTABLECOLUMN] [varchar](50) NOT NULL,
	[C_TABLENAME] [varchar](50) NOT NULL,
	[C_COLUMNNAME] [varchar](50) NOT NULL,
	[C_COLUMNDATATYPE] [varchar](50) NOT NULL,
	[C_OPERATOR] [varchar](10) NOT NULL,
	[C_DIMCODE] [varchar](700) NOT NULL,
	[C_COMMENT] [text] NULL,
	[C_TOOLTIP] [varchar](900) NULL,
	[M_APPLIED_PATH] [varchar](700) NOT NULL,
	[UPDATE_DATE] [datetime] NOT NULL,
	[DOWNLOAD_DATE] [datetime] NULL,
	[IMPORT_DATE] [datetime] NULL,
	[SOURCESYSTEM_CD] [varchar](50) NULL,
	[VALUETYPE_CD] [varchar](50) NULL,
	[M_EXCLUSION_CD] [varchar](25) NULL,
	[C_PATH] [varchar](700) NULL,
	[C_SYMBOL] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
--select * from [dbo].[FamilialRelationship]



insert into [dbo].[TABLE_ACCESS] (C_TABLE_CD, C_TABLE_NAME, C_PROTECTED_ACCESS, C_HLEVEL, C_FULLNAME, C_NAME, C_SYNONYM_CD, C_VISUALATTRIBUTES,
									C_FACTTABLECOLUMN, C_DIMTABLENAME, C_COLUMNNAME, C_COLUMNDATATYPE, C_OPERATOR, C_DIMCODE, C_TOOLTIP)
values ('FAMREL', 'FamilialRelationship', 'N', '1', '\i2b2\Familial Relationship\', 'Familial Relationship', 'N', 'FA', 'concept_cd', 'concept_dimension', 'concept_path', 'T', 'LIKE', '\i2b2\Familial Relationship\', 'Familial Relationship')

insert into [dbo].[FamilialRelationship] (C_HLEVEL, C_FULLNAME, C_NAME, C_SYNONYM_CD, C_VISUALATTRIBUTES, C_FACTTABLECOLUMN, C_TABLENAME, C_COLUMNNAME, C_COLUMNDATATYPE, 
										C_OPERATOR, C_DIMCODE, C_TOOLTIP, M_APPLIED_PATH, UPDATE_DATE, DOWNLOAD_DATE, IMPORT_DATE, SOURCESYSTEM_CD)
select 1, '\i2b2\Familial Relationship\', 'Familial Relationship', 'N', 'CA', 'concept_cd', 'concept_dimension', 'concept_path', 'T', 'LIKE', '\i2b2\Familial Relationship\',
	'Familial Relationship', '@', getdate(), getdate(), getdate(), 'Family_relationship'

insert into [dbo].[FamilialRelationship] (C_HLEVEL, C_FULLNAME, C_NAME, C_SYNONYM_CD, C_VISUALATTRIBUTES, C_BASECODE, C_FACTTABLECOLUMN, C_TABLENAME, C_COLUMNNAME, C_COLUMNDATATYPE, C_OPERATOR, C_DIMCODE, C_TOOLTIP, M_APPLIED_PATH, UPDATE_DATE, DOWNLOAD_DATE, IMPORT_DATE, SOURCESYSTEM_CD)
select 2, '\i2b2\Familial Relationship\Has Child in Database\', 'Has Child in Database', 'N', 'LA', 'FAMREL:HasChildinDatabase', 'concept_cd', 'concept_dimension', 'concept_path', 'T', 'LIKE', '\i2b2\Familial Relationship\Has Child in Database\', 'Has Child in Database', '@', getdate(), getdate(), getdate(), 'Family_relationship'

insert into [dbo].[FamilialRelationship] (C_HLEVEL, C_FULLNAME, C_NAME, C_SYNONYM_CD, C_VISUALATTRIBUTES, C_BASECODE, C_FACTTABLECOLUMN, C_TABLENAME, C_COLUMNNAME, C_COLUMNDATATYPE, C_OPERATOR, C_DIMCODE, C_TOOLTIP, M_APPLIED_PATH, UPDATE_DATE, DOWNLOAD_DATE, IMPORT_DATE, SOURCESYSTEM_CD)
select 2, '\i2b2\Familial Relationship\Has Mother in Database\', 'Has Mother in Database', 'N', 'LA', 'FAMREL:HasMotherinDatabase', 'concept_cd', 'concept_dimension', 'concept_path', 'T', 'LIKE', '\i2b2\Familial Relationship\Has Mother in Database\', 'Has Mother in Database', '@', getdate(), getdate(), getdate(), 'Family_relationship'

insert into [dbo].[FamilialRelationship] (C_HLEVEL, C_FULLNAME, C_NAME, C_SYNONYM_CD, C_VISUALATTRIBUTES, C_BASECODE, C_FACTTABLECOLUMN, C_TABLENAME, C_COLUMNNAME, C_COLUMNDATATYPE, C_OPERATOR, C_DIMCODE, C_TOOLTIP, M_APPLIED_PATH, UPDATE_DATE, DOWNLOAD_DATE, IMPORT_DATE, SOURCESYSTEM_CD)
select 2, '\i2b2\Familial Relationship\Has Father in Database\', 'Has Father in Database', 'N', 'LA', 'FAMREL:HasFatherinDatabase', 'concept_cd', 'concept_dimension', 'concept_path', 'T', 'LIKE', '\i2b2\Familial Relationship\Has Father in Database\', 'Has Father in Database', '@', getdate(), getdate(), getdate(), 'Family_relationship'

insert into [dbo].[FamilialRelationship] (C_HLEVEL, C_FULLNAME, C_NAME, C_SYNONYM_CD, C_VISUALATTRIBUTES, C_BASECODE, C_FACTTABLECOLUMN, C_TABLENAME, C_COLUMNNAME, C_COLUMNDATATYPE, C_OPERATOR, C_DIMCODE, C_TOOLTIP, M_APPLIED_PATH, UPDATE_DATE, DOWNLOAD_DATE, IMPORT_DATE, SOURCESYSTEM_CD)
select 2, '\i2b2\Familial Relationship\Has Spouce in Database\', 'Has Spouce in Database', 'N', 'LA', 'FAMREL:HasSpouceinDatabase', 'concept_cd', 'concept_dimension', 'concept_path', 'T', 'LIKE', '\i2b2\Familial Relationship\Has Spouce in Database\', 'Spouce Of', '@', getdate(), getdate(), getdate(), 'Family_relationship'

insert into [dbo].[FamilialRelationship] (C_HLEVEL, C_FULLNAME, C_NAME, C_SYNONYM_CD, C_VISUALATTRIBUTES, C_BASECODE, C_FACTTABLECOLUMN, C_TABLENAME, C_COLUMNNAME, C_COLUMNDATATYPE, C_OPERATOR, C_DIMCODE, C_TOOLTIP, M_APPLIED_PATH, UPDATE_DATE, DOWNLOAD_DATE, IMPORT_DATE, SOURCESYSTEM_CD)
select 2, '\i2b2\Familial Relationship\Has Sibling in Database\', 'Has Sibling in Database', 'N', 'FA', 'FAMREL:HasSiblinginDatabase', 'concept_cd', 'concept_dimension', 'concept_path', 'T', 'LIKE', '\i2b2\Familial Relationship\Has Sibling in Database\', 'Has Sibling in Database', '@', getdate(), getdate(), getdate(), 'Family_relationship'

insert into [dbo].[FamilialRelationship] (C_HLEVEL, C_FULLNAME, C_NAME, C_SYNONYM_CD, C_VISUALATTRIBUTES, C_BASECODE, C_FACTTABLECOLUMN, C_TABLENAME, C_COLUMNNAME, C_COLUMNDATATYPE, C_OPERATOR, C_DIMCODE, C_TOOLTIP, M_APPLIED_PATH, UPDATE_DATE, DOWNLOAD_DATE, IMPORT_DATE, SOURCESYSTEM_CD)
select 3, '\i2b2\Familial Relationship\Has Sibling in Database\Has Twin in Database\', 'Has Twin in Database', 'N', 'FA', 'FAMREL:HasTwininDatabase', 'concept_cd', 'concept_dimension', 'concept_path', 'T', 'LIKE', '\i2b2\Familial Relationship\Has Sibling in Database\Has Twin in Database\', 'Has Twin in Database', '@', getdate(), getdate(), getdate(), 'Family_relationship'

insert into [dbo].[FamilialRelationship] (C_HLEVEL, C_FULLNAME, C_NAME, C_SYNONYM_CD, C_VISUALATTRIBUTES, C_BASECODE, C_FACTTABLECOLUMN, C_TABLENAME, C_COLUMNNAME, C_COLUMNDATATYPE, C_OPERATOR, C_DIMCODE, C_TOOLTIP, M_APPLIED_PATH, UPDATE_DATE, DOWNLOAD_DATE, IMPORT_DATE, SOURCESYSTEM_CD)
select 4, '\i2b2\Familial Relationship\Has Sibling in Database\Has Twin in Database\Has Fraternal Twin in Database\', 'Has Fraternal Twin in Database', 'N', 'LA', 'FAMREL:HasFraternalTwininDatabase', 'concept_cd', 'concept_dimension', 'concept_path', 'T', 'LIKE', '\i2b2\Familial Relationship\Has Sibling in Database\Has Twin in Database\Has Fraternal Twin in Database\', 'Has Fraternal Twin in Database', '@', getdate(), getdate(), getdate(), 'Family_relationship'

insert into [dbo].[FamilialRelationship] (C_HLEVEL, C_FULLNAME, C_NAME, C_SYNONYM_CD, C_VISUALATTRIBUTES, C_BASECODE, C_FACTTABLECOLUMN, C_TABLENAME, C_COLUMNNAME, C_COLUMNDATATYPE, C_OPERATOR, C_DIMCODE, C_TOOLTIP, M_APPLIED_PATH, UPDATE_DATE, DOWNLOAD_DATE, IMPORT_DATE, SOURCESYSTEM_CD)
select 4, '\i2b2\Familial Relationship\Has Sibling in Database\Has Twin in Database\Has Identical Twin in Database\', 'Has Identical Twin in Database', 'N', 'LA', 'FAMREL:HasIdenticalTwininDatabase', 'concept_cd', 'concept_dimension', 'concept_path', 'T', 'LIKE', '\i2b2\Familial Relationship\Has Sibling in Database\Has Twin in Database\Has Identical Twin in Database\', 'Has Identical Twin in Database', '@', getdate(), getdate(), getdate(), 'Family_relationship'

--select top 100 * from [dbo].[I2B2] where C_FULLNAME like '%Demographics%' order by c_hlevel
--truncate table [dbo].[FamilialRelationship]


