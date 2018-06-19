/*
        Name: apply_plsql_lab9.sql
        Author:  Matthew Schaupp
        Date: April 2, 2018
        Sources:
*/

--code to call other scripts here
@/home/student/Data/cit325/oracle/lib/cleanup_oracle.sql
@/home/student/Data/cit325/oracle/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

--open log file:
SPOOL base_t.txt

--add environment to allow PL/SQL to print to console
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

--code here:

BEGIN
        dbms_output.put_line('====================================================');
        dbms_output.put_line('===================== BASE_T =======================');
        dbms_output.put_line('====================================================');
END;
/

--Drop object types(keep in mind dependencies):
DROP TYPE noldor_t;
DROP TYPE silvan_t;
DROP TYPE sindar_t;
DROP TYPE teleri_t;
DROP TYPE orc_t;
DROP TYPE man_t;
DROP TYPE maia_t;
DROP TYPE hobbit_t;
DROP TYPE goblin_t;
DROP TYPE elf_t;
DROP TYPE dwarf_t;
DROP TYPE base_t;


CREATE OR REPLACE
  TYPE base_t IS OBJECT
  ( oid   NUMBER
  , oname VARCHAR2(30)
  , CONSTRUCTOR FUNCTION base_t
    ( oid    NUMBER
    , oname  VARCHAR2 )
    RETURN SELF AS RESULT
  , MEMBER FUNCTION get_oname RETURN VARCHAR2
  , MEMBER PROCEDURE set_oname
    ( oname  VARCHAR2)
  , MEMBER FUNCTION get_name RETURN VARCHAR2
  , MEMBER FUNCTION to_string RETURN VARCHAR2 )
  INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE
  TYPE BODY base_t IS
  /* Implement a default constructor. */
  CONSTRUCTOR FUNCTION base_t
  ( oid    NUMBER
  , oname  VARCHAR2 )
  RETURN SELF AS RESULT IS
  BEGIN
    self.oid := oid;
    self.oname := oname;
    RETURN;
  END base_t;

  --get_oname function
  MEMBER FUNCTION get_oname
  RETURN VARCHAR2 IS
  BEGIN
    RETURN '['||self.oname||']';
  END get_oname;

  --set_oname procedure
  MEMBER PROCEDURE set_oname
  (oname  VARCHAR2) IS
  BEGIN
    self.oname := oname;
  END set_oname;

  --get_name function
  MEMBER FUNCTION get_name
  RETURN VARCHAR2 IS
  BEGIN
    RETURN '[GET_NAME_STUB]';
  END get_name;
 
  /* Implement a to_string function. */
  MEMBER FUNCTION to_string
  RETURN VARCHAR2 IS
  BEGIN
    RETURN '[TO_STRING_STUB]';
  END to_string;
END;
/

DESC base_t

-- Display any compilation errors.
LIST
SHOW ERRORS

--close log
SPOOL OFF

--instruct program to exit sqlplus.  comment out if you want to remain inside 
--interactive sqlplus connection
--SPOOL OFF
--EXIT

--Uncomment for bash script
QUIT;
