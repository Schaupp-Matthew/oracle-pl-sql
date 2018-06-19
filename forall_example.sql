
SPOOL forall_example.txt

CREATE TABLE item_temp
( item_id NUMBER
, item_title VARCHAR2(62)
, item_subtitle VARCHAR2(60));



DECLARE
-- Define a record type.
TYPE item_record IS RECORD
( id NUMBER
, title VARCHAR2(62)
, subtitle VARCHAR2(60));
-- Define a collection based on the record data type.
TYPE item_table IS TABLE OF ITEM_RECORD;
-- Declare a variable of the collection data type.
lv_fulltitle ITEM_TABLE;
-- Declare an explicit cursor.
CURSOR c IS
SELECT item_id AS id
, item_title AS title
, item_subtitle AS subtitle
FROM item;
BEGIN
OPEN c;
LOOP
FETCH c
BULK COLLECT INTO lv_fulltitle LIMIT 10;
EXIT WHEN lv_fulltitle.COUNT = 0;
FORALL i IN lv_fulltitle.FIRST..lv_fulltitle.LAST
INSERT INTO item_temp
VALUES
( lv_fulltitle(i).id
, lv_fulltitle(i).title
, lv_fulltitle(i).subtitle );
/* Print the number of rows inserted per iteration. */
dbms_output.put_line('['||SQL%ROWCOUNT||'] Inserted.');
END LOOP;
END;
/

SPOOL OFF
