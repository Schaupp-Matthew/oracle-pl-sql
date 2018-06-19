/*
        Name: apply_plsql_lab8.sql
        Author:  Matthew Schaupp
        Date: Mar. 1, 2018
        Sources:
*/

--code to call other scripts here
@/home/student/Data/cit325/oracle/lib/cleanup_oracle.sql
@/home/student/Data/cit325/oracle/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

--open log file:
SPOOL apply_plsql_lab8.txt

--add environment to allow PL/SQL to print to console
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

--code here:

BEGIN
        dbms_output.put_line('====================================================');
        dbms_output.put_line('===================== LAB 8 ========================');
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

-- Drop all objects created in this script (running the cleanup script does this)
--DROP PACKAGE insert_contact_package;


-- Create package specification
CREATE OR REPLACE PACKAGE insert_contact_package IS
  PROCEDURE insert_contact
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
  , pv_user_name          VARCHAR2);
  PROCEDURE insert_contact
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
  , pv_user_id            NUMBER := -1);
  FUNCTION insert_contact
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
  , pv_user_name          VARCHAR2) RETURN NUMBER;
  FUNCTION insert_contact
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
  , pv_user_id            NUMBER := -1) RETURN NUMBER;
END insert_contact_package;
/

DESC insert_contact_package

-- Insert two new users and an anonymous user into the system_user table
INSERT INTO system_user
VALUES
( 6
, 'BONDSB'
, 1
, 1
, 'Bonds'
, 'Barry'
, 'L'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO system_user
VALUES
( 7
, 'CURRYW'
, 1
, 1
, 'Curry'
, 'Wardell'
, 'S'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO system_user
VALUES
( -1
, 'ANONYMOUS'
, 1
, 1
, ' '
, ' '
, ' '
, 1
, SYSDATE
, 1
, SYSDATE);

-- ----------------------------------------
-- Test to confirm inserts
-- ----------------------------------------
COL system_user_id  FORMAT 9999  HEADING "System|User ID"
COL system_user_name FORMAT A12  HEADING "System|User Name"
COL first_name       FORMAT A10  HEADING "First|Name"
COL middle_initial   FORMAT A2   HEADING "MI"
COL last_name        FORMAT A10  HeADING "Last|Name"
SELECT system_user_id
,      system_user_name
,      first_name
,      middle_initial
,      last_name
FROM   system_user
WHERE  last_name IN ('Bonds','Curry')
OR     system_user_name = 'ANONYMOUS';

-- ---------------------------------------------------
-- Package Body: Overloaded Procedures and Functions
-- ---------------------------------------------------
CREATE OR REPLACE PACKAGE BODY insert_contact_package IS
PROCEDURE insert_contact            -- Procedure 1
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
  , pv_user_name          VARCHAR2) IS
-- Local variables, cursors, etc.
lv_debug VARCHAR2(30) := 'START';  --Debugging variable
lv_date DATE := SYSDATE;  --Variable for date
lv_system_user NUMBER;  --Variable for system user id
lv_member_type       INT(10);  --Variables for _TYPES
lv_contact_type      INT(10);
lv_address_type      INT(10);
lv_telephone_type    INT(10);
lv_credit_card_type  INT(10);

CURSOR c ( cv_table_name        VARCHAR2  --Dynamic cursor to retrieve the common_lookup_id
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
lv_debug := 'SELECT SYSTEM USER ID';

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
lv_debug := '_TYPE FOR LOOPS';

SAVEPOINT all_or_none;

-- Insert Statements: Start with least dependent
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
lv_debug := 'INSERT INTO MEMBER';

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
lv_debug := 'INSERT INTO CONTACT';

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
lv_debug := 'INSERT INTO ADDRESS';

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
lv_debug := 'INSERT INTO TELEPHONE';

COMMIT;


EXCEPTION
  WHEN OTHERS THEN
   dbms_output.put_line('DEBUG INFO: ' || lv_debug);
   dbms_output.put_line('ERROR IN PROCEDURE 1: ' || SQLERRM);
   ROLLBACK TO all_or_none;
END insert_contact;
PROCEDURE insert_contact            -- Procedure 2: For web interface
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
  , pv_user_id            NUMBER := -1) IS
-- Local variables, cursors, etc.
lv_debug VARCHAR2(30) := 'START';  --Debugging variable
lv_date DATE := SYSDATE;  --Variable for date
lv_member_id NUMBER;  --Variable for finding match in member table from get_member(pv_account_number)
--lv_system_user NUMBER;  --Variable for system user id (replaced by pv_user_id and lv_member_id)
lv_member_type       INT(10);  --Variables for _TYPES
lv_contact_type      INT(10);
lv_address_type      INT(10);
lv_telephone_type    INT(10);
lv_credit_card_type  INT(10);

CURSOR c ( cv_table_name        VARCHAR2  --Dynamic cursor to retrieve the common_lookup_id
         , cv_column_name       VARCHAR2
         , cv_lookup_type       VARCHAR2 ) IS
         SELECT common_lookup_id AS id
         FROM common_lookup
         WHERE common_lookup_table = cv_table_name AND
               common_lookup_column = cv_column_name AND
               common_lookup_type = cv_lookup_type;

CURSOR get_member ( cv_account_number VARCHAR2 ) IS
                  SELECT member_id
                  FROM member
                  WHERE member.account_number = cv_account_number;

BEGIN


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
lv_debug := '_TYPE FOR LOOPS';

SAVEPOINT all_or_none;

-- Open the get_member cursor
OPEN get_member(pv_account_number);
LOOP
FETCH get_member INTO lv_member_id;
EXIT WHEN get_member%NOTFOUND;
-- Insert Statements: Start with least dependent
INSERT INTO member
VALUES
( member_s1.NEXTVAL
, lv_member_type
, pv_account_number
, pv_credit_card_number
, lv_credit_card_type
, pv_user_id
, lv_date
, pv_user_id
, lv_date);
lv_debug := 'INSERT INTO MEMBER';
END LOOP;
CLOSE get_member;

INSERT INTO contact
VALUES
( contact_s1.NEXTVAL
, member_s1.CURRVAL
, lv_contact_type
, pv_last_name
, pv_first_name
, pv_middle_name
, pv_user_id
, lv_date
, pv_user_id
, lv_date);
lv_debug := 'INSERT INTO CONTACT';

INSERT INTO address
VALUES
( address_s1.NEXTVAL
, contact_s1.CURRVAL
, lv_address_type
, pv_city
, pv_state_province
, pv_postal_code
, pv_user_id
, lv_date
, pv_user_id
, lv_date);
lv_debug := 'INSERT INTO ADDRESS';

INSERT INTO telephone
VALUES
( telephone_s1.NEXTVAL
, contact_s1.CURRVAL
, address_s1.CURRVAL
, lv_telephone_type
, pv_country_code
, pv_area_code
, pv_telephone_number
, pv_user_id
, lv_date
, pv_user_id
, lv_date);
lv_debug := 'INSERT INTO TELEPHONE';

COMMIT;


EXCEPTION
  WHEN OTHERS THEN
   dbms_output.put_line('DEBUG INFO: ' || lv_debug);
   dbms_output.put_line('ERROR IN PROCEDURE 2: ' || SQLERRM);
   ROLLBACK TO all_or_none;
END insert_contact;
FUNCTION insert_contact            -- Function 1
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
  , pv_user_name          VARCHAR2) RETURN NUMBER IS
