/*
        Name: apply_plsql_lab9.sql
        Author:  Matthew Schaupp
        Date: APRIL 2, 2018
        Sources:
*/

--code to call other scripts here
--@/home/student/Data/cit325/oracle/lib/cleanup_oracle.sql
--@/home/student/Data/cit325/oracle/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

--open log file:
SPOOL noldor_t.txt

--add environment to allow PL/SQL to print to console
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

--code here:

BEGIN
        dbms_output.put_line('====================================================');
        dbms_output.put_line('===================== noldor_t =====================');
        dbms_output.put_line('====================================================');
END;
/

--Drop section:
Drop TYPE noldor_t;

CREATE OR REPLACE
  TYPE noldor_t UNDER elf_t
  ( elfkind   VARCHAR2(30)
  , CONSTRUCTOR FUNCTION noldor_t
  ( elfkind   VARCHAR2)
  RETURN SELF AS RESULT
  , MEMBER PROCEDURE set_elfkind
  ( elfkind  VARCHAR2)
  , MEMBER FUNCTION get_elfkind RETURN VARCHAR2
  , OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)
  INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY noldor_t IS
  /* Implement a default constructor. */  
  CONSTRUCTOR FUNCTION noldor_t
  ( elfkind      VARCHAR2)
  RETURN SELF AS RESULT IS
  BEGIN
    self.elfkind := elfkind;
    RETURN;
  END noldor_t;

  MEMBER PROCEDURE set_elfkind
  ( elfkind  VARCHAR2) IS
  BEGIN
    self.elfkind := elfkind;
  END set_elfkind;

  MEMBER FUNCTION get_elfkind
  RETURN VARCHAR2 IS
  BEGIN
    RETURN '['||self.elfkind||']';
  END get_elfkind;

  OVERRIDING MEMBER FUNCTION to_string
  RETURN VARCHAR2 IS
  BEGIN
    RETURN '['||self.oid||']['||self.name||']['||self.genus||']['||self.elfkind||']';
  END to_string;
END;
/

DESC noldor_t

-- Display any compilation errors.
LIST
SHOW ERRORS

--close log
SPOOL OFF

--instruct program to exit sqlplus.  comment out if you want to remain inside 
--interactive sqlplus connection
--SPOOL OFF
--exit

--Uncomment for bash script:
QUIT;
