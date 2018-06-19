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
SPOOL man_t.txt

--add environment to allow PL/SQL to print to console
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

--code here:

BEGIN
        dbms_output.put_line('====================================================');
        dbms_output.put_line('===================== man_t ========================');
        dbms_output.put_line('====================================================');
END;
/

--Drop section:
Drop TYPE man_t;

CREATE OR REPLACE
  TYPE man_t UNDER base_t
  ( name      VARCHAR2(30)
  , genus     VARCHAR2(30)
  , CONSTRUCTOR FUNCTION man_t
  ( name      VARCHAR2
  , genus     VARCHAR2)
  RETURN SELF AS RESULT
  , MEMBER PROCEDURE set_name
  ( name  VARCHAR2)
  , MEMBER FUNCTION get_genus RETURN VARCHAR2
  , MEMBER PROCEDURE set_genus
  ( genus  VARCHAR2)
  , OVERRIDING MEMBER FUNCTION get_name RETURN VARCHAR2
  , OVERRIDING MEMBER FUNCTION to_string RETURN VARCHAR2)
  INSTANTIABLE NOT FINAL;
/

CREATE OR REPLACE TYPE BODY man_t IS
  /* Implement a default constructor. */  
  CONSTRUCTOR FUNCTION man_t
  ( name      VARCHAR2
  , genus     VARCHAR2)
  RETURN SELF AS RESULT IS
  BEGIN
    self.name := name;
    self.genus := genus;
    RETURN;
  END man_t;

  MEMBER PROCEDURE set_name
  ( name  VARCHAR2) IS
  BEGIN
    self.name := name;
  END set_name;

  MEMBER FUNCTION get_genus
  RETURN VARCHAR2 IS
  BEGIN
    RETURN '['||self.genus||']';
  END get_genus;

  MEMBER PROCEDURE set_genus
  ( genus  VARCHAR2) IS
  BEGIN
    self.genus := genus;
  END set_genus;

  OVERRIDING MEMBER FUNCTION get_name
  RETURN VARCHAR2 IS
  BEGIN
    RETURN '['||self.name||']';
  END get_name;

  OVERRIDING MEMBER FUNCTION to_string
  RETURN VARCHAR2 IS
  BEGIN
    RETURN '['||self.oid||']['||self.name||']['||self.genus||']';
  END to_string;
END;
/

DESC man_t

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
