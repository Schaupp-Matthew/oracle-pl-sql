/*
        Name: apply_plsql_lab3.sql
        Author:  Matthew Schaupp
        Date: Jan. 24, 2018
        Sources:
*/

--code to call other scripts here

--open log file:
SPOOL apply_plsql_lab3_mylog.txt

--add environment to allow PL/SQL to print to console
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF
     
--code here:

--function to check date
CREATE OR REPLACE
  FUNCTION verify_date
  ( pv_date_in  VARCHAR2) RETURN DATE IS
  /* Local return variable. */
  lv_date  DATE;
BEGIN
  /* Check for a DD-MON-RR or DD-MON-YYYY string. */
  IF REGEXP_LIKE(pv_date_in,'^[0-9]{2,2}-[ADFJMNOS][ACEOPU][BCGLNPRTVY]-([0-9]{2,2}|[0-9]{4,4})$') THEN
    /* Case statement checks for 28 or 29, 30, or 31 day month. */
    CASE
      /* Valid 31 day month date value. */
      WHEN SUBSTR(pv_date_in,4,3) IN ('JAN','MAR','MAY','JUL','AUG','OCT','DEC') AND
           TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 31 THEN 
        lv_date := pv_date_in;
      /* Valid 30 day month date value. */
      WHEN SUBSTR(pv_date_in,4,3) IN ('APR','JUN','SEP','NOV') AND
           TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 30 THEN 
        lv_date := pv_date_in;
      /* Valid 28 or 29 day month date value. */
      WHEN SUBSTR(pv_date_in,4,3) = 'FEB' THEN
        /* Verify 2-digit or 4-digit year. */
        IF (LENGTH(pv_date_in) = 9 AND MOD(TO_NUMBER(SUBSTR(pv_date_in,8,2)) + 2000,4) = 0 OR
            LENGTH(pv_date_in) = 11 AND MOD(TO_NUMBER(SUBSTR(pv_date_in,8,4)),4) = 0) AND
            TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 29 THEN
          lv_date := pv_date_in;
        ELSE /* Not a leap year. */
          IF TO_NUMBER(SUBSTR(pv_date_in,1,2)) BETWEEN 1 AND 28 THEN
            lv_date := pv_date_in;
          ELSE
            lv_date := NULL;
          END IF;
        END IF;
      ELSE
        /* Assign a default date. */
        lv_date := NULL;
    END CASE;
  ELSE
    /* Assign a default date. */
    lv_date := NULL;
  END IF;
  /* Return date. */
  RETURN lv_date;
END;
/

--anonymous block
DECLARE
        lv_input1 VARCHAR2(100);
        lv_input2 VARCHAR2(100);
        lv_input3 VARCHAR2(100);
        --create table of inputs/parameters
        TYPE list IS TABLE OF VARCHAR2(100);
        lv_strings LIST;
        --default record struct
        TYPE string_record IS RECORD
        ( xnum          NUMBER
        , xdate         DATE
        , xstring       VARCHAR2(30));
        --local record struct
        three_type STRING_RECORD;
BEGIN
        lv_input1 := '&1';   
        lv_input2 := '&2'; 
        lv_input3 := '&3';
        lv_strings := list(lv_input1, lv_input2, lv_input3);

        --loop through list to assign values to record
        FOR i IN 1..lv_strings.COUNT LOOP
                IF REGEXP_LIKE(lv_strings(i), '^[[:digit:]]*$') THEN
                        three_type.xnum := lv_strings(i);
                ELSIF REGEXP_LIKE(lv_strings(i), '^[[:alnum:]]*$') THEN
                        three_type.xstring := lv_strings(i);
                ELSIF REGEXP_LIKE(lv_strings(i)
                , '^[0-9]{2,2}-[[:alpha:]]{3,3}-([0-9]{2,2}|[0-9]{4,4})$') THEN
                        three_type.xdate := verify_date(lv_strings(i));
                ELSIF verify_date(lv_strings(i)) IS NOT NULL THEN
                        three_type.xdate := lv_strings(i);
                END IF;
        END LOOP;
        
        dbms_output.put_line('Record [' || three_type.xnum || '] [' || three_type.xstring || '] [' || three_type.xdate || ']');

        

         
EXCEPTION
        WHEN OTHERS THEN
                dbms_output.put_line(SQLERRM);
END;
/

--close log
SPOOL OFF

--instruct program to exit sqlplus.  comment out if you want to remain inside 
--interactive sqlplus connection
--SPOOL OFF
exit
