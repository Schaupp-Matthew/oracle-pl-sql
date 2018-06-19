/*
        Name: rerunnable1.sql
        Author:  Matthew Schaupp
        Date: Jan. 18, 2018
*/

--code to call other scripts here

--open log file:
SPOOL rerunnable1.txt

--add environment to allow PL/SQL to print to console
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

--code here:

--anonymous block:
BEGIN
        dbms_output.put_line('Hello '||'&1'||'!');
END;
/

--close log
SPOOL OFF

--instruct program to exit sqlplus.  comment out if you want to remain inside 
--interactive sqlplus connection
SPOOL OFF

