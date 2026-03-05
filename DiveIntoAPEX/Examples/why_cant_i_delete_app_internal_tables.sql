-- =============================================================================
--  WHY_CANT_I_DELETE_APP  -  Internal Tables Edition
--  Schema  : APEX engine schema only (e.g. APEX_240200, APEX_230100, etc.)
--  Database: Oracle 23ai / APEX 24.2
--
--  Purpose : Identifies cross-app FK violations that prevent an APEX application
--            from being deleted, by querying internal APEX tables directly.
--            Covers all dangerous (NO ACTION delete rule) FK constraints.
--
--  IMPORTANT: This procedure requires direct SELECT access to internal APEX
--             tables (WWV_FLOWS, WWV_FLOW_STEP_BUTTONS, etc.).  It can only
--             be created and run while connected as the APEX engine schema user
--             (e.g. APEX_240200).  For a version usable by any APEX developer
--             schema, see why_cant_i_delete_app_public_views.sql instead.
--
--  Usage:
--    SET SERVEROUTPUT ON SIZE UNLIMITED
--    EXEC why_cant_i_delete_app( <application_id> );
-- =============================================================================

CREATE OR REPLACE PROCEDURE why_cant_i_delete_app (
    p_app_id IN NUMBER
) IS
    l_sgid  NUMBER;
    l_count NUMBER := 0;

    PROCEDURE p( p_msg IN VARCHAR2 ) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE( p_msg );
    END p;

    PROCEDURE section( p_title IN VARCHAR2 ) IS
    BEGIN
        p( '' );
        p( '>>> ' || p_title );
        p( RPAD( '-', LEAST( LENGTH(p_title) + 4, 80 ), '-' ) );
    END section;

    PROCEDURE found(
        p_offender_type IN VARCHAR2,
        p_offender_desc IN VARCHAR2,
        p_bad_col       IN VARCHAR2,
        p_bad_val       IN NUMBER,
        p_target_type   IN VARCHAR2,
        p_target_name   IN VARCHAR2
    ) IS
    BEGIN
        l_count := l_count + 1;
        p( '  [#' || l_count || '] ' || p_offender_type || ':' );
        p( '       ' || p_offender_desc );
        p( '       Column  : ' || p_bad_col || ' = ' || p_bad_val );
        p( '       Locks   : ' || p_target_type || ' ""'  || p_target_name
                               || '"" (App ' || p_app_id || ')' );
    END found;

