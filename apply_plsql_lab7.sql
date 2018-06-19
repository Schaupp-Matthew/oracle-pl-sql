/*
        Name: apply_plsql_lab7.sql
        Author:  Matthew Schaupp
        Date: Feb. 20, 2018
        Sources:
*/

--code to call other scripts here
@/home/student/Data/cit325/oracle/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

--open log file:
SPOOL apply_plsql_lab7.txt

--add environment to allow PL/SQL to print to console
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

--code here:

BEGIN
        dbms_output.put_line('====================================================');
        dbms_output.put_line('===================== LAB 7 ========================');
        dbms_output.put_line('====================================================');
END;
/

-- ---------------------------------------------------
--Step 0:  Lab set-up:
-- ---------------------------------------------------
SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name = 'DBA';

UPDATE system_user
SET    system_user_name = 'DBA'
WHERE  system_user_name LIKE 'DBA%';

DECLARE
  /* Create a local counter variable. */
  lv_counter  NUMBER := 2;
 
  /* Create a collection of two-character strings. */
  TYPE numbers IS TABLE OF NUMBER;
 
  /* Create a variable of the roman_numbers collection. */
  lv_numbers  NUMBERS := numbers(1,2,3,4);
 
BEGIN
  /* Update the system_user names to make them unique. */
  FOR i IN 1..lv_numbers.COUNT LOOP
    /* Update the system_user table. */
    UPDATE system_user
    SET    system_user_name = system_user_name || ' ' || lv_numbers(i)
    WHERE  system_user_id = lv_counter;
 
    /* Increment the counter. */
    lv_counter := lv_counter + 1;
  END LOOP;
END;
/

SELECT system_user_id
,      system_user_name
FROM   system_user
WHERE  system_user_name LIKE 'DBA%';

-- Conditionally drop the insert_contact procedure/function
-- Makes the script re-runnable
BEGIN
  FOR i IN (SELECT uo.object_type
            ,      uo.object_name
            FROM   user_objects uo
            WHERE  uo.object_name = 'INSERT_CONTACT') LOOP
    EXECUTE IMMEDIATE 'DROP ' || i.object_type || ' ' || i.object_name;
  END LOOP;
END;
/

-- --------------------------------------------
-- Step 1:  Create an insert_contact procedure
-- Inserts into the member, contact, address, and telephone tables
-- --------------------------------------------

/*
--Create an object type
Create OR REPLACE
  TYPE cl_data IS OBJECT
    ( table_name  VARCHAR2(20)
    , column_name VARCHAR2(20)
    , lookup_type VARCHAR2(20));
/
*/

CREATE OR REPLACE FUNCTION insert_contact
( pv_first_name         VARCHAR2
, pv_middle_name        VARCHAR2
, pv_last_name          VARCHAR2
, pv_contact_type       VARCHAR2
, pv_account_number     VARCHAR2
, pv_member_type        VARCHAR2
, pv_credit_card_number VARCHAR2
, pv_credit_card_type   VARCHAR2
, pv_city               VARCHAR2
, pv_state_province     VARCHAR2
, pv_postal_code        VARCHAR2
, pv_address_type       VARCHAR2
, pv_country_code       VARCHAR2
, pv_area_code          VARCHAR2
, pv_telephone_number   VARCHAR2
, pv_telephone_type     VARCHAR2
, pv_user_name          VARCHAR2) 
RETURN NUMBER --Return type for function
AUTHID CURRENT_USER IS --Sets to invoker rights

PRAGMA AUTONOMOUS_TRANSACTION; --Sets autonomous behavior

-- -------------------------------------------------
-- Declaration section for procedure
-- -------------------------------------------------

/*
-- Create a collection that will hold cl_data object types
TYPE cursor_data IS TABLE OF CL_DATA;

-- Initialize the collection
lv_cursor_data CURSOR_DATA := cursor_data( cl_data('MEMBER', 'MEMBER_TYPE', pv_member_type)
                                               , cl_data('CONTACT', 'CONTACT_TYPE', pv_contact_type)
                                               , cl_data('ADDRESS', 'ADDRESS_TYPE', pv_address_type)
                                               , cl_data('TELEPHONE', 'TELEPHONE_TYPE', pv_telephone_type));

-- Create a collection for the common_lookup_id
TYPE cl_id IS TABLE OF INT(10);
-- Declare local variable of cl_id type
lv_common_lookup_id CL_ID;
*/

-- Local variable for the timestamp
lv_date DATE := SYSDATE;
--dbms_output.put_line('The SYSDATE is: ' || lv_date);

-- Local variable for system user id
lv_system_user NUMBER;

-- Local variables for _TYPES
lv_member_type       INT(10);
lv_contact_type      INT(10);
lv_address_type      INT(10);
lv_telephone_type    INT(10);
lv_credit_card_type  INT(10);