-- Local variables, cursors, etc.
lv_debug VARCHAR2(30) := 'START';  --Debugging variable
lv_date DATE := SYSDATE;  --Variable for date
lv_system_user NUMBER;  --Variable for system user id
lv_member_type       INT(10);  --Variables for _TYPES
lv_contact_type      INT(10);
lv_address_type      INT(10);
lv_telephone_type    INT(10);
lv_credit_card_type  INT(10);

CURSOR c ( cv_table_name        VARCHAR2  --Dynamic cursor to retrieve the common_lookup_id
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
lv_debug := 'SELECT SYSTEM USER ID';

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
lv_debug := '_TYPE FOR LOOPS';

SAVEPOINT all_or_none;

-- Insert Statements: Start with least dependent
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
lv_debug := 'INSERT INTO MEMBER';

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
lv_debug := 'INSERT INTO CONTACT';

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
lv_debug := 'INSERT INTO ADDRESS';

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
lv_debug := 'INSERT INTO TELEPHONE';

COMMIT;
RETURN 0;

EXCEPTION
  WHEN OTHERS THEN
   RETURN 1;
   dbms_output.put_line('DEBUG INFO: ' || lv_debug);
   dbms_output.put_line('ERROR IN PROCEDURE 1: ' || SQLERRM);
   ROLLBACK TO all_or_none;
END insert_contact;
FUNCTION insert_contact            -- Function 2: For web interface
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
  , pv_user_id            NUMBER := -1) RETURN NUMBER IS
