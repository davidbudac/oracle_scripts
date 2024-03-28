set arraysize 200
set pages 0
set markup csv on
set termout off
set feedback off
spool test.csv

select * from dba_tables;

spool off
set termout on
set feedback on
set markup csv off
