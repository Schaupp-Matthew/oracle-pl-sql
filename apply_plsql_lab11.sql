/*
        Name: apply_plsql_lab11.sql
        Author:  Matthew Schaupp
        Date: Mar. 19, 2018
        Sources:
*/

--code to call other scripts here
@/home/student/Data/cit325/oracle/lib/cleanup_oracle.sql
@/home/student/Data/cit325/oracle/lib/Oracle12cPLSQLCode/Introduction/create_video_store.sql

--open log file:
SPOOL apply_plsql_lab11.txt

--add environment to allow PL/SQL to print to console
SET SERVEROUTPUT ON SIZE UNLIMITED
SET VERIFY OFF

--code here:

BEGIN
        dbms_output.put_line('====================================================');
        dbms_output.put_line('===================== LAB 11 =======================');
        dbms_output.put_line('====================================================');
END;
/

-- Drop structures:
-- ----------------------------------
--DROP TABLE logger;
--DROP SEQUENCE logger_s;

-- Add column to item table and test to ensure added properly:
-- ------------------------------------------------------------
ALTER TABLE item
ADD (text_file_name  VARCHAR2(40));

COLUMN table_name   FORMAT A14
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

-- First, you create a logger table and logger_s sequence:
-- ------------------------------------------------------------

-- Verify item table definition:
desc item

-- logger_s sequence:
-- ------------------
CREATE SEQUENCE logger_s;

-- logger table:
CREATE TABLE logger
( logger_id		        NUMBER  CONSTRAINT pk_logger_1 PRIMARY KEY
, old_item_id			NUMBER
, old_item_barcode		VARCHAR2(20)
, old_item_type			NUMBER
, old_item_title 		VARCHAR2(60)
, old_item_subtitle		VARCHAR2(60)
, old_item_rating		VARCHAR2(8)
, old_item_rating_agency 	VARCHAR2(4)
, old_item_release_date		DATE
, old_created_by 		NUMBER
, old_creation_date		DATE
, old_last_updated_by		NUMBER
, old_last_update_date		DATE
, old_text_file_name		VARCHAR2(40)
, new_item_id			NUMBER
, new_item_barcode		VARCHAR2(20)
, new_item_type			NUMBER
, new_item_title 		VARCHAR2(60)
, new_item_subtitle		VARCHAR2(60)
, new_item_rating		VARCHAR2(8)
, new_item_rating_agency 	VARCHAR2(4)
, new_item_release_date		DATE
, new_created_by 		NUMBER
, new_creation_date		DATE
, new_last_updated_by		NUMBER
, new_last_update_date		DATE
, new_text_file_name		VARCHAR2(40));


-- Verify logger table definition:
desc logger

-- Step 1 Test Case:
-- ---------------------
DECLARE
  /* Dynamic cursor. */
  CURSOR get_row IS
    SELECT * FROM item WHERE item_title = 'Brave Heart';
BEGIN
  /* Read the dynamic cursor. */
  FOR i IN get_row LOOP
 
    INSERT INTO logger
	VALUES
	( logger_s.NEXTVAL
	, i.item_id
	, i.item_barcode
	, i.item_type
	, i.item_title
	, i.item_subtitle
	, i.item_rating
	, i.item_rating_agency
	, i.item_release_date
	, i.created_by
	, i.creation_date
	, i.last_updated_by
	, i.last_update_date
	, i.text_file_name
	, i.item_id
	, i.item_barcode
	, i.item_type
	, i.item_title
	, i.item_subtitle
	, i.item_rating
	, i.item_rating_agency
	, i.item_release_date
	, i.created_by
	, i.creation_date
	, i.last_updated_by
	, i.last_update_date
	, i.text_file_name );
 
  END LOOP;
END;
/

/* Query the logger table. */
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 9999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 9999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

