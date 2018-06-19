/*
        Name: rerunnable1.sql
        Author:  Matthew Schaupp
        Date: Jan. 18, 2018
        Sources:  www.oracle.com/technetwork/issue-archive/2011/11-sep/o51plsql-453456.html
*/

--code to call other scripts here

--open log file:
SPOOL apply_plsql_lab2_2.txt

--add environment to allow PL/SQL to print to console
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

--code here:
--anonymous block:
DECLARE
        lv_raw_input    VARCHAR2(60);
        lv_input        VARCHAR2(10);
BEGIN
        lv_raw_input := '&1';
        lv_input := SUBSTR(lv_raw_input, 1, 10);

        IF NVL((LENGTH(lv_raw_input) <= 10), FALSE) THEN
                dbms_output.put_line('Hello ' || lv_raw_input || '!');
        ELSIF NVL((LENGTH(lv_raw_input) > 10), FALSE) THEN
                dbms_output.put_line('Hello ' || lv_input || '!');
        ELSE
                dbms_output.put_line('Hello World!');
        END IF;
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
