prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
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
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.4'
,p_default_workspace_id=>3745309568181809
,p_default_application_id=>103
,p_default_id_offset=>0
,p_default_owner=>'SMUENCH'
);
end;
/
 
prompt APPLICATION 103 - Remember Date Calendar
--
-- Application Export:
--   Application:     103
--   Name:            Remember Date Calendar
--   Date and Time:   11:59 Wednesday September 9, 2026
--   Exported By:     SMUENCH
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 8743038207322467
--   Manifest End
--   Version:         26.1.4
--   Instance ID:     1541695422090121
--

begin
  -- replace components
  wwv_flow_imp.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/dynamic_action/org_stevemuench_apex_remember_cal_state
begin
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(8743038207322467)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'ORG.STEVEMUENCH.APEX.REMEMBER_CAL_STATE'
,p_display_name=>'Remember Calendar State'
,p_apexlang_name=>'rememberCalendarState'
,p_category=>'COMPONENT'
,p_javascript_file_urls=>'#PLUGIN_FILES#js/rememberCalendarState#MIN#.js'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function render (',
'    p_dynamic_action in apex_plugin.t_dynamic_action,',
'    p_plugin         in apex_plugin.t_plugin )',
'    return apex_plugin.t_dynamic_action_render_result is',
'    l_result apex_plugin.t_dynamic_action_render_result;',
'    l_ajax_id varchar2(4000) := apex_plugin.get_ajax_identifier;',
'begin',
'    apex_json.initialize_clob_output;',
'    apex_json.open_object;',
'    apex_json.write(''ajaxId'',   l_ajax_id);',
'    apex_json.write(''dayItem'',  p_dynamic_action.attribute_01);',
'    apex_json.write(''viewItem'', p_dynamic_action.attribute_02);',
'    apex_json.close_object;',
'',
'    l_result.javascript_function :=',
'        ''function(){rememberCalendarState.call(this,''||',
'        apex_json.get_clob_output||'');}'';',
'',
'    apex_json.free_output;',
'    return l_result;',
'end render;',
'',
'function ajax (',
'    p_dynamic_action in apex_plugin.t_dynamic_action,',
'    p_plugin         in apex_plugin.t_plugin )',
'    return apex_plugin.t_dynamic_action_ajax_result is',
'    l_result apex_plugin.t_dynamic_action_ajax_result;',
'begin',
'    apex_util.set_session_state(',
'        p_name  => p_dynamic_action.attribute_01,',
'        p_value => apex_application.g_x01',
'    );',
'    apex_util.set_session_state(',
'        p_name  => p_dynamic_action.attribute_02,',
'        p_value => apex_application.g_x02',
'    );',
'',
'    apex_json.initialize_output;',
'    apex_json.open_object;',
'    apex_json.write(''status'', ''success'');',
'    apex_json.close_object;',
'',
'    return l_result;',
'end ajax;'))
,p_api_version=>1
,p_render_function=>'render'
,p_ajax_function=>'ajax'
,p_standard_attributes=>'REGION:REQUIRED'
,p_substitute_attributes=>true
,p_version_identifier=>'1.0'
,p_files_version=>2461293114820
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(8743188822322469)
,p_plugin_id=>wwv_flow_imp.id(8743038207322467)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_static_id=>'attribute_01'
,p_prompt=>'Last Day Viewed Item'
,p_apexlang_name=>'dayItem'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>true
,p_is_translatable=>false
,p_help_text=>'The page item used to store the last calendar date viewed.'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(8743262229322470)
,p_plugin_id=>wwv_flow_imp.id(8743038207322467)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_static_id=>'attribute_02'
,p_prompt=>'Last View Used Item'
,p_apexlang_name=>'viewItem'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>true
,p_is_translatable=>false
,p_help_text=>'The page item used to store the last calendar view used.'
);
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '77696E646F772E72656D656D62657243616C656E6461725374617465203D2066756E6374696F6E2028636F6E66696729207B0A202020202275736520737472696374223B0A0A20202020766172206166666563746564203D20746869732E616666656374';
wwv_flow_imp.g_varchar2_table(2) := '6564456C656D656E74733B0A2020202076617220726567696F6E4964203D2061666665637465642026262061666665637465642E617474722822696422293B0A2020202076617220726567696F6E3B0A202020207661722063616C656E6461723B0A2020';
wwv_flow_imp.g_varchar2_table(3) := '202076617220726573746F72696E67203D20747275653B0A20202020766172206F726967696E616C44617465735365743B0A202020207661722063616C656E646172456C656D656E743B0A0A202020206966202821726567696F6E496429207B0A202020';
wwv_flow_imp.g_varchar2_table(4) := '20202020207468726F77206E6577204572726F722822416666656374656420526567696F6E206D757374206861766520616E20494422293B0A202020207D0A0A20202020726567696F6E203D20617065782E726567696F6E28726567696F6E4964293B0A';
wwv_flow_imp.g_varchar2_table(5) := '0A202020206966202821726567696F6E207C7C20726567696F6E2E7479706520213D3D202246756C6C43616C656E6461722229207B0A20202020202020207468726F77206E6577204572726F722822416666656374656420526567696F6E206D75737420';
wwv_flow_imp.g_varchar2_table(6) := '626520616E20415045582043616C656E64617222293B0A202020207D0A0A2020202063616C656E646172203D20726567696F6E2E77696467657428292E64617461282266756C6C43616C656E64617222293B0A0A20202020696620282163616C656E6461';
wwv_flow_imp.g_varchar2_table(7) := '7229207B0A20202020202020207468726F77206E6577204572726F7228225468652043616C656E64617220726567696F6E206973206E6F7420696E697469616C697A656422293B0A202020207D0A0A2020202063616C656E646172456C656D656E74203D';
wwv_flow_imp.g_varchar2_table(8) := '2061666665637465643B0A2020202063616C656E646172456C656D656E742E63737328227669736962696C697479222C202268696464656E22293B0A0A2020202066756E6374696F6E206974656D56616C7565286E616D6529207B0A2020202020202020';
wwv_flow_imp.g_varchar2_table(9) := '766172206974656D203D20617065782E6974656D286E616D65293B0A202020202020202072657475726E206974656D203F206974656D2E67657456616C75652829203A2022223B0A202020207D0A0A2020202066756E6374696F6E207361766553746174';
wwv_flow_imp.g_varchar2_table(10) := '6528646174652C207669657729207B0A2020202020202020617065782E6974656D28636F6E6669672E6461794974656D292E73657456616C75652864617465293B0A2020202020202020617065782E6974656D28636F6E6669672E766965774974656D29';
wwv_flow_imp.g_varchar2_table(11) := '2E73657456616C75652876696577293B0A0A2020202020202020617065782E7365727665722E706C7567696E28636F6E6669672E616A617849642C207B0A2020202020202020202020207830313A20646174652C0A202020202020202020202020783032';
wwv_flow_imp.g_varchar2_table(12) := '3A20766965770A20202020202020207D2C207B0A20202020202020202020202071756575653A207B0A202020202020202020202020202020206E616D653A202272656D656D62657243616C656E6461725374617465222C0A202020202020202020202020';
wwv_flow_imp.g_varchar2_table(13) := '20202020616374696F6E3A20227265706C616365220A2020202020202020202020207D0A20202020202020207D293B0A202020207D0A0A202020206F726967696E616C4461746573536574203D2063616C656E6461722E6765744F7074696F6E28226461';
wwv_flow_imp.g_varchar2_table(14) := '74657353657422293B0A2020202063616C656E6461722E7365744F7074696F6E28226461746573536574222C2066756E6374696F6E2028696E666F29207B0A202020202020202069662028747970656F66206F726967696E616C4461746573536574203D';
wwv_flow_imp.g_varchar2_table(15) := '3D3D202266756E6374696F6E2229207B0A2020202020202020202020206F726967696E616C446174657353657428696E666F293B0A20202020202020207D0A0A20202020202020206966202821726573746F72696E6729207B0A20202020202020202020';
wwv_flow_imp.g_varchar2_table(16) := '202073617665537461746528696E666F2E73746172745374722E737562737472696E6728302C203130292C20696E666F2E766965772E74797065293B0A20202020202020207D0A202020207D293B0A0A2020202077696E646F772E73657454696D656F75';
wwv_flow_imp.g_varchar2_table(17) := '742866756E6374696F6E202829207B0A202020202020202076617220736176656444617465203D206974656D56616C756528636F6E6669672E6461794974656D293B0A202020202020202076617220736176656456696577203D206974656D56616C7565';
wwv_flow_imp.g_varchar2_table(18) := '28636F6E6669672E766965774974656D293B0A0A20202020202020206966202873617665645669657729207B0A20202020202020202020202063616C656E6461722E6368616E67655669657728736176656456696577293B0A20202020202020207D0A0A';
wwv_flow_imp.g_varchar2_table(19) := '20202020202020206966202873617665644461746529207B0A20202020202020202020202063616C656E6461722E676F746F4461746528736176656444617465293B0A20202020202020207D0A0A2020202020202020726573746F72696E67203D206661';
wwv_flow_imp.g_varchar2_table(20) := '6C73653B0A202020202020202063616C656E646172456C656D656E742E63737328227669736962696C697479222C202222293B0A202020207D2C20313530293B0A7D3B0A';
null;
end;
/
begin
wwv_flow_imp_shared.create_plugin_file(
 p_id=>wwv_flow_imp.id(8743386690322470)
,p_plugin_id=>wwv_flow_imp.id(8743038207322467)
,p_file_name=>'js/rememberCalendarState.js'
,p_mime_type=>'application/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false)
);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
