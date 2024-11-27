select
    segments_data.*
from
(
    select /* SEGMENTS */ 
        to_char(sysdate, 'yyyymmddhh24miss') snapshot_time_id,
        sysdate snapshot_timestamp,
        dba_segments.owner segment_owner, 
        dba_segments.segment_name segment_name,
        dba_segments.segment_type segment_type,
        dba_segments.tablespace_name tablespace_name,
        dba_segments.partition_name partition_name,
        v$database.dbid DBID,
        v$database.name database_name,
        dba_lobs.column_name lob_column_name,
        dba_segments.bytes segment_size_b,
        round(dba_segments.bytes /1024/1024/1024 ,2) segment_size_gb,
        case 
        when dba_segments.segment_type in ( 'TABLE', 'TABLE PARTITION','TABLE SUBPARTITION')
        then
            dba_segments.segment_name
        else
            coalesce (dba_lobs.table_name, dba_indexes.table_name )
        end as table_name
    from 
        dba_segments,
        v$database,
        dba_lobs,
        dba_indexes
    where 
            1=1
        and dba_segments.segment_name = dba_indexes.index_name (+)
        and dba_segments.segment_name = dba_lobs.segment_name (+)
    union all
    select /* FREE SPACE per TABLESPACE */
        to_char(sysdate, 'yyyymmddhh24miss') snapshot_time_id,
        sysdate snapshot_timestamp,
        null segment_owner, 
        null segment_name,
        'FREE_SPACE' segment_type,
        tbs.tablespace_name,
        null partition_name,
        v$database.dbid DBID,
        v$database.name database_name,
        null lob_column_name,
        bytes segment_size_b,
        round(bytes /1024/1024/1024 ,2) segment_size_gb,
        null table_name
    from 
        (
            select 
                sum(bytes) bytes,
                tablespace_name
            from
                dba_free_space
            group by
                tablespace_name
        ) tbs,
        v$database
) segments_data
