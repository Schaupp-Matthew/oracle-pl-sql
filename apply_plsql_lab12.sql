/*
        Name: apply_plsql_lab9.sql
        Author:  Matthew Schaupp
        Date: Mar. 27, 2018
        Sources:
*/

--code to call other scripts here
@/home/student/Data/cit325/oracle/lib/cleanup_oracle.sql
@/home/student/Data/cit325/oracle/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

--open log file:
SPOOL apply_plsql_lab12.txt

--add environment to allow PL/SQL to print to console
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

--code here:

BEGIN
        dbms_output.put_line('====================================================');
        dbms_output.put_line('===================== LAB 12 =======================');
        dbms_output.put_line('====================================================');
END;
/

-- Drop section:
DROP TYPE item_tab;
DROP TYPE item_obj;
DROP FUNCTION item_list;

CREATE OR REPLACE TYPE item_obj IS OBJECT
( title  VARCHAR2(60)
, subtitle  VARCHAR2(60)
, rating  VARCHAR2(8)
, release_date  DATE);
/

DESC item_obj

CREATE OR REPLACE TYPE item_tab IS TABLE OF ITEM_OBJ;
/

DESC item_tab

CREATE OR REPLACE
  FUNCTION item_list
  ( pv_start_date DATE
  , pv_end_date DATE := TRUNC(SYSDATE)+1) RETURN item_tab IS
 
    /* Declare a record type. */
    TYPE item_rec IS RECORD
    ( title  VARCHAR2(60)
    , subtitle  VARCHAR2(60)
    , rating  VARCHAR2(8)
    , release_date  DATE);
 
    /* Declare reference cursor for an NDS cursor. */
    item_cur   SYS_REFCURSOR;
 
    /* Declare a item row for output from an NDS cursor. */
    item_row   ITEM_REC;
    item_set   ITEM_TAB := item_tab();
 
    /* Declare dynamic statement. */
    stmt  VARCHAR2(2000);

   /* Declare rating agency variable */
   r_agency VARCHAR2(4) := 'MPAA';

  BEGIN
    /* Create a dynamic statement. */
    stmt := 'SELECT item_title AS title, '
         || 'item_subtitle AS subtitle, '
         || 'item_rating AS rating, '
         || 'item_release_date AS release_date '
         || 'FROM item '
         || 'WHERE item_rating_agency = ''MPAA'' '
         || 'AND item_release_date BETWEEN :pv_start_date_in AND :pv_end_date';

    dbms_output.put_line(stmt);

    /* Open and read dynamic cursor. */
    OPEN item_cur FOR stmt USING pv_start_date, pv_end_date;
    LOOP
      /* Fetch the cursror into a customer row. */
      FETCH item_cur INTO item_row;
      EXIT WHEN item_cur%NOTFOUND;
 
      /* Extend space and assign a value collection. */      
      item_set.EXTEND;
      item_set(item_set.COUNT) :=
        item_obj( title  =>  item_row.title
                   , subtitle =>  item_row.subtitle
                   , rating   =>  item_row.rating
                   , release_date  =>  item_row.release_date );
    END LOOP;
 
    /* Return item set. */
    RETURN item_set;
  END item_list;
/

--LIST
--SHOW ERRORS

DESC item_list

-- Test Case:
COL title    FORMAT A60 HEADING "TITLE"
COL rating   FORMAT A6  HEADING "RATING"
SELECT il.title
     , il.rating
FROM TABLE(item_list(TO_DATE('01-JAN-2000','DD-MON-YYYY'))) il;
--ORDER BY 1, 2;

-- Display any compilation errors.
LIST
SHOW ERRORS

--close log
SPOOL OFF

--instruct program to exit sqlplus.  comment out if you want to remain inside 
--interactive sqlplus connection
--SPOOL OFF
exit