-- Second, you create overloaded insert_item autonomous procedures in the manage_item package:
-- --------------------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE manage_item IS
PROCEDURE item_insert                       -- INSERT PROCEDURE
( pv_new_item_id                NUMBER
, pv_new_item_barcode           VARCHAR2
, pv_new_item_type              NUMBER
, pv_new_item_title             VARCHAR2
, pv_new_item_subtitle          VARCHAR2
, pv_new_item_rating            VARCHAR2
, pv_new_item_rating_agency     VARCHAR2
, pv_new_item_release_date      DATE
, pv_new_created_by             NUMBER
, pv_new_creation_date          DATE
, pv_new_last_updated_by        NUMBER
, pv_new_last_update_date       DATE
, pv_new_text_file_name         VARCHAR2);
PROCEDURE item_insert                           -- UPDATE PROCEDURE
( pv_old_item_id 		NUMBER			
, pv_old_item_barcode		VARCHAR2		
, pv_old_item_type		NUMBER			
, pv_old_item_title		VARCHAR2		
, pv_old_item_subtitle		VARCHAR2		
, pv_old_item_rating		VARCHAR2		
, pv_old_item_rating_agency	VARCHAR2		
, pv_old_item_release_date	DATE			
, pv_old_created_by		NUMBER			
, pv_old_creation_date		DATE			
, pv_old_last_updated_by 	NUMBER			
, pv_old_last_update_date	DATE			
, pv_old_text_file_name		VARCHAR2		
, pv_new_item_id 		NUMBER			
, pv_new_item_barcode		VARCHAR2		
, pv_new_item_type		NUMBER			
, pv_new_item_title		VARCHAR2		
, pv_new_item_subtitle		VARCHAR2		
, pv_new_item_rating		VARCHAR2		
, pv_new_item_rating_agency	VARCHAR2		
, pv_new_item_release_date	DATE			
, pv_new_created_by		NUMBER			
, pv_new_creation_date		DATE			
, pv_new_last_updated_by 	NUMBER			
, pv_new_last_update_date	DATE			
, pv_new_text_file_name		VARCHAR2 );
PROCEDURE item_insert                           -- DELETE PROCEDURE
( pv_old_item_id 		NUMBER			
, pv_old_item_barcode		VARCHAR2		
, pv_old_item_type		NUMBER			
, pv_old_item_title		VARCHAR2		
, pv_old_item_subtitle		VARCHAR2		
, pv_old_item_rating		VARCHAR2		
, pv_old_item_rating_agency	VARCHAR2		
, pv_old_item_release_date	DATE			
, pv_old_created_by		NUMBER			
, pv_old_creation_date		DATE			
, pv_old_last_updated_by 	NUMBER			
, pv_old_last_update_date	DATE			
, pv_old_text_file_name		VARCHAR2 );
END manage_item;
/

desc manage_item

CREATE OR REPLACE PACKAGE BODY manage_item IS
PROCEDURE item_insert                       -- INSERT PROCEDURE
( pv_new_item_id                NUMBER
, pv_new_item_barcode           VARCHAR2
, pv_new_item_type              NUMBER
, pv_new_item_title             VARCHAR2
, pv_new_item_subtitle          VARCHAR2
, pv_new_item_rating            VARCHAR2
, pv_new_item_rating_agency     VARCHAR2
, pv_new_item_release_date      DATE
, pv_new_created_by             NUMBER
, pv_new_creation_date          DATE
, pv_new_last_updated_by        NUMBER
, pv_new_last_update_date       DATE
, pv_new_text_file_name         VARCHAR2) IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  manage_item.item_insert(
          pv_old_item_id                =>  NULL 					
        , pv_old_item_barcode		=>  NULL		
        , pv_old_item_type		=>  NULL			
        , pv_old_item_title		=>  ' '		
        , pv_old_item_subtitle		=>  ' '		
        , pv_old_item_rating		=>  NULL		
        , pv_old_item_rating_agency	=>  NULL		
        , pv_old_item_release_date      =>  NULL
        , pv_old_created_by	        =>  NULL				
        , pv_old_creation_date	        =>  NULL				
        , pv_old_last_updated_by        =>  NULL				
        , pv_old_last_update_date       =>  NULL				
        , pv_old_text_file_name	        =>  NULL			
        , pv_new_item_id 	        =>  pv_new_item_id				
        , pv_new_item_barcode	        =>  pv_new_item_barcode			
        , pv_new_item_type	        =>  pv_new_item_type				
        , pv_new_item_title		=>  pv_new_item_title		
        , pv_new_item_subtitle		=>  pv_new_item_subtitle		
        , pv_new_item_rating		=>  pv_new_item_rating		
        , pv_new_item_rating_agency	=>  pv_new_item_rating_agency		
        , pv_new_item_release_date	=>  pv_new_item_release_date			
        , pv_new_created_by		=>  pv_new_created_by			
        , pv_new_creation_date		=>  pv_new_creation_date			
        , pv_new_last_updated_by 	=>  pv_new_last_updated_by			
        , pv_new_last_update_date	=>  pv_new_last_update_date			
        , pv_new_text_file_name         =>  pv_new_text_file_name );
