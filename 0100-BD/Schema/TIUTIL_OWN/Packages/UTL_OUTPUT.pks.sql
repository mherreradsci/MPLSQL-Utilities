CREATE OR REPLACE PACKAGE "TIUTIL_OWN"."UTL_OUTPUT"
/*******************************************************************************
* Empresa:    Explora IT
* Proyecto:   Utilitarios Generales
* Objetivo:   Implementa un put_line que puede escribir archivos de texto en el
*             sistema operativo (OS Text Files) o que pueda mostrar texto
*             utilizando el DBMS OUTPUT.
*
* Historia    Quién    Descripción
* ----------- -------- ---------------------------------------------------------
* 18-Nov-2024 mherrera Creación
*******************************************************************************/
as
    -- Constantes para identificar el package
    k_package            constant fdc_defs.package_name_t := 'UTL_OUTPUT';

    -- Max line length for dbms_output line; TODO: Centralizar para DRY
    $if dbms_db_version.ver_le_9 $then
        k_max_line_length     number (3) := 255; -- Oracle 8i
    $elsif dbms_db_version.ver_le_11_2 $then
        k_max_line_length     number (5) := 1500; --32767;
    $elsif dbms_db_version.ver_le_12_2 $then
        k_max_line_length     number (5) := 32767;
    $elsif dbms_db_version.ver_le_18 $then
        k_max_line_length     number (5) := 32767;
    $elsif dbms_db_version.ver_le_19 $then
        k_max_line_length     number (5) := 32767;
    $end


    --User expeptions
    ue_directory_does_not_exist   exception;

    procedure set_handle (p_directory in varchar2);

    procedure set_file_name (p_filename in varchar2);

    function get_file_name
        return varchar2;

    procedure put_line (
        p_line in varchar2,
        p_chunk_size in pls_integer default k_max_line_length);

    procedure close_file;
end utl_output;
/