-- Dynamic cursor to call to retrieve the common_lookup_id
-- where common_lookup_type = 'INDIVIDUAL' and common_lookup_table = 'MEMBER' and common_lookup_column = 
-- 'MEMBER_TYPE'
CURSOR c ( cv_table_name        VARCHAR2
         , cv_column_name       VARCHAR2
         , cv_lookup_type       VARCHAR2 ) IS
         SELECT common_lookup_id AS id
         FROM common_lookup
         WHERE common_lookup_table = cv_table_name AND
               common_lookup_column = cv_column_name AND
               common_lookup_type = cv_lookup_type;



BEGIN
-- Select into to retrieve the correct system user id
  SELECT system_user_id
    INTO lv_system_user
    FROM system_user
    WHERE system_user_name = pv_user_name;
--dbms_output.put_line('System User is: ' || lv_system_user);

-- For Loops:
/*  FOR i IN 1..lv_cursor_data.COUNT LOOP
    FOR x IN c(lv_cursor_data(i).table_name
              , lv_cursor_data(i).column_name
              , lv_cursor_data(i).lookup_type) LOOP
      lv_common_lookup_id.EXTEND;
      lv_common_lookup_id(lv_common_lookup_id.COUNT) := x;
    END LOOP;
  END LOOP;
*/

--member_type
FOR i IN c('MEMBER', 'MEMBER_TYPE', pv_member_type) LOOP
  lv_member_type := i.id;
END LOOP;

--contact_type
FOR i IN c('CONTACT', 'CONTACT_TYPE', pv_contact_type) LOOP
  lv_contact_type := i.id;
END LOOP;

--address_type
FOR i IN c('ADDRESS', 'ADDRESS_TYPE', pv_address_type) LOOP
  lv_address_type := i.id;
END LOOP;

--telephone_type
FOR i IN c('TELEPHONE', 'TELEPHONE_TYPE', pv_telephone_type) LOOP
  lv_telephone_type := i.id;
END LOOP;

--credit_card_type
FOR i IN c('MEMBER', 'CREDIT_CARD_TYPE', pv_credit_card_type) LOOP
  lv_credit_card_type := i.id;
END LOOP;

SAVEPOINT all_or_none;

-- Insert Statements: Start with least dependent
-- Insert into member
INSERT INTO member
VALUES
( member_s1.NEXTVAL
, lv_member_type
, pv_account_number
, pv_credit_card_number
, lv_credit_card_type
, lv_system_user
, lv_date
, lv_system_user
, lv_date);

-- Insert into contact
INSERT INTO contact
VALUES
( contact_s1.NEXTVAL
, member_s1.CURRVAL
, lv_contact_type
, pv_last_name
, pv_first_name
, pv_middle_name
, lv_system_user
, lv_date
, lv_system_user
, lv_date);

-- Insert into address
INSERT INTO address
VALUES
( address_s1.NEXTVAL
, contact_s1.CURRVAL
, lv_address_type
, pv_city
, pv_state_province
, pv_postal_code
, lv_system_user
, lv_date
, lv_system_user
, lv_date);

-- Insert into telephone
INSERT INTO telephone
VALUES
( telephone_s1.NEXTVAL
, contact_s1.CURRVAL
, address_s1.CURRVAL
, lv_telephone_type
, pv_country_code
, pv_area_code
, pv_telephone_number
, lv_system_user
, lv_date
, lv_system_user
, lv_date);

COMMIT;

RETURN 0;

EXCEPTION
  WHEN OTHERS THEN
   RETURN 1;
   dbms_output.put_line('***THERE WAS AN ERROR.  ROLLING BACK.***');
    ROLLBACK TO all_or_none;
END insert_contact;
/

-- ---------------------------------
-- Step 4
-- ---------------------------------
--Create sql object data type
Create OR REPLACE
  TYPE contact_obj IS OBJECT
    ( first_name  VARCHAR2(20)
    , middle_name VARCHAR2(20)
    , last_name   VARCHAR2(20) );
/

-- Create sql list data type
CREATE OR REPLACE
  TYPE contact_tab IS TABLE OF contact_obj;
/

-- Create the get_contact object table function
CREATE OR REPLACE 
FUNCTION get_contact RETURN CONTACT_TAB IS

-- Declare local variables: counter and collection
lv_count INT := 1;
lv_contact_tab CONTACT_TAB := contact_tab();

-- Cursor the get names from contact table
CURSOR c IS
  SELECT first_name, middle_name, last_name
  FROM contact;

BEGIN
  FOR i IN c LOOP
    lv_contact_tab.EXTEND;
    lv_contact_tab(lv_count) := contact_obj (i.first_name, i.middle_name, i.last_name);
    lv_count := lv_count + 1;
  END LOOP;

  RETURN lv_contact_tab;
END;
/

-- Check to ensure procedure/function has not changed
DESC insert_contact;


-- --------------------------------------
-- Step 1 Test Cases:
-- --------------------------------------
-- Call the insert_contact procedure
/* insert_contact ( pv_first_name         =>  'Charles'
               , pv_middle_name        =>  'Francis'
               , pv_last_name          =>  'Xavier'
               , pv_contact_type       =>  'CUSTOMER'
               , pv_account_number     =>  'SLC-000008'
               , pv_member_type        =>  'INDIVIDUAL'
               , pv_credit_card_number =>  '7777-6666-5555-4444'
               , pv_credit_card_type   =>  'DISCOVER_CARD'
               , pv_city               =>  'Milbridge'
               , pv_state_province     =>  'Maine'
               , pv_postal_code        =>  '04658'
               , pv_address_type       =>  'HOME'
               , pv_country_code       =>  '001'
               , pv_area_code          =>  '207'
               , pv_telephone_number   =>  '111-1234'
               , pv_telephone_type     =>  'HOME'
               , pv_user_name          =>  'DBA 2'); */