EXCEPTION
  WHEN OTHERS THEN
   dbms_output.put_line(SQLERRM);
   dbms_output.put_line('***THERE WAS AN ERROR IN THE INSERT PROCEDURE!***');
   RETURN;
END item_insert;

PROCEDURE item_insert                           -- UPDATE PROCEDURE
( pv_old_item_id 		NUMBER			
, pv_old_item_barcode		VARCHAR2		
, pv_old_item_type		NUMBER			
, pv_old_item_title		VARCHAR2		
, pv_old_item_subtitle		VARCHAR2		
, pv_old_item_rating		VARCHAR2		
, pv_old_item_rating_agency	VARCHAR2		
, pv_old_item_release_date	DATE			
, pv_old_created_by		NUMBER			
, pv_old_creation_date		DATE			
, pv_old_last_updated_by 	NUMBER			
, pv_old_last_update_date	DATE			
, pv_old_text_file_name		VARCHAR2		
, pv_new_item_id 		NUMBER			
, pv_new_item_barcode		VARCHAR2		
, pv_new_item_type		NUMBER			
, pv_new_item_title		VARCHAR2		
, pv_new_item_subtitle		VARCHAR2		
, pv_new_item_rating		VARCHAR2		
, pv_new_item_rating_agency	VARCHAR2		
, pv_new_item_release_date	DATE			
, pv_new_created_by		NUMBER			
, pv_new_creation_date		DATE			
, pv_new_last_updated_by 	NUMBER			
, pv_new_last_update_date	DATE			
, pv_new_text_file_name		VARCHAR2 ) IS

PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
  SAVEPOINT starting;
  INSERT INTO logger
	VALUES
	( logger_s.NEXTVAL
	, pv_old_item_id 					
        , pv_old_item_barcode				
        , pv_old_item_type					
        , pv_old_item_title				
        , pv_old_item_subtitle				
        , pv_old_item_rating				
        , pv_old_item_rating_agency			
        , pv_old_item_release_date
        , pv_old_created_by					
        , pv_old_creation_date					
        , pv_old_last_updated_by 				
        , pv_old_last_update_date				
        , pv_old_text_file_name				
        , pv_new_item_id 					
        , pv_new_item_barcode				
        , pv_new_item_type					
        , pv_new_item_title				
        , pv_new_item_subtitle				
        , pv_new_item_rating				
        , pv_new_item_rating_agency			
        , pv_new_item_release_date				
        , pv_new_created_by					
        , pv_new_creation_date					
        , pv_new_last_updated_by 				
        , pv_new_last_update_date				
        , pv_new_text_file_name );
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN
   dbms_output.put_line(SQLERRM);
   dbms_output.put_line('***THERE WAS AN ERROR IN THE UPDATE PROCEDURE!***');
   ROLLBACK TO starting;
   RETURN;
END item_insert;

PROCEDURE item_insert                           -- DELETE PROCEDURE
( pv_old_item_id 		NUMBER			
, pv_old_item_barcode		VARCHAR2		
, pv_old_item_type		NUMBER			
, pv_old_item_title		VARCHAR2		
, pv_old_item_subtitle		VARCHAR2		
, pv_old_item_rating		VARCHAR2		
, pv_old_item_rating_agency	VARCHAR2		
, pv_old_item_release_date	DATE			
, pv_old_created_by		NUMBER			
, pv_old_creation_date		DATE			
, pv_old_last_updated_by 	NUMBER			
, pv_old_last_update_date	DATE			
, pv_old_text_file_name		VARCHAR2 ) IS
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  manage_item.item_insert(
          pv_old_item_id                =>  pv_old_item_id 					
        , pv_old_item_barcode		=>  pv_old_item_barcode		
        , pv_old_item_type		=>  pv_old_item_type			
        , pv_old_item_title		=>  pv_old_item_title		
        , pv_old_item_subtitle		=>  pv_old_item_subtitle		
        , pv_old_item_rating		=>  pv_old_item_rating		
        , pv_old_item_rating_agency	=>  pv_old_item_rating_agency		
        , pv_old_item_release_date      =>  pv_old_item_release_date
        , pv_old_created_by	        =>  pv_old_created_by				
        , pv_old_creation_date	        =>  pv_old_creation_date				
        , pv_old_last_updated_by        =>  pv_old_last_updated_by				
        , pv_old_last_update_date       =>  pv_old_last_update_date				
        , pv_old_text_file_name	        =>  pv_old_text_file_name			
        , pv_new_item_id 	        =>  NULL				
        , pv_new_item_barcode	        =>  NULL			
        , pv_new_item_type	        =>  NULL				
        , pv_new_item_title		=>  ' '		
        , pv_new_item_subtitle		=>  ' '		
        , pv_new_item_rating		=>  NULL		
        , pv_new_item_rating_agency	=>  NULL		
        , pv_new_item_release_date	=>  NULL			
        , pv_new_created_by		=>  NULL			
        , pv_new_creation_date		=>  NULL			
        , pv_new_last_updated_by 	=>  NULL			
        , pv_new_last_update_date	=>  NULL			
        , pv_new_text_file_name         =>  NULL );
