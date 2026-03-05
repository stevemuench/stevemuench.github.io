-- =============================================================================
--  WHY_CANT_I_DELETE_APP  –  Public-Views Edition  (v2)
--  Schema  : Any APEX developer schema (e.g. SMUENCH)
--  Database: Oracle 23ai / APEX 24.2
--
--  Purpose : Identifies cross-app FK violations that prevent an APEX application
--            from being deleted.  The root cause is a historic APEX copy-app bug
--            where child metadata rows in the copied app retained the original
--            component IDs from the source app instead of being re-mapped.
--
--  Methodology:
--    This version was built by cross-referencing two artifacts:
--      1. The complete set of NO ACTION FK constraints on WWV_FLOW_* tables
--         (queried live from USER_CONSTRAINTS / USER_CONS_COLUMNS on the APEX
--         engine schema) — the mathematically complete ground truth.
--      2. The APEX public-view DDL (apex_views.sql) — parsed to find which
--         internal FK columns are surfaced in public views and under what alias.
--    Every FK that both (a) can create a cross-app dependency and (b) has its
--    child column exposed in a public view is covered below.
--
--  Coverage: 26 sections (vs 19 in v1 and 24 in the internal-table edition)
--
--  FKs that cannot be checked here (column not exposed in any public view):
--    - WWV_FLOW_STEP_PROCESSING.EMAIL_TEMPLATE_ID    (page processes e-mail)
--    - WWV_FLOW_PROCESSING.EMAIL_TEMPLATE_ID          (app processes e-mail)
--    - WWV_FLOW_PROCESSING.WEB_SRC_OPERATION_ID       (app processes REST op)
--    - WWV_FLOW_WORKFLOW_ACTIVITIES.TASK_DEF_ID        (sub-task in workflow)
--    - WWV_FLOW_WORKFLOW_ACTIVITIES.WORKFLOW_ID        (sub-workflow)
--    - WWV_FLOW_AUTOMATION_ACTIONS.EMAIL_TEMPLATE_ID  (automation e-mail)
--    - WWV_FLOW_WEB_SRC_MODULES.SYNC_ARRAY_COL_ID     (web source sync col)
--    - WWV_FLOW_WEB_SRC_OPERATIONS.DATA_PROFILE_ID    (operation data profile)
--    - WWV_FLOW_WEB_SRC_OPERATIONS.DATA_PROFILE_ARRAY_COL_ID
--    - WWV_FLOW_PAGE_PLUGS.MENU_ID                    (region breadcrumb menu)
--    - WWV_FLOW_COMP_GRP_COMPONENTS.MESSAGE_ID        (app text message)
--    - WWV_FLOW_COMP_GRP_COMPONENTS.APP_PROCESS_ID    (app process)
--    - WWV_FLOW_COMP_GRP_COMPONENTS.DUALITY_VIEW_ID   (duality view)
--    Use why_cant_i_delete_app_internal_tables.sql (APEX engine schema) for
--    complete coverage of all 87 dangerous FK constraints.
--
--  Design notes:
--    * Uses only public APEX views (APEX_APPLICATION_*, APEX_APPL_*).
--      No access to internal APEX tables (WWV_FLOWS etc.) is required.
--    * Public APEX views automatically scope to the current user's workspace;
--      no explicit workspace/security_group_id filter is needed.
--    * Template-based sections use a NOT EXISTS guard to suppress false positives
--      from Universal Theme template IDs shared (same ID) across all apps:
--        Sections 1, 2, 4, 5 — list/button/label template checks.
--    * All other shared-component IDs (lists, LOVs, web sources, etc.) are
--      globally unique Oracle sequences — safe to JOIN directly.
--
--  Usage:
--    SET SERVEROUTPUT ON SIZE UNLIMITED
--    EXEC why_cant_i_delete_app( <application_id> );
-- =============================================================================

CREATE OR REPLACE PROCEDURE why_cant_i_delete_app (
    p_app_id IN NUMBER
) IS
    l_app_name  VARCHAR2(255);
    l_count     NUMBER := 0;

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
        p( '       Locks   : ' || p_target_type || ' "' || p_target_name
                               || '" (App ' || p_app_id || ')' );
    END found;

