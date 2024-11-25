CREATE OR REPLACE PACKAGE "TIUTIL_OWN"."UTL_DIRECTORY"
/*******************************************************************************
* Empresa:    Explora IT
* Proyecto:   Utilitarios Generales
* Objetivo:   Implementa un programas útilitarios para  Directorios Oracle
*
* Historia    Quién    Descripción
* ----------- -------- ---------------------------------------------------------
* 24-Nov-2024 mherrera Creación
*******************************************************************************/
as
    -- Constante para identificar el package
    k_package   constant fdc_defs.package_name_t := 'UTL_OUTPUT';

    function directory_exists (
        p_directory in all_directories.directory_name%type)
        return boolean;
end utl_directory;
/
