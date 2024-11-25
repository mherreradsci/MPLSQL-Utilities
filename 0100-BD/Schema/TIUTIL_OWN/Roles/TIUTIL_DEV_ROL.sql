-- TODO: Automatizar la creación de este script
DEFINE V_ROLE="TIUTIL_DEV_ROL"

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

GRANT EXECUTE ON TIUTIL_OWN.UTL_DISPLAY TO &V_ROLE
/
GRANT EXECUTE ON TIUTIL_OWN.UTL_OUTPUT TO &V_ROLE
/
GRANT EXECUTE ON TIUTIL_OWN.UTL_DIRECTORY TO &V_ROLE
/