BEGIN
    BEGIN
        SELECT application_name INTO l_app_name
          FROM apex_applications
         WHERE application_id = p_app_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p( 'ERROR: Application ' || p_app_id || ' does not exist or is not accessible.' );
            RETURN;
    END;

    p( '================================================================' );
    p( '  WHY CANT I DELETE APP ' || p_app_id || '? (' || l_app_name || ')' );
    p( '  Checking all cross-app FK violations via public APEX views ...' );
    p( '================================================================' );

    -- =========================================================================
    -- Section 1: APPLICATION SETTINGS
    -- Checks app-level shared-component references on the application itself.
    -- NOT EXISTS guards on list-template IDs (Universal Theme shares same IDs).
    -- =========================================================================
    section( 'APPLICATION SETTINGS referencing App ' || p_app_id || ' shared components' );

    FOR r IN (
        SELECT a.application_id, a.application_name, a.navigation_list_id, l.list_name
          FROM apex_applications a
          JOIN apex_application_lists l
            ON l.list_id = a.navigation_list_id AND l.application_id = p_app_id
         WHERE a.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Application Settings',
               '"' || r.application_name || '"',
               'NAVIGATION_LIST_ID', r.navigation_list_id, 'List', r.list_name );
    END LOOP;

    FOR r IN (
        SELECT a.application_id, a.application_name, a.navigation_list_template_id, t.template_name
          FROM apex_applications a
          JOIN apex_application_temp_list t
            ON t.list_template_id = a.navigation_list_template_id AND t.application_id = p_app_id
         WHERE a.application_id != p_app_id
           AND NOT EXISTS (
               SELECT 1 FROM apex_application_temp_list own
                WHERE own.list_template_id = a.navigation_list_template_id
                  AND own.application_id   = a.application_id
           )
    ) LOOP
        found( 'App ' || r.application_id || ' / Application Settings',
               '"' || r.application_name || '"',
               'NAVIGATION_LIST_TEMPLATE_ID', r.navigation_list_template_id,
               'List Template', r.template_name );
    END LOOP;

    FOR r IN (
        SELECT a.application_id, a.application_name, a.nav_bar_list_id, l.list_name
          FROM apex_applications a
          JOIN apex_application_lists l
            ON l.list_id = a.nav_bar_list_id AND l.application_id = p_app_id
         WHERE a.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Application Settings',
               '"' || r.application_name || '"',
               'NAV_BAR_LIST_ID', r.nav_bar_list_id, 'List', r.list_name );
    END LOOP;

    FOR r IN (
        SELECT a.application_id, a.application_name, a.nav_bar_list_template_id, t.template_name
          FROM apex_applications a
          JOIN apex_application_temp_list t
            ON t.list_template_id = a.nav_bar_list_template_id AND t.application_id = p_app_id
         WHERE a.application_id != p_app_id
           AND NOT EXISTS (
               SELECT 1 FROM apex_application_temp_list own
                WHERE own.list_template_id = a.nav_bar_list_template_id
                  AND own.application_id   = a.application_id
           )
    ) LOOP
        found( 'App ' || r.application_id || ' / Application Settings',
               '"' || r.application_name || '"',
               'NAV_BAR_LIST_TEMPLATE_ID', r.nav_bar_list_template_id,
               'List Template', r.template_name );
    END LOOP;

    FOR r IN (
        SELECT a.application_id, a.application_name, a.authentication_scheme_id,
               s.authentication_scheme_name
          FROM apex_applications a
          JOIN apex_application_auth s
            ON s.authentication_scheme_id = a.authentication_scheme_id
           AND s.application_id = p_app_id
         WHERE a.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Application Settings',
               '"' || r.application_name || '"',
               'AUTHENTICATION_SCHEME_ID', r.authentication_scheme_id,
               'Authentication Scheme', r.authentication_scheme_name );
    END LOOP;

    FOR r IN (
        SELECT a.application_id, a.application_name, a.authorization_scheme_id,
               z.authorization_scheme_name
          FROM apex_applications a
          JOIN apex_application_authorization z
            ON z.authorization_scheme_id = a.authorization_scheme_id
           AND z.application_id = p_app_id
         WHERE a.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Application Settings',
               '"' || r.application_name || '"',
               'AUTHORIZATION_SCHEME_ID', r.authorization_scheme_id,
               'Authorization Scheme', r.authorization_scheme_name );
    END LOOP;

    -- =========================================================================
    -- Section 2: PAGES (page-level navigation list / template overrides)
    -- Individual pages can override the application's navigation list and
    -- template.  These are separate FK columns on WWV_FLOW_STEPS.
    -- NOT EXISTS guard on template ID (Universal Theme sharing).
    -- =========================================================================
    section( 'PAGES in other apps referencing App ' || p_app_id || ' nav lists / templates' );

    FOR r IN (
        SELECT c.application_id, c.page_id, c.page_name, c.navigation_list_id, p.list_name
          FROM apex_application_pages c
          JOIN apex_application_lists p
            ON p.list_id = c.navigation_list_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Page',
               'Page ' || r.page_id || ' "' || r.page_name || '"',
               'NAVIGATION_LIST_ID', r.navigation_list_id, 'List', r.list_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.page_id, c.page_name,
               c.navigation_list_template_id, t.template_name
          FROM apex_application_pages c
          JOIN apex_application_temp_list t
            ON t.list_template_id = c.navigation_list_template_id
           AND t.application_id   = p_app_id
         WHERE c.application_id != p_app_id
           AND NOT EXISTS (
               SELECT 1 FROM apex_application_temp_list own
                WHERE own.list_template_id = c.navigation_list_template_id
                  AND own.application_id   = c.application_id
           )
    ) LOOP
        found( 'App ' || r.application_id || ' / Page',
               'Page ' || r.page_id || ' "' || r.page_name || '"',
               'NAVIGATION_LIST_TEMPLATE_ID', r.navigation_list_template_id,
               'List Template', r.template_name );
    END LOOP;

    -- =========================================================================
    -- Section 3: REGIONS
    -- =========================================================================
    section( 'REGIONS in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT c.application_id, c.page_id, c.region_name, c.list_id, p.list_name
          FROM apex_application_page_regions c
          JOIN apex_application_lists p ON p.list_id = c.list_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Region',
               'Page ' || r.page_id || ' / Region "' || r.region_name || '"',
               'LIST_ID', r.list_id, 'List', r.list_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.page_id, c.region_name, c.web_source_module_id, p.module_name
          FROM apex_application_page_regions c
          JOIN apex_appl_web_src_modules p
            ON p.module_id = c.web_source_module_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Region',
               'Page ' || r.page_id || ' / Region "' || r.region_name || '"',
               'WEB_SOURCE_MODULE_ID', r.web_source_module_id,
               'Web Source Module', r.module_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.page_id, c.region_name, c.json_source_id, p.source_name
          FROM apex_application_page_regions c
          JOIN apex_appl_json_sources p
            ON p.source_id = c.json_source_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Region',
               'Page ' || r.page_id || ' / Region "' || r.region_name || '"',
               'JSON_SOURCE_ID', r.json_source_id, 'Document Source', r.source_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.page_id, c.region_name, c.array_column_id, p.name dp_col_nm
          FROM apex_application_page_regions c
          JOIN apex_appl_data_profile_cols p
            ON p.data_profile_column_id = c.array_column_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Region',
               'Page ' || r.page_id || ' / Region "' || r.region_name || '"',
               'ARRAY_COLUMN_ID', r.array_column_id, 'Data Profile Column', r.dp_col_nm );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.page_id, c.region_name, c.ai_config_id, p.config_name
          FROM apex_application_page_regions c
          JOIN apex_appl_ai_configs p
            ON p.config_id = c.ai_config_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Region',
               'Page ' || r.page_id || ' / Region "' || r.region_name || '"',
               'AI_CONFIG_ID', r.ai_config_id, 'AI Configuration', r.config_name );
    END LOOP;

    -- =========================================================================
    -- Section 4: BUTTONS
    -- NOT EXISTS guard: Universal Theme button template IDs are identical across
    -- all subscribed apps.  Only flag when the referencing app does NOT have its
    -- own copy of that template_id (= genuine broken cross-app reference).
    -- =========================================================================
    section( 'BUTTONS in other apps referencing App ' || p_app_id || ' button templates' );

    FOR r IN (
        SELECT c.application_id, c.page_id, c.button_name, c.button_template_id, p.template_name
          FROM apex_application_page_buttons c
          JOIN apex_application_temp_button p
            ON p.button_template_id = c.button_template_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
           AND NOT EXISTS (
               SELECT 1 FROM apex_application_temp_button own
                WHERE own.button_template_id = c.button_template_id
                  AND own.application_id     = c.application_id
           )
    ) LOOP
        found( 'App ' || r.application_id || ' / Button',
               'Page ' || r.page_id || ' / Button "' || r.button_name || '"',
               'BUTTON_TEMPLATE_ID', r.button_template_id,
               'Button Template', r.template_name );
    END LOOP;

    -- =========================================================================
    -- Section 5: REGION TEMPLATES (cross-template default references)
    -- Region templates can designate default button and label templates.  After
    -- a copy these may still point to templates that only exist in the source app.
    -- NOT EXISTS guards on all three columns (same Universal Theme sharing issue).
    -- =========================================================================
    section( 'REGION TEMPLATES in other apps referencing App ' || p_app_id || ' templates' );

    FOR r IN (
        SELECT c.application_id, c.region_template_id, c.template_name,
               c.default_button_template_id, p.template_name btn_tmpl_name
          FROM apex_application_temp_region c
          JOIN apex_application_temp_button p
            ON p.button_template_id = c.default_button_template_id
           AND p.application_id     = p_app_id
         WHERE c.application_id != p_app_id
           AND NOT EXISTS (
               SELECT 1 FROM apex_application_temp_button own
                WHERE own.button_template_id = c.default_button_template_id
                  AND own.application_id     = c.application_id
           )
    ) LOOP
        found( 'App ' || r.application_id || ' / Region Template',
               '"' || r.template_name || '"',
               'DEFAULT_BUTTON_TEMPLATE_ID', r.default_button_template_id,
               'Button Template', r.btn_tmpl_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.region_template_id, c.template_name,
               c.default_field_template_id, p.template_name lbl_tmpl_name
          FROM apex_application_temp_region c
          JOIN apex_application_temp_label p
            ON p.label_template_id = c.default_field_template_id
           AND p.application_id    = p_app_id
         WHERE c.application_id != p_app_id
           AND NOT EXISTS (
               SELECT 1 FROM apex_application_temp_label own
                WHERE own.label_template_id = c.default_field_template_id
                  AND own.application_id    = c.application_id
           )
    ) LOOP
        found( 'App ' || r.application_id || ' / Region Template',
               '"' || r.template_name || '"',
               'DEFAULT_FIELD_TEMPLATE_ID', r.default_field_template_id,
               'Label Template (field)', r.lbl_tmpl_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.region_template_id, c.template_name,
               c.default_req_field_template_id, p.template_name lbl_tmpl_name
          FROM apex_application_temp_region c
          JOIN apex_application_temp_label p
            ON p.label_template_id = c.default_req_field_template_id
           AND p.application_id    = p_app_id
         WHERE c.application_id != p_app_id
           AND NOT EXISTS (
               SELECT 1 FROM apex_application_temp_label own
                WHERE own.label_template_id = c.default_req_field_template_id
                  AND own.application_id    = c.application_id
           )
    ) LOOP
        found( 'App ' || r.application_id || ' / Region Template',
               '"' || r.template_name || '"',
               'DEFAULT_REQ_FIELD_TEMPLATE_ID', r.default_req_field_template_id,
               'Label Template (required field)', r.lbl_tmpl_name );
    END LOOP;

    -- =========================================================================
    -- Section 6: PAGE ITEMS
    -- =========================================================================
    section( 'PAGE ITEMS in other apps referencing App ' || p_app_id || ' AI configurations' );

    FOR r IN (
        SELECT c.application_id, c.page_id, c.item_name, c.ai_config_id, p.config_name
          FROM apex_application_page_items c
          JOIN apex_appl_ai_configs p
            ON p.config_id = c.ai_config_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Page Item',
               'Page ' || r.page_id || ' / Item "' || r.item_name || '"',
               'AI_CONFIG_ID', r.ai_config_id, 'AI Configuration', r.config_name );
    END LOOP;

    -- =========================================================================
    -- Section 7: PAGE PROCESSES
    -- Note: EMAIL_TEMPLATE_ID on WWV_FLOW_STEP_PROCESSING is NOT exposed in
    -- APEX_APPLICATION_PAGE_PROC — use the internal-table version for full coverage.
    -- =========================================================================
    section( 'PAGE PROCESSES in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT c.application_id, c.page_id, c.process_name, c.web_source_module_id, p.module_name
          FROM apex_application_page_proc c
          JOIN apex_appl_web_src_modules p
            ON p.module_id = c.web_source_module_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Page Process',
               'Page ' || r.page_id || ' / Process "' || r.process_name || '"',
               'WEB_SOURCE_MODULE_ID', r.web_source_module_id,
               'Web Source Module', r.module_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.page_id, c.process_name, c.web_source_operation_id,
               p.operation_name
          FROM apex_application_page_proc c
          JOIN apex_appl_web_src_operations p
            ON p.operation_id = c.web_source_operation_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Page Process',
               'Page ' || r.page_id || ' / Process "' || r.process_name || '"',
               'WEB_SOURCE_OPERATION_ID', r.web_source_operation_id,
               'Web Source Operation', r.operation_name );
    END LOOP;

    -- =========================================================================
    -- Section 8: AUTOMATIONS
    -- =========================================================================
    section( 'AUTOMATIONS in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT c.application_id, c.name, c.web_source_module_id, p.module_name
          FROM apex_appl_automations c
          JOIN apex_appl_web_src_modules p
            ON p.module_id = c.web_source_module_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Automation', '"' || r.name || '"',
               'WEB_SOURCE_MODULE_ID', r.web_source_module_id,
               'Web Source Module', r.module_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.name, c.json_source_id, p.source_name
          FROM apex_appl_automations c
          JOIN apex_appl_json_sources p
            ON p.source_id = c.json_source_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Automation', '"' || r.name || '"',
               'JSON_SOURCE_ID', r.json_source_id, 'Document Source', r.source_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.name, c.array_column_id, p.name dp_col_nm
          FROM apex_appl_automations c
          JOIN apex_appl_data_profile_cols p
            ON p.data_profile_column_id = c.array_column_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Automation', '"' || r.name || '"',
               'ARRAY_COLUMN_ID', r.array_column_id, 'Data Profile Column', r.dp_col_nm );
    END LOOP;

    -- =========================================================================
    -- Section 9: AUTOMATION ACTIONS
    -- Note: ACTION_NAME fails PL/SQL static validation; AUTOMATION_NAME used.
    -- Note: EMAIL_TEMPLATE_ID is NOT exposed in APEX_APPL_AUTOMATION_ACTIONS.
    -- =========================================================================
    section( 'AUTOMATION ACTIONS in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT c.application_id, c.automation_name, c.web_source_module_id, p.module_name
          FROM apex_appl_automation_actions c
          JOIN apex_appl_web_src_modules p
            ON p.module_id = c.web_source_module_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Automation Action',
               'Automation "' || r.automation_name || '"',
               'WEB_SOURCE_MODULE_ID', r.web_source_module_id,
               'Web Source Module', r.module_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.automation_name, c.web_source_operation_id, p.operation_name
          FROM apex_appl_automation_actions c
          JOIN apex_appl_web_src_operations p
            ON p.operation_id = c.web_source_operation_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Automation Action',
               'Automation "' || r.automation_name || '"',
               'WEB_SOURCE_OPERATION_ID', r.web_source_operation_id,
               'Web Source Operation', r.operation_name );
    END LOOP;

    -- =========================================================================
    -- Section 10: LOVs (Lists of Values)
    -- =========================================================================
    section( 'LOVs in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT c.application_id, c.list_of_values_name, c.web_source_module_id, p.module_name
          FROM apex_application_lovs c
          JOIN apex_appl_web_src_modules p
            ON p.module_id = c.web_source_module_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / LOV',
               '"' || r.list_of_values_name || '"',
               'WEB_SOURCE_MODULE_ID', r.web_source_module_id,
               'Web Source Module', r.module_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.list_of_values_name, c.json_source_id, p.source_name
          FROM apex_application_lovs c
          JOIN apex_appl_json_sources p
            ON p.source_id = c.json_source_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / LOV',
               '"' || r.list_of_values_name || '"',
               'JSON_SOURCE_ID', r.json_source_id, 'Document Source', r.source_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.list_of_values_name, c.array_column_id, p.name dp_col_nm
          FROM apex_application_lovs c
          JOIN apex_appl_data_profile_cols p
            ON p.data_profile_column_id = c.array_column_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / LOV',
               '"' || r.list_of_values_name || '"',
               'ARRAY_COLUMN_ID', r.array_column_id, 'Data Profile Column', r.dp_col_nm );
    END LOOP;

    -- =========================================================================
    -- Section 11: SEARCH CONFIGURATIONS
    -- =========================================================================
    section( 'SEARCH CONFIGURATIONS in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT c.application_id, c.label, c.list_id, p.list_name
          FROM apex_appl_search_configs c
          JOIN apex_application_lists p ON p.list_id = c.list_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Search Configuration',
               '"' || r.label || '"', 'LIST_ID', r.list_id, 'List', r.list_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.label, c.web_source_module_id, p.module_name
          FROM apex_appl_search_configs c
          JOIN apex_appl_web_src_modules p
            ON p.module_id = c.web_source_module_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Search Configuration',
               '"' || r.label || '"',
               'WEB_SOURCE_MODULE_ID', r.web_source_module_id,
               'Web Source Module', r.module_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.label, c.json_source_id, p.source_name
          FROM apex_appl_search_configs c
          JOIN apex_appl_json_sources p
            ON p.source_id = c.json_source_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Search Configuration',
               '"' || r.label || '"',
               'JSON_SOURCE_ID', r.json_source_id, 'Document Source', r.source_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.label, c.array_column_id, p.name dp_col_nm
          FROM apex_appl_search_configs c
          JOIN apex_appl_data_profile_cols p
            ON p.data_profile_column_id = c.array_column_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Search Configuration',
               '"' || r.label || '"',
               'ARRAY_COLUMN_ID', r.array_column_id, 'Data Profile Column', r.dp_col_nm );
    END LOOP;

    -- =========================================================================
    -- Section 12: SEARCH REGION SOURCES
    -- =========================================================================
    section( 'SEARCH REGION SOURCES in other apps referencing App ' || p_app_id || ' search configs' );

    FOR r IN (
        SELECT c.application_id, c.page_id, c.search_source_name, c.search_config_id, p.label
          FROM apex_appl_page_search_sources c
          JOIN apex_appl_search_configs p
            ON p.search_config_id = c.search_config_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Search Region Source',
               'Page ' || r.page_id || ' / Source "' || r.search_source_name || '"',
               'SEARCH_CONFIG_ID', r.search_config_id, 'Search Configuration', r.label );
    END LOOP;

    -- =========================================================================
    -- Section 13: CHART SERIES
    -- =========================================================================
    section( 'CHART SERIES in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT c.application_id, c.page_id, c.series_name, c.web_source_module_id, p.module_name
          FROM apex_application_page_chart_s c
          JOIN apex_appl_web_src_modules p
            ON p.module_id = c.web_source_module_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Chart Series',
               'Page ' || r.page_id || ' / Series "' || r.series_name || '"',
               'WEB_SOURCE_MODULE_ID', r.web_source_module_id,
               'Web Source Module', r.module_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.page_id, c.series_name, c.json_source_id, p.source_name
          FROM apex_application_page_chart_s c
          JOIN apex_appl_json_sources p
            ON p.source_id = c.json_source_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Chart Series',
               'Page ' || r.page_id || ' / Series "' || r.series_name || '"',
               'JSON_SOURCE_ID', r.json_source_id, 'Document Source', r.source_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.page_id, c.series_name, c.array_column_id, p.name dp_col_nm
          FROM apex_application_page_chart_s c
          JOIN apex_appl_data_profile_cols p
            ON p.data_profile_column_id = c.array_column_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Chart Series',
               'Page ' || r.page_id || ' / Series "' || r.series_name || '"',
               'ARRAY_COLUMN_ID', r.array_column_id, 'Data Profile Column', r.dp_col_nm );
    END LOOP;

    -- =========================================================================
    -- Section 14: MAP LAYERS
    -- =========================================================================
    section( 'MAP LAYERS in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT c.application_id, c.page_id, c.name layer_nm, c.web_source_module_id, p.module_name
          FROM apex_appl_page_map_layers c
          JOIN apex_appl_web_src_modules p
            ON p.module_id = c.web_source_module_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Map Layer',
               'Page ' || r.page_id || ' / Layer "' || r.layer_nm || '"',
               'WEB_SOURCE_MODULE_ID', r.web_source_module_id,
               'Web Source Module', r.module_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.page_id, c.name layer_nm, c.json_source_id, p.source_name
          FROM apex_appl_page_map_layers c
          JOIN apex_appl_json_sources p
            ON p.source_id = c.json_source_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Map Layer',
               'Page ' || r.page_id || ' / Layer "' || r.layer_nm || '"',
               'JSON_SOURCE_ID', r.json_source_id, 'Document Source', r.source_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.page_id, c.name layer_nm, c.array_column_id, p.name dp_col_nm
          FROM apex_appl_page_map_layers c
          JOIN apex_appl_data_profile_cols p
            ON p.data_profile_column_id = c.array_column_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Map Layer',
               'Page ' || r.page_id || ' / Layer "' || r.layer_nm || '"',
               'ARRAY_COLUMN_ID', r.array_column_id, 'Data Profile Column', r.dp_col_nm );
    END LOOP;

    -- =========================================================================
    -- Section 15: MAP REGIONS (background tile layer references)
    -- Map regions can designate a shared tile layer (background map) for default
    -- and dark-mode display.  These are separate FKs exposed in APEX_APPL_PAGE_MAPS
    -- as CUSTOM_BG_MAP_ID and CUSTOM_BG_MAP_DARK_ID.
    -- =========================================================================
    section( 'MAP REGIONS in other apps referencing App ' || p_app_id || ' map backgrounds' );

    FOR r IN (
        SELECT c.application_id, c.page_id, c.region_name,
               c.custom_bg_map_id, p.name bg_name
          FROM apex_appl_page_maps c
          JOIN apex_appl_map_backgrounds p
            ON p.map_background_id = c.custom_bg_map_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Map Region',
               'Page ' || r.page_id || ' / Region "' || r.region_name || '"',
               'CUSTOM_BG_MAP_ID', r.custom_bg_map_id,
               'Map Background', r.bg_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.page_id, c.region_name,
               c.custom_bg_map_dark_id, p.name bg_name
          FROM apex_appl_page_maps c
          JOIN apex_appl_map_backgrounds p
            ON p.map_background_id = c.custom_bg_map_dark_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Map Region',
               'Page ' || r.page_id || ' / Region "' || r.region_name || '"',
               'CUSTOM_BG_MAP_DARK_ID', r.custom_bg_map_dark_id,
               'Map Background (dark mode)', r.bg_name );
    END LOOP;

    -- =========================================================================
    -- Section 16: LIST ENTRIES (sub-list references)
    -- A list entry can point to a sub-list (nested navigation).  After a copy
    -- the sub-list reference may still point to the source app's list.
    -- FK: WWV_FLOW_LIST_ITEMS.SUB_LIST_ID → WWV_FLOW_LISTS.ID (NO ACTION)
    -- =========================================================================
    section( 'LIST ENTRIES in other apps referencing App ' || p_app_id || ' sub-lists' );

    FOR r IN (
        SELECT c.application_id, c.list_name, c.list_entry_id, c.sub_list_id, p.list_name sub_nm
          FROM apex_application_list_entries c
          JOIN apex_application_lists p
            ON p.list_id = c.sub_list_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / List Entry',
               'List "' || r.list_name || '" / Entry ID ' || r.list_entry_id,
               'SUB_LIST_ID', r.sub_list_id, 'List', r.sub_nm );
    END LOOP;

    -- =========================================================================
    -- Section 17: WEB SOURCE MODULES (data profile reference)
    -- =========================================================================
    section( 'WEB SOURCE MODULES in other apps referencing App ' || p_app_id || ' data profiles' );

    FOR r IN (
        SELECT c.application_id, c.module_name, c.data_profile_id, p.name dp_name
          FROM apex_appl_web_src_modules c
          JOIN apex_appl_data_profiles p
            ON p.data_profile_id = c.data_profile_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Web Source Module',
               '"' || r.module_name || '"',
               'DATA_PROFILE_ID', r.data_profile_id, 'Data Profile', r.dp_name );
    END LOOP;

    -- =========================================================================
    -- Section 18: REPORT QUERY SOURCES
    -- =========================================================================
    section( 'REPORT QUERY SOURCES in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT c.application_id, c.report_query_name, c.web_source_module_id, p.module_name
          FROM apex_appl_rpt_qry_sources c
          JOIN apex_appl_web_src_modules p
            ON p.module_id = c.web_source_module_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Report Query Source',
               '"' || r.report_query_name || '"',
               'WEB_SOURCE_MODULE_ID', r.web_source_module_id,
               'Web Source Module', r.module_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.report_query_name, c.json_source_id, p.source_name
          FROM apex_appl_rpt_qry_sources c
          JOIN apex_appl_json_sources p
            ON p.source_id = c.json_source_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Report Query Source',
               '"' || r.report_query_name || '"',
               'JSON_SOURCE_ID', r.json_source_id, 'Document Source', r.source_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.report_query_name, c.array_column_id, p.name dp_col_nm
          FROM apex_appl_rpt_qry_sources c
          JOIN apex_appl_data_profile_cols p
            ON p.data_profile_column_id = c.array_column_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Report Query Source',
               '"' || r.report_query_name || '"',
               'ARRAY_COLUMN_ID', r.array_column_id, 'Data Profile Column', r.dp_col_nm );
    END LOOP;

    -- =========================================================================
    -- Section 19: REPORT / CLASSIC REPORT COLUMNS (LOV reference)
    -- Report and classic report columns can reference a shared LOV by ID.
    -- FK: WWV_FLOW_REGION_COLUMNS.LOV_ID → WWV_FLOW_LISTS_OF_VALUES$.ID (NO ACTION)
    -- =========================================================================
    section( 'REPORT COLUMNS in other apps referencing App ' || p_app_id || ' LOVs' );

    FOR r IN (
        SELECT c.application_id, c.page_id, c.region_name, c.name col_nm,
               c.lov_id, p.list_of_values_name lov_nm
          FROM apex_application_page_reg_cols c
          JOIN apex_application_lovs p
            ON p.lov_id = c.lov_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Report Column',
               'Page ' || r.page_id || ' / Region "' || r.region_name
                       || '" / Column "' || r.col_nm || '"',
               'LOV_ID', r.lov_id, 'List of Values', r.lov_nm );
    END LOOP;

    -- =========================================================================
    -- Section 20: INTERACTIVE GRID COLUMNS (LOV and filter LOV references)
    -- FK: WWV_FLOW_REGION_COLUMNS.LOV_ID → WWV_FLOW_LISTS_OF_VALUES$.ID
    -- FK: WWV_FLOW_REGION_COLUMNS.FILTER_LOV_ID → WWV_FLOW_LISTS_OF_VALUES$.ID
    -- =========================================================================
    section( 'IG COLUMNS in other apps referencing App ' || p_app_id || ' LOVs' );

    FOR r IN (
        SELECT c.application_id, c.page_id, c.region_name, c.name col_nm,
               c.lov_id, p.list_of_values_name lov_nm
          FROM apex_appl_page_ig_columns c
          JOIN apex_application_lovs p
            ON p.lov_id = c.lov_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / IG Column',
               'Page ' || r.page_id || ' / Region "' || r.region_name
                       || '" / Column "' || r.col_nm || '"',
               'LOV_ID', r.lov_id, 'List of Values', r.lov_nm );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.page_id, c.region_name, c.name col_nm,
               c.filter_lov_id, p.list_of_values_name lov_nm
          FROM apex_appl_page_ig_columns c
          JOIN apex_application_lovs p
            ON p.lov_id = c.filter_lov_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / IG Column',
               'Page ' || r.page_id || ' / Region "' || r.region_name
                       || '" / Column "' || r.col_nm || '"',
               'FILTER_LOV_ID', r.filter_lov_id, 'List of Values (filter)', r.lov_nm );
    END LOOP;

    -- =========================================================================
    -- Section 21: TASK DEFINITION ACTIONS
    -- Note: APEX_APPL_TASKDEF_ACTIONS uses column NAME (not ACTION_NAME).
    -- =========================================================================
    section( 'TASK DEFINITION ACTIONS in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT c.application_id, c.task_def_name, c.name action_nm,
               c.web_source_module_id, p.module_name
          FROM apex_appl_taskdef_actions c
          JOIN apex_appl_web_src_modules p
            ON p.module_id = c.web_source_module_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Task Def Action',
               'Task "' || r.task_def_name || '" / Action "' || r.action_nm || '"',
               'WEB_SOURCE_MODULE_ID', r.web_source_module_id,
               'Web Source Module', r.module_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.task_def_name, c.name action_nm,
               c.web_source_operation_id, p.operation_name
          FROM apex_appl_taskdef_actions c
          JOIN apex_appl_web_src_operations p
            ON p.operation_id = c.web_source_operation_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Task Def Action',
               'Task "' || r.task_def_name || '" / Action "' || r.action_nm || '"',
               'WEB_SOURCE_OPERATION_ID', r.web_source_operation_id,
               'Web Source Operation', r.operation_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.task_def_name, c.name action_nm,
               c.email_template_id, p.name tmpl_name
          FROM apex_appl_taskdef_actions c
          JOIN apex_appl_email_templates p
            ON p.email_template_id = c.email_template_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Task Def Action',
               'Task "' || r.task_def_name || '" / Action "' || r.action_nm || '"',
               'EMAIL_TEMPLATE_ID', r.email_template_id, 'Email Template', r.tmpl_name );
    END LOOP;

    -- =========================================================================
    -- Section 22: WORKFLOW ACTIVITIES
    -- Note: TASK_DEF_ID and WORKFLOW_ID (sub-workflow) are NOT exposed in
    -- APEX_APPL_WORKFLOW_ACTIVITIES — use the internal-table version for those.
    -- =========================================================================
    section( 'WORKFLOW ACTIVITIES in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT c.application_id, c.name activity_nm, c.web_source_module_id, p.module_name
          FROM apex_appl_workflow_activities c
          JOIN apex_appl_web_src_modules p
            ON p.module_id = c.web_source_module_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Workflow Activity',
               '"' || r.activity_nm || '"',
               'WEB_SOURCE_MODULE_ID', r.web_source_module_id,
               'Web Source Module', r.module_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.name activity_nm, c.web_source_operation_id, p.operation_name
          FROM apex_appl_workflow_activities c
          JOIN apex_appl_web_src_operations p
            ON p.operation_id = c.web_source_operation_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Workflow Activity',
               '"' || r.activity_nm || '"',
               'WEB_SOURCE_OPERATION_ID', r.web_source_operation_id,
               'Web Source Operation', r.operation_name );
    END LOOP;

    FOR r IN (
        SELECT c.application_id, c.name activity_nm, c.email_template_id, p.name tmpl_name
          FROM apex_appl_workflow_activities c
          JOIN apex_appl_email_templates p
            ON p.email_template_id = c.email_template_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Workflow Activity',
               '"' || r.activity_nm || '"',
               'EMAIL_TEMPLATE_ID', r.email_template_id, 'Email Template', r.tmpl_name );
    END LOOP;

    -- =========================================================================
    -- Section 23: DOCUMENT SOURCES (data profile reference)
    -- =========================================================================
    section( 'DOCUMENT SOURCES in other apps referencing App ' || p_app_id || ' data profiles' );

    FOR r IN (
        SELECT c.application_id, c.source_name, c.data_profile_id, p.name dp_name
          FROM apex_appl_json_sources c
          JOIN apex_appl_data_profiles p
            ON p.data_profile_id = c.data_profile_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Document Source',
               '"' || r.source_name || '"',
               'DATA_PROFILE_ID', r.data_profile_id, 'Data Profile', r.dp_name );
    END LOOP;

    -- =========================================================================
    -- Section 24: DATA PROFILE COLUMNS (self-referencing parent column)
    -- =========================================================================
    section( 'DATA PROFILE COLUMNS in other apps referencing App ' || p_app_id || ' parent cols' );

    FOR r IN (
        SELECT c.application_id, c.name col_nm, c.parent_column_id, p.name parent_col_nm
          FROM apex_appl_data_profile_cols c
          JOIN apex_appl_data_profile_cols p
            ON p.data_profile_column_id = c.parent_column_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Data Profile Column',
               '"' || r.col_nm || '"',
               'PARENT_COLUMN_ID', r.parent_column_id,
               'Data Profile Column', r.parent_col_nm );
    END LOOP;

    -- =========================================================================
    -- Section 25: DATA LOADS (data profile reference)
    -- FK: WWV_FLOW_LOAD_TABLES.DATA_PROFILE_ID → WWV_FLOW_DATA_PROFILES.ID (NO ACTION)
    -- Exposed as APEX_APPL_DATA_LOADS.DATA_PROFILE_ID (NOT NULL column).
    -- =========================================================================
    section( 'DATA LOADS in other apps referencing App ' || p_app_id || ' data profiles' );

    FOR r IN (
        SELECT c.application_id, c.name, c.data_profile_id, p.name dp_name
          FROM apex_appl_data_loads c
          JOIN apex_appl_data_profiles p
            ON p.data_profile_id = c.data_profile_id AND p.application_id = p_app_id
         WHERE c.application_id != p_app_id
    ) LOOP
        found( 'App ' || r.application_id || ' / Data Load',
               '"' || r.name || '"',
               'DATA_PROFILE_ID', r.data_profile_id, 'Data Profile', r.dp_name );
    END LOOP;

    -- =========================================================================
    -- Section 26: COMPONENT GROUP MEMBERSHIPS
    -- A component group in app B can list components from app A as members.
    -- Checks all known shareable component ID types.
    -- IDs are globally unique Oracle sequences — no NOT EXISTS guard needed.
    --
    -- Extended in v2 to cover: app computations, app items, build options,
    -- app settings, shortcuts, plugins, plugin settings.
    -- Still unexposable: text messages, app-level processes, duality views.
    -- =========================================================================
    section( 'COMPONENT GROUP MEMBERSHIPS in other apps referencing App ' || p_app_id || ' components' );

    FOR r IN (
        SELECT c.application_id, c.component_name, c.component_id
          FROM apex_appl_comp_grp_components c
         WHERE c.application_id != p_app_id
           AND c.component_id IN (
               -- Existing component types (v1)
               SELECT list_id                  FROM apex_application_lists          WHERE application_id = p_app_id
               UNION ALL
               SELECT lov_id                   FROM apex_application_lovs            WHERE application_id = p_app_id
               UNION ALL
               SELECT authentication_scheme_id FROM apex_application_auth            WHERE application_id = p_app_id
               UNION ALL
               SELECT authorization_scheme_id  FROM apex_application_authorization   WHERE application_id = p_app_id
               UNION ALL
               SELECT email_template_id        FROM apex_appl_email_templates        WHERE application_id = p_app_id
               UNION ALL
               SELECT module_id                FROM apex_appl_web_src_modules        WHERE application_id = p_app_id
               UNION ALL
               SELECT search_config_id         FROM apex_appl_search_configs         WHERE application_id = p_app_id
               UNION ALL
               SELECT map_background_id        FROM apex_appl_map_backgrounds        WHERE application_id = p_app_id
               UNION ALL
               SELECT report_layout_id         FROM apex_application_rpt_layouts     WHERE application_id = p_app_id
               UNION ALL
               SELECT theme_style_id           FROM apex_application_theme_styles    WHERE application_id = p_app_id
               UNION ALL
               SELECT config_id                FROM apex_appl_ai_configs             WHERE application_id = p_app_id
               UNION ALL
               SELECT load_table_id            FROM apex_appl_load_tables            WHERE application_id = p_app_id
               UNION ALL
               SELECT task_def_id              FROM apex_appl_taskdefs               WHERE application_id = p_app_id
               UNION ALL
               SELECT workflow_id              FROM apex_appl_workflows              WHERE application_id = p_app_id
               UNION ALL
               SELECT data_profile_id          FROM apex_appl_data_profiles          WHERE application_id = p_app_id
               -- New component types (v2)
               UNION ALL
               SELECT application_computation_id FROM apex_application_computations  WHERE application_id = p_app_id
               UNION ALL
               SELECT application_item_id      FROM apex_application_items           WHERE application_id = p_app_id
               UNION ALL
               SELECT build_option_id          FROM apex_application_build_options   WHERE application_id = p_app_id
               UNION ALL
               SELECT application_setting_id   FROM apex_application_settings        WHERE application_id = p_app_id
               UNION ALL
               SELECT shortcut_id              FROM apex_application_shortcuts        WHERE application_id = p_app_id
               UNION ALL
               SELECT plugin_id                FROM apex_appl_plugins                WHERE application_id = p_app_id
               UNION ALL
               SELECT plugin_setting_id        FROM apex_appl_plugin_settings        WHERE application_id = p_app_id
           )
    ) LOOP
        found( 'App ' || r.application_id || ' / Component Group Member',
               '"' || r.component_name || '"',
               'COMPONENT_ID', r.component_id,
               'Shared Component', '(ID ' || r.component_id || ' in App ' || p_app_id || ')' );
    END LOOP;

    -- =========================================================================
    -- Summary
    -- =========================================================================
    p( '' );
    p( '================================================================' );
    IF l_count = 0 THEN
        p( '  Result: No cross-app FK violations found for App ' || p_app_id || '.' );
        p( '  If deletion still fails, check the following that this' );
        p( '  public-view version cannot detect:' );
        p( '    - Page/app process email template references' );
        p( '    - Workflow sub-task and sub-workflow references' );
        p( '    - Automation action email template references' );
        p( '    - Web source operation data profile references' );
        p( '    - Region breadcrumb menu references' );
        p( '    - Component group: text messages, app processes, duality views' );
        p( '  Use why_cant_i_delete_app_internal_tables.sql for full coverage.' );
    ELSE
        p( '  TOTAL VIOLATIONS FOUND: ' || l_count );
        p( '' );
        p( '  Each violation above is a component in ANOTHER app that' );
        p( '  has a foreign key pointing to a component inside App ' || p_app_id || '.' );
        p( '  To fix: open each offending component in APEX App Builder' );
        p( '  and update the reference, then retry the deletion.' );
    END IF;
    p( '================================================================' );

EXCEPTION
    WHEN OTHERS THEN
        p( 'UNEXPECTED ERROR: ' || SQLERRM );
        RAISE;
END why_cant_i_delete_app;
/
