/*******************
* 
* i2b2 familial Relationships plugin 
* DemoData database script
*
* This script adds two patients and a number of observations to the standard i2b2 demodata 
* to enable testing and evaluation of the familial relationship plugin. 
* If you have previously added additional patients to the demo dataset you may need to edit 
* the patient IDs of the new patients in this script
* 
* Run this script in your i2b2 CRC database (i2b2demodata for a default i2b2 install)
*
*********************/




insert into PATIENT_DIMENSION (PATIENT_NUM, VITAL_STATUS_CD, BIRTH_DATE, SEX_CD, AGE_IN_YEARS_NUM, LANGUAGE_CD, RACE_CD, MARITAL_STATUS_CD, RELIGION_CD, ZIP_CD, STATECITYZIP_PATH, INCOME_CD, UPDATE_DATE, DOWNLOAD_DATE, IMPORT_DATE, SOURCESYSTEM_CD, FACT_COUNT, FACT_COUNT_PERCENTILE)
select 1000000135, '', BIRTH_DATE, SEX_CD, AGE_IN_YEARS_NUM, LANGUAGE_CD, RACE_CD, MARITAL_STATUS_CD, RELIGION_CD, ZIP_CD, STATECITYZIP_PATH, INCOME_CD, getdate(), getdate(), getdate(), 'Family_relationship', 0, 0  from PATIENT_DIMENSION  where PATIENT_NUM = 1000000122
union
select 1000000136, '', BIRTH_DATE, SEX_CD, AGE_IN_YEARS_NUM, LANGUAGE_CD, RACE_CD, MARITAL_STATUS_CD, RELIGION_CD, ZIP_CD, STATECITYZIP_PATH, INCOME_CD, getdate(), getdate(), getdate(), 'Family_relationship', 0, 0  from PATIENT_DIMENSION  where PATIENT_NUM = 1000000072

select * from [dbo].[OBSERVATION_FACT] where PATIENT_NUM = 1000000122 and concept_cd like 'DEM%'

insert into [dbo].[OBSERVATION_FACT] (ENCOUNTER_NUM, PATIENT_NUM, CONCEPT_CD, PROVIDER_ID, START_DATE, MODIFIER_CD, INSTANCE_NUM, VALTYPE_CD, TVAL_CHAR, NVAL_NUM, VALUEFLAG_CD, UNITS_CD, END_DATE, LOCATION_CD, OBSERVATION_BLOB, UPDATE_DATE, DOWNLOAD_DATE, IMPORT_DATE, SOURCESYSTEM_CD)
select 600001, 1000000135, CONCEPT_CD, PROVIDER_ID, START_DATE, MODIFIER_CD, INSTANCE_NUM, VALTYPE_CD, TVAL_CHAR, NVAL_NUM, VALUEFLAG_CD, UNITS_CD, END_DATE, LOCATION_CD, OBSERVATION_BLOB, GETDATE(), GETDATE(), GETDATE(), 'Family_relationship'   from [dbo].[OBSERVATION_FACT] where PATIENT_NUM = 1000000122 and concept_cd like 'DEM%'

insert into [dbo].[OBSERVATION_FACT] (ENCOUNTER_NUM, PATIENT_NUM, CONCEPT_CD, PROVIDER_ID, START_DATE, MODIFIER_CD, INSTANCE_NUM, VALTYPE_CD, TVAL_CHAR, NVAL_NUM, VALUEFLAG_CD, UNITS_CD, END_DATE, LOCATION_CD, OBSERVATION_BLOB, UPDATE_DATE, DOWNLOAD_DATE, IMPORT_DATE, SOURCESYSTEM_CD)
select 600001, 1000000136, CONCEPT_CD, PROVIDER_ID, START_DATE, MODIFIER_CD, INSTANCE_NUM, VALTYPE_CD, TVAL_CHAR, NVAL_NUM, VALUEFLAG_CD, UNITS_CD, END_DATE, LOCATION_CD, OBSERVATION_BLOB, GETDATE(), GETDATE(), GETDATE(), 'Family_relationship'   from [dbo].[OBSERVATION_FACT] where PATIENT_NUM = 1000000072 and concept_cd like 'DEM%'


create table #families (mother int, father int, child1 int, child2 int, child3 int)
insert into #families (mother, father, child1, child2, child3)
select 1000000002, 1000000073, 1000000019, 1000000136, 1000000072
union select 1000000005, null, 1000000065, 1000000122, 1000000135
union select 1000000011, null, 1000000021, 1000000033, null
union select 1000000013, null, 1000000087, 1000000095, 1000000111
union select 1000000063, null, 1000000055, 1000000058, 1000000066
union select 1000000085, 1000000101, 1000000104, 1000000107, null
union select 1000000086, 1000000051, 1000000115, 1000000116, 1000000132
union select 1000000125, null, 1000000041, 1000000090, 1000000128
union select 1000000130, null, 1000000134, null, null
select * From #families
create table #twins(personID1 int, personID2 int, twintype varchar(50))
insert into #twins
select 1000000122, 1000000135, 'Identical'
union
select 1000000072, 1000000136, 'Fraternal'


--delete from [dbo].[OBSERVATION_FACT] where ENCOUNTER_NUM = 600000

Insert into [dbo].[OBSERVATION_FACT] (ENCOUNTER_NUM, PATIENT_NUM, CONCEPT_CD, PROVIDER_ID, START_DATE, MODIFIER_CD, INSTANCE_NUM, VALTYPE_CD, TVAL_CHAR,
										NVAL_NUM, VALUEFLAG_CD, UNITS_CD, END_DATE, LOCATION_CD, OBSERVATION_BLOB, UPDATE_DATE, DOWNLOAD_DATE, IMPORT_DATE, 
										SOURCESYSTEM_CD)--, TEXT_SEARCH_INDEX)
