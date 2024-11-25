-- Test case
--$ NLS_LANG=AMERICAN_AMERICA.UTF8 sqlplus system@centos-ora11g @eTest_NLS_Plus_Encoding.sql < /tmp/pass
--$ NLS_LANG=SPANISH_CHILE.WE8MSWIN1252 sqlplus system@centos-ora11g @eTest_NLS_Plus_Encoding.sql < /tmp/pass
--$ NLS_LANG=SPANISH_CHILE.UTF8 sqlplus system@centos-ora11g @eTest_NLS_Plus_Encoding.sql < /tmp/pass

WHENEVER SQLERROR EXIT SQL.SQLCODE

set echo off lines 600 pagesize 9999
col DB_CHARACTERSET format a30

select VALUE as DB_CHARACTERSET from nls_database_parameters where parameter='NLS_CHARACTERSET';

col PARAMETER format a30 wrap
col VALUE format a30 wrap

SELECT * FROM nls_session_parameters where parameter in('NLS_TERRITORY', 'NLS_LANGUAGE','NLS_NUMERIC_CHARACTERS','NLS_DATE_FORMAT','NLS_DATE_LANGUAGE');

select 'ñ' as ch, chr(241) from dual;


-- Valida que el separador decimal sea coma (,)
select to_number('99,90', '990D00') as num from dual;

-- Valida que las fechas sean en español 
select next_day(trunc(sysdate, 'month'), 'lunes') sd from dual;

-- Valida que el primer día de la semana sea lunes
select case to_char(next_day(trunc(sysdate, 'month'), 'lunes'), 'd') when '1' then 'Pass: Lúnes es el primer día de la semana' else 'Fail' end as "Test 1er día de la semana" from dual;
 
col C_ENCODING new_value V_ENCODING

with encoding as (
    select case when 'ñ' != chr(241) then 'Fail' else 'Pass: Encoding Ok' end as TestEncoding from dual
)     
select  case testencoding when 'Pass: Encoding Ok' then 0 else 1/0 end as force_error  
from encoding;