-- Local variables, cursors, etc.
lv_debug VARCHAR2(30) := 'START';  --Debugging variable
lv_date DATE := SYSDATE;  --Variable for date
lv_member_id NUMBER;  --Variable for finding match in member table from get_member(pv_account_number)
--lv_system_user NUMBER;  --Variable for system user id (replaced by pv_user_id and lv_member_id)
lv_member_type       INT(10);  --Variables for _TYPES
lv_contact_type      INT(10);
lv_address_type      INT(10);
lv_telephone_type    INT(10);
lv_credit_card_type  INT(10);

CURSOR c ( cv_table_name        VARCHAR2  --Dynamic cursor to retrieve the common_lookup_id
         , cv_column_name       VARCHAR2
         , cv_lookup_type       VARCHAR2 ) IS
         SELECT common_lookup_id AS id
         FROM common_lookup
         WHERE common_lookup_table = cv_table_name AND
               common_lookup_column = cv_column_name AND
               common_lookup_type = cv_lookup_type;

CURSOR get_member ( cv_account_number VARCHAR2 ) IS
                  SELECT member_id
                  FROM member
                  WHERE member.account_number = cv_account_number;

BEGIN


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
lv_debug := '_TYPE FOR LOOPS';

SAVEPOINT all_or_none;

-- Open the get_member cursor
OPEN get_member(pv_account_number);
LOOP
FETCH get_member INTO lv_member_id;
EXIT WHEN get_member%NOTFOUND;
-- Insert Statements: Start with least dependent
INSERT INTO member
VALUES
( member_s1.NEXTVAL
, lv_member_type
, pv_account_number
, pv_credit_card_number
, lv_credit_card_type
, pv_user_id
, lv_date
, pv_user_id
, lv_date);
lv_debug := 'INSERT INTO MEMBER';
END LOOP;
CLOSE get_member;

INSERT INTO contact
VALUES
( contact_s1.NEXTVAL
, member_s1.CURRVAL
, lv_contact_type
, pv_last_name
, pv_first_name
, pv_middle_name
, pv_user_id
, lv_date
, pv_user_id
, lv_date);
lv_debug := 'INSERT INTO CONTACT';

INSERT INTO address
VALUES
( address_s1.NEXTVAL
, contact_s1.CURRVAL
, lv_address_type
, pv_city
, pv_state_province
, pv_postal_code
, pv_user_id
, lv_date
, pv_user_id
, lv_date);
lv_debug := 'INSERT INTO ADDRESS';

INSERT INTO telephone
VALUES
( telephone_s1.NEXTVAL
, contact_s1.CURRVAL
, address_s1.CURRVAL
, lv_telephone_type
, pv_country_code
, pv_area_code
, pv_telephone_number
, pv_user_id
, lv_date
, pv_user_id
, lv_date);
lv_debug := 'INSERT INTO TELEPHONE';

COMMIT;
RETURN 0;

EXCEPTION
  WHEN OTHERS THEN
   RETURN 1;
   dbms_output.put_line('DEBUG INFO: ' || lv_debug);
   dbms_output.put_line('ERROR IN PROCEDURE 2: ' || SQLERRM);
   ROLLBACK TO all_or_none;
END insert_contact;
END insert_contact_package;
/

-- --------------------------------------------
-- TEST CASES:
-- --------------------------------------------

