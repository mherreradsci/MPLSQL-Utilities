CREATE OR REPLACE PACKAGE BODY "TIUTIL_OWN"."UTL_DIRECTORY"
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
    function directory_exists (
        p_directory in all_directories.directory_name%type)
        return boolean
    is
        --* Constantes para identificar el programa
        k_program_name   constant fdc_defs.program_name_t := 'DIRECTORY_EXISTS';
        k_module_name    constant fdc_defs.module_name_t
                                      := k_package || '.' || k_program_name ;
        -- Variables, constantes, tipos y subtipos locales

        v_dummy                   varchar2 (1);

        cursor c_exists
        is
            select 'x'
            from   all_directories
            where  directory_name = p_directory;

    begin
        open c_exists;

        fetch c_exists into v_dummy;

        close c_exists;

        return case when v_dummy is null then false else true end;
    exception
        when others then
            utl_error.informa (
                p_programa   => k_module_name,
                p_mensaje    => fdc_utility.get_oracle_error_message);
            raise;
    end directory_exists;
end utl_directory;
/
