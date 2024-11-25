CREATE OR REPLACE PACKAGE BODY "TIUTIL_OWN"."UTL_OUTPUT"
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
    g_file_handle      utl_file.file_type;
    g_directory_name   all_directories.directory_name%type;
    g_file_name        varchar2 (2048);


    procedure set_handle (p_directory in varchar2)
    is
        --* Constantes para identificar el programa
        k_program_name   constant fdc_defs.program_name_t := 'SET_HANDLE';
        k_module_name    constant fdc_defs.module_name_t
                                      := k_package || '.' || k_program_name ;
    -- Variables, constantes, tipos y subtipos locales

    begin
        if utl_directory.directory_exists (p_directory => p_directory) then
            g_directory_name := p_directory;
        else
            raise ue_directory_does_not_exist;
        end if;
    exception
        when ue_directory_does_not_exist then
            raise;
        when others then
            utl_error.informa (
                p_programa   => k_module_name,
                p_mensaje    => fdc_utility.get_oracle_error_message);
            raise;
    end set_handle;


    function get_file_name
        return varchar2
    is
        k_program_name   constant fdc_defs.program_name_t := 'GET_FILE_NAME';
        k_module_name    constant fdc_defs.module_name_t
                                      := k_package || '.' || k_program_name ;
    begin
        return g_file_name;
    exception
        when others then
            utl_error.informa (
                p_programa   => k_module_name,
                p_mensaje    => fdc_utility.get_oracle_error_message);
            raise;
    end get_file_name;


    procedure set_file_name (p_filename in varchar2)
    is
        k_program_name   constant fdc_defs.program_name_t := 'SET_FILE_NAME';
        k_module_name    constant fdc_defs.module_name_t
                                      := k_package || '.' || k_program_name ;
    begin
        g_file_name := p_filename;
        g_file_handle :=
            utl_file.fopen (location    => g_directory_name,
                            filename    => g_file_name,
                            open_mode   => 'W');
    exception
        when utl_file.invalid_path then
            utl_error.informa (
                p_programa   => k_module_name,
                p_mensaje    => fdc_utility.get_oracle_error_message);
            raise;
        when utl_file.invalid_mode then
            utl_error.informa (
                p_programa   => k_module_name,
                p_mensaje    => fdc_utility.get_oracle_error_message);
            raise;
        when others then
            utl_error.informa (
                p_programa   => k_module_name,
                p_mensaje    => fdc_utility.get_oracle_error_message);
            raise;
    end set_file_name;

    procedure put_line (
        p_line         in varchar2,
        p_chunk_size   in pls_integer default k_max_line_length)
    is
        k_program_name   constant fdc_defs.program_name_t := 'PUT_LINE';
        k_module_name    constant fdc_defs.module_name_t
                                      := k_package || '.' || k_program_name ;
    begin
        if nvl (p_chunk_size, 0) <= 0 then
            raise_application_error (
                glb_user_exceptions.k_ue_tamano_trozo_invalido,
                   k_module_name
                || ':'
                || 'p_chunk_size debe ser un número mayor que cero. Valor invocado:['
                || case
                       when p_chunk_size is null then 'NULL'
                       else to_char (p_chunk_size)
                   end
                || ']');
        end if;


        if get_file_name () is not null then
            utl_file.put_line (g_file_handle, p_line);
        else
            utl_display.put_line (p_linea                => p_line,
                                  p_largo_trozo_maximo   => p_chunk_size);
        end if;
    exception
        when utl_file.invalid_filehandle then
            utl_error.informa (
                p_programa   => k_module_name,
                p_mensaje    => fdc_utility.get_oracle_error_message (
                                   'INVALID FILE HANDLE'));

            raise;
        when utl_file.write_error then
            utl_error.informa (
                p_programa   => k_module_name,
                p_mensaje    => fdc_utility.get_oracle_error_message (
                                   'WRITE ERROR'));

            raise;
        when others then
            utl_error.informa (
                p_programa   => k_module_name,
                p_mensaje    => fdc_utility.get_oracle_error_message ('OTHERS'));

            raise;
    end put_line;

    procedure close_file
    is
        k_program_name   constant fdc_defs.program_name_t := 'CLOSE_FILE';
        k_module_name    constant fdc_defs.module_name_t
                                      := k_package || '.' || k_program_name ;
    begin
        if utl_file.is_open (g_file_handle) then
            utl_file.fclose (g_file_handle);
        end if;
    exception
        when utl_file.invalid_filehandle then
            utl_error.informa (
                p_programa   => k_module_name,
                p_mensaje    => fdc_utility.get_oracle_error_message);

            raise;
        when others then
            utl_error.informa (
                p_programa   => k_module_name,
                p_mensaje    => fdc_utility.get_oracle_error_message);
            raise;
    end close_file;
end utl_output;
/
