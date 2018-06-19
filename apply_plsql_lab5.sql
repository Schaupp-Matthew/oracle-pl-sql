/*
        Name: apply_plsql_lab5.sql
        Author:  Matthew Schaupp
        Date: Feb. 6, 2018
        Sources:
*/

--code to call other scripts here
@/home/student/Data/cit325/oracle/lib/cleanup_oracle.sql
@/home/student/Data/cit325/oracle/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

--open log file:
SPOOL apply_plsql_lab5.txt

--add environment to allow PL/SQL to print to console
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

--code here:

BEGIN
        dbms_output.put_line('====================================================');
        dbms_output.put_line('===================== LAB 5 ========================');
        dbms_output.put_line('====================================================');
END;
/

--drop previously created
--DROP SEQUENCE rating_agency_s;
--DROP TABLE rating_agency;
--DROP TYPE rating_agency_tab;
--DROP TYPE rating_agency_obj;

--ALTER TABLE item
--        DROP COLUMN rating_agency_id;

--Create the new Rating_Agency table and Rating_Agency_S sequence
CREATE SEQUENCE rating_agency_s START WITH 1001;

CREATE TABLE rating_agency AS
  SELECT rating_agency_s.NEXTVAL AS rating_agency_id
  ,      il.item_rating AS rating
  ,      il.item_rating_agency AS rating_agency
  FROM  (SELECT DISTINCT
                i.item_rating
         ,      i.item_rating_agency
         FROM   item i) il;

--DESCRIBE rating_agency;

--Add new rating_agency_id column to ITEM table
ALTER TABLE item
ADD (rating_agency_id   NUMBER);

--DESCRIBE item;

--SQL structure/composite object type
CREATE OR REPLACE 
        TYPE rating_agency_obj IS OBJECT
        ( rating_agency_id      NUMBER
        , rating                VARCHAR2(8)
        , rating_agency         VARCHAR2(4));
/

--SQL collection/table of object type
CREATE OR REPLACE
        TYPE rating_agency_tab IS TABLE OF rating_agency_obj;
/

--anonymous block:
--Declare a local cursor
DECLARE
        CURSOR c IS
        SELECT  rating_agency_id AS id
        ,       rating AS rating
        ,       rating_agency AS agency
        FROM    rating_agency;

lv_table  RATING_AGENCY_TAB := rating_agency_tab();

BEGIN
--cursor for loop
FOR i IN c LOOP
        lv_table.Extend;
        lv_table(lv_table.COUNT) := rating_agency_obj   ( i.id
                                                        , i.rating
                                                        , i.agency);
END LOOP;

--range for loop
FOR i IN lv_table.FIRST..lv_table.LAST LOOP
        UPDATE item
        SET rating_agency_id = lv_table(i).rating_agency_id
        WHERE item.item_rating = lv_table(i).rating
        AND   item.item_rating_agency = lv_table(i).rating_agency;
END LOOP;

END;
/
--Test Case Code:
--Test 1:
COLUMN rating_agency_id FORMAT 9999
COLUMN rating           FORMAT A18
COLUMN rating_agency    FORMAT A22
SELECT * FROM rating_agency;

--Test 2:
SET NULL ''
COLUMN table_name   FORMAT A18
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'ITEM'
ORDER BY 2;

--Test 3:
SELECT   rating_agency_id
,        COUNT(*)
FROM     item
WHERE    rating_agency_id IS NOT NULL
GROUP BY rating_agency_id
ORDER BY 1;

--close log
SPOOL OFF

--instruct program to exit sqlplus.  comment out if you want to remain inside 
--interactive sqlplus connection
--SPOOL OFF
--exit