EXCEPTION
  WHEN OTHERS THEN
   dbms_output.put_line(SQLERRM);
   dbms_output.put_line('***THERE WAS AN ERROR IN THE DELETE PROCEDURE!***');
   RETURN;
END item_insert;
END manage_item;
/

-- Test Cases:
-- -----------------------------------------------------------------------------------------------
-- UPDATE test:
DECLARE
  /* Dynamic cursor. */
  CURSOR get_row IS
    SELECT * FROM item WHERE item_title = 'King Arthur';
BEGIN
  /* Read the dynamic cursor. */
  FOR i IN get_row LOOP
 
    manage_item.item_insert(
          pv_old_item_id                =>  i.item_id 					
        , pv_old_item_barcode		=>  i.item_barcode		
        , pv_old_item_type		=>  i.item_type			
        , pv_old_item_title		=>  i.item_title		
        , pv_old_item_subtitle		=>  i.item_subtitle		
        , pv_old_item_rating		=>  i.item_rating		
        , pv_old_item_rating_agency	=>  i.item_rating_agency		
        , pv_old_item_release_date      =>  i.item_release_date
        , pv_old_created_by	        =>  i.created_by				
        , pv_old_creation_date	        =>  i.creation_date				
        , pv_old_last_updated_by        =>  i.last_updated_by				
        , pv_old_last_update_date       =>  i.last_update_date				
        , pv_old_text_file_name	        =>  i.text_file_name			
        , pv_new_item_id 	        =>  i.item_id				
        , pv_new_item_barcode	        =>  i.item_barcode			
        , pv_new_item_type	        =>  i.item_type				
        , pv_new_item_title		=>  i.item_title || '-Changed'		
        , pv_new_item_subtitle		=>  i.item_subtitle		
        , pv_new_item_rating		=>  i.item_rating		
        , pv_new_item_rating_agency	=>  i.item_rating_agency		
        , pv_new_item_release_date	=>  i.item_release_date			
        , pv_new_created_by		=>  i.created_by			
        , pv_new_creation_date		=>  i.creation_date			
        , pv_new_last_updated_by 	=>  i.last_updated_by			
        , pv_new_last_update_date	=>  i.last_update_date			
        , pv_new_text_file_name         =>  i.text_file_name );
  END LOOP;
END;
/

-- INSERT test:
DECLARE
  /* Dynamic cursor. */
  CURSOR get_row IS
    SELECT * FROM item WHERE item_title = 'King Arthur';
BEGIN
  /* Read the dynamic cursor. */
  FOR i IN get_row LOOP
 
    manage_item.item_insert(			
          pv_new_item_id 	        =>  i.item_id				
        , pv_new_item_barcode	        =>  i.item_barcode			
        , pv_new_item_type	        =>  i.item_type				
        , pv_new_item_title		=>  i.item_title || '-Inserted'		
        , pv_new_item_subtitle		=>  i.item_subtitle		
        , pv_new_item_rating		=>  i.item_rating		
        , pv_new_item_rating_agency	=>  i.item_rating_agency		
        , pv_new_item_release_date	=>  i.item_release_date			
        , pv_new_created_by		=>  i.created_by			
        , pv_new_creation_date		=>  i.creation_date			
        , pv_new_last_updated_by 	=>  i.last_updated_by			
        , pv_new_last_update_date	=>  i.last_update_date			
        , pv_new_text_file_name         =>  i.text_file_name );
 
  END LOOP;
