-- Test case
--$ NLS_LANG=AMERICAN_AMERICA.UTF8 sqlplus system@centos-ora11g @eTest_NLS_Plus_Encoding.sql < /tmp/pass
--$ NLS_LANG=SPANISH_CHILE.WE8MSWIN1252 sqlplus system@centos-ora11g @eTest_NLS_Plus_Encoding.sql < /tmp/pass
--$ NLS_LANG=SPANISH_CHILE.UTF8 sqlplus system@centos-ora11g @eTest_NLS_Plus_Encoding.sql < /tmp/pass

--$ NLS_LANG=SPANISH_CHILE.UTF8 sqlplus system@docker-19c-pdb1-testing @eTest_NLS_Plus_Encoding.sql

WHENEVER SQLERROR EXIT SQL.SQLCODE

set echo off lines 600 pagesize 9999


col PARAMETER format a30 wrap
col VALUE format a30 wrap

select * from nls_database_parameters where parameter like 'NLS_%CHARACTERSET' order by parameter;

SELECT * FROM nls_session_parameters where parameter in('NLS_TERRITORY', 'NLS_LANGUAGE','NLS_NUMERIC_CHARACTERS','NLS_DATE_FORMAT','NLS_DATE_LANGUAGE');


-- Valida que el separador decimal sea coma (,)
select to_number('99,90', '990D00') as num from dual;

-- Valida que las fechas sean en español 
select next_day(trunc(sysdate, 'month'), 'lunes') sd from dual;

-- Valida que el primer día de la semana sea lunes
select case to_char(next_day(trunc(sysdate, 'month'), 'lunes'), 'd') when '1' then 'Pass: Lúnes es el primer día de la semana' else 'Fail' end as "Test 1er día de la semana" from dual;
 
col C_ENCODING new_value V_ENCODING

-- Valida que el lenguaje y character set sea el correcto
select ascii('ñ') as a, chr(ascii('ñ')) as c, unistr('\00f1') as u from dual;

with encoding as (
    select case when 'ñ' != chr(ascii('ñ')) then 'Fail' else 'Pass: Encoding Ok' end as TestEncoding from dual
)     
select  case testencoding when 'Pass: Encoding Ok' then 0 else 1/0 end as force_error  
from encoding;

