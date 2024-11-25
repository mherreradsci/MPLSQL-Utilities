CREATE OR REPLACE PACKAGE BODY "TIUTIL_OWN"."UTL_DISPLAY"
/*
* Empresa:    Explora IT
* Proyecto:   Utilitarios Generales
* Objetivo:   Implementa un put_line equivalente al dbms_outut.put_line sin la
*             restricción de 255 bytes (Oracle 8i)
*
* Historia    Quién    Descripción
* ----------- -------- ---------------------------------------------------------
* 29-Nov-2004 mherrera Creación
* 17-Jul-2024 mherrera Agrega procedimiento new_line
* 17-Nov-2024 mherrera Rename this package from UTL_OUTPUT to UTL_DISPLAY
*/
is
    procedure put_line (
        p_linea                in varchar2,
        p_largo_trozo_maximo   in number default k_max_line_length)
    is
        -- Constantes para identificar el package/programa que se está ejecutando
        k_programa   constant fdc_defs.program_name_t := 'PUT_LINE';
        k_modulo     constant fdc_defs.module_name_t
            := substr (k_package || '.' || k_programa,
                       1,
                       fdc_defs.k_max_module_name_len) ;
        -- Variables
        v_len                 pls_integer;
        v_len2                pls_integer;
        v_new_line_pos        pls_integer;
        v_str                 clob;
    begin
        if nvl (p_largo_trozo_maximo, 0) <= 0 then
            raise_application_error (
                glb_user_exceptions.k_ue_tamano_trozo_invalido,
                   k_modulo
                || ':'
                || 'p_largo_trozo_maximo debe ser un número mayor que cero. Valor invocado:['
                || case
                       when p_largo_trozo_maximo is null then 'NULL'
                       else to_char (p_largo_trozo_maximo)
                   end
                || ']');
        end if;

        v_len := least (p_largo_trozo_maximo, k_max_line_length);

        if p_linea is null then
            utl_display.new_line ();
        elsif lengthb (p_linea) > v_len then
            v_new_line_pos := instr (p_linea, k_new_line_ch);

            if v_new_line_pos > 0 and v_len >= v_new_line_pos then
                v_len := v_new_line_pos - 1;
                v_len2 := v_new_line_pos + 1;
            else
                v_len := v_len;
                v_len2 := v_len + 1;
            end if;

            v_str := substr (p_linea, 1, v_len);
            dbms_output.put_line (v_str);
            put_line (substr (p_linea, v_len2), p_largo_trozo_maximo); -- Recursivo <<<<<<<<<<<<<<<<<<< Es lo mejor? VALIDAR con la nueva propuesta
        else
            dbms_output.put_line (p_linea);
        end if;
    exception
        when others then
            utl_error.informa (
                p_programa   => k_modulo,
                p_mensaje    => fdc_utility.get_oracle_error_message);

            raise;
    end put_line;

    -- UTL_DISPLAY.new_line: Funciona distinto al dbms_output.new_line ya qe el
    -- original pone un NEW_LINE solo si exite un dbms_output.put() en
    -- forma previa.En este caso, siempre pone un NEW_LINE. Esto ha sido probado
    -- con Oracle host server 19c (linux) y cliente  19.3.0.0.0 Windows
    procedure new_line
    is
    begin
        dbms_output.put (k_new_line_ch);
    end;
end utl_display;
/