END;
/

--DELETE test:
DECLARE
  /* Dynamic cursor. */
  CURSOR get_row IS
    SELECT * FROM item WHERE item_title = 'King Arthur';
BEGIN
  /* Read the dynamic cursor. */
  FOR i IN get_row LOOP
 
    manage_item.item_insert(
          pv_old_item_id                =>  i.item_id 					
        , pv_old_item_barcode		=>  i.item_barcode		
        , pv_old_item_type		=>  i.item_type			
        , pv_old_item_title		=>  i.item_title || '-Deleted'		
        , pv_old_item_subtitle		=>  i.item_subtitle		
        , pv_old_item_rating		=>  i.item_rating		
        , pv_old_item_rating_agency	=>  i.item_rating_agency		
        , pv_old_item_release_date      =>  i.item_release_date
        , pv_old_created_by	        =>  i.created_by				
        , pv_old_creation_date	        =>  i.creation_date				
        , pv_old_last_updated_by        =>  i.last_updated_by				
        , pv_old_last_update_date       =>  i.last_update_date				
        , pv_old_text_file_name	        =>  i.text_file_name );
 
  END LOOP;
END;
/

/* Query the logger table. */
/* Query the logger table. */
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 99999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 99999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

-- Third, you create an item_trig trigger that manages INSERT, UPDATE, and DELETE statement 
-- events against the item table; and the overloaded insert_item autonomous procedure process 
-- or reject events while writing (or logging) both the new_ and old_ column values to the logger table:
-- ------------------------------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER item_trig
  BEFORE INSERT OR UPDATE ON item
  FOR EACH ROW
  WHEN (REGEXP_LIKE(new.item_title,':'))
DECLARE
    e EXCEPTION;
    PRAGMA EXCEPTION_INIT(e,-20001);
BEGIN
    IF INSERTING THEN
      manage_item.item_insert(			
          pv_new_item_id                =>  :NEW.item_id
        , pv_new_item_barcode           =>  :NEW.item_barcode
        , pv_new_item_type              =>  :NEW.item_type
        , pv_new_item_title             =>  :NEW.item_title
        , pv_new_item_subtitle          =>  :NEW.item_subtitle
        , pv_new_item_rating            =>  :NEW.item_rating
        , pv_new_item_rating_agency     =>  :NEW.item_rating_agency
        , pv_new_item_release_date      =>  :NEW.item_release_date
        , pv_new_created_by             =>  :NEW.created_by
        , pv_new_creation_date          =>  :NEW.creation_date
        , pv_new_last_updated_by        =>  :NEW.last_updated_by
        , pv_new_last_update_date       =>  :NEW.last_update_date
        , pv_new_text_file_name         =>  :NEW.text_file_name );

/* Check for a subtitle following the colon:
          - Colon is the last element of string, shave off the colon.
          - Colon is not the last element of string, parse into two substrings. */

      IF REGEXP_INSTR(:new.item_title,':') = LENGTH(:new.item_title) THEN
        :new.item_title := SUBSTR(:new.item_title, 1, REGEXP_INSTR(:new.item_title,':') - 1);
      ELSIF REGEXP_INSTR(:new.item_title,':') < LENGTH(:new.item_title) THEN
        :new.item_subtitle := LTRIM(
            SUBSTR(:new.item_title
          , REGEXP_INSTR(:new.item_title,':') + 1
          , LENGTH(:new.item_title) - REGEXP_INSTR(:new.item_title,':')));
        :new.item_title := SUBSTR(:new.item_title, 1, REGEXP_INSTR(:new.item_title,':') - 1);
      END IF;

      
    ELSIF UPDATING THEN
      manage_item.item_insert(
          pv_old_item_id                =>  :OLD.item_id
        , pv_old_item_barcode		=>  :OLD.item_barcode
        , pv_old_item_type		=>  :OLD.item_type
        , pv_old_item_title		=>  :OLD.item_title
        , pv_old_item_subtitle		=>  :OLD.item_subtitle
        , pv_old_item_rating		=>  :OLD.item_rating
        , pv_old_item_rating_agency	=>  :OLD.item_rating_agency
        , pv_old_item_release_date      =>  :OLD.item_release_date
        , pv_old_created_by	        =>  :OLD.created_by
        , pv_old_creation_date	        =>  :OLD.creation_date
        , pv_old_last_updated_by        =>  :OLD.last_updated_by
        , pv_old_last_update_date       =>  :OLD.last_update_date
        , pv_old_text_file_name	        =>  :OLD.text_file_name
        , pv_new_item_id 	        =>  :NEW.item_id
        , pv_new_item_barcode	        =>  :NEW.item_barcode
        , pv_new_item_type	        =>  :NEW.item_type
        , pv_new_item_title		=>  :NEW.item_title
        , pv_new_item_subtitle		=>  :NEW.item_subtitle
        , pv_new_item_rating		=>  :NEW.item_rating
        , pv_new_item_rating_agency	=>  :NEW.item_rating_agency
        , pv_new_item_release_date	=>  :NEW.item_release_date
        , pv_new_created_by		=>  :NEW.created_by
        , pv_new_creation_date		=>  :NEW.creation_date
        , pv_new_last_updated_by 	=>  :NEW.last_updated_by
        , pv_new_last_update_date	=>  :NEW.last_update_date			
        , pv_new_text_file_name         =>  :NEW.text_file_name );
