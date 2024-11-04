prompt --application/set_environment
set define off verify off feedback off
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_default_workspace_id=>20
);
end;
/
prompt --workspace/rest-source-catalogs//fusion_hcm
begin
wwv_web_src_catalog_api.create_catalog(
 p_id=>wwv_flow_imp.id(8849586811758552)
,p_name=>'Fusion HCM'
,p_internal_name=>'FUSION_HCM'
,p_endpoint_url=>'https://stevemuench.github.io/FusionHCM.sql'
,p_format=>'APEX'
);
end;
/
prompt --workspace/rest-source-catalogs/services//employees
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '{'||wwv_flow.LF||
'"data_profile":{'||wwv_flow.LF||
'"name":"Employees"'||wwv_flow.LF||
',"format":"JSON"'||wwv_flow.LF||
',"row_selector":"items"'||wwv_flow.LF||
',"is_single_row":"N"'||wwv_flow.LF||
'';
wwv_flow_imp.g_varchar2_table(2) := ',"columns":['||wwv_flow.LF||
'{'||wwv_flow.LF||
'"name":"APEX$RESOURCEKEY"'||wwv_flow.LF||
',"sequence":1'||wwv_flow.LF||
',"is_primary_key":"Y"'||wwv_flow.LF||
',"data_type":"VARCHAR2"';
wwv_flow_imp.g_varchar2_table(3) := ''||wwv_flow.LF||
',"max_length":4000'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"N"'||wwv_flow.LF||
',"selector":"@context';
wwv_flow_imp.g_varchar2_table(4) := '.key"'||wwv_flow.LF||
',"remote_attribute_name":"APEX$ResourceKey"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"SALUTATION"'||wwv_flow.LF||
',"sequen';
wwv_flow_imp.g_varchar2_table(5) := 'ce":2'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidde';
wwv_flow_imp.g_varchar2_table(6) := 'n":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"Salutation"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"FIRSTNAME"'||wwv_flow.LF||
',"sequ';
wwv_flow_imp.g_varchar2_table(7) := 'ence":3'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":150'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hi';
wwv_flow_imp.g_varchar2_table(8) := 'dden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"FirstName"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"MIDDLENAME"'||wwv_flow.LF||
',"s';
wwv_flow_imp.g_varchar2_table(9) := 'equence":4'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":80'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_';
wwv_flow_imp.g_varchar2_table(10) := 'hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"MiddleName"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"LASTNAME"'||wwv_flow.LF||
',"';
wwv_flow_imp.g_varchar2_table(11) := 'sequence":5'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":150'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"i';
wwv_flow_imp.g_varchar2_table(12) := 's_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"LastName"'||wwv_flow.LF||
',"additional_info":"Required"'||wwv_flow.LF||
',"is_common"';
wwv_flow_imp.g_varchar2_table(13) := ':"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"PREVIOUSLASTNAME"'||wwv_flow.LF||
',"sequence":6'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"ma';
wwv_flow_imp.g_varchar2_table(14) := 'x_length":150'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"PreviousLastNa';
wwv_flow_imp.g_varchar2_table(15) := 'me"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"NAMESUFFIX"'||wwv_flow.LF||
',"sequence":7'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARC';
wwv_flow_imp.g_varchar2_table(16) := 'HAR2"'||wwv_flow.LF||
',"max_length":80'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"NameS';
wwv_flow_imp.g_varchar2_table(17) := 'uffix"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"DISPLAYNAME"'||wwv_flow.LF||
',"sequence":8'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"';
wwv_flow_imp.g_varchar2_table(18) := 'VARCHAR2"'||wwv_flow.LF||
',"max_length":240'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"';
wwv_flow_imp.g_varchar2_table(19) := 'DisplayName"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"PREFERREDNAME"'||wwv_flow.LF||
',"sequence":9'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data';
wwv_flow_imp.g_varchar2_table(20) := '_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":80'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"sele';
wwv_flow_imp.g_varchar2_table(21) := 'ctor":"PreferredName"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"HONORS"'||wwv_flow.LF||
',"sequence":10'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"d';
wwv_flow_imp.g_varchar2_table(22) := 'ata_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":80'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"s';
wwv_flow_imp.g_varchar2_table(23) := 'elector":"Honors"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"CORRESPONDENCELANGUAGE"'||wwv_flow.LF||
',"sequence":11'||wwv_flow.LF||
',"is_primary_';
wwv_flow_imp.g_varchar2_table(24) := 'key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filtera';
wwv_flow_imp.g_varchar2_table(25) := 'ble":"Y"'||wwv_flow.LF||
',"selector":"CorrespondenceLanguage"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"PERSONNUMBER"'||wwv_flow.LF||
',"sequence';
wwv_flow_imp.g_varchar2_table(26) := '":12'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden';
wwv_flow_imp.g_varchar2_table(27) := '":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"PersonNumber"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"WORKPHONECOUNTRY';
wwv_flow_imp.g_varchar2_table(28) := 'CODE"'||wwv_flow.LF||
',"sequence":13'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone"';
wwv_flow_imp.g_varchar2_table(29) := ':"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"WorkPhoneCountryCode"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'';
wwv_flow_imp.g_varchar2_table(30) := '"name":"WORKPHONEAREACODE"'||wwv_flow.LF||
',"sequence":14'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length';
wwv_flow_imp.g_varchar2_table(31) := '":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"WorkPhoneAreaCode"'||wwv_flow.LF||
',"is';
wwv_flow_imp.g_varchar2_table(32) := '_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"WORKPHONENUMBER"'||wwv_flow.LF||
',"sequence":15'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHA';
wwv_flow_imp.g_varchar2_table(33) := 'R2"'||wwv_flow.LF||
',"max_length":60'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"WorkPho';
wwv_flow_imp.g_varchar2_table(34) := 'neNumber"'||wwv_flow.LF||
',"additional_info":"Required"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"WORKPHONEEXTENSION"'||wwv_flow.LF||
',"sequence';
wwv_flow_imp.g_varchar2_table(35) := '":16'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":60'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden';
wwv_flow_imp.g_varchar2_table(36) := '":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"WorkPhoneExtension"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"WORKPHONEL';
wwv_flow_imp.g_varchar2_table(37) := 'EGISLATIONCODE"'||wwv_flow.LF||
',"sequence":17'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":4'||wwv_flow.LF||
',"has_t';
wwv_flow_imp.g_varchar2_table(38) := 'ime_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"WorkPhoneLegislationCode"'||wwv_flow.LF||
',"is_comm';
wwv_flow_imp.g_varchar2_table(39) := 'on":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"WORKFAXCOUNTRYCODE"'||wwv_flow.LF||
',"sequence":18'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2';
wwv_flow_imp.g_varchar2_table(40) := '"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"WorkFaxCo';
wwv_flow_imp.g_varchar2_table(41) := 'untryCode"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"WORKFAXAREACODE"'||wwv_flow.LF||
',"sequence":19'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"dat';
wwv_flow_imp.g_varchar2_table(42) := 'a_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"sel';
wwv_flow_imp.g_varchar2_table(43) := 'ector":"WorkFaxAreaCode"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"WORKFAXNUMBER"'||wwv_flow.LF||
',"sequence":20'||wwv_flow.LF||
',"is_primary_ke';
wwv_flow_imp.g_varchar2_table(44) := 'y":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":60'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterabl';
wwv_flow_imp.g_varchar2_table(45) := 'e":"Y"'||wwv_flow.LF||
',"selector":"WorkFaxNumber"'||wwv_flow.LF||
',"additional_info":"Required"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"WORKF';
wwv_flow_imp.g_varchar2_table(46) := 'AXEXTENSION"'||wwv_flow.LF||
',"sequence":21'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":60'||wwv_flow.LF||
',"has_tim';
wwv_flow_imp.g_varchar2_table(47) := 'e_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"WorkFaxExtension"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
'';
wwv_flow_imp.g_varchar2_table(48) := ',{'||wwv_flow.LF||
'"name":"WORKFAXLEGISLATIONCODE"'||wwv_flow.LF||
',"sequence":22'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"ma';
wwv_flow_imp.g_varchar2_table(49) := 'x_length":4'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"WorkFaxLegislati';
wwv_flow_imp.g_varchar2_table(50) := 'onCode"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"WORKMOBILEPHONECOUNTRYCODE"'||wwv_flow.LF||
',"sequence":23'||wwv_flow.LF||
',"is_primary_key":"';
wwv_flow_imp.g_varchar2_table(51) := 'N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"';
wwv_flow_imp.g_varchar2_table(52) := 'Y"'||wwv_flow.LF||
',"selector":"WorkMobilePhoneCountryCode"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"WORKMOBILEPHONEAREACODE"'||wwv_flow.LF||
',';
wwv_flow_imp.g_varchar2_table(53) := '"sequence":24'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"';
wwv_flow_imp.g_varchar2_table(54) := 'is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"WorkMobilePhoneAreaCode"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"nam';
wwv_flow_imp.g_varchar2_table(55) := 'e":"WORKMOBILEPHONENUMBER"'||wwv_flow.LF||
',"sequence":25'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length';
wwv_flow_imp.g_varchar2_table(56) := '":60'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"WorkMobilePhoneNumber"'||wwv_flow.LF||
'';
wwv_flow_imp.g_varchar2_table(57) := ',"additional_info":"Required"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"WORKMOBILEPHONEEXTENSION"'||wwv_flow.LF||
',"sequence":26';
wwv_flow_imp.g_varchar2_table(58) := ''||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":60'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N';
wwv_flow_imp.g_varchar2_table(59) := '"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"WorkMobilePhoneExtension"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"WORKMOBI';
wwv_flow_imp.g_varchar2_table(60) := 'LEPHONELEGISLATIONCODE"'||wwv_flow.LF||
',"sequence":27'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":4';
wwv_flow_imp.g_varchar2_table(61) := ''||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"WorkMobilePhoneLegislationC';
wwv_flow_imp.g_varchar2_table(62) := 'ode"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"HOMEPHONECOUNTRYCODE"'||wwv_flow.LF||
',"sequence":28'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data';
wwv_flow_imp.g_varchar2_table(63) := '_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"sele';
wwv_flow_imp.g_varchar2_table(64) := 'ctor":"HomePhoneCountryCode"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"HOMEPHONEAREACODE"'||wwv_flow.LF||
',"sequence":29'||wwv_flow.LF||
',"is_pr';
wwv_flow_imp.g_varchar2_table(65) := 'imary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_f';
wwv_flow_imp.g_varchar2_table(66) := 'ilterable":"Y"'||wwv_flow.LF||
',"selector":"HomePhoneAreaCode"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"HOMEPHONENUMBER"'||wwv_flow.LF||
',"sequ';
wwv_flow_imp.g_varchar2_table(67) := 'ence":30'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":60'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hi';
wwv_flow_imp.g_varchar2_table(68) := 'dden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"HomePhoneNumber"'||wwv_flow.LF||
',"additional_info":"Required"'||wwv_flow.LF||
',"is_comm';
wwv_flow_imp.g_varchar2_table(69) := 'on":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"HOMEPHONEEXTENSION"'||wwv_flow.LF||
',"sequence":31'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2';
wwv_flow_imp.g_varchar2_table(70) := '"'||wwv_flow.LF||
',"max_length":60'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"HomePhone';
wwv_flow_imp.g_varchar2_table(71) := 'Extension"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"HOMEPHONELEGISLATIONCODE"'||wwv_flow.LF||
',"sequence":32'||wwv_flow.LF||
',"is_primary_key":';
wwv_flow_imp.g_varchar2_table(72) := '"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":4'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"';
wwv_flow_imp.g_varchar2_table(73) := 'Y"'||wwv_flow.LF||
',"selector":"HomePhoneLegislationCode"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"HOMEFAXCOUNTRYCODE"'||wwv_flow.LF||
',"sequen';
wwv_flow_imp.g_varchar2_table(74) := 'ce":33'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidd';
wwv_flow_imp.g_varchar2_table(75) := 'en":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"HomeFaxCountryCode"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"HOMEFAXA';
wwv_flow_imp.g_varchar2_table(76) := 'REACODE"'||wwv_flow.LF||
',"sequence":34'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zo';
wwv_flow_imp.g_varchar2_table(77) := 'ne":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"HomeFaxAreaCode"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"n';
wwv_flow_imp.g_varchar2_table(78) := 'ame":"HOMEFAXNUMBER"'||wwv_flow.LF||
',"sequence":35'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":60'||wwv_flow.LF||
',';
wwv_flow_imp.g_varchar2_table(79) := '"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"HomeFaxNumber"'||wwv_flow.LF||
',"additional_i';
wwv_flow_imp.g_varchar2_table(80) := 'nfo":"Required"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"HOMEFAXEXTENSION"'||wwv_flow.LF||
',"sequence":36'||wwv_flow.LF||
',"is_primary_key":"N"';
wwv_flow_imp.g_varchar2_table(81) := ''||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":60'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"';
wwv_flow_imp.g_varchar2_table(82) := ''||wwv_flow.LF||
',"selector":"HomeFaxExtension"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"WORKEMAIL"'||wwv_flow.LF||
',"sequence":37'||wwv_flow.LF||
',"is_primary';
wwv_flow_imp.g_varchar2_table(83) := '_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":240'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filte';
wwv_flow_imp.g_varchar2_table(84) := 'rable":"Y"'||wwv_flow.LF||
',"selector":"WorkEmail"'||wwv_flow.LF||
',"additional_info":"Required"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"HOMEF';
wwv_flow_imp.g_varchar2_table(85) := 'AXLEGISLATIONCODE"'||wwv_flow.LF||
',"sequence":38'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":4'||wwv_flow.LF||
',"ha';
wwv_flow_imp.g_varchar2_table(86) := 's_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"HomeFaxLegislationCode"'||wwv_flow.LF||
',"is_com';
wwv_flow_imp.g_varchar2_table(87) := 'mon":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"ADDRESSLINE1"'||wwv_flow.LF||
',"sequence":39'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"m';
wwv_flow_imp.g_varchar2_table(88) := 'ax_length":240'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"AddressLine1"';
wwv_flow_imp.g_varchar2_table(89) := ''||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"ADDRESSLINE2"'||wwv_flow.LF||
',"sequence":40'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARC';
wwv_flow_imp.g_varchar2_table(90) := 'HAR2"'||wwv_flow.LF||
',"max_length":240'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"Addr';
wwv_flow_imp.g_varchar2_table(91) := 'essLine2"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"ADDRESSLINE3"'||wwv_flow.LF||
',"sequence":41'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_ty';
wwv_flow_imp.g_varchar2_table(92) := 'pe":"VARCHAR2"'||wwv_flow.LF||
',"max_length":240'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"select';
wwv_flow_imp.g_varchar2_table(93) := 'or":"AddressLine3"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"CITY"'||wwv_flow.LF||
',"sequence":42'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_t';
wwv_flow_imp.g_varchar2_table(94) := 'ype":"VARCHAR2"'||wwv_flow.LF||
',"max_length":60'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"select';
wwv_flow_imp.g_varchar2_table(95) := 'or":"City"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"REGION"'||wwv_flow.LF||
',"sequence":43'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"';
wwv_flow_imp.g_varchar2_table(96) := 'VARCHAR2"'||wwv_flow.LF||
',"max_length":120'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"';
wwv_flow_imp.g_varchar2_table(97) := 'Region"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"REGION2"'||wwv_flow.LF||
',"sequence":44'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VA';
wwv_flow_imp.g_varchar2_table(98) := 'RCHAR2"'||wwv_flow.LF||
',"max_length":120'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"Re';
wwv_flow_imp.g_varchar2_table(99) := 'gion2"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"COUNTRY"'||wwv_flow.LF||
',"sequence":45'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VAR';
wwv_flow_imp.g_varchar2_table(100) := 'CHAR2"'||wwv_flow.LF||
',"max_length":60'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"Coun';
wwv_flow_imp.g_varchar2_table(101) := 'try"'||wwv_flow.LF||
',"additional_info":"Required,CreateOnly"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"POSTALCODE"'||wwv_flow.LF||
',"sequence":';
wwv_flow_imp.g_varchar2_table(102) := '46'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":';
wwv_flow_imp.g_varchar2_table(103) := '"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"PostalCode"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"DATEOFBIRTH"'||wwv_flow.LF||
',"seque';
wwv_flow_imp.g_varchar2_table(104) := 'nce":47'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"DATE"'||wwv_flow.LF||
',"format_mask":"YYYY-MM-DD"'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',';
wwv_flow_imp.g_varchar2_table(105) := '"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"DateOfBirth"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"ETHNICI';
wwv_flow_imp.g_varchar2_table(106) := 'TY"'||wwv_flow.LF||
',"sequence":48'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"';
wwv_flow_imp.g_varchar2_table(107) := 'N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"Ethnicity"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"PROJE';
wwv_flow_imp.g_varchar2_table(108) := 'CTEDTERMINATIONDATE"'||wwv_flow.LF||
',"sequence":49'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"DATE"'||wwv_flow.LF||
',"format_mask":"YYYY-M';
wwv_flow_imp.g_varchar2_table(109) := 'M-DD"'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"ProjectedTerminationDa';
wwv_flow_imp.g_varchar2_table(110) := 'te"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"LEGALENTITYID"'||wwv_flow.LF||
',"sequence":50'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"';
wwv_flow_imp.g_varchar2_table(111) := 'NUMBER"'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"N"'||wwv_flow.LF||
',"selector":"LegalEntityId"'||wwv_flow.LF||
',"add';
wwv_flow_imp.g_varchar2_table(112) := 'itional_info":"Required"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"HIREDATE"'||wwv_flow.LF||
',"sequence":51'||wwv_flow.LF||
',"is_primary_key":"N';
wwv_flow_imp.g_varchar2_table(113) := '"'||wwv_flow.LF||
',"data_type":"DATE"'||wwv_flow.LF||
',"format_mask":"YYYY-MM-DD"'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filtera';
wwv_flow_imp.g_varchar2_table(114) := 'ble":"Y"'||wwv_flow.LF||
',"selector":"HireDate"'||wwv_flow.LF||
',"additional_info":"Required"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"TERMINAT';
wwv_flow_imp.g_varchar2_table(115) := 'IONDATE"'||wwv_flow.LF||
',"sequence":52'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"DATE"'||wwv_flow.LF||
',"format_mask":"YYYY-MM-DD"'||wwv_flow.LF||
',"has_';
wwv_flow_imp.g_varchar2_table(116) := 'time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"TerminationDate"'||wwv_flow.LF||
',"additional_info';
wwv_flow_imp.g_varchar2_table(117) := '":"ReadOnly"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"GENDER"'||wwv_flow.LF||
',"sequence":53'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type"';
wwv_flow_imp.g_varchar2_table(118) := ':"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":';
wwv_flow_imp.g_varchar2_table(119) := '"Gender"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"MARITALSTATUS"'||wwv_flow.LF||
',"sequence":54'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_ty';
wwv_flow_imp.g_varchar2_table(120) := 'pe":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selecto';
wwv_flow_imp.g_varchar2_table(121) := 'r":"MaritalStatus"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"NATIONALIDTYPE"'||wwv_flow.LF||
',"sequence":55'||wwv_flow.LF||
',"is_primary_key":"N';
wwv_flow_imp.g_varchar2_table(122) := '"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y';
wwv_flow_imp.g_varchar2_table(123) := '"'||wwv_flow.LF||
',"selector":"NationalIdType"'||wwv_flow.LF||
',"additional_info":"Required"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"NATIONALI';
wwv_flow_imp.g_varchar2_table(124) := 'D"'||wwv_flow.LF||
',"sequence":56'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N';
wwv_flow_imp.g_varchar2_table(125) := '"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"NationalId"'||wwv_flow.LF||
',"additional_info":"Required"'||wwv_flow.LF||
',"is_';
wwv_flow_imp.g_varchar2_table(126) := 'common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"NATIONALIDCOUNTRY"'||wwv_flow.LF||
',"sequence":57'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCH';
wwv_flow_imp.g_varchar2_table(127) := 'AR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"Nation';
wwv_flow_imp.g_varchar2_table(128) := 'alIdCountry"'||wwv_flow.LF||
',"additional_info":"Required,CreateOnly"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"NATIONALIDEXPIRA';
wwv_flow_imp.g_varchar2_table(129) := 'TIONDATE"'||wwv_flow.LF||
',"sequence":58'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"DATE"'||wwv_flow.LF||
',"format_mask":"YYYY-MM-DD"'||wwv_flow.LF||
',"has';
wwv_flow_imp.g_varchar2_table(130) := '_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"NationalIdExpirationDate"'||wwv_flow.LF||
',"is_co';
wwv_flow_imp.g_varchar2_table(131) := 'mmon":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"NATIONALIDPLACEOFISSUE"'||wwv_flow.LF||
',"sequence":59'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VA';
wwv_flow_imp.g_varchar2_table(132) := 'RCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"Nat';
wwv_flow_imp.g_varchar2_table(133) := 'ionalIdPlaceOfIssue"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"PERSONID"'||wwv_flow.LF||
',"sequence":60'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"';
wwv_flow_imp.g_varchar2_table(134) := 'data_type":"NUMBER"'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"PersonId';
wwv_flow_imp.g_varchar2_table(135) := '"'||wwv_flow.LF||
',"additional_info":"RemotePK,Required,HasDefault,CreateOnly"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"EFFECTI';
wwv_flow_imp.g_varchar2_table(136) := 'VESTARTDATE"'||wwv_flow.LF||
',"sequence":61'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"DATE"'||wwv_flow.LF||
',"format_mask":"YYYY-MM-DD"'||wwv_flow.LF||
',"';
wwv_flow_imp.g_varchar2_table(137) := 'has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"EffectiveStartDate"'||wwv_flow.LF||
',"addition';
wwv_flow_imp.g_varchar2_table(138) := 'al_info":"RemotePK,Required"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"USERNAME"'||wwv_flow.LF||
',"sequence":62'||wwv_flow.LF||
',"is_primary_key';
wwv_flow_imp.g_varchar2_table(139) := '":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":100'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterabl';
wwv_flow_imp.g_varchar2_table(140) := 'e":"Y"'||wwv_flow.LF||
',"selector":"UserName"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"CITIZENSHIPID"'||wwv_flow.LF||
',"sequence":63'||wwv_flow.LF||
',"is_prima';
wwv_flow_imp.g_varchar2_table(141) := 'ry_key":"N"'||wwv_flow.LF||
',"data_type":"NUMBER"'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selec';
wwv_flow_imp.g_varchar2_table(142) := 'tor":"CitizenshipId"'||wwv_flow.LF||
',"additional_info":"RemotePK,Required,HasDefault,CreateOnly"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}';
wwv_flow_imp.g_varchar2_table(143) := ''||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"CITIZENSHIPSTATUS"'||wwv_flow.LF||
',"sequence":64'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_le';
wwv_flow_imp.g_varchar2_table(144) := 'ngth":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"CitizenshipStatus"'||wwv_flow.LF||
'';
wwv_flow_imp.g_varchar2_table(145) := ',"additional_info":"Required"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"CITIZENSHIPLEGISLATIONCODE"'||wwv_flow.LF||
',"sequence":';
wwv_flow_imp.g_varchar2_table(146) := '65'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":';
wwv_flow_imp.g_varchar2_table(147) := '"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"CitizenshipLegislationCode"'||wwv_flow.LF||
',"additional_info":"Required,Creat';
wwv_flow_imp.g_varchar2_table(148) := 'eOnly"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"CITIZENSHIPTODATE"'||wwv_flow.LF||
',"sequence":66'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_';
wwv_flow_imp.g_varchar2_table(149) := 'type":"DATE"'||wwv_flow.LF||
',"format_mask":"YYYY-MM-DD"'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
'';
wwv_flow_imp.g_varchar2_table(150) := ',"selector":"CitizenshipToDate"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"RELIGION"'||wwv_flow.LF||
',"sequence":67'||wwv_flow.LF||
',"is_primary_';
wwv_flow_imp.g_varchar2_table(151) := 'key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filtera';
wwv_flow_imp.g_varchar2_table(152) := 'ble":"Y"'||wwv_flow.LF||
',"selector":"Religion"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"RELIGIONID"'||wwv_flow.LF||
',"sequence":68'||wwv_flow.LF||
',"is_primar';
wwv_flow_imp.g_varchar2_table(153) := 'y_key":"N"'||wwv_flow.LF||
',"data_type":"NUMBER"'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"select';
wwv_flow_imp.g_varchar2_table(154) := 'or":"ReligionId"'||wwv_flow.LF||
',"additional_info":"RemotePK,Required,HasDefault,CreateOnly"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'';
wwv_flow_imp.g_varchar2_table(155) := '"name":"PASSPORTISSUEDATE"'||wwv_flow.LF||
',"sequence":69'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"DATE"'||wwv_flow.LF||
',"format_mask":"';
wwv_flow_imp.g_varchar2_table(156) := 'YYYY-MM-DD"'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"PassportIssueDat';
wwv_flow_imp.g_varchar2_table(157) := 'e"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"PASSPORTNUMBER"'||wwv_flow.LF||
',"sequence":70'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"';
wwv_flow_imp.g_varchar2_table(158) := 'VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"P';
wwv_flow_imp.g_varchar2_table(159) := 'assportNumber"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"PASSPORTISSUINGCOUNTRY"'||wwv_flow.LF||
',"sequence":71'||wwv_flow.LF||
',"is_primary_key';
wwv_flow_imp.g_varchar2_table(160) := '":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable';
wwv_flow_imp.g_varchar2_table(161) := '":"Y"'||wwv_flow.LF||
',"selector":"PassportIssuingCountry"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"PASSPORTID"'||wwv_flow.LF||
',"sequence":72'||wwv_flow.LF||
'';
wwv_flow_imp.g_varchar2_table(162) := ',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"NUMBER"'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"';
wwv_flow_imp.g_varchar2_table(163) := 'Y"'||wwv_flow.LF||
',"selector":"PassportId"'||wwv_flow.LF||
',"additional_info":"RemotePK,Required,HasDefault,CreateOnly"'||wwv_flow.LF||
',"is_common';
wwv_flow_imp.g_varchar2_table(164) := '":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"PASSPORTEXPIRATIONDATE"'||wwv_flow.LF||
',"sequence":73'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"DATE"'||wwv_flow.LF||
'';
wwv_flow_imp.g_varchar2_table(165) := ',"format_mask":"YYYY-MM-DD"'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"';
wwv_flow_imp.g_varchar2_table(166) := 'PassportExpirationDate"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"LICENSENUMBER"'||wwv_flow.LF||
',"sequence":74'||wwv_flow.LF||
',"is_primary_key';
wwv_flow_imp.g_varchar2_table(167) := '":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":150'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterabl';
wwv_flow_imp.g_varchar2_table(168) := 'e":"Y"'||wwv_flow.LF||
',"selector":"LicenseNumber"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"DRIVERSLICENSEEXPIRATIONDATE"'||wwv_flow.LF||
',"seq';
wwv_flow_imp.g_varchar2_table(169) := 'uence":75'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"DATE"'||wwv_flow.LF||
',"format_mask":"YYYY-MM-DD"'||wwv_flow.LF||
',"has_time_zone":"N"';
wwv_flow_imp.g_varchar2_table(170) := ''||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"DriversLicenseExpirationDate"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}';
wwv_flow_imp.g_varchar2_table(171) := ''||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"DRIVERSLICENSEISSUINGCOUNTRY"'||wwv_flow.LF||
',"sequence":76'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR';
wwv_flow_imp.g_varchar2_table(172) := '2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"DriversL';
wwv_flow_imp.g_varchar2_table(173) := 'icenseIssuingCountry"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"DRIVERSLICENSEID"'||wwv_flow.LF||
',"sequence":77'||wwv_flow.LF||
',"is_primary_ke';
wwv_flow_imp.g_varchar2_table(174) := 'y":"N"'||wwv_flow.LF||
',"data_type":"NUMBER"'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":';
wwv_flow_imp.g_varchar2_table(175) := '"DriversLicenseId"'||wwv_flow.LF||
',"additional_info":"RemotePK,Required,HasDefault,CreateOnly"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',';
wwv_flow_imp.g_varchar2_table(176) := '{'||wwv_flow.LF||
'"name":"MILITARYVETSTATUS"'||wwv_flow.LF||
',"sequence":78'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_leng';
wwv_flow_imp.g_varchar2_table(177) := 'th":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"MilitaryVetStatus"'||wwv_flow.LF||
',"';
wwv_flow_imp.g_varchar2_table(178) := 'additional_info":"Required"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"CREATIONDATE"'||wwv_flow.LF||
',"sequence":79'||wwv_flow.LF||
',"is_primary_';
wwv_flow_imp.g_varchar2_table(179) := 'key":"N"'||wwv_flow.LF||
',"data_type":"TIMESTAMP WITH TIME ZONE"'||wwv_flow.LF||
',"format_mask":"yyyy-mm-dd\"T\"hh24:mi:ss.fftzh:tzm';
wwv_flow_imp.g_varchar2_table(180) := '"'||wwv_flow.LF||
',"has_time_zone":"Y"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"CreationDate"'||wwv_flow.LF||
',"additional';
wwv_flow_imp.g_varchar2_table(181) := '_info":"Required,ReadOnly"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"LASTUPDATEDATE"'||wwv_flow.LF||
',"sequence":80'||wwv_flow.LF||
',"is_primary';
wwv_flow_imp.g_varchar2_table(182) := '_key":"N"'||wwv_flow.LF||
',"data_type":"TIMESTAMP WITH TIME ZONE"'||wwv_flow.LF||
',"format_mask":"yyyy-mm-dd\"T\"hh24:mi:ss.fftzh:tz';
wwv_flow_imp.g_varchar2_table(183) := 'm"'||wwv_flow.LF||
',"has_time_zone":"Y"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"LastUpdateDate"'||wwv_flow.LF||
',"additio';
wwv_flow_imp.g_varchar2_table(184) := 'nal_info":"Required,ReadOnly"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"WORKERTYPE"'||wwv_flow.LF||
',"sequence":81'||wwv_flow.LF||
',"is_primary_';
wwv_flow_imp.g_varchar2_table(185) := 'key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filtera';
wwv_flow_imp.g_varchar2_table(186) := 'ble":"Y"'||wwv_flow.LF||
',"selector":"WorkerType"'||wwv_flow.LF||
',"additional_info":"Required,ReadOnly"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
']'||wwv_flow.LF||
'}'||wwv_flow.LF||
',"pl';
wwv_flow_imp.g_varchar2_table(187) := 'ugin_attributes":{'||wwv_flow.LF||
'"1":"Y"'||wwv_flow.LF||
',"2":"emps"'||wwv_flow.LF||
',"3":"N"'||wwv_flow.LF||
',"4":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',"operations":['||wwv_flow.LF||
'{'||wwv_flow.LF||
'"operation":"GET"'||wwv_flow.LF||
',"dat';
wwv_flow_imp.g_varchar2_table(188) := 'abase_operation":"FETCH_COLLECTION"'||wwv_flow.LF||
',"url_pattern":"."'||wwv_flow.LF||
',"allow_fetch_all_rows":"N"'||wwv_flow.LF||
',"parameters":['||wwv_flow.LF||
']';
wwv_flow_imp.g_varchar2_table(189) := ''||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"operation":"POST"'||wwv_flow.LF||
',"database_operation":"INSERT"'||wwv_flow.LF||
',"url_pattern":"."'||wwv_flow.LF||
',"allow_fetch_all_rows":"';
wwv_flow_imp.g_varchar2_table(190) := 'N"'||wwv_flow.LF||
',"parameters":['||wwv_flow.LF||
']'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"operation":"GET"'||wwv_flow.LF||
',"database_operation":"FETCH_SINGLE_ROW"'||wwv_flow.LF||
',"url_pattern":';
wwv_flow_imp.g_varchar2_table(191) := '"\/:APEX$ResourceKey"'||wwv_flow.LF||
',"allow_fetch_all_rows":"N"'||wwv_flow.LF||
',"parameters":['||wwv_flow.LF||
']'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"operation":"PATCH"'||wwv_flow.LF||
',"datab';
wwv_flow_imp.g_varchar2_table(192) := 'ase_operation":"UPDATE"'||wwv_flow.LF||
',"url_pattern":"\/:APEX$ResourceKey"'||wwv_flow.LF||
',"allow_fetch_all_rows":"N"'||wwv_flow.LF||
',"parameter';
wwv_flow_imp.g_varchar2_table(193) := 's":['||wwv_flow.LF||
']'||wwv_flow.LF||
'}'||wwv_flow.LF||
']'||wwv_flow.LF||
',"parameters":['||wwv_flow.LF||
']'||wwv_flow.LF||
'}'||wwv_flow.LF||
'';
wwv_web_src_catalog_api.create_catalog_service(
 p_id=>wwv_flow_imp.id(8955495983832913)
,p_catalog_id=>wwv_flow_imp.id(8849586811758552)
,p_name=>'Employees'
,p_base_url=>'https://fa-exgs-saasfademo1.ds-fa.oraclepdemos.com'
,p_service_path=>'/hcmRestApi/resources/11.13.18.05/emps'
,p_plugin_internal_name=>'NATIVE_ADFBC'
,p_authentication_type=>'BASIC'
,p_details_json=>wwv_flow_imp.g_varchar2_table
,p_version=>'20241104'
);
end;
/
prompt --workspace/rest-source-catalogs/services//hcm_contacts
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '{'||wwv_flow.LF||
'"data_profile":{'||wwv_flow.LF||
'"name":"HCM Contacts"'||wwv_flow.LF||
',"format":"JSON"'||wwv_flow.LF||
',"row_selector":"items"'||wwv_flow.LF||
',"is_single_row":"';
wwv_flow_imp.g_varchar2_table(2) := 'N"'||wwv_flow.LF||
',"columns":['||wwv_flow.LF||
'{'||wwv_flow.LF||
'"name":"APEX$RESOURCEKEY"'||wwv_flow.LF||
',"sequence":1'||wwv_flow.LF||
',"is_primary_key":"Y"'||wwv_flow.LF||
',"data_type":"VARCHA';
wwv_flow_imp.g_varchar2_table(3) := 'R2"'||wwv_flow.LF||
',"max_length":4000'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"N"'||wwv_flow.LF||
',"selector":"@cont';
wwv_flow_imp.g_varchar2_table(4) := 'ext.key"'||wwv_flow.LF||
',"remote_attribute_name":"APEX$ResourceKey"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"PERSONID"'||wwv_flow.LF||
',"seque';
wwv_flow_imp.g_varchar2_table(5) := 'nce":2'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"NUMBER"'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filter';
wwv_flow_imp.g_varchar2_table(6) := 'able":"Y"'||wwv_flow.LF||
',"selector":"PersonId"'||wwv_flow.LF||
',"additional_info":"RemotePK,Required,HasDefault,CreateOnly"'||wwv_flow.LF||
',"is_c';
wwv_flow_imp.g_varchar2_table(7) := 'ommon":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"PERSONNUMBER"'||wwv_flow.LF||
',"sequence":3'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"';
wwv_flow_imp.g_varchar2_table(8) := 'max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"PersonNumber"';
wwv_flow_imp.g_varchar2_table(9) := ''||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"CORRESPONDENCELANGUAGE"'||wwv_flow.LF||
',"sequence":4'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_ty';
wwv_flow_imp.g_varchar2_table(10) := 'pe":"VARCHAR2"'||wwv_flow.LF||
',"max_length":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"N"'||wwv_flow.LF||
',"selecto';
wwv_flow_imp.g_varchar2_table(11) := 'r":"CorrespondenceLanguage"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"CORRLANGUAGEMEANING"'||wwv_flow.LF||
',"sequence":5'||wwv_flow.LF||
',"is_pr';
wwv_flow_imp.g_varchar2_table(12) := 'imary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":80'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_f';
wwv_flow_imp.g_varchar2_table(13) := 'ilterable":"Y"'||wwv_flow.LF||
',"selector":"CorrLanguageMeaning"'||wwv_flow.LF||
',"additional_info":"Required,ReadOnly"'||wwv_flow.LF||
',"is_common"';
wwv_flow_imp.g_varchar2_table(14) := ':"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"BLOODTYPE"'||wwv_flow.LF||
',"sequence":6'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_lengt';
wwv_flow_imp.g_varchar2_table(15) := 'h":30'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"N"'||wwv_flow.LF||
',"selector":"BloodType"'||wwv_flow.LF||
',"is_common';
wwv_flow_imp.g_varchar2_table(16) := '":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"BLOODTYPEMEANING"'||wwv_flow.LF||
',"sequence":7'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"m';
wwv_flow_imp.g_varchar2_table(17) := 'ax_length":80'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"BloodTypeMeani';
wwv_flow_imp.g_varchar2_table(18) := 'ng"'||wwv_flow.LF||
',"additional_info":"Required,ReadOnly"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"DATEOFBIRTH"'||wwv_flow.LF||
',"sequence":8'||wwv_flow.LF||
'';
wwv_flow_imp.g_varchar2_table(19) := ',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"DATE"'||wwv_flow.LF||
',"format_mask":"YYYY-MM-DD"'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidd';
wwv_flow_imp.g_varchar2_table(20) := 'en":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"DateOfBirth"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"DATEOFDEATH"'||wwv_flow.LF||
',"';
wwv_flow_imp.g_varchar2_table(21) := 'sequence":9'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"DATE"'||wwv_flow.LF||
',"format_mask":"YYYY-MM-DD"'||wwv_flow.LF||
',"has_time_zone":"';
wwv_flow_imp.g_varchar2_table(22) := 'N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"N"'||wwv_flow.LF||
',"selector":"DateOfDeath"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"COU';
wwv_flow_imp.g_varchar2_table(23) := 'NTRYOFBIRTH"'||wwv_flow.LF||
',"sequence":10'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":240'||wwv_flow.LF||
',"has_ti';
wwv_flow_imp.g_varchar2_table(24) := 'me_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"N"'||wwv_flow.LF||
',"selector":"CountryOfBirth"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',';
wwv_flow_imp.g_varchar2_table(25) := '{'||wwv_flow.LF||
'"name":"COUNTRYOFBIRTHNAME"'||wwv_flow.LF||
',"sequence":11'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_len';
wwv_flow_imp.g_varchar2_table(26) := 'gth":80'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"Y"'||wwv_flow.LF||
',"selector":"CountryOfBirthName"'||wwv_flow.LF||
'';
wwv_flow_imp.g_varchar2_table(27) := ',"additional_info":"Required,ReadOnly"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"REGIONOFBIRTH"'||wwv_flow.LF||
',"sequence":12'||wwv_flow.LF||
',';
wwv_flow_imp.g_varchar2_table(28) := '"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":240'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"';
wwv_flow_imp.g_varchar2_table(29) := ''||wwv_flow.LF||
',"is_filterable":"N"'||wwv_flow.LF||
',"selector":"RegionOfBirth"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"TOWNOFBIRTH"'||wwv_flow.LF||
',"seque';
wwv_flow_imp.g_varchar2_table(30) := 'nce":13'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":240'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hi';
wwv_flow_imp.g_varchar2_table(31) := 'dden":"N"'||wwv_flow.LF||
',"is_filterable":"N"'||wwv_flow.LF||
',"selector":"TownOfBirth"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"CREATEDBY"'||wwv_flow.LF||
',"';
wwv_flow_imp.g_varchar2_table(32) := 'sequence":14'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR2"'||wwv_flow.LF||
',"max_length":64'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"i';
wwv_flow_imp.g_varchar2_table(33) := 's_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"N"'||wwv_flow.LF||
',"selector":"CreatedBy"'||wwv_flow.LF||
',"additional_info":"Required,ReadOnly"'||wwv_flow.LF||
',"';
wwv_flow_imp.g_varchar2_table(34) := 'is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"CREATIONDATE"'||wwv_flow.LF||
',"sequence":15'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"TIMESTA';
wwv_flow_imp.g_varchar2_table(35) := 'MP WITH TIME ZONE"'||wwv_flow.LF||
',"format_mask":"yyyy-mm-dd\"T\"hh24:mi:ss.fftzh:tzm"'||wwv_flow.LF||
',"has_time_zone":"Y"'||wwv_flow.LF||
',"is_hi';
wwv_flow_imp.g_varchar2_table(36) := 'dden":"N"'||wwv_flow.LF||
',"is_filterable":"N"'||wwv_flow.LF||
',"selector":"CreationDate"'||wwv_flow.LF||
',"additional_info":"Required,ReadOnly"'||wwv_flow.LF||
',"i';
wwv_flow_imp.g_varchar2_table(37) := 's_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"LASTUPDATEDBY"'||wwv_flow.LF||
',"sequence":16'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"VARCHAR';
wwv_flow_imp.g_varchar2_table(38) := '2"'||wwv_flow.LF||
',"max_length":64'||wwv_flow.LF||
',"has_time_zone":"N"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"N"'||wwv_flow.LF||
',"selector":"LastUpda';
wwv_flow_imp.g_varchar2_table(39) := 'tedBy"'||wwv_flow.LF||
',"additional_info":"Required,ReadOnly"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"name":"LASTUPDATEDATE"'||wwv_flow.LF||
',"sequen';
wwv_flow_imp.g_varchar2_table(40) := 'ce":17'||wwv_flow.LF||
',"is_primary_key":"N"'||wwv_flow.LF||
',"data_type":"TIMESTAMP WITH TIME ZONE"'||wwv_flow.LF||
',"format_mask":"yyyy-mm-dd\"T\"';
wwv_flow_imp.g_varchar2_table(41) := 'hh24:mi:ss.fftzh:tzm"'||wwv_flow.LF||
',"has_time_zone":"Y"'||wwv_flow.LF||
',"is_hidden":"N"'||wwv_flow.LF||
',"is_filterable":"N"'||wwv_flow.LF||
',"selector":"LastUp';
wwv_flow_imp.g_varchar2_table(42) := 'dateDate"'||wwv_flow.LF||
',"additional_info":"Required,ReadOnly"'||wwv_flow.LF||
',"is_common":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
']'||wwv_flow.LF||
'}'||wwv_flow.LF||
',"plugin_attributes":{'||wwv_flow.LF||
'"1":"';
wwv_flow_imp.g_varchar2_table(43) := 'Y"'||wwv_flow.LF||
',"2":"hcmContacts"'||wwv_flow.LF||
',"3":"N"'||wwv_flow.LF||
',"4":"Y"'||wwv_flow.LF||
'}'||wwv_flow.LF||
',"operations":['||wwv_flow.LF||
'{'||wwv_flow.LF||
'"operation":"GET"'||wwv_flow.LF||
',"database_operation":';
wwv_flow_imp.g_varchar2_table(44) := '"FETCH_COLLECTION"'||wwv_flow.LF||
',"url_pattern":"."'||wwv_flow.LF||
',"allow_fetch_all_rows":"N"'||wwv_flow.LF||
',"parameters":['||wwv_flow.LF||
']'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"operation"';
wwv_flow_imp.g_varchar2_table(45) := ':"POST"'||wwv_flow.LF||
',"database_operation":"INSERT"'||wwv_flow.LF||
',"url_pattern":"."'||wwv_flow.LF||
',"allow_fetch_all_rows":"N"'||wwv_flow.LF||
',"parameters":';
wwv_flow_imp.g_varchar2_table(46) := '['||wwv_flow.LF||
']'||wwv_flow.LF||
'}'||wwv_flow.LF||
',{'||wwv_flow.LF||
'"operation":"GET"'||wwv_flow.LF||
',"database_operation":"FETCH_SINGLE_ROW"'||wwv_flow.LF||
',"url_pattern":"\/:APEX$Resource';
wwv_flow_imp.g_varchar2_table(47) := 'Key"'||wwv_flow.LF||
',"allow_fetch_all_rows":"N"'||wwv_flow.LF||
',"parameters":['||wwv_flow.LF||
']'||wwv_flow.LF||
'}'||wwv_flow.LF||
']'||wwv_flow.LF||
',"parameters":['||wwv_flow.LF||
']'||wwv_flow.LF||
'}'||wwv_flow.LF||
'';
wwv_web_src_catalog_api.create_catalog_service(
 p_id=>wwv_flow_imp.id(9137583402600929)
,p_catalog_id=>wwv_flow_imp.id(8849586811758552)
,p_name=>'HCM Contacts'
,p_base_url=>'https://fa-exgs-saasfademo1.ds-fa.oraclepdemos.com'
,p_service_path=>'/hcmRestApi/resources/11.13.18.05/hcmContacts'
,p_plugin_internal_name=>'NATIVE_ADFBC'
,p_authentication_type=>'BASIC'
,p_details_json=>wwv_flow_imp.g_varchar2_table
,p_version=>'20241104'
);
end;
/
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
