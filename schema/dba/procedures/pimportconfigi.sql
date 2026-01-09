CREATE OR REPLACE PROCEDURE dba.pimportconfigi(IN p_config_name character varying, IN p_datasource character varying, IN p_datasettype character varying, IN p_source_directory character varying, IN p_archive_directory character varying, IN p_file_pattern character varying, IN p_file_type character varying, IN p_metadata_label_source character varying, IN p_metadata_label_location character varying, IN p_dateconfig character varying, IN p_datelocation character varying, IN p_dateformat character varying, IN p_delimiter character varying, IN p_target_table character varying, IN p_importstrategyid integer, IN p_is_active bit)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    INSERT INTO dba."timportconfig" (
        config_name,
        datasource,
        datasettype,
        source_directory,
        archive_directory,
        file_pattern,
        file_type,
        metadata_label_source,
        metadata_label_location,
        dateconfig,
        datelocation,
        dateformat,
        delimiter,
        target_table,
        importstrategyid,
        is_active,
        created_at,
        last_modified_at
    ) VALUES (
        p_config_name,
        p_datasource,
        p_datasettype,
        p_source_directory,
        p_archive_directory,
        p_file_pattern,
        p_file_type,
        p_metadata_label_source,
        p_metadata_label_location,
        p_dateconfig,
        p_datelocation,
        p_dateformat,
        p_delimiter,
        p_target_table,
        p_importstrategyid,
        p_is_active,
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP
    ) ON CONFLICT (config_name) DO NOTHING;
END;
$procedure$