DECLARE
lv_output NUMBER;

BEGIN
-- Changed to call function after converting from procedure to function
lv_output := insert_contact ( 'Charles'
               , 'Francis'
               , 'Xavier'
               , 'CUSTOMER'
               , 'SLC-000008'
               , 'INDIVIDUAL'
               , '7777-6666-5555-4444'
               , 'DISCOVER_CARD'
               , 'Milbridge'
               , 'Maine'
               , '04658'
               , 'HOME'
               , '001'
               , '207'
               , '111-1234'
               , 'HOME'
               , 'DBA 2');
END;
/


COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14
 
SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Xavier';

-- --------------------------------------------
-- Step 2 Test Cases: 
-- --------------------------------------------
-- Call the insert_contact procedure
/* insert_contact ( pv_first_name         =>  'Maura'
               , pv_middle_name        =>  'Jane'
               , pv_last_name          =>  'Haggerty'
               , pv_contact_type       =>  'CUSTOMER'
               , pv_account_number     =>  'SLC-000009'
               , pv_member_type        =>  'INDIVIDUAL'
               , pv_credit_card_number =>  '8888-7777-6666-5555'
               , pv_credit_card_type   =>  'MASTER_CARD'
               , pv_city               =>  'Bangor'
               , pv_state_province     =>  'Maine'
               , pv_postal_code        =>  '04401'
               , pv_address_type       =>  'HOME'
               , pv_country_code       =>  '001'
               , pv_area_code          =>  '207'
               , pv_telephone_number   =>  '111-1234'
               , pv_telephone_type     =>  'HOME'
               , pv_user_name          =>  'DBA 2'); */
DECLARE
lv_output NUMBER;

BEGIN
lv_output := insert_contact ( 'Maura'
               , 'Jane'
               , 'Haggerty'
               , 'CUSTOMER'
               , 'SLC-000009'
               , 'INDIVIDUAL'
               , '8888-7777-6666-5555'
               , 'MASTER_CARD'
               , 'Bangor'
               , 'Maine'
               , '04401'
               , 'HOME'
               , '001'
               , '207'
               , '111-1234'
               , 'HOME'
               , 'DBA 2');
END;
/

COL full_name      FORMAT A24
COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
COL address        FORMAT A22
COL telephone      FORMAT A14
 
SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Haggerty';
-- --------------------------------------------
-- Step 3 Test Cases: 
-- --------------------------------------------
-- Call the insert_contact function
DECLARE
  lv_output NUMBER;

BEGIN
  lv_output := insert_contact ( 'Harriet'
                              , 'Mary'
                              , 'McDonnell'
                              , 'CUSTOMER'
                              , 'SLC-000010'
                              , 'INDIVIDUAL'
                              , '9999-8888-7777-6666'
                              , 'VISA_CARD'
                              , 'Orono'
                              , 'Maine'
                              , '04469'
                              , 'HOME'
                              , '001'
                              , '207'
                              , '111-1234'
                              , 'HOME'
                              , 'DBA 2');

  IF lv_output = 0 THEN
    dbms_output.put_line('***Insert Contact Successful***');
  ELSE
    dbms_output.put_line('***Insert Contact Unsuccessful***');
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END;
/

    COL full_name      FORMAT A24
    COL account_number FORMAT A10 HEADING "ACCOUNT|NUMBER"
    COL address        FORMAT A22
    COL telephone      FORMAT A14
    SELECT c.first_name
    ||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
           END
    ||     c.last_name AS full_name
    ,      m.account_number
    ,      a.city || ', ' || a.state_province AS address
    ,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
    FROM   member m INNER JOIN contact c
    ON     m.member_id = c.member_id INNER JOIN address a
    ON     c.contact_id = a.contact_id INNER JOIN telephone t
    ON     c.contact_id = t.contact_id
    AND    a.address_id = t.address_id
    WHERE  c.last_name = 'McDonnell';


-- --------------------------------------------
-- Step 4 Test Cases: 
-- --------------------------------------------
SET PAGESIZE 999
COLUMN full_name FORMAT A24
SELECT first_name || CASE
                       WHEN middle_name IS NOT NULL
                       THEN ' ' || middle_name || ' '
                       ELSE ' '
                     END || last_name AS full_name
--, LENGTH(first_name) AS fname_length
--, LENGTH(middle_name) AS mname_length
--, LENGTH(last_name) AS lname_length
FROM   TABLE(get_contact);


-- Display any compilation errors.
LIST
SHOW ERRORS

--close log
SPOOL OFF

--instruct program to exit sqlplus.  comment out if you want to remain inside 
--interactive sqlplus connection
--SPOOL OFF
exit
