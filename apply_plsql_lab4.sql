/*
        Name: apply_plsql_lab3.sql
        Author:  Matthew Schaupp
        Date: Jan. 31, 2018
        Sources:
*/

--code to call other scripts here

--open log file:
SPOOL apply_plsql_lab4.txt

--add environment to allow PL/SQL to print to console
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF
     
--code here:

--create sql object type
CREATE OR REPLACE
        TYPE christmas IS OBJECT
        ( day_name VARCHAR2(8)
        , gift_name VARCHAR2(24));
/

--anonymous block
DECLARE
        --array of days and gifts
        TYPE days IS TABLE OF VARCHAR2(8);
        TYPE gifts IS TABLE OF christmas;

        --initialize collections
        lv_days DAYS := days('first', 'second', 'third', 'fourth', 'fifth', 'sixth'
                                , 'seventh', 'eighth', 'nineth', 'tenth', 'eleventh', 'twelfth');
        lv_gifts GIFTS := gifts(        christmas('and a', 'Partridge in a pear tree')
                                        ,christmas('Two', 'Turtle doves')
                                        ,christmas('Three', 'French hens')
                                        ,christmas('Four', 'Calling birds')
                                        ,christmas('Five', 'Golden rings')
                                        ,christmas('Six', 'Geese a laying')
                                        ,christmas('Seven', 'Swans a swimming')
                                        ,christmas('Eight', 'Maids a milking')
                                        ,christmas('Nine', 'Ladies dancing')
                                        ,christmas('Ten', 'Lords a leaping')
                                        ,christmas('Eleven', 'Pipers piping')
                                        ,christmas('Twelve', 'Drummers drumming'));
      lv_count NUMBER := 1;   
        
BEGIN
        FOR i IN 1..lv_days.COUNT LOOP
                IF lv_days(i) = 'first' THEN
                        dbms_output.put_line('On the ' || lv_days(i) || ' day of Christmas');
                        dbms_output.put_line('my true love sent to me:');
                        dbms_output.put_line('-A ' || lv_gifts(i).gift_name);
                        dbms_output.put_line(CHR(13));
                        lv_count := lv_count + 1;
                ELSE
                        dbms_output.put_line('On the ' || lv_days(i) || ' day of Christmas');
                        dbms_output.put_line('my true love sent to me:');

                        FOR i IN REVERSE 1..lv_count LOOP
                                dbms_output.put_line('-' || lv_gifts(i).day_name || ' ' || lv_gifts(i).gift_name);
                        END LOOP;

                        dbms_output.put_line(CHR(13));
                        lv_count := lv_count + 1;
                END IF;
        END LOOP;
                                
         
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