BEGIN
  insert_contact_package.insert_contact (
    pv_first_name         =>  'Charlie'
  , pv_middle_name        =>  NULL
  , pv_last_name          =>  'Brown'
  , pv_contact_type       =>  'CUSTOMER'
  , pv_account_number     =>  'SLC-000011'
  , pv_member_type        =>  'GROUP'
  , pv_credit_card_number =>  '8888-6666-8888-4444'
  , pv_credit_card_type   =>  'VISA_CARD'
  , pv_city               =>  'Lehi'
  , pv_state_province     =>  'Utah'
  , pv_postal_code        =>  '84043'
  , pv_address_type       =>  'HOME'
  , pv_country_code       =>  '001'
  , pv_area_code          =>  '207'
  , pv_telephone_number   =>  '887-4321'
  , pv_telephone_type     =>  'HOME'
  , pv_user_name          =>  'DBA 3');  

  insert_contact_package.insert_contact (
    pv_first_name         =>  'Peppermint'
  , pv_middle_name        =>  NULL
  , pv_last_name          =>  'Patty'
  , pv_contact_type       =>  'CUSTOMER'
  , pv_account_number     =>  'SLC-000011'
  , pv_member_type        =>  'GROUP'
  , pv_credit_card_number =>  '8888-6666-8888-4444'
  , pv_credit_card_type   =>  'VISA_CARD'
  , pv_city               =>  'Lehi'
  , pv_state_province     =>  'Utah'
  , pv_postal_code        =>  '84043'
  , pv_address_type       =>  'HOME'
  , pv_country_code       =>  '001'
  , pv_area_code          =>  '207'
  , pv_telephone_number   =>  '887-4321'
  , pv_telephone_type     =>  'HOME');  

  insert_contact_package.insert_contact (
    pv_first_name         =>  'Sally'
  , pv_middle_name        =>  NULL
  , pv_last_name          =>  'Brown'
  , pv_contact_type       =>  'CUSTOMER'
  , pv_account_number     =>  'SLC-000011'
  , pv_member_type        =>  'GROUP'
  , pv_credit_card_number =>  '8888-6666-8888-4444'
  , pv_credit_card_type   =>  'VISA_CARD'
  , pv_city               =>  'Lehi'
  , pv_state_province     =>  'Utah'
  , pv_postal_code        =>  '84043'
  , pv_address_type       =>  'HOME'
  , pv_country_code       =>  '001'
  , pv_area_code          =>  '207'
  , pv_telephone_number   =>  '887-4321'
  , pv_telephone_type     =>  'HOME'
  , pv_user_id            =>  6);  
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
WHERE  c.last_name IN ('Brown','Patty');

BEGIN
  IF insert_contact_package.insert_contact (
      'Shirley'
    , NULL
    , 'Partridge'
    , 'CUSTOMER'
    , 'SLC-000012'
    , 'GROUP'
    , '8888-6666-8888-4444'
    , 'VISA_CARD'
    , 'Lehi'
    , 'Utah'
    , '84043'
    , 'HOME'
    , '001'
    , '207'
    , '887-4321'
    , 'HOME'
    , 'DBA 3') = 0 THEN
          dbms_output.put_line('Insert function succeeded!');
  END IF;
END;
/

BEGIN
  IF insert_contact_package.insert_contact (
      'Keith'
    , NULL
    , 'Partridge'
    , 'CUSTOMER'
    , 'SLC-000012'
    , 'GROUP'
    , '8888-6666-8888-4444'
    , 'VISA_CARD'
    , 'Lehi'
    , 'Utah'
    , '84043'
    , 'HOME'
    , '001'
    , '207'
    , '887-4321'
    , 'HOME'
    , 6) = 0 THEN
          dbms_output.put_line('Insert function succeeded!');
  END IF;
END;
/

BEGIN
  IF insert_contact_package.insert_contact (
      'Laurie'
    , NULL
    , 'Partridge'
    , 'CUSTOMER'
    , 'SLC-000012'
    , 'GROUP'
    , '8888-6666-8888-4444'
    , 'VISA_CARD'
    , 'Lehi'
    , 'Utah'
    , '84043'
    , 'HOME'
    , '001'
    , '207'
    , '887-4321'
    , 'HOME'
    , -1) = 0 THEN
          dbms_output.put_line('Insert function succeeded!');
  END IF;
END;
/

COL full_name      FORMAT A18   HEADING "Full Name"
COL created_by     FORMAT 9999  HEADING "System|User ID"
COL account_number FORMAT A12   HEADING "Account|Number"
COL address        FORMAT A16   HEADING "Address"
COL telephone      FORMAT A16   HEADING "Telephone"
SELECT c.first_name
||     CASE
         WHEN c.middle_name IS NOT NULL THEN ' '||c.middle_name||' ' ELSE ' '
       END
||     c.last_name AS full_name
,      c.created_by 
,      m.account_number
,      a.city || ', ' || a.state_province AS address
,      '(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM   member m INNER JOIN contact c
ON     m.member_id = c.member_id INNER JOIN address a
ON     c.contact_id = a.contact_id INNER JOIN telephone t
ON     c.contact_id = t.contact_id
AND    a.address_id = t.address_id
WHERE  c.last_name = 'Partridge';


-- Display any compilation errors.
--LIST
SHOW ERRORS

--close log
SPOOL OFF

--instruct program to exit sqlplus.  comment out if you want to remain inside 
--interactive sqlplus connection
--SPOOL OFF
exit