--      IF REGEXP_LIKE(:NEW.item_title,':') THEN
        RAISE_APPLICATION_ERROR(-20001, '***NO COLONS ALLOWED IN ITEM TITLE***');
--      END IF;

    END IF;
EXCEPTION
  WHEN e THEN
    dbms_output.put_line(SQLERRM);
    dbms_output.put_line('***ROLLBACK UPDATE***');
    ROLLBACK;
  WHEN OTHERS THEN
    dbms_output.put_line(SQLERRM);
END item_trig;
/

--LIST
--SHOW ERRORS

CREATE OR REPLACE TRIGGER item_delete_trig
  BEFORE DELETE ON item
  FOR EACH ROW
/*DECLARE
    e EXCEPTION;
    PRAGMA EXCEPTION_INIT(e,-20001);*/
BEGIN
    IF DELETING THEN
      manage_item.item_insert(
          pv_old_item_id                =>  :OLD.item_id 					
        , pv_old_item_barcode		=>  :OLD.item_barcode		
        , pv_old_item_type		=>  :OLD.item_type			
        , pv_old_item_title		=>  :OLD.item_title		
        , pv_old_item_subtitle		=>  :OLD.item_subtitle		
        , pv_old_item_rating		=>  :OLD.item_rating		
        , pv_old_item_rating_agency	=>  :OLD.item_rating_agency		
        , pv_old_item_release_date      =>  :OLD.item_release_date
        , pv_old_created_by	        =>  :OLD.created_by				
        , pv_old_creation_date	        =>  :OLD.creation_date				
        , pv_old_last_updated_by        =>  :OLD.last_updated_by				
        , pv_old_last_update_date       =>  :OLD.last_update_date				
        , pv_old_text_file_name	        =>  :OLD.text_file_name );

    END IF;
END item_delete_trig;
/

--LIST
--SHOW ERRORS

ALTER TABLE item
DROP CONSTRAINT fk_item_1;

ALTER TABLE item
ADD CONSTRAINT fk_item_1 
FOREIGN KEY (item_type) REFERENCES common_lookup (common_lookup_id) 
ON DELETE CASCADE;

COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_type      FORMAT 9999 HEADING "Item|Type"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_type
,      i.item_rating
FROM   item i
WHERE  i.item_title = 'Star Wars';

DELETE FROM common_lookup
WHERE common_lookup_table = 'ITEM'
AND common_lookup_column = 'ITEM_TYPE'
AND common_lookup_type = 'BLU-RAY';

COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_type      FORMAT 9999 HEADING "Item|Type"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_type
,      i.item_rating
FROM   item i
WHERE  i.item_title = 'Star Wars';

ALTER TABLE item
DROP CONSTRAINT fk_item_1;

ALTER TABLE item
ADD CONSTRAINT fk_item_1 
FOREIGN KEY (item_type) REFERENCES common_lookup (common_lookup_id);

INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, 'ITEM'
, 'ITEM_TYPE'
, 'BLU-RAY'
, NULL
, 'Blu-ray'
, 3
, SYSDATE
, 3
, SYSDATE);

