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
SPOOL insert_instances.txt

--add environment to allow PL/SQL to print to console
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

--code here:

BEGIN
        dbms_output.put_line('====================================================');
        dbms_output.put_line('===================== INSERTS ======================');
        dbms_output.put_line('====================================================');
END;
/

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, man_t(1, 'Man', 'Boromir', 'Men'));

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, man_t(2, 'Man', 'Faramir', 'Men'));

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, hobbit_t(3, 'Hobbit', 'Bilbo', 'Hobbits'));

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, hobbit_t(4, 'Hobbit', 'Frodo', 'Hobbits'));

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, hobbit_t(5, 'Hobbit', 'Merry', 'Hobbits'));

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, hobbit_t(6, 'Hobbit', 'Pippin', 'Hobbits'));

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, hobbit_t(7, 'Hobbit', 'Samwise', 'Hobbits'));

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, dwarf_t(8, 'Dwarf', 'Gimli', 'Dwarves'));

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, noldor_t(9,'Elf','Feanor','Elves','Noldor'));

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, silvan_t(10,'Elf','Tauriel','Elves','Silvan'));

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, teleri_t(11,'Elf','Earwen','Elves','Teleri'));

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, teleri_t(12,'Elf','Celeborn','Elves','Teleri'));

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, sindar_t(13,'Elf','Thranduil','Elves','Sindar'));

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, sindar_t(14,'Elf','Legolas','Elves','Sindar'));

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, orc_t(15,'Orc','Azog the Defiler','Orcs'));

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, orc_t(16,'Orc','Bolg','Orcs'));

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, maia_t(17,'Maia','Gandalf the Gray','Maia'));

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, maia_t(18,'Maia','Radagast the Brown','Maia'));

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, maia_t(19,'Maia','Saruman the White','Maia'));

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, goblin_t(20,'Goblin','The Great Goblin','Goblins'));

INSERT INTO tolkien
VALUES
( tolkien_s.NEXTVAL
, man_t(21,'Man','Aragorn','Men'));

-- Display any compilation errors.
LIST
SHOW ERRORS

--close log
SPOOL OFF

--instruct program to exit sqlplus.  comment out if you want to remain inside 
--interactive sqlplus connection
--SPOOL OFF
exit

--Uncomment for bash script:
--QUIT;