BEGIN
    -- ----------------------------------------------------------------
    -- Validate the target app exists and get its workspace
    -- ----------------------------------------------------------------
    BEGIN
        SELECT security_group_id
          INTO l_sgid
          FROM wwv_flows
         WHERE id = p_app_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p( 'ERROR: Application ' || p_app_id || ' does not exist.' );
            RETURN;
    END;

    p( '================================================================' );
    p( '  WHY CANT I DELETE APP ' || p_app_id || '?' );
    p( '  Workspace (security_group_id): ' || l_sgid );
    p( '  Checking all cross-app FK violations ...' );
    p( '================================================================' );

    -- ================================================================
    -- 1. WWV_FLOWS (other apps) referencing shared components of target
    -- ================================================================
    section( 'APPLICATION SETTINGS referencing App ' || p_app_id || ' shared components' );

    FOR r IN (
        SELECT f.id app_id, f.name app_name, f.authentication_id, a.name auth_name
          FROM wwv_flows f
          JOIN wwv_flow_authentications a
            ON a.id      = f.authentication_id
           AND a.flow_id = p_app_id
         WHERE f.security_group_id = l_sgid
           AND f.id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id, r.app_name,
               'AUTHENTICATION_ID', r.authentication_id,
               'Authentication Scheme', r.auth_name );
    END LOOP;

    FOR r IN (
        SELECT f.id app_id, f.name app_name, f.navigation_list_id, l.name list_name
          FROM wwv_flows f
          JOIN wwv_flow_lists l
            ON l.id      = f.navigation_list_id
           AND l.flow_id = p_app_id
         WHERE f.security_group_id = l_sgid AND f.id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id, r.app_name,
               'NAVIGATION_LIST_ID', r.navigation_list_id,
               'List', r.list_name );
    END LOOP;

    FOR r IN (
        SELECT f.id app_id, f.name app_name, f.nav_bar_list_id, l.name list_name
          FROM wwv_flows f
          JOIN wwv_flow_lists l
            ON l.id      = f.nav_bar_list_id
           AND l.flow_id = p_app_id
         WHERE f.security_group_id = l_sgid AND f.id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id, r.app_name,
               'NAV_BAR_LIST_ID', r.nav_bar_list_id,
               'List', r.list_name );
    END LOOP;

    FOR r IN (
        SELECT f.id app_id, f.name app_name,
               f.navigation_list_template_id, t.list_template_name
          FROM wwv_flows f
          JOIN wwv_flow_list_templates t
            ON t.id      = f.navigation_list_template_id
           AND t.flow_id = p_app_id
         WHERE f.security_group_id = l_sgid AND f.id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id, r.app_name,
               'NAVIGATION_LIST_TEMPLATE_ID', r.navigation_list_template_id,
               'List Template', r.list_template_name );
    END LOOP;

    FOR r IN (
        SELECT f.id app_id, f.name app_name,
               f.nav_bar_list_template_id, t.list_template_name
          FROM wwv_flows f
          JOIN wwv_flow_list_templates t
            ON t.id      = f.nav_bar_list_template_id
           AND t.flow_id = p_app_id
         WHERE f.security_group_id = l_sgid AND f.id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id, r.app_name,
               'NAV_BAR_LIST_TEMPLATE_ID', r.nav_bar_list_template_id,
               'List Template', r.list_template_name );
    END LOOP;

    -- ================================================================
    -- 2. WWV_FLOW_STEPS (pages) referencing lists/templates of target
    -- ================================================================
    section( 'PAGES in other apps referencing App ' || p_app_id || ' lists/templates' );

    FOR r IN (
        SELECT s.flow_id app_id, s.id page_id, s.name page_name,
               s.navigation_list_id, l.name list_name
          FROM wwv_flow_steps s
          JOIN wwv_flow_lists l
            ON l.id      = s.navigation_list_id
           AND l.flow_id = p_app_id
         WHERE s.security_group_id = l_sgid AND s.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Page ' || r.page_id, r.page_name,
               'NAVIGATION_LIST_ID', r.navigation_list_id,
               'List', r.list_name );
    END LOOP;

    FOR r IN (
        SELECT s.flow_id app_id, s.id page_id, s.name page_name,
               s.navigation_list_template_id, t.list_template_name
          FROM wwv_flow_steps s
          JOIN wwv_flow_list_templates t
            ON t.id      = s.navigation_list_template_id
           AND t.flow_id = p_app_id
         WHERE s.security_group_id = l_sgid AND s.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Page ' || r.page_id, r.page_name,
               'NAVIGATION_LIST_TEMPLATE_ID', r.navigation_list_template_id,
               'List Template', r.list_template_name );
    END LOOP;

    -- ================================================================
    -- 3. WWV_FLOW_PAGE_PLUGS (regions) referencing target app components
    -- ================================================================
    section( 'REGIONS in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT pl.flow_id app_id, pl.page_id, pl.plug_name region_name,
               pl.list_id, l.name list_name
          FROM wwv_flow_page_plugs pl
          JOIN wwv_flow_lists l
            ON l.id      = pl.list_id
           AND l.flow_id = p_app_id
         WHERE pl.security_group_id = l_sgid AND pl.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Page ' || r.page_id || ' / Region', r.region_name,
               'LIST_ID', r.list_id, 'List', r.list_name );
    END LOOP;

    FOR r IN (
        SELECT pl.flow_id app_id, pl.page_id, pl.plug_name region_name,
               pl.menu_id, m.name menu_name
          FROM wwv_flow_page_plugs pl
          JOIN wwv_flow_menus m
            ON m.id      = pl.menu_id
           AND m.flow_id = p_app_id
         WHERE pl.security_group_id = l_sgid AND pl.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Page ' || r.page_id || ' / Region', r.region_name,
               'MENU_ID', r.menu_id, 'Breadcrumb/Menu', r.menu_name );
    END LOOP;

    FOR r IN (
        SELECT pl.flow_id app_id, pl.page_id, pl.plug_name region_name,
               pl.web_src_module_id, wm.name wsm_name
          FROM wwv_flow_page_plugs pl
          JOIN wwv_flow_web_src_modules wm
            ON wm.id      = pl.web_src_module_id
           AND wm.flow_id = p_app_id
         WHERE pl.security_group_id = l_sgid AND pl.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Page ' || r.page_id || ' / Region', r.region_name,
               'WEB_SRC_MODULE_ID', r.web_src_module_id,
               'Web Source Module', r.wsm_name );
    END LOOP;

    FOR r IN (
        SELECT pl.flow_id app_id, pl.page_id, pl.plug_name region_name,
               pl.master_region_id, mr.plug_name master_name, mr.page_id master_page
          FROM wwv_flow_page_plugs pl
          JOIN wwv_flow_page_plugs mr
            ON mr.id      = pl.master_region_id
           AND mr.flow_id = p_app_id
         WHERE pl.security_group_id = l_sgid AND pl.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Page ' || r.page_id || ' / Region', r.region_name,
               'MASTER_REGION_ID', r.master_region_id,
               'Region (Page ' || r.master_page || ')', r.master_name );
    END LOOP;

    FOR r IN (
        SELECT pl.flow_id app_id, pl.page_id, pl.plug_name region_name,
               pl.ai_config_id, ai.name ai_name
          FROM wwv_flow_page_plugs pl
          JOIN wwv_flow_ai_configs ai
            ON ai.id      = pl.ai_config_id
           AND ai.flow_id = p_app_id
         WHERE pl.security_group_id = l_sgid AND pl.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Page ' || r.page_id || ' / Region', r.region_name,
               'AI_CONFIG_ID', r.ai_config_id, 'AI Configuration', r.ai_name );
    END LOOP;

    FOR r IN (
        SELECT pl.flow_id app_id, pl.page_id, pl.plug_name region_name,
               pl.array_column_id, dc.name col_name
          FROM wwv_flow_page_plugs pl
          JOIN wwv_flow_data_profile_cols dc
            ON dc.id      = pl.array_column_id
           AND dc.flow_id = p_app_id
         WHERE pl.security_group_id = l_sgid AND pl.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Page ' || r.page_id || ' / Region', r.region_name,
               'ARRAY_COLUMN_ID', r.array_column_id,
               'Data Profile Column', r.col_name );
    END LOOP;

    FOR r IN (
        SELECT pl.flow_id app_id, pl.page_id, pl.plug_name region_name,
               pl.document_source_id, ds.name doc_name
          FROM wwv_flow_page_plugs pl
          JOIN wwv_flow_document_sources ds
            ON ds.id      = pl.document_source_id
           AND ds.flow_id = p_app_id
         WHERE pl.security_group_id = l_sgid AND pl.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Page ' || r.page_id || ' / Region', r.region_name,
               'DOCUMENT_SOURCE_ID', r.document_source_id,
               'Document Source (Duality View/JSON)', r.doc_name );
    END LOOP;

    -- ================================================================
    -- 4. WWV_FLOW_STEP_BUTTONS → button templates
    -- ================================================================
    section( 'BUTTONS in other apps referencing App ' || p_app_id || ' button templates' );

    FOR r IN (
        SELECT b.flow_id app_id, b.flow_step_id page_id, b.button_name,
               b.button_template_id, bt.template_name
          FROM wwv_flow_step_buttons b
          JOIN wwv_flow_button_templates bt
            ON bt.id      = b.button_template_id
           AND bt.flow_id = p_app_id
         WHERE b.security_group_id = l_sgid AND b.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Page ' || r.page_id || ' / Button', r.button_name,
               'BUTTON_TEMPLATE_ID', r.button_template_id,
               'Button Template', r.template_name );
    END LOOP;

    -- ================================================================
    -- 5. WWV_FLOW_STEP_ITEMS → AI configs
    -- ================================================================
    section( 'PAGE ITEMS in other apps referencing App ' || p_app_id || ' AI configurations' );

    FOR r IN (
        SELECT i.flow_id app_id, i.flow_step_id page_id, i.name item_name,
               i.ai_config_id, ai.name ai_name
          FROM wwv_flow_step_items i
          JOIN wwv_flow_ai_configs ai
            ON ai.id      = i.ai_config_id
           AND ai.flow_id = p_app_id
         WHERE i.security_group_id = l_sgid AND i.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Page ' || r.page_id || ' / Item', r.item_name,
               'AI_CONFIG_ID', r.ai_config_id, 'AI Configuration', r.ai_name );
    END LOOP;

    -- ================================================================
    -- 6. WWV_FLOW_PROCESSING (app-level processes) → email tmpl / web src op
    -- ================================================================
    section( 'APP PROCESSES in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT pr.flow_id app_id, pr.process_name,
               pr.email_template_id, et.name email_tmpl_name
          FROM wwv_flow_processing pr
          JOIN wwv_flow_email_templates et
            ON et.id      = pr.email_template_id
           AND et.flow_id = p_app_id
         WHERE pr.security_group_id = l_sgid AND pr.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / App Process', r.process_name,
               'EMAIL_TEMPLATE_ID', r.email_template_id,
               'Email Template', r.email_tmpl_name );
    END LOOP;

    FOR r IN (
        SELECT pr.flow_id app_id, pr.process_name,
               pr.web_src_operation_id, wo.name op_name
          FROM wwv_flow_processing pr
          JOIN wwv_flow_web_src_operations wo
            ON wo.id      = pr.web_src_operation_id
           AND wo.flow_id = p_app_id
         WHERE pr.security_group_id = l_sgid AND pr.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / App Process', r.process_name,
               'WEB_SRC_OPERATION_ID', r.web_src_operation_id,
               'Web Source Operation', r.op_name );
    END LOOP;

    -- ================================================================
    -- 7. WWV_FLOW_STEP_PROCESSING (page processes) → email tmpl / web src
    -- ================================================================
    section( 'PAGE PROCESSES in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT sp.flow_id app_id, sp.flow_step_id page_id, sp.process_name,
               sp.email_template_id, et.name email_tmpl_name
          FROM wwv_flow_step_processing sp
          JOIN wwv_flow_email_templates et
            ON et.id      = sp.email_template_id
           AND et.flow_id = p_app_id
         WHERE sp.security_group_id = l_sgid AND sp.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Page ' || r.page_id || ' / Process', r.process_name,
               'EMAIL_TEMPLATE_ID', r.email_template_id,
               'Email Template', r.email_tmpl_name );
    END LOOP;

    FOR r IN (
        SELECT sp.flow_id app_id, sp.flow_step_id page_id, sp.process_name,
               sp.web_src_module_id, wm.name wsm_name
          FROM wwv_flow_step_processing sp
          JOIN wwv_flow_web_src_modules wm
            ON wm.id      = sp.web_src_module_id
           AND wm.flow_id = p_app_id
         WHERE sp.security_group_id = l_sgid AND sp.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Page ' || r.page_id || ' / Process', r.process_name,
               'WEB_SRC_MODULE_ID', r.web_src_module_id,
               'Web Source Module', r.wsm_name );
    END LOOP;

    FOR r IN (
        SELECT sp.flow_id app_id, sp.flow_step_id page_id, sp.process_name,
               sp.web_src_operation_id, wo.name op_name
          FROM wwv_flow_step_processing sp
          JOIN wwv_flow_web_src_operations wo
            ON wo.id      = sp.web_src_operation_id
           AND wo.flow_id = p_app_id
         WHERE sp.security_group_id = l_sgid AND sp.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Page ' || r.page_id || ' / Process', r.process_name,
               'WEB_SRC_OPERATION_ID', r.web_src_operation_id,
               'Web Source Operation', r.op_name );
    END LOOP;

    -- ================================================================
    -- 8. WWV_FLOW_AUTOMATIONS → web src modules / doc sources
    -- ================================================================
    section( 'AUTOMATIONS in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT am.flow_id app_id, am.name automation_name,
               am.web_src_module_id, wm.name wsm_name
          FROM wwv_flow_automations am
          JOIN wwv_flow_web_src_modules wm
            ON wm.id      = am.web_src_module_id
           AND wm.flow_id = p_app_id
         WHERE am.security_group_id = l_sgid AND am.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Automation', r.automation_name,
               'WEB_SRC_MODULE_ID', r.web_src_module_id,
               'Web Source Module', r.wsm_name );
    END LOOP;

    FOR r IN (
        SELECT am.flow_id app_id, am.name automation_name,
               am.document_source_id, ds.name doc_name
          FROM wwv_flow_automations am
          JOIN wwv_flow_document_sources ds
            ON ds.id      = am.document_source_id
           AND ds.flow_id = p_app_id
         WHERE am.security_group_id = l_sgid AND am.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Automation', r.automation_name,
               'DOCUMENT_SOURCE_ID', r.document_source_id,
               'Document Source', r.doc_name );
    END LOOP;

    FOR r IN (
        SELECT am.flow_id app_id, am.name automation_name,
               am.array_column_id, dc.name col_name
          FROM wwv_flow_automations am
          JOIN wwv_flow_data_profile_cols dc
            ON dc.id      = am.array_column_id
           AND dc.flow_id = p_app_id
         WHERE am.security_group_id = l_sgid AND am.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Automation', r.automation_name,
               'ARRAY_COLUMN_ID', r.array_column_id,
               'Data Profile Column', r.col_name );
    END LOOP;

    -- Automation Actions
    FOR r IN (
        SELECT aa.flow_id app_id, aa.automation_id, aa.name action_name,
               aa.web_src_module_id, wm.name wsm_name
          FROM wwv_flow_automation_actions aa
          JOIN wwv_flow_web_src_modules wm
            ON wm.id      = aa.web_src_module_id
           AND wm.flow_id = p_app_id
         WHERE aa.security_group_id = l_sgid AND aa.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Automation ID=' || r.automation_id || ' / Action',
               r.action_name, 'WEB_SRC_MODULE_ID', r.web_src_module_id,
               'Web Source Module', r.wsm_name );
    END LOOP;

    FOR r IN (
        SELECT aa.flow_id app_id, aa.automation_id, aa.name action_name,
               aa.web_src_operation_id, wo.name op_name
          FROM wwv_flow_automation_actions aa
          JOIN wwv_flow_web_src_operations wo
            ON wo.id      = aa.web_src_operation_id
           AND wo.flow_id = p_app_id
         WHERE aa.security_group_id = l_sgid AND aa.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Automation ID=' || r.automation_id || ' / Action',
               r.action_name, 'WEB_SRC_OPERATION_ID', r.web_src_operation_id,
               'Web Source Operation', r.op_name );
    END LOOP;

    FOR r IN (
        SELECT aa.flow_id app_id, aa.automation_id, aa.name action_name,
               aa.email_template_id, et.name email_tmpl_name
          FROM wwv_flow_automation_actions aa
          JOIN wwv_flow_email_templates et
            ON et.id      = aa.email_template_id
           AND et.flow_id = p_app_id
         WHERE aa.security_group_id = l_sgid AND aa.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Automation ID=' || r.automation_id || ' / Action',
               r.action_name, 'EMAIL_TEMPLATE_ID', r.email_template_id,
               'Email Template', r.email_tmpl_name );
    END LOOP;

    -- ================================================================
    -- 9. WWV_FLOW_LISTS_OF_VALUES$ (LOVs) → web sources / doc sources
    -- ================================================================
    section( 'LOVs in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT lov.flow_id app_id, lov.lov_name,
               lov.web_src_module_id, wm.name wsm_name
          FROM wwv_flow_lists_of_values$ lov
          JOIN wwv_flow_web_src_modules wm
            ON wm.id      = lov.web_src_module_id
           AND wm.flow_id = p_app_id
         WHERE lov.security_group_id = l_sgid AND lov.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / LOV', r.lov_name,
               'WEB_SRC_MODULE_ID', r.web_src_module_id,
               'Web Source Module', r.wsm_name );
    END LOOP;

    FOR r IN (
        SELECT lov.flow_id app_id, lov.lov_name,
               lov.array_column_id, dc.name col_name
          FROM wwv_flow_lists_of_values$ lov
          JOIN wwv_flow_data_profile_cols dc
            ON dc.id      = lov.array_column_id
           AND dc.flow_id = p_app_id
         WHERE lov.security_group_id = l_sgid AND lov.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / LOV', r.lov_name,
               'ARRAY_COLUMN_ID', r.array_column_id,
               'Data Profile Column', r.col_name );
    END LOOP;

    FOR r IN (
        SELECT lov.flow_id app_id, lov.lov_name,
               lov.document_source_id, ds.name doc_name
          FROM wwv_flow_lists_of_values$ lov
          JOIN wwv_flow_document_sources ds
            ON ds.id      = lov.document_source_id
           AND ds.flow_id = p_app_id
         WHERE lov.security_group_id = l_sgid AND lov.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / LOV', r.lov_name,
               'DOCUMENT_SOURCE_ID', r.document_source_id,
               'Document Source', r.doc_name );
    END LOOP;

    -- ================================================================
    -- 10. WWV_FLOW_SEARCH_CONFIGS → lists, web src, doc sources
    -- ================================================================
    section( 'SEARCH CONFIGURATIONS in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT sc.flow_id app_id, sc.label sc_name,
               sc.list_id, l.name list_name
          FROM wwv_flow_search_configs sc
          JOIN wwv_flow_lists l
            ON l.id      = sc.list_id
           AND l.flow_id = p_app_id
         WHERE sc.security_group_id = l_sgid AND sc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Search Config', r.sc_name,
               'LIST_ID', r.list_id, 'List', r.list_name );
    END LOOP;

    FOR r IN (
        SELECT sc.flow_id app_id, sc.label sc_name,
               sc.web_src_module_id, wm.name wsm_name
          FROM wwv_flow_search_configs sc
          JOIN wwv_flow_web_src_modules wm
            ON wm.id      = sc.web_src_module_id
           AND wm.flow_id = p_app_id
         WHERE sc.security_group_id = l_sgid AND sc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Search Config', r.sc_name,
               'WEB_SRC_MODULE_ID', r.web_src_module_id,
               'Web Source Module', r.wsm_name );
    END LOOP;

    FOR r IN (
        SELECT sc.flow_id app_id, sc.label sc_name,
               sc.document_source_id, ds.name doc_name
          FROM wwv_flow_search_configs sc
          JOIN wwv_flow_document_sources ds
            ON ds.id      = sc.document_source_id
           AND ds.flow_id = p_app_id
         WHERE sc.security_group_id = l_sgid AND sc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Search Config', r.sc_name,
               'DOCUMENT_SOURCE_ID', r.document_source_id,
               'Document Source', r.doc_name );
    END LOOP;

    FOR r IN (
        SELECT sc.flow_id app_id, sc.label sc_name,
               sc.array_column_id, dc.name col_name
          FROM wwv_flow_search_configs sc
          JOIN wwv_flow_data_profile_cols dc
            ON dc.id      = sc.array_column_id
           AND dc.flow_id = p_app_id
         WHERE sc.security_group_id = l_sgid AND sc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Search Config', r.sc_name,
               'ARRAY_COLUMN_ID', r.array_column_id,
               'Data Profile Column', r.col_name );
    END LOOP;

    -- ================================================================
    -- 11. WWV_FLOW_SEARCH_REGION_SOURCES → search configs
    -- ================================================================
    section( 'SEARCH REGION SOURCES in other apps referencing App ' || p_app_id || ' search configs' );

    FOR r IN (
        SELECT srs.flow_id app_id, srs.page_id,
               srs.search_config_id, sc.label sc_name
          FROM wwv_flow_search_region_sources srs
          JOIN wwv_flow_search_configs sc
            ON sc.id      = srs.search_config_id
           AND sc.flow_id = p_app_id
         WHERE srs.security_group_id = l_sgid AND srs.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Page ' || r.page_id || ' / Search Source',
               '(search region source)',
               'SEARCH_CONFIG_ID', r.search_config_id,
               'Search Configuration', r.sc_name );
    END LOOP;

    -- ================================================================
    -- 12. WWV_FLOW_JET_CHART_SERIES → web sources / doc sources
    -- ================================================================
    section( 'CHART SERIES in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT jcs.flow_id app_id, jcs.chart_id, jcs.name series_name,
               jcs.web_src_module_id, wm.name wsm_name
          FROM wwv_flow_jet_chart_series jcs
          JOIN wwv_flow_web_src_modules wm
            ON wm.id      = jcs.web_src_module_id
           AND wm.flow_id = p_app_id
         WHERE jcs.security_group_id = l_sgid AND jcs.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Chart ID=' || r.chart_id || ' / Series',
               r.series_name, 'WEB_SRC_MODULE_ID', r.web_src_module_id,
               'Web Source Module', r.wsm_name );
    END LOOP;

    FOR r IN (
        SELECT jcs.flow_id app_id, jcs.chart_id, jcs.name series_name,
               jcs.document_source_id, ds.name doc_name
          FROM wwv_flow_jet_chart_series jcs
          JOIN wwv_flow_document_sources ds
            ON ds.id      = jcs.document_source_id
           AND ds.flow_id = p_app_id
         WHERE jcs.security_group_id = l_sgid AND jcs.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Chart ID=' || r.chart_id || ' / Series',
               r.series_name, 'DOCUMENT_SOURCE_ID', r.document_source_id,
               'Document Source', r.doc_name );
    END LOOP;

    FOR r IN (
        SELECT jcs.flow_id app_id, jcs.chart_id, jcs.name series_name,
               jcs.array_column_id, dc.name col_name
          FROM wwv_flow_jet_chart_series jcs
          JOIN wwv_flow_data_profile_cols dc
            ON dc.id      = jcs.array_column_id
           AND dc.flow_id = p_app_id
         WHERE jcs.security_group_id = l_sgid AND jcs.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Chart ID=' || r.chart_id || ' / Series',
               r.series_name, 'ARRAY_COLUMN_ID', r.array_column_id,
               'Data Profile Column', r.col_name );
    END LOOP;

    -- ================================================================
    -- 13. WWV_FLOW_MAP_REGIONS → map backgrounds
    -- ================================================================
    section( 'MAP REGIONS in other apps referencing App ' || p_app_id || ' map backgrounds' );

    FOR r IN (
        SELECT mr.flow_id app_id, mr.region_id,
               mr.default_shared_tilelayer_id, mb.name bg_name
          FROM wwv_flow_map_regions mr
          JOIN wwv_flow_map_backgrounds mb
            ON mb.id      = mr.default_shared_tilelayer_id
           AND mb.flow_id = p_app_id
         WHERE mr.security_group_id = l_sgid AND mr.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Map Region ID=' || r.region_id,
               '(map region)',
               'DEFAULT_SHARED_TILELAYER_ID', r.default_shared_tilelayer_id,
               'Map Background', r.bg_name );
    END LOOP;

    FOR r IN (
        SELECT mr.flow_id app_id, mr.region_id,
               mr.darkmode_shared_tilelayer_id, mb.name bg_name
          FROM wwv_flow_map_regions mr
          JOIN wwv_flow_map_backgrounds mb
            ON mb.id      = mr.darkmode_shared_tilelayer_id
           AND mb.flow_id = p_app_id
         WHERE mr.security_group_id = l_sgid AND mr.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Map Region ID=' || r.region_id,
               '(map region)',
               'DARKMODE_SHARED_TILELAYER_ID', r.darkmode_shared_tilelayer_id,
               'Map Background', r.bg_name );
    END LOOP;

    -- ================================================================
    -- 14. WWV_FLOW_MAP_REGION_LAYERS → web sources / doc sources
    -- ================================================================
    section( 'MAP LAYERS in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT mrl.flow_id app_id, mrl.map_region_id, mrl.name layer_name,
               mrl.web_src_module_id, wm.name wsm_name
          FROM wwv_flow_map_region_layers mrl
          JOIN wwv_flow_web_src_modules wm
            ON wm.id      = mrl.web_src_module_id
           AND wm.flow_id = p_app_id
         WHERE mrl.security_group_id = l_sgid AND mrl.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Map Region ID=' || r.map_region_id || ' / Layer',
               r.layer_name, 'WEB_SRC_MODULE_ID', r.web_src_module_id,
               'Web Source Module', r.wsm_name );
    END LOOP;

    FOR r IN (
        SELECT mrl.flow_id app_id, mrl.map_region_id, mrl.name layer_name,
               mrl.document_source_id, ds.name doc_name
          FROM wwv_flow_map_region_layers mrl
          JOIN wwv_flow_document_sources ds
            ON ds.id      = mrl.document_source_id
           AND ds.flow_id = p_app_id
         WHERE mrl.security_group_id = l_sgid AND mrl.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Map Region ID=' || r.map_region_id || ' / Layer',
               r.layer_name, 'DOCUMENT_SOURCE_ID', r.document_source_id,
               'Document Source', r.doc_name );
    END LOOP;

    FOR r IN (
        SELECT mrl.flow_id app_id, mrl.map_region_id, mrl.name layer_name,
               mrl.array_column_id, dc.name col_name
          FROM wwv_flow_map_region_layers mrl
          JOIN wwv_flow_data_profile_cols dc
            ON dc.id      = mrl.array_column_id
           AND dc.flow_id = p_app_id
         WHERE mrl.security_group_id = l_sgid AND mrl.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Map Region ID=' || r.map_region_id || ' / Layer',
               r.layer_name, 'ARRAY_COLUMN_ID', r.array_column_id,
               'Data Profile Column', r.col_name );
    END LOOP;

    -- ================================================================
    -- 15. WWV_FLOW_WEB_SRC_MODULES → data profiles of target app
    -- ================================================================
    section( 'WEB SOURCE MODULES in other apps referencing App ' || p_app_id || ' data profiles' );

    FOR r IN (
        SELECT wm.flow_id app_id, wm.name wsm_name,
               wm.data_profile_id, dp.name dp_name
          FROM wwv_flow_web_src_modules wm
          JOIN wwv_flow_data_profiles dp
            ON dp.id      = wm.data_profile_id
           AND dp.flow_id = p_app_id
         WHERE wm.security_group_id = l_sgid AND wm.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Web Source Module', r.wsm_name,
               'DATA_PROFILE_ID', r.data_profile_id,
               'Data Profile', r.dp_name );
    END LOOP;

    FOR r IN (
        SELECT wm.flow_id app_id, wm.name wsm_name,
               wm.sync_array_col_id, dc.name col_name
          FROM wwv_flow_web_src_modules wm
          JOIN wwv_flow_data_profile_cols dc
            ON dc.id      = wm.sync_array_col_id
           AND dc.flow_id = p_app_id
         WHERE wm.security_group_id = l_sgid AND wm.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Web Source Module', r.wsm_name,
               'SYNC_ARRAY_COL_ID', r.sync_array_col_id,
               'Data Profile Column', r.col_name );
    END LOOP;

    -- ================================================================
    -- 16. WWV_FLOW_WEB_SRC_OPERATIONS → data profiles
    -- ================================================================
    section( 'WEB SOURCE OPERATIONS in other apps referencing App ' || p_app_id || ' data profiles' );

    FOR r IN (
        SELECT wo.flow_id app_id, wo.name op_name,
               wo.data_profile_id, dp.name dp_name
          FROM wwv_flow_web_src_operations wo
          JOIN wwv_flow_data_profiles dp
            ON dp.id      = wo.data_profile_id
           AND dp.flow_id = p_app_id
         WHERE wo.security_group_id = l_sgid AND wo.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Web Source Operation', r.op_name,
               'DATA_PROFILE_ID', r.data_profile_id,
               'Data Profile', r.dp_name );
    END LOOP;

    FOR r IN (
        SELECT wo.flow_id app_id, wo.name op_name,
               wo.data_profile_array_col_id, dc.name col_name
          FROM wwv_flow_web_src_operations wo
          JOIN wwv_flow_data_profile_cols dc
            ON dc.id      = wo.data_profile_array_col_id
           AND dc.flow_id = p_app_id
         WHERE wo.security_group_id = l_sgid AND wo.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Web Source Operation', r.op_name,
               'DATA_PROFILE_ARRAY_COL_ID', r.data_profile_array_col_id,
               'Data Profile Column', r.col_name );
    END LOOP;

    -- ================================================================
    -- 17. WWV_FLOW_SHARED_QRY_SQL_STMTS (Report Query SQL statements)
    --     → web sources / doc sources
    -- ================================================================
    section( 'REPORT QUERY SOURCES in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT sq.flow_id app_id, sq.name stmt_name,
               sq.web_src_module_id, wm.name wsm_name
          FROM wwv_flow_shared_qry_sql_stmts sq
          JOIN wwv_flow_web_src_modules wm
            ON wm.id      = sq.web_src_module_id
           AND wm.flow_id = p_app_id
         WHERE sq.security_group_id = l_sgid AND sq.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Report Query Source', r.stmt_name,
               'WEB_SRC_MODULE_ID', r.web_src_module_id,
               'Web Source Module', r.wsm_name );
    END LOOP;

    FOR r IN (
        SELECT sq.flow_id app_id, sq.name stmt_name,
               sq.document_source_id, ds.name doc_name
          FROM wwv_flow_shared_qry_sql_stmts sq
          JOIN wwv_flow_document_sources ds
            ON ds.id      = sq.document_source_id
           AND ds.flow_id = p_app_id
         WHERE sq.security_group_id = l_sgid AND sq.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Report Query Source', r.stmt_name,
               'DOCUMENT_SOURCE_ID', r.document_source_id,
               'Document Source', r.doc_name );
    END LOOP;

    FOR r IN (
        SELECT sq.flow_id app_id, sq.name stmt_name,
               sq.array_column_id, dc.name col_name
          FROM wwv_flow_shared_qry_sql_stmts sq
          JOIN wwv_flow_data_profile_cols dc
            ON dc.id      = sq.array_column_id
           AND dc.flow_id = p_app_id
         WHERE sq.security_group_id = l_sgid AND sq.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Report Query Source', r.stmt_name,
               'ARRAY_COLUMN_ID', r.array_column_id,
               'Data Profile Column', r.col_name );
    END LOOP;

    -- ================================================================
    -- 18. WWV_FLOW_TASK_DEF_ACTIONS → email templates, web src ops/modules
    -- ================================================================
    section( 'TASK DEFINITION ACTIONS in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT tda.flow_id app_id, tda.task_def_id, tda.name action_name,
               tda.email_template_id, et.name email_tmpl_name
          FROM wwv_flow_task_def_actions tda
          JOIN wwv_flow_email_templates et
            ON et.id      = tda.email_template_id
           AND et.flow_id = p_app_id
         WHERE tda.security_group_id = l_sgid AND tda.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Task Def ID=' || r.task_def_id || ' / Action',
               r.action_name, 'EMAIL_TEMPLATE_ID', r.email_template_id,
               'Email Template', r.email_tmpl_name );
    END LOOP;

    FOR r IN (
        SELECT tda.flow_id app_id, tda.task_def_id, tda.name action_name,
               tda.web_src_module_id, wm.name wsm_name
          FROM wwv_flow_task_def_actions tda
          JOIN wwv_flow_web_src_modules wm
            ON wm.id      = tda.web_src_module_id
           AND wm.flow_id = p_app_id
         WHERE tda.security_group_id = l_sgid AND tda.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Task Def ID=' || r.task_def_id || ' / Action',
               r.action_name, 'WEB_SRC_MODULE_ID', r.web_src_module_id,
               'Web Source Module', r.wsm_name );
    END LOOP;

    FOR r IN (
        SELECT tda.flow_id app_id, tda.task_def_id, tda.name action_name,
               tda.web_src_operation_id, wo.name op_name
          FROM wwv_flow_task_def_actions tda
          JOIN wwv_flow_web_src_operations wo
            ON wo.id      = tda.web_src_operation_id
           AND wo.flow_id = p_app_id
         WHERE tda.security_group_id = l_sgid AND tda.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Task Def ID=' || r.task_def_id || ' / Action',
               r.action_name, 'WEB_SRC_OPERATION_ID', r.web_src_operation_id,
               'Web Source Operation', r.op_name );
    END LOOP;

    -- ================================================================
    -- 19. WWV_FLOW_WORKFLOW_ACTIVITIES → tasks, workflows, email/web src
    -- ================================================================
    section( 'WORKFLOW ACTIVITIES in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT wa.flow_id app_id, wa.workflow_id, wa.name act_name,
               wa.task_def_id, td.name task_def_name
          FROM wwv_flow_workflow_activities wa
          JOIN wwv_flow_task_defs td
            ON td.id      = wa.task_def_id
           AND td.flow_id = p_app_id
         WHERE wa.security_group_id = l_sgid AND wa.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Workflow ID=' || r.workflow_id || ' / Activity',
               r.act_name, 'TASK_DEF_ID', r.task_def_id,
               'Task Definition', r.task_def_name );
    END LOOP;

    FOR r IN (
        SELECT wa.flow_id app_id, wa.name act_name,
               wa.workflow_id, wf.name wf_name
          FROM wwv_flow_workflow_activities wa
          JOIN wwv_flow_workflows wf
            ON wf.id      = wa.workflow_id
           AND wf.flow_id = p_app_id
         WHERE wa.security_group_id = l_sgid AND wa.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Workflow Activity', r.act_name,
               'WORKFLOW_ID', r.workflow_id, 'Workflow', r.wf_name );
    END LOOP;

    FOR r IN (
        SELECT wa.flow_id app_id, wa.workflow_id, wa.name act_name,
               wa.email_template_id, et.name email_tmpl_name
          FROM wwv_flow_workflow_activities wa
          JOIN wwv_flow_email_templates et
            ON et.id      = wa.email_template_id
           AND et.flow_id = p_app_id
         WHERE wa.security_group_id = l_sgid AND wa.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Workflow ID=' || r.workflow_id || ' / Activity',
               r.act_name, 'EMAIL_TEMPLATE_ID', r.email_template_id,
               'Email Template', r.email_tmpl_name );
    END LOOP;

    FOR r IN (
        SELECT wa.flow_id app_id, wa.workflow_id, wa.name act_name,
               wa.web_src_module_id, wm.name wsm_name
          FROM wwv_flow_workflow_activities wa
          JOIN wwv_flow_web_src_modules wm
            ON wm.id      = wa.web_src_module_id
           AND wm.flow_id = p_app_id
         WHERE wa.security_group_id = l_sgid AND wa.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Workflow ID=' || r.workflow_id || ' / Activity',
               r.act_name, 'WEB_SRC_MODULE_ID', r.web_src_module_id,
               'Web Source Module', r.wsm_name );
    END LOOP;

    FOR r IN (
        SELECT wa.flow_id app_id, wa.workflow_id, wa.name act_name,
               wa.web_src_operation_id, wo.name op_name
          FROM wwv_flow_workflow_activities wa
          JOIN wwv_flow_web_src_operations wo
            ON wo.id      = wa.web_src_operation_id
           AND wo.flow_id = p_app_id
         WHERE wa.security_group_id = l_sgid AND wa.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Workflow ID=' || r.workflow_id || ' / Activity',
               r.act_name, 'WEB_SRC_OPERATION_ID', r.web_src_operation_id,
               'Web Source Operation', r.op_name );
    END LOOP;

    -- ================================================================
    -- 20. WWV_FLOW_THEMES → theme styles
    -- ================================================================
    section( 'THEMES in other apps referencing App ' || p_app_id || ' theme styles' );

    FOR r IN (
        SELECT th.flow_id app_id, th.theme_id,
               th.current_theme_style_id, ts.name style_name
          FROM wwv_flow_themes th
          JOIN wwv_flow_theme_styles ts
            ON ts.id      = th.current_theme_style_id
           AND ts.flow_id = p_app_id
         WHERE th.security_group_id = l_sgid AND th.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Theme ' || r.theme_id,
               '(theme settings)',
               'CURRENT_THEME_STYLE_ID', r.current_theme_style_id,
               'Theme Style', r.style_name );
    END LOOP;

    -- ================================================================
    -- 21. WWV_FLOW_DOCUMENT_SOURCES → data profiles
    -- ================================================================
    section( 'DOCUMENT SOURCES in other apps referencing App ' || p_app_id || ' data profiles' );

    FOR r IN (
        SELECT ds.flow_id app_id, ds.name doc_name,
               ds.data_profile_id, dp.name dp_name
          FROM wwv_flow_document_sources ds
          JOIN wwv_flow_data_profiles dp
            ON dp.id      = ds.data_profile_id
           AND dp.flow_id = p_app_id
         WHERE ds.security_group_id = l_sgid AND ds.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Document Source', r.doc_name,
               'DATA_PROFILE_ID', r.data_profile_id,
               'Data Profile', r.dp_name );
    END LOOP;

    -- ================================================================
    -- 22. WWV_FLOW_LOAD_TABLES → data profiles
    -- ================================================================
    section( 'DATA LOAD TABLES in other apps referencing App ' || p_app_id || ' data profiles' );

    FOR r IN (
        SELECT lt.flow_id app_id, lt.name lt_name,
               lt.data_profile_id, dp.name dp_name
          FROM wwv_flow_load_tables lt
          JOIN wwv_flow_data_profiles dp
            ON dp.id      = lt.data_profile_id
           AND dp.flow_id = p_app_id
         WHERE lt.security_group_id = l_sgid AND lt.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Data Load Table', r.lt_name,
               'DATA_PROFILE_ID', r.data_profile_id,
               'Data Profile', r.dp_name );
    END LOOP;

    -- ================================================================
    -- 23. WWV_FLOW_DATA_PROFILE_COLS (self-ref) → parent cols of target
    -- ================================================================
    section( 'DATA PROFILE COLUMNS in other apps referencing App ' || p_app_id || ' parent columns' );

    FOR r IN (
        SELECT dc.flow_id app_id, dc.name col_name,
               dc.parent_column_id, pc.name parent_col_name
          FROM wwv_flow_data_profile_cols dc
          JOIN wwv_flow_data_profile_cols pc
            ON pc.id      = dc.parent_column_id
           AND pc.flow_id = p_app_id
         WHERE dc.security_group_id = l_sgid AND dc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Data Profile Column', r.col_name,
               'PARENT_COLUMN_ID', r.parent_column_id,
               'Data Profile Column', r.parent_col_name );
    END LOOP;

    -- ================================================================
    -- 24. WWV_FLOW_COMP_GRP_COMPONENTS → any shared component of target app
    --     (catches all remaining cross-app component group memberships)
    -- ================================================================
    section( 'COMPONENT GROUP MEMBERSHIPS in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT cgc.flow_id app_id, cg.name group_name,
               cgc.list_id, l.name list_name
          FROM wwv_flow_comp_grp_components cgc
          JOIN wwv_flow_component_groups cg ON cg.id = cgc.component_group_id
          JOIN wwv_flow_lists l ON l.id = cgc.list_id AND l.flow_id = p_app_id
         WHERE cgc.security_group_id = l_sgid AND cgc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Component Group', r.group_name,
               'LIST_ID', r.list_id, 'List', r.list_name );
    END LOOP;

    FOR r IN (
        SELECT cgc.flow_id app_id, cg.name group_name,
               cgc.lov_id, lov.lov_name
          FROM wwv_flow_comp_grp_components cgc
          JOIN wwv_flow_component_groups cg ON cg.id = cgc.component_group_id
          JOIN wwv_flow_lists_of_values$ lov ON lov.id = cgc.lov_id AND lov.flow_id = p_app_id
         WHERE cgc.security_group_id = l_sgid AND cgc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Component Group', r.group_name,
               'LOV_ID', r.lov_id, 'List of Values', r.lov_name );
    END LOOP;

    FOR r IN (
        SELECT cgc.flow_id app_id, cg.name group_name,
               cgc.app_item_id, i.name item_name
          FROM wwv_flow_comp_grp_components cgc
          JOIN wwv_flow_component_groups cg ON cg.id = cgc.component_group_id
          JOIN wwv_flow_items i ON i.id = cgc.app_item_id AND i.flow_id = p_app_id
         WHERE cgc.security_group_id = l_sgid AND cgc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Component Group', r.group_name,
               'APP_ITEM_ID', r.app_item_id, 'Application Item', r.item_name );
    END LOOP;

    FOR r IN (
        SELECT cgc.flow_id app_id, cg.name group_name,
               cgc.app_process_id, pr.process_name
          FROM wwv_flow_comp_grp_components cgc
          JOIN wwv_flow_component_groups cg ON cg.id = cgc.component_group_id
          JOIN wwv_flow_processing pr ON pr.id = cgc.app_process_id AND pr.flow_id = p_app_id
         WHERE cgc.security_group_id = l_sgid AND cgc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Component Group', r.group_name,
               'APP_PROCESS_ID', r.app_process_id, 'Application Process', r.process_name );
    END LOOP;

    FOR r IN (
        SELECT cgc.flow_id app_id, cg.name group_name,
               cgc.app_computation_id, c.computation_item
          FROM wwv_flow_comp_grp_components cgc
          JOIN wwv_flow_component_groups cg ON cg.id = cgc.component_group_id
          JOIN wwv_flow_computations c ON c.id = cgc.app_computation_id AND c.flow_id = p_app_id
         WHERE cgc.security_group_id = l_sgid AND cgc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Component Group', r.group_name,
               'APP_COMPUTATION_ID', r.app_computation_id,
               'Application Computation', r.computation_item );
    END LOOP;

    FOR r IN (
        SELECT cgc.flow_id app_id, cg.name group_name,
               cgc.app_setting_id, s.name setting_name
          FROM wwv_flow_comp_grp_components cgc
          JOIN wwv_flow_component_groups cg ON cg.id = cgc.component_group_id
          JOIN wwv_flow_app_settings s ON s.id = cgc.app_setting_id AND s.flow_id = p_app_id
         WHERE cgc.security_group_id = l_sgid AND cgc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Component Group', r.group_name,
               'APP_SETTING_ID', r.app_setting_id, 'Application Setting', r.setting_name );
    END LOOP;

    FOR r IN (
        SELECT cgc.flow_id app_id, cg.name group_name,
               cgc.build_option_id, pa.patch_name
          FROM wwv_flow_comp_grp_components cgc
          JOIN wwv_flow_component_groups cg ON cg.id = cgc.component_group_id
          JOIN wwv_flow_patches pa ON pa.id = cgc.build_option_id AND pa.flow_id = p_app_id
         WHERE cgc.security_group_id = l_sgid AND cgc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Component Group', r.group_name,
               'BUILD_OPTION_ID', r.build_option_id, 'Build Option', r.patch_name );
    END LOOP;

    FOR r IN (
        SELECT cgc.flow_id app_id, cg.name group_name,
               cgc.authentication_id, a.name auth_name
          FROM wwv_flow_comp_grp_components cgc
          JOIN wwv_flow_component_groups cg ON cg.id = cgc.component_group_id
          JOIN wwv_flow_authentications a ON a.id = cgc.authentication_id AND a.flow_id = p_app_id
         WHERE cgc.security_group_id = l_sgid AND cgc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Component Group', r.group_name,
               'AUTHENTICATION_ID', r.authentication_id,
               'Authentication Scheme', r.auth_name );
    END LOOP;

    FOR r IN (
        SELECT cgc.flow_id app_id, cg.name group_name,
               cgc.authorization_id, ss.name scheme_name
          FROM wwv_flow_comp_grp_components cgc
          JOIN wwv_flow_component_groups cg ON cg.id = cgc.component_group_id
          JOIN wwv_flow_security_schemes ss ON ss.id = cgc.authorization_id AND ss.flow_id = p_app_id
         WHERE cgc.security_group_id = l_sgid AND cgc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Component Group', r.group_name,
               'AUTHORIZATION_ID', r.authorization_id,
               'Authorization Scheme', r.scheme_name );
    END LOOP;

    FOR r IN (
        SELECT cgc.flow_id app_id, cg.name group_name,
               cgc.group_id, ug.group_name role_name
          FROM wwv_flow_comp_grp_components cgc
          JOIN wwv_flow_component_groups cg ON cg.id = cgc.component_group_id
          JOIN wwv_flow_fnd_user_groups ug ON ug.id = cgc.group_id AND ug.flow_id = p_app_id
         WHERE cgc.security_group_id = l_sgid AND cgc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Component Group', r.group_name,
               'GROUP_ID', r.group_id, 'ACL Role', r.role_name );
    END LOOP;

    FOR r IN (
        SELECT cgc.flow_id app_id, cg.name group_name,
               cgc.email_template_id, et.name email_tmpl_name
          FROM wwv_flow_comp_grp_components cgc
          JOIN wwv_flow_component_groups cg ON cg.id = cgc.component_group_id
          JOIN wwv_flow_email_templates et ON et.id = cgc.email_template_id AND et.flow_id = p_app_id
         WHERE cgc.security_group_id = l_sgid AND cgc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Component Group', r.group_name,
               'EMAIL_TEMPLATE_ID', r.email_template_id,
               'Email Template', r.email_tmpl_name );
    END LOOP;

    FOR r IN (
        SELECT cgc.flow_id app_id, cg.name group_name,
               cgc.plugin_id, pl.name plugin_name
          FROM wwv_flow_comp_grp_components cgc
          JOIN wwv_flow_component_groups cg ON cg.id = cgc.component_group_id
          JOIN wwv_flow_plugins pl ON pl.id = cgc.plugin_id AND pl.flow_id = p_app_id
         WHERE cgc.security_group_id = l_sgid AND cgc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Component Group', r.group_name,
               'PLUGIN_ID', r.plugin_id, 'Plug-in', r.plugin_name );
    END LOOP;

    FOR r IN (
        SELECT cgc.flow_id app_id, cg.name group_name,
               cgc.shortcut_id, sh.shortcut_name
          FROM wwv_flow_comp_grp_components cgc
          JOIN wwv_flow_component_groups cg ON cg.id = cgc.component_group_id
          JOIN wwv_flow_shortcuts sh ON sh.id = cgc.shortcut_id AND sh.flow_id = p_app_id
         WHERE cgc.security_group_id = l_sgid AND cgc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Component Group', r.group_name,
               'SHORTCUT_ID', r.shortcut_id, 'Shortcut', r.shortcut_name );
    END LOOP;

    FOR r IN (
        SELECT cgc.flow_id app_id, cg.name group_name,
               cgc.web_src_module_id, wm.name wsm_name
          FROM wwv_flow_comp_grp_components cgc
          JOIN wwv_flow_component_groups cg ON cg.id = cgc.component_group_id
          JOIN wwv_flow_web_src_modules wm ON wm.id = cgc.web_src_module_id AND wm.flow_id = p_app_id
         WHERE cgc.security_group_id = l_sgid AND cgc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Component Group', r.group_name,
               'WEB_SRC_MODULE_ID', r.web_src_module_id,
               'Web Source Module', r.wsm_name );
    END LOOP;

    FOR r IN (
        SELECT cgc.flow_id app_id, cg.name group_name,
               cgc.search_config_id, sc.label sc_name
          FROM wwv_flow_comp_grp_components cgc
          JOIN wwv_flow_component_groups cg ON cg.id = cgc.component_group_id
          JOIN wwv_flow_search_configs sc ON sc.id = cgc.search_config_id AND sc.flow_id = p_app_id
         WHERE cgc.security_group_id = l_sgid AND cgc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Component Group', r.group_name,
               'SEARCH_CONFIG_ID', r.search_config_id,
               'Search Configuration', r.sc_name );
    END LOOP;

    FOR r IN (
        SELECT cgc.flow_id app_id, cg.name group_name,
               cgc.map_background_id, mb.name bg_name
          FROM wwv_flow_comp_grp_components cgc
          JOIN wwv_flow_component_groups cg ON cg.id = cgc.component_group_id
          JOIN wwv_flow_map_backgrounds mb ON mb.id = cgc.map_background_id AND mb.flow_id = p_app_id
         WHERE cgc.security_group_id = l_sgid AND cgc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Component Group', r.group_name,
               'MAP_BACKGROUND_ID', r.map_background_id,
               'Map Background', r.bg_name );
    END LOOP;

    FOR r IN (
        SELECT cgc.flow_id app_id, cg.name group_name,
               cgc.message_id, msg.name message_name
          FROM wwv_flow_comp_grp_components cgc
          JOIN wwv_flow_component_groups cg ON cg.id = cgc.component_group_id
          JOIN wwv_flow_messages$ msg ON msg.id = cgc.message_id AND msg.flow_id = p_app_id
         WHERE cgc.security_group_id = l_sgid AND cgc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Component Group', r.group_name,
               'MESSAGE_ID', r.message_id, 'Text Message', r.message_name );
    END LOOP;

    FOR r IN (
        SELECT cgc.flow_id app_id, cg.name group_name,
               cgc.duality_view_id, ds.name doc_name
          FROM wwv_flow_comp_grp_components cgc
          JOIN wwv_flow_component_groups cg ON cg.id = cgc.component_group_id
          JOIN wwv_flow_document_sources ds ON ds.id = cgc.duality_view_id AND ds.flow_id = p_app_id
         WHERE cgc.security_group_id = l_sgid AND cgc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Component Group', r.group_name,
               'DUALITY_VIEW_ID', r.duality_view_id,
               'Document Source (Duality/JSON)', r.doc_name );
    END LOOP;

    FOR r IN (
        SELECT cgc.flow_id app_id, cg.name group_name,
               cgc.load_table_id, lt.name lt_name
          FROM wwv_flow_comp_grp_components cgc
          JOIN wwv_flow_component_groups cg ON cg.id = cgc.component_group_id
          JOIN wwv_flow_load_tables lt ON lt.id = cgc.load_table_id AND lt.flow_id = p_app_id
         WHERE cgc.security_group_id = l_sgid AND cgc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Component Group', r.group_name,
               'LOAD_TABLE_ID', r.load_table_id, 'Data Load Table', r.lt_name );
    END LOOP;

    FOR r IN (
        SELECT cgc.flow_id app_id, cg.name group_name,
               cgc.report_layout_id, rl.report_layout_name
          FROM wwv_flow_comp_grp_components cgc
          JOIN wwv_flow_component_groups cg ON cg.id = cgc.component_group_id
          JOIN wwv_flow_report_layouts rl ON rl.id = cgc.report_layout_id AND rl.flow_id = p_app_id
         WHERE cgc.security_group_id = l_sgid AND cgc.flow_id != p_app_id
    ) LOOP
        found( 'App ' || r.app_id || ' / Component Group', r.group_name,
               'REPORT_LAYOUT_ID', r.report_layout_id,
               'Report Layout', r.report_layout_name );
    END LOOP;

    -- ================================================================
    -- Final summary
    -- ================================================================
    p( '' );
    p( '================================================================' );
    IF l_count = 0 THEN
        p( '  Result: No cross-app FK violations found for App ' || p_app_id || '.' );
        p( '  If deletion still fails, the blocking FK may originate from' );
        p( '  outside this workspace or from a non-metadata table.' );
    ELSE
        p( '  TOTAL VIOLATIONS FOUND: ' || l_count );
        p( '' );
        p( '  Each violation above is a row in ANOTHER app that has a' );
        p( '  foreign key column pointing to a component inside App ' || p_app_id || '.' );
        p( '  To fix: open each offending component in APEX App Builder' );
        p( '  and update the reference to point to a component owned by' );
        p( '  the same application, then retry the deletion.' );
    END IF;
    p( '================================================================' );

EXCEPTION
    WHEN OTHERS THEN
        p( 'UNEXPECTED ERROR: ' || SQLERRM );
        RAISE;
END why_cant_i_delete_app;
/
