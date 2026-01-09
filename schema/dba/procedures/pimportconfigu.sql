CREATE OR REPLACE PROCEDURE dba.pimportconfigu(IN p_config_id integer, IN p_config_name character varying DEFAULT NULL::character varying, IN p_datasource character varying DEFAULT NULL::character varying, IN p_datasettype character varying DEFAULT NULL::character varying, IN p_source_directory character varying DEFAULT NULL::character varying, IN p_archive_directory character varying DEFAULT NULL::character varying, IN p_file_pattern character varying DEFAULT NULL::character varying, IN p_file_type character varying DEFAULT NULL::character varying, IN p_metadata_label_source character varying DEFAULT NULL::character varying, IN p_metadata_label_location character varying DEFAULT NULL::character varying, IN p_dateconfig character varying DEFAULT NULL::character varying, IN p_datelocation character varying DEFAULT NULL::character varying, IN p_dateformat character varying DEFAULT NULL::character varying, IN p_delimiter character varying DEFAULT NULL::character varying, IN p_target_table character varying DEFAULT NULL::character varying, IN p_importstrategyid integer DEFAULT NULL::integer, IN p_is_active bit DEFAULT NULL::"bit")
 LANGUAGE plpgsql
AS $procedure$
BEGIN
    UPDATE dba."timportconfig"
    SET
        config_name = COALESCE(p_config_name, config_name),
        datasource = COALESCE(p_datasource, datasource),
        datasettype = COALESCE(p_datasettype, datasettype),
        source_directory = COALESCE(p_source_directory, source_directory),
        archive_directory = COALESCE(p_archive_directory, archive_directory),
        file_pattern = COALESCE(p_file_pattern, file_pattern),
        file_type = COALESCE(p_file_type, file_type),
        metadata_label_source = COALESCE(p_metadata_label_source, metadata_label_source),
        metadata_label_location = COALESCE(p_metadata_label_location, metadata_label_location),
        dateconfig = COALESCE(p_dateconfig, dateconfig),
        datelocation = COALESCE(p_datelocation, datelocation),
        dateformat = COALESCE(p_dateformat, dateformat),
        delimiter = COALESCE(p_delimiter, delimiter),
        target_table = COALESCE(p_target_table, target_table),
        importstrategyid = COALESCE(p_importstrategyid, importstrategyid),
        is_active = COALESCE(p_is_active, is_active),
        last_modified_at = CURRENT_TIMESTAMP
    WHERE config_id = p_config_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'No configuration found with config_id %', p_config_id;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error updating configuration: %', SQLERRM;
END;
$procedure$

