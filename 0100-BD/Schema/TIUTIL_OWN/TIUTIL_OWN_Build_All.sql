/*
* Create Schema Script 
*  Database Version          : 19.0.0.0.0 
*  Database Compatible Level : 19.0.0 
*  Script Compatible Level   : 11.2 
*  DB Connect String         : DOCKER-19C-PDB1-TARGET 
*  Schema                    : TIUTIL_OWN 
*  Script Created by         : SYSTEM 
*  Script Created at         : 17-11-2024 22:40:00 
*/

-- OBSERVACIÓN: Este Script sirve para la Instalacion inicial, no tiene
-- grants a terceros. Los GRANTS a terceros se deben incluir en un set 
-- de scripts aparte, generalmente en el directorio GrantsToThirdParties, 
-- para mantener un correcto Control de Configuración de Fuentes (GIT)


---------------------------------- IMPORTANTE ----------------------------------
---------------------------------- IMPORTANTE ----------------------------------
---------------------------------- IMPORTANTE ----------------------------------
-- Para ejecutar desde MINGW64 en Windows se debe asignar la variable de
-- ambiente NLS_LANG utilizando español y UTF8 o AL32UTF8, por ejemplo:
--  $ cd <BASE_PROJ>/0200-MPLSQL-Utilities/0100-BD/Schema/TIUTIL_OWN
--  $ NLS_LANG=SPANISH_CHILE.UTF8 sqlplus system@centos-ora11g @TIUTIL_OWN_Build_All.sql

-- Una vez ejecutado el script se debe validar que el último mensaje
-- sea "### Finished!!!" Si no se muestra este mensaje quiere decir que hubo
-- algún problema con la ejecución. En este caso, debe revisar el log de este
-- script para detectar el error.

-------------------------------- FIN IMPORTANTE --------------------------------

-- Incluir siempre los 2 scripts con WHENEVER
WHENEVER SQLERROR EXIT SQL.SQLCODE
WHENEVER OSERROR EXIT FAILURE


col C_SERVICE_NAME new_value V_SERVICE_NAME
col C_DT new_value V_DT

select  UPPER(sys_context('USERENV','SERVICE_NAME')) AS C_SERVICE_NAME,
        TO_CHAR(SYSDATE, 'yyyymmdd_hh24miss') AS C_DT
from dual;

spool ./TIUTIL_OWN_Build_All-&V_SERVICE_NAME.-&V_DT..spool.out  
set echo on


ALTER SESSION SET NLS_TERRITORY=CHILE;
ALTER SESSION SET NLS_LANGUAGE=SPANISH;


-- Valida Language and encoding
@../../../0400-Utilities/eTest_NLS_Plus_Encoding.sql

-- DROP_OWNER_AND_ROLE='Yes'/'No' First time must be 'No'
DEFINE DROP_OWNER_AND_ROLE='Yes' 

PROMPT ### Owner Roles
@./Roles/TIUTIL_OWN_DEPLOY_ROL.sql
@./Roles/TIUTIL_OWN_DEVELOP_ROL.sql


PROMPT ### User
@./Users/TIUTIL_OWN.sql

PROMPT ### Packages

@./Packages/UTL_DISPLAY.pks.sql
@./Packages/UTL_OUTPUT.pks.sql
@./Packages/UTL_DIRECTORY.pks.sql

@./Packages/UTL_DISPLAY.pkb.sql
@./Packages/UTL_OUTPUT.pkb.sql
@./Packages/UTL_DIRECTORY.pkb.sql

PROMPT ### Public Synonyms
@./Synonyms/PUBLIC_SYNONYMS.sql

PROMPT ### Developers Roles for this application
@./Roles/TIUTIL_DEV_ROL.sql


PROMPT ### Finished!!!

spool off

exit
/
