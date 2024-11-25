DEFINE V_USER="TIUTIL_OWN"

begin
    IF '&DROP_OWNER_AND_ROLE' = 'Yes' then
        execute immediate 'DROP USER &V_USER CASCADE';
    END IF;
exception
    when others then
        -- If the role the script is trying to delete does not exist,
        -- the process continues as normal. But, if there is another error,
        -- then it raises the error.
        if SQLCODE != -01918 then
            raise;
        end if;
end;
/


CREATE USER &V_USER
  IDENTIFIED BY VALUES 'S:30B4D203B21AC0C5672FDA8DE892AE98B743D053C4A6C2EC2578801D50BA;T:F21B06E2C9008FBDA93301E4616199CC06DC02F7DA3930AD89B77F5E709ED0B48CAA7AF6F26907FC587278D4B2A7D8B42D8065690AA2B34F28F8124566926005A880ED88521D4323233D0A03A10B26DD'
  DEFAULT TABLESPACE USERS
  TEMPORARY TABLESPACE TEMP
  PROFILE DEFAULT
  ACCOUNT UNLOCK
/
 
GRANT TIFUND_DEV_ROL TO &V_USER
/
GRANT &V_USER._DEPLOY_ROL TO &V_USER
/
GRANT &V_USER._DEVELOP_ROL TO &V_USER
/

-- Default Roles:
-- When a new role is assigned to this OWNER, this role will be added 
-- to the list of default roles.
ALTER USER &V_USER. DEFAULT ROLE ALL except &V_USER._DEPLOY_ROL
/


-- IMPORTANT:
-- Minimum grants to compile own objects that depend on higher level schemas

grant execute on tifund_own.fdc_defs to &V_USER
/

grant execute on tifund_own.fdc_utility to &V_USER
/

grant execute on tifund_own.glb_user_exceptions to &V_USER
/

grant execute on tifund_own.utl_error to &V_USER
/
