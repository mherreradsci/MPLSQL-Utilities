CREATE OR REPLACE PACKAGE "TIUTIL_OWN"."UTL_DISPLAY"
/*
* Empresa:    Explora IT
* Proyecto:   Utilitarios Generales
* Objetivo:   Implementa un put_line equivalente al dbms_outut.put_line sin la
*             restricción de 255 bytes (Oracle 8i)
*
* Historia    Quien    Descripción
* ----------- -------- ---------------------------------------------------------
* 29-Nov-2004 mherrera Creación
* 17-Jul-2024 mherrera Agrega procedimiento new_line
* 17-Nov-2024 mherrera Rename this package from UTL_OUTPUT to UTL_DISPLAY
*/

is
    -- Constantes para identificar el package
    k_package    constant varchar2 (30) := upper ('UTL_DISPLAY');
    -- Constantes
    k_new_line_ch   constant varchar2 (1) := chr (10);
    k_blank_ch   constant varchar2 (1) := chr (32);

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


    procedure put_line (p_linea              in varchar2,
                        p_largo_trozo_maximo in number default k_max_line_length);

    -- UTL_DISPLAY.new_line: Funciona distinto al dbms_output.new_line ya qe el
    -- original pone un NEW_LINE solo si exite un dbms_output.put() en
    -- forma previa.En este caso, siempre pone un NEW_LINE. Esto ha sido probado
    -- con Oracle host server 19c (linux) y cliente  19.3.0.0.0 Windows
    procedure new_line;
end utl_display;
/