COL common_lookup_table   FORMAT A14 HEADING "Common Lookup|Table"
COL common_lookup_column  FORMAT A14 HEADING "Common Lookup|Column"
COL common_lookup_type    FORMAT A14 HEADING "Common Lookup|Type"
SELECT common_lookup_table
,      common_lookup_column
,      common_lookup_type
FROM   common_lookup
WHERE  common_lookup_table = 'ITEM'
AND    common_lookup_column = 'ITEM_TYPE'
AND    common_lookup_type = 'BLU-RAY';

INSERT INTO item
VALUES
( item_s1.NEXTVAL
, 'B01IHVPA8'
, (SELECT common_lookup_id FROM common_lookup WHERE common_lookup_type = 'BLU-RAY')
, 'Bourne'
, ' '
, 'CLOB'
, NULL
, 'PG-13'
, 'MPAA'
, '06-DEC-2016'
, 3
, SYSDATE
, 3
, SYSDATE
, 'TEXT_FILE_NAME');

INSERT INTO item
VALUES
( item_s1.NEXTVAL
, 'B01AT251XY'
, (SELECT common_lookup_id FROM common_lookup WHERE common_lookup_type = 'BLU-RAY')
, 'Bourne Legacy:'
, ' '
, 'CLOB'
, NULL
, 'PG-13'
, 'MPAA'
, '05-APR-2016'
, 3
, SYSDATE
, 3
, SYSDATE
, 'TEXT_FILE_NAME');

INSERT INTO item
VALUES
( item_s1.NEXTVAL
, 'B018FK66TU'
, (SELECT common_lookup_id FROM common_lookup WHERE common_lookup_type = 'BLU-RAY')
, 'Star Wars: The Force Awakens'
, ' '
, 'CLOB'
, NULL
, 'PG-13'
, 'MPAA'
, '05-APR-2016'
, 3
, SYSDATE
, 3
, SYSDATE
, 'TEXT_FILE_NAME');

COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
COL item_type      FORMAT A18   HEADING "Item|Type"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_rating
,      cl.common_lookup_meaning AS item_type
FROM   item i INNER JOIN common_lookup cl
ON     i.item_type = cl.common_lookup_id
WHERE  cl.common_lookup_type = 'BLU-RAY';

/* Query the logger table. */
COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 999999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 999999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;
/*
UPDATE item
SET item_title = 'Star Wars: The Force Awakens'
WHERE item_barcode = 'B018FK66TU';
*/

UPDATE item
SET item_title = 'Star Wars: The Force Awakens'
, item_subtitle = ' '
WHERE item_title = 'Star Wars'
AND item_subtitle = 'The Force Awakens';

COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
COL item_type      FORMAT A18   HEADING "Item|Type"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_rating
,      cl.common_lookup_meaning AS item_type
FROM   item i INNER JOIN common_lookup cl
ON     i.item_type = cl.common_lookup_id
WHERE  cl.common_lookup_type = 'BLU-RAY';

COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 999999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 999999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;

DELETE FROM item
WHERE item_barcode = 'B018FK66TU';

COL item_id        FORMAT 9999 HEADING "Item|ID #"
COL item_title     FORMAT A20  HEADING "Item Title"
COL item_subtitle  FORMAT A20  HEADING "Item Subtitle"
COL item_rating    FORMAT A6   HEADING "Item|Rating"
COL item_type      FORMAT A18   HEADING "Item|Type"
SELECT i.item_id
,      i.item_title
,      i.item_subtitle
,      i.item_rating
,      cl.common_lookup_meaning AS item_type
FROM   item i INNER JOIN common_lookup cl
ON     i.item_type = cl.common_lookup_id
WHERE  cl.common_lookup_type = 'BLU-RAY';

COL logger_id       FORMAT 9999 HEADING "Logger|ID #"
COL old_item_id     FORMAT 999999 HEADING "Old|Item|ID #"
COL old_item_title  FORMAT A20  HEADING "Old Item Title"
COL new_item_id     FORMAT 999999 HEADING "New|Item|ID #"
COL new_item_title  FORMAT A30  HEADING "New Item Title"
SELECT l.logger_id
,      l.old_item_id
,      l.old_item_title
,      l.new_item_id
,      l.new_item_title
FROM   logger l;



-- Display any compilation errors.
LIST
SHOW ERRORS

--close log
SPOOL OFF

--instruct program to exit sqlplus.  comment out if you want to remain inside 
--interactive sqlplus connection
--SPOOL OFF
exit