select 600000, mother, 'FAMREL:HasChildinDatabase', 'Family_relationship', getdate(), '@', 1, 'N', 'E', 
		child1, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #families where mother is not null and child1 is not null
union
select 600000, mother, 'FAMREL:HasChildinDatabase', 'Family_relationship', getdate(), '@', 2, 'N', 'E', 
		child2, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #families where mother is not null and child2 is not null
union
select 600000, mother, 'FAMREL:HasChildinDatabase', 'Family_relationship', getdate(), '@', 3, 'N', 'E', 
		child3, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #families where mother is not null and child3 is not null
union
select 600000, father, 'FAMREL:HasChildinDatabase', 'Family_relationship', getdate(), '@', 1, 'N', 'E', 
		child1, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #families where father is not null and child1 is not null
union
select 600000, father, 'FAMREL:HasChildinDatabase', 'Family_relationship', getdate(), '@', 2, 'N', 'E', 
		child2, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #families where father is not null and child2 is not null
union
select 600000, father, 'FAMREL:HasChildinDatabase', 'Family_relationship', getdate(), '@', 3, 'N', 'E', 
		child3, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #families where father is not null and child3 is not null
union
select 600000, child1, 'FAMREL:HasMotherinDatabase', 'Family_relationship', getdate(), '@', 1, 'N', 'E', 
		mother, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #families where mother is not null and child1 is not null
union
select 600000, child2, 'FAMREL:HasMotherinDatabase', 'Family_relationship', getdate(), '@', 1, 'N', 'E', 
		mother, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #families where mother is not null and child2 is not null
union
select 600000, child3, 'FAMREL:HasMotherinDatabase', 'Family_relationship', getdate(), '@', 1, 'N', 'E', 
		mother, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #families where mother is not null and child3 is not null
union
select 600000, child1, 'FAMREL:HasFatherinDatabase', 'Family_relationship', getdate(), '@', 2, 'N', 'E', 
		father, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #families where father is not null and child1 is not null
union
select 600000, child2, 'FAMREL:HasFatherinDatabase', 'Family_relationship', getdate(), '@', 2, 'N', 'E', 
		father, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #families where father is not null and child2 is not null
union
select 600000, child3, 'FAMREL:HasFatherinDatabase', 'Family_relationship', getdate(), '@', 2, 'N', 'E', 
		father, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #families where father is not null and child3 is not null

union 
select 600000, child1, 'FAMREL:HasSiblinginDatabase', 'Family_relationship', getdate(), '@', 1, 'N', 'E', 
		child2, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #families where child1 is not null and child2 is not null
union 
select 600000, child1, 'FAMREL:HasSiblinginDatabase', 'Family_relationship', getdate(), '@', 2, 'N', 'E', 
		child3, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #families where child1 is not null and child3 is not null
union
select 600000, child2, 'FAMREL:HasSiblinginDatabase', 'Family_relationship', getdate(), '@', 3, 'N', 'E', 
		child3, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #families where child2 is not null and child3 is not null
union 
select 600000, child2, 'FAMREL:HasSiblinginDatabase', 'Family_relationship', getdate(), '@', 4, 'N', 'E', 
		child1, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #families where child1 is not null and child2 is not null
union 
select 600000, child3, 'FAMREL:HasSiblinginDatabase', 'Family_relationship', getdate(), '@', 5, 'N', 'E', 
		child1, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #families where child1 is not null and child3 is not null
union
select 600000, child3, 'FAMREL:HasSiblinginDatabase', 'Family_relationship', getdate(), '@', 6, 'N', 'E', 
		child2, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #families where child2 is not null and child3 is not null

union
select 600000, personID1, 'FAMREL:HasTwininDatabase', 'Family_relationship', getdate(), '@', 1, 'N', 'E', 
		personID2, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #twins
union
select 600000, personID2, 'FAMREL:HasTwininDatabase', 'Family_relationship', getdate(), '@', 1, 'N', 'E', 
		personID1, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #twins
union
select 600000, personID1, 'FAMREL:HasFraternalTwininDatabase', 'Family_relationship', getdate(), '@', 1, 'N', 'E', 
		personID2, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #twins where twintype = 'Fraternal'
union
select 600000, personID2, 'FAMREL:HasFraternalTwininDatabase', 'Family_relationship', getdate(), '@', 1, 'N', 'E', 
		personID1, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #twins where twintype = 'Fraternal'
union
select 600000, personID1, 'FAMREL:HasIdenticalTwininDatabase', 'Family_relationship', getdate(), '@', 1, 'N', 'E', 
		personID2, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #twins where twintype = 'Identical'
union
select 600000, personID2, 'FAMREL:HasIdenticalTwininDatabase', 'Family_relationship', getdate(), '@', 1, 'N', 'E', 
		personID1, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #twins where twintype = 'Identical'
union
select 600000, mother, 'FAMREL:HasSpouceinDatabase', 'Family_relationship', getdate(), '@', 1, 'N', 'E', 
		father, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #families where mother is not null and father is not null
union
select 600000, father, 'FAMREL:HasSpouceinDatabase', 'Family_relationship', getdate(), '@', 1, 'N', 'E', 
		mother, '', '', getdate(), '@', '', getDate(), getdate(), getdate(), 'Family_relationship'
		from #families where father is not null and mother is not null