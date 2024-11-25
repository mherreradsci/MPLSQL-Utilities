DEFINE V_ROLE="TIUTIL_OWN_DEVELOP_ROL"

begin
    IF '&DROP_OWNER_AND_ROLE' = 'Yes' then
        execute immediate 'DROP ROLE &V_ROLE';
    END IF;
exception
    when others then
        -- If the role the script is trying to delete does not exist,
        -- the process continues as normal. But, if there is another error,
        -- then it raises the error.
        if SQLCODE != -01919 then
            raise;
        end if;
end;
/


CREATE ROLE &V_ROLE NOT IDENTIFIED
/


GRANT CREATE SESSION TO &V_ROLE
/
GRANT DEBUG CONNECT SESSION TO &V_ROLE
/
GRANT SELECT_CATALOG_ROLE TO &V_ROLE
/

GRANT CREATE PROCEDURE TO &V_ROLE
/
