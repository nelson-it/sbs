-- Database Version: 12
--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2 (Ubuntu 14.2-1ubuntu1)
-- Dumped by pg_dump version 14.2 (Ubuntu 14.2-1ubuntu1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: ext_sogo; Type: SCHEMA; Schema: -; Owner: sogogaia
--

CREATE SCHEMA ext_sogo;


ALTER SCHEMA ext_sogo OWNER TO sogogaia;

--
-- Name: mne_application; Type: SCHEMA; Schema: -; Owner: admindb
--

CREATE SCHEMA mne_application;


ALTER SCHEMA mne_application OWNER TO admindb;

--
-- Name: mne_catalog; Type: SCHEMA; Schema: -; Owner: admindb
--

CREATE SCHEMA mne_catalog;


ALTER SCHEMA mne_catalog OWNER TO admindb;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: dbacltype; Type: TYPE; Schema: mne_application; Owner: admindb
--

CREATE TYPE mne_application.dbacltype AS (
	dbname character varying,
	role character varying,
	"create" boolean,
	temp boolean,
	connect boolean
);


ALTER TYPE mne_application.dbacltype OWNER TO admindb;

--
-- Name: mne_history_applications(); Type: FUNCTION; Schema: mne_application; Owner: admindb
--

CREATE FUNCTION mne_application.mne_history_applications() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE 
    str varchar := '';
    oldval varchar := '';
    newval varchar := '';
    modrecord RECORD;
    acttime integer;
  BEGIN
  RETURN NULL;  END;
$$;


ALTER FUNCTION mne_application.mne_history_applications() OWNER TO admindb;

--
-- Name: mne_history_folder(); Type: FUNCTION; Schema: mne_application; Owner: admindb
--

CREATE FUNCTION mne_application.mne_history_folder() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE 
    str varchar := '';
    oldval varchar := '';
    newval varchar := '';
    modrecord RECORD;
    acttime integer;
  BEGIN
    IF ( TG_OP = 'DELETE' ) THEN
      modrecord = OLD;
    ELSE 
      modrecord = NEW;
    END IF;
    SELECT INTO acttime CAST(FLOOR(EXTRACT(EPOCH FROM CURRENT_TIMESTAMP)) AS INTEGER);
    newval = modrecord."location";
    oldval = OLD."location";
  IF ( newval IS NULL ) THEN newval = ''; END IF;
  IF ( oldval IS NULL ) THEN oldval = ''; END IF;
  IF ( TG_OP = 'DELETE' OR newval <> oldval ) THEN
    str = 'INSERT INTO mne_base.history '
        || '( operation, createdate, createuser, refid, refcol, '        ||    '  schema, tabname, colname, '        ||    '  oldvalue , newvalue )'
        || 'SELECT ' || quote_literal(TG_OP)        ||    ', ' || acttime || ', session_user, '        ||    quote_literal(modrecord.folderid) || ', '        ||    ' ''folderid'', '        ||    ' ''mne_application'',               ''folder'', ''location'', '      ||    quote_literal(oldval) || ',' || quote_literal(newval);
  EXECUTE str;
  END IF
;     IF ( TG_OP = 'DELETE' ) THEN
      modrecord = OLD;
    ELSE 
      modrecord = NEW;
    END IF;
    SELECT INTO acttime CAST(FLOOR(EXTRACT(EPOCH FROM CURRENT_TIMESTAMP)) AS INTEGER);
    newval = modrecord."name";
    oldval = OLD."name";
  IF ( newval IS NULL ) THEN newval = ''; END IF;
  IF ( oldval IS NULL ) THEN oldval = ''; END IF;
  IF ( TG_OP = 'DELETE' OR newval <> oldval ) THEN
    str = 'INSERT INTO mne_base.history '
        || '( operation, createdate, createuser, refid, refcol, '        ||    '  schema, tabname, colname, '        ||    '  oldvalue , newvalue )'
        || 'SELECT ' || quote_literal(TG_OP)        ||    ', ' || acttime || ', session_user, '        ||    quote_literal(modrecord.folderid) || ', '        ||    ' ''folderid'', '        ||    ' ''mne_application'',               ''folder'', ''name'', '      ||    quote_literal(oldval) || ',' || quote_literal(newval);
  EXECUTE str;
  END IF
;     IF ( TG_OP = 'DELETE' ) THEN
      modrecord = OLD;
    ELSE 
      modrecord = NEW;
    END IF;
    SELECT INTO acttime CAST(FLOOR(EXTRACT(EPOCH FROM CURRENT_TIMESTAMP)) AS INTEGER);
    newval = modrecord."description";
    oldval = OLD."description";
  IF ( newval IS NULL ) THEN newval = ''; END IF;
  IF ( oldval IS NULL ) THEN oldval = ''; END IF;
  IF ( TG_OP = 'DELETE' OR newval <> oldval ) THEN
    str = 'INSERT INTO mne_base.history '
        || '( operation, createdate, createuser, refid, refcol, '        ||    '  schema, tabname, colname, '        ||    '  oldvalue , newvalue )'
        || 'SELECT ' || quote_literal(TG_OP)        ||    ', ' || acttime || ', session_user, '        ||    quote_literal(modrecord.folderid) || ', '        ||    ' ''folderid'', '        ||    ' ''mne_application'',               ''folder'', ''description'', '      ||    quote_literal(oldval) || ',' || quote_literal(newval);
  EXECUTE str;
  END IF
;   RETURN NULL;  END;
$$;


ALTER FUNCTION mne_application.mne_history_folder() OWNER TO admindb;

--
-- Name: acttime(); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.acttime() RETURNS integer
    LANGUAGE plpgsql
    AS $$ DECLARE 
    acttime INT4;
BEGIN
    
    SELECT INTO acttime
        CAST(FLOOR(EXTRACT(EPOCH FROM CURRENT_TIMESTAMP)) AS INTEGER);

    return acttime;
END;
 $$;


ALTER FUNCTION mne_catalog.acttime() OWNER TO admindb;

--
-- Name: check_group(character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.check_group(p_username character varying, p_groupname character varying) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$ DECLARE
  stm varchar;
  result varchar;
  acttime INTEGER;
BEGIN

  IF session_user <> 'admindb' THEN
    PERFORM  DISTINCT t0.rolname 
    FROM pg_catalog.pg_roles t0 
      INNER JOIN pg_catalog.pg_roles t1 ON (  t0.rolname = COALESCE(p_username,session_user)  AND t1.rolname IN ( 'admindb', p_groupname ) AND t0.rolcanlogin = true AND t1.rolcanlogin = false )
      INNER JOIN pg_catalog.pg_auth_members t2 ON ( t1.oid = t2.roleid AND t0.oid = t2.member );
    return FOUND;
  END IF;
  
  return true;
  
END; $$;


ALTER FUNCTION mne_catalog.check_group(p_username character varying, p_groupname character varying) OWNER TO admindb;

--
-- Name: color(integer); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.color(num integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$ DECLARE
 retval VARCHAR;
BEGIN
  CASE num
    WHEN 0 THEN retval = 'B0B0B0';
    WHEN 1 THEN retval = '808080';
    ELSE retval = '404040';
  END CASE;
  return retval;
END $$;


ALTER FUNCTION mne_catalog.color(num integer) OWNER TO admindb;

--
-- Name: dbaccess(boolean); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.dbaccess(withuser boolean) RETURNS SETOF mne_application.dbacltype
    LANGUAGE plpgsql
    AS $$ DECLARE
  result mne_application.dbacltype;
  rdb    record;
  ru     record;
  rg     record;
  len    int4;
  i      int4;
  acl    varchar;
  user   varchar;
  guser  varchar;
  acc    varchar;
BEGIN
  FOR rdb IN select datname, datacl from pg_catalog.pg_database LOOP
    
    result.dbname = rdb.datname;

    len = array_length(rdb.datacl, 1);
    IF len is NULL THEN
        result.connect = true;
        result.temp = true;
        result.create = true;
        FOR ru IN SELECT rolname from pg_catalog.pg_roles LOOP
          result.role = ru.rolname;
          return next result;
        END LOOP;
    ELSE
      FOR ru IN SELECT rolname from pg_catalog.pg_roles LOOP
        result.role = ru.rolname;
        result.connect = false;
        result.temp = false;
        result.create = false;
        
        FOR i in 1..len LOOP
          acl = split_part('' || rdb.datacl[i], '/', 1);
          user = split_part(acl, '=', 1);
          acc  = split_part(acl, '=', 2);

          IF user <> '' THEN
            FOUND := FALSE;
            PERFORM DISTINCT t1."rolname"
            FROM (((pg_catalog.pg_auth_members t0
                    LEFT JOIN pg_catalog.pg_roles t1 ON ( t0.roleid = t1.oid) ))
                    LEFT JOIN pg_catalog.pg_roles t2 ON ( t0.member = t2.oid))
            WHERE t1.rolname = user AND t2.rolname = ru.rolname;
          END IF;
          
          IF user = '' OR FOUND OR ( user = ru.rolname AND withuser = true ) THEN
            result.connect = strpos(acc, 'c') > 0;
            result.temp = strpos(acc, 'T') > 0;
            result.create = strpos(acc, 'C') > 0;
          END IF;
        END LOOP;
        return next result;
        
      END LOOP;
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION mne_catalog.dbaccess(withuser boolean) OWNER TO admindb;

--
-- Name: epoch_date(integer); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.epoch_date(timevalue integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$ 
DECLARE 
    result varchar;
    format varchar;
BEGIN
    format = 'DD.MM.YYYY';
    
    SELECT to_char(to_timestamp(timevalue),format) INTO result;
    return result;

END;
 $$;


ALTER FUNCTION mne_catalog.epoch_date(timevalue integer) OWNER TO admindb;

--
-- Name: epoch_datetime(integer); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.epoch_datetime(timevalue integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$ 
DECLARE 
    result varchar;
    format varchar;
BEGIN
    format = 'DD.MM.YYYY HH:MI';
    
    SELECT to_char(to_timestamp(timevalue),format) INTO result;
    return result;

END;
 $$;


ALTER FUNCTION mne_catalog.epoch_datetime(timevalue integer) OWNER TO admindb;

--
-- Name: epoch_day(integer); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.epoch_day(timevalue integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$ 
DECLARE 
    result INTEGER;
BEGIN
    
SELECT 
  CAST(FLOOR(EXTRACT(EPOCH FROM
    date_trunc(  'day', ( TIMESTAMP WITH TIME ZONE '1-1-1970 GMT'
           + CAST (  ( TO_CHAR(timevalue, '9999999999999999999') || ' sec') as INTERVAL ))))) AS INTEGER )
        INTO result;

    return result;
END;
 $$;


ALTER FUNCTION mne_catalog.epoch_day(timevalue integer) OWNER TO admindb;

--
-- Name: epoch_dayname(integer); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.epoch_dayname(timevalue integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$ 
DECLARE 
    result varchar;
BEGIN
    
    SELECT to_char(to_timestamp(timevalue),'D' ) INTO result;
    return result;

END;
 $$;


ALTER FUNCTION mne_catalog.epoch_dayname(timevalue integer) OWNER TO admindb;

--
-- Name: epoch_format(integer, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.epoch_format(timevalue integer, format character varying) RETURNS character varying
    LANGUAGE plpgsql IMMUTABLE
    AS $$ 
DECLARE 
    result varchar;
BEGIN
    
    SELECT to_char(to_timestamp(timevalue),format) INTO result;
    return result;

END;
 $$;


ALTER FUNCTION mne_catalog.epoch_format(timevalue integer, format character varying) OWNER TO admindb;

--
-- Name: epoch_month(integer); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.epoch_month(timevalue integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$ 
DECLARE 
    result INTEGER;
BEGIN
    
SELECT 
  CAST(FLOOR(EXTRACT(EPOCH FROM
    date_trunc(  'month', ( TIMESTAMP WITH TIME ZONE '1-1-1970 GMT'
           + CAST (  ( TO_CHAR(timevalue, '9999999999999999999') || ' sec') as INTERVAL ))))) AS INTEGER )
        INTO result;

    return result;
END;
 $$;


ALTER FUNCTION mne_catalog.epoch_month(timevalue integer) OWNER TO admindb;

--
-- Name: epoch_quarter(integer); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.epoch_quarter(timevalue integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$ 
DECLARE 
    result INTEGER;
BEGIN
    
SELECT 
  CAST(FLOOR(EXTRACT(EPOCH FROM
    date_trunc(  'quarter', ( TIMESTAMP WITH TIME ZONE '1-1-1970 GMT'
           + CAST (  ( TO_CHAR(timevalue, '9999999999999999999') || ' sec') as INTERVAL ))))) AS INTEGER )
        INTO result;

    return result;
END;
 $$;


ALTER FUNCTION mne_catalog.epoch_quarter(timevalue integer) OWNER TO admindb;

--
-- Name: epoch_time(integer); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.epoch_time(timevalue integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$ 
DECLARE 
    result INTEGER;
BEGIN
    
SELECT 
  CAST(FLOOR(EXTRACT(EPOCH FROM date_trunc(  'day',  to_timestamp(timevalue)))) AS INTEGER ) INTO result;
  return timevalue - result;
END;
 $$;


ALTER FUNCTION mne_catalog.epoch_time(timevalue integer) OWNER TO admindb;

--
-- Name: epoch_workday(integer); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.epoch_workday(timevalue integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$ DECLARE
    days int4;
BEGIN
  SELECT INTO days mne_catalog.epoch_workday(timevalue, timevalue + 2678400 + 3600);
  return days;
END; $$;


ALTER FUNCTION mne_catalog.epoch_workday(timevalue integer) OWNER TO admindb;

--
-- Name: epoch_workday(integer, integer); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.epoch_workday(starttime integer, endtime integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$ DECLARE
    i int4;
    j int4;
    diff int4[][];

    sday int4;
    st timestamp;
    et timestamp;
    
    result int4;
BEGIN
  SELECT INTO st DATE_TRUNC('day', TIMESTAMP WITH TIME ZONE  'epoch' + starttime * INTERVAL '1 second');
  IF EXTRACT(EPOCH FROM CURRENT_TIMESTAMP) < endtime THEN
    SELECT INTO et DATE_TRUNC('day', CURRENT_TIMESTAMP);
  ELSE
    SELECT INTO et DATE_TRUNC('day', TIMESTAMP WITH TIME ZONE  'epoch' + endtime * INTERVAL '1 second');
  END IF;
  
  IF st >= et THEN
     return 0;
  END IF;
  
  diff = '{{ 0, 0, 0, 0, 0, 0, 0 },
          { 1, 1, 1, 1, 1, 0, 0 },
          { 2, 2, 2, 2, 1, 0, 1 },
          { 3, 3, 3, 2, 1, 1, 2 },
          { 4, 4, 3, 2, 2, 2, 3 },
          { 5, 4, 3, 3, 3, 3, 4 },
          { 5, 4, 4, 4, 4, 4, 5 }}';

  SELECT EXTRACT('day' FROM et - st) INTO result; 
  SELECT  (result / 7) * 5  + diff[( result % 7 + 1)][EXTRACT(ISODOW FROM st)] INTO result;
  
  return result;

END; $$;


ALTER FUNCTION mne_catalog.epoch_workday(starttime integer, endtime integer) OWNER TO admindb;

--
-- Name: epoch_workday(character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.epoch_workday(starttime character varying, endtime character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$ DECLARE
    i int4;
    j int4;
    diff int4[][];

    sday int4;
    st timestamp;
    et timestamp;
    
    result int4;
BEGIN
  SELECT INTO st DATE_TRUNC('day', to_timestamp(starttime, 'DDMMYYYY'));
  IF CURRENT_TIMESTAMP < to_timestamp(endtime, 'DDMMYYYY') THEN
    SELECT INTO et DATE_TRUNC('day', CURRENT_TIMESTAMP + 86400 * INTERVAL '1 second');
  ELSE
    SELECT INTO et DATE_TRUNC('day', to_timestamp(endtime, 'DDMMYYYY'));
  END IF;
  
  IF st >= et THEN
     return 0;
  END IF;
  
  diff = '{{ 0, 0, 0, 0, 0, 0, 0 },
          { 1, 1, 1, 1, 1, 0, 0 },
          { 2, 2, 2, 2, 1, 0, 1 },
          { 3, 3, 3, 2, 1, 1, 2 },
          { 4, 4, 3, 2, 2, 2, 3 },
          { 5, 4, 3, 3, 3, 3, 4 },
          { 5, 4, 4, 4, 4, 4, 5 }}';

  SELECT EXTRACT('day' FROM et - st) INTO result; 
  SELECT  (result / 7) * 5  + diff[( result % 7 + 1)][EXTRACT(ISODOW FROM st)] INTO result;
  
  return result;

END; $$;


ALTER FUNCTION mne_catalog.epoch_workday(starttime character varying, endtime character varying) OWNER TO admindb;

--
-- Name: epoch_year(integer); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.epoch_year(timevalue integer) RETURNS integer
    LANGUAGE plpgsql IMMUTABLE
    AS $$ 
DECLARE 
    result INTEGER;
BEGIN
    
SELECT 
  CAST(FLOOR(EXTRACT(EPOCH FROM
    date_trunc(  'year', ( TIMESTAMP WITH TIME ZONE '1-1-1970 GMT'
           + CAST (  ( TO_CHAR(timevalue, '9999999999999999999') || ' sec') as INTERVAL ))))) AS INTEGER )
        INTO result;

    return result;
END;
 $$;


ALTER FUNCTION mne_catalog.epoch_year(timevalue integer) OWNER TO admindb;

--
-- Name: history_check(character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.history_check(schema character varying, tabname character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    str text;
    trigname varchar;
    fullname varchar;
    funcname varchar;
    rec RECORD;
BEGIN

    fullname = schema || '.' || tabname;
    trigname = 'mne_history';
    funcname = schema || '.' || 'mne_history_' || tabname || '()';

     SELECT INTO rec tgrelid 
         FROM 
     pg_catalog.pg_trigger t,
     pg_catalog.pg_class c,
     pg_catalog.pg_namespace n
         WHERE 
         tgrelid = c.oid 
         AND n.nspname = schema
         AND c.relkind = 'r' 
         AND c.relnamespace = n.oid 
         AND c.relname = tabname
     AND t.tgname = 'mne_history';

    IF ( NOT FOUND ) THEN
    RETURN 0;
    ELSE
        RETURN 1;
    END IF;
END;
$$;


ALTER FUNCTION mne_catalog.history_check(schema character varying, tabname character varying) OWNER TO admindb;

--
-- Name: history_create(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.history_create(schema character varying, tabname character varying, refname character varying, historytab character varying) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$ 
DECLARE
    
    n RECORD;
    str text := '';
    cols varchar[] = '{}';
    anzahl_cols integer := 0;
    modify_str varchar = 'CAST(EXTRACT(EPOCH FROM current_timestamp) AS int4)';
    i integer;
    trigname varchar;
    fullname varchar;
    funcname varchar;
BEGIN
     str =  'SELECT a.attname as attname '
         || 'FROM '
     || '  pg_catalog.pg_class c,'
     || '  pg_catalog.pg_namespace n,'
     || '  pg_catalog.pg_attribute a '
         || 'WHERE '
         || '  attrelid = c.oid '
         || '  AND a.attisdropped = false '
         || '  AND attnum > 0::pg_catalog.int2 '
         || '  AND n.nspname = ''' || schema || ''' '
         || '  AND c.relkind = ''r'' '
         || '  AND c.relnamespace = n.oid '
         || '  AND c.relname = ''' || tabname || ''' ';

    FOR n IN EXECUTE str LOOP
        IF n.attname = 'modifydate' THEN
        modify_str = 'quote_literal(modrecord.modifydate)';
    ELSIF n.attname != 'createuser' AND
          n.attname != 'createdate' AND
          n.attname != 'modifyuser' AND
          n.attname != refname THEN
        cols[anzahl_cols] = n.attname;
        anzahl_cols = anzahl_cols + 1;
    END IF;
    END LOOP;

    funcname = schema || '.' || 'mne_history_' || tabname || '()';
    str = E'CREATE OR REPLACE FUNCTION ' || funcname
       || E'  RETURNS TRIGGER AS $t$\n'
       || E'  DECLARE \n'
       || E'    str varchar := '''';\n'
       || E'    oldval varchar := '''';\n'
       || E'    newval varchar := '''';\n'
       || E'    modrecord RECORD;\n'
       || E'    acttime integer;\n'
       || E'  BEGIN\n';


    FOR i IN 0 .. anzahl_cols-1 LOOP

       str = str 
       || E'    IF ( TG_OP = ''DELETE'' ) THEN\n'
       || E'      modrecord = OLD;\n'
       || E'    ELSE \n'
       || E'      modrecord = NEW;\n'
       || E'    END IF;\n'

       || E'    SELECT INTO acttime CAST(FLOOR(EXTRACT(EPOCH FROM CURRENT_TIMESTAMP)) AS INTEGER);\n'
       
       || E'    newval = modrecord."' || cols[i] || E'";\n'
       || E'    oldval = OLD."' || cols[i] || E'";\n'

       || E'  IF ( newval IS NULL ) THEN newval = ''''; END IF;\n'
       || E'  IF ( oldval IS NULL ) THEN oldval = ''''; END IF;\n'

       || E'  IF ( TG_OP = ''DELETE'' OR newval <> oldval ) THEN\n'
       || E'    str = ''INSERT INTO ' || historytab || E' ''\n'
       || E'        || ''( operation, createdate, createuser, refid, refcol, '''
       || E'        ||    ''  schema, tabname, colname, '''
       || E'        ||    ''  oldvalue , newvalue )''\n'
       || E'        || ''SELECT '' || quote_literal(TG_OP)'
       || E'        ||    '', '' || acttime || '', session_user, '''
       || E'        ||    quote_literal(modrecord.' || refname || ') || '', '''
       || E'        ||    '' ''''' || refname || ''''', '''
       || E'        ||    '' ''''' || schema || ''''', '
       || E'              ''''' || tabname || ''''', '''''

       || cols[i] 

       || E''''', '''
       || E'      ||    quote_literal(oldval) || '','' || quote_literal(newval);\n'

       || E'  EXECUTE str;\n'
       || E'  END IF\n; ';

    END LOOP;

       str = str || E'  RETURN NULL;'

       || E'  END;\n'
       || '$t$ LANGUAGE plpgsql;';

    EXECUTE str;
    EXECUTE 'GRANT EXECUTE ON FUNCTION ' || funcname || ' TO public';

    trigname = 'mne_history ';
    fullname = schema || '.' || tabname;

    BEGIN
    EXCEPTION WHEN UNDEFINED_OBJECT THEN END;

   str = 'CREATE TRIGGER ' || trigname
           || ' AFTER UPDATE OR DELETE on ' || fullname || ' ' 
           || ' FOR EACH ROW EXECUTE PROCEDURE ' || funcname;
    EXECUTE str;

    RETURN 1;
END;
 $_$;


ALTER FUNCTION mne_catalog.history_create(schema character varying, tabname character varying, refname character varying, historytab character varying) OWNER TO admindb;

--
-- Name: history_drop(character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.history_drop(schema character varying, tabname character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$ 
DECLARE
    trigname varchar;
    fullname varchar;
    funcname varchar;
    str varchar;
BEGIN

    fullname = schema || '.' || tabname;
    trigname = 'mne_history';

    BEGIN
    EXCEPTION WHEN UNDEFINED_OBJECT THEN END;

    str = 'DROP TRIGGER ' || trigname || ' on ' || fullname;
    EXECUTE str;

    RETURN 1;
END;
 $$;


ALTER FUNCTION mne_catalog.history_drop(schema character varying, tabname character varying) OWNER TO admindb;

--
-- Name: mk_id(); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.mk_id() RETURNS character varying
    LANGUAGE plpgsql
    AS $$  
DECLARE 
    rec RECORD;
    str TEXT;
BEGIN
    
    SELECT
    INTO
        rec
        CAST(FLOOR(EXTRACT(EPOCH FROM CURRENT_TIMESTAMP)) AS INTEGER)
        AS acttime,
        id,
        lasttime
    FROM
        mne_catalog.id_count;

    IF ( rec.lasttime < rec.acttime ) OR rec.id < 32768 OR rec.id > 65535 THEN
        rec.id = 32768;
    ELSE
        rec.id = rec.id + 1;
    END IF;

    EXECUTE 'UPDATE mne_catalog.id_count SET id = '
            || quote_literal(rec.id)
        || ', lasttime = '
        || quote_literal(rec.acttime);

    return TO_HEX(rec.acttime) || TO_HEX(rec.id);
END;
  $$;


ALTER FUNCTION mne_catalog.mk_id() OWNER TO admindb;

--
-- Name: not_empty(character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.not_empty(par1 character varying, par2 character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF par1 IS NOT NULL AND TRIM( FROM par1) != '' THEN return par1;
    ELSE return par2; END IF;
END;
$$;


ALTER FUNCTION mne_catalog.not_empty(par1 character varying, par2 character varying) OWNER TO admindb;

--
-- Name: path(character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.path(p_tabname character varying, p_id character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$ DECLARE
  str varchar;
  result varchar;
  r RECORD;
  r_id varchar;
  r_count integer;
  r_delimiter varchar;
BEGIN
  
  result = '';
  r_delimiter ='';
  r_id = p_id;
  LOOP
    str = 'SELECT parentid, treename FROM ' || p_tabname || ' WHERE treeid = ' || quote_literal(COALESCE(r_id, ''));
    EXECUTE str INTO r;
     GET DIAGNOSTICS r_count = ROW_COUNT;

    IF r_count > 0 THEN
      IF r_id <> p_id THEN 
        result = r.treename || r_delimiter || result;
        r_delimiter = '???';
      END IF;
      r_id = r.parentid;
    END IF;
    
    EXIT WHEN r_count = 0 OR r.parentid IS NULL OR r.parentid = '';

  END LOOP;
  
  return result;
END $$;


ALTER FUNCTION mne_catalog.path(p_tabname character varying, p_id character varying) OWNER TO admindb;

--
-- Name: pgplsql_fargs(oid); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.pgplsql_fargs(oidin oid) RETURNS character varying
    LANGUAGE plpgsql
    AS $$ 
DECLARE
    stm VARCHAR;
    str VARCHAR;
    komma VARCHAR;
    rec RECORD;
BEGIN
    str = '(';

    stm =  'SELECT '
        || '  p.proargnames[count.i + 1] as argname, '
        || '  count.i as num, '
        || '  s.nspname, '
        || '  t.typname '
        || 'FROM '
        || ' pg_proc p, pg_type t, pg_namespace s, '
        || ' ( SELECT pc.proname, pc.oid, generate_series(0, pc.pronargs - 1) AS i '
        || '   FROM pg_proc pc ) AS count '
        || 'WHERE '
        || '    count.oid = p.oid '
        || 'AND t.oid = p.proargtypes[count.i] '
        || 'AND s.oid = t.typnamespace '
        || 'AND count.oid = ' || CAST(oidin AS VARCHAR);

    komma = '';
    FOR rec IN EXECUTE stm LOOP
        IF rec.nspname <> 'pg_catalog' AND rec.nspname <> 'public' THEN
          str = str || komma || rec.argname || ' ' || rec.nspname || '.' || rec.typname;
        ELSE
          str = str || komma || rec.argname || ' ' || rec.typname;
        END IF;
    komma = ', ';
    END LOOP;
    str = str || ')';

    return str;
END;
 $$;


ALTER FUNCTION mne_catalog.pgplsql_fargs(oidin oid) OWNER TO admindb;

--
-- Name: pgplsql_proc_access_add(character varying, character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.pgplsql_proc_access_add(p_schema character varying, p_name character varying, p_user character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$ 
DECLARE
    stm varchar;
BEGIN
    stm = 'GRANT EXECUTE ON FUNCTION ' || p_schema || '.' || p_name || ' TO ';

    IF p_user = '' THEN
        stm = stm ||  ' PUBLIC ';
    ELSE
        stm = stm ||  p_user;
    END IF;
    EXECUTE stm;

    return 'ok';
END;
 $$;


ALTER FUNCTION mne_catalog.pgplsql_proc_access_add(p_schema character varying, p_name character varying, p_user character varying) OWNER TO admindb;

--
-- Name: pgplsql_proc_access_del(character varying, character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.pgplsql_proc_access_del(p_schema character varying, p_name character varying, p_user character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$ 
DECLARE
    stm varchar;
BEGIN
    stm = 'REVOKE EXECUTE ON FUNCTION ' || p_schema || '.' || p_name || ' FROM ';

    IF p_user = '' THEN
        stm = stm ||  ' PUBLIC ';
    ELSE
        stm = stm ||  p_user;
    END IF;
    EXECUTE stm;
    
    return 'ok';
END;
 $$;


ALTER FUNCTION mne_catalog.pgplsql_proc_access_del(p_schema character varying, p_name character varying, p_user character varying) OWNER TO admindb;

--
-- Name: pgplsql_proc_create(character varying, character varying, character varying, character varying, boolean, character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.pgplsql_proc_create(schema character varying, name character varying, rettyp character varying, text character varying, asowner boolean, vol character varying, owner character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$ 
/* WARNUNG - DIESE FUNKTION NICHT EDITIEREN */

DECLARE
  stm VARCHAR;
  ret VARCHAR;
BEGIN
  stm =  'CREATE OR REPLACE FUNCTION ' || schema || '.' || name || ' RETURNS ' || rettyp
    || E' AS \$\$ '
    || text
    || E' $\$ LANGUAGE plpgsql';

   IF vol = 'i' THEN stm = stm || ' IMMUTABLE'; END IF;
   IF vol = 's' THEN stm = stm || ' STABLE'; END IF;
   
   if asowner = true THEN stm = stm || ' SECURITY DEFINER'; END IF;

  EXECUTE stm;
    
  stm = 'ALTER FUNCTION ' || schema || '.' || name || ' OWNER TO ' || owner;    
  EXECUTE stm;
    
  return 'ok';

END;
 $_$;


ALTER FUNCTION mne_catalog.pgplsql_proc_create(schema character varying, name character varying, rettyp character varying, text character varying, asowner boolean, vol character varying, owner character varying) OWNER TO admindb;

--
-- Name: pgplsql_proc_del(character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.pgplsql_proc_del(schema character varying, name character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$ 
DECLARE
    stm VARCHAR;
BEGIN

    stm = 'DROP FUNCTION ' || "schema" || '.' || name;
    EXECUTE stm;

    return 'ok';

END; $$;


ALTER FUNCTION mne_catalog.pgplsql_proc_del(schema character varying, name character varying) OWNER TO admindb;

--
-- Name: pgplsql_proc_drop(character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.pgplsql_proc_drop(schema character varying, name character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$ 
DECLARE
    stm VARCHAR;
BEGIN

    stm = 'DROP FUNCTION ' || "schema" || '.' || name;
    EXECUTE stm;

    return 'ok';

END; $$;


ALTER FUNCTION mne_catalog.pgplsql_proc_drop(schema character varying, name character varying) OWNER TO admindb;

--
-- Name: session_user(); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog."session_user"() RETURNS character varying
    LANGUAGE plpgsql
    AS $$ BEGIN
    return session_user;
END $$;


ALTER FUNCTION mne_catalog."session_user"() OWNER TO admindb;

--
-- Name: start_session(character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.start_session(app_schema character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$ 
DECLARE 
    p_timezone varchar;
    p_language varchar;
    p_user     varchar;
    acttime    integer;
    i          integer;
BEGIN
    select session_user INTO p_user;

    BEGIN
    CREATE LOCAL TEMP TABLE mne_settings 
        (
            timezone       varchar NOT NULL,
            language       varchar NOT NULL,
            region         varchar NOT NULL,
            countrycarcode varchar NOT NULL
        );
        EXCEPTION WHEN DUPLICATE_TABLE THEN NULL;
     END;

    EXECUTE 'GRANT ALL ON mne_settings TO ' || p_user;
    GRANT ALL ON mne_settings TO public;

    DELETE FROM mne_settings;
    EXECUTE 'SELECT username FROM ' || app_schema || '.userpref WHERE username = session_user';
    GET DIAGNOSTICS i = ROW_COUNT;
    IF i = 0 THEN
      SELECT INTO acttime
        CAST(FLOOR(EXTRACT(EPOCH FROM CURRENT_TIMESTAMP)) AS INTEGER);

      EXECUTE 'INSERT INTO ' || app_schema || '.userpref 
          ( username, createdate, modifydate, createuser, modifyuser )
        VALUES
          ( session_user, ' || acttime || ',' || acttime || ', current_user, current_user )';
    END IF;

    EXECUTE 'INSERT INTO mne_settings
    SELECT  timezone, language, region, countrycarcode
    FROM ' || app_schema || '.userpref
    WHERE username = session_user';

    SELECT timezone, language INTO p_timezone, p_language FROM mne_settings;
    EXECUTE 'SET SESSION TIME ZONE ''' || p_timezone || '''';

    return 'ok';
END;
 $$;


ALTER FUNCTION mne_catalog.start_session(app_schema character varying) OWNER TO admindb;

--
-- Name: subweblet_del(character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.subweblet_del(p_htmlcomposetabid character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$     
DECLARE
  r_id varchar;
  r_htmlcomposeid varchar;
BEGIN
   
  SELECT id, htmlcomposeid INTO r_id,r_htmlcomposeid FROM mne_application.htmlcomposetab WHERE htmlcomposetabid = p_htmlcomposetabid;
  
  DELETE FROM mne_application.htmlcomposetabselect WHERE htmlcomposeid = r_htmlcomposeid AND id = r_id;
  DELETE FROM mne_application.htmlcomposetabnames WHERE htmlcomposetabid = p_htmlcomposetabid;
  DELETE FROM mne_application.htmlcomposetab WHERE htmlcomposetabid = p_htmlcomposetabid;
  
  return 'ok';
END;
     $$;


ALTER FUNCTION mne_catalog.subweblet_del(p_htmlcomposetabid character varying) OWNER TO admindb;

--
-- Name: subweblet_ok(character varying, character varying, character varying, character varying, integer, integer, character varying, character varying, character varying, character varying, boolean, character varying, character varying, boolean); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.subweblet_ok(p_htmlcomposeid character varying, p_htmlcomposetabid character varying, p_id character varying, p_position character varying, p_subposition integer, p_loadpos integer, p_path character varying, p_initpar character varying, p_depend character varying, p_ugroup character varying, p_custom boolean, p_label_de character varying, p_label_en character varying, p_namecustom boolean) RETURNS character varying
    LANGUAGE plpgsql
    AS $$     
DECLARE
    acttime INTEGER;
	r_htmlcomposetabid VARCHAR;
BEGIN
     SELECT INTO acttime
      CAST(FLOOR(EXTRACT(EPOCH FROM CURRENT_TIMESTAMP)) AS INTEGER);

  IF p_htmlcomposetabid = '################' THEN
    SELECT INTO r_htmlcomposetabid mne_catalog.mk_id();
	INSERT INTO mne_application.htmlcomposetab ( htmlcomposetabid, htmlcomposeid, path, id, subposition, "position", initpar, depend, loadpos, ugroup, custom, createdate, createuser, modifydate, modifyuser )
          VALUES ( r_htmlcomposetabid, p_htmlcomposeid, p_path, p_id, p_subposition, p_position, p_initpar, p_depend, p_loadpos, p_ugroup, p_custom, acttime, session_user, acttime, session_user);
    INSERT INTO mne_application.htmlcomposetabnames ( htmlcomposetabid, htmlcomposeid, label_de, label_en, custom, createdate, createuser, modifydate, modifyuser )
	      VALUES ( r_htmlcomposetabid, p_htmlcomposeid, p_label_de, p_label_en, p_namecustom, acttime, session_user, acttime, session_user);
  ELSE
    r_htmlcomposetabid = p_htmlcomposetabid;
	UPDATE mne_application.htmlcomposetab
	SET
	  htmlcomposeid = p_htmlcomposeid,
	  path = p_path,
	  id = p_id,
	  subposition = p_subposition,
	  "position" = p_position,
	  initpar = p_initpar,
	  depend = p_depend,
	  loadpos = p_loadpos,
	  ugroup = p_ugroup,
  	  custom = p_custom,
	  modifyuser = session_user,
	  modifydate = acttime
	WHERE
	  htmlcomposetabid = r_htmlcomposetabid;
	
	UPDATE mne_application.htmlcomposetabnames
	SET
	  htmlcomposeid = p_htmlcomposeid,
	  label_de = p_label_de,
	  label_en = p_label_en,
	  custom = p_namecustom,
	  modifyuser = session_user,
	  modifydate = acttime
	WHERE
	  htmlcomposetabid = r_htmlcomposetabid;
  END IF;
  
  return r_htmlcomposetabid;
END;
     $$;


ALTER FUNCTION mne_catalog.subweblet_ok(p_htmlcomposeid character varying, p_htmlcomposetabid character varying, p_id character varying, p_position character varying, p_subposition integer, p_loadpos integer, p_path character varying, p_initpar character varying, p_depend character varying, p_ugroup character varying, p_custom boolean, p_label_de character varying, p_label_en character varying, p_namecustom boolean) OWNER TO admindb;

--
-- Name: table_access_add(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.table_access_add(schema character varying, tabname character varying, name character varying, access character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$     
DECLARE
    stm varchar;
BEGIN
    stm = 'GRANT ' || access || ' ON TABLE ' || schema || '.' || tabname || ' TO ';

    IF name = '' THEN
        stm = stm ||  ' PUBLIC ';
    ELSE
        stm = stm ||  name;
    END IF;
    EXECUTE stm;

    return 'ok';
END;
     $$;


ALTER FUNCTION mne_catalog.table_access_add(schema character varying, tabname character varying, name character varying, access character varying) OWNER TO admindb;

--
-- Name: table_access_drop(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.table_access_drop(schema character varying, tabname character varying, name character varying, accesstyp character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$ 
DECLARE
    stm varchar;
BEGIN
    stm = 'REVOKE ' || accesstyp || ' ON TABLE ' || schema || '.' || tabname || ' FROM ';

    IF name = '' THEN
        stm = stm ||  ' PUBLIC ';
    ELSE
        stm = stm ||  name;
    END IF;
    EXECUTE stm;
    
    return 'ok';
END;
 $$;


ALTER FUNCTION mne_catalog.table_access_drop(schema character varying, tabname character varying, name character varying, accesstyp character varying) OWNER TO admindb;

--
-- Name: table_access_ok(character varying, character varying, character varying, boolean, boolean, boolean, boolean, boolean, boolean); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.table_access_ok(schema character varying, tabname character varying, name character varying, p_select boolean, p_insert boolean, p_update boolean, p_delete boolean, p_reference boolean, p_trigger boolean) RETURNS character varying
    LANGUAGE plpgsql
    AS $$     
DECLARE
    stm varchar;
BEGIN
	IF p_select THEN
	  PERFORM mne_catalog.table_access_add(schema, tabname, name, 'SELECT' );
	ELSE
	  PERFORM mne_catalog.table_access_drop(schema, tabname, name, 'SELECT' );
	END IF;
    IF p_insert THEN
	  PERFORM mne_catalog.table_access_add(schema, tabname, name, 'INSERT' );
	ELSE
	  PERFORM mne_catalog.table_access_drop(schema, tabname, name, 'INSERT' );
	END IF;
    IF p_update THEN
	  PERFORM mne_catalog.table_access_add(schema, tabname, name, 'UPDATE' );
	ELSE
	  PERFORM mne_catalog.table_access_drop(schema, tabname, name, 'UPDATE' );
	END IF;
    IF p_delete THEN
	  PERFORM mne_catalog.table_access_add(schema, tabname, name, 'DELETE' );
	ELSE
	  PERFORM mne_catalog.table_access_drop(schema, tabname, name, 'DELETE' );
	END IF;
    IF p_reference THEN
	  PERFORM mne_catalog.table_access_add(schema, tabname, name, 'REFERENCES' );
	ELSE
	  PERFORM mne_catalog.table_access_drop(schema, tabname, name, 'REFERENCES' );
	END IF;
    IF p_trigger THEN
	  PERFORM mne_catalog.table_access_add(schema, tabname, name, 'TRIGGER' );
	ELSE
	  PERFORM mne_catalog.table_access_drop(schema, tabname, name, 'TRIGGER' );
	END IF;
	
    return 'ok';
END;
     $$;


ALTER FUNCTION mne_catalog.table_access_ok(schema character varying, tabname character varying, name character varying, p_select boolean, p_insert boolean, p_update boolean, p_delete boolean, p_reference boolean, p_trigger boolean) OWNER TO admindb;

--
-- Name: table_index_add(character varying, character varying, character varying, boolean, character varying[], character varying, character varying, boolean); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.table_index_add(schema character varying, tabname character varying, indname character varying, isunique boolean, cols character varying[], p_text_de character varying, p_text_en character varying, p_custom boolean) RETURNS character varying
    LANGUAGE plpgsql
    AS $$ DECLARE
    stm varchar;
    i integer;
    acttime int4;
BEGIN
  SELECT INTO acttime
      CAST(FLOOR(EXTRACT(EPOCH FROM CURRENT_TIMESTAMP)) AS INTEGER);

  BEGIN
    PERFORM mne_catalog.table_index_drop(schema, indname);
  EXCEPTION WHEN OTHERS THEN
    DELETE FROM mne_application.tableconstraintmessages WHERE tableconstraintmessagesid = indname;
    INSERT INTO mne_application.tableconstraintmessages
      ( tableconstraintmessagesid, text_de, text_en, custom, createdate, createuser, modifydate, modifyuser )
    VALUES  
      ( indname, p_text_de, p_text_en, p_custom, acttime, session_user, acttime, session_user );
    return 'ok';
  END;

    stm = 'CREATE ' ;
    
    IF isunique THEN
      stm = stm || 'UNIQUE INDEX ';
    ELSE
      stm = stm || 'INDEX ';
    END IF;
    
    IF schema <> '' OR tabname <> '' THEN
      stm = stm || indname || ' ON ' || schema || '.' || tabname;
      stm = stm || ' ( ';
      FOR i in array_lower(cols,1)..array_upper(cols,1) LOOP
         stm = stm || cols[i];
         IF i <> array_upper(cols,1) THEN
             stm = stm || ',';
         END IF;
      END LOOP;
      stm = stm || ' ) ';

      EXECUTE stm;
    END IF;
    
    DELETE FROM mne_application.tableconstraintmessages WHERE tableconstraintmessagesid = indname;
    INSERT INTO mne_application.tableconstraintmessages
      ( tableconstraintmessagesid, text_de, text_en, custom, createdate, createuser, modifydate, modifyuser )
    VALUES  
      ( indname, p_text_de, p_text_en, p_custom, acttime, session_user, acttime, session_user );
    
    return 'ok';
 
END $$;


ALTER FUNCTION mne_catalog.table_index_add(schema character varying, tabname character varying, indname character varying, isunique boolean, cols character varying[], p_text_de character varying, p_text_en character varying, p_custom boolean) OWNER TO admindb;

--
-- Name: table_index_drop(character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.table_index_drop(p_schema character varying, p_index character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$ DECLARE
    stm varchar;
BEGIN
    DELETE from mne_application.tableconstraintmessages WHERE tableconstraintmessagesid = p_index;
    IF p_index != '' THEN
      stm = 'DROP INDEX ' || p_schema || '.' || p_index;
      EXECUTE stm;
    END IF;
	return 'ok'; 
END $$;


ALTER FUNCTION mne_catalog.table_index_drop(p_schema character varying, p_index character varying) OWNER TO admindb;

--
-- Name: table_owner(character varying, character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.table_owner(schema character varying, tabname character varying, owner character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$ DECLARE
    stm varchar;
BEGIN

    stm = 'ALTER TABLE ' || schema || '.' || tabname || ' OWNER TO ' || owner;
    EXECUTE stm;

    return 'ok';
END;
 $$;


ALTER FUNCTION mne_catalog.table_owner(schema character varying, tabname character varying, owner character varying) OWNER TO admindb;

--
-- Name: tree_havechild(character varying, character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.tree_havechild(schema character varying, tabname character varying, treeid character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$ DECLARE
   str varchar;
   anzahl int4;
BEGIN

   str = 'SELECT COUNT(treeid) FROM ' || schema || '.' || tabname || E' WHERE parentid = \'' || treeid || E'\''; 
   EXECUTE str INTO anzahl;
   return anzahl > 0;
    
END; $$;


ALTER FUNCTION mne_catalog.tree_havechild(schema character varying, tabname character varying, treeid character varying) OWNER TO admindb;

--
-- Name: tree_typnoleaf(character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.tree_typnoleaf(schema character varying, tabname character varying, treeid character varying, treeval character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$ DECLARE
   str varchar;
   anzahl int4;
BEGIN

   str = 'SELECT COUNT(*) FROM ' || schema || '.' || tabname || E' WHERE parentid = \'' || treeid || E'\' AND ' || treeval || ' ISNULL'; 
   EXECUTE str INTO anzahl;
   return anzahl > 0;
    
END; $$;


ALTER FUNCTION mne_catalog.tree_typnoleaf(schema character varying, tabname character varying, treeid character varying, treeval character varying) OWNER TO admindb;

--
-- Name: useradd(character varying, boolean, integer); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.useradd(p_username character varying, p_canlogin boolean, p_valid integer) RETURNS character varying
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$ DECLARE
  stm varchar;
  result varchar;
  acttime INTEGER;
BEGIN
  SELECT INTO acttime
      CAST(FLOOR(EXTRACT(EPOCH FROM CURRENT_TIMESTAMP)) AS INTEGER);

  IF p_username = '' OR p_canlogin = false THEN
      PERFORM mne_catalog.userdel(p_username);
      return 'ok';
  END IF;
  
  SELECT INTO result DISTINCT t0."usename" AS username
  FROM ((pg_catalog.pg_user t0 LEFT JOIN mne_catalog.dbaccessgroup t1 ON ( t0.usename =   t1.role) ))
  WHERE( t1.dbname = current_database() AND t1.connect = true AND t0.usename = p_username );
  
  IF NOT FOUND THEN
    SELECT usename INTO result from pg_catalog.pg_user WHERE usename = p_username;
    IF FOUND THEN
      RAISE EXCEPTION '#mne_lang#Benutzer <%> existiert schon und hat eventuell Zugriff zu einer anderen Datenbank#', p_username;
    END IF;
  ELSE
    RAISE WARNING '#mne_lang#Benutzer <%>existiert wird nur zugeordnet#', p_username;
    return p_username;
  END IF;
  
  stm = 'CREATE USER ' || p_username || ' WITH LOGIN';
  IF COALESCE(p_valid, 0) <> 0 THEN
    EXECUTE 'SELECT to_char(to_timestamp(' || p_valid || '), ''dd-mm-YYYY'') ' INTO result;
    stm = stm || ' VALID UNTIL ''' || result || '''';
  END IF;
  EXECUTE stm;

  FOUND := FALSE;
  PERFORM DISTINCT rolname FROM pg_catalog.pg_roles where rolname = 'login' || current_database();
  IF FOUND THEN
  
    FOUND := FALSE;
    PERFORM DISTINCT t0."usename" AS username
    FROM ((pg_catalog.pg_user t0 LEFT JOIN mne_catalog.dbaccessgroup t1 ON ( t0.usename =   t1.role) ))
    WHERE( t1.dbname = current_database() AND t1.connect = true AND t0.usename = p_username );
  
    IF NOT FOUND THEN
      SELECT 'GRANT login' || current_database() || ' TO ' || p_username INTO stm;
      EXECUTE stm;
    END IF;
  END IF;
  
  SELECT username INTO result from mne_application.userpref WHERE username = p_username;
  IF NOT FOUND THEN
    INSERT INTO mne_application.userpref ( username,createdate,createuser,modifydate,modifyuser ) VALUES ( p_username, acttime, session_user, acttime, session_user );
  END IF;
  
  return p_username;
END; $$;


ALTER FUNCTION mne_catalog.useradd(p_username character varying, p_canlogin boolean, p_valid integer) OWNER TO admindb;

--
-- Name: userdel(character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.userdel(p_username character varying) RETURNS character varying
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$ BEGIN

  IF p_username = '' OR p_username IS NULL THEN
     return 'ok';
  END IF;
  
  IF p_username = 'admindb' THEN
     RAISE WARNING '%', '#mne_lang#Admindb kann nicht gel??scht werden#';
     return 'ok';
  END IF;
  
  EXECUTE 'DROP USER IF EXISTS "' || p_username || '"';
  DELETE FROM mne_application.userpref WHERE username NOT IN (SELECT usename FROM pg_catalog.pg_user );

  return 'ok';
END; $$;


ALTER FUNCTION mne_catalog.userdel(p_username character varying) OWNER TO admindb;

--
-- Name: usergroupadd(character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.usergroupadd(p_user character varying, p_group character varying) RETURNS character varying
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$ DECLARE
    str varchar;
BEGIN
    IF p_group = '' THEN
        RAISE EXCEPTION '#mne_lang#Keine Gruppe angegeben#';
    END IF;
    
    IF p_user = '' THEN
        RAISE EXCEPTION '#mne_lang#Kein Benutzer angegeben#';
    END IF;
    
  PERFORM t0."rolname"
  FROM pg_catalog.pg_roles t0
    LEFT JOIN pg_catalog.pg_auth_members t1 ON ( t0.oid = t1.member )
    LEFT JOIN pg_catalog.pg_roles t2 ON ( t2.oid = t1.roleid )
  WHERE t0.rolname = p_user AND t2.rolname = p_group;
  
  IF FOUND THEN
    return 'ok';
  END IF;
  
  IF substring(p_group from 1 for 5) = 'login' THEN
        RAISE EXCEPTION '#mne_lang#Kann Benutzer nicht zu dieser Gruppe hinzuf??gen#';
    END IF;
    
    str = 'GRANT ' || p_group || ' TO ' || p_user;
    EXECUTE str;
    
    return 'ok';
END $$;


ALTER FUNCTION mne_catalog.usergroupadd(p_user character varying, p_group character varying) OWNER TO admindb;

--
-- Name: usergroupdel(character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.usergroupdel(p_user character varying, p_group character varying) RETURNS character varying
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$ DECLARE
    str varchar;
BEGIN
    IF p_group = '' THEN
        RAISE EXCEPTION '#mne_lang#Keine Gruppe angegeben#';
    END IF;
    
    IF p_user = '' THEN
        RAISE EXCEPTION '#mne_lang#Kein Benutzer angegeben#';
    END IF;
    
  PERFORM t0."rolname"
  FROM pg_catalog.pg_roles t0
    LEFT JOIN pg_catalog.pg_auth_members t1 ON ( t0.oid = t1.member )
    LEFT JOIN pg_catalog.pg_roles t2 ON ( t2.oid = t1.roleid )
  WHERE t0.rolname = p_user AND t2.rolname = p_group;
  
  IF NOT FOUND THEN
    return 'ok';
  END IF;

  str = 'REVOKE ' || p_group || ' FROM ' || p_user;
  EXECUTE str;
    
    return 'ok';
END $$;


ALTER FUNCTION mne_catalog.usergroupdel(p_user character varying, p_group character varying) OWNER TO admindb;

--
-- Name: usermod(character varying, boolean, integer); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.usermod(p_username character varying, p_canlogin boolean, p_valid integer) RETURNS character varying
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$ DECLARE
  stm varchar;
  result varchar;
  acttime INTEGER;
BEGIN
  
  IF p_username = '' THEN
      return 'ok';
  END IF;
  
  SELECT INTO result DISTINCT t0."rolname" AS username
    FROM ((pg_catalog.pg_roles t0 LEFT JOIN mne_catalog.dbaccessgroup t1 ON ( t0.rolname =   t1.role) ))
    WHERE( t1.dbname = current_database() AND t1.connect = true AND t0.rolname = p_username );

  IF FOUND THEN

    IF COALESCE(p_valid, 0) <> 0 THEN
      EXECUTE 'SELECT to_char(to_timestamp(' || p_valid || '), ''dd-mm-YYYY'') ' INTO result;
      stm = 'ALTER ROLE ' || p_username || ' VALID UNTIL ''' || result || '''';
      EXECUTE stm;
    ELSE
      stm = 'ALTER ROLE ' || p_username || ' VALID UNTIL ''infinity''';
      EXECUTE stm;
    END IF;

    IF p_canlogin AND p_username != '' OR p_username = 'admindb' THEN
      stm = 'ALTER ROLE ' || p_username || ' WITH LOGIN';
      EXECUTE stm;
    ELSE
       PERFORM mne_catalog.userdel(p_username);
    END IF;
    
  ELSE
    PERFORM mne_catalog.useradd(p_username, p_canlogin, p_valid);
  END IF;

  return p_username;
END; $$;


ALTER FUNCTION mne_catalog.usermod(p_username character varying, p_canlogin boolean, p_valid integer) OWNER TO admindb;

--
-- Name: userok_save(character varying, boolean, integer); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.userok_save(p_username character varying, p_canlogin boolean, p_valid integer) RETURNS character varying
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$ 
 DECLARE
  stm varchar;
  result varchar;
  acttime INTEGER;
BEGIN
  SELECT INTO acttime
      CAST(FLOOR(EXTRACT(EPOCH FROM CURRENT_TIMESTAMP)) AS INTEGER);
  IF p_username = '' THEN
      RAISE EXCEPTION '#mne_lang#Bitte Benutzernamen angeben#';
  END IF;
  
  SELECT INTO result DISTINCT t0."rolname" AS username
  FROM ((pg_catalog.pg_roles t0 LEFT JOIN mne_catalog.dbaccessgroup t1 ON ( t0.rolname =   t1.role) ))
  WHERE( t1.dbname = current_database() AND t1.connect = true AND t0.rolname = p_username ) OR  ( t0.rolcanlogin = false AND t0.rolname = p_username );
  
  IF NOT FOUND THEN
    SELECT rolname INTO result from pg_catalog.pg_roles WHERE rolname = p_username;
    IF FOUND THEN
      RAISE EXCEPTION '#mne_lang#Benutzer existiert schon und hat eventuell Zugriff zu einer anderen Datenbank#';
    END IF;
    
    stm = 'CREATE ROLE "' || p_username;
    IF p_canlogin THEN 
      stm = stm || '" WITH LOGIN';
    ELSE
      stm = stm || '" WITH NOLOGIN';
    END IF;
    IF COALESCE(p_valid, 0) <> 0 THEN
      EXECUTE 'SELECT to_char(to_timestamp(' || p_valid || '), ''dd-mm-YYYY'') ' INTO result;
      stm = stm || ' VALID UNTIL ''' || result || '''';
    END IF;
    EXECUTE stm;
    
  ELSE
    IF COALESCE(p_valid, 0) <> 0 THEN
      EXECUTE 'SELECT to_char(to_timestamp(' || p_valid || '), ''dd-mm-YYYY'') ' INTO result;
      stm = 'ALTER ROLE "' || p_username || '" VALID UNTIL ''' || result || '''';
      EXECUTE stm;
    ELSE
      stm = 'ALTER ROLE "' || p_username || '" VALID UNTIL ''infinity''';
      EXECUTE stm;
    END IF;

    IF p_canlogin OR p_username = 'admindb' THEN
      stm = 'ALTER ROLE "' || p_username || '" WITH LOGIN';
      EXECUTE stm;
    ELSE
      stm = 'ALTER ROLE "' || p_username || '" WITH NOLOGIN';
      EXECUTE stm;
    END IF;
    
  END IF;
  
  FOUND := FALSE;
  PERFORM DISTINCT rolname FROM pg_catalog.pg_roles where rolname = 'login' || current_database();
  IF FOUND AND p_canlogin THEN
  
    FOUND := FALSE;
    PERFORM DISTINCT t0."usename" AS username
    FROM ((pg_catalog.pg_user t0 LEFT JOIN mne_catalog.dbaccessgroup t1 ON ( t0.usename =   t1.role) ))
    WHERE( t1.dbname = current_database() AND t1.connect = true AND t0.usename = p_username );
  
    IF NOT FOUND THEN
      SELECT 'GRANT login' || current_database() || ' TO "' || p_username || '"' INTO stm;
      EXECUTE stm;
    END IF;
  END IF;
  
  SELECT username INTO result from mne_application.userpref WHERE username = p_username;
  IF NOT FOUND THEN
    INSERT INTO mne_application.userpref ( username,createdate,createuser,modifydate,modifyuser ) VALUES ( p_username, acttime, session_user, acttime, session_user );
  END IF;
  
  return p_username;
END; 
 $$;


ALTER FUNCTION mne_catalog.userok_save(p_username character varying, p_canlogin boolean, p_valid integer) OWNER TO admindb;

--
-- Name: userpasswd(character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.userpasswd(p_username character varying, p_passwd character varying) RETURNS character varying
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$ DECLARE
stm VARCHAR;
BEGIN
  
  IF p_passwd = '' THEN
    RAISE EXCEPTION '%', '#mne_lang#Bitte ein Passwort angeben#';
  END IF;
  
  PERFORM DISTINCT t0."rolname" AS rolname
  FROM (((pg_catalog.pg_roles t0 LEFT JOIN pg_catalog.pg_roles t1 ON ( t0.rolcanlogin = true AND ( t1.rolcanlogin = false OR t1.rolname = 'admindb' ) AND substring(t1.rolname FROM 1 FOR 5 ) != 'login' ) )
         INNER JOIN pg_catalog.pg_auth_members t2 ON ( t1.oid = t2.roleid AND t0.oid = t2.member ) ))
  WHERE t0.rolname = session_user  AND ( t1.rolname = 'adminpersonnal' OR t1.rolname = 'adminsystem' );

  IF FOUND OR p_username = session_user OR 'admindb' = session_user THEN
    stm = 'ALTER USER ' || p_username || ' WITH PASSWORD ''' || p_passwd || '''';
    EXECUTE stm;
  ELSE
    RAISE EXCEPTION '#mne_lang#keine Berechtigung das Passwort zu ??ndern#';
  END IF;
  
    return 'ok';
END $$;


ALTER FUNCTION mne_catalog.userpasswd(p_username character varying, p_passwd character varying) OWNER TO admindb;

--
-- Name: usertimecolumn_check(character varying, character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.usertimecolumn_check(schema character varying, tabname character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    rec RECORD;
BEGIN

     SELECT INTO rec count(*) as num 
       FROM
         information_schema.columns
       WHERE
         table_schema = schema
         AND table_name = tabname
         AND column_name in ( 'createdate', 'createuser', 'modifydate', 'modifyuser' );
    
   IF ( rec.num != 4 ) THEN
    RETURN 0;
    ELSE
        RETURN 1;
    END IF;
END;
$$;


ALTER FUNCTION mne_catalog.usertimecolumn_check(schema character varying, tabname character varying) OWNER TO admindb;

--
-- Name: weblet_del(character varying); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.weblet_del(p_htmlcomposeid character varying) RETURNS character varying
    LANGUAGE plpgsql
    AS $$     
DECLARE
    acttime INTEGER;
	r_htmlcomposeid VARCHAR;
BEGIN
  
  DELETE FROM mne_application.htmlcomposetabslider  where htmlcomposeid = p_htmlcomposeid;
  DELETE FROM mne_application.htmlcomposetabselect  where htmlcomposeid = p_htmlcomposeid;
  DELETE FROM mne_application.htmlcomposetabnames   where htmlcomposeid = p_htmlcomposeid;
  DELETE FROM mne_application.htmlcomposetab        where htmlcomposeid = p_htmlcomposeid;
  DELETE FROM mne_application.htmlcomposenames      where htmlcomposeid = p_htmlcomposeid;
  DELETE FROM mne_application.htmlcompose           where htmlcomposeid = p_htmlcomposeid;
  
  return 'ok';
END;
     $$;


ALTER FUNCTION mne_catalog.weblet_del(p_htmlcomposeid character varying) OWNER TO admindb;

--
-- Name: weblet_ok(character varying, character varying, character varying, character varying, character varying, boolean); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.weblet_ok(p_htmlcomposeid character varying, p_name character varying, p_template character varying, p_label_de character varying, p_label_en character varying, p_custom boolean) RETURNS character varying
    LANGUAGE plpgsql
    AS $$     
DECLARE
    acttime INTEGER;
	r_htmlcomposeid VARCHAR;
BEGIN
     SELECT INTO acttime
      CAST(FLOOR(EXTRACT(EPOCH FROM CURRENT_TIMESTAMP)) AS INTEGER);

  IF p_htmlcomposeid = '################' THEN
    SELECT INTO r_htmlcomposeid mne_catalog.mk_id();
    INSERT INTO mne_application.htmlcompose ( htmlcomposeid, name, template, custom, createdate, createuser, modifydate, modifyuser )
	      VALUES ( r_htmlcomposeid, p_name, p_template, p_custom, acttime, session_user, acttime, session_user);
    INSERT INTO mne_application.htmlcomposenames ( htmlcomposeid, label_de, label_en, createdate, createuser, modifydate, modifyuser )
	      VALUES ( r_htmlcomposeid, p_label_de, p_label_en, acttime, session_user, acttime, session_user);
  ELSE
    r_htmlcomposeid = p_htmlcomposeid;
	UPDATE mne_application.htmlcompose
	SET
	  name = p_name,
	  template = p_template,
	  custom = p_custom,
	  modifyuser = session_user,
	  modifydate = acttime
	WHERE
	  htmlcomposeid = r_htmlcomposeid;
	
	UPDATE mne_application.htmlcomposenames
	SET
	  label_de = p_label_de,
	  label_en = p_label_en,
	  modifyuser = session_user,
	  modifydate = acttime
	WHERE
	  htmlcomposeid = r_htmlcomposeid;
  END IF;
  
  return r_htmlcomposeid;
END;
     $$;


ALTER FUNCTION mne_catalog.weblet_ok(p_htmlcomposeid character varying, p_name character varying, p_template character varying, p_label_de character varying, p_label_en character varying, p_custom boolean) OWNER TO admindb;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: yearday; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.yearday (
    leapyear boolean NOT NULL,
    vyear integer NOT NULL,
    vquarter integer NOT NULL,
    vmonth integer NOT NULL,
    vday integer NOT NULL,
    wday integer NOT NULL,
    vfullday character varying NOT NULL,
    createuser character varying(32) NOT NULL,
    modifyuser character varying(32) NOT NULL,
    createdate integer NOT NULL,
    modifydate integer NOT NULL
);


ALTER TABLE mne_application.yearday OWNER TO admindb;

--
-- Name: yearday(); Type: FUNCTION; Schema: mne_catalog; Owner: admindb
--

CREATE FUNCTION mne_catalog.yearday() RETURNS SETOF mne_application.yearday
    LANGUAGE plpgsql
    AS $$ DECLARE
 r mne_application.yearday%ROWTYPE;
 t int4;
 m int4;
 y int4;
 ymin int4;
 ymax int4;
 md int4[];
 leapyear boolean;
 acttime int4;
BEGIN
  
  SET TIME ZONE GMT;
  SELECT yearmin, yearmax INTO ymin,ymax FROM mne_application.year;
  
  SELECT INTO acttime CAST(FLOOR(EXTRACT(EPOCH FROM CURRENT_TIMESTAMP)) AS INTEGER);

  
  y = ymin;
  WHILE y <= ymax LOOP
    leapyear = ( y % 4 ) = 0 AND ( y % 400 <> 0 ) OR ( y % 1000 = 0 );
  
    IF leapyear THEN
      md = '{ 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }';
    ELSE
      md = '{ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }';
    END IF;
    m = 1;
    WHILE m <= 12 LOOP
      t = 1;
      WHILE t <= md[m] LOOP
        r.vyear = y;
        r.vmonth = m;
        r.vquarter = ((m - (( m - 1 ) % 3)) / 3) + 1;
        r.vday = t;
        r.leapyear = leapyear;
        r.wday = to_char( (trim(to_char(y,'9999')) || '-' || trim(to_char(m,'99')) || '-' || trim(to_char(t,'99')))::date,'D' );
        r.vfullday = trim(to_char(t,'00')) || trim(to_char(m,'00')) || trim(to_char(y,'0000'));
        r.createdate = acttime;
        r.modifydate = acttime;
        r.createuser = session_user;
        r.modifyuser = session_user;
        RETURN NEXT r;
         t = t+1;
      END LOOP;
      m = m + 1;
    END LOOP;
    y = y + 1;
  END LOOP;

END; $$;


ALTER FUNCTION mne_catalog.yearday() OWNER TO admindb;

--
-- Name: mne_history_test(); Type: FUNCTION; Schema: public; Owner: admindb
--

CREATE FUNCTION public.mne_history_test() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE 
    str varchar := '';
    oldval varchar := '';
    newval varchar := '';
    modrecord RECORD;
    acttime integer;
  BEGIN
    IF ( TG_OP = 'DELETE' ) THEN
      modrecord = OLD;
    ELSE 
      modrecord = NEW;
    END IF;
    SELECT INTO acttime CAST(FLOOR(EXTRACT(EPOCH FROM CURRENT_TIMESTAMP)) AS INTEGER);
    newval = modrecord."test";
    oldval = OLD."test";
  IF ( newval IS NULL ) THEN newval = ''; END IF;
  IF ( oldval IS NULL ) THEN oldval = ''; END IF;
  IF ( TG_OP = 'DELETE' OR newval <> oldval ) THEN
    str = 'INSERT INTO mne_base.history '
        || '( operation, createdate, createuser, refid, refcol, '        ||    '  schema, tabname, colname, '        ||    '  oldvalue , newvalue )'
        || 'SELECT ' || quote_literal(TG_OP)        ||    ', ' || acttime || ', session_user, '        ||    quote_literal(modrecord.testid) || ', '        ||    ' ''testid'', '        ||    ' ''public'',               ''test'', ''test'', '      ||    quote_literal(oldval) || ',' || quote_literal(newval);
  EXECUTE str;
  END IF
;   RETURN NULL;  END;
$$;


ALTER FUNCTION public.mne_history_test() OWNER TO admindb;

--
-- Name: mne_history_test1(); Type: FUNCTION; Schema: public; Owner: admindb
--

CREATE FUNCTION public.mne_history_test1() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE 
    str varchar := '';
    oldval varchar := '';
    newval varchar := '';
    modrecord RECORD;
    acttime integer;
  BEGIN
  RETURN NULL;  END;
$$;


ALTER FUNCTION public.mne_history_test1() OWNER TO admindb;

--
-- Name: mne_history_test2(); Type: FUNCTION; Schema: public; Owner: admindb
--

CREATE FUNCTION public.mne_history_test2() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE 
    str varchar := '';
    oldval varchar := '';
    newval varchar := '';
    modrecord RECORD;
    acttime integer;
  BEGIN
  RETURN NULL;  END;
$$;


ALTER FUNCTION public.mne_history_test2() OWNER TO admindb;

--
-- Name: mne_history_test3(); Type: FUNCTION; Schema: public; Owner: admindb
--

CREATE FUNCTION public.mne_history_test3() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE 
    str varchar := '';
    oldval varchar := '';
    newval varchar := '';
    modrecord RECORD;
    acttime integer;
  BEGIN
  RETURN NULL;  END;
$$;


ALTER FUNCTION public.mne_history_test3() OWNER TO admindb;

--
-- Name: mne_history_testt(); Type: FUNCTION; Schema: public; Owner: admindb
--

CREATE FUNCTION public.mne_history_testt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  DECLARE 
    str varchar := '';
    oldval varchar := '';
    newval varchar := '';
    modrecord RECORD;
    acttime integer;
  BEGIN
    IF ( TG_OP = 'DELETE' ) THEN
      modrecord = OLD;
    ELSE 
      modrecord = NEW;
    END IF;
    SELECT INTO acttime CAST(FLOOR(EXTRACT(EPOCH FROM CURRENT_TIMESTAMP)) AS INTEGER);
    newval = modrecord."test";
    oldval = OLD."test";
  IF ( newval IS NULL ) THEN newval = ''; END IF;
  IF ( oldval IS NULL ) THEN oldval = ''; END IF;
  IF ( TG_OP = 'DELETE' OR newval <> oldval ) THEN
    str = 'INSERT INTO mne_base.history '
        || '( operation, createdate, createuser, refid, refcol, '        ||    '  schema, tabname, colname, '        ||    '  oldvalue , newvalue )'
        || 'SELECT ' || quote_literal(TG_OP)        ||    ', ' || acttime || ', session_user, '        ||    quote_literal(modrecord.testtid) || ', '        ||    ' ''testtid'', '        ||    ' ''public'',               ''testt'', ''test'', '      ||    quote_literal(oldval) || ',' || quote_literal(newval);
  EXECUTE str;
  END IF
;   RETURN NULL;  END;
$$;


ALTER FUNCTION public.mne_history_testt() OWNER TO admindb;

--
-- Name: sogo_cache_folder_manny; Type: TABLE; Schema: ext_sogo; Owner: sogogaia
--

CREATE TABLE ext_sogo.sogo_cache_folder_manny (
    c_path character varying(255) NOT NULL,
    c_parent_path character varying(255),
    c_type smallint NOT NULL,
    c_creationdate integer NOT NULL,
    c_lastmodified integer NOT NULL,
    c_version integer DEFAULT 0 NOT NULL,
    c_deleted smallint DEFAULT 0 NOT NULL,
    c_content text
);


ALTER TABLE ext_sogo.sogo_cache_folder_manny OWNER TO sogogaia;

--
-- Name: sogo_folder_info; Type: TABLE; Schema: ext_sogo; Owner: sogogaia
--

CREATE TABLE ext_sogo.sogo_folder_info (
    c_folder_id integer NOT NULL,
    c_path character varying(255) NOT NULL,
    c_path1 character varying(255) NOT NULL,
    c_path2 character varying(255),
    c_path3 character varying(255),
    c_path4 character varying(255),
    c_foldername character varying(255) NOT NULL,
    c_location character varying(2048),
    c_quick_location character varying(2048),
    c_acl_location character varying(2048),
    c_folder_type character varying(255) NOT NULL
);


ALTER TABLE ext_sogo.sogo_folder_info OWNER TO sogogaia;

--
-- Name: sogo_folder_info_c_folder_id_seq; Type: SEQUENCE; Schema: ext_sogo; Owner: sogogaia
--

CREATE SEQUENCE ext_sogo.sogo_folder_info_c_folder_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ext_sogo.sogo_folder_info_c_folder_id_seq OWNER TO sogogaia;

--
-- Name: sogo_folder_info_c_folder_id_seq; Type: SEQUENCE OWNED BY; Schema: ext_sogo; Owner: sogogaia
--

ALTER SEQUENCE ext_sogo.sogo_folder_info_c_folder_id_seq OWNED BY ext_sogo.sogo_folder_info.c_folder_id;


--
-- Name: sogo_sessions_folder; Type: TABLE; Schema: ext_sogo; Owner: sogogaia
--

CREATE TABLE ext_sogo.sogo_sessions_folder (
    c_id character varying(255) NOT NULL,
    c_value character varying(255) NOT NULL,
    c_creationdate integer NOT NULL,
    c_lastseen integer NOT NULL
);


ALTER TABLE ext_sogo.sogo_sessions_folder OWNER TO sogogaia;

--
-- Name: sogo_user_profile; Type: TABLE; Schema: ext_sogo; Owner: sogogaia
--

CREATE TABLE ext_sogo.sogo_user_profile (
    c_uid character varying(255) NOT NULL,
    c_defaults text,
    c_settings text
);


ALTER TABLE ext_sogo.sogo_user_profile OWNER TO sogogaia;

--
-- Name: sogomanny0012a410d78; Type: TABLE; Schema: ext_sogo; Owner: sogogaia
--

CREATE TABLE ext_sogo.sogomanny0012a410d78 (
    c_name character varying(255) NOT NULL,
    c_content text NOT NULL,
    c_creationdate integer NOT NULL,
    c_lastmodified integer NOT NULL,
    c_version integer NOT NULL,
    c_deleted integer
);


ALTER TABLE ext_sogo.sogomanny0012a410d78 OWNER TO sogogaia;

--
-- Name: sogomanny0012a410d78_acl; Type: TABLE; Schema: ext_sogo; Owner: sogogaia
--

CREATE TABLE ext_sogo.sogomanny0012a410d78_acl (
    c_uid character varying(255) NOT NULL,
    c_object character varying(255) NOT NULL,
    c_role character varying(80) NOT NULL
);


ALTER TABLE ext_sogo.sogomanny0012a410d78_acl OWNER TO sogogaia;

--
-- Name: sogomanny0012a410d78_quick; Type: TABLE; Schema: ext_sogo; Owner: sogogaia
--

CREATE TABLE ext_sogo.sogomanny0012a410d78_quick (
    c_name character varying(255) NOT NULL,
    c_givenname character varying(255),
    c_cn character varying(255),
    c_sn character varying(255),
    c_screenname character varying(255),
    c_l character varying(255),
    c_mail text,
    c_o character varying(255),
    c_ou character varying(255),
    c_telephonenumber character varying(255),
    c_categories character varying(255),
    c_component character varying(10) NOT NULL,
    c_hascertificate integer
);


ALTER TABLE ext_sogo.sogomanny0012a410d78_quick OWNER TO sogogaia;

--
-- Name: sogomanny001611f754f; Type: TABLE; Schema: ext_sogo; Owner: sogogaia
--

CREATE TABLE ext_sogo.sogomanny001611f754f (
    c_name character varying(255) NOT NULL,
    c_content text NOT NULL,
    c_creationdate integer NOT NULL,
    c_lastmodified integer NOT NULL,
    c_version integer NOT NULL,
    c_deleted integer
);


ALTER TABLE ext_sogo.sogomanny001611f754f OWNER TO sogogaia;

--
-- Name: sogomanny001611f754f_acl; Type: TABLE; Schema: ext_sogo; Owner: sogogaia
--

CREATE TABLE ext_sogo.sogomanny001611f754f_acl (
    c_uid character varying(255) NOT NULL,
    c_object character varying(255) NOT NULL,
    c_role character varying(80) NOT NULL
);


ALTER TABLE ext_sogo.sogomanny001611f754f_acl OWNER TO sogogaia;

--
-- Name: sogomanny001611f754f_quick; Type: TABLE; Schema: ext_sogo; Owner: sogogaia
--

CREATE TABLE ext_sogo.sogomanny001611f754f_quick (
    c_name character varying(255) NOT NULL,
    c_uid character varying(255) NOT NULL,
    c_startdate integer,
    c_enddate integer,
    c_cycleenddate integer,
    c_title character varying(1000) NOT NULL,
    c_participants text,
    c_isallday integer,
    c_iscycle integer,
    c_cycleinfo text,
    c_classification integer NOT NULL,
    c_isopaque integer NOT NULL,
    c_status integer NOT NULL,
    c_priority integer,
    c_location character varying(255),
    c_orgmail character varying(255),
    c_partmails text,
    c_partstates text,
    c_category character varying(255),
    c_sequence integer,
    c_component character varying(10) NOT NULL,
    c_nextalarm integer,
    c_description text
);


ALTER TABLE ext_sogo.sogomanny001611f754f_quick OWNER TO sogogaia;

--
-- Name: sogotest001587c6ced; Type: TABLE; Schema: ext_sogo; Owner: sogogaia
--

CREATE TABLE ext_sogo.sogotest001587c6ced (
    c_name character varying(255) NOT NULL,
    c_content text NOT NULL,
    c_creationdate integer NOT NULL,
    c_lastmodified integer NOT NULL,
    c_version integer NOT NULL,
    c_deleted integer
);


ALTER TABLE ext_sogo.sogotest001587c6ced OWNER TO sogogaia;

--
-- Name: sogotest001587c6ced_acl; Type: TABLE; Schema: ext_sogo; Owner: sogogaia
--

CREATE TABLE ext_sogo.sogotest001587c6ced_acl (
    c_uid character varying(255) NOT NULL,
    c_object character varying(255) NOT NULL,
    c_role character varying(80) NOT NULL
);


ALTER TABLE ext_sogo.sogotest001587c6ced_acl OWNER TO sogogaia;

--
-- Name: sogotest001587c6ced_quick; Type: TABLE; Schema: ext_sogo; Owner: sogogaia
--

CREATE TABLE ext_sogo.sogotest001587c6ced_quick (
    c_name character varying(255) NOT NULL,
    c_uid character varying(255) NOT NULL,
    c_startdate integer,
    c_enddate integer,
    c_cycleenddate integer,
    c_title character varying(1000) NOT NULL,
    c_participants text,
    c_isallday integer,
    c_iscycle integer,
    c_cycleinfo text,
    c_classification integer NOT NULL,
    c_isopaque integer NOT NULL,
    c_status integer NOT NULL,
    c_priority integer,
    c_location character varying(255),
    c_orgmail character varying(255),
    c_partmails text,
    c_partstates text,
    c_category character varying(255),
    c_sequence integer,
    c_component character varying(10) NOT NULL,
    c_nextalarm integer,
    c_description text
);


ALTER TABLE ext_sogo.sogotest001587c6ced_quick OWNER TO sogogaia;

--
-- Name: sogotest00223211dc6; Type: TABLE; Schema: ext_sogo; Owner: sogogaia
--

CREATE TABLE ext_sogo.sogotest00223211dc6 (
    c_name character varying(255) NOT NULL,
    c_content text NOT NULL,
    c_creationdate integer NOT NULL,
    c_lastmodified integer NOT NULL,
    c_version integer NOT NULL,
    c_deleted integer
);


ALTER TABLE ext_sogo.sogotest00223211dc6 OWNER TO sogogaia;

--
-- Name: sogotest00223211dc6_acl; Type: TABLE; Schema: ext_sogo; Owner: sogogaia
--

CREATE TABLE ext_sogo.sogotest00223211dc6_acl (
    c_uid character varying(255) NOT NULL,
    c_object character varying(255) NOT NULL,
    c_role character varying(80) NOT NULL
);


ALTER TABLE ext_sogo.sogotest00223211dc6_acl OWNER TO sogogaia;

--
-- Name: sogotest00223211dc6_quick; Type: TABLE; Schema: ext_sogo; Owner: sogogaia
--

CREATE TABLE ext_sogo.sogotest00223211dc6_quick (
    c_name character varying(255) NOT NULL,
    c_givenname character varying(255),
    c_cn character varying(255),
    c_sn character varying(255),
    c_screenname character varying(255),
    c_l character varying(255),
    c_mail text,
    c_o character varying(255),
    c_ou character varying(255),
    c_telephonenumber character varying(255),
    c_categories character varying(255),
    c_component character varying(10) NOT NULL,
    c_hascertificate integer
);


ALTER TABLE ext_sogo.sogotest00223211dc6_quick OWNER TO sogogaia;

--
-- Name: applications; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.applications (
    applicationsid character varying(32) NOT NULL,
    createdate integer NOT NULL,
    createuser character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    menuname character varying NOT NULL
);


ALTER TABLE mne_application.applications OWNER TO admindb;

--
-- Name: customerfunctions; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.customerfunctions (
    customerfunction character varying(32) NOT NULL,
    func character varying NOT NULL,
    funcschema character varying NOT NULL,
    createuser character varying(32) NOT NULL,
    modifyuser character varying(32) NOT NULL,
    createdate integer NOT NULL,
    modifydate integer NOT NULL
);


ALTER TABLE mne_application.customerfunctions OWNER TO admindb;

--
-- Name: htmlcompose; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.htmlcompose (
    createdate integer NOT NULL,
    createuser character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    name character varying NOT NULL,
    template character varying NOT NULL,
    custom boolean NOT NULL,
    htmlcomposeid character varying(32) NOT NULL,
    CONSTRAINT htmlcompose_name_check CHECK (((name)::text <> ''::text))
);


ALTER TABLE mne_application.htmlcompose OWNER TO admindb;

--
-- Name: htmlcomposenames; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.htmlcomposenames (
    createdate integer NOT NULL,
    createuser character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    label_de character varying NOT NULL,
    label_en character varying NOT NULL,
    htmlcomposeid character varying(32) NOT NULL
);


ALTER TABLE mne_application.htmlcomposenames OWNER TO admindb;

--
-- Name: htmlcomposetab; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.htmlcomposetab (
    createuser character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    path character varying NOT NULL,
    id character varying NOT NULL,
    subposition integer NOT NULL,
    "position" character varying NOT NULL,
    initpar character varying DEFAULT ''::character varying NOT NULL,
    depend character varying DEFAULT ''::character varying NOT NULL,
    loadpos integer DEFAULT 0 NOT NULL,
    ugroup character varying NOT NULL,
    custom boolean NOT NULL,
    htmlcomposetabid character varying(32) NOT NULL,
    htmlcomposeid character varying(32) NOT NULL,
    createdate integer NOT NULL,
    CONSTRAINT htmlcomposetab_id_check CHECK (((id)::text <> ''::text))
);


ALTER TABLE mne_application.htmlcomposetab OWNER TO admindb;

--
-- Name: htmlcomposetabnames; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.htmlcomposetabnames (
    createdate integer NOT NULL,
    createuser character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    label_en character varying NOT NULL,
    label_de character varying NOT NULL,
    custom boolean NOT NULL,
    htmlcomposetabid character varying NOT NULL,
    htmlcomposeid character varying(32) NOT NULL
);


ALTER TABLE mne_application.htmlcomposetabnames OWNER TO admindb;

--
-- Name: htmlcomposetabselect; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.htmlcomposetabselect (
    createdate integer NOT NULL,
    createuser character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    id character varying NOT NULL,
    element character varying NOT NULL,
    schema character varying DEFAULT 'mne_application'::character varying NOT NULL,
    query character varying NOT NULL,
    tab character varying DEFAULT 'selectlist'::character varying NOT NULL,
    wop character varying NOT NULL,
    wcol character varying NOT NULL,
    wval character varying NOT NULL,
    scols character varying NOT NULL,
    showcols character varying NOT NULL,
    cols character varying NOT NULL,
    weblet character varying DEFAULT ''::character varying NOT NULL,
    showids character varying NOT NULL,
    custom boolean NOT NULL,
    selval character varying,
    htmlcomposetabselectid character varying(32) NOT NULL,
    htmlcomposeid character varying(32) NOT NULL,
    type character varying DEFAULT 'table'::character varying NOT NULL,
    showalias character varying NOT NULL
);


ALTER TABLE mne_application.htmlcomposetabselect OWNER TO admindb;

--
-- Name: htmlcomposetabslider; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.htmlcomposetabslider (
    createdate integer NOT NULL,
    createuser character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    sliderpos character varying NOT NULL,
    slidername character varying NOT NULL,
    custom boolean NOT NULL,
    htmlcomposeid character varying(32) NOT NULL
);


ALTER TABLE mne_application.htmlcomposetabslider OWNER TO admindb;

--
-- Name: joindef; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.joindef (
    createdate integer NOT NULL,
    createuser character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    tcols character varying(128) NOT NULL,
    ttab character varying(128) NOT NULL,
    fcols character varying(128) NOT NULL,
    ftab character varying(128) NOT NULL,
    typ integer DEFAULT 1 NOT NULL,
    fschema character varying(128) NOT NULL,
    tschema character varying(128) NOT NULL,
    joindefid character varying(32) NOT NULL,
    op character varying NOT NULL
);


ALTER TABLE mne_application.joindef OWNER TO admindb;

--
-- Name: menu; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.menu (
    createdate integer NOT NULL,
    createuser character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    menupos integer NOT NULL,
    parentid character varying(32),
    menuid character varying(32) NOT NULL,
    menuname character varying(32) NOT NULL,
    action character varying NOT NULL,
    itemname character varying(32) NOT NULL,
    ugroup character varying NOT NULL,
    custom boolean DEFAULT false NOT NULL
);


ALTER TABLE mne_application.menu OWNER TO admindb;

--
-- Name: menu_child; Type: VIEW; Schema: mne_application; Owner: admindb
--

CREATE VIEW mne_application.menu_child AS
 SELECT DISTINCT ON (t0.menuid) t0.menuid,
    t1.menuid AS childid
   FROM (mne_application.menu t0
     LEFT JOIN mne_application.menu t1 ON (((t0.menuid)::text = (t1.parentid)::text)));


ALTER TABLE mne_application.menu_child OWNER TO admindb;

--
-- Name: querycolnames; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.querycolnames (
    createdate integer NOT NULL,
    createuser character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    text_de character varying,
    text_en character varying,
    colid character varying DEFAULT ''::character varying NOT NULL,
    schema character varying NOT NULL,
    query character varying NOT NULL
);


ALTER TABLE mne_application.querycolnames OWNER TO admindb;

--
-- Name: querycolumns; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.querycolumns (
    createdate integer NOT NULL,
    createuser character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    tabnum integer NOT NULL,
    colnum integer NOT NULL,
    queryid character varying NOT NULL,
    fieldtyp integer NOT NULL,
    lang integer DEFAULT 0 NOT NULL,
    colid character varying NOT NULL,
    field character varying NOT NULL,
    format character varying DEFAULT ''::character varying NOT NULL,
    groupby boolean DEFAULT false NOT NULL,
    cannull boolean NOT NULL,
    musthaving boolean DEFAULT false NOT NULL
);


ALTER TABLE mne_application.querycolumns OWNER TO admindb;

--
-- Name: queryname; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.queryname (
    createdate integer NOT NULL,
    createuser character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    selectdistinct boolean DEFAULT false NOT NULL,
    unionall boolean DEFAULT true NOT NULL,
    queryid character varying NOT NULL,
    unionnum integer DEFAULT 1 NOT NULL,
    query character varying NOT NULL,
    schema character varying DEFAULT ''::character varying NOT NULL,
    CONSTRAINT queryname_queryid_check CHECK (((queryid)::text <> ''::text))
);


ALTER TABLE mne_application.queryname OWNER TO admindb;

--
-- Name: querytables; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.querytables (
    createdate integer NOT NULL,
    createuser character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    tabnum integer NOT NULL,
    typ integer DEFAULT 1 NOT NULL,
    deep integer NOT NULL,
    tabid integer NOT NULL,
    queryid character varying NOT NULL,
    fcols character varying DEFAULT ''::character varying NOT NULL,
    op character varying DEFAULT ''::character varying NOT NULL,
    tcols character varying DEFAULT ''::character varying NOT NULL,
    tschema character varying DEFAULT ''::character varying NOT NULL,
    ttab character varying NOT NULL,
    joindefid character varying(32),
    CONSTRAINT querytables_queryid_check CHECK (((queryid)::text <> ''::text))
);


ALTER TABLE mne_application.querytables OWNER TO admindb;

--
-- Name: querywheres; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.querywheres (
    createdate integer NOT NULL,
    createuser character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    notoperator boolean DEFAULT false NOT NULL,
    leftbrace boolean DEFAULT false NOT NULL,
    rightbrace boolean DEFAULT false NOT NULL,
    lefttab character varying(4) NOT NULL,
    righttab character varying(4) NOT NULL,
    booloperator character varying(16) NOT NULL,
    wherecol integer NOT NULL,
    queryid character varying NOT NULL,
    leftvalue character varying NOT NULL,
    rightvalue character varying NOT NULL,
    operator character varying(16) DEFAULT '='::character varying NOT NULL,
    CONSTRAINT viewwheres_viewname_check CHECK (((queryid)::text <> ''::text))
);


ALTER TABLE mne_application.querywheres OWNER TO admindb;

--
-- Name: selectlist; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.selectlist (
    createdate integer NOT NULL,
    createuser character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    name character varying NOT NULL,
    text_de character varying NOT NULL,
    value character varying NOT NULL,
    num integer DEFAULT 0 NOT NULL,
    text_en character varying NOT NULL,
    custom boolean NOT NULL,
    CONSTRAINT selectlist_name_check CHECK (((name)::text <> ''::text))
);


ALTER TABLE mne_application.selectlist OWNER TO admindb;

--
-- Name: tablecolnames; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.tablecolnames (
    createdate integer NOT NULL,
    createuser character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    schema character varying NOT NULL,
    tab character varying NOT NULL,
    colname character varying NOT NULL,
    text_en character varying,
    text_de character varying,
    dpytype integer DEFAULT '-1'::integer NOT NULL,
    showhistory boolean DEFAULT true NOT NULL,
    regexp character varying,
    regexphelp character varying,
    custom boolean NOT NULL,
    regexpmod character varying,
    CONSTRAINT tablecolnames_dpytype_check CHECK (((dpytype = '-1'::integer) OR (dpytype = 1) OR (dpytype = 2) OR (dpytype = 3) OR (dpytype = 4) OR (dpytype = 5) OR (dpytype = 6) OR (dpytype = 7) OR (dpytype = 100) OR (dpytype = 1000) OR (dpytype = 1001) OR (dpytype = 1002) OR (dpytype = 1003) OR (dpytype = 1004) OR (dpytype = 1005) OR (dpytype = 1006) OR (dpytype = 1007) OR (dpytype = 1008) OR (dpytype = 1010) OR (dpytype = 1011) OR (dpytype = 1020)))
);


ALTER TABLE mne_application.tablecolnames OWNER TO admindb;

--
-- Name: tableconstraintmessages; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.tableconstraintmessages (
    tableconstraintmessagesid character varying NOT NULL,
    text_de character varying NOT NULL,
    text_en character varying NOT NULL,
    custom boolean NOT NULL,
    createuser character varying(32) NOT NULL,
    modifyuser character varying(32) NOT NULL,
    createdate integer NOT NULL,
    modifydate integer NOT NULL
);


ALTER TABLE mne_application.tableconstraintmessages OWNER TO admindb;

--
-- Name: tableregexp; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.tableregexp (
    createdate integer NOT NULL,
    createuser character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    tableregexpid character varying(32) NOT NULL,
    regexp character varying NOT NULL,
    regexphelp character varying,
    regexpmod character varying NOT NULL
);


ALTER TABLE mne_application.tableregexp OWNER TO admindb;

--
-- Name: timestyle; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.timestyle (
    createdate integer NOT NULL,
    createuser character varying(32) NOT NULL,
    language character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    region character varying NOT NULL,
    style character varying NOT NULL,
    typ character varying NOT NULL
);


ALTER TABLE mne_application.timestyle OWNER TO admindb;

--
-- Name: translate; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.translate (
    createdate integer NOT NULL,
    createuser character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    id character varying NOT NULL,
    text_de character varying DEFAULT ''::character varying NOT NULL,
    text_en character varying DEFAULT ''::character varying NOT NULL,
    categorie character varying DEFAULT ''::character varying NOT NULL,
    accesstime integer
);


ALTER TABLE mne_application.translate OWNER TO admindb;

--
-- Name: trustrequest; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.trustrequest (
    createdate integer NOT NULL,
    createuser character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    trustrequestid character varying(32) NOT NULL,
    action character varying NOT NULL,
    ipaddr character varying NOT NULL,
    name character varying NOT NULL,
    typ character varying NOT NULL,
    custom boolean NOT NULL,
    validpar character varying NOT NULL
);


ALTER TABLE mne_application.trustrequest OWNER TO admindb;

--
-- Name: update; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.update (
    updateid character varying(32) NOT NULL,
    version character varying NOT NULL,
    updatehost character varying NOT NULL,
    CONSTRAINT version_versionid_check CHECK (((updateid)::text = '0'::text))
);


ALTER TABLE mne_application.update OWNER TO admindb;

--
-- Name: userpref; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.userpref (
    createdate integer NOT NULL,
    createuser character varying(32) NOT NULL,
    modifydate integer NOT NULL,
    modifyuser character varying(32) NOT NULL,
    username character varying(32) NOT NULL,
    language character varying DEFAULT 'de'::character varying NOT NULL,
    timezone character varying DEFAULT 'MET'::character varying NOT NULL,
    stylename character varying DEFAULT 'default'::character varying NOT NULL,
    countrycarcode character varying DEFAULT 'CH'::character varying NOT NULL,
    startweblet character varying,
    region character varying DEFAULT 'CH'::character varying NOT NULL,
    mslanguage character varying DEFAULT 'des'::character varying NOT NULL,
    debug integer DEFAULT 0 NOT NULL,
    exportencoding character varying NOT NULL,
    CONSTRAINT userpref_language_check CHECK ((((language)::text = 'de'::text) OR ((language)::text = 'en'::text)))
);


ALTER TABLE mne_application.userpref OWNER TO admindb;

--
-- Name: usertables; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.usertables (
    text_de character varying NOT NULL,
    schemaname character varying NOT NULL,
    tablename character varying NOT NULL,
    text_en character varying NOT NULL,
    createuser character varying(32) NOT NULL,
    modifyuser character varying(32) NOT NULL,
    createdate integer NOT NULL,
    modifydate integer NOT NULL
);


ALTER TABLE mne_application.usertables OWNER TO admindb;

--
-- Name: year; Type: TABLE; Schema: mne_application; Owner: admindb
--

CREATE TABLE mne_application.year (
    yearmin integer NOT NULL,
    yearmax integer NOT NULL,
    yearid character varying(32) NOT NULL,
    createuser character varying(32) NOT NULL,
    modifyuser character varying(32) NOT NULL,
    createdate integer NOT NULL,
    modifydate integer NOT NULL,
    CONSTRAINT year_yearid_check CHECK (((yearid)::text = '0'::text))
);


ALTER TABLE mne_application.year OWNER TO admindb;

--
-- Name: accessgroup; Type: VIEW; Schema: mne_catalog; Owner: admindb
--

CREATE VIEW mne_catalog.accessgroup AS
 SELECT t0.rolname AS "group",
    t2.rolname AS member
   FROM ((pg_roles t0
     JOIN pg_auth_members t1 ON ((t0.oid = t1.roleid)))
     JOIN pg_roles t2 ON ((t1.member = t2.oid)));


ALTER TABLE mne_catalog.accessgroup OWNER TO admindb;

--
-- Name: dbaccessgroup; Type: VIEW; Schema: mne_catalog; Owner: admindb
--

CREATE VIEW mne_catalog.dbaccessgroup AS
 SELECT dbaccess.dbname,
    dbaccess.role,
    dbaccess."create",
    dbaccess.temp,
    dbaccess.connect
   FROM mne_catalog.dbaccess(false) dbaccess(dbname, role, "create", temp, connect);


ALTER TABLE mne_catalog.dbaccessgroup OWNER TO admindb;

--
-- Name: dbaccessuser; Type: VIEW; Schema: mne_catalog; Owner: admindb
--

CREATE VIEW mne_catalog.dbaccessuser AS
 SELECT dbaccess.dbname,
    dbaccess.role,
    dbaccess."create",
    dbaccess.temp,
    dbaccess.connect
   FROM mne_catalog.dbaccess(true) dbaccess(dbname, role, "create", temp, connect);


ALTER TABLE mne_catalog.dbaccessuser OWNER TO admindb;

--
-- Name: fkey; Type: VIEW; Schema: mne_catalog; Owner: admindb
--

CREATE VIEW mne_catalog.fkey AS
 SELECT con.conname AS name,
    ns.nspname AS schema,
    cl.relname AS "table",
    attr.attname AS "column",
    rns.nspname AS rschema,
    rcl.relname AS rtable,
    rattr.attname AS rcolumn,
    count.i AS "position"
   FROM pg_constraint con,
    pg_namespace ns,
    pg_class cl,
    pg_attribute attr,
    pg_namespace rns,
    pg_class rcl,
    pg_attribute rattr,
    ( SELECT generate_series(1, 10) AS i) count
  WHERE ((con.contype = 'f'::"char") AND (ns.oid = con.connamespace) AND (con.conrelid = cl.oid) AND (attr.attrelid = cl.oid) AND (attr.attnum = con.conkey[count.i]) AND (con.confrelid = rcl.oid) AND (rattr.attrelid = rcl.oid) AND (rattr.attnum = con.confkey[count.i]) AND (rcl.relnamespace = rns.oid));


ALTER TABLE mne_catalog.fkey OWNER TO admindb;

--
-- Name: historycheck; Type: VIEW; Schema: mne_catalog; Owner: admindb
--

CREATE VIEW mne_catalog.historycheck AS
 SELECT (tables.table_schema)::character varying AS schema,
    (tables.table_name)::character varying AS "table",
    mne_catalog.history_check((tables.table_schema)::character varying, (tables.table_name)::character varying) AS showhistory
   FROM information_schema.tables;


ALTER TABLE mne_catalog.historycheck OWNER TO admindb;

--
-- Name: id_count; Type: TABLE; Schema: mne_catalog; Owner: admindb
--

CREATE TABLE mne_catalog.id_count (
    index integer NOT NULL,
    id integer NOT NULL,
    lasttime integer,
    CONSTRAINT id_count_index_check CHECK ((index = 0))
);


ALTER TABLE mne_catalog.id_count OWNER TO admindb;

--
-- Name: pg_timezone_names; Type: VIEW; Schema: mne_catalog; Owner: admindb
--

CREATE VIEW mne_catalog.pg_timezone_names AS
 SELECT pg_timezone_names.name,
    pg_timezone_names.abbrev,
    (date_part('epoch'::text, pg_timezone_names.utc_offset))::integer AS utc_offset,
    pg_timezone_names.is_dst
   FROM pg_timezone_names() pg_timezone_names(name, abbrev, utc_offset, is_dst)
  WHERE ((pg_timezone_names.name ~~ 'Africa%'::text) OR (pg_timezone_names.name ~~ 'America%'::text) OR (pg_timezone_names.name ~~ 'Antarctica%'::text) OR (pg_timezone_names.name ~~ 'Arctic%'::text) OR (pg_timezone_names.name ~~ 'Asia%'::text) OR (pg_timezone_names.name ~~ 'Atlantic%'::text) OR (pg_timezone_names.name ~~ 'Australia%'::text) OR (pg_timezone_names.name ~~ 'Indian%'::text) OR (pg_timezone_names.name ~~ 'Europe%'::text) OR (pg_timezone_names.name ~~ 'Pacific%'::text) OR (char_length(pg_timezone_names.name) < 5));


ALTER TABLE mne_catalog.pg_timezone_names OWNER TO admindb;

--
-- Name: pgplsql_proc; Type: VIEW; Schema: mne_catalog; Owner: admindb
--

CREATE VIEW mne_catalog.pgplsql_proc AS
 SELECT p.oid AS id,
    n.nspname AS schema,
    p.proname AS name,
    ((p.proname)::text || (mne_catalog.pgplsql_fargs(p.oid))::text) AS fullname,
    t.typname AS rettype,
    p.prosrc AS text,
    p.proacl AS access
   FROM (((pg_proc p
     LEFT JOIN pg_type t ON ((p.prorettype = t.oid)))
     LEFT JOIN pg_namespace n ON ((p.pronamespace = n.oid)))
     JOIN pg_language l ON (((p.prolang = l.oid) AND (l.lanname = 'plpgsql'::name))));


ALTER TABLE mne_catalog.pgplsql_proc OWNER TO admindb;

--
-- Name: pkey; Type: VIEW; Schema: mne_catalog; Owner: admindb
--

CREATE VIEW mne_catalog.pkey WITH (security_barrier='false') AS
 SELECT DISTINCT t2.constraint_name AS name,
    t0.table_schema AS schema,
    t0.table_name AS "table",
    t0.column_name AS "column",
        CASE
            WHEN ((t1.column_name)::text = (t0.column_name)::text) THEN (t1.ordinal_position)::integer
            ELSE 0
        END AS "position"
   FROM ((information_schema.columns t0
     LEFT JOIN ( SELECT tt0.table_schema,
            tt0.table_name,
            tt0.constraint_catalog,
            tt0.constraint_name,
            tt0.constraint_schema,
            tt1.column_name,
            tt1.ordinal_position
           FROM (information_schema.table_constraints tt0
             LEFT JOIN information_schema.key_column_usage tt1 ON ((((tt0.constraint_catalog)::text = (tt1.constraint_catalog)::text) AND ((tt0.constraint_name)::text = (tt1.constraint_name)::text) AND ((tt0.constraint_schema)::text = (tt1.constraint_schema)::text))))
          WHERE ((tt0.constraint_type)::text = 'PRIMARY KEY'::text)) t1 ON ((((t0.table_schema)::text = (t1.table_schema)::text) AND ((t0.table_name)::text = (t1.table_name)::text) AND ((t0.column_name)::text = (t1.column_name)::text))))
     LEFT JOIN ( SELECT table_constraints.table_schema,
            table_constraints.table_name,
            table_constraints.constraint_name
           FROM information_schema.table_constraints
          WHERE ((table_constraints.constraint_type)::text = 'PRIMARY KEY'::text)) t2 ON ((((t2.table_schema)::text = (t0.table_schema)::text) AND ((t2.table_name)::text = (t0.table_name)::text))));


ALTER TABLE mne_catalog.pkey OWNER TO admindb;

--
-- Name: table_index; Type: VIEW; Schema: mne_catalog; Owner: admindb
--

CREATE VIEW mne_catalog.table_index AS
 SELECT DISTINCT t4.nspname AS schema,
    t3.relname AS "table",
    t1.relname AS index,
    t6.attname AS "column",
    (t5.i + 1) AS "position",
    t0.indisunique,
    t0.indisprimary
   FROM ((((((pg_index t0
     JOIN pg_class t1 ON (((t0.indexrelid = t1.oid) AND (t1.relkind = 'i'::"char") AND (t0.indisprimary <> true))))
     LEFT JOIN pg_namespace t2 ON ((t1.relnamespace = t2.oid)))
     LEFT JOIN pg_class t3 ON ((t0.indrelid = t3.oid)))
     LEFT JOIN pg_namespace t4 ON ((t3.relnamespace = t4.oid)))
     JOIN ( SELECT tt0.indexrelid,
            generate_series(0, array_upper(tt0.indkey, 1)) AS i
           FROM pg_index tt0) t5 ON ((t5.indexrelid = t0.indexrelid)))
     LEFT JOIN pg_attribute t6 ON (((t6.attnum = t0.indkey[t5.i]) AND (t6.attrelid = t3.oid))))
  ORDER BY t4.nspname, t3.relname, t1.relname, t6.attname, (t5.i + 1), t0.indisunique, t0.indisprimary;


ALTER TABLE mne_catalog.table_index OWNER TO admindb;

--
-- Name: table_index_column; Type: VIEW; Schema: mne_catalog; Owner: admindb
--

CREATE VIEW mne_catalog.table_index_column AS
 SELECT t0.table_schema AS schema,
    t0.table_name AS "table",
    t1.index_name AS index,
    t1.indisunique,
    t1.indisprimary,
    t0.column_name AS "column",
    COALESCE(t2."position", 0) AS "position"
   FROM ((information_schema.columns t0
     LEFT JOIN ( SELECT n.nspname AS table_schema,
            c.relname AS table_name,
            i.relname AS index_name,
            x.indisunique,
            x.indisprimary
           FROM (((pg_index x
             JOIN pg_class c ON ((c.oid = x.indrelid)))
             JOIN pg_class i ON ((i.oid = x.indexrelid)))
             LEFT JOIN pg_namespace n ON ((n.oid = c.relnamespace)))
          WHERE ((c.relkind = ANY (ARRAY['r'::"char", 'm'::"char"])) AND (i.relkind = 'i'::"char"))) t1 ON ((((t0.table_schema)::name = t1.table_schema) AND ((t0.table_name)::name = t1.table_name))))
     LEFT JOIN ( SELECT DISTINCT tt4.nspname AS table_schema,
            tt3.relname AS table_name,
            tt1.relname AS index_name,
            tt6.attname AS column_name,
            (tt5.i + 1) AS "position"
           FROM ((((((pg_index tt0
             JOIN pg_class tt1 ON (((tt0.indexrelid = tt1.oid) AND (tt1.relkind = 'i'::"char") AND (tt0.indisprimary <> true))))
             LEFT JOIN pg_namespace tt2 ON ((tt1.relnamespace = tt2.oid)))
             LEFT JOIN pg_class tt3 ON ((tt0.indrelid = tt3.oid)))
             LEFT JOIN pg_namespace tt4 ON ((tt3.relnamespace = tt4.oid)))
             JOIN ( SELECT ttt0.indexrelid,
                    generate_series(0, array_upper(ttt0.indkey, 1)) AS i
                   FROM pg_index ttt0) tt5 ON ((tt5.indexrelid = tt0.indexrelid)))
             LEFT JOIN pg_attribute tt6 ON (((tt6.attnum = tt0.indkey[tt5.i]) AND (tt6.attrelid = tt3.oid))))) t2 ON (((t1.table_schema = t2.table_schema) AND (t1.table_name = t2.table_name) AND (t1.index_name = t2.index_name) AND ((t0.column_name)::name = t2.column_name))));


ALTER TABLE mne_catalog.table_index_column OWNER TO admindb;

--
-- Name: table_privilege; Type: VIEW; Schema: mne_catalog; Owner: admindb
--

CREATE VIEW mne_catalog.table_privilege AS
 SELECT t0.table_schema AS schema,
    t0.table_name AS "table",
    t0.grantee AS "user",
    (NOT (t1.grantee IS NULL)) AS "select",
    (NOT (t2.grantee IS NULL)) AS insert,
    (NOT (t3.grantee IS NULL)) AS update,
    (NOT (t4.grantee IS NULL)) AS delete,
    (NOT (t5.grantee IS NULL)) AS reference,
    (NOT (t6.grantee IS NULL)) AS trigger
   FROM ((((((( SELECT DISTINCT tt0.table_schema,
            tt0.table_name,
            tt1.grantee
           FROM (information_schema.tables tt0
             LEFT JOIN information_schema.table_privileges tt1 ON ((((tt0.table_schema)::text = (tt1.table_schema)::text) AND ((tt0.table_name)::text = (tt1.table_name)::text))))) t0
     LEFT JOIN information_schema.table_privileges t1 ON ((((t0.table_schema)::text = (t1.table_schema)::text) AND ((t0.table_name)::text = (t1.table_name)::text) AND ((t1.grantee)::text = (t0.grantee)::text) AND ((t1.privilege_type)::text = 'SELECT'::text))))
     LEFT JOIN information_schema.table_privileges t2 ON ((((t0.table_schema)::text = (t2.table_schema)::text) AND ((t0.table_name)::text = (t2.table_name)::text) AND ((t2.grantee)::text = (t0.grantee)::text) AND ((t2.privilege_type)::text = 'INSERT'::text))))
     LEFT JOIN information_schema.table_privileges t3 ON ((((t0.table_schema)::text = (t3.table_schema)::text) AND ((t0.table_name)::text = (t3.table_name)::text) AND ((t3.grantee)::text = (t0.grantee)::text) AND ((t3.privilege_type)::text = 'UPDATE'::text))))
     LEFT JOIN information_schema.table_privileges t4 ON ((((t0.table_schema)::text = (t4.table_schema)::text) AND ((t0.table_name)::text = (t4.table_name)::text) AND ((t4.grantee)::text = (t0.grantee)::text) AND ((t4.privilege_type)::text = 'DELETE'::text))))
     LEFT JOIN information_schema.table_privileges t5 ON ((((t0.table_schema)::text = (t5.table_schema)::text) AND ((t0.table_name)::text = (t5.table_name)::text) AND ((t5.grantee)::text = (t0.grantee)::text) AND ((t5.privilege_type)::text = 'REFERENCES'::text))))
     LEFT JOIN information_schema.table_privileges t6 ON ((((t0.table_schema)::text = (t6.table_schema)::text) AND ((t0.table_name)::text = (t6.table_name)::text) AND ((t6.grantee)::text = (t0.grantee)::text) AND ((t6.privilege_type)::text = 'TRIGGER'::text))));


ALTER TABLE mne_catalog.table_privilege OWNER TO admindb;

--
-- Name: usertimecolumncheck; Type: VIEW; Schema: mne_catalog; Owner: admindb
--

CREATE VIEW mne_catalog.usertimecolumncheck AS
 SELECT (tables.table_schema)::character varying AS schema,
    (tables.table_name)::character varying AS "table",
    mne_catalog.usertimecolumn_check((tables.table_schema)::character varying, (tables.table_name)::character varying) AS haveusertimecolumn
   FROM information_schema.tables;


ALTER TABLE mne_catalog.usertimecolumncheck OWNER TO admindb;

--
-- Name: uuid; Type: TABLE; Schema: mne_catalog; Owner: admindb
--

CREATE TABLE mne_catalog.uuid (
    uuid character varying NOT NULL,
    uuidid character varying(1) NOT NULL,
    CONSTRAINT uuid_uuidid_check CHECK (((uuidid)::text = '1'::text)),
    CONSTRAINT uuid_uuidid_check1 CHECK (((uuidid)::text = '1'::text))
);


ALTER TABLE mne_catalog.uuid OWNER TO admindb;

--
-- Name: sogo_folder_info c_folder_id; Type: DEFAULT; Schema: ext_sogo; Owner: sogogaia
--

ALTER TABLE ONLY ext_sogo.sogo_folder_info ALTER COLUMN c_folder_id SET DEFAULT nextval('ext_sogo.sogo_folder_info_c_folder_id_seq'::regclass);


--
-- Data for Name: sogo_cache_folder_manny; Type: TABLE DATA; Schema: ext_sogo; Owner: sogogaia
--

COPY ext_sogo.sogo_cache_folder_manny (c_path, c_parent_path, c_type, c_creationdate, c_lastmodified, c_version, c_deleted, c_content) FROM stdin;
/MZTB798eb0e8f15c89109d8b4648de1c+folder97270c179e7ebf60ce4e0000f76e0603	\N	201	1649944177	1649944177	0	0	HAAAAAJkaXNwbGF5TmFtZQAGAAAASU5CT1gAAA==
/MZTB798eb0e8f15c89109d8b4648de1c+folder85621230712658621d2600001af83cb2	\N	201	1649944177	1649944177	0	0	HQAAAAJkaXNwbGF5TmFtZQAHAAAARHJhZnRzAAA=
/MZTB798eb0e8f15c89109d8b4648de1c+foldere0d11b32712658621d2600001af83cb2	\N	201	1649944177	1649944177	0	0	GwAAAAJkaXNwbGF5TmFtZQAFAAAAU2VudAAA
/MZTB798eb0e8f15c89109d8b4648de1c+folder08746334712658621d2600001af83cb2	\N	201	1649944177	1649944177	0	0	HAAAAAJkaXNwbGF5TmFtZQAGAAAAVHJhc2gAAA==
/MZTB798eb0e8f15c89109d8b4648de1c+folder000ef538712658621d2600001af83cb2	\N	201	1649944177	1649944177	0	0	GwAAAAJkaXNwbGF5TmFtZQAFAAAASnVuawAA
/MZTB798eb0e8f15c89109d8b4648de1c+vtodo/personal	\N	201	1649944178	1649944178	0	0	LQAAAAJkaXNwbGF5TmFtZQAXAAAAUGVyc8O2bmxpY2hlciBLYWxlbmRlcgAA
/MZTB798eb0e8f15c89109d8b4648de1c+vcard/personal	\N	201	1649944178	1649944178	0	0	LwAAAAJkaXNwbGF5TmFtZQAZAAAAUGVyc8O2bmxpY2hlcyBBZHJlc3NidWNoAAA=
/MZTB798eb0e8f15c89109d8b4648de1c	\N	200	1649944178	1649944280	4	0	XwAAABBTeW5jUmVxdWVzdCt2ZXZlbnQvcGVyc29uYWwAwB4AABBTeW5jUmVxdWVzdADYJlhi\nAkZvbGRlclN5bmNLZXkAFQAAAGdhaWFfMWVjMF8yODA4NWMzZF8xAAA=
/MZTB798eb0e8f15c89109d8b4648de1c+vevent/personal	\N	201	1649944178	1649944280	5	0	cQEAAANVaWRDYWNoZQAFAAAAAAJkaXNwbGF5TmFtZQAXAAAAUGVyc8O2bmxpY2hlciBLYWxl\nbmRlcgADRGF0ZUNhY2hlAD0AAAARMUVDMC02MjU4MjQ4MC0xLTE3RjlERTYwABoAAAAyMDIy\nLTA0LTEwIDExOjMwOjAwICswMjAwAAACU3luY0tleQALAAAAMTY0OTk0Mzc0MQARQ2xlYW5v\ndXREYXRlABoAAAAyMDIyLTA0LTE0IDE1OjUwOjE5ICswMjAwAANTeW5jQ2FjaGUANQAAAAIx\nRUMwLTYyNTgyNDgwLTEtMTdGOURFNjAAEgAAADE2NDk5NDQyODAuMjE4MDEyAAADRm9sZGVy\nT3B0aW9ucwBaAAAAAkJvZHlQcmVmZXJlbmNlVHlwZQACAAAAMQACRmlsdGVyVHlwZQACAAAA\nNwACTUlNRVN1cHBvcnQAAgAAADAAAk1JTUVUcnVuY2F0aW9uAAIAAAA4AAAA
\.


--
-- Data for Name: sogo_folder_info; Type: TABLE DATA; Schema: ext_sogo; Owner: sogogaia
--

COPY ext_sogo.sogo_folder_info (c_folder_id, c_path, c_path1, c_path2, c_path3, c_path4, c_foldername, c_location, c_quick_location, c_acl_location, c_folder_type) FROM stdin;
1	/Users/manny/Calendar/personal	Users	manny	Calendar	personal	Pers??nlicher Kalender	postgresql://sogogaia@127.0.0.1:5432/sbsdb/sogomanny001611f754f	postgresql://sogogaia@127.0.0.1:5432/sbsdb/sogomanny001611f754f_quick	postgresql://sogogaia@127.0.0.1:5432/sbsdb/sogomanny001611f754f_acl	Appointment
2	/Users/manny/Contacts/personal	Users	manny	Contacts	personal	Pers??nliches Adressbuch	postgresql://sogogaia@127.0.0.1:5432/sbsdb/sogomanny0012a410d78	postgresql://sogogaia@127.0.0.1:5432/sbsdb/sogomanny0012a410d78_quick	postgresql://sogogaia@127.0.0.1:5432/sbsdb/sogomanny0012a410d78_acl	Contact
3	/Users/test/Calendar/personal	Users	test	Calendar	personal	Personal Calendar	postgresql://sogogaia@127.0.0.1:5432/sbsdb/sogotest001587c6ced	postgresql://sogogaia@127.0.0.1:5432/sbsdb/sogotest001587c6ced_quick	postgresql://sogogaia@127.0.0.1:5432/sbsdb/sogotest001587c6ced_acl	Appointment
4	/Users/test/Contacts/personal	Users	test	Contacts	personal	Personal Address Book	postgresql://sogogaia@127.0.0.1:5432/sbsdb/sogotest00223211dc6	postgresql://sogogaia@127.0.0.1:5432/sbsdb/sogotest00223211dc6_quick	postgresql://sogogaia@127.0.0.1:5432/sbsdb/sogotest00223211dc6_acl	Contact
\.


--
-- Data for Name: sogo_sessions_folder; Type: TABLE DATA; Schema: ext_sogo; Owner: sogogaia
--

COPY ext_sogo.sogo_sessions_folder (c_id, c_value, c_creationdate, c_lastseen) FROM stdin;
xFbl/ySNZWZHthIikuN4ag==	b1mk/YcVQCyaUq9bkfYhYUa4o8FAmvUnSM+1g7FMRtOpACXVAm0CJM3PSAPrP8ECFS0uwP3JasiZb34E5tIGN6XqZ7srOma9uURfECzkcPURP4VM1PtMXQGZpa4FJP4vSU4wFTA94RJvIwxqGywWwhgWfT84TtNmSnksCQFd7FMeN0Jp6GlWBQZQqyj3IaLlPS/ltV5fchxC1fBKiyMAUQ==	1649943708	1649944286
1QSUKnNKKo3JRvIItwtMjw==	VYfm7oss9oKi2kFBkHKNj8zaMeZC/af/4XuCwVMMsfaZG3/WipMSrKddwh91NVCkNO3TaaMGltdoCoLCo+sok+DCtdQwZ6WnXLidsmHtcTe1mri+WOIBhSdxZaXY8jTuk+XTItCJnG3W+DdPXoXzoDeLwVcRQrgZoRLm0SNV5xWaDqymY3RMraw68gacFTak2I//LLpY2AvpeCn89q9kgw==	1652953600	1652971331
i4IW3eLfDSnksbwdD9toKg==	Wq+T6kgq71s3sMJr/4fdb1NP0a7q8swR4hFVxQZmA0bln1qzeQ8bs7i+Rue+cDOGcaHMrMq6uH241fJdsrVgdmu+yplEqwdeukkDANNbglfdiLir9oLIGLHh79PuWxJjMe8yzBJCiMTtLWhWFvhsUhzfDPxyJEdKQFJYxIxfE0Hmu0q24XignWS1lWrJSoHY6PWyygqCi4JzfJFxJA4jBA==	1653028985	1653028985
\.


--
-- Data for Name: sogo_user_profile; Type: TABLE DATA; Schema: ext_sogo; Owner: sogogaia
--

COPY ext_sogo.sogo_user_profile (c_uid, c_defaults, c_settings) FROM stdin;
manny	{"SOGoMailLabelsColors": {"$mdnsent": ["Empfangsbest??tigung gesendet", "#006600"], "$label5": ["Sp??ter", "#993399"], "$label2": ["Gesch??ftlich", "#FF9900"], "$label4": ["To-Do", "#3333FF"], "$label1": ["Wichtig", "#FF0000"], "$label3": ["Pers??nlich", "#009900"]}, "SOGoMailAutoSave": "5", "SOGoTimeFormat": "%H:%M", "SOGoMailAddOutgoingAddresses": 0, "SOGoCalendarCategories": ["Kunde", "Anrufe", "Favoriten", "Besprechung", "Ideen", "Verschiedenes", "Geburtstag", "Jubil??um", "Urlaub", "Reise", "Projekte", "Lieferanten", "Geschenke", "Klienten", "Fragen", "Gesch??ft", "Ferien", "Pers??nlich", "Status", "Konkurrenz", "Fortsetzung", "Feiertag"], "SOGoCalendarDefaultReminder": "NONE", "SOGoCalendarCategoriesColors": {"Lieferanten": "#9708CC", "Gesch??ft": "#FA016D", "Ideen": "#32CCBC", "Ferien": "#0E197D", "Pers??nlich": "#DE4313", "Projekte": "#8C1BAB", "Geburtstag": "#28C76F", "Fragen": "#3677FF", "Urlaub": "#623AA2", "Konkurrenz": "#6018DC", "Jubil??um": "#9F44D3", "Status": "#002661", "Feiertag": "#E80505", "Fortsetzung": "#D939CD", "Klienten": "#E96D71", "Anrufe": "#0396FF", "Reise": "#F55555", "Verschiedenes": "#F6416C", "Besprechung": "#7367F0", "Geschenke": "#736EFE", "Kunde": "#F8D800", "Favoriten": "#EA5455"}, "SOGoLoginModule": "Mail", "SOGoDayStartTime": "08:00", "SOGoCalendarWeekdays": ["SU", "MO", "TU", "WE", "TH", "FR", "SA"], "SOGoCalendarTasksDefaultClassification": "PUBLIC", "SOGoTimeZone": "Europe\\/Berlin", "SOGoRefreshViewCheck": "manually", "SOGoLanguage": "German", "SOGoAnimationMode": "normal", "SOGoMailSignaturePlacement": "below", "SOGoSelectedAddressBook": "collected", "SOGoContactsCategories": ["Familie", "Freund", "Gesch??ftspartner", "Kollegin", "Konkurrenten", "Kunden", "Lieferant", "Presse", "VIP"], "SOGoShortDateFormat": "%d-%b-%y", "SOGoFirstWeekOfYear": "January1", "SOGoDefaultCalendar": "selected", "SOGoFirstDayOfWeek": 0, "SOGoAlternateAvatar": "none", "SOGoCalendarEventsDefaultClassification": "PUBLIC", "SOGoMailComposeMessageType": "html", "SOGoGravatarEnabled": 0, "SOGoLongDateFormat": "%A, %B %d, %Y", "SOGoMailDisplayRemoteInlineImages": "never", "SOGoMailComposeFontSize": "0", "SOGoGoogleAuthenticatorEnabled": 0, "SOGoMailMessageForwarding": "inline", "SOGoDayEndTime": "18:00", "SOGoMailReplyPlacement": "below"}	{"Calendar": {"SelectedList": "eventsListView", "FoldersOrder": ["personal"], "EventsFilterState": "view_next7", "EventsSortingState": ["start", "1"], "View": "weekview"}}
test	{"SOGoMailLabelsColors": {"$mdnsent": ["Return Receipt Sent", "#006600"], "$label5": ["Later", "#993399"], "$label2": ["Work", "#FF9900"], "$label4": ["To Do", "#3333FF"], "$label1": ["Important", "#FF0000"], "$label3": ["Personal", "#009900"]}, "SOGoMailAutoSave": "5", "SOGoTimeFormat": "%H:%M", "SOGoMailAddOutgoingAddresses": 0, "SOGoCalendarCategories": ["Customer", "Calls", "Favorites", "Meeting", "Ideas", "Miscellaneous", "Birthday", "Anniversary", "Vacation", "Travel", "Projects", "Suppliers", "Gifts", "Clients", "Issues", "Business", "Holidays", "Personal", "Status", "Competition", "Follow up", "Public Holiday"], "SOGoCalendarDefaultReminder": "NONE", "SOGoCalendarCategoriesColors": {"Personal": "#DE4313", "Miscellaneous": "#F6416C", "Gifts": "#736EFE", "Customer": "#F8D800", "Business": "#FA016D", "Status": "#002661", "Anniversary": "#9F44D3", "Vacation": "#623AA2", "Clients": "#E96D71", "Travel": "#F55555", "Competition": "#6018DC", "Calls": "#0396FF", "Favorites": "#EA5455", "Meeting": "#7367F0", "Issues": "#3677FF", "Public Holiday": "#E80505", "Projects": "#8C1BAB", "Holidays": "#0E197D", "Birthday": "#28C76F", "Ideas": "#32CCBC", "Suppliers": "#9708CC", "Follow up": "#D939CD"}, "SOGoLoginModule": "Mail", "SOGoDayStartTime": "08:00", "SOGoCalendarWeekdays": ["SU", "MO", "TU", "WE", "TH", "FR", "SA"], "SOGoCalendarTasksDefaultClassification": "PUBLIC", "SOGoTimeZone": "Europe\\/Berlin", "SOGoRefreshViewCheck": "manually", "SOGoLanguage": "English", "SOGoAnimationMode": "normal", "SOGoMailSignaturePlacement": "below", "SOGoSelectedAddressBook": "collected", "SOGoContactsCategories": ["Business Partner", "Colleague", "Competitor", "Customer", "Family", "Friend", "Press", "Provider", "VIP"], "SOGoShortDateFormat": "%d-%b-%y", "SOGoFirstWeekOfYear": "January1", "SOGoDefaultCalendar": "selected", "SOGoFirstDayOfWeek": 0, "SOGoAlternateAvatar": "none", "SOGoTOTPEnabled": 0, "SOGoCalendarEventsDefaultClassification": "PUBLIC", "SOGoMailComposeMessageType": "html", "SOGoGravatarEnabled": 0, "SOGoLongDateFormat": "%A, %B %d, %Y", "SOGoMailDisplayRemoteInlineImages": "never", "SOGoMailAutoMarkAsReadDelay": 0, "SOGoMailComposeFontSize": "0", "SOGoMailMessageForwarding": "inline", "SOGoDayEndTime": "18:00", "SOGoMailReplyPlacement": "below"}	{"Contact": {"SortingState": ["c_cn", "1"]}, "Calendar": {}}
\.


--
-- Data for Name: sogomanny0012a410d78; Type: TABLE DATA; Schema: ext_sogo; Owner: sogogaia
--

COPY ext_sogo.sogomanny0012a410d78 (c_name, c_content, c_creationdate, c_lastmodified, c_version, c_deleted) FROM stdin;
\.


--
-- Data for Name: sogomanny0012a410d78_acl; Type: TABLE DATA; Schema: ext_sogo; Owner: sogogaia
--

COPY ext_sogo.sogomanny0012a410d78_acl (c_uid, c_object, c_role) FROM stdin;
\.


--
-- Data for Name: sogomanny0012a410d78_quick; Type: TABLE DATA; Schema: ext_sogo; Owner: sogogaia
--

COPY ext_sogo.sogomanny0012a410d78_quick (c_name, c_givenname, c_cn, c_sn, c_screenname, c_l, c_mail, c_o, c_ou, c_telephonenumber, c_categories, c_component, c_hascertificate) FROM stdin;
\.


--
-- Data for Name: sogomanny001611f754f; Type: TABLE DATA; Schema: ext_sogo; Owner: sogogaia
--

COPY ext_sogo.sogomanny001611f754f (c_name, c_content, c_creationdate, c_lastmodified, c_version, c_deleted) FROM stdin;
1EC0-62582480-1-17F9DE60.ics	BEGIN:VCALENDAR\r\nPRODID:-//Inverse inc./SOGo 5.1.1//EN\r\nVERSION:2.0\r\nBEGIN:VTIMEZONE\r\nTZID:Europe/Berlin\r\nLAST-MODIFIED:20210303T135712Z\r\nX-LIC-LOCATION:Europe/Berlin\r\nBEGIN:DAYLIGHT\r\nTZNAME:CEST\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0200\r\nDTSTART:19700329T020000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZNAME:CET\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0100\r\nDTSTART:19701025T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nBEGIN:VEVENT\r\nUID:1EC0-62582480-1-17F9DE60\r\nSUMMARY:test\r\nCLASS:PUBLIC\r\nTRANSP:OPAQUE\r\nDTSTART;TZID=Europe/Berlin:20220410T090000\r\nDTEND;TZID=Europe/Berlin:20220410T094500\r\nCREATED:20220414T134220Z\r\nDTSTAMP:20220414T134220Z\r\nLAST-MODIFIED:20220414T135120Z\r\nORGANIZER;PARTSTAT=ACCEPTED;CN=manny:mailto:manny@gtest.puran2.ch\r\nSEQUENCE:1\r\nEND:VEVENT\r\nEND:VCALENDAR	1649943741	1649944280	1	\N
\.


--
-- Data for Name: sogomanny001611f754f_acl; Type: TABLE DATA; Schema: ext_sogo; Owner: sogogaia
--

COPY ext_sogo.sogomanny001611f754f_acl (c_uid, c_object, c_role) FROM stdin;
\.


--
-- Data for Name: sogomanny001611f754f_quick; Type: TABLE DATA; Schema: ext_sogo; Owner: sogogaia
--

COPY ext_sogo.sogomanny001611f754f_quick (c_name, c_uid, c_startdate, c_enddate, c_cycleenddate, c_title, c_participants, c_isallday, c_iscycle, c_cycleinfo, c_classification, c_isopaque, c_status, c_priority, c_location, c_orgmail, c_partmails, c_partstates, c_category, c_sequence, c_component, c_nextalarm, c_description) FROM stdin;
1EC0-62582480-1-17F9DE60.ics	1EC0-62582480-1-17F9DE60	1649574000	1649576700	\N	test	\N	0	0	\N	0	1	1	0		manny@gtest.puran2.ch	\N		\N	1	vevent	0	
\.


--
-- Data for Name: sogotest001587c6ced; Type: TABLE DATA; Schema: ext_sogo; Owner: sogogaia
--

COPY ext_sogo.sogotest001587c6ced (c_name, c_content, c_creationdate, c_lastmodified, c_version, c_deleted) FROM stdin;
\.


--
-- Data for Name: sogotest001587c6ced_acl; Type: TABLE DATA; Schema: ext_sogo; Owner: sogogaia
--

COPY ext_sogo.sogotest001587c6ced_acl (c_uid, c_object, c_role) FROM stdin;
\.


--
-- Data for Name: sogotest001587c6ced_quick; Type: TABLE DATA; Schema: ext_sogo; Owner: sogogaia
--

COPY ext_sogo.sogotest001587c6ced_quick (c_name, c_uid, c_startdate, c_enddate, c_cycleenddate, c_title, c_participants, c_isallday, c_iscycle, c_cycleinfo, c_classification, c_isopaque, c_status, c_priority, c_location, c_orgmail, c_partmails, c_partstates, c_category, c_sequence, c_component, c_nextalarm, c_description) FROM stdin;
\.


--
-- Data for Name: sogotest00223211dc6; Type: TABLE DATA; Schema: ext_sogo; Owner: sogogaia
--

COPY ext_sogo.sogotest00223211dc6 (c_name, c_content, c_creationdate, c_lastmodified, c_version, c_deleted) FROM stdin;
\.


--
-- Data for Name: sogotest00223211dc6_acl; Type: TABLE DATA; Schema: ext_sogo; Owner: sogogaia
--

COPY ext_sogo.sogotest00223211dc6_acl (c_uid, c_object, c_role) FROM stdin;
\.


--
-- Data for Name: sogotest00223211dc6_quick; Type: TABLE DATA; Schema: ext_sogo; Owner: sogogaia
--

COPY ext_sogo.sogotest00223211dc6_quick (c_name, c_givenname, c_cn, c_sn, c_screenname, c_l, c_mail, c_o, c_ou, c_telephonenumber, c_categories, c_component, c_hascertificate) FROM stdin;
\.


--
-- Data for Name: applications; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.applications (applicationsid, createdate, createuser, modifydate, modifyuser, menuname) FROM stdin;
dbadmin	1610360801	admindb	1610360801	admindb	dbadmin
sbsdb	1610360800	admindb	1611330828	admindb	dbadmin
sbs	1610360777	admindb	1611330835	admindb	sbs
\.


--
-- Data for Name: customerfunctions; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.customerfunctions (customerfunction, func, funcschema, createuser, modifyuser, createdate, modifydate) FROM stdin;
\.


--
-- Data for Name: htmlcompose; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.htmlcompose (createdate, createuser, modifydate, modifyuser, name, template, custom, htmlcomposeid) FROM stdin;
1427952853	admindb	1427952853	admindb	main	main	f	575e9c458013
1226308048	admindb	1434349688	admindb	user_settings	hh	f	575e9c458034
1220555700	admindb	1516288977	admindb	dbadmin_table	t_hh	f	575e9c45800d
1206446471	admindb	1434349317	admindb	dbadmin_weblet	t_hh	f	575e9c45801d
1206446471	admindb	1589787699	admindb	dbadmin_query	query	f	575e9c458001
1220256846	admindb	1590668442	admindb	dbadmin_join	join	f	575e9c458002
1222161762	admindb	1591110882	admindb	dbadmin_procedure	h_hh	f	575e9c45801a
1246350355	admindb	1591282709	admindb	dbadmin_sql_execute	hh	f	575e9c458006
1289898750	admindb	1591362535	admindb	dbadmin_menu	h_hh	f	575e9c458027
1289984431	admindb	1591609000	admindb	dbadmin_selectlist	vv	f	575e9c458028
1611567956	admindb	1611568218	admindb	sysadmin_network	network	f	600e93548000
1459247285	admindb	1611939233	admindb	sysadmin_cert	hh	f	575e9c458039
1453298759	admindb	1612333476	admindb	sysadmin_apache	hh	f	575e9c458038
1471854098	admindb	1613985512	admindb	sysadmin_domain	hh	f	57bab6120000
1615271969	admindb	1615271969	admindb	sysadmin_person	h_hh	f	604718218000
1616147907	admindb	1616147907	admindb	sysadmin_share	h_hh	f	605475c38000
\.


--
-- Data for Name: htmlcomposenames; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.htmlcomposenames (createdate, createuser, modifydate, modifyuser, label_de, label_en, htmlcomposeid) FROM stdin;
1220555700	admindb	1516288977	admindb	Tabellen	tables	575e9c45800d
1427952853	admindb	1427952853	admindb	ERP - Nelson technische Informatik	ERP - Nelson technische Informatik	575e9c458013
1220608949	admindb	1434349317	admindb	Weblets	weblets	575e9c45801d
1226308048	admindb	1434349688	admindb	Benutzer Einstellungen	user settings	575e9c458034
1206446471	admindb	1589787699	admindb	Abfragen	querys	575e9c458001
1220256846	admindb	1590668442	admindb	Joins	joins	575e9c458002
1222161787	admindb	1591110882	admindb	Prozeduren	procedures	575e9c45801a
1246350355	admindb	1591282709	admindb	Sql ausf??hren	execute sql	575e9c458006
1289898750	admindb	1591362535	admindb	Men??	menu	575e9c458027
1289984431	admindb	1591609000	admindb	Auswahllisten	select lists	575e9c458028
1611567956	admindb	1611568218	admindb	Netzwerk	network	600e93548000
1459247285	admindb	1611939233	admindb	Zertifikate	certificates	575e9c458039
1453298759	admindb	1612333476	admindb	Webserver Apache	webserver apache	575e9c458038
1471854098	admindb	1613985512	admindb	Domain	domain	57bab6120000
1615271969	admindb	1615271969	admindb	Benutzer	user	604718218000
1616147907	admindb	1616147907	admindb	Freigaben	shares	605475c38000
\.


--
-- Data for Name: htmlcomposetab; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.htmlcomposetab (createuser, modifydate, modifyuser, path, id, subposition, "position", initpar, depend, loadpos, ugroup, custom, htmlcomposetabid, htmlcomposeid, createdate) FROM stdin;
admindb	1597749086	admindb	/weblet/dbadmin/table/name	detail	10	detail	mainweblet : true	bottom	0		f	575ea20580f0	575e9c45800d	1291107024
admindb	1359387171	admindb	/weblet/allg/user/settings	detail	0	detail	showtitle : true	bottom	0		f	575ea205804c	575e9c458034	1226313601
admindb	1585905837	admindb	/weblet/basic/framebutton	menubutton	0	menubutton	frame : this.obj.slider.s1.frame		0		f	575e9c458016	575e9c458013	1585905837
admindb	1615983542	admindb	/weblet/allg/table/fix	mail	0	bottom	tableweblet : '/weblet/sbs/user/mailtable',\npasswdweblet : 'detail',\n\nurl    : 'sysexec/sbs/user/mail_read',\naddurl : 'sysexec/sbs/user/mail_add',\nmodurl : 'sysexec/sbs/user/mail_mod',\ndelurl : 'sysexec/sbs/user/mail_del',\n\ncols          : 'otherMailbox',\nshowids       : [ 'sAMAccountName' ],\nokids         : [ 'otherMailbox' ],\ndelids        : [ 'sAMAccountName', 'otherMailbox' ],\ndelconfirmids : [ 'otherMailbox' ],\n\ntablecoltype : { otherMailbox : 'text' },\n\ndefvalues : { otherMailbox : '' },\nloaddirect : true\n\n		0		f	6050679b8000	604718218000	1615882139
admindb	1542279038	admindb	/weblet/dbadmin/table/check	check	20	bottom			0	admindb	f	575ea2058177	575e9c45800d	1221503696
admindb	1611648963	admindb	/weblet/sbs/network/detail	network	0	network			0		f	600ebad78000	600e93548000	1611578071
admindb	1599565612	admindb	/weblet/allg/menu/fix	querys	10	selection	'schema'    : 'mne_application',\n 'table'        : 'queryname',\n 'cols'         : 'schema,query,unionnum',\n 'showcols' : 'queryid',\n\n loaddirect : 1	detail	0		f	575ea20580ae	575e9c458001	1206446752
admindb	1611903530	admindb	/weblet/sbs/network/devices	devices	0	devices			0		f	60115dfa8000	600e93548000	1611750906
admindb	1616151099	admindb	/weblet/allg/menu/fix	all	0	selection	url : 'sysexec/sbs/share/select_read',\ncols : 'share',\nshowcols : 'share'	detail	0		f	6054762b8000	605475c38000	1616148011
admindb	1603794891	admindb	/weblet/allg/table/fix	webletselect	20	bottom	schema : 'mne_application',\ntable : 'htmlcomposetabselect',\ncols : 'htmlcomposeid,htmlcomposetabselectid,id,element,type,schema,query,tab,wcol,wop,wval,cols,showcols,scols,selval,showids,showalias,weblet,custom',\nscols : 'id,element',\n\nshowids : ['htmlcomposeid'],\n  okids : ['htmlcomposetabselectid'],\n\ntablehidecols : ['htmlcomposeid','htmlcomposetabselectid'],\ntablecoltype : { id: 'text', element: 'text', type: 'text', schema: 'text', query: 'text', tab: 'text', wcol: 'text', wop: 'text', wval: 'text',cols: 'text',showcols: 'text',scols: 'text',showids: 'text', showalias : 'text', selval : 'text', weblet: 'text',custom: 'text' },\n\n\n		0		f	575ea20580bf	575e9c45801d	1226394770
admindb	1615283099	admindb	/weblet/allg/menu/fix	all	0	selection	url : 'sysexec/sbs/user/select_read',\ncols : 'fullname',\nshowcols : 'sAMAccountName'	detail	0		f	604718e08000	604718218000	1615272160
admindb	1615382298	admindb	/weblet/sbs/user/detail	detail	0	detail	mainweblet : true	bottom	0		f	60471cb68000	604718218000	1615273142
admindb	1610115860	admindb	/weblet/main/detail	detail	0	detail			0		f	575e9c458015	575e9c458013	1585893537
admindb	1614169478	admindb	/weblet/allg/table/fix	addresses	0	addresses	url : 'sysexec/sbs/network/address_read',\ncols: 'device,addr,mask,broadcast,readtime'		0		f	601035c08000	600e93548000	1611675072
admindb	1615896362	admindb	/weblet/allg/table/fix	group	10	bottom	url    : 'sysexec/sbs/user/group_read',\naddurl : 'sysexec/sbs/user/group_add',\nmodurl : 'sysexec/sbs/user/group_mod',\ndelurl : 'sysexec/sbs/user/group_del',\n\ncols       : 'memberOf',\n\nshowids       : ['sAMAccountName'],\nokids         : ['memberOf'],\ndelids        : ['memberOf', 'sAMAccountName'],\ndelconfirmids : [ 'memberOf' ],\n\nprimarykey   : ['memberOf'],\ntablecoltype : { memberOf : 'text' },\n\ndefvalues  : { memberOf : '' }\n		0		f	6049f6f08000	604718218000	1615460080
admindb	1347866145	admindb	/weblet/allg/table/fix	access	40	bottom	schema : 'mne_catalog',\n table : 'table_privilege',\n  cols : 'schema,table,user,select,insert,update,delete,reference,trigger',\nscols  : 'user',\n\ntablehidecols : [ 'schema', 'table'],\n tablecoltype : { user : 'text', select : 'bool', insert : 'bool', update : 'bool', delete : 'bool', reference : 'bool', trigger : 'bool' },\n\n   showids : [ 'schema', 'table' ],\nokfunction : 'table_access_ok',\n    okcols : [ 'schema', 'table', 'user', 'select', 'insert', 'update', 'delete', 'reference', 'trigger' ]		0	admindb	f	575ea20580b8	575e9c45800d	1222088958
admindb	1599565653	admindb	/weblet/dbadmin/query/detail	detail	0	detail	mainweblet : true	join,bottom	0		f	575ea20580b9	575e9c458001	1206451053
admindb	1596541380	admindb	/weblet/allg/table/fix	column	5	bottom	schema : 'mne_application',\nquery : 'table_cols',\ncols : 'schema,table,column,text_de,text_en,ntyp,maxlength,nullable,default,defvalue,ndpytype,showhistory,regexp,regexphelp,custom',\nscols : 'column',\n\ntablehidecols : 'schema,table',\ntablecoltype: { column : 'text', text_de: 'text', text_en: 'text' , ntyp: 'selection', maxlength : 'text', 'default' : 'bool', nullable : 'bool' ,defvalue : 'text', ndpytype : 'selection', showhistory : 'bool', regexp : 'text', regexphelp : 'text', custom : 'bool' },\n\nshowids : [ 'schema', 'table' ],\nselectlists : { ntyp : 'tablecoltype', ndpytype : 'tabledpytype' },\ndefvalues : { ntyp : 2, ndpytype : -1 },\n\naddurl : "/db/admin/table/column/add.json",\nmodurl : "/db/admin/table/column/mod.json",\n\ndelurl : "/db/admin/table/column/del.json",\n\nokids: [ 'schema', 'table','column' ],\nokcols : [ 'schema', 'table', 'column', 'text_de', 'text_en' , 'ntyp', 'maxlength', 'default', 'nullable', 'defvalue', 'ndpytype', 'showhistory', 'regexp', 'regexphelp', 'custom' ],\n\nloaddirect : true		0		f	575ea2058107	575e9c45800d	1291107125
admindb	1615896378	admindb	/weblet/sbs/user/passwd	password	20	bottom			0		f	604a2b778000	604718218000	1615473527
admindb	1615796952	admindb	/weblet/allg/table/frame	groupselect	0	popup	url : 'sysexec/sbs/user/groups_readall',\ncols : 'sAMAccountName,description',\nshowcols : 'sAMAccountName'\n		0		f	604b05638000	604718218000	1615529315
admindb	1591609080	admindb	/weblet/allg/menu/fix	selection	0	selection	schema : 'mne_application', table : 'selectlist',\n\n   cols  : 'name',\n   scols : 'name',\nshowcols : 'name',\n\ndistinct : true,\nloaddirect : true,\n\n	detail	0	admindb	f	575ea2058074	575e9c458028	1289984584
admindb	1615802808	admindb	/weblet/allg/table/fix	groups	100	bottom	notdepend    : true,\ntableweblet  : '/weblet/sbs/user/grouptable',\npasswdweblet : 'detail',\n\nurl    : 'sysexec/sbs/user/groups_read',\naddurl : 'sysexec/sbs/user/groups_add',\nmodurl : 'sysexec/sbs/user/groups_mod',\ndelurl : 'sysexec/sbs/user/groups_del',\n\ncols       : 'sAMAccountName,description',\n\nokids         : ['sAMAccountName'],\ndelids        : ['sAMAccountName'],\ndelconfirmids : [ 'sAMAccountName' ],\n\nprimarykey   : ['sAMAccountName'],\ntablecoltype : { sAMAccountName : 'text', description : 'text' },\n\ndefvalues  : { sAMAccountName : '', description : '' }	#group	0		f	604b222b8000	604718218000	1615536683
admindb	1540557410	admindb	/weblet/allg/menu/fix	all	10	selection	classname : 'tree',\n   schema : 'mne_application',\n    query : 'menu',\n     cols : 'menuname',\n showcols : 'menuname',\n\nloaddirect : 1	detail	0		f	575ea20580e3	575e9c458027	1289899033
admindb	1590669707	admindb	/weblet/allg/menu/fix	firstsel	10	firstsel	notitle : false,\n\n?? schema : 'mne_application',\n???? query :'table_all',\n?????? cols :'schema,table',\nshowcols :'schema,table'\n\n	firsttab,joins	0		f	575ea20580de	575e9c458002	1220269177
admindb	1616583522	admindb	/weblet/sbs/share/detail	detail	0	detail		bottom	0		f	605482378000	605475c38000	1616151095
admindb	1590669789	admindb	/weblet/allg/menu/fix	secondsel	10	secondsel	notitle : false,\n\n?? schema : 'mne_application',\n???? query : 'table_all',\n?????? cols : 'schema,table',\nshowcols : 'schema,table'\n\n	secondtab	0		f	575ea20580d3	575e9c458002	1220267153
admindb	1547561906	admindb	/weblet/allg/menu/fix	all	10	selection	classname : 'tree', schema: 'mne_application', query : 'procedure', \n\n     cols : 'schema,fullname', \n showcols : 'schema,fullname', \n\nloaddirect : 1	detail	0		f	575ea205810e	575e9c45801a	1222162435
admindb	1465829261	admindb	/weblet/allg/menu/fix	all	10	selection	classname : 'tree', schema : 'mne_application', query : 'weblet_all', cols : 'schema,name', showcols : 'htmlcomposeid',loaddirect : 1	detail	0		f	575ea20580e4	575e9c45801d	1220255283
admindb	1591188671	admindb	/weblet/dbadmin/procedure/detail	detail	0	detail		access	0		f	575ea20580d2	575e9c45801a	1222163144
admindb	1605600034	admindb	/weblet/allg/user/passwd	bottom	0	bottom	\n		0		f	575ea205808c	575e9c458034	1276678196
admindb	1347866180	admindb	/weblet/allg/menu/fix	all	20	selection	'classname' : 'tree',\n      schema: 'mne_application', \n    'query' : 'table_all',\n      'cols':'schema,table',\n  'showcols':'schema,table',\n       wcol : 'schema,schema,schema,schema,relkind', \n        wop : "!=,!=,!=,^like,^=",\n       wval : 'information_schema,pg_catalog,mne_application_save,%temp%,v',\n   distinct : true,\n loaddirect : 1	detail	0	admindb	f	575ea205802e	575e9c45800d	1220557163
admindb	1347866190	admindb	/weblet/allg/menu/fix	views	30	selection	'classname' : 'tree',\n      schema: 'mne_application', \n    'query' : 'table_all',\n      'cols':'schema,table',\n  'showcols':'schema,table',\n       wcol : 'schema,schema,schema,schema,relkind', \n        wop : "!=,!=,!=,^like,=",\n       wval : 'information_schema,pg_catalog,mne_application_save,%temp%,v',\n   distinct : true	detail	0	admindb	f	575ea2058156	575e9c45800d	1308646210
admindb	1472537380	admindb	/weblet/allg/menu/fix	custom	100	selection	classname : 'tree', schema : 'mne_application', query : 'weblet_all', cols : 'schema,name', showcols : 'htmlcomposeid', wcol : 'customall', wop : '=', wval : 'true'	detail	0		f	575ea205804b	575e9c45801d	1269608549
admindb	1599565619	admindb	/weblet/allg/menu/fix	tables	20	selection	schema : 'mne_application',\n query : 'table_all',\n  cols : 'schema,table',\n\nshowcols : 'schema,table'	detail	0		f	575ea20580a9	575e9c458001	1132588439
admindb	1590760142	admindb	/weblet/allg/table/fix	joins	10	joins	showtitle : true,\n\nschema : 'mne_application',\n??query : 'join_all',\n??table : 'joindef',\n\n?? cols : 'joindefid,joindef',\n??scols : 'joindef',\n\nshowids : [ 'schema', 'table' ],\n??delids : [ 'joindefid' ],\n\ntablehidecols : [ 'joindefid' ],\n\ndelbutton : 'refresh,add,ok,cancel,export'\n		0		f	575ea20580c6	575e9c458002	1220276304
admindb	1347866119	admindb	/weblet/dbadmin/table/pkey	primary	10	bottom			0	admindb	f	575ea2058041	575e9c45800d	1221574895
admindb	1589975191	admindb	/weblet/dbadmin/query/where	where	20	bottom	\n		0		f	575ea2058043	575e9c458001	1210872313
admindb	1589965289	admindb	/weblet/dbadmin/query/jointree	join	0	join		collist	0		f	575ea205806d	575e9c458001	1208860000
admindb	1236678650	admindb	/weblet/dbadmin/query/joinedit	joinedit	0	popup	schema : 'mne_application', table : 'querytables'		0		f	575ea2058095	575e9c458001	1236677737
admindb	1223408722	admindb	/weblet/dbadmin/table/index	indexdetail	10	popup	showtitle : true		0		f	575ea2058098	575e9c45800d	1223408722
admindb	1597663569	admindb	/weblet/dbadmin/join/collist	firsttab	10	firsttab	notitle  : false,\nselectid : 'firsttab'\n\n	detail	0		f	575ea20580c1	575e9c458002	1220266963
admindb	1472537003	admindb	/weblet/allg/menu/fix	sub	20	selection	classname : 'tree', \n\nschema : 'mne_application',\n query : 'weblet_tabs',\n  cols : 'path,name',\n\n showcols : 'htmlcomposeid'	detail	0		f	575ea20580a0	575e9c45801d	1226481868
admindb	1590756883	admindb	/weblet/dbadmin/join/detail	detail	10	detail			0		f	575ea20580e9	575e9c458002	1220341776
admindb	1591282813	admindb	/weblet/dbadmin/command/detail	detail	0	detail	showtitle : true	bottom	0		f	575ea20580c7	575e9c458006	1246350541
admindb	1440594410	admindb	/weblet/dbadmin/table/check	checkdetail	10	popup	showtitle : true,\n  sschema : 'mne_application',\n   squery : 'table_checks'		0		f	575ea20580ea	575e9c45800d	1221722756
admindb	1605511953	admindb	/weblet/allg/table/fix	index	15	bottom	schema     : 'mne_application', query : 'table_index', \ncols       : 'index,isunique,text_de,text_en,custom',\nscols      : 'index',\nshowids    : [  'schema',  'table' ],\nprimarykey : ['index'],\n\ndetailweblet : 'indexdetail'		0	admindb	f	575ea205812b	575e9c45800d	1223212325
admindb	1613985136	admindb	/weblet/sbs/domain/detail	detail	0	detail		bottom	0		f	57bab6810000	57bab6120000	1471854209
admindb	1603699904	admindb	/weblet/allg/menu/recursive	detail	0	detail	  schema : 'mne_application',\n   query : 'menu',\n    cols : "show,editname,menuid,pos,typ",\n   scols : "pos",\ndistinct : 1,\n\nshowids : ['menuname', 'parentid'],\nactioncol : '0'\n	bottom	0		f	575ea2058119	575e9c458027	1289899152
admindb	1597386810	admindb	/weblet/allg/table/fix	subweblet	10	bottom	schema : 'mne_application',\n query : 'weblet_detail',\ncols : 'htmlcomposetabid,position,subposition,depend,id,label,path,customall,ugroup',\nscols : 'position,subposition,id,depend',\nshowids : ['htmlcomposeid'],\nprimarykey : ['htmlcomposetabid'],\n\ntablehidecols : ['htmlcomposetabid'],\ndetailweblet : 'subwebletdetail',\nloaddirect : 1		0		f	575ea20581bc	575e9c45801d	1206446752
admindb	1591614356	admindb	/weblet/dbadmin/selectlist/detail	detail	0	detail	\n		0		f	575ea2058100	575e9c458028	1289986253
admindb	1614074388	admindb	/weblet/sbs/cert/detail	detail	0	detail		bottom	0		f	575ea2058212	575e9c458039	1459247454
admindb	1472537356	admindb	/weblet/allg/menu/fix	templ	30	selection	classname : 'tree', schema : 'mne_application', query : 'weblet', cols : 'template,name', showcols : 'htmlcomposeid'	detail	0		f	575ea205801c	575e9c45801d	1246439280
admindb	1589977698	admindb	/weblet/dbadmin/weblet/subwebletdetail	subwebletdetail	0	popup	\n		0		f	575ea2058131	575e9c45801d	1206446752
admindb	1613983833	admindb	/weblet/allg/table/filter	module	100	bottom	url : 'sysexec/sbs/apache/module_read',\n\ncols         : 'name,enabled',\nprimarykey   : [ 'name' ],\ntablecoltype : { enabled : 'bool' },\n\nmodurl : 'sysexec/sbs/apache/module_mod',\n\nokcols : [ 'name', 'enabled' ],\noktyps : { enabled : 'bool' },\n\n		0		f	575ea205820f	575e9c458038	1453298868
admindb	1614169343	admindb	/weblet/allg/table/filter	externca	400	bottom	tableweblet   : '/weblet/sbs/cert/certtable',\nurl           : 'sysexec/sbs/cert/cert_read',\ncols          : 'dir,data,filename,dns,valid,ca',\nshowids       : ['dir'],\nshowalias     : ['#ext'],\ntablehidecols : [ 'dir', 'data', 'dns' ],\ntablecoltype  : { filename : 'file' },\n\ndelurl        : 'sysexec/sbs/cert/cert_del',\ndelids        : [ 'dir', 'filename'],\ndelconfirmids : [ 'filename' ],\n\naddurl  : 'sysexec/sbs/cert/cert_add',\naddcols : [ 'dir', 'filename', 'data' ],\n\nmodurl  : 'sysexec/sbs/cert/cert_mod',\nokcols : [ 'dir', 'filename', 'data' ],\nokids  : [ 'dir', 'filename' ],\n\ndefvalues     : { dir : 'ext' }\n		0		f	5ca1cbff0000	575e9c458039	1554107391
admindb	1599565624	admindb	/weblet/allg/menu/fix	aggregat	100	selection	classname : 'tree',\n\nschema : 'mne_application',\nquery : 'query_cols',\ncols : 'qschema,query,unionnum',\nshowcols : 'queryid',\n\nwcol : 'groupby',\nwop : '=',\nwval : 'true'	detail	0		f	575ea205812c	575e9c458001	1306391863
admindb	1347869139	admindb	/weblet/allg/menu/fix	usertable	40	selection	'classname' : 'tree',\n      schema: 'mne_application', \n    'query' : 'usertables',\n      'cols':'text',\n  'showcols':'schema,table',\n   distinct : true	detail	0	erpdb	f	575ea205815b	575e9c45800d	1347866478
admindb	1440590358	admindb	/weblet/menu/select	menuselect	0	popup	schema : 'mne_application',\n query : 'menu_select',\nnoleaf : true,\nshowdynpar : ' "name" : "%menuname" '		0		f	575ea2058102	575e9c458027	1289910833
admindb	1589965082	admindb	/weblet/dbadmin/query/collist	collist	0	collist			0		f	575ea2058030	575e9c458001	1210075262
admindb	1347866185	admindb	/weblet/allg/menu/fix	sys	30	selection	'classname' : 'tree',\n      schema: 'mne_application', \n    'query' : 'table_all',\n      'cols':'schema,table',\n  'showcols':'schema,table',\n   distinct : true	detail	0	admindb	f	575ea2058179	575e9c45800d	1308637423
admindb	1614783774	admindb	/weblet/allg/table/filter	dnsaddress	10	bottom	css : 'sbs/domain/dns.css',\n\nurl    : 'sysexec/sbs/domain/dns_read',\naddurl : 'sysexec/sbs/domain/dns_add',\nmodurl : 'sysexec/sbs/domain/dns_mod',\ndelurl : 'sysexec/sbs/domain/dns_del',\n\ncols         : 'name,dns_record,address,fix,mac,comment,readtime,missmatch',\nprimarykey   : ['name', 'dns_record', 'address'],\ntablecoltype : { dns_record : 'selection', name : 'text', address : 'text', fix : 'bool', mac : 'text', comment : 'text' },\ntablerowstyle : ['missmatch'],\ntablerowstylecol : ['missmatch'],\n\nokids   : [ 'name', 'dns_record', 'address'],\naddcols : ['name', 'dns_record', 'address', 'fix', 'mac', 'comment'],\naddtyps : {},\n\nmodcols : ['name', 'dns_record', 'address', 'fix', 'mac', 'comment'],\nmodtyps : {},\n\ndelids : ['name', 'dns_record', 'address'],\ndeltyps : {},\ndelconfirmids : [ 'name', 'dns_record', 'address'],\n\ndefvalues : { name : '', dns_record : 'A', address : '' }\n\n		0		f	581c7ce40000	57bab6120000	1478261988
admindb	1615185249	admindb	/weblet/sbs/sogo/detail	sogo	0	bottom			0		f	580a16f70000	57bab6120000	1477056247
admindb	1591090455	admindb	/weblet/dbadmin/join/collist	secondtab	10	secondtab	notitle : false,\nselectid : 'secondtab'\n\n	detail	0		f	575ea2058050	575e9c458002	1220269084
admindb	1591341653	admindb	/weblet/dbadmin/command/result	bottom	0	bottom	showtitle : true		0		f	575ea20580ba	575e9c458006	1246351202
admindb	1597900333	admindb	/weblet/dbadmin/weblet/detail	detail	0	detail	mainweblet : true	bottom	0		f	575ea20580cf	575e9c45801d	1206446752
admindb	1589977626	admindb	/weblet/dbadmin/query/content	content	30	bottom			0		f	575ea2058008	575e9c458001	1132588439
admindb	1597385346	admindb	/weblet/allg/table/fix	sliderpos	30	bottom	schema : 'mne_application',\ntable : 'htmlcomposetabslider',\ncols : 'htmlcomposeid,slidername,sliderpos,custom',\n\nshowids : ['htmlcomposeid'],\nokids : ['slidername'],\ndelconfirmids : ['slidername'],\n\ndefvalues : { slidername : 's0' },\n\ntablehidecols : ['htmlcomposeid'],\ntablecoltype : { slidername : 'text', sliderpos : 'text' , custom : 'bool' }\n		0		f	575ea205806f	575e9c45801d	1237824787
admindb	1591257211	admindb	/weblet/allg/table/fix	access	0	bottom	??schema : 'mne_application',\n?? query : 'procedure_access',\n???? cols : 'schema,fullname,user,privilege',\nshowids : [ 'schema', 'specific_name'],\n\ntablehidecols : [ 'schema', 'fullname' ],\n??tablecoltype : { user : 'text' },\n\n?? okschema : 'mne_catalog',\nokfunction : 'pgplsql_proc_access_add',\n?????? okcols : [ 'schema', 'fullname', 'user' ],\n\n?? delfunction : 'pgplsql_proc_access_del',\n???? ???? delcols : [ 'schema', 'fullname', 'user' ],\ndelconfirmids : [ 'user' ],\n\nloaddirect : 1		0		f	575ea205813b	575e9c45801a	1222509985
admindb	1347866140	admindb	/weblet/allg/table/fix	foreign	30	bottom	schema : 'mne_application',\n query : 'table_fkeys',\n distinct : true,\n cols : 'schema,table,name,rschema,rtable,text_de,text_en,custom',\n\n tablehidecols: [ 'schema', 'table' ],\n\nshowids  : [  'schema',  'table'  ],\n \ndetailweblet : 'foreigndetail'		0	admindb	f	575ea2058178	575e9c45800d	1221555822
admindb	1427952927	admindb	/weblet/basic/count	count	0	count			0		f	575ea20581e2	575e9c458013	1427952927
admindb	1591603931	admindb	/weblet/dbadmin/menu/detail	bottom	0	bottom			0		f	575ea205811a	575e9c458027	1289901272
admindb	1547548771	admindb	/weblet/dbadmin/table/fkey	foreigndetail	10	popup			0		f	575ea2058137	575e9c45800d	1221728783
admindb	1620368154	admindb	/weblet/allg/table/filter	certs	200	bottom	tableweblet   : '/weblet/sbs/cert/certtable',\nurl           : 'sysexec/sbs/cert/cert_read',\ncols          : 'dir,data,filename,dns,valid,ca',\nshowids       : ['dir'],\nshowalias     : ['#crt'],\ntablehidecols : [ 'dir', 'data' ],\n\ndelurl        : 'sysexec/sbs/cert/cert_del',\ndelids        : [ 'dir', 'filename'],\ndelconfirmids : [ 'filename' ],\n\nloaddirect : 1\n	csrs,keys	0		f	575ea2058218	575e9c458039	1459515940
admindb	1620389672	admindb	/weblet/allg/table/filter	csrs	250	bottom	tableweblet : '/weblet/sbs/cert/certtable',\nurl : 'sysexec/sbs/cert/cert_read',\ncols : 'dir,data,filename,dns,valid,ca',\nshowids : ['dir'],\nshowalias : ['#csr'],\ntablehidecols : [ 'dir', 'data', 'valid', 'ca' ],\ntablecoltype : { filename : 'file' },\n\naddurl : 'sysexec/sbs/cert/cert_add',\naddcols : [ 'dir', 'filename', 'data' ],\n\nmodurl : 'sysexec/sbs/cert/cert_mod',\nokcols : [ 'dir', 'filename', 'data' ],\nokids : [ 'dir', 'filename' ],\n\n\ndelurl : 'sysexec/sbs/cert/cert_del',\ndelids : [ 'dir', 'filename'],\ndelconfirmids : [ 'filename' ],\n\ndefvalues : { dir : 'csr' }\n	certs,keys	0		f	575ea2058215	575e9c458039	1459840832
admindb	1420729368	admindb	/weblet/dbadmin/table/content	content	100	bottom	showdynpar : '"schema" : "schema", "table" : "table"',\nshowdynparweblet : 'detail',\n\npopup : 'contentedit',\nno_vals : false,\nnotclose : true,\n\nignore_notdefined : true		0		f	575ea20581d8	575e9c45800d	1221469373
admindb	1466414716	admindb	/weblet/basic/message	message	0	popup			0		f	575ea2058010	575e9c458013	1427952906
admindb	1597657792	admindb	/weblet/allg/table/select	search	90	selection	schema : 'mne_application', \n query : 'weblet_detail',\n\n    cols : 'htmlcomposeid,id,path,initpar',\nshowcols : 'htmlcomposeid',\n\ntablehidecols : [ 'htmlcomposeid' ],\n\nselectok : (res) => { var self = s.composeparent.obj.weblets[s.id];\n                      var i; for ( i in res.ids ) self.obj.run.values[res.ids[i]] = res.values[0][i];\n                      self.newselect = true }\n	detail	0		f	575ea205819a	575e9c45801d	1400059224
admindb	1589965925	admindb	/weblet/dbadmin/query/column	column	10	bottom	loaddirect : 1		0		f	575ea2058207	575e9c458001	1210872151
admindb	1615902527	admindb	/weblet/allg/table/filter	cert	200	bottom	tableweblet : '/weblet/sbs/cert/certtable',\nurl : 'sysexec/sbs/cert/cert_read',\ncols : 'dir,data,filename,dns,valid,ca',\nshowids : ['dir'],\nshowalias : ['#crt'],\ntablehidecols : [ 'dir', 'data' ],\n\ndelurl : 'sysexec/sbs/cert/cert_del',\ndelids : [ 'dir', 'filename'],\ndelconfirmids : [ 'filename' ],\n		0		f	575ea2058214	575e9c458038	1457702905
admindb	1612338359	admindb	/weblet/sbs/apache/detail	detail	0	detail			0		f	575ea205820e	575e9c458038	1453800703
admindb	1615903050	admindb	/weblet/allg/table/filter	site	0	bottom	tableweblet  : '/weblet/sbs/apache/sitetable',\nurl          : 'sysexec/sbs/apache/site_read',\n\ncols         : 'name,enabled,domain,aliases,email,documentroot,conf,httpsonly,renewcert',\nprimarykey   : [ 'name' ],\ntablecoltype : { name : 'text', enabled : 'bool', domain : 'text', aliases : 'text', email : 'text', documentroot : 'text', conf : 'mtext', httpsonly : 'bool', renewcert : 'bool' },\n\naddurl : 'sysexec/sbs/apache/site_add',\nmodurl : 'sysexec/sbs/apache/site_mod',\ndelurl : 'sysexec/sbs/apache/site_del',\n\nokids        : [ 'name' ],\nokcols       : [ 'name', 'enabled', 'domain', 'aliases', 'email', 'documentroot', 'conf', 'httpsonly', 'renewcert' ],\noktyps       : { renewcert : 'bool', httpsonly : 'bool' },\n\ndelids       : [ 'name' ],\ndeltyps      : {},\ndelconfirmids : [ 'name'],\n\ndefvalues : { name : '' },\n\nloaddirect : true		0		f	575ea2058210	575e9c458038	1453807783
admindb	1610121067	admindb	/weblet/main/menu	menu	0	menu	weblet : 'detail'	detail	0		f	575e9c458014	575e9c458013	1585893280
admindb	1616743255	admindb	/weblet/allg/table/fix	bottom	0	bottom	url    : 'sysexec/sbs/share/user_read',\naddurl : 'sysexec/sbs/share/user_add',\nmodurl : 'sysexec/sbs/share/user_mod',\ndelurl : 'sysexec/sbs/share/user_del',\n\ncols    : 'login,fullname,rw',\ntablecoltype : { login : 'text', rw : 'bool' },\n\nshowids : [ 'share' ],\nokids   : [ 'login' ],\n\ndelids  : [ 'login', 'share' ],\ndelconfirmids : [ 'fullname'],\n\ndefvalues : { login : '', fullname : '', rw : false },\n\nloaddirect : 1		0		f	605b14ac8000	605475c38000	1616581804
admindb	1620368191	admindb	/weblet/allg/table/filter	keys	300	bottom	tableweblet   : '/weblet/sbs/cert/certtable',\nurl           : 'sysexec/sbs/cert/cert_read',\ncols          : 'dir,data,filename,dns,valid,ca',\nshowids       : ['dir'],\nshowalias     : ['#key'],\ntablehidecols : [ 'dir', 'data', 'dns', 'valid', 'ca' ],\n\ndelurl        : 'sysexec/sbs/cert/cert_del',\ndelids        : [ 'dir', 'filename'],\ndelconfirmids : [ 'filename' ],\n	certs,csrs	0		f	575ea2058217	575e9c458039	1459840726
admindb	1616579317	admindb	/weblet/allg/menu/rselect	locationselect	0	popup	url    : 'sysexec/sbs/share/location_read',\naddurl : 'sysexec/sbs/share/location_add',\nmodurl : 'sysexec/sbs/share/location_mod',\ndelurl : 'sysexec/sbs/share/location_del',\n\ncols : 'action,item,menuid,typ,pos',\nscols : 'pos',\nshowcols : 'menuid',\n\nwcol : 'typ,parentid',\nwop  : '=,=',\nwval : ',',\n\nloaddirect : 1		0		f	6054b1c38000	605475c38000	1616163267
admindb	1616741429	admindb	/weblet/allg/table/frame	userselect	0	popup	url : 'sysexec/sbs/user/select_read',\ncols : 'fullname',\nshowcols : 'sAMAccountName'\n		0		f	605d83d08000	605475c38000	1616741328
admindb	1653028423	admindb	/weblet/allg/table/select	deviceselect	0	popup	url : 'sysexec/sbs/network/devices_read',\ncols : 'device,netaddrtyp,netaddr6,netaddr,netbcast,netgateway,dnsnameserver,dnssearch,wlan,wlanpass,wlanhidden,readtime',\nshowcols : 'device',\n\ntablehidecols : 'netaddrtyp,netaddr6,netaddr,netbcast,netgateway,dnsnameserver,dnssearch,wlanpass,wlanhidden,readtime'.split(','),\n		0		f	6034b0ee8000	57bab6120000	1614065902
\.


--
-- Data for Name: htmlcomposetabnames; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.htmlcomposetabnames (createdate, createuser, modifydate, modifyuser, label_en, label_de, custom, htmlcomposetabid, htmlcomposeid) FROM stdin;
1615529315	admindb	1615796952	admindb			f	604b05638000	604718218000
1226313601	admindb	1359387171	admindb	user settings	Benutzereinstellungen	f	575ea205804c	575e9c458034
1471854209	admindb	1613985136	admindb	domain	Domain	f	57bab6810000	57bab6120000
1220269084	admindb	1591090455	admindb	second table columns	zweite Tabelle Spalten	f	575ea2058050	575e9c458002
1611578071	admindb	1611648963	admindb	actual network	aktuelles Netzwerk	f	600ebad78000	600e93548000
1615272160	admindb	1615283099	admindb	User	Benutzer	f	604718e08000	604718218000
1615273142	admindb	1615382298	admindb	user	Benutzer	f	60471cb68000	604718218000
1611750906	admindb	1611903530	admindb	devices	Schnittstellen	f	60115dfa8000	600e93548000
1220006312	admindb	1589977698	admindb	subweblet detail	Subwebletdetail	f	575ea2058131	575e9c45801d
1226394770	admindb	1603794891	admindb	selection tables	Selektionstabellen	f	575ea20580bf	575e9c45801d
1615882139	admindb	1615983542	admindb	email addresses	Mailadressen	f	6050679b8000	604718218000
1291107125	admindb	1596541380	admindb	columns	Spalten	f	575ea2058107	575e9c45800d
1616148011	admindb	1616151099	admindb	all shares	Alle Freigaben	f	6054762b8000	605475c38000
1210872313	admindb	1589975191	admindb	where	Where	f	575ea2058043	575e9c458001
1220557163	admindb	1347866180	admindb	tables	Tabellen	f	575ea205802e	575e9c45800d
1220255283	admindb	1314366705	admindb	all	Alle	f	575ea20580e4	575e9c45801d
1246439280	admindb	1472537356	admindb	by template	nach Template	f	575ea205801c	575e9c45801d
1210872313	admindb	1597386810	admindb	subweblet	Subweblet	f	575ea20581bc	575e9c45801d
1210075262	admindb	1589965082	admindb	table	Tabelle	f	575ea2058030	575e9c458001
1237824787	admindb	1589783246	admindb	slider positions	Sliderpositionen	f	575ea205806f	575e9c45801d
1246350541	admindb	1591282813	admindb	execute sql	Sql Komando ausf??hren	f	575ea20580c7	575e9c458006
1220254721	admindb	1597900333	admindb	weblet	Weblet	f	575ea20580cf	575e9c45801d
1220341776	admindb	1590756883	admindb	join detail	Join Details	f	575ea20580e9	575e9c458002
1246351202	admindb	1591341653	admindb	result	Ergebnis	f	575ea20580ba	575e9c458006
1206451053	admindb	1599565653	admindb	query	Abfrage	f	575ea20580b9	575e9c458001
1611675072	admindb	1614169478	admindb	addresses	Addressen	f	601035c08000	600e93548000
1615460080	admindb	1615896362	admindb	member of groups	Gruppenzugeh??rigkeit	f	6049f6f08000	604718218000
1276678196	admindb	1605600034	admindb	password	Password	f	575ea205808c	575e9c458034
1223408722	admindb	1223408722	admindb	index	Index	f	575ea2058098	575e9c45800d
1221574895	admindb	1347866119	admindb	primary key	Primary Key	f	575ea2058041	575e9c45800d
1222088958	admindb	1347866145	admindb	access	Rechte	f	575ea20580b8	575e9c45800d
1236677737	admindb	1236678650	admindb	edit join	Join bearbeiten	f	575ea2058095	575e9c458001
1208860001	admindb	1589965289	admindb	joins	Joins	f	575ea205806d	575e9c458001
1220269132	admindb	1590669789	admindb	second table	zweite Tabelle	f	575ea20580d3	575e9c458002
1222509985	admindb	1591257211	admindb	access	Rechte	f	575ea205813b	575e9c45801a
1222163144	admindb	1591188671	admindb	procedure	Prozedur	f	575ea20580d2	575e9c45801a
1210872313	admindb	1599565619	admindb	tables	Tabellen	f	575ea20580a9	575e9c458001
1615473527	admindb	1615896378	admindb	password	Password	f	604a2b778000	604718218000
1221555822	admindb	1347866140	admindb	foreign keys	Foreign Keys	f	575ea2058178	575e9c45800d
1221728783	admindb	1547548771	admindb	foreign keys	Foreign Keys	f	575ea2058137	575e9c45800d
1221503696	admindb	1542279038	admindb	check constraints	Check Constraints	f	575ea2058177	575e9c45800d
1221722756	admindb	1440594410	admindb	check constraint	Check Constraint	f	575ea20580ea	575e9c45800d
1306391863	admindb	1599565624	admindb	querys with aggregate functions	Abfragen mit Aggregatfunktionen	f	575ea205812c	575e9c458001
1220276304	admindb	1590760142	admindb	joins	Joins	f	575ea20580c6	575e9c458002
1289901272	admindb	1591603931	admindb	menu item	Men??element	f	575ea205811a	575e9c458027
1223212325	admindb	1605511953	admindb	indexes	Index	f	575ea205812b	575e9c45800d
1206446752	admindb	1599565612	admindb	querys	Abfragen	f	575ea20580ae	575e9c458001
1291107024	admindb	1597749086	admindb	table	Tabelle	f	575ea20580f0	575e9c45800d
1289899152	admindb	1603699904	admindb	menu	Men??	f	575ea2058119	575e9c458027
1269608549	admindb	1472537380	admindb	customized	Angepasst	f	575ea205804b	575e9c45801d
1289899033	admindb	1540557410	admindb	all	Alle	f	575ea20580e3	575e9c458027
1222162435	admindb	1547561906	admindb	all procedures	Alle Prozeduren	f	575ea205810e	575e9c45801a
1347866478	admindb	1347869139	admindb	user table	Benutzertabellen	f	575ea205815b	575e9c45800d
1308637423	admindb	1347866185	admindb	with system tables	Mit Systemtabellen	f	575ea2058179	575e9c45800d
1289984584	admindb	1591609080	admindb	all	Alle	f	575ea2058074	575e9c458028
1220268917	admindb	1597663569	admindb	first table columns	erste Tabelle Spalten	f	575ea20580c1	575e9c458002
1289986253	admindb	1591614356	admindb	list	Liste	f	575ea2058100	575e9c458028
1453800703	admindb	1612338359	admindb	apache port configuration	Apache Port Konfiguration	f	575ea205820e	575e9c458038
1615536683	admindb	1615802808	admindb	groups	Gruppen	f	604b222b8000	604718218000
1457702905	admindb	1615902527	admindb	certificates	Zertifikate	f	575ea2058214	575e9c458038
1453807784	admindb	1615903050	admindb	sites	Seiten	f	575ea2058210	575e9c458038
1453298868	admindb	1613983833	admindb	modules	Modules	f	575ea205820f	575e9c458038
1427952927	admindb	1427952927	admindb			f	575ea20581e2	575e9c458013
1210872151	admindb	1589965925	admindb	columns	Spalten	f	575ea2058207	575e9c458001
1400059224	admindb	1597657792	admindb	search	Suchen	f	575ea205819a	575e9c45801d
1221469374	admindb	1420729368	admindb	content	Inhalt	f	575ea20581d8	575e9c45800d
1427952906	admindb	1466414716	admindb	logfile	Logdatei	f	575ea2058010	575e9c458013
1226481868	admindb	1472537003	admindb	by path	nach Path	f	575ea20580a0	575e9c45801d
1459247454	admindb	1614074388	admindb	certification authority	Zertifizierungsstelle	f	575ea2058212	575e9c458039
1616151095	admindb	1616583522	admindb	share	Freigabe	f	605482378000	605475c38000
1459515940	admindb	1620368154	admindb	certificates	Zertifikate	f	575ea2058218	575e9c458039
1459840833	admindb	1620389672	admindb	certificate requests	Zertifikat Requests	f	575ea2058215	575e9c458039
1554107391	admindb	1614169343	admindb	certificate authority	Zertifizierungsstellen	f	5ca1cbff0000	575e9c458039
1308646210	admindb	1347866190	admindb	views	Sichten	f	575ea2058156	575e9c45800d
1478261988	admindb	1614783774	admindb	dns	DNS	f	581c7ce40000	57bab6120000
1289910833	admindb	1440590358	admindb	menu	Men??	f	575ea2058102	575e9c458027
1477056247	admindb	1615185249	admindb	groupware	Groupware	f	580a16f70000	57bab6120000
1220269859	admindb	1589977626	admindb	content	Inhalt	f	575ea2058008	575e9c458001
1220269177	admindb	1590669707	admindb	first table	erste Tabelle	f	575ea20580de	575e9c458002
1616163267	admindb	1616579317	admindb	select folder	Verzeichnis ausw??hlen	f	6054b1c38000	605475c38000
1616741328	admindb	1616741429	admindb	select user	Benutzer ausw??hlen	f	605d83d08000	605475c38000
1616581804	admindb	1616743255	admindb	user	Benutzer	f	605b14ac8000	605475c38000
1459840726	admindb	1620368191	admindb	keys	Schl??ssel	f	575ea2058217	575e9c458039
1614065902	admindb	1653028423	admindb	network device	Netzwerkadapter	f	6034b0ee8000	57bab6120000
\.


--
-- Data for Name: htmlcomposetabselect; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.htmlcomposetabselect (createdate, createuser, modifydate, modifyuser, id, element, schema, query, tab, wop, wcol, wval, scols, showcols, cols, weblet, showids, custom, selval, htmlcomposetabselectid, htmlcomposeid, type, showalias) FROM stdin;
1612279512	admindb	1612283173	admindb	bottom	parentname,parentid	mne_application	menu					pos	item,menuid	action,item,menuid,typ,pos		menuname,typ,parentid	f	\N	60196ed80000	575e9c458027	rmenu	[ () => { return this.config.dependweblet.config.dependweblet.obj.run.values.menuname }, () => { return '' } ]
1614065698	admindb	1614066237	admindb	detail	netdevice								device		deviceselect		f	\N	6034b0220000	57bab6120000	weblet	
1615529217	admindb	1615796657	admindb	group	!memberOf								sAMAccountName	sAMAccountName	groupselect		f	\N	604b05010000	604718218000	fweblet	
1547548983	admindb	1547549116	admindb	access	user	mne_application	user		not like	name	pg_%	name	name	name			f	0	5c3db9370001	575e9c45800d	frame	
1616163222	admindb	1616409626	admindb	detail	location								menuid		locationselect		f	\N	6054b1960000	605475c38000	weblet	
1591188431	admindb	1591188505	admindb	detail	ownername	mne_application	user		like,olike	name,name	admin%,erp%	name	name	name			f	\N	5ed79bcf0000	575e9c45801a	table	
1516289258	admindb	1516289258	admindb	detail	owner	mne_application	user		(like,olike)	name,name	erp%,admin%	name	name	name			f	0	5a60bcea0001	575e9c45800d	table	
1516291535	admindb	1516291535	admindb	detail	schema,?schema,?fullname	mne_application	procedure					schema,fullname	schema,schema,fullname	schema,fullname			f	1	5a60c5cf0000	575e9c45801a	table	
1516289258	admindb	1599800918	admindb	detail	schema,?schema,?table	mne_application	table_all					schema,table	schema,schema,table	schema,table			f	1	5a60bcea0000	575e9c45800d	fmenu	
1516290904	admindb	1516290925	admindb	detail	schema,?queryid	mne_application		queryname				schema,query	schema,queryid	schema,query			f	1	5a60c3580000	575e9c458001	table	
1591196902	admindb	1591196902	admindb	access	user	mne_application	user		like,olike	name,name	admin%,erp%	name	name	name			f	\N	5ed7bce60000	575e9c45801a	frame	
1589546895	admindb	1600775016	admindb	detail	name,?htmlcomposeid	mne_application	weblet_all					id	name,htmlcomposeid	schema,name			f	\N	5ebe8f8f0000	575e9c45801d	fmenu	
1289926302	admindb	1591608669	admindb	bottom	ugroup	mne_application	group					group	group	group			f	0	575ea30c807f	575e9c458027	table	
1271679254	admindb	1591682097	admindb	detail	startwebletname,startweblet	mne_application	weblet_all		<>,<>	schema,schema	dbadmin,main	label	label,name	label			f	0	575ea30c8080	575e9c458034	table	
1478862575	admindb	1478862575	admindb	dnsaddress	record	mne_application		selectlist	=	name	dns_record	value	value,text_de	value,text_de			f	\N	5825a6ef0000	57bab6120000	table	
1547548983	admindb	1599800918	admindb	foreigndetail	rschema,rtable	mne_application	table_all					schema,table	schema,table	schema,table			f	\N	5c3db9370000	575e9c45800d	fmenu	
1449498201	admindb	1449502674	admindb	detail	timezone	mne_catalog		pg_timezone_names				name	name	name			f	\N	575ea30c8112	575e9c458034	table	
1226408838	admindb	1589787671	admindb	webletselect	id	mne_application		htmlcomposetab				id	id	id		htmlcomposeid	f	\N	575ea30c8050	575e9c45801d	frame	
1616741201	admindb	1616743085	admindb	bottom	!login,fullname								sAMAccountName,fullname		userselect		f	\N	605d83510000	605475c38000	fweblet	
\.


--
-- Data for Name: htmlcomposetabslider; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.htmlcomposetabslider (createdate, createuser, modifydate, modifyuser, sliderpos, slidername, custom, htmlcomposeid) FROM stdin;
1453804496	admindb	1453805037	admindb	180px	s0	f	575e9c458038
1589782258	admindb	1589786103	admindb	33%	s2	f	575e9c45801d
1591609215	admindb	1591609326	admindb	20%	s0	f	575e9c458028
1600261081	admindb	1600261081	admindb	70%	s1	f	575e9c45801a
\.


--
-- Data for Name: joindef; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.joindef (createdate, createuser, modifydate, modifyuser, tcols, ttab, fcols, ftab, typ, fschema, tschema, joindefid, op) FROM stdin;
1553766008	admindb	1553766008	admindb	certcaid	certca	sogoid	sogo	1	mne_system	mne_system	5c9c96780000	=
1310562742	admindb	1310562742	admindb	personid	person	refid	file	1	mne_crm	mne_crm	4e1d99b60000	=
1597846752	admindb	1597846752	admindb	orderid	order	orderid	personorder	0	mne_crm	mne_crm	5f3d34e00000	=
1597902655	admindb	1597902655	admindb	offerid	offer	offerid	personoffer	1	mne_crm	mne_crm	5f3e0f3f0000	=
1603109426	admindb	1603109426	admindb	law	workphase	law	order	1	mne_hoai	mne_hoai	5f8d82320000	=
1605166738	admindb	1605166738	admindb		selectlist		time	1	mne_builddiary	mne_application	5face6920000	#0.weather = #1.value AND #1.name = 'builddiary_weather'
1606146814	admindb	1606146814	admindb		timemanagement_param		timemanagement	1	mne_personnal	mne_personnal	5fbbdafe0000	#1.timemanagement_paramid = ''
1605174468	admindb	1605174468	admindb		selectlist		present	1	mne_builddiary	mne_application	5fad04c40000	#0.typ = #1.value::INTEGER AND #1.name = 'builddiary_presenttype'
1591098442	admindb	1591098442	admindb	test1id	test1	testid	test	1	public	public	5ed63c4a0000	=
1591597093	admindb	1591597093	admindb	menuid	menu_child	menuid	menu	0	mne_application	mne_application	5eddd8250000	=
1605105026	admindb	1605105026	admindb	timeid	time	timeid	time	1	mne_personnal	mne_builddiary	5fabf5820000	=
1591700936	admindb	1591700936	admindb		selectlist		companydata	0	mne_crm	mne_application	5edf6dc80000	#0.categorie = #1.value AND #1.name = 'companycategorie'
1284379789	admindb	1284379789	admindb	bugid	bug	bugid	bugtree	1	mne_support	mne_support	4c8e148d0000	=
1348035369	admindb	1348035369	admindb		companyown		skill	1	mne_personnal	mne_crm	505963290000	#1.prefix = ''
1348490584	admindb	1348490584	admindb	timeid	time	timeid	invoicetime	1	mne_shipment	mne_personnal	506055580000	=
1348490611	admindb	1348490611	admindb	invoiceid	invoice	invoiceid	invoicetime	1	mne_shipment	mne_shipment	506055730000	=
1447325192	admindb	1447325192	admindb	parentid	menu	menuid	menu	1	mne_application	mne_application	56446e080000	=
1348668124	admindb	1348668124	admindb	orderproductid	deliverynoteproduct	orderproductid	orderproduct	1	mne_crm	mne_shipment	50630adc0000	=
1348668316	admindb	1348668316	admindb	deliverynoteid	deliverynote	deliverynoteid	deliverynoteproduct	1	mne_shipment	mne_shipment	50630b9c0000	=
1447325572	admindb	1447325572	admindb		pg_auth_members		pg_roles	1	pg_catalog	pg_catalog	56446f840000	#0.oid = #1.roleid
1449145844	admindb	1449145844	admindb		yearday		personowndatapublic	1	mne_personnal	mne_application	566035f40000	true
1258547347	admindb	1258547347	admindb	oid	pg_class	typrelid	pg_type	1	pg_catalog	pg_catalog	4b03e8930000	=
1258634590	admindb	1258634590	admindb	partid	part	subpartid	partsubpart	1	mne_warehouse	mne_warehouse	4b053d5e0000	=
1301383804	admindb	1301383804	admindb	userid	time	personid	personowndata	1	mne_personnal	mne_personnal	4d918a7c0000	=
1301673859	admindb	1301673859	admindb	userid	time	personid	person	1	mne_crm	mne_personnal	4d95f7830000	=
1453820723	admindb	1453820723	admindb		apache		apachesites	1	mne_system	mne_system	56a78b330000	true
1453820738	admindb	1453820738	admindb		apache		apachemod	1	mne_system	mne_system	56a78b420000	true
1259922725	admindb	1259922725	admindb	storageid	storage	storageid	storagelocation	1	mne_warehouse	mne_warehouse	4b18e5250000	=
1267000088	admindb	1267000088	admindb	orderproductid	orderproduct	orderproductid	orderproductpart	1	mne_warehouse	mne_crm	4b84e3180000	=
1267104531	admindb	1267104531	admindb	partstoragelocationid	partstoragelocation	spartstoragelocationid	partoutgoing	1	mne_warehouse	mne_warehouse	4b867b130000	=
1267171562	admindb	1267171562	admindb	relocationid	relocation	relocationid	partoutgoing	1	mne_warehouse	mne_warehouse	4b8780ea0000	=
1269944296	admindb	1269944296	admindb	personid	personowndata	personid	person	1	mne_crm	mne_personnal	4bb1cfe80000	=
1136213033	admindb	1154933009	admindb		address		person	1	mne_crm	mne_crm	43b93c290001	/* haupt */ #0.personid = #1.refid AND #1.addresstypid = '000000000001'
1270127406	admindb	1270127406	admindb		address		company	1	mne_crm	mne_crm	4bb49b2e0000	/* bestellung */ ( #1.refid = #0.companyid AND CAST ( #1.addresstypid AS INTEGER ) = ( SELECT MAX(CAST( addresstypid AS INTEGER )) FROM mne_crm.address a WHERE refid = #1.refid AND CAST(a.addresstypid AS INTEGER ) IN (1,50) ))
1280378899	admindb	1280378899	admindb		fee		feename	1	mne_hoai	mne_hoai	4c5108130000	#0.feenameid = #1.law AND #1.zone = 1
1280379063	admindb	1280379063	admindb		fee		feename	1	mne_hoai	mne_hoai	4c5108b70000	#0.feenameid = #1.law AND #1.zone = 2
1280379072	admindb	1280379072	admindb		fee		feename	1	mne_hoai	mne_hoai	4c5108c00000	#0.feenameid = #1.law AND #1.zone = 3
1280379082	admindb	1280379082	admindb		fee		feename	1	mne_hoai	mne_hoai	4c5108ca0000	#0.feenameid = #1.law AND #1.zone = 4
1280379094	admindb	1280379094	admindb		fee		feename	1	mne_hoai	mne_hoai	4c5108d60000	#0.feenameid = #1.law AND #1.zone = 5
1271663570	admindb	1271663570	admindb	username	userpref	username	userpref	1	mne_application	mne_personnal	4bcc0bd20000	=
1271831341	admindb	1271831341	admindb	skillid	personskill	skillid	orderproducttime	1	mne_personnal	mne_personnal	4bce9b2d0000	=
1271837633	admindb	1271837633	admindb	companyid	companyown	companyid	company	1	mne_crm	mne_crm	4bceb3c10000	=
1265294067	admindb	1265294067	admindb	partingoingid	partstoragelocationsum	partingoingid	partingoing	1	mne_warehouse	mne_warehouse	4b6adaf30000	=
1265294382	admindb	1265294382	admindb	partingoingid,partstoragelocationid	partstoragelocation	partingoingid,partstoragelocationid	partingoing	1	mne_warehouse	mne_warehouse	4b6adc2e0000	=,=
1263199234	admindb	1263199234	admindb	skillid	skill	skillid	offerproducttime	1	mne_personnal	mne_personnal	4b4ae4020000	=
1263199946	admindb	1263199946	admindb	offerproductid	offerproducttime	offerproductid	offerproduct	1	mne_crm	mne_personnal	4b4ae6ca0000	=
1263202118	admindb	1263202118	admindb	productid	producttime	productid	product	1	mne_crm	mne_personnal	4b4aef460000	=
1263284728	admindb	1263284728	admindb		selectlist		offerprobability	1	mne_crm	mne_application	4b4c31f80000	#0.probability = CAST (#1.value AS INTEGER) AND #1.name = 'offerprobability'
1263289230	admindb	1263289230	admindb	offernumber	offerprobability	offernumber	offer	1	mne_crm	mne_crm	4b4c438e0000	=
1263291242	admindb	1263291242	admindb	offerid	offerproduct	offerid	offer	1	mne_crm	mne_crm	4b4c4b6a0000	=
1280468172	admindb	1280468696	admindb		workphase		workphase	1	mne_hoai	mne_hoai	4c5264cc0000	#0.law = #1.law AND #1.phase = 1
1280468197	admindb	1280468707	admindb		workphase		workphase	1	mne_hoai	mne_hoai	4c5264e50000	 #0.law = #1.law AND #1.phase = 2
1280468208	admindb	1280468715	admindb		workphase		workphase	1	mne_hoai	mne_hoai	4c5264f00000	#0.law = #1.law AND #1.phase = 3
1280468216	admindb	1280468723	admindb		workphase		workphase	1	mne_hoai	mne_hoai	4c5264f80000	#0.law = #1.law AND #1.phase = 4
1280468224	admindb	1280468730	admindb		workphase		workphase	1	mne_hoai	mne_hoai	4c5265000000	#0.law = #1.law AND #1.phase = 5
1280468235	admindb	1280468742	admindb		workphase		workphase	1	mne_hoai	mne_hoai	4c52650b0000	#0.law = #1.law AND #1.phase = 6
1280468242	admindb	1280468749	admindb		workphase		workphase	1	mne_hoai	mne_hoai	4c5265120000	#0.law = #1.law AND #1.phase = 7
1267602242	admindb	1267602242	admindb	relocationid	partoutgoing	relocationid	relocation	1	mne_warehouse	mne_warehouse	4b8e13420000	=
1318347849	admindb	1318347849	admindb	uid	file	letterid	letter	1	mne_base	mne_crm	4e9464490000	=
1267646694	admindb	1267646694	admindb	storagelocationid	partstorageloction_sum	storagelocationid	storagelocation	1	mne_warehouse	mne_warehouse	4b8ec0e60000	=
1267706901	admindb	1267706901	admindb	partid	part	partid	orderproductpart	1	mne_warehouse	mne_warehouse	4b8fac150000	=
1267713324	admindb	1267713324	admindb	partid	part	partid	offerproductpart	1	mne_warehouse	mne_warehouse	4b8fc52c0000	=
1267728444	admindb	1267728444	admindb	partid	part	partid	productpart	1	mne_warehouse	mne_warehouse	4b90003c0000	=
1269892514	admindb	1269892514	admindb	partid	part_sum	partid	part	1	mne_warehouse	mne_warehouse	4bb105a20000	=
1257837396	admindb	1257837396	admindb	storagelocationtypid	storagelocationtyp	storagelocationtypid	storagelocation	1	mne_warehouse	mne_warehouse	4af913540000	=
1257837428	admindb	1257837428	admindb	storagetypid	storagetyp	storagetypid	storage	1	mne_warehouse	mne_warehouse	4af913740000	=
1257837622	admindb	1257837622	admindb	storagelocationtypid	storagelocationtyp	storagelocationtypid	storage	1	mne_warehouse	mne_warehouse	4af914360000	=
1140424132	admindb	1140424132	admindb		pg_type		pg_proc	1	pg_catalog	pg_catalog	43f97dc40000	#0.prorettype = #1.oid
1258446883	admindb	1258446883	admindb	partid	part	partid	partstoragemasterdata	1	mne_warehouse	mne_warehouse	4b0260230000	=
1258446898	admindb	1258446898	admindb	partid	partstoragemasterdata	partid	part	1	mne_warehouse	mne_warehouse	4b0260320000	=
1264759740	admindb	1264759740	admindb		storagepersonnal		storage	1	mne_warehouse	mne_warehouse	4b62b3bc0000	#0.storageid = #1.storageid OR #1.storageid IS NULL
1265013267	admindb	1265013267	admindb	storagelocationid	storagelocation	newstoragelocationid	relocation	1	mne_warehouse	mne_warehouse	4b6692130000	=
1265013304	admindb	1265013304	admindb	personid	person	personid	relocation	1	mne_warehouse	mne_crm	4b6692380000	=
1265014176	admindb	1265014176	admindb	partstoragelocationid	partstoragelocation	partstoragelocationid	relocation	1	mne_warehouse	mne_warehouse	4b6695a00000	=
1265028731	admindb	1265028731	admindb	partid	part	partid	partstoragelocationmasterdata	1	mne_warehouse	mne_warehouse	4b66ce7b0000	=
1280378863	admindb	1280378863	admindb	law	fee	feenameid	feename	1	mne_hoai	mne_hoai	4c5107ef0000	=
1265028745	admindb	1265028745	admindb	storagelocationtypid	storagelocationtyp	storagelocationtypid	partstoragelocationmasterdata	1	mne_warehouse	mne_warehouse	4b66ce890000	=
1265211771	admindb	1265211771	admindb	partingoingid	partingoing	partingoingid	partstoragelocation	1	mne_warehouse	mne_warehouse	4b69997b0000	=
1265212726	admindb	1265212726	admindb	newstoragelocationid	relocation	storagelocationid	storagelocation	1	mne_warehouse	mne_warehouse	4b699d360000	=
1136193874	admindb	1136193874	admindb	refid	person	companyid	company	1	mne_crm	mne_crm	43b8f1520004	=
1144689069	admindb	1144689069	admindb	orderid	order	orderid	orderproduct	1	mne_crm	mne_crm	443a91ad0000	=
1145622912	admindb	1145622912	admindb	orderid	orderproduct	orderid	order	1	mne_crm	mne_crm	4448d1800000	=
1147095219	admindb	1147095219	admindb	personid	person	contactid	offer	1	mne_crm	mne_crm	445f48b30000	=
1147247555	admindb	1147247555	admindb	personid	person	contactid	order	1	mne_crm	mne_crm	44619bc30000	=
1153738328	admindb	1153738328	admindb	personid	person	refid	offer	1	mne_crm	mne_crm	44c4a6580000	=
1153812087	admindb	1153812087	admindb	personid	person	refid	order	1	mne_crm	mne_crm	44c5c6770000	=
1110181936	admindb	1110189977	admindb	persondataid	persondata	personid	person	1	mne_crm	mne_crm	422c08300001	=
1322468495	admindb	1322468495	admindb	personid	person	ownerid	purchase	1	mne_warehouse	mne_crm	4ed3448f0000	=
1280468255	admindb	1280468755	admindb		workphase		workphase	1	mne_hoai	mne_hoai	4c52651f0000	#0.law = #1.law AND #1.phase = 8
1280468267	admindb	1280468767	admindb		workphase		workphase	1	mne_hoai	mne_hoai	4c52652b0000	#0.law = #1.law AND #1.phase = 9
1280469170	admindb	1280469170	admindb	feenameid	feename	law	workphase	1	mne_hoai	mne_hoai	4c5268b20000	=
1263300110	admindb	1263300110	admindb	offernumber,version	offer	offernumber,version	offermax	0	mne_crm	mne_crm	4b4c6e0e0000	=,=
1263480765	admindb	1263480765	admindb	productid	product	productid	productpart	1	mne_warehouse	mne_crm	4b4f2fbd0000	=
1318433200	admindb	1318433200	admindb	loginname	personowndatapublic	username	userpref	1	mne_application	mne_personnal	4e95b1b00000	=
1318433302	admindb	1318433302	admindb	personid	person	personid	personowndatapublic	1	mne_personnal	mne_crm	4e95b2160000	=
1263480783	admindb	1263480783	admindb	productid	productpart	productid	product	1	mne_crm	mne_warehouse	4b4f2fcf0000	=
1263495809	admindb	1263495809	admindb	offerproductid	offerproductpart	offerproductid	offerproduct	1	mne_crm	mne_warehouse	4b4f6a810000	=
1267525029	admindb	1267525029	admindb	partid	partvendor	partid	part	1	mne_warehouse	mne_warehouse	4b8ce5a50000	=
1263501024	admindb	1263501024	admindb		selectlist		offerproduct	1	mne_crm	mne_application	4b4f7ee00000	#0.offerproducttype = #1.value AND #1.name = 'offerproducttype'
1263843936	admindb	1263843936	admindb	orderproductid	orderproductpart	orderproductid	orderproduct	1	mne_crm	mne_warehouse	4b54ba600000	=
1263847121	admindb	1263847121	admindb		selectlist		orderproduct	1	mne_crm	mne_application	4b54c6d10000	#0.orderproducttype = #1.value AND #1.name = 'orderproducttype'
1266999761	admindb	1266999761	admindb	partstoragelocationid	partstoragelocation	partstoragelocationid	partoutgoing	1	mne_warehouse	mne_warehouse	4b84e1d10000	=
1153724531	admindb	1153724531	admindb	personid	person	refid	letter	1	mne_base	mne_crm	44c470730000	=
1266999836	admindb	1266999836	admindb	partingoingid	partingoing	partingoingid	partoutgoing	1	mne_warehouse	mne_warehouse	4b84e21c0000	=
1266999857	admindb	1266999857	admindb	orderproductpartid	orderproductpart	orderproductpartid	partoutgoing	1	mne_warehouse	mne_warehouse	4b84e2310000	=
1266999881	admindb	1266999881	admindb	partstoragelocationid	partoutgoing	partstoragelocationid	partstoragelocation	1	mne_warehouse	mne_warehouse	4b84e2490000	=
1248763484	admindb	1248763484	admindb	personid	person	personid	personskill	1	mne_personnal	mne_crm	4a6e9e5c0000	=
1249978977	admindb	1249978977	admindb	currencyid	currency	productcurrencyid	offerproduct	1	mne_crm	mne_base	4a812a610000	=
1250512740	admindb	1250512740	admindb		selectlist		personskill	1	mne_personnal	mne_application	4a894f640000	#0.rating = CAST(#1.value AS integer)  AND #1.name = 'rating'
1250670502	admindb	1250670502	admindb	personid	person	personid	timemanagement	1	mne_personnal	mne_crm	4a8bb7a60000	=
1250837170	admindb	1250837170	admindb	productid	product	productid	producttime	1	mne_personnal	mne_crm	4a8e42b20000	=
1250859802	admindb	1250859802	admindb	orderproductid	orderproduct	orderproductid	orderproducttime	1	mne_personnal	mne_crm	4a8e9b1a0000	=
1250943595	admindb	1250943595	admindb	orderproductid	orderproducttime	orderproductid	orderproduct	1	mne_crm	mne_personnal	4a8fe26b0000	=
1134655996	admindb	1134655996	admindb	offerid	offer	offerid	offerproduct	1	mne_crm	mne_crm	43a179fc0001	=
1253788474	admindb	1253788474	admindb	orderproducttimeid	orderproducttime	orderproducttimeid	timemanagement	1	mne_personnal	mne_personnal	4abb4b3a0000	=
1257407758	admindb	1257407758	admindb	treeid	parttree	parentid	parttree	1	mne_warehouse	mne_warehouse	4af2850e0000	=
1257407810	admindb	1257407810	admindb	partid	part	partid	parttree	1	mne_warehouse	mne_warehouse	4af285420000	=
1257409590	admindb	1257409590	admindb	partid	parttree	partid	part	1	mne_warehouse	mne_warehouse	4af28c360000	=
1257427809	admindb	1257427809	admindb	currencyid	currency	currencyid	partvendor	1	mne_warehouse	mne_base	4af2d3610000	=
1257431787	admindb	1257431787	admindb	companyid	company	companyid	partvendor	1	mne_warehouse	mne_crm	4af2e2eb0000	=
1223122844	admindb	1223122844	admindb	relname	pg_class	table_name	tables	1	information_schema	pg_catalog	48e75f9c0000	=
1221509337	admindb	1221509337	admindb		pg_namespace		pg_constraint	1	pg_catalog	pg_catalog	48cec0d90000	#0.connamespace = #1.oid
1221509820	admindb	1221509820	admindb		pg_class		pg_constraint	1	pg_catalog	pg_catalog	48cec2bc0000	#0.conrelid = #1.oid
1221550943	admindb	1221550943	admindb	constraint_catalog,constraint_name,constraint_schema	key_column_usage	constraint_catalog,constraint_name,constraint_schema	table_constraints	1	information_schema	information_schema	48cf635f0000	=,=,=
1221553732	admindb	1221553732	admindb		pg_namespace		pg_class	1	pg_catalog	pg_catalog	48cf6e440000	#0.relnamespace = #1.oid
1152191659	admindb	1152191659	admindb	deliverynoteid	deliverynoteproduct	deliverynoteid	deliverynote	1	mne_shipment	mne_shipment	44ad0cab0000	=
1152616191	admindb	1152616191	admindb	invoiceid	deliverynote	invoiceid	invoice	1	mne_shipment	mne_shipment	44b386ff0000	=
1259873681	admindb	1259873681	admindb	partid	part	partid	partstoragelocation	1	mne_warehouse	mne_warehouse	4b1825910000	=
1259873695	admindb	1259873695	admindb	storagelocationid	storagelocation	storagelocationid	partstoragelocation	1	mne_warehouse	mne_warehouse	4b18259f0000	=
1260968862	admindb	1260968862	admindb	storagelocationid	partstoragelocation	storagelocationid	storagelocation	1	mne_warehouse	mne_warehouse	4b28db9e0000	=
1261126104	admindb	1261126104	admindb	orderproducttimeid	orderproducttime	orderproducttimeid	time	1	mne_personnal	mne_personnal	4b2b41d80000	=
1261132526	admindb	1261132526	admindb	orderproducttimeid	time	orderproducttimeid	orderproducttime	1	mne_personnal	mne_personnal	4b2b5aee0000	=
1262676730	admindb	1262676730	admindb	currency	currency	currency	companyown	1	mne_crm	mne_base	4b42eafa0000	=
1262719528	admindb	1262719528	admindb	skillid	skill	skillid	orderproducttime	1	mne_personnal	mne_personnal	4b4392280000	=
1262719561	admindb	1262719561	admindb	skillid	skill	skillid	personskill	1	mne_personnal	mne_personnal	4b4392490000	=
1262719581	admindb	1262719581	admindb	skillid	skill	skillid	producttime	1	mne_personnal	mne_personnal	4b43925d0000	=
1147862927	admindb	1262866283	admindb		pg_roles		pg_proc	1	pg_catalog	pg_catalog	446aff8f0000	#0.proowner = #1.oid
1261927513	admindb	1262866325	admindb	oid	pg_roles	member	pg_auth_members	1	pg_catalog	pg_catalog	4b377c590000	=
1262793885	admindb	1262866335	admindb	rolname	pg_roles	ugroup	htmlcomposetab	1	mne_application	pg_catalog	4b44b49d0000	=
1262853025	admindb	1262866343	admindb	rolname	pg_roles	ugroup	menu	1	mne_application	pg_catalog	4b459ba10000	=
1264583069	admindb	1264583069	admindb	personid	person	refid	address	1	mne_crm	mne_crm	4b60019d0000	=
1264710243	admindb	1264710243	admindb	personid	person	personid	storagepersonnal	1	mne_warehouse	mne_crm	4b61f2630000	=
1264710260	admindb	1264710260	admindb	storageid	storage	storageid	storagepersonnal	1	mne_warehouse	mne_warehouse	4b61f2740000	=
1134656006	admindb	1134656006	admindb	productid	product	productid	offerproduct	1	mne_crm	mne_crm	43a17a060002	=
1137753389	admindb	1137753389	admindb	companyid	company	refid	order	1	mne_crm	mne_crm	43d0bd2d0000	=
1137753403	admindb	1137753403	admindb	personid	person	ownerid	order	1	mne_crm	mne_crm	43d0bd3b0000	=
1102680187	admindb	1102680187	admindb	cityid	city	cityid	address	1	mne_crm	mne_crm	41b9907b0004	=
1108982944	admindb	1108982944	admindb	companyid	company	refid	person	1	mne_crm	mne_crm	4219bca00001	=
1109352477	admindb	1109352477	admindb	personid	person	personid	companyperson	1	mne_crm	mne_crm	421f601d0003	=
1109771102	admindb	1109771102	admindb	companyid	company	companyid	companyperson	1	mne_crm	mne_crm	4225c35e0002	=
1130939786	admindb	1130939786	admindb	countryid	country	countryid	city	1	mne_crm	mne_crm	4368c58a0003	=
1132324696	admindb	1132324696	admindb	personid	person	ownerid	company	1	mne_crm	mne_crm	437de7580001	=
1134656349	admindb	1134656349	admindb	productid	productprice	productid	product	1	mne_crm	mne_crm	43a17b5d0003	=
1134656422	admindb	1134656422	admindb	treeid	producttree	parentid	producttree	1	mne_crm	mne_crm	43a17ba60004	=
1134656493	admindb	1134656493	admindb	productid	product	productid	producttree	1	mne_crm	mne_crm	43a17bed0006	=
1134767850	admindb	1134767850	admindb	companyid	company	refid	offer	1	mne_crm	mne_crm	43a32eea0002	=
1137761582	admindb	1137761582	admindb		pg_namespace		pg_proc	0	pg_catalog	pg_catalog	43d0dd2e0000	(#0.pronamespace = #1.oid)
1137761685	admindb	1137761685	admindb		pg_language		pg_proc	0	pg_catalog	pg_catalog	43d0dd950000	(#0.prolang = #1.oid)
1116849961	admindb	1116849961	admindb	schema,tab,colname	tablecolnames	schema,tabname,colname	history	1	mne_base	mne_application	4291c7290001	=,=,=
1132759764	admindb	1132759764	admindb	name,id	htmlcomposetabnames	name,id	htmlcomposetab	1	mne_application	mne_application	43848ad40002	=,=
1196778322	admindb	1196778322	admindb	id	translate	itemname	menu	1	mne_application	mne_application	475563520000	=
1291974294	admindb	1291974294	admindb	partid	partcost	partid	part	1	mne_warehouse	mne_warehouse	4d01f6960000	=
1136216077	admindb	1154933261	admindb		address		company	1	mne_crm	mne_crm	43b9480d0001	/* haupt */ #0.companyid = #1.refid AND #1.addresstypid = '000000000001'
1162300487	admindb	1162300487	admindb	productid	producttree	productid	product	1	mne_crm	mne_crm	45474c470000	=
1110289614	admindb	1110289614	admindb	companydataid	companydata	companyid	company	1	mne_crm	mne_crm	422dacce0001	=
1291707530	admindb	1291707530	admindb	fixturetypeid	fixturetypecost	fixturetypeid	fixturetype	1	mne_fixture	mne_fixture	4cfde48a0000	=
1521210470	admindb	1521210470	admindb	ownerid	invoice	personid	person	0	mne_crm	mne_shipment	5aabd4660000	=
1236765183	admindb	1236765183	admindb		address		company	1	mne_crm	mne_crm	49b789ff0000	/* rechnung */ ( #1.refid = #0.companyid AND CAST ( #1.addresstypid AS INTEGER ) = ( SELECT MAX(CAST( addresstypid AS INTEGER )) FROM mne_crm.address a WHERE refid = #1.refid AND CAST(a.addresstypid AS INTEGER ) IN (1,40) ))
1206023705	admindb	1521213467	admindb	personid	person	ownerid	person	0	mne_crm	mne_crm	47e276190000	=
1236766868	admindb	1236766868	admindb	refid	letter	companyid	company	1	mne_crm	mne_base	49b790940000	=
1245102089	admindb	1245102089	admindb	invoicemanagementid	invoicemanagement	invoiceid	invoice	1	mne_shipment	mne_shipment	4a36c0090000	=
1245316931	admindb	1245316931	admindb	invoiceid	invoice	invoicemanagementid	invoicemanagement	0	mne_shipment	mne_shipment	4a3a07430000	=
1245317300	admindb	1245317300	admindb	orderid	order	orderid	deliverynote	1	mne_shipment	mne_crm	4a3a08b40000	=
1245414038	admindb	1245414038	admindb	invoicecondid	invoicecond	textid	invoice	1	mne_shipment	mne_shipment	4a3b82960000	=
1245414064	admindb	1245414064	admindb	invoicecondid	invoicecond	condid	invoice	1	mne_shipment	mne_shipment	4a3b82b00000	=
1246439477	admindb	1246439477	admindb	personid	person	userid	time	1	mne_personnal	mne_crm	4a4b28350000	=
1246439982	admindb	1246439982	admindb	companyid	companyown	refid	person	1	mne_crm	mne_crm	4a4b2a2e0000	=
1246440068	admindb	1246440068	admindb	companyid	company	companyid	companyown	0	mne_crm	mne_crm	4a4b2a840000	=
1154932514	admindb	1154933113	admindb		address		person	1	mne_crm	mne_crm	44d6df220000	/* rechnung */  ( #1.refid = #0.personid AND CAST ( #1.addresstypid AS INTEGER ) = ( SELECT MAX(CAST( addresstypid AS INTEGER )) FROM mne_crm.address a WHERE refid = #1.refid AND CAST(a.addresstypid AS INTEGER ) IN (1,40) ))
1285647796	admindb	1285647796	admindb	invoiceid	invoicerefcount	invoiceid	invoice	1	mne_shipment	mne_shipment	4ca16db40000	=
1288166365	admindb	1288166365	admindb	partid	relocation_sum	partid	part	1	mne_warehouse	mne_warehouse	4cc7dbdd0000	=
1288177562	admindb	1288177562	admindb	partstoragelocationid	relocation_partstoragelocationsum	partstoragelocationid	partstoragelocation	1	mne_warehouse	mne_warehouse	4cc8079a0000	=
1106573916	admindb	1106573916	admindb	addresstypid	addresstyp	addresstypid	address	1	mne_crm	mne_crm	41f4fa5c0006	=
1288187860	admindb	1288187860	admindb	newstoragelocationid	relocation_partnewstoragelocationsum	storagelocationid	storagelocation	1	mne_warehouse	mne_warehouse	4cc82fd40000	=
1288239497	admindb	1288239497	admindb	partid	partoutgoing_sum	partid	part	1	mne_warehouse	mne_warehouse	4cc8f9890000	=
1322830595	admindb	1322830595	admindb	purchaseinvoiceid	purchaseinvoicepay	purchaseinvoiceid	purchaseinvoice	1	mne_warehouse	mne_warehouse	4ed8cb030000	=
1288941484	admindb	1288941484	admindb	partid	part	partid	purchase	1	mne_warehouse	mne_warehouse	4cd3afac0000	=
1289220647	admindb	1289220647	admindb	treeid	partoutgoing_tree	treeid	parttree	0	mne_warehouse	mne_warehouse	4cd7f2270000	=
1289904352	admindb	1289904352	admindb	menuid	menu	parentid	menu	1	mne_application	mne_application	4ce260e00000	=
1290071143	admindb	1290071143	admindb	fixtureid	fixture	fixtureid	fixturetree	1	mne_fixture	mne_fixture	4ce4ec670000	=
1290071170	admindb	1290071170	admindb	treeid	fixturetree	parentid	fixturetree	1	mne_fixture	mne_fixture	4ce4ec820000	=
1290071205	admindb	1290071205	admindb	personid	person	ownerid	fixture	1	mne_fixture	mne_crm	4ce4eca50000	=
1290073199	admindb	1290073199	admindb	fixtureid	fixturetree	fixtureid	fixture	1	mne_fixture	mne_fixture	4ce4f46f0000	=
1290143550	admindb	1290143550	admindb	partid	part	partid	fixture	1	mne_fixture	mne_warehouse	4ce6073e0000	=
1288863873	admindb	1290432280	admindb	purchaseid	purchase	purchaseid	purchasedelivery	1	mne_warehouse	mne_warehouse	4cd280810000	=
1289210328	admindb	1290432293	admindb	purchasedeliveryid	partingoing	purchasedeliveryid	purchasedelivery	1	mne_warehouse	mne_warehouse	4cd7c9d80000	=
1288949112	admindb	1290432322	admindb	purchaseid	purchasedelivery_sum	purchaseid	purchase	1	mne_warehouse	mne_warehouse	4cd3cd780000	=
1290527226	admindb	1290527226	admindb	purchasedeliveryid	purchasedelivery	purchasedeliveryid	fixture	1	mne_fixture	mne_warehouse	4cebe1fa0000	=
1290778865	admindb	1290778865	admindb	purchasedeliveryid	fixture	purchasedeliveryid	purchasedelivery	1	mne_warehouse	mne_fixture	4cefb8f10000	=
1291028263	admindb	1291028263	admindb	treeid	parttree_r	treeid	parttree	0	mne_warehouse	mne_warehouse	4cf387270000	=
1291028404	admindb	1291028404	admindb	partid	purchase	partid	parttree_r	1	mne_warehouse	mne_warehouse	4cf387b40000	=
1154952263	admindb	1154952263	admindb	invoiceid	invoice	invoiceid	deliverynote	1	mne_shipment	mne_shipment	44d72c470000	=
1135175107	admindb	1135175107	admindb	currencyid	currency	currencyid	productprice	1	mne_crm	mne_base	43a965c30001	=
1144689719	admindb	1144689719	admindb	currencyid	currency	productcurrencyid	orderproduct	1	mne_crm	mne_base	443a94370000	=
1153898454	admindb	1153898454	admindb	refid	letter	personid	person	0	mne_crm	mne_base	44c717d60000	=
1124888060	admindb	1124888060	admindb	companyid	company	refid	letter	1	mne_base	mne_crm	430c6dfc0002	=
1130853180	admindb	1130853180	admindb	addressid	address	refid	history	0	mne_base	mne_crm	4367733c0009	=
1310562996	admindb	1310562996	admindb	companyid	company	refid	file	1	mne_crm	mne_crm	4e1d9ab40000	=
1305796422	admindb	1305796422	admindb	tableconstraintmessagesid	tableconstraintmessages	index	table_index	1	mne_catalog	mne_application	4dd4df460000	=
1305876503	admindb	1305876503	admindb	tableconstraintmessagesid	tableconstraintmessages	conname	pg_constraint	1	pg_catalog	mne_application	4dd618170000	=
1306325288	admindb	1306325288	admindb	personid	person	personid	personowndata	1	mne_personnal	mne_crm	4ddcf1280000	=
1305893610	admindb	1305893610	admindb	tableconstraintmessagesid	tableconstraintmessages	name	fkey	1	mne_catalog	mne_application	4dd65aea0000	=
1291121621	admindb	1291121621	admindb	treeid	fixturetypetree	parentid	fixturetypetree	1	mne_fixture	mne_fixture	4cf4f3d50000	=
1291121631	admindb	1291121631	admindb	fixturetypeid	fixturetype	fixturetypeid	fixturetypetree	1	mne_fixture	mne_fixture	4cf4f3df0000	=
1291122082	admindb	1291122082	admindb	fixturetypeid	fixturetype	fixturetypeid	fixture	1	mne_fixture	mne_fixture	4cf4f5a20000	=
1291122119	admindb	1291122119	admindb	fixturetypeid	fixturetypetree	fixturetypeid	fixturetype	1	mne_fixture	mne_fixture	4cf4f5c70000	=
1291706388	admindb	1291706388	admindb	fixtureid	fixturecost	fixtureid	fixture	1	mne_fixture	mne_fixture	4cfde0140000	=
1291706507	admindb	1291706507	admindb	fixtureid	fixture	fixtureid	fixturecost	1	mne_fixture	mne_fixture	4cfde08b0000	=
1291707505	admindb	1291707505	admindb	fixturetypeid	fixturetype	fixturetypeid	fixturetypecost	1	mne_fixture	mne_fixture	4cfde4710000	=
1291733445	admindb	1291733445	admindb	fixturetypeid	fixturetype	fixturetypeid	productpart	1	mne_warehouse	mne_fixture	4cfe49c50000	=
1291998843	admindb	1291998843	admindb	partid	part	partid	partcost	1	mne_warehouse	mne_warehouse	4d02567b0000	=
1292232761	admindb	1292232761	admindb	fixturetypeid	fixturetype	fixturetypeid	offerproductpart	1	mne_warehouse	mne_fixture	4d05e8390000	=
1292245789	admindb	1292245789	admindb	fixturetypeid	fixturetype	fixturetypeid	orderproductpart	1	mne_warehouse	mne_fixture	4d061b1d0000	=
1292849990	admindb	1292849990	admindb	orderproductpartid	orderproductpart	refid	history	1	mne_base	mne_warehouse	4d0f53460000	=
1292850045	admindb	1292850045	admindb	orderproducttimeid	orderproducttime	refid	history	1	mne_base	mne_personnal	4d0f537d0000	=
1222860646	admindb	1222860646	admindb		pg_proc		routine_privileges	1	information_schema	pg_catalog	48e35f660000	#0.specific_name = #1.proname || '_' || #1.oid
1386591267	admindb	1386591267	admindb	feenameid	feename	law	offer	1	mne_hoai	mne_hoai	52a5b4230000	=
1220606116	admindb	1220606116	admindb	schema,tab,colname	tablecolnames	table_schema,table_name,column_name	columns	1	information_schema	mne_application	48c0f8a40000	=,=,=
1135355465	admindb	1135355465	admindb	personid	person	ownerid	offer	1	mne_crm	mne_crm	43ac26490012	=
1281598219	admindb	1281598219	admindb	productid	product	productid	workphase	1	mne_hoai	mne_crm	4c63a30b0000	=
1281674185	admindb	1281674185	admindb	productid	product	productid	feeextra	1	mne_hoai	mne_crm	4c64cbc90000	=
1284379774	admindb	1284379774	admindb	treeid	bugtree	parentid	bugtree	1	mne_support	mne_support	4c8e147e0000	=
1311055954	admindb	1311055954	admindb	companyid	company	companyid	companyemail	1	mne_crm	mne_crm	4e2520520000	=
1311143661	admindb	1311143661	admindb	personid	person	personid	personemail	1	mne_crm	mne_crm	4e2676ed0000	=
1284380607	admindb	1284380607	admindb	bugid	bugtree	bugid	bug	1	mne_support	mne_support	4c8e17bf0000	=
1284455686	admindb	1284455686	admindb	personid	person	ownerid	bug	1	mne_support	mne_crm	4c8f3d060000	=
1284462816	admindb	1284462816	admindb	bugid	bug	bugid	bugfile	1	mne_support	mne_support	4c8f58e00000	=
1285590550	admindb	1285590550	admindb	invoiceid	invoiceref	invoiceid	invoice	1	mne_shipment	mne_shipment	4ca08e160000	=
1285590639	admindb	1285590639	admindb	companyid	company	refid	invoiceref	1	mne_shipment	mne_crm	4ca08e6f0000	=
1285590661	admindb	1285590661	admindb	personid	person	refid	invoiceref	1	mne_shipment	mne_crm	4ca08e850000	=
1288962820	admindb	1326301422	admindb	purchasedeliveryid	purchasedelivery	purchasedeliveryid	partingoing	1	mne_warehouse	mne_warehouse	4cd403040000	=
1288966933	admindb	1288966933	admindb	partvendorid	partvendor	partvendorid	purchase	1	mne_warehouse	mne_warehouse	4cd413150000	=
1321524492	admindb	1321524492	admindb	invoiceid	invoice	invoiceid	invoiceref	1	mne_shipment	mne_shipment	4ec4dd0c0000	=
1321428591	admindb	1321869391	admindb	id	konto	konto_id	umsatz	1	ext_hibiscus	ext_hibiscus	4ec3666f0000	=
1321877008	admindb	1321877008	admindb	id	konto	konto_id	ueberweisung	1	ext_hibiscus	ext_hibiscus	4eca3e100000	=
1321445524	admindb	1322042330	admindb		invoicetransaction		umsatz	1	ext_hibiscus	mne_shipment	4ec3a8940000	#1.umsatzid = to_char(#0.id,'FM99999999999999999999999999999999')
1321982770	admindb	1322042334	admindb	refid	invoicetransaction	invoiceid	invoice	1	mne_shipment	mne_shipment	4ecbdb320000	=
1321982817	admindb	1322042339	admindb	refid	invoicetransaction	invoicerefid	invoiceref	1	mne_shipment	mne_shipment	4ecbdb610000	=
1321524059	admindb	1322042348	admindb	invoiceid	invoice	refid	invoicetransaction	1	mne_shipment	mne_shipment	4ec4db5b0000	=
1321524074	admindb	1322042353	admindb	invoicerefid	invoiceref	refid	invoicetransaction	1	mne_shipment	mne_shipment	4ec4db6a0000	=
1321445315	admindb	1322042360	admindb		umsatz		invoicetransaction	1	mne_shipment	ext_hibiscus	4ec3a7c30000	#0.umsatzid = to_char(#1.id,'FM99999999999999999999999999999999')
1322149938	admindb	1322149938	admindb		invoiceaccount		konto	1	ext_hibiscus	mne_shipment	4ece68320000	to_char(#0.id,'FM99999999999999999999') = #1.accountid
1322470654	admindb	1322470654	admindb	orderid	order	crmorderid	purchase	1	mne_warehouse	mne_crm	4ed34cfe0000	=
1322472532	admindb	1322472532	admindb	purchasedeliveryid	purchasedelivery	purchasedeliveryid	purchaseinvoicedelivery	1	mne_warehouse	mne_warehouse	4ed354540000	=
1322472542	admindb	1322472542	admindb	purchaseinvoiceid	purchaseinvoice	purchaseinvoiceid	purchaseinvoicedelivery	1	mne_warehouse	mne_warehouse	4ed3545e0000	=
1322653960	admindb	1322653960	admindb	purchasedeliveryid	purchaseinvoicedelivery	purchasedeliveryid	purchasedelivery	1	mne_warehouse	mne_warehouse	4ed619080000	=
1322734631	admindb	1322734631	admindb	companyid	company	companyid	purchaseinvoice	1	mne_warehouse	mne_crm	4ed754270000	=
1322734997	admindb	1322734997	admindb	companyid	purchaseinvoice	companyid	company	1	mne_crm	mne_warehouse	4ed755950000	=
1322735417	admindb	1322735417	admindb	companyid	partvendor	companyid	company	1	mne_crm	mne_warehouse	4ed757390000	=
1330961572	admindb	1330961572	admindb	timeid	time	timeid	present	1	mne_builddiary	mne_builddiary	4f54dca40000	=
1330961585	admindb	1330961585	admindb	timeid	present	timeid	time	1	mne_builddiary	mne_builddiary	4f54dcb10000	=
1330961627	admindb	1330961627	admindb	personid	person	personid	present	1	mne_builddiary	mne_crm	4f54dcdb0000	=
1335777054	admindb	1335777054	admindb	personnaltimeid	present	timeid	time	1	mne_personnal	mne_builddiary	4f9e571e0000	=
1335852768	admindb	1335852768	admindb	orderid	order	orderid	time	1	mne_builddiary	mne_crm	4f9f7ee00000	=
1331707729	admindb	1331707729	admindb	personid	person	personid	presentpersonall	1	mne_builddiary	mne_crm	4f603f510000	=
1331712010	admindb	1331712010	admindb	personid,timeid	present	personid,timeid	presentpersonall	1	mne_builddiary	mne_builddiary	4f60500a0000	=,=
1332425774	admindb	1332425774	admindb	timeid	comment	timeid	time	1	mne_builddiary	mne_builddiary	4f6b342e0000	=
1332425782	admindb	1332425782	admindb	timeid	time	timeid	comment	1	mne_builddiary	mne_builddiary	4f6b34360000	=
1332425895	admindb	1332425895	admindb		selectlist		comment	1	mne_builddiary	mne_application	4f6b34a70000	#0.typ = #1.value AND #1.name = 'mne_builddiary_comment_typ'
1347867757	admindb	1347867757	admindb	name	userselectlist	name	selectlist	1	mne_application	mne_application	5056d46d0000	=
1347613600	admindb	1356098853	admindb	role	dbaccessgroup	usename	pg_user	1	pg_catalog	mne_catalog	5052f3a00000	=
1321625968	admindb	1358771678	admindb		invoice		umsatz	1	ext_hibiscus	mne_shipment	4ec669700000	mne_hibiscus.invoicetransaction_reffind(#0.id) = #1.invoiceid
1521198982	admindb	1521198982	admindb	ownerid	person	personid	person	0	mne_crm	mne_crm	5aaba7860000	=
1321625983	admindb	1358771697	admindb		invoiceref		umsatz	1	ext_hibiscus	mne_shipment	4ec6697f0000	mne_hibiscus.invoicetransaction_reffind(#0.id) = #1.invoicerefid
1380099696	admindb	1380099696	admindb	personid	personowndatapublic	personid	person	1	mne_crm	mne_personnal	5242a6700000	=
1380175785	admindb	1380175785	admindb	usename	pg_user	loginname	personowndatapublic	1	mne_personnal	pg_catalog	5243cfa90000	=
1381246483	admindb	1381246483	admindb	rolname	pg_roles	username	userpref	1	mne_application	pg_catalog	525426130000	=
1382373061	admindb	1382373061	admindb	personid	personowndatapublic	ownerid	orderproductpart	1	mne_warehouse	mne_personnal	526556c50000	=
1382389478	admindb	1382389478	admindb	personid	personowndatapublic	ownerid	offerproductpart	1	mne_warehouse	mne_personnal	526596e60000	=
1382498897	admindb	1382498897	admindb	start	time	start	lasttime	1	mne_builddiary	mne_builddiary	526742510000	=
1382499716	admindb	1382499716	admindb	orderid,personid	lasttime	orderid,personid	presentpersonall	1	mne_builddiary	mne_builddiary	526745840000	=,=
1386591279	admindb	1386591279	admindb	feenameid	feename	law	order	1	mne_hoai	mne_hoai	52a5b42f0000	=
1389694594	admindb	1389694594	admindb	orderid	order	refid	repository	1	mne_repository	mne_crm	52d50e820000	=
1391580256	admindb	1391580256	admindb	personid	person	personid	fileinterests	1	mne_repository	mne_crm	52f1d4600000	=
1391757386	admindb	1391757386	admindb	repositoryid	repository	repositoryid	fileinterests	1	mne_repository	mne_repository	52f4884a0000	=
1393504008	admindb	1393504008	admindb	repositoryid	fileinterests	repositoryid	repository	1	mne_repository	mne_repository	530f2f080000	=
1393569546	admindb	1393569546	admindb	repositoryid,filename	filedata_maxdate	repositoryid,filename	fileinterests	1	mne_repository	mne_repository	53102f0a0000	=,=
1394001545	admindb	1394001545	admindb	repositoryid,filename,repdate	filedata_rank	repositoryid,filename,repdate	filedata	1	mne_repository	mne_repository	5316c6890000	=,=,=
1394001614	admindb	1394001614	admindb	repositoryid,filename,repdate	filedata_rank	repositoryid,filename,repdate	fileinterests	1	mne_repository	mne_repository	5316c6ce0000	=,=,=
1394002042	admindb	1394002042	admindb	repositoryid,filename,repdate	filedata_rank	repositoryid,filename,repdate	filedata_maxdate	1	mne_repository	mne_repository	5316c87a0000	=,=,=
1394607842	admindb	1394607842	admindb	repositoryid,filename,repdate	filedata	repositoryid,filename,repdate	filedata_maxdate	1	mne_repository	mne_repository	532006e20000	=,=,=
1409651358	admindb	1409651358	admindb	personpictureid	personpicture	personid	person	1	mne_crm	mne_crm	5405929e0000	=
1410160790	admindb	1410160790	admindb	invoiceid,invoicerefid	invoicepaid	invoiceid,invoicerefid	invoiceref	1	mne_shipment	mne_shipment	540d58960000	=,=
1410166404	admindb	1410166404	admindb	invoiceid	invoicepaidsum	invoiceid	invoice	1	mne_shipment	mne_shipment	540d6e840000	=
1410256714	admindb	1410256714	admindb		invoicepaid		invoice	1	mne_shipment	mne_shipment	540ecf4a0000	#0.invoiceid = #1.invoiceid AND #1.invoicerefid IS NULL
1413876766	admindb	1415615856	admindb	personid	person	personid	filedata_interests	1	mne_repository	mne_crm	54460c1e0000	=
1413881500	admindb	1415615863	admindb	repositoryid,filename,personid	fileinterests	repositoryid,filename,personid	filedata_interests	1	mne_repository	mne_repository	54461e9c0000	=,=,=
1414133984	admindb	1415615869	admindb	repositoryid,filename	filedata_maxdate	repositoryid,filename	filedata_interests	1	mne_repository	mne_repository	5449f8e00000	=,=
1422261950	admindb	1422261950	admindb	personid	person	refid	repository	1	mne_repository	mne_crm	54c5febe0000	=
1422261983	admindb	1422261983	admindb	companyid	company	refid	repository	1	mne_repository	mne_crm	54c5fedf0000	=
1422262003	admindb	1422262003	admindb	offerid	offer	refid	repository	1	mne_repository	mne_crm	54c5fef30000	=
1426266856	admindb	1426490515	admindb	personid	person	personid	personsharepasswd	1	mne_crm	mne_crm	55031ae80000	=
1432891671	admindb	1432891671	admindb	personid	person	personid	shares	1	mne_system	mne_crm	556831170000	=
1432891690	admindb	1432891690	admindb	folderid	folder	folderid	shares	1	mne_system	mne_application	5568312a0000	=
1465820583	admindb	1465820583	admindb	htmlcomposeid	htmlcomposetab	htmlcomposeid	htmlcompose	1	mne_application	mne_application	575ea5a70000	=
1465821082	admindb	1465821082	admindb	htmlcomposetabnamesid	htmlcomposetabnames	htmlcomposetabid	htmlcomposetab	1	mne_application	mne_application	575ea79a0000	=
1465822087	admindb	1465822087	admindb	name	htmlcompose	startweblet	userpref	1	mne_application	mne_application	575eab870000	=
1472107897	admindb	1472107897	admindb	htmlcomposeid	htmlcompose	htmlcomposeid	htmlcomposetab	1	mne_application	mne_application	57be95790000	=
1472131443	admindb	1472131443	admindb	personowndataid	personowndata	personowndataid	personowndata	1	mne_personnal	mne_crm	57bef1730000	=
1472133711	admindb	1472133711	admindb	usename	pg_user	loginname	personowndata	1	mne_crm	pg_catalog	57befa4f0000	=
1472134083	admindb	1472134083	admindb	personid	person	personid	personowndata	1	mne_crm	mne_crm	57befbc30000	=
1472135279	admindb	1472135279	admindb	member	accessgroup	loginname	personowndata	1	mne_crm	mne_catalog	57bf006f0000	=
1472549027	admindb	1472549027	admindb	personid	personowndata	personid	person	1	mne_crm	mne_crm	57c550a30000	=
1472709848	admindb	1472709848	admindb	rolname	pg_roles	loginname	personowndata	1	mne_crm	pg_catalog	57c7c4d80000	=
1472709974	admindb	1472709974	admindb		dbaccessgroup		pg_roles	1	pg_catalog	mne_catalog	57c7c5560000	#0.rolname = #1.role AND #1.dbname = current_database() AND connect = true
1473783145	admindb	1473783145	admindb		accessgroup		pg_roles	1	pg_catalog	mne_catalog	57d825690000	#0.rolname = #1.member AND #1.group = 'erpdav'
1473783170	admindb	1473783170	admindb		accessgroup		pg_roles	1	pg_catalog	mne_catalog	57d825820000	#0.rolname = #1.member AND #1.group = 'erpsmb'
1474361309	admindb	1474361309	admindb	personid	personsharepasswdpublic	personid	person	1	mne_crm	mne_system	57e0f7dd0000	=
1475218478	admindb	1475218478	admindb	folderid	shares	folderid	folder	1	mne_application	mne_system	57ee0c2e0000	=
1477551551	admindb	1477551551	admindb	personid	person	personid	mailalias	1	mne_system	mne_crm	5811a5bf0000	=
1478168461	admindb	1478168461	admindb	personowndataid	personowndata	personowndataid	personowndata	1	mne_crm	mne_personnal	581b0f8d0000	=
1521198955	admindb	1521213634	admindb	ownerid	company	personid	person	0	mne_crm	mne_crm	5aaba76b0000	=
1521199062	admindb	1521199062	admindb	ownerid	order	personid	person	0	mne_crm	mne_crm	5aaba7d60000	=
1521198997	admindb	1521198997	admindb	ownerid	offer	personid	person	0	mne_crm	mne_crm	5aaba7950000	=
1521210446	admindb	1521210446	admindb	ownerid	deliverynote	personid	person	0	mne_crm	mne_shipment	5aabd44e0000	=
1521199139	admindb	1521199139	admindb	ownerid	fixture	personid	person	0	mne_crm	mne_fixture	5aaba8230000	=
1521210509	admindb	1521210509	admindb	ownerid	offerproductpart	personid	person	0	mne_crm	mne_warehouse	5aabd48d0000	=
1521210546	admindb	1521210546	admindb	ownerid	purchase	personid	person	0	mne_crm	mne_warehouse	5aabd4b20000	=
1521210523	admindb	1521210523	admindb	ownerid	orderproductpart	personid	person	0	mne_crm	mne_warehouse	5aabd49b0000	=
1521561158	admindb	1521561158	admindb		uuid		userpref	1	mne_application	mne_catalog	5ab12e460000	true
1522132502	admindb	1522132502	admindb	addresstypid,addresstyp_en,addresstyp_en,	addresstyp	modifydate,addresstyp_en,addresstyp_en,	address	1	mne_crm	mne_crm	5ab9e6160000	=,=,=,=
1525686436	admindb	1525686436	admindb	personid	person	personid	persontime	1	mne_builddiary	mne_crm	5af020a40000	=
1525686456	admindb	1525686456	admindb	orderid	order	orderid	persontime	1	mne_builddiary	mne_crm	5af020b80000	=
1525686475	admindb	1525686475	admindb	orderproducttimeid	orderproducttime	orderproducttimeid	persontime	1	mne_builddiary	mne_personnal	5af020cb0000	=
1525686495	admindb	1525686495	admindb	timeid	time	timeid	persontime	1	mne_builddiary	mne_personnal	5af020df0000	=
1525686521	admindb	1525686521	admindb	timeid	time	bdtimeid	persontime	1	mne_builddiary	mne_builddiary	5af020f90000	=
1525844113	admindb	1525844113	admindb	timeid,personid	present	bdtimeid,personid	persontime	1	mne_builddiary	mne_builddiary	5af288910000	=,=
1542878074	admindb	1542878074	admindb	law	workphase	law	offer	1	mne_hoai	mne_hoai	5bf6737a0000	=
1545297080	admindb	1545297080	admindb	timeid	time	timeid	timemax	1	mne_personnal	mne_personnal	5c1b5cb80000	=
1545315773	admindb	1545315773	admindb	userid	timemax	userid	time	1	mne_personnal	mne_personnal	5c1ba5bd0000	=
1546850278	admindb	1546850278	admindb		selectlist		timemanagement	1	mne_personnal	mne_application	5c330fe60000	#1.name = 'timetyp' AND #0.timetyp = CAST ( #1.value AS INT )
1553176351	admindb	1553176351	admindb	personid	personshares	personid	personowndata	1	mne_crm	mne_system	5c93971f0000	=
1553766097	admindb	1553766097	admindb	domainid	domain	sogoid	sogo	1	mne_system	mne_system	5c9c96d10000	=
1574665106	admindb	1574665106	admindb		server		network	1	mne_system	mne_application	5ddb7b920000	true
1576577610	admindb	1576577610	admindb	domainid	domain	hostname	network	1	mne_system	mne_system	5df8aa4a0000	=
1576676446	admindb	1576676446	admindb	domainid	domain	netparamid	netparam	1	mne_system	mne_system	5dfa2c5e0000	=
1579610187	admindb	1579610187	admindb		server		netparam	1	mne_system	mne_application	5e26f04b0000	true
1579620076	admindb	1579620076	admindb	hostname,networkid	network	domainid,netdevice	domain	1	mne_system	mne_system	5e2716ec0000	=,=
1610368938	admindb	1610368938	admindb	menuname	applications	menuname	menu	1	mne_application	mne_application	5ffc47aa0000	=
1611326107	admindb	1611326107	admindb	htmlcomposeid	htmlcomposenames	htmlcomposeid	htmlcompose	1	mne_application	mne_application	600ae29b0000	=
\.


--
-- Data for Name: menu; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.menu (createdate, createuser, modifydate, modifyuser, menupos, parentid, menuid, menuname, action, itemname, ugroup, custom) FROM stdin;
1612279950	admindb	1612280008	admindb	5	\N	6019708e0000	sbs	{ "action" :  "show",  "parameter" : [ "user_settings"] }	Benutzer Einstellungen		f
1206438339	admindb	1358870242	admindb	0	\N	47e8c9c30000	dbadmin	{ "action" : "submenu", "parameter" : "" }	Einstellungen		f
1206438434	admindb	1612283884	admindb	10	47e8c9fa0001	47e8ca240001	dbadmin	{ "action" :  "show",  "parameter" : [ "dbadmin_table"] }	Tabellen	erpdb	f
1613986440	admindb	1613986440	admindb	0	\N	60337a880000	sbs	{ "action" : "request",  "parameter" : [ "/utils/logout.json"] }	Logout		f
1206438394	admindb	1347865860	admindb	20	\N	47e8c9fa0000	dbadmin	{ "action" : "submenu", "parameter" : "" }	Web	erpdb	f
1246350465	admindb	1347865822	admindb	50	47e8c9fa0001	4a49cc810000	dbadmin	{ "action" :  "show",  "parameter" : [ "dbadmin_sql_execute"] }	Sql ausf??hren	admindb	f
1196949200	admindb	1347865802	admindb	10	47e8c9c30000	485661270000	dbadmin	{ "action" :  "show",  "parameter" : [ "user_settings"] }	Benutzer Einstellungen	erpdb	f
1268337191	admindb	1422265394	admindb	5	47e8c9c30000	4b994a360000	dbadmin	{ "action" : "request",  "parameter" : [ "/utils/logout.xml"] }	Logout		f
1222158401	admindb	1262866920	admindb	40	47e8c9fa0001	48d8a8410000	dbadmin	{ "action" :  "show",  "parameter" : [ "dbadmin_procedure"] }	Prozeduren	admindb	f
1206438434	admindb	1262866972	admindb	20	47e8c9fa0000	47e8ca230000	dbadmin	{ "action" :  "show",  "parameter" : [ "dbadmin_weblet"] }	Weblets	admindb	f
1206438434	admindb	1262867032	admindb	30	47e8c9fa0001	47e8ca240000	dbadmin	{ "action" :  "show",  "parameter" : [ "dbadmin_join"] }	Joins	admindb	f
1206438434	admindb	1262867038	admindb	20	47e8c9fa0001	47e8ca220000	dbadmin	{ "action" :  "show",  "parameter" : [ "dbadmin_query"] }	Abfragen	admindb	f
1292600461	admindb	1292600484	admindb	30	47e8c9fa0000	4d0b848d0000	dbadmin	{ "action" :  "show",  "parameter" : [ "dbadmin_menu"] }	Men??	admindb	f
1471848530	admindb	1611817140	admindb	2000	\N	57baa0520000	sbs	{ "action" : "menu" , "parameter" : [ "sbsdb" ] }	Datenbank		f
1490777282	admindb	1613986462	admindb	1	\N	58db74c20000	sbs	{ "action" : "request",  "parameter" : [ "/db/utils/connect/reload.json"] }	Konfiguration neu laden		f
1433322665	admindb	1613986469	admindb	10	\N	556ec4a90000	sbs	{ "action" :  "show",  "parameter" : [ "sysadmin_network"] }	Netzwerk		f
1459247227	admindb	1613986475	admindb	15	\N	56fa587b0000	sbs	{ "action" :  "show",  "parameter" : [ "sysadmin_cert"] }	Zertifikate		f
1206438394	admindb	1358245867	admindb	10	\N	47e8c9fa0001	dbadmin	{ "action" : "submenu", "parameter" : "" }	Datenbank	erpdb	f
1471854051	admindb	1613986480	admindb	20	\N	57bab5e30000	sbs	{ "action" :  "show",  "parameter" : [ "sysadmin_domain"] }	Domain		f
1472115393	admindb	1613986486	admindb	30	\N	57beb2c10000	sbs	{ "action" :  "show",  "parameter" : [ "sysadmin_person"] }	Benutzer		f
1422265664	admindb	1613986493	admindb	50	\N	54c60d400000	sbs	{ "action" :  "show",  "parameter" : [ "sysadmin_share"] }	Freigabe		f
1292600543	admindb	1347865853	admindb	40	47e8c9fa0000	4d0b84df0000	dbadmin	{ "action" :  "show",  "parameter" : [ "dbadmin_selectlist"] }	Auswahllisten	erpdb	f
1453298527	admindb	1613986499	admindb	100	\N	569f935f0000	sbs	{ "action" :  "show",  "parameter" : [ "sysadmin_apache"] }	Apache		f
1358870282	admindb	1611330908	admindb	100	\N	50feb70a0000	dbadmin	{ "action" : "menu", "parameter" : [ "sbs" ] }	Sbs		f
1422365644	admindb	1611557576	admindb	30	47e8c9c30000	54c793cc0000	dbadmin	{ "action" : "request",  "parameter" : [ "/db/utils/connect/reload.json"] }	Konfiguration neu laden		f
\.


--
-- Data for Name: querycolnames; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.querycolnames (createdate, createuser, modifydate, modifyuser, text_de, text_en, colid, schema, query) FROM stdin;
1611325733	admindb	1611325733	admindb	\N	\N	uowncountryname_en	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	stylename	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	uownemail	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	uownpostcode	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	countrycarcode	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	cstartweblet	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	startweblet	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	uownhttp	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	uownpostbox	mne_application	userpreff
1306422520	admindb	1306422520	admindb	\N	german	text_de	mne_application	query_cols
1306422520	admindb	1306422520	admindb	\N	english	text_en	mne_application	query_cols
1611325733	admindb	1611325733	admindb	\N	\N	uowntelefon	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	uownfax	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	uowncompany	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	uownphoneprefix	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	regionselect	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	personid	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	loginname	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	uownbank	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	uowncountryname_de	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	startwebletname	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	uowncompanyid	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	uownblz	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	region	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	uuid	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	username	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	uowncountrycarcode	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	debug	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	mslanguage	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	uownaccount	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	uowncurrencyid	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	uownstreet	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	timezone	mne_application	userpreff
1611325733	admindb	1611325733	admindb	Name	name	fullname	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	uowncompanyownprefix	mne_application	userpreff
1611325733	admindb	1611325733	admindb	\N	\N	version	mne_application	userpreff
1611326745	admindb	1611326745	admindb	\N	\N	countrycarcode	mne_application	userpref
1611326745	admindb	1611326745	admindb	\N	\N	debug	mne_application	userpref
1611326745	admindb	1611326745	admindb	\N	\N	language	mne_application	userpref
1611326745	admindb	1611326745	admindb	\N	\N	region	mne_application	userpref
1611326745	admindb	1611326745	admindb	\N	\N	startweblet	mne_application	userpref
1611326745	admindb	1611326745	admindb	\N	\N	stylename	mne_application	userpref
1611326745	admindb	1611326745	admindb	\N	\N	timezone	mne_application	userpref
1611326745	admindb	1611326745	admindb	\N	\N	mslanguage	mne_application	userpref
1611326745	admindb	1611326745	admindb	\N	\N	exportencoding	mne_application	userpref
1611326745	admindb	1611326745	admindb	\N	\N	startwebletname	mne_application	userpref
1611326745	admindb	1611326745	admindb	\N	\N	uuid	mne_application	userpref
1611326745	admindb	1611326745	admindb	\N	\N	username	mne_application	userpref
1611326745	admindb	1611326745	admindb	\N	\N	loginname	mne_application	userpref
1611326745	admindb	1611326745	admindb	\N	\N	regionselect	mne_application	userpref
1611327174	admindb	1611327174	admindb	\N	\N	username	mne_application	userpasswd
1611327174	admindb	1611327174	admindb	Password	password	passwd1	mne_application	userpasswd
1611327174	admindb	1611327174	admindb	wiederhohlen	repeat	passwd2	mne_application	userpasswd
1522137609	admindb	1589298321	admindb	Schema	schema	schema	mne_application	table_cols
1465828142	admindb	1589298336	admindb	Schema	schema	schema	mne_application	weblet_all
1410256508	admindb	1589298348	admindb	Schema	schema	schema	mne_application	table_all
1611328123	admindb	1611328123	admindb	\N	\N	username	mne_application	loginuser
1611328123	admindb	1611328123	admindb	\N	\N	systemuser	mne_application	loginuser
1591195919	admindb	1591195919	admindb	\N	\N	id	mne_application	procedure_access
1591195919	admindb	1591195919	admindb	\N	\N	schema	mne_application	procedure_access
1591195919	admindb	1591195919	admindb	\N	\N	specific_name	mne_application	procedure_access
1591195919	admindb	1591195919	admindb	\N	\N	fullname	mne_application	procedure_access
1591195919	admindb	1591195919	admindb	\N	\N	routine_schema	mne_application	procedure_access
1591195919	admindb	1591195919	admindb	\N	\N	routine_name	mne_application	procedure_access
1591195919	admindb	1591195919	admindb	\N	\N	privilege	mne_application	procedure_access
1591195919	admindb	1591195919	admindb	\N	\N	owner	mne_application	procedure_access
1591195919	admindb	1591195919	admindb	\N	\N	user	mne_application	procedure_access
1591195919	admindb	1591195919	admindb	\N	\N	rolname	mne_application	procedure_access
1591195919	admindb	1591195919	admindb	\N	\N	test	mne_application	procedure_access
1603197205	admindb	1603197205	admindb	\N	\N	htmlcomposetabid	mne_application	weblet_tabs
1591372373	admindb	1591372373	admindb	\N	\N	menuname	mne_application	menu_tree
1591372373	admindb	1591372373	admindb	\N	\N	parentid	mne_application	menu_tree
1591372373	admindb	1591372373	admindb	\N	\N	menuid	mne_application	menu_tree
1591372373	admindb	1591372373	admindb	\N	\N	item	mne_application	menu_tree
1591372373	admindb	1591372373	admindb	\N	\N	action	mne_application	menu_tree
1591372373	admindb	1591372373	admindb	\N	\N	pos	mne_application	menu_tree
1591372373	admindb	1591372373	admindb	\N	\N	typ	mne_application	menu_tree
1591372373	admindb	1591372373	admindb	Benutzergruppe	\N	ugroup	mne_application	menu_tree
1591372373	admindb	1591372373	admindb	Datenbankgruppe	\N	group	mne_application	menu_tree
1591372373	admindb	1591372373	admindb	\N	\N	rolname	mne_application	menu_tree
1591372373	admindb	1591372373	admindb	\N	\N	parentname	mne_application	menu_tree
1603197205	admindb	1603197205	admindb	\N	\N	htmlcomposeid	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	\N	\N	name	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	\N	\N	id	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	\N	\N	depend	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	\N	\N	position	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	\N	\N	subposition	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	\N	\N	path	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	\N	\N	initpar	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	\N	\N	loadpos	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	\N	\N	ugroup	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	\N	\N	custom	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	Deutsch	german	label_de	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	Englisch	englisch	label_en	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	Beschriftung	label	label	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	\N	\N	namecustom	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	\N	\N	createdate	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	\N	\N	modifydate	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	\N	\N	createuser	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	\N	\N	modifyuser	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	\N	\N	rolname	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	\N	\N	loginname	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	\N	\N	groupexists	mne_application	weblet_tabs
1603197205	admindb	1603197205	admindb	angepasst	customized	customall	mne_application	weblet_tabs
1591604505	admindb	1591604505	admindb	\N	\N	menuid	mne_application	menu_edit
1591604505	admindb	1591604505	admindb	\N	\N	parentid	mne_application	menu_edit
1591604505	admindb	1591604505	admindb	\N	\N	menuname	mne_application	menu_edit
1591604505	admindb	1591604505	admindb	\N	\N	itemname	mne_application	menu_edit
1591604505	admindb	1591604505	admindb	\N	\N	parentname	mne_application	menu_edit
1591604505	admindb	1591604505	admindb	\N	\N	menupos	mne_application	menu_edit
1591604505	admindb	1591604505	admindb	\N	\N	action	mne_application	menu_edit
1591604505	admindb	1591604505	admindb	\N	\N	ugroup	mne_application	menu_edit
1591604505	admindb	1591604505	admindb	\N	\N	custom	mne_application	menu_edit
1591604505	admindb	1591604505	admindb	\N	\N	createdate	mne_application	menu_edit
1591604505	admindb	1591604505	admindb	\N	\N	createuser	mne_application	menu_edit
1591604505	admindb	1591604505	admindb	\N	\N	modifydate	mne_application	menu_edit
1591604505	admindb	1591604505	admindb	\N	\N	modifyuser	mne_application	menu_edit
1605541710	admindb	1605541710	admindb	\N	\N	rolname	mne_application	usergroup
1605541710	admindb	1605541710	admindb	\N	\N	group	mne_application	usergroup
1605541710	admindb	1605541710	admindb	\N	\N	ismember	mne_application	usergroup
1605541710	admindb	1605541710	admindb	\N	\N	groupname	mne_application	usergroup
1603794803	admindb	1603794803	admindb	\N	\N	wval	mne_application	weblet_select
1603794803	admindb	1603794803	admindb	\N	\N	htmlcomposetabselectid	mne_application	weblet_select
1603794803	admindb	1603794803	admindb	\N	\N	htmlcomposetabid	mne_application	weblet_select
1603794803	admindb	1603794803	admindb	\N	\N	htmlcomposeid	mne_application	weblet_select
1603794803	admindb	1603794803	admindb	\N	\N	id	mne_application	weblet_select
1603794803	admindb	1603794803	admindb	\N	\N	query	mne_application	weblet_select
1603794803	admindb	1603794803	admindb	\N	\N	schema	mne_application	weblet_select
1603794803	admindb	1603794803	admindb	\N	\N	element	mne_application	weblet_select
1603794803	admindb	1603794803	admindb	\N	\N	cols	mne_application	weblet_select
1603794803	admindb	1603794803	admindb	\N	\N	scols	mne_application	weblet_select
1603794803	admindb	1603794803	admindb	\N	\N	selval	mne_application	weblet_select
1603794803	admindb	1603794803	admindb	\N	\N	showcols	mne_application	weblet_select
1603794803	admindb	1603794803	admindb	\N	\N	showids	mne_application	weblet_select
1603794803	admindb	1603794803	admindb	\N	\N	showalias	mne_application	weblet_select
1603794803	admindb	1603794803	admindb	\N	\N	tab	mne_application	weblet_select
1603794803	admindb	1603794803	admindb	\N	\N	wcol	mne_application	weblet_select
1603794803	admindb	1603794803	admindb	\N	\N	wop	mne_application	weblet_select
1603794803	admindb	1603794803	admindb	\N	\N	weblet	mne_application	weblet_select
1603794803	admindb	1603794803	admindb	\N	\N	type	mne_application	weblet_select
1347537029	admindb	1347537029	admindb	\N	\N	name	mne_application	user
1347537029	admindb	1347537029	admindb	\N	\N	id	mne_application	user
1222088857	admindb	1222088857	admindb	\N	\N	schema	mne_application	table_access
1222088857	admindb	1222088857	admindb	\N	\N	table	mne_application	table_access
1222088857	admindb	1222088857	admindb	Benutzer/Gruppe	user/group	user	mne_application	table_access
1222088857	admindb	1222088857	admindb	\N	\N	privilege	mne_application	table_access
1224836999	admindb	1224836999	admindb	\N	\N	joindefid	mne_application	join_all
1224836999	admindb	1224836999	admindb	\N	\N	schema	mne_application	join_all
1224836999	admindb	1224836999	admindb	\N	\N	table	mne_application	join_all
1224836999	admindb	1224836999	admindb	\N	\N	joindef	mne_application	join_all
1224836999	admindb	1224836999	admindb	\N	\N	fschema	mne_application	join_all
1224836999	admindb	1224836999	admindb	\N	\N	ftab	mne_application	join_all
1224836999	admindb	1224836999	admindb	\N	\N	fcols	mne_application	join_all
1224836999	admindb	1224836999	admindb	\N	\N	tschema	mne_application	join_all
1224836999	admindb	1224836999	admindb	\N	\N	ttab	mne_application	join_all
1224836999	admindb	1224836999	admindb	\N	\N	tcols	mne_application	join_all
1224836999	admindb	1224836999	admindb	\N	\N	op	mne_application	join_all
1224836999	admindb	1224836999	admindb	\N	\N	typ	mne_application	join_all
1224836999	admindb	1224836999	admindb	\N	\N	typtext	mne_application	join_all
1224836999	admindb	1224836999	admindb	\N	\N	createdate	mne_application	join_all
1224836999	admindb	1224836999	admindb	\N	\N	createuser	mne_application	join_all
1224836999	admindb	1224836999	admindb	\N	\N	modifydate	mne_application	join_all
1224836999	admindb	1224836999	admindb	\N	\N	modifyuser	mne_application	join_all
1221575033	admindb	1221575033	admindb	\N	\N	name	mne_application	table_pkey
1221575033	admindb	1221575033	admindb	\N	\N	schema	mne_application	table_pkey
1221575033	admindb	1221575033	admindb	\N	\N	table	mne_application	table_pkey
1221575033	admindb	1221575033	admindb	\N	\N	column	mne_application	table_pkey
1221575033	admindb	1221575033	admindb	\N	\N	position	mne_application	table_pkey
1221575033	admindb	1221575033	admindb	\N	\N	cschema	mne_application	table_pkey
1347869187	admindb	1347869187	admindb	\N	\N	schema	mne_application	usertables
1347869187	admindb	1347869187	admindb	\N	\N	table	mne_application	usertables
1347869187	admindb	1347869187	admindb	\N	\N	text	mne_application	usertables
1410243240	admindb	1410243240	admindb	\N	\N	id	mne_application	procedure
1410243240	admindb	1410243240	admindb	\N	\N	specific_name	mne_application	procedure
1410243240	admindb	1410243240	admindb	\N	\N	text	mne_application	procedure
1410243240	admindb	1410243240	admindb	\N	\N	fullname	mne_application	procedure
1410243240	admindb	1410243240	admindb	\N	\N	name	mne_application	procedure
1410243240	admindb	1410243240	admindb	\N	\N	schema	mne_application	procedure
1410243240	admindb	1410243240	admindb	Eigner	owner	ownername	mne_application	procedure
1410243240	admindb	1410243240	admindb	\N	\N	rettype	mne_application	procedure
1410243240	admindb	1410243240	admindb	Als Eigner	as owner	asowner	mne_application	procedure
1410243240	admindb	1410243240	admindb	\N	\N	access	mne_application	procedure
1410243240	admindb	1410243240	admindb	Volatility	Volatility	provolatile	mne_application	procedure
1305893645	admindb	1305893645	admindb	\N	\N	schema	mne_application	table_fkeys
1305893645	admindb	1305893645	admindb	\N	\N	table	mne_application	table_fkeys
1305893645	admindb	1305893645	admindb	\N	\N	name	mne_application	table_fkeys
1305893645	admindb	1305893645	admindb	\N	\N	column	mne_application	table_fkeys
1305893645	admindb	1305893645	admindb	Referenz Schema	reference schema	rschema	mne_application	table_fkeys
1305893645	admindb	1305893645	admindb	Referenz Tabelle	reference table	rtable	mne_application	table_fkeys
1305893645	admindb	1305893645	admindb	Referenz Spalte	reference column	rcolumn	mne_application	table_fkeys
1305893645	admindb	1305893645	admindb	\N	\N	position	mne_application	table_fkeys
1305893645	admindb	1305893645	admindb	\N	\N	text_de	mne_application	table_fkeys
1305893645	admindb	1305893645	admindb	\N	\N	text_en	mne_application	table_fkeys
1305893645	admindb	1305893645	admindb	\N	\N	custom	mne_application	table_fkeys
1306422520	admindb	1306422520	admindb	\N	\N	queryid	mne_application	query_cols
1306422520	admindb	1306422520	admindb	\N	\N	qschema	mne_application	query_cols
1306422520	admindb	1306422520	admindb	\N	\N	query	mne_application	query_cols
1306422520	admindb	1306422520	admindb	\N	\N	unionnum	mne_application	query_cols
1306422520	admindb	1306422520	admindb	\N	\N	colnum	mne_application	query_cols
1306422520	admindb	1306422520	admindb	\N	\N	schema	mne_application	query_cols
1306422520	admindb	1306422520	admindb	\N	\N	table	mne_application	query_cols
1306422520	admindb	1306422520	admindb	\N	\N	columnid	mne_application	query_cols
1306422520	admindb	1306422520	admindb	\N	type	typ	mne_application	query_cols
1306422520	admindb	1306422520	admindb	\N	\N	format	mne_application	query_cols
1306422520	admindb	1306422520	admindb	having	having	musthaving	mne_application	query_cols
1305796442	admindb	1305796442	admindb	\N	\N	schema	mne_application	table_index
1305796442	admindb	1305796442	admindb	\N	\N	table	mne_application	table_index
1305796442	admindb	1305796442	admindb	\N	\N	index	mne_application	table_index
1305796442	admindb	1305796442	admindb	\N	\N	isunique	mne_application	table_index
1305796442	admindb	1305796442	admindb	\N	\N	text_de	mne_application	table_index
1305796442	admindb	1305796442	admindb	\N	\N	text_en	mne_application	table_index
1305796442	admindb	1305796442	admindb	\N	\N	custom	mne_application	table_index
1306422520	admindb	1306422520	admindb	\N	\N	field	mne_application	query_cols
1306422520	admindb	1306422520	admindb	\N	\N	tabnum	mne_application	query_cols
1306422520	admindb	1306422520	admindb	\N	\N	groupby	mne_application	query_cols
1306422520	admindb	1306422520	admindb	Sprache	language	lang	mne_application	query_cols
1410256508	admindb	1410256508	admindb	Eigner	\N	owner	mne_application	table_all
1410256508	admindb	1410256508	admindb	Tabelle	\N	table	mne_application	table_all
1410256508	admindb	1410256508	admindb	Typ	type	relkind	mne_application	table_all
1410256508	admindb	1410256508	admindb	History	history	showhistory	mne_application	table_all
1410256508	admindb	1410256508	admindb	User/Time Spalten	user/time columns	haveusertimecolumn	mne_application	table_all
1512555690	admindb	1512555690	admindb	\N	\N	schema	mne_application	table_index_column
1512555690	admindb	1512555690	admindb	\N	\N	table	mne_application	table_index_column
1512555690	admindb	1512555690	admindb	Index	\N	index	mne_application	table_index_column
1512555690	admindb	1512555690	admindb	Unique	\N	isunique	mne_application	table_index_column
1512555690	admindb	1512555690	admindb	Spalte	\N	column	mne_application	table_index_column
1512555690	admindb	1512555690	admindb	Postion	\N	position	mne_application	table_index_column
1512555690	admindb	1512555690	admindb	\N	\N	text_de	mne_application	table_index_column
1512555690	admindb	1512555690	admindb	\N	\N	text_en	mne_application	table_index_column
1512555690	admindb	1512555690	admindb	\N	\N	custom	mne_application	table_index_column
1473783246	admindb	1473783246	admindb	\N	\N	sharesid	mne_system	shares
1473783246	admindb	1473783246	admindb	\N	\N	folderid	mne_system	shares
1473783246	admindb	1473783246	admindb	\N	\N	personid	mne_system	shares
1473783246	admindb	1473783246	admindb	\N	\N	readwrite	mne_system	shares
1473783246	admindb	1473783246	admindb	\N	\N	location	mne_system	shares
1473783246	admindb	1473783246	admindb	\N	\N	name	mne_system	shares
1473783246	admindb	1473783246	admindb	\N	\N	description	mne_system	shares
1473783246	admindb	1473783246	admindb	\N	\N	firstname	mne_system	shares
1473783246	admindb	1473783246	admindb	\N	\N	lastname	mne_system	shares
1473783246	admindb	1473783246	admindb	Name	name	fullname	mne_system	shares
1473783246	admindb	1473783246	admindb	\N	\N	company	mne_system	shares
1473783246	admindb	1473783246	admindb	Webdav Zugriff	webdav access	havedav	mne_system	shares
1473783246	admindb	1473783246	admindb	Smb Zugriff	smb access	havesmb	mne_system	shares
1459515687	admindb	1459515687	admindb	\N	\N	certcaid	mne_system	certca
1459515687	admindb	1459515687	admindb	\N	\N	country	mne_system	certca
1459515687	admindb	1459515687	admindb	\N	\N	state	mne_system	certca
1459515687	admindb	1459515687	admindb	\N	\N	city	mne_system	certca
1459515687	admindb	1459515687	admindb	\N	\N	org	mne_system	certca
1459515687	admindb	1459515687	admindb	\N	\N	orgunit	mne_system	certca
1459515687	admindb	1459515687	admindb	\N	\N	email	mne_system	certca
1459515687	admindb	1459515687	admindb	Passwort	password	passwd	mne_system	certca
1459515687	admindb	1459515687	admindb	\N	\N	createdate	mne_system	certca
1459515687	admindb	1459515687	admindb	\N	\N	createuser	mne_system	certca
1459515687	admindb	1459515687	admindb	\N	\N	modifydate	mne_system	certca
1459515687	admindb	1459515687	admindb	\N	\N	modifyuser	mne_system	certca
1459515687	admindb	1459515687	admindb	Zertifikat erneuern	renew certificate	overwrite	mne_system	certca
1477560480	admindb	1477560480	admindb	\N	\N	mailaliasid	mne_system	mailalias
1477560480	admindb	1477560480	admindb	\N	\N	alias	mne_system	mailalias
1477560480	admindb	1477560480	admindb	\N	\N	loginname	mne_system	mailalias
1477560480	admindb	1477560480	admindb	\N	\N	personid	mne_system	mailalias
1477560480	admindb	1477560480	admindb	\N	\N	createdate	mne_system	mailalias
1477560480	admindb	1477560480	admindb	\N	\N	createuser	mne_system	mailalias
1477560480	admindb	1477560480	admindb	\N	\N	modifydate	mne_system	mailalias
1477560480	admindb	1477560480	admindb	\N	\N	modifyuser	mne_system	mailalias
1465828142	admindb	1465828142	admindb	\N	\N	modifydate	mne_application	weblet_all
1465828121	admindb	1465828121	admindb	\N	\N	htmlcomposeid	mne_application	weblet
1465828121	admindb	1465828121	admindb	\N	\N	name	mne_application	weblet
1465828121	admindb	1465828121	admindb	\N	\N	template	mne_application	weblet
1465828121	admindb	1465828121	admindb	\N	\N	label	mne_application	weblet
1465828121	admindb	1465828121	admindb	\N	\N	custom	mne_application	weblet
1465828121	admindb	1465828121	admindb	\N	\N	customall	mne_application	weblet
1465828142	admindb	1465828142	admindb	\N	\N	htmlcomposeid	mne_application	weblet_all
1465828142	admindb	1465828142	admindb	Name	\N	name	mne_application	weblet_all
1465828142	admindb	1465828142	admindb	Vorlage	\N	template	mne_application	weblet_all
1465828142	admindb	1465828142	admindb	Deutsch	german	label_de	mne_application	weblet_all
1465828142	admindb	1465828142	admindb	Englisch	english	label_en	mne_application	weblet_all
1465828142	admindb	1465828142	admindb	Beschriftung	\N	label	mne_application	weblet_all
1465828142	admindb	1465828142	admindb	\N	\N	createdate	mne_application	weblet_all
1465828142	admindb	1465828142	admindb	\N	\N	createuser	mne_application	weblet_all
1465828142	admindb	1465828142	admindb	\N	\N	modifyuser	mne_application	weblet_all
1465828142	admindb	1465828142	admindb	\N	\N	custom	mne_application	weblet_all
1465828142	admindb	1465828142	admindb	\N	\N	customall	mne_application	weblet_all
1478018905	admindb	1478018905	admindb	\N	\N	personid	mne_system	personsharepasswd
1478018905	admindb	1478018905	admindb	\N	\N	loginname	mne_system	personsharepasswd
1478018905	admindb	1478018905	admindb	\N	\N	validuntil	mne_system	personsharepasswd
1478018905	admindb	1478018905	admindb	Passwort	password	passwd1	mne_system	personsharepasswd
1478018905	admindb	1478018905	admindb	Passwort wiederhohlen	password check	passwd2	mne_system	personsharepasswd
1478018905	admindb	1478018905	admindb	\N	\N	firstname	mne_system	personsharepasswd
1478018905	admindb	1478018905	admindb	\N	\N	lastname	mne_system	personsharepasswd
1478018905	admindb	1478018905	admindb	Name	name	fullname	mne_system	personsharepasswd
1478018905	admindb	1478018905	admindb	\N	\N	refname	mne_system	personsharepasswd
1478018905	admindb	1478018905	admindb	Webdav Zugriff	webdav access	havedav	mne_system	personsharepasswd
1478018905	admindb	1478018905	admindb	SMB Zugriff	smb access	havesmb	mne_system	personsharepasswd
1515764924	admindb	1515764924	admindb	\N	\N	htmlcomposetabid	mne_application	weblet_detail
1515764924	admindb	1515764924	admindb	\N	\N	htmlcomposeid	mne_application	weblet_detail
1515764924	admindb	1515764924	admindb	\N	\N	name	mne_application	weblet_detail
1515764924	admindb	1515764924	admindb	\N	\N	id	mne_application	weblet_detail
1515764924	admindb	1515764924	admindb	\N	\N	depend	mne_application	weblet_detail
1515764924	admindb	1515764924	admindb	\N	\N	position	mne_application	weblet_detail
1515764924	admindb	1515764924	admindb	\N	\N	subposition	mne_application	weblet_detail
1515764924	admindb	1515764924	admindb	\N	\N	path	mne_application	weblet_detail
1515764924	admindb	1515764924	admindb	\N	\N	initpar	mne_application	weblet_detail
1515764924	admindb	1515764924	admindb	\N	\N	loadpos	mne_application	weblet_detail
1515764924	admindb	1515764924	admindb	\N	\N	ugroup	mne_application	weblet_detail
1515764924	admindb	1515764924	admindb	\N	\N	custom	mne_application	weblet_detail
1515764924	admindb	1515764924	admindb	Deutsch	german	label_de	mne_application	weblet_detail
1515764924	admindb	1515764924	admindb	Englisch	englisch	label_en	mne_application	weblet_detail
1515764924	admindb	1515764924	admindb	Beschriftung	label	label	mne_application	weblet_detail
1515764924	admindb	1515764924	admindb	\N	\N	namecustom	mne_application	weblet_detail
1515764924	admindb	1515764924	admindb	\N	\N	createdate	mne_application	weblet_detail
1515764924	admindb	1515764924	admindb	\N	\N	modifydate	mne_application	weblet_detail
1515764924	admindb	1515764924	admindb	\N	\N	createuser	mne_application	weblet_detail
1515764924	admindb	1515764924	admindb	\N	\N	modifyuser	mne_application	weblet_detail
1515764924	admindb	1515764924	admindb	angepasst	customized	customall	mne_application	weblet_detail
1516204173	admindb	1516204173	admindb	Gruppe	\N	group	mne_application	group
1522137609	admindb	1522137609	admindb	Tabelle	\N	table	mne_application	table_cols
1522137609	admindb	1522137609	admindb	Spalte	\N	column	mne_application	table_cols
1522137609	admindb	1522137609	admindb	\N	\N	defvalue	mne_application	table_cols
1522137609	admindb	1522137609	admindb	\N	\N	column_default	mne_application	table_cols
1522137609	admindb	1522137609	admindb	Orginal Typ	\N	origtyp	mne_application	table_cols
1522137609	admindb	1522137609	admindb	L??nge	length	maxlength	mne_application	table_cols
1522137609	admindb	1522137609	admindb	Typ	\N	typ	mne_application	table_cols
1522137609	admindb	1522137609	admindb	\N	\N	ntyp	mne_application	table_cols
1522137609	admindb	1522137609	admindb	\N	\N	default	mne_application	table_cols
1522137609	admindb	1522137609	admindb	\N	\N	nullable	mne_application	table_cols
1522137609	admindb	1522137609	admindb	History	history	showhistory	mne_application	table_cols
1522137609	admindb	1522137609	admindb	Deutsch	german	text_de	mne_application	table_cols
1522137609	admindb	1522137609	admindb	Englisch	english	text_en	mne_application	table_cols
1522137609	admindb	1522137609	admindb	Anzeige Typ	display type	ndpytype	mne_application	table_cols
1522137609	admindb	1522137609	admindb	Anzeige Typ	display type	dpytype	mne_application	table_cols
1522137609	admindb	1522137609	admindb	\N	\N	regexp	mne_application	table_cols
1522137609	admindb	1522137609	admindb	\N	\N	regexphelp	mne_application	table_cols
1522137609	admindb	1522137609	admindb	\N	\N	custom	mne_application	table_cols
1522155621	admindb	1522155621	admindb	\N	\N	name	mne_application	selectlist
1522155621	admindb	1522155621	admindb	\N	\N	num	mne_application	selectlist
1522155621	admindb	1522155621	admindb	\N	\N	value	mne_application	selectlist
1522155621	admindb	1522155621	admindb	\N	\N	text	mne_application	selectlist
1553754877	admindb	1553754877	admindb	\N	\N	apachemodid	mne_system	apachemod
1553754877	admindb	1553754877	admindb	\N	\N	hostname	mne_system	apachemod
1553754877	admindb	1553754877	admindb	\N	\N	enabled	mne_system	apachemod
1553754877	admindb	1553754877	admindb	\N	\N	createdate	mne_system	apachemod
1553754877	admindb	1553754877	admindb	\N	\N	createuser	mne_system	apachemod
1553754877	admindb	1553754877	admindb	\N	\N	modifydate	mne_system	apachemod
1553754877	admindb	1553754877	admindb	\N	\N	modifyuser	mne_system	apachemod
1553755649	admindb	1553755649	admindb	\N	\N	apachesiteid	mne_system	apachesite
1553755649	admindb	1553755649	admindb	\N	\N	enabled	mne_system	apachesite
1553755649	admindb	1553755649	admindb	\N	\N	hostname	mne_system	apachesite
1553755649	admindb	1553755649	admindb	\N	\N	domain	mne_system	apachesite
1553755649	admindb	1553755649	admindb	\N	\N	alias	mne_system	apachesite
1553755649	admindb	1553755649	admindb	\N	\N	documentroot	mne_system	apachesite
1553755649	admindb	1553755649	admindb	\N	\N	email	mne_system	apachesite
1553755649	admindb	1553755649	admindb	\N	\N	httpsonly	mne_system	apachesite
1553755649	admindb	1553755649	admindb	\N	\N	conftext	mne_system	apachesite
1553755649	admindb	1553755649	admindb	\N	\N	lastread	mne_system	apachesite
1610369005	admindb	1610369005	admindb	\N	\N	show	mne_application	menu
1553755649	admindb	1553755649	admindb	Zertifikat erneuern	renew certificate	renewcert	mne_system	apachesite
1553755649	admindb	1553755649	admindb	CA Passwort	ca password	passwd	mne_system	apachesite
1553755649	admindb	1553755649	admindb	\N	\N	createdate	mne_system	apachesite
1553755649	admindb	1553755649	admindb	\N	\N	createuser	mne_system	apachesite
1553755649	admindb	1553755649	admindb	\N	\N	modifydate	mne_system	apachesite
1553755649	admindb	1553755649	admindb	\N	\N	modifyuser	mne_system	apachesite
1553755649	admindb	1553755649	admindb	\N	\N	port	mne_system	apachesite
1553755649	admindb	1553755649	admindb	\N	\N	sport	mne_system	apachesite
1553766118	admindb	1553766118	admindb	\N	\N	sogoid	mne_system	sogo
1553766118	admindb	1553766118	admindb	Zertifikat vorhanden	certifikates ok	certok	mne_system	sogo
1553766118	admindb	1553766118	admindb	Domain vorhanden	domain ok	domainok	mne_system	sogo
1553766118	admindb	1553766118	admindb	\N	\N	mailcanonical	mne_system	sogo
1553766118	admindb	1553766118	admindb	\N	\N	mailrelay	mne_system	sogo
1553766118	admindb	1553766118	admindb	\N	\N	mailrelayuser	mne_system	sogo
1553766118	admindb	1553766118	admindb	Mail Passwort	mail password	mailrelaypassword	mne_system	sogo
1553766118	admindb	1553766118	admindb	CA Passwort	ca password	passwd	mne_system	sogo
1553766118	admindb	1553766118	admindb	\N	\N	createdate	mne_system	sogo
1553766118	admindb	1553766118	admindb	\N	\N	createuser	mne_system	sogo
1553766118	admindb	1553766118	admindb	\N	\N	modifydate	mne_system	sogo
1553766118	admindb	1553766118	admindb	\N	\N	modifyuser	mne_system	sogo
1578380726	admindb	1578380726	admindb	\N	\N	dnsaddressid	mne_system	dnsaddress
1578380726	admindb	1578380726	admindb	\N	\N	name	mne_system	dnsaddress
1578380726	admindb	1578380726	admindb	\N	\N	address	mne_system	dnsaddress
1578380726	admindb	1578380726	admindb	\N	\N	record	mne_system	dnsaddress
1578380726	admindb	1578380726	admindb	\N	\N	fix	mne_system	dnsaddress
1578380726	admindb	1578380726	admindb	\N	\N	mac	mne_system	dnsaddress
1578380726	admindb	1578380726	admindb	\N	\N	comment	mne_system	dnsaddress
1578380726	admindb	1578380726	admindb	\N	\N	createdate	mne_system	dnsaddress
1578380726	admindb	1578380726	admindb	\N	\N	createuser	mne_system	dnsaddress
1578380726	admindb	1578380726	admindb	\N	\N	modifydate	mne_system	dnsaddress
1578380726	admindb	1578380726	admindb	\N	\N	modifyuser	mne_system	dnsaddress
1578499160	admindb	1578499160	admindb	\N	\N	domainid	mne_system	domain
1578499160	admindb	1578499160	admindb	\N	\N	domain	mne_system	domain
1578499160	admindb	1578499160	admindb	\N	\N	typ	mne_system	domain
1578499160	admindb	1578499160	admindb	\N	\N	workgroup	mne_system	domain
1578499160	admindb	1578499160	admindb	\N	\N	description	mne_system	domain
1578499160	admindb	1578499160	admindb	\N	\N	netdevice	mne_system	domain
1578499160	admindb	1578499160	admindb	\N	\N	primaryname	mne_system	domain
1578499160	admindb	1578499160	admindb	\N	\N	primaryaddr	mne_system	domain
1578499160	admindb	1578499160	admindb	\N	\N	dnsforwarder	mne_system	domain
1578499160	admindb	1578499160	admindb	\N	\N	dnssearch	mne_system	domain
1578499160	admindb	1578499160	admindb	Administrator	administrator	admin	mne_system	domain
1578499160	admindb	1578499160	admindb	Admin Password	admin password	adminpassword	mne_system	domain
1578499160	admindb	1578499160	admindb	Password Check	password check	adminpassword2	mne_system	domain
1578499160	admindb	1578499160	admindb	\N	\N	dhcpstart	mne_system	domain
1578499160	admindb	1578499160	admindb	\N	\N	dhcpend	mne_system	domain
1578499160	admindb	1578499160	admindb	\N	\N	dhcp6start	mne_system	domain
1578499160	admindb	1578499160	admindb	\N	\N	dhcp6end	mne_system	domain
1578499160	admindb	1578499160	admindb	\N	\N	createdate	mne_system	domain
1578499160	admindb	1578499160	admindb	\N	\N	createuser	mne_system	domain
1578499160	admindb	1578499160	admindb	\N	\N	modifydate	mne_system	domain
1578499160	admindb	1578499160	admindb	\N	\N	modifyuser	mne_system	domain
1579620562	admindb	1579620562	admindb	\N	\N	networkid	mne_system	network
1579620562	admindb	1579620562	admindb	\N	\N	ownnetwork	mne_system	network
1579620562	admindb	1579620562	admindb	Schnittstelle	interface	networkidname	mne_system	network
1579620562	admindb	1579620562	admindb	Rechner	\N	hostname	mne_system	network
1579620562	admindb	1579620562	admindb	vorhanden	\N	available	mne_system	network
1579620562	admindb	1579620562	admindb	\N	\N	search	mne_system	network
1579620562	admindb	1579620562	admindb	\N	\N	typ	mne_system	network
1579620562	admindb	1579620562	admindb	\N	\N	nameserver	mne_system	network
1579620562	admindb	1579620562	admindb	\N	\N	mask	mne_system	network
1579620562	admindb	1579620562	admindb	\N	\N	mask6	mne_system	network
1579620562	admindb	1579620562	admindb	\N	\N	gateway	mne_system	network
1579620562	admindb	1579620562	admindb	\N	\N	domain	mne_system	network
1579620562	admindb	1579620562	admindb	\N	\N	configured	mne_system	network
1579620562	admindb	1579620562	admindb	\N	\N	broadcast	mne_system	network
1579620562	admindb	1579620562	admindb	\N	\N	addr	mne_system	network
1579620562	admindb	1579620562	admindb	\N	\N	addr6	mne_system	network
1579620562	admindb	1579620562	admindb	\N	\N	createdate	mne_system	network
1579620562	admindb	1579620562	admindb	\N	\N	createuser	mne_system	network
1579620562	admindb	1579620562	admindb	\N	\N	modifydate	mne_system	network
1579620562	admindb	1579620562	admindb	\N	\N	modifyuser	mne_system	network
1579620644	admindb	1579620644	admindb	\N	\N	netparamid	mne_system	netparam
1579620644	admindb	1579620644	admindb	\N	\N	domain	mne_system	netparam
1579620644	admindb	1579620644	admindb	\N	\N	search	mne_system	netparam
1579620644	admindb	1579620644	admindb	\N	\N	gw	mne_system	netparam
1579620644	admindb	1579620644	admindb	\N	\N	nameserver	mne_system	netparam
1579620644	admindb	1579620644	admindb	\N	\N	createdate	mne_system	netparam
1579620644	admindb	1579620644	admindb	\N	\N	createuser	mne_system	netparam
1579620644	admindb	1579620644	admindb	\N	\N	modifydate	mne_system	netparam
1579620644	admindb	1579620644	admindb	\N	\N	modifyuser	mne_system	netparam
1610369005	admindb	1610369005	admindb	\N	\N	menuname	mne_application	menu
1610369005	admindb	1610369005	admindb	\N	\N	parentid	mne_application	menu
1610369005	admindb	1610369005	admindb	\N	\N	menuid	mne_application	menu
1610369005	admindb	1610369005	admindb	\N	\N	item	mne_application	menu
1610369005	admindb	1610369005	admindb	\N	\N	action	mne_application	menu
1610369005	admindb	1610369005	admindb	\N	\N	showname	mne_application	menu
1610369005	admindb	1610369005	admindb	\N	\N	editname	mne_application	menu
1610369005	admindb	1610369005	admindb	\N	\N	pos	mne_application	menu
1610369005	admindb	1610369005	admindb	\N	\N	typ	mne_application	menu
1610369005	admindb	1610369005	admindb	Benutzergruppe	\N	ugroup	mne_application	menu
1610369005	admindb	1610369005	admindb	Datenbankgruppe	\N	group	mne_application	menu
1610369005	admindb	1610369005	admindb	\N	\N	rolname	mne_application	menu
1610369005	admindb	1610369005	admindb	\N	\N	mymenu	mne_application	menu
1610519462	admindb	1610519462	admindb	\N	\N	schema	mne_application	table_checks
1610519462	admindb	1610519462	admindb	\N	\N	table	mne_application	table_checks
1610519462	admindb	1610519462	admindb	\N	\N	name	mne_application	table_checks
1610519462	admindb	1610519462	admindb	\N	\N	check	mne_application	table_checks
1610519462	admindb	1610519462	admindb	\N	\N	cschema	mne_application	table_checks
1610519462	admindb	1610519462	admindb	\N	\N	text_de	mne_application	table_checks
1610519462	admindb	1610519462	admindb	\N	\N	text_en	mne_application	table_checks
1610519462	admindb	1610519462	admindb	\N	\N	custom	mne_application	table_checks
\.


--
-- Data for Name: querycolumns; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.querycolumns (createdate, createuser, modifydate, modifyuser, tabnum, colnum, queryid, fieldtyp, lang, colid, field, format, groupby, cannull, musthaving) FROM stdin;
1591195919	admindb	1591195919	admindb	0	4	48de01ca0000	2	0	routine_schema	routine_schema		f	t	f
1216810623	admindb	1216810623	admindb	0	0	test_1	2	0	test	name		f	t	f
1611325733	admindb	1611325733	admindb	52	0	4925b94f0000	2	0	uowncountryname_en	name_en		f	f	f
1459515687	admindb	1459515687	admindb	0	3	56fcfd960000	2	0	city	city		f	f	f
1611325733	admindb	1611325733	admindb	0	1	4925b94f0000	2	0	stylename	stylename		f	f	f
1611325733	admindb	1611325733	admindb	38	2	4925b94f0000	1010	0	uownemail	email		f	f	f
1611325733	admindb	1611325733	admindb	48	3	4925b94f0000	2	0	uownpostcode	postcode		f	f	f
1611325733	admindb	1611325733	admindb	0	4	4925b94f0000	2	0	countrycarcode	countrycarcode		f	f	f
1611325733	admindb	1611325733	admindb	-1	5	4925b94f0000	2	0	cstartweblet	'{ appl : "erp", weblet : "' ||  #0.startweblet || '" }'		f	f	f
1611325733	admindb	1611325733	admindb	0	6	4925b94f0000	2	0	startweblet	startweblet		f	t	f
1611325733	admindb	1611325733	admindb	38	7	4925b94f0000	1011	0	uownhttp	http		f	f	f
1611325733	admindb	1611325733	admindb	33	8	4925b94f0000	2	0	uownpostbox	postbox		f	f	f
1611325733	admindb	1611325733	admindb	-1	9	4925b94f0000	2	0	uowntelefon	CASE WHEN substring(#38.telefon from 1 for 1 ) = '0' THEN substring(#38.telefon from 2 ) ELSE #38.telefon END		f	f	f
1611325733	admindb	1611325733	admindb	38	10	4925b94f0000	2	0	uownfax	fax		f	f	f
1611325733	admindb	1611325733	admindb	-1	11	4925b94f0000	2	0	uowncompany	COALESCE(#31.name, ( SELECT name FROM mne_crm.company WHERE companyid = ( SELECT MIN(companyid) FROM mne_crm.companyown)) )		f	f	f
1611325733	admindb	1611325733	admindb	52	12	4925b94f0000	2	0	uownphoneprefix	phoneprefix		f	f	f
1611325733	admindb	1611325733	admindb	-1	13	4925b94f0000	2	0	regionselect	#0.region || ':' || #0.mslanguage		f	f	f
1611325733	admindb	1611325733	admindb	3	14	4925b94f0000	2	0	personid	personid		f	t	f
1611325733	admindb	1611325733	admindb	0	15	4925b94f0000	2	0	loginname	username		f	f	f
1611325733	admindb	1611325733	admindb	29	16	4925b94f0000	2	0	uownbank	bank		f	f	f
1611325733	admindb	1611325733	admindb	52	17	4925b94f0000	2	0	uowncountryname_de	name_de		f	f	f
1611325733	admindb	1611325733	admindb	59	18	4925b94f0000	2	1	startwebletname	label		f	f	f
1611325733	admindb	1611325733	admindb	-1	19	4925b94f0000	2	0	uowncompanyid	COALESCE(#31.companyid, ( SELECT MIN(companyid) FROM mne_crm.companyown) )		f	f	f
1611325733	admindb	1611325733	admindb	29	20	4925b94f0000	2	0	uownblz	blz		f	f	f
1611325733	admindb	1611325733	admindb	0	21	4925b94f0000	2	0	region	region		f	f	f
1611325733	admindb	1611325733	admindb	61	22	4925b94f0000	2	0	uuid	uuid		f	f	f
1611325733	admindb	1611325733	admindb	0	23	4925b94f0000	2	0	username	username		f	f	f
1611325733	admindb	1611325733	admindb	52	24	4925b94f0000	2	0	uowncountrycarcode	countrycarcode		f	f	f
1611325733	admindb	1611325733	admindb	0	25	4925b94f0000	4	0	debug	debug		f	f	f
1611325733	admindb	1611325733	admindb	0	26	4925b94f0000	2	0	mslanguage	mslanguage		f	f	f
1611325733	admindb	1611325733	admindb	29	27	4925b94f0000	2	0	uownaccount	account		f	f	f
1611325733	admindb	1611325733	admindb	62	28	4925b94f0000	2	0	uowncurrencyid	currencyid		f	f	f
1611325733	admindb	1611325733	admindb	33	29	4925b94f0000	2	0	uownstreet	street		f	f	f
1611325733	admindb	1611325733	admindb	0	30	4925b94f0000	2	0	timezone	timezone		f	f	f
1611325733	admindb	1611325733	admindb	-1	31	4925b94f0000	2	0	fullname	#4.firstname || ' ' || #4.lastname		f	f	f
1611325733	admindb	1611325733	admindb	29	32	4925b94f0000	2	0	uowncompanyownprefix	prefix		f	f	f
1611325733	admindb	1611325733	admindb	55	33	4925b94f0000	2	0	version	version		f	f	f
1611326745	admindb	1611326745	admindb	0	0	600ae1550000	2	0	countrycarcode	countrycarcode		f	f	f
1611326745	admindb	1611326745	admindb	0	1	600ae1550000	4	0	debug	debug		f	f	f
1611326745	admindb	1611326745	admindb	0	2	600ae1550000	2	0	language	language		f	f	f
1611326745	admindb	1611326745	admindb	0	3	600ae1550000	2	0	region	region		f	f	f
1611326745	admindb	1611326745	admindb	0	4	600ae1550000	2	0	startweblet	startweblet		f	t	f
1611326745	admindb	1611326745	admindb	0	5	600ae1550000	2	0	stylename	stylename		f	f	f
1611326745	admindb	1611326745	admindb	0	6	600ae1550000	2	0	timezone	timezone		f	f	f
1611326745	admindb	1611326745	admindb	0	7	600ae1550000	2	0	mslanguage	mslanguage		f	f	f
1611326745	admindb	1611326745	admindb	0	8	600ae1550000	2	0	exportencoding	exportencoding		f	f	f
1611326745	admindb	1611326745	admindb	6	9	600ae1550000	2	1	startwebletname	label		f	f	f
1611326745	admindb	1611326745	admindb	7	10	600ae1550000	2	0	uuid	uuid		f	f	f
1611326745	admindb	1611326745	admindb	0	11	600ae1550000	2	0	username	username		f	f	f
1611326745	admindb	1611326745	admindb	0	12	600ae1550000	2	0	loginname	username		f	f	f
1611326745	admindb	1611326745	admindb	-1	13	600ae1550000	2	0	regionselect	#0.region || ':' || #0.mslanguage		f	f	f
1611328123	admindb	1611328123	admindb	0	0	4b41e9050000	2	0	username	usename		f	t	f
1611328123	admindb	1611328123	admindb	-1	1	4b41e9050000	1	0	systemuser	substring(#0.usename from 1 for 4) = 'mne_' OR #0.usename = 'postgres'		f	f	f
1410243240	admindb	1410243240	admindb	-1	0	mne_dbadmin_sqlproc_1	2	0	id	#0.oid		f	f	f
1410243240	admindb	1410243240	admindb	-1	1	mne_dbadmin_sqlproc_1	2	0	specific_name	(#0.proname::text || '_'::text) || #0.oid::text		f	f	f
1610369005	admindb	1610369005	admindb	0	10	mne_application_menu_1	2	0	ugroup	ugroup		f	f	f
1410243240	admindb	1410243240	admindb	-1	2	mne_dbadmin_sqlproc_1	2	0	text	trim(both ' ' from #0.prosrc)		f	f	f
1410243240	admindb	1410243240	admindb	-1	3	mne_dbadmin_sqlproc_1	2	0	fullname	#0.proname || mne_catalog.pgplsql_fargs(#0.oid)		f	f	f
1410243240	admindb	1410243240	admindb	0	4	mne_dbadmin_sqlproc_1	2	0	name	proname		f	f	f
1410243240	admindb	1410243240	admindb	3	5	mne_dbadmin_sqlproc_1	2	0	schema	nspname		f	f	f
1410243240	admindb	1410243240	admindb	1	6	mne_dbadmin_sqlproc_1	2	0	ownername	rolname		f	t	f
1410243240	admindb	1410243240	admindb	-1	7	mne_dbadmin_sqlproc_1	2	0	rettype	CASE WHEN #0.proretset THEN 'SETOF ' ELSE '' END || CASE WHEN #5.relname IS NULL THEN #4.typname ELSE #7.nspname || '.' || #5.relname END		f	f	f
1410243240	admindb	1410243240	admindb	0	8	mne_dbadmin_sqlproc_1	1	0	asowner	prosecdef		f	f	f
1410243240	admindb	1410243240	admindb	-1	9	mne_dbadmin_sqlproc_1	2	0	access	array_to_string(#0.proacl, ',')		f	f	f
1410243240	admindb	1410243240	admindb	0	10	mne_dbadmin_sqlproc_1	2	0	provolatile	provolatile		f	f	f
1603197205	admindb	1603197205	admindb	0	0	48b44ed00000	2	0	htmlcomposetabid	htmlcomposetabid		f	f	f
1603197205	admindb	1603197205	admindb	0	1	48b44ed00000	2	0	htmlcomposeid	htmlcomposeid		f	f	f
1603197205	admindb	1603197205	admindb	8	2	48b44ed00000	2	0	name	name		f	f	f
1603197205	admindb	1603197205	admindb	0	3	48b44ed00000	2	0	id	id		f	f	f
1603197205	admindb	1603197205	admindb	0	4	48b44ed00000	2	0	depend	depend		f	f	f
1603197205	admindb	1603197205	admindb	0	5	48b44ed00000	2	0	position	position		f	f	f
1603197205	admindb	1603197205	admindb	0	6	48b44ed00000	4	0	subposition	subposition		f	f	f
1603197205	admindb	1603197205	admindb	0	7	48b44ed00000	2	0	path	path		f	f	f
1603197205	admindb	1603197205	admindb	0	8	48b44ed00000	2	0	initpar	initpar		f	f	f
1603197205	admindb	1603197205	admindb	0	9	48b44ed00000	4	0	loadpos	loadpos		f	f	f
1603197205	admindb	1603197205	admindb	0	10	48b44ed00000	2	0	ugroup	ugroup		f	f	f
1603197205	admindb	1603197205	admindb	0	11	48b44ed00000	1	0	custom	custom		f	f	f
1603197205	admindb	1603197205	admindb	7	12	48b44ed00000	2	0	label_de	label_de		f	f	f
1603197205	admindb	1603197205	admindb	7	13	48b44ed00000	2	0	label_en	label_en		f	f	f
1603197205	admindb	1603197205	admindb	7	14	48b44ed00000	2	1	label	label		f	f	f
1603197205	admindb	1603197205	admindb	7	15	48b44ed00000	1	0	namecustom	custom		f	f	f
1603197205	admindb	1603197205	admindb	7	16	48b44ed00000	1000	0	createdate	createdate		f	f	f
1603197205	admindb	1603197205	admindb	7	17	48b44ed00000	1000	0	modifydate	modifydate		f	f	f
1603197205	admindb	1603197205	admindb	7	18	48b44ed00000	2	0	createuser	createuser		f	f	f
1603197205	admindb	1603197205	admindb	7	19	48b44ed00000	2	0	modifyuser	modifyuser		f	f	f
1603197205	admindb	1603197205	admindb	2	20	48b44ed00000	2	0	rolname	rolname		f	t	f
1603197205	admindb	1603197205	admindb	6	21	48b44ed00000	2	0	loginname	rolname		f	t	f
1603197205	admindb	1603197205	admindb	-1	22	48b44ed00000	1	0	groupexists	#0.ugroup = '' OR #2.rolname IS NOT NULL		f	f	f
1603197205	admindb	1603197205	admindb	-1	23	48b44ed00000	1	0	customall	#0.custom OR #7.custom		f	f	f
1516204173	admindb	1516204173	admindb	0	0	4b39feaa0000	2	0	group	rolname		f	t	f
1459515687	admindb	1459515687	admindb	0	4	56fcfd960000	2	0	org	org		f	f	f
1579620562	admindb	1579620562	admindb	0	8	57da3e460000	2	0	mask	mask		f	f	f
1347537029	admindb	1347537029	admindb	0	0	48e65ec40000	2	0	name	rolname		f	t	f
1347537029	admindb	1347537029	admindb	0	1	48e65ec40000	4	0	id	oid		f	t	f
1134650009	admindb	1134650009	admindb	2	10	mne_crmbase_product_detail_1	2	0	treeparentname	treename		f	f	f
1108742170	admindb	1108742170	admindb	0	3	mne_crmbase_country_no_phoneprefix_1	2	1	continent	continent		f	f	f
1106570498	admindb	1106570498	admindb	1	5	mne_crmbase_city_detail_1	2	1	continent	continent		f	f	f
1107183325	admindb	1107183325	admindb	0	0	mne_dbadmin_menu_1	2	0	id	id		f	f	f
1107183325	admindb	1107183325	admindb	0	1	mne_dbadmin_menu_1	4	0	menunum	menunum		f	f	f
1107183325	admindb	1107183325	admindb	0	2	mne_dbadmin_menu_1	2	0	menuname	menuname		f	f	f
1107183325	admindb	1107183325	admindb	2	3	mne_dbadmin_menu_1	2	0	menuname_de	text_de		f	f	f
1107183325	admindb	1107183325	admindb	2	4	mne_dbadmin_menu_1	2	0	menuname_en	text_en		f	f	f
1107183325	admindb	1107183325	admindb	0	5	mne_dbadmin_menu_1	4	0	itemnum	itemnum		f	f	f
1107183325	admindb	1107183325	admindb	0	6	mne_dbadmin_menu_1	2	0	itemname	itemname		f	f	f
1221575033	admindb	1221575033	admindb	0	0	48cf6c950000	2	0	name	constraint_name		f	t	f
1221575033	admindb	1221575033	admindb	0	1	48cf6c950000	2	0	schema	table_schema		f	t	f
1221575033	admindb	1221575033	admindb	0	2	48cf6c950000	2	0	table	table_name		f	t	f
1221575033	admindb	1221575033	admindb	1	3	48cf6c950000	2	0	column	column_name		f	t	f
1221575033	admindb	1221575033	admindb	1	4	48cf6c950000	-10635	0	position	ordinal_position		f	t	f
1221575033	admindb	1221575033	admindb	0	5	48cf6c950000	2	0	cschema	constraint_schema		f	t	f
1222088857	admindb	1222088857	admindb	0	0	48d798200000	2	0	schema	table_schema		f	t	f
1222088857	admindb	1222088857	admindb	0	1	48d798200000	2	0	table	table_name		f	t	f
1222088857	admindb	1222088857	admindb	0	2	48d798200000	2	0	user	grantee		f	t	f
1222088857	admindb	1222088857	admindb	0	3	48d798200000	2	0	privilege	privilege_type		f	t	f
1107183325	admindb	1107183325	admindb	1	7	mne_dbadmin_menu_1	2	0	itemname_de	text_de		f	f	f
1107183325	admindb	1107183325	admindb	1	8	mne_dbadmin_menu_1	2	0	itemname_en	text_en		f	f	f
1134650009	admindb	1134650009	admindb	0	0	mne_crmbase_product_detail_1	2	0	productid	productid		f	f	f
1134650009	admindb	1134650009	admindb	0	1	mne_crmbase_product_detail_1	2	0	name	name		f	f	f
1134650009	admindb	1134650009	admindb	0	2	mne_crmbase_product_detail_1	2	0	description	description		f	f	f
1134650009	admindb	1134650009	admindb	0	3	mne_crmbase_product_detail_1	4	0	createdate	createdate		f	f	f
1134650009	admindb	1134650009	admindb	0	4	mne_crmbase_product_detail_1	2	0	createuser	createuser		f	f	f
1134650009	admindb	1134650009	admindb	0	5	mne_crmbase_product_detail_1	2	0	modifyuser	modifyuser		f	f	f
1134650009	admindb	1134650009	admindb	0	6	mne_crmbase_product_detail_1	4	0	modifydate	modifydate		f	f	f
1134650009	admindb	1134650009	admindb	1	7	mne_crmbase_product_detail_1	2	0	treeid	treeid		f	f	f
1134650009	admindb	1134650009	admindb	1	8	mne_crmbase_product_detail_1	2	0	treename	treename		f	f	f
1134650009	admindb	1134650009	admindb	1	9	mne_crmbase_product_detail_1	2	0	treeparentid	parentid		f	f	f
1107183325	admindb	1107183325	admindb	0	9	mne_dbadmin_menu_1	4	0	deep	deep		f	f	f
1107183325	admindb	1107183325	admindb	0	10	mne_dbadmin_menu_1	2	0	target	target		f	f	f
1107183325	admindb	1107183325	admindb	0	11	mne_dbadmin_menu_1	2	0	owner	owner		f	f	f
1107183325	admindb	1107183325	admindb	0	12	mne_dbadmin_menu_1	2	0	menu_action	menu_action		f	f	f
1107183325	admindb	1107183325	admindb	0	13	mne_dbadmin_menu_1	2	0	menu_actiontype	menu_actiontype		f	f	f
1107183325	admindb	1107183325	admindb	0	14	mne_dbadmin_menu_1	2	0	menu_actionname	menu_actionname		f	f	f
1107784945	admindb	1107784945	admindb	0	0	mne_dbadmin_screen_1	2	0	name	name		f	f	f
1107784945	admindb	1107784945	admindb	0	1	mne_dbadmin_screen_1	2	0	template	template		f	f	f
1107784945	admindb	1107784945	admindb	1	2	mne_dbadmin_screen_1	2	0	label_de	label_de		f	f	f
1107784945	admindb	1107784945	admindb	1	3	mne_dbadmin_screen_1	2	0	label_en	label_en		f	f	f
1106061401	admindb	1108742031	admindb	0	2	mne_crmbase_country_1	2	0	countrycarcode	countrycarcode		f	f	f
1108742170	admindb	1108742170	admindb	0	0	mne_crmbase_country_no_phoneprefix_1	2	0	countryid	countryid		f	f	f
1305893645	admindb	1305893645	admindb	0	1	48cfa87a0000	2	0	table	table		f	t	f
1108742170	admindb	1108742170	admindb	0	1	mne_crmbase_country_no_phoneprefix_1	2	1	country	name		f	f	f
1108742170	admindb	1108742170	admindb	0	2	mne_crmbase_country_no_phoneprefix_1	2	0	countrycarcode	countrycarcode		f	f	f
1127831494	admindb	1127831494	admindb	0	0	mne_crmbase_address_list_1	2	0	addressid	addressid		f	f	f
1127831494	admindb	1127831494	admindb	1	1	mne_crmbase_address_list_1	2	1	addresstyp	addresstyp		f	f	f
1127831494	admindb	1127831494	admindb	0	2	mne_crmbase_address_list_1	2	0	refid	refid		f	f	f
1127831494	admindb	1127831494	admindb	0	3	mne_crmbase_address_list_1	2	0	street	street		f	f	f
1127831494	admindb	1127831494	admindb	0	4	mne_crmbase_address_list_1	2	0	postbox	postbox		f	f	f
1127831494	admindb	1127831494	admindb	2	5	mne_crmbase_address_list_1	2	0	postcode	postcode		f	f	f
1127831494	admindb	1127831494	admindb	2	6	mne_crmbase_address_list_1	2	0	city	name		f	f	f
1127831494	admindb	1127831494	admindb	3	7	mne_crmbase_address_list_1	2	1	country	name		f	f	f
1128001062	admindb	1128001062	admindb	0	0	mne_crmbase_address_detail_1	2	0	refid	refid		f	f	f
1128001062	admindb	1128001062	admindb	0	1	mne_crmbase_address_detail_1	2	0	addressid	addressid		f	f	f
1128001062	admindb	1128001062	admindb	0	2	mne_crmbase_address_detail_1	2	0	addresstypid	addresstypid		f	f	f
1128001062	admindb	1128001062	admindb	0	3	mne_crmbase_address_detail_1	2	0	street	street		f	f	f
1128001062	admindb	1128001062	admindb	0	4	mne_crmbase_address_detail_1	2	0	postbox	postbox		f	f	f
1128001062	admindb	1128001062	admindb	0	5	mne_crmbase_address_detail_1	2	0	cityid	cityid		f	f	f
1128001062	admindb	1128001062	admindb	1	6	mne_crmbase_address_detail_1	2	0	postcode	postcode		f	f	f
1128001062	admindb	1128001062	admindb	1	7	mne_crmbase_address_detail_1	2	0	city	name		f	f	f
1106061401	admindb	1132320361	admindb	0	0	mne_crmbase_country_1	2	0	countryid	countryid		f	f	f
1132759801	admindb	1132759801	admindb	0	0	mne_dbadmin_screen_tabs_1	2	0	name	name		f	f	f
1132759801	admindb	1132759801	admindb	0	1	mne_dbadmin_screen_tabs_1	2	0	id	id		f	f	f
1132759801	admindb	1132759801	admindb	0	2	mne_dbadmin_screen_tabs_1	2	0	position	position		f	f	f
1216810934	admindb	1216810934	admindb	0	0	48870fa10000_2	2	0	test	name		f	t	f
1216811421	admindb	1216811421	admindb	0	0	488710440000_2	2	0	test	name		f	t	f
1216811481	admindb	1216811481	admindb	0	0	48870fa10000_1	2	0	test	name		f	t	f
1410256508	admindb	1410256508	admindb	0	0	4f756c120000	2	0	schema	table_schema		f	t	f
1410256508	admindb	1410256508	admindb	9	1	4f756c120000	2	0	owner	rolname		f	t	f
1410256508	admindb	1410256508	admindb	0	2	4f756c120000	2	0	table	table_name		f	t	f
1410256508	admindb	1410256508	admindb	6	3	4f756c120000	2	0	relkind	relkind		f	f	f
1579620562	admindb	1579620562	admindb	0	9	57da3e460000	2	0	mask6	mask6		f	f	f
1262614071	admindb	1262614071	admindb	0	0	4b41f1940000	2	0	username	usename		f	t	f
1262614071	admindb	1262614071	admindb	-1	1	4b41f1940000	2	0	passwd1	'xxxxxxxxxx'		f	f	f
1262614071	admindb	1262614071	admindb	-1	2	4b41f1940000	2	0	passwd2	'tttttttttt'		f	f	f
1106061401	admindb	1106061401	admindb	0	3	mne_crmbase_country_1	2	1	continent	continent		f	f	f
1224836999	admindb	1224836999	admindb	0	0	48bbe7280000	2	0	joindefid	joindefid		f	f	f
1224836999	admindb	1224836999	admindb	0	1	48bbe7280000	2	0	schema	fschema		f	f	f
1224836999	admindb	1224836999	admindb	0	2	48bbe7280000	2	0	table	ftab		f	f	f
1224836999	admindb	1224836999	admindb	-1	3	48bbe7280000	2	0	joindef	t0.tschema || '.' || t0.ttab || '.' || t0.tcols || ' ' || t0.op || ' ' || t0.fcols || ',' || CASE WHEN t0.typ=0 THEN 'inner' WHEN t0.typ=1 THEN 'left' WHEN t0.typ=2 THEN 'right' WHEN t0.typ=3 THEN 'full' ELSE CAST ( t0.typ AS char ) END		f	f	f
1106570498	admindb	1106570498	admindb	0	0	mne_crmbase_city_detail_1	2	0	name	name		f	f	f
1224836999	admindb	1224836999	admindb	-1	12	48bbe7280000	2	0	typtext	CASE WHEN t0.typ=0 THEN 'inner' WHEN t0.typ=1 THEN 'left' WHEN t0.typ=2 THEN 'right' WHEN t0.typ=3 THEN 'full' ELSE CAST ( t0.typ AS char ) END		f	f	f
1224836999	admindb	1224836999	admindb	0	13	48bbe7280000	4	0	createdate	createdate		f	f	f
1224836999	admindb	1224836999	admindb	0	14	48bbe7280000	2	0	createuser	createuser		f	f	f
1224836999	admindb	1224836999	admindb	0	15	48bbe7280000	4	0	modifydate	modifydate		f	f	f
1224836999	admindb	1224836999	admindb	0	16	48bbe7280000	2	0	modifyuser	modifyuser		f	f	f
1226406260	admindb	1226406260	admindb	-1	0	491979530000	2	0	name	'public'		f	f	f
1226406260	admindb	1226406260	admindb	-1	1	491979530000	2	0	id	-1		f	f	f
1132759801	admindb	1132759801	admindb	0	3	mne_dbadmin_screen_tabs_1	4	0	subposition	subposition		f	f	f
1132759801	admindb	1132759801	admindb	0	4	mne_dbadmin_screen_tabs_1	2	0	path	path		f	f	f
1132759801	admindb	1132759801	admindb	0	5	mne_dbadmin_screen_tabs_1	2	0	initpar	initpar		f	f	f
1132759801	admindb	1132759801	admindb	0	6	mne_dbadmin_screen_tabs_1	2	0	showpar	showpar		f	f	f
1132759801	admindb	1132759801	admindb	0	7	mne_dbadmin_screen_tabs_1	2	0	depend	depend		f	f	f
1132759801	admindb	1132759801	admindb	3	8	mne_dbadmin_screen_tabs_1	2	0	label_de	label_de		f	f	f
1132759801	admindb	1132759801	admindb	3	9	mne_dbadmin_screen_tabs_1	2	0	label_en	label_en		f	f	f
1106061401	admindb	1106061401	admindb	0	1	mne_crmbase_country_1	2	1	country	name		f	f	f
1106570498	admindb	1106570498	admindb	0	1	mne_crmbase_city_detail_1	2	0	postcode	postcode		f	f	f
1106570498	admindb	1106570498	admindb	0	2	mne_crmbase_city_detail_1	2	0	cityid	cityid		f	f	f
1106570498	admindb	1106570498	admindb	0	3	mne_crmbase_city_detail_1	2	0	countryid	countryid		f	f	f
1106570498	admindb	1106570498	admindb	1	4	mne_crmbase_city_detail_1	2	1	country	name		f	f	f
1224836999	admindb	1224836999	admindb	0	4	48bbe7280000	2	0	fschema	fschema		f	f	f
1224836999	admindb	1224836999	admindb	0	5	48bbe7280000	2	0	ftab	ftab		f	f	f
1224836999	admindb	1224836999	admindb	0	6	48bbe7280000	2	0	fcols	fcols		f	f	f
1224836999	admindb	1224836999	admindb	0	7	48bbe7280000	2	0	tschema	tschema		f	f	f
1224836999	admindb	1224836999	admindb	0	8	48bbe7280000	2	0	ttab	ttab		f	f	f
1224836999	admindb	1224836999	admindb	0	9	48bbe7280000	2	0	tcols	tcols		f	f	f
1224836999	admindb	1224836999	admindb	0	10	48bbe7280000	2	0	op	op		f	f	f
1224836999	admindb	1224836999	admindb	0	11	48bbe7280000	4	0	typ	typ		f	f	f
1306422520	admindb	1306422520	admindb	0	14	mne_application_querycols_1	1	0	musthaving	musthaving		f	f	f
1305893645	admindb	1305893645	admindb	0	0	48cfa87a0000	2	0	schema	schema		f	t	f
1306422520	admindb	1306422520	admindb	3	3	mne_application_querycols_1	4	0	unionnum	unionnum		f	f	f
1305893645	admindb	1305893645	admindb	0	2	48cfa87a0000	2	0	name	name		f	t	f
1305893645	admindb	1305893645	admindb	0	3	48cfa87a0000	2	0	column	column		f	t	f
1305893645	admindb	1305893645	admindb	0	4	48cfa87a0000	2	0	rschema	rschema		f	t	f
1305893645	admindb	1305893645	admindb	0	5	48cfa87a0000	2	0	rtable	rtable		f	t	f
1305893645	admindb	1305893645	admindb	0	6	48cfa87a0000	2	0	rcolumn	rcolumn		f	t	f
1305893645	admindb	1305893645	admindb	0	7	48cfa87a0000	4	0	position	position		f	t	f
1305893645	admindb	1305893645	admindb	1	8	48cfa87a0000	2	0	text_de	text_de		f	f	f
1522155621	admindb	1522155621	admindb	0	0	491822b40000	2	0	name	name		f	f	f
1306422520	admindb	1306422520	admindb	0	0	mne_application_querycols_1	2	0	queryid	queryid		f	f	f
1306422520	admindb	1306422520	admindb	3	1	mne_application_querycols_1	2	0	qschema	schema		f	f	f
1306422520	admindb	1306422520	admindb	3	2	mne_application_querycols_1	2	0	query	query		f	f	f
1306422520	admindb	1306422520	admindb	0	4	mne_application_querycols_1	4	0	colnum	colnum		f	f	f
1306422520	admindb	1306422520	admindb	2	6	mne_application_querycols_1	2	0	schema	tschema		f	f	f
1306422520	admindb	1306422520	admindb	2	7	mne_application_querycols_1	2	0	table	ttab		f	f	f
1306422520	admindb	1306422520	admindb	0	9	mne_application_querycols_1	2	0	columnid	colid		f	f	f
1306422520	admindb	1306422520	admindb	0	12	mne_application_querycols_1	4	0	typ	fieldtyp		f	f	f
1306422520	admindb	1306422520	admindb	0	13	mne_application_querycols_1	2	0	format	format		f	f	f
1305893645	admindb	1305893645	admindb	1	9	48cfa87a0000	2	0	text_en	text_en		f	f	f
1305893645	admindb	1305893645	admindb	1	10	48cfa87a0000	1	0	custom	custom		f	f	f
1305796442	admindb	1305796442	admindb	0	0	48e8baa70000	2	0	schema	schema		f	t	f
1305796442	admindb	1305796442	admindb	0	1	48e8baa70000	2	0	table	table		f	t	f
1305796442	admindb	1305796442	admindb	0	2	48e8baa70000	2	0	index	index		f	t	f
1305796442	admindb	1305796442	admindb	0	3	48e8baa70000	1	0	isunique	indisunique		f	t	f
1305796442	admindb	1305796442	admindb	1	4	48e8baa70000	2	0	text_de	text_de		f	f	f
1305796442	admindb	1305796442	admindb	1	5	48e8baa70000	2	0	text_en	text_en		f	f	f
1305796442	admindb	1305796442	admindb	1	6	48e8baa70000	1	0	custom	custom		f	f	f
1306422520	admindb	1306422520	admindb	0	8	mne_application_querycols_1	2	0	field	field		f	f	f
1306422520	admindb	1306422520	admindb	0	5	mne_application_querycols_1	4	0	tabnum	tabnum		f	f	f
1306422520	admindb	1306422520	admindb	0	11	mne_application_querycols_1	1	0	groupby	groupby		f	f	f
1306422520	admindb	1306422520	admindb	0	10	mne_application_querycols_1	4	0	lang	lang		f	f	f
1522155621	admindb	1522155621	admindb	0	1	491822b40000	4	0	num	num		f	f	f
1347869187	admindb	1347869187	admindb	0	0	5056d0e30000	2	0	schema	schemaname		f	f	f
1347869187	admindb	1347869187	admindb	0	1	5056d0e30000	2	0	table	tablename		f	f	f
1347869187	admindb	1347869187	admindb	0	2	5056d0e30000	2	1	text	text		f	f	f
1522155621	admindb	1522155621	admindb	0	2	491822b40000	2	0	value	value		f	f	f
1522155621	admindb	1522155621	admindb	-1	3	491822b40000	2	0	text	COALESCE(NULLIF(#0.text_#mne_langid#,''), value)		f	f	f
1459515687	admindb	1459515687	admindb	0	0	56fcfd960000	2	0	certcaid	certcaid		f	f	f
1459515687	admindb	1459515687	admindb	0	1	56fcfd960000	2	0	country	country		f	f	f
1459515687	admindb	1459515687	admindb	0	2	56fcfd960000	2	0	state	state		f	f	f
1459515687	admindb	1459515687	admindb	0	5	56fcfd960000	2	0	orgunit	orgunit		f	f	f
1459515687	admindb	1459515687	admindb	0	6	56fcfd960000	2	0	email	email		f	f	f
1459515687	admindb	1459515687	admindb	-1	7	56fcfd960000	2	0	passwd	''		f	f	f
1459515687	admindb	1459515687	admindb	0	8	56fcfd960000	4	0	createdate	createdate		f	f	f
1459515687	admindb	1459515687	admindb	0	9	56fcfd960000	2	0	createuser	createuser		f	f	f
1459515687	admindb	1459515687	admindb	0	10	56fcfd960000	4	0	modifydate	modifydate		f	f	f
1459515687	admindb	1459515687	admindb	0	11	56fcfd960000	2	0	modifyuser	modifyuser		f	f	f
1459515687	admindb	1459515687	admindb	-1	12	56fcfd960000	1	0	overwrite	''		f	f	f
1465828142	admindb	1465828142	admindb	0	0	48b3b18a0000	2	0	htmlcomposeid	htmlcomposeid		t	f	f
1512555690	admindb	1512555690	admindb	0	0	48e8bb150000	2	0	schema	schema		f	t	f
1512555690	admindb	1512555690	admindb	0	1	48e8bb150000	2	0	table	table		f	t	f
1512555690	admindb	1512555690	admindb	0	2	48e8bb150000	2	0	index	index		f	t	f
1512555690	admindb	1512555690	admindb	0	3	48e8bb150000	1	0	isunique	indisunique		f	t	f
1512555690	admindb	1512555690	admindb	0	4	48e8bb150000	2	0	column	column		f	t	f
1512555690	admindb	1512555690	admindb	0	5	48e8bb150000	4	0	position	position		f	t	f
1512555690	admindb	1512555690	admindb	1	6	48e8bb150000	2	0	text_de	text_de		f	f	f
1512555690	admindb	1512555690	admindb	1	7	48e8bb150000	2	0	text_en	text_en		f	f	f
1512555690	admindb	1512555690	admindb	1	8	48e8bb150000	1	0	custom	custom		f	f	f
1473783246	admindb	1473783246	admindb	0	0	556831b90000	2	0	sharesid	sharesid		f	f	f
1473783246	admindb	1473783246	admindb	0	1	556831b90000	2	0	folderid	folderid		f	f	f
1473783246	admindb	1473783246	admindb	0	2	556831b90000	2	0	personid	personid		f	f	f
1473783246	admindb	1473783246	admindb	0	3	556831b90000	1	0	readwrite	readwrite		f	f	f
1473783246	admindb	1473783246	admindb	1	4	556831b90000	2	0	location	location		f	f	f
1473783246	admindb	1473783246	admindb	1	5	556831b90000	2	0	name	name		f	f	f
1473783246	admindb	1473783246	admindb	1	6	556831b90000	2	0	description	description		f	f	f
1473783246	admindb	1473783246	admindb	2	7	556831b90000	2	0	firstname	firstname		f	f	f
1473783246	admindb	1473783246	admindb	2	8	556831b90000	2	0	lastname	lastname		f	f	f
1473783246	admindb	1473783246	admindb	-1	9	556831b90000	2	0	fullname	#2.firstname || ' ' || #2.lastname		f	f	f
1473783246	admindb	1473783246	admindb	11	10	556831b90000	2	0	company	name		f	f	f
1473783246	admindb	1473783246	admindb	-1	11	556831b90000	1	0	havedav	#31.group IS NOT NULL		f	f	f
1473783246	admindb	1473783246	admindb	-1	12	556831b90000	1	0	havesmb	#32.group IS NOT NULL		f	f	f
1465828142	admindb	1465828142	admindb	-1	1	48b3b18a0000	2	0	schema	split_part(#0.name, '_', 1)		t	f	f
1478018905	admindb	1478018905	admindb	0	0	5502b8300000	2	0	personid	personid		f	t	f
1478018905	admindb	1478018905	admindb	0	1	5502b8300000	2	0	loginname	loginname		f	t	f
1478018905	admindb	1478018905	admindb	0	2	5502b8300000	4	0	validuntil	validuntil		f	t	f
1478018905	admindb	1478018905	admindb	-1	3	5502b8300000	2	0	passwd1	'********'		f	f	f
1478018905	admindb	1478018905	admindb	-1	4	5502b8300000	2	0	passwd2	'********'		f	f	f
1478018905	admindb	1478018905	admindb	1	5	5502b8300000	2	0	firstname	firstname		f	f	f
1478018905	admindb	1478018905	admindb	1	6	5502b8300000	2	0	lastname	lastname		f	f	f
1478018905	admindb	1478018905	admindb	-1	7	5502b8300000	2	0	fullname	#1.firstname || ' ' || #1.lastname		f	f	f
1478018905	admindb	1478018905	admindb	10	8	5502b8300000	2	0	refname	name		f	f	f
1478018905	admindb	1478018905	admindb	-1	9	5502b8300000	1	0	havedav	#23.group IS NOT NULL		f	f	f
1478018905	admindb	1478018905	admindb	-1	10	5502b8300000	2	0	havesmb	#22.group IS NOT NULL		f	f	f
1465828121	admindb	1465828121	admindb	0	0	48b3b18a0001	2	0	htmlcomposeid	htmlcomposeid		t	f	f
1465828121	admindb	1465828121	admindb	0	1	48b3b18a0001	2	0	name	name		t	f	f
1465828121	admindb	1465828121	admindb	0	2	48b3b18a0001	2	0	template	template		t	f	f
1465828121	admindb	1465828121	admindb	4	3	48b3b18a0001	2	1	label	label		t	f	f
1465828121	admindb	1465828121	admindb	0	4	48b3b18a0001	1	0	custom	custom		t	f	f
1465828121	admindb	1465828121	admindb	-1	5	48b3b18a0001	2	0	customall	#0.custom OR BOOL_OR(#6.custom) OR BOOL_OR(#7.custom)		f	f	t
1465828142	admindb	1465828142	admindb	0	2	48b3b18a0000	2	0	name	name		t	f	f
1465828142	admindb	1465828142	admindb	0	3	48b3b18a0000	2	0	template	template		t	f	f
1465828142	admindb	1465828142	admindb	4	4	48b3b18a0000	2	0	label_de	label_de		t	f	f
1465828142	admindb	1465828142	admindb	4	5	48b3b18a0000	2	0	label_en	label_en		t	f	f
1465828142	admindb	1465828142	admindb	4	6	48b3b18a0000	2	1	label	label		t	f	f
1465828142	admindb	1465828142	admindb	0	7	48b3b18a0000	4	0	modifydate	modifydate		t	f	f
1465828142	admindb	1465828142	admindb	0	8	48b3b18a0000	4	0	createdate	createdate		t	f	f
1465828142	admindb	1465828142	admindb	0	9	48b3b18a0000	2	0	createuser	createuser		t	f	f
1465828142	admindb	1465828142	admindb	0	10	48b3b18a0000	2	0	modifyuser	modifyuser		t	f	f
1465828142	admindb	1465828142	admindb	0	11	48b3b18a0000	1	0	custom	custom		t	f	f
1465828142	admindb	1465828142	admindb	-1	12	48b3b18a0000	1	0	customall	BOOL_OR(#0.custom) OR BOOL_OR(#5.custom) OR BOOL_OR(#6.custom)		f	f	t
1515764924	admindb	1515764924	admindb	0	0	4c85f5440000	2	0	htmlcomposetabid	htmlcomposetabid		f	f	f
1515764924	admindb	1515764924	admindb	0	1	4c85f5440000	2	0	htmlcomposeid	htmlcomposeid		f	f	f
1515764924	admindb	1515764924	admindb	3	2	4c85f5440000	2	0	name	name		f	f	f
1515764924	admindb	1515764924	admindb	0	3	4c85f5440000	2	0	id	id		f	f	f
1515764924	admindb	1515764924	admindb	0	4	4c85f5440000	2	0	depend	depend		f	f	f
1515764924	admindb	1515764924	admindb	0	5	4c85f5440000	2	0	position	position		f	f	f
1515764924	admindb	1515764924	admindb	0	6	4c85f5440000	4	0	subposition	subposition		f	f	f
1515764924	admindb	1515764924	admindb	0	7	4c85f5440000	2	0	path	path		f	f	f
1515764924	admindb	1515764924	admindb	0	8	4c85f5440000	2	0	initpar	initpar		f	f	f
1515764924	admindb	1515764924	admindb	0	9	4c85f5440000	4	0	loadpos	loadpos		f	f	f
1515764924	admindb	1515764924	admindb	0	10	4c85f5440000	2	0	ugroup	ugroup		f	f	f
1515764924	admindb	1515764924	admindb	0	11	4c85f5440000	1	0	custom	custom		f	f	f
1515764924	admindb	1515764924	admindb	2	12	4c85f5440000	2	0	label_de	label_de		f	f	f
1515764924	admindb	1515764924	admindb	2	13	4c85f5440000	2	0	label_en	label_en		f	f	f
1515764924	admindb	1515764924	admindb	2	14	4c85f5440000	2	1	label	label		f	f	f
1515764924	admindb	1515764924	admindb	2	15	4c85f5440000	1	0	namecustom	custom		f	f	f
1515764924	admindb	1515764924	admindb	2	16	4c85f5440000	4	0	createdate	createdate		f	f	f
1515764924	admindb	1515764924	admindb	2	17	4c85f5440000	4	0	modifydate	modifydate		f	f	f
1515764924	admindb	1515764924	admindb	2	18	4c85f5440000	2	0	createuser	createuser		f	f	f
1515764924	admindb	1515764924	admindb	2	19	4c85f5440000	2	0	modifyuser	modifyuser		f	f	f
1515764924	admindb	1515764924	admindb	-1	20	4c85f5440000	1	0	customall	#0.custom OR #2.custom		f	f	f
1477551618	admindb	1477551618	admindb	0	0	5811a5ad0000	2	0	mailaliasid	mailaliasid		f	f	f
1477551618	admindb	1477551618	admindb	0	1	5811a5ad0000	2	0	alias	alias		f	f	f
1477551618	admindb	1477551618	admindb	9	2	5811a5ad0000	2	0	loginname	loginname		f	f	f
1477551618	admindb	1477551618	admindb	0	3	5811a5ad0000	2	0	personid	personid		f	f	f
1477551618	admindb	1477551618	admindb	0	4	5811a5ad0000	4	0	createdate	createdate		f	f	f
1477551618	admindb	1477551618	admindb	0	5	5811a5ad0000	2	0	createuser	createuser		f	f	f
1477551618	admindb	1477551618	admindb	0	6	5811a5ad0000	4	0	modifydate	modifydate		f	f	f
1477551618	admindb	1477551618	admindb	0	7	5811a5ad0000	2	0	modifyuser	modifyuser		f	f	f
1522137609	admindb	1522137609	admindb	0	0	mne_application_table_cols_1	2	0	schema	table_schema		f	t	f
1522137609	admindb	1522137609	admindb	0	1	mne_application_table_cols_1	2	0	table	table_name		f	t	f
1522137609	admindb	1522137609	admindb	0	2	mne_application_table_cols_1	2	0	column	column_name		f	t	f
1522137609	admindb	1522137609	admindb	-1	3	mne_application_table_cols_1	2	0	defvalue	CASE WHEN position('::' in #0.column_default ) = 0 THEN #0.column_default ELSE CASE WHEN position('\\'::' in #0.column_default) >= 2  THEN substring(#0.column_default from 2 for (position('\\'::' in #0.column_default)-2)) ELSE substring(#0.column_default from 0 for position('::' in #0.column_default)) END END		f	f	f
1522137609	admindb	1522137609	admindb	0	4	mne_application_table_cols_1	2	0	column_default	column_default		f	t	f
1522137609	admindb	1522137609	admindb	0	5	mne_application_table_cols_1	2	0	origtyp	data_type		f	t	f
1522137609	admindb	1522137609	admindb	0	6	mne_application_table_cols_1	4	0	maxlength	character_maximum_length		f	t	f
1522137609	admindb	1522137609	admindb	-1	7	mne_application_table_cols_1	2	0	typ	CASE WHEN #0.data_type = 'character varying' THEN 'character'  WHEN #0.data_type = 'smallint' THEN 'short'  WHEN #0.data_type = 'integer' THEN 'long' WHEN #0.data_type = 'real' THEN 'float'  WHEN #0.data_type = 'double precision' THEN 'double' ELSE #0.data_type END		f	f	f
1579620562	admindb	1579620562	admindb	0	17	57da3e460000	2	0	createuser	createuser		f	f	f
1579620562	admindb	1579620562	admindb	0	18	57da3e460000	4	0	modifydate	modifydate		f	f	f
1522137609	admindb	1522137609	admindb	-1	8	mne_application_table_cols_1	2	0	ntyp	CASE WHEN #0.data_type = 'boolean' THEN 1 WHEN #0.data_type = 'character varying' THEN 2 WHEN #0.data_type = 'smallint' THEN 3  WHEN #0.data_type = 'integer' THEN 4 WHEN #0.data_type = 'real' THEN 5  WHEN #0.data_type = 'double precision' THEN 6 ELSE -1 END		f	f	f
1522137609	admindb	1522137609	admindb	-1	9	mne_application_table_cols_1	2	0	default	NOT #0.column_default  ISNULL		f	f	f
1522137609	admindb	1522137609	admindb	-1	10	mne_application_table_cols_1	2	0	nullable	CASE WHEN #0.is_nullable = 'NO' THEN FALSE WHEN #0.is_nullable = 'YES' THEN 'true' END		f	f	f
1522137609	admindb	1522137609	admindb	1	11	mne_application_table_cols_1	1	0	showhistory	showhistory		f	f	f
1522137609	admindb	1522137609	admindb	1	12	mne_application_table_cols_1	2	0	text_de	text_de		f	t	f
1522137609	admindb	1522137609	admindb	1	13	mne_application_table_cols_1	2	0	text_en	text_en		f	t	f
1522137609	admindb	1522137609	admindb	-1	14	mne_application_table_cols_1	2	0	ndpytype	COALESCE(#1.dpytype, -1)		f	f	f
1522137609	admindb	1522137609	admindb	-1	15	mne_application_table_cols_1	2	0	dpytype	CASE WHEN #1.dpytype = -1 THEN 'default' WHEN #1.dpytype =1 THEN 'boolean' WHEN #1.dpytype = 2 THEN 'character' WHEN #1.dpytype = 3 THEN 'short' WHEN #1.dpytype = 4 THEN 'long' WHEN #1.dpytype = 5 THEN 'float' WHEN #1.dpytype = 6 THEN 'double' WHEN #1.dpytype = 1000 THEN 'date/time' WHEN #1.dpytype = 1001 THEN 'date' WHEN #1.dpytype = 1002 THEN 'time' WHEN #1.dpytype = 1003 THEN 'interval'WHEN #1.dpytype = 1004 THEN 'day'WHEN #1.dpytype = 1005 THEN 'quarter' WHEN #1.dpytype = 1010 THEN 'email' WHEN #1.dpytype = 1011 THEN 'link' WHEN #1.dpytype = 1100 THEN 'from column'  WHEN #1.dpytype is null THEN 'default' ELSE CAST ( #1.dpytype as character ) END		f	f	f
1522137609	admindb	1522137609	admindb	1	16	mne_application_table_cols_1	2	0	regexp	regexp		f	t	f
1522137609	admindb	1522137609	admindb	1	17	mne_application_table_cols_1	2	0	regexphelp	regexphelp		f	t	f
1522137609	admindb	1522137609	admindb	-1	18	mne_application_table_cols_1	2	0	custom	CASE WHEN #1.custom THEN 1 ELSE 0 END		f	f	f
1553754877	admindb	1553754877	admindb	0	0	569f95b30000	2	0	apachemodid	apachemodid		f	f	f
1553754877	admindb	1553754877	admindb	0	1	569f95b30000	2	0	hostname	hostname		f	f	f
1553754877	admindb	1553754877	admindb	0	2	569f95b30000	1	0	enabled	enabled		f	f	f
1553754877	admindb	1553754877	admindb	0	3	569f95b30000	4	0	createdate	createdate		f	f	f
1553754877	admindb	1553754877	admindb	0	4	569f95b30000	2	0	createuser	createuser		f	f	f
1553754877	admindb	1553754877	admindb	0	5	569f95b30000	4	0	modifydate	modifydate		f	f	f
1553754877	admindb	1553754877	admindb	0	6	569f95b30000	2	0	modifyuser	modifyuser		f	f	f
1553755649	admindb	1553755649	admindb	0	0	56a78aed0000	2	0	apachesiteid	apachesiteid		f	f	f
1553755649	admindb	1553755649	admindb	0	1	56a78aed0000	1	0	enabled	enabled		f	f	f
1553755649	admindb	1553755649	admindb	0	2	56a78aed0000	2	0	hostname	hostname		f	f	f
1553755649	admindb	1553755649	admindb	0	3	56a78aed0000	2	0	domain	domain		f	f	f
1553755649	admindb	1553755649	admindb	0	4	56a78aed0000	2	0	alias	alias		f	f	f
1553755649	admindb	1553755649	admindb	0	5	56a78aed0000	2	0	documentroot	documentroot		f	f	f
1553755649	admindb	1553755649	admindb	0	6	56a78aed0000	2	0	email	email		f	f	f
1553755649	admindb	1553755649	admindb	0	7	56a78aed0000	1	0	httpsonly	httpsonly		f	f	f
1553755649	admindb	1553755649	admindb	0	8	56a78aed0000	2	0	conftext	conftext		f	f	f
1553755649	admindb	1553755649	admindb	0	9	56a78aed0000	4	0	lastread	lastread		f	t	f
1553755649	admindb	1553755649	admindb	-1	10	56a78aed0000	1	0	renewcert	''		f	f	f
1553755649	admindb	1553755649	admindb	-1	11	56a78aed0000	2	0	passwd	''		f	f	f
1553755649	admindb	1553755649	admindb	0	12	56a78aed0000	4	0	createdate	createdate		f	f	f
1553755649	admindb	1553755649	admindb	0	13	56a78aed0000	2	0	createuser	createuser		f	f	f
1553755649	admindb	1553755649	admindb	0	14	56a78aed0000	4	0	modifydate	modifydate		f	f	f
1553755649	admindb	1553755649	admindb	0	15	56a78aed0000	2	0	modifyuser	modifyuser		f	f	f
1553755649	admindb	1553755649	admindb	1	16	56a78aed0000	3	0	port	port		f	f	f
1553755649	admindb	1553755649	admindb	1	17	56a78aed0000	3	0	sport	sport		f	f	f
1553766118	admindb	1553766118	admindb	0	0	580a19280000	2	0	sogoid	sogoid		f	f	f
1553766118	admindb	1553766118	admindb	-1	1	580a19280000	2	0	certok	#3.certcaid IS NOT NULL		f	f	f
1553766118	admindb	1553766118	admindb	-1	2	580a19280000	2	0	domainok	#4.typ = 'primary' OR #4.typ = 'second'		f	f	f
1553766118	admindb	1553766118	admindb	0	3	580a19280000	1	0	mailcanonical	mailcanonical		f	f	f
1553766118	admindb	1553766118	admindb	0	4	580a19280000	2	0	mailrelay	mailrelay		f	f	f
1553766118	admindb	1553766118	admindb	0	5	580a19280000	2	0	mailrelayuser	mailrelayuser		f	f	f
1553766118	admindb	1553766118	admindb	-1	6	580a19280000	2	0	mailrelaypassword	''		f	f	f
1553766118	admindb	1553766118	admindb	-1	7	580a19280000	2	0	passwd	''		f	f	f
1553766118	admindb	1553766118	admindb	0	8	580a19280000	4	0	createdate	createdate		f	f	f
1553766118	admindb	1553766118	admindb	0	9	580a19280000	2	0	createuser	createuser		f	f	f
1579620562	admindb	1579620562	admindb	0	6	57da3e460000	2	0	typ	typ		f	t	f
1553766118	admindb	1553766118	admindb	0	10	580a19280000	4	0	modifydate	modifydate		f	f	f
1553766118	admindb	1553766118	admindb	0	11	580a19280000	2	0	modifyuser	modifyuser		f	f	f
1579620562	admindb	1579620562	admindb	0	14	57da3e460000	2	0	addr	addr		f	f	f
1579620562	admindb	1579620562	admindb	0	15	57da3e460000	2	0	addr6	addr6		f	f	f
1579620562	admindb	1579620562	admindb	0	16	57da3e460000	4	0	createdate	createdate		f	f	f
1579620562	admindb	1579620562	admindb	0	19	57da3e460000	2	0	modifyuser	modifyuser		f	f	f
1579620644	admindb	1579620644	admindb	0	0	5dfa2c070000	2	0	netparamid	netparamid		f	f	f
1579620644	admindb	1579620644	admindb	-1	1	5dfa2c070000	2	0	domain	COALESCE(#1.domain, #0.domain)		f	f	f
1579620644	admindb	1579620644	admindb	-1	2	5dfa2c070000	2	0	search	CASE WHEN #1.typ = 'standalone' THEN #0.search ELSE #1.dnssearch END		f	f	f
1579620644	admindb	1579620644	admindb	0	3	5dfa2c070000	2	0	gw	gw		f	f	f
1579620644	admindb	1579620644	admindb	-1	4	5dfa2c070000	2	0	nameserver	CASE WHEN #1.typ = 'standalone' THEN #0.nameserver ELSE COALESCE(NULLIF(#2.addr6,''),NULLIF(#2.addr,''),'127.0.0.1') END		f	f	f
1579620644	admindb	1579620644	admindb	0	5	5dfa2c070000	4	0	createdate	createdate		f	f	f
1579620644	admindb	1579620644	admindb	0	6	5dfa2c070000	2	0	createuser	createuser		f	f	f
1579620644	admindb	1579620644	admindb	0	7	5dfa2c070000	4	0	modifydate	modifydate		f	f	f
1579620644	admindb	1579620644	admindb	0	8	5dfa2c070000	2	0	modifyuser	modifyuser		f	f	f
1579620562	admindb	1579620562	admindb	-1	7	57da3e460000	2	0	nameserver	CASE WHEN #2.typ = 'standalone' THEN #0.nameserver ELSE COALESCE(NULLIF(#3.addr6,''),NULLIF(#3.addr,''),'127.0.0.1') END		f	f	f
1578380726	admindb	1578380726	admindb	0	0	581c7c020000	2	0	dnsaddressid	dnsaddressid		f	f	f
1578380726	admindb	1578380726	admindb	0	1	581c7c020000	2	0	name	name		f	f	f
1578380726	admindb	1578380726	admindb	0	2	581c7c020000	2	0	address	address		f	f	f
1578380726	admindb	1578380726	admindb	0	3	581c7c020000	2	0	record	record		f	f	f
1578380726	admindb	1578380726	admindb	0	4	581c7c020000	1	0	fix	fix		f	f	f
1578380726	admindb	1578380726	admindb	0	5	581c7c020000	2	0	mac	mac		f	f	f
1578380726	admindb	1578380726	admindb	0	6	581c7c020000	2	0	comment	comment		f	f	f
1578380726	admindb	1578380726	admindb	0	7	581c7c020000	4	0	createdate	createdate		f	f	f
1578380726	admindb	1578380726	admindb	0	8	581c7c020000	2	0	createuser	createuser		f	f	f
1578380726	admindb	1578380726	admindb	0	9	581c7c020000	4	0	modifydate	modifydate		f	f	f
1578380726	admindb	1578380726	admindb	0	10	581c7c020000	2	0	modifyuser	modifyuser		f	f	f
1578480576	admindb	1578480576	admindb	-1	0	57da3e520000	2	0	networkid	''		f	f	f
1578480576	admindb	1578480576	admindb	-1	1	57da3e520000	3	0	ownnetwork	1		f	f	f
1578480576	admindb	1578480576	admindb	-1	2	57da3e520000	2	0	networkidname	'#mne_lang#keine'		f	f	f
1578480576	admindb	1578480576	admindb	-1	3	57da3e520000	2	0	hostname	''		f	f	f
1578480576	admindb	1578480576	admindb	-1	4	57da3e520000	2	0	available	'0'		f	f	f
1578480576	admindb	1578480576	admindb	-1	5	57da3e520000	2	0	search	''		f	f	f
1578480576	admindb	1578480576	admindb	-1	6	57da3e520000	2	0	typ	'static'		f	f	f
1578480576	admindb	1578480576	admindb	-1	7	57da3e520000	2	0	nameserver	''		f	f	f
1578480576	admindb	1578480576	admindb	-1	8	57da3e520000	2	0	mask	''		f	f	f
1578480576	admindb	1578480576	admindb	-1	9	57da3e520000	2	0	mask6	''		f	f	f
1578480576	admindb	1578480576	admindb	-1	10	57da3e520000	2	0	gateway	''		f	f	f
1578480576	admindb	1578480576	admindb	-1	11	57da3e520000	2	0	domain	''		f	f	f
1578480576	admindb	1578480576	admindb	-1	12	57da3e520000	2	0	configured	true		f	f	f
1578480576	admindb	1578480576	admindb	-1	13	57da3e520000	2	0	broadcast	''		f	f	f
1578480576	admindb	1578480576	admindb	-1	14	57da3e520000	2	0	addr	''		f	f	f
1578480576	admindb	1578480576	admindb	-1	15	57da3e520000	2	0	addr6	''		f	f	f
1578480576	admindb	1578480576	admindb	-1	16	57da3e520000	2	0	createdate	0		f	f	f
1578480576	admindb	1578480576	admindb	-1	17	57da3e520000	2	0	createuser	'admindb'		f	f	f
1578480576	admindb	1578480576	admindb	-1	18	57da3e520000	2	0	modifydate	0		f	f	f
1578480576	admindb	1578480576	admindb	-1	19	57da3e520000	2	0	modifyuser	'admindb'		f	f	f
1578499160	admindb	1578499160	admindb	0	0	57d910560000	2	0	domainid	domainid		f	f	f
1578499160	admindb	1578499160	admindb	0	1	57d910560000	2	0	domain	domain		f	f	f
1578499160	admindb	1578499160	admindb	0	2	57d910560000	2	0	typ	typ		f	f	f
1578499160	admindb	1578499160	admindb	0	3	57d910560000	2	0	workgroup	workgroup		f	f	f
1578499160	admindb	1578499160	admindb	0	4	57d910560000	2	0	description	description		f	f	f
1578499160	admindb	1578499160	admindb	0	5	57d910560000	2	0	netdevice	netdevice		f	t	f
1578499160	admindb	1578499160	admindb	0	6	57d910560000	2	0	primaryname	primaryname		f	f	f
1578499160	admindb	1578499160	admindb	0	7	57d910560000	2	0	primaryaddr	primaryaddr		f	f	f
1578499160	admindb	1578499160	admindb	0	8	57d910560000	2	0	dnsforwarder	dnsforwarder		f	f	f
1578499160	admindb	1578499160	admindb	0	9	57d910560000	2	0	dnssearch	dnssearch		f	f	f
1578499160	admindb	1578499160	admindb	-1	10	57d910560000	2	0	admin	''		f	f	f
1578499160	admindb	1578499160	admindb	-1	11	57d910560000	2	0	adminpassword	''		f	f	f
1578499160	admindb	1578499160	admindb	-1	12	57d910560000	2	0	adminpassword2	''		f	f	f
1578499160	admindb	1578499160	admindb	0	13	57d910560000	2	0	dhcpstart	dhcpstart		f	f	f
1578499160	admindb	1578499160	admindb	0	14	57d910560000	2	0	dhcpend	dhcpend		f	f	f
1578499160	admindb	1578499160	admindb	0	15	57d910560000	2	0	dhcp6start	dhcp6start		f	f	f
1578499160	admindb	1578499160	admindb	0	16	57d910560000	2	0	dhcp6end	dhcp6end		f	f	f
1578499160	admindb	1578499160	admindb	0	17	57d910560000	4	0	createdate	createdate		f	f	f
1578499160	admindb	1578499160	admindb	0	18	57d910560000	2	0	createuser	createuser		f	f	f
1578499160	admindb	1578499160	admindb	0	19	57d910560000	4	0	modifydate	modifydate		f	f	f
1578499160	admindb	1578499160	admindb	0	20	57d910560000	2	0	modifyuser	modifyuser		f	f	f
1579620562	admindb	1579620562	admindb	0	0	57da3e460000	2	0	networkid	networkid		f	f	f
1579620562	admindb	1579620562	admindb	-1	1	57da3e460000	3	0	ownnetwork	CASE WHEN #1.serverid = #0.hostname THEN 1 ELSE 0 END		f	f	f
1579620562	admindb	1579620562	admindb	0	2	57da3e460000	2	0	networkidname	networkid		f	f	f
1579620562	admindb	1579620562	admindb	0	3	57da3e460000	2	0	hostname	hostname		f	f	f
1579620562	admindb	1579620562	admindb	-1	4	57da3e460000	2	0	available	CASE WHEN #0.available THEN '1' ELSE '0' END		f	f	f
1579620562	admindb	1579620562	admindb	-1	5	57da3e460000	2	0	search	CASE WHEN #2.typ = 'standalone' THEN #0.search ELSE #2.dnssearch END		f	f	f
1579620562	admindb	1579620562	admindb	0	10	57da3e460000	2	0	gateway	gateway		f	f	f
1579620562	admindb	1579620562	admindb	-1	11	57da3e460000	2	0	domain	COALESCE(#2.domain, #0.domain)		f	f	f
1579620562	admindb	1579620562	admindb	0	12	57da3e460000	1	0	configured	configured		f	f	f
1579620562	admindb	1579620562	admindb	0	13	57da3e460000	2	0	broadcast	broadcast		f	f	f
1306422520	admindb	1306422520	admindb	1	16	mne_application_querycols_1	2	0	text_en	text_en		f	t	f
1306422520	admindb	1306422520	admindb	1	15	mne_application_querycols_1	2	0	text_de	text_de		f	t	f
1591195919	admindb	1591195919	admindb	-1	0	48de01ca0000	2	0	id	#1.oid		f	f	f
1591195919	admindb	1591195919	admindb	0	1	48de01ca0000	2	0	schema	specific_schema		f	t	f
1591195919	admindb	1591195919	admindb	0	2	48de01ca0000	2	0	specific_name	specific_name		f	t	f
1591195919	admindb	1591195919	admindb	-1	3	48de01ca0000	2	0	fullname	#1.proname || mne_catalog.pgplsql_fargs(#1.oid)		f	f	f
1591195919	admindb	1591195919	admindb	0	5	48de01ca0000	2	0	routine_name	routine_name		f	t	f
1591195919	admindb	1591195919	admindb	0	6	48de01ca0000	2	0	privilege	privilege_type		f	t	f
1591195919	admindb	1591195919	admindb	0	7	48de01ca0000	2	0	owner	grantor		f	t	f
1591195919	admindb	1591195919	admindb	0	8	48de01ca0000	2	0	user	grantee		f	t	f
1591195919	admindb	1591195919	admindb	2	9	48de01ca0000	2	0	rolname	rolname		f	t	f
1591195919	admindb	1591195919	admindb	-1	10	48de01ca0000	1	0	test	CAST ( #2.rolname AS information_schema.sql_identifier) = #0.grantor		f	f	f
1591372373	admindb	1591372373	admindb	0	0	4ce24d130000	2	0	menuname	menuname		f	f	f
1591372373	admindb	1591372373	admindb	0	1	4ce24d130000	2	0	parentid	parentid		f	t	f
1591372373	admindb	1591372373	admindb	0	2	4ce24d130000	2	0	menuid	menuid		f	f	f
1591372373	admindb	1591372373	admindb	-1	3	4ce24d130000	2	0	item	#0.menupos || ' ' || COALESCE(NULLIF(#1.text_#mne_langid#,''), #0.itemname)		f	f	f
1591372373	admindb	1591372373	admindb	-1	4	4ce24d130000	2	0	action	CASE WHEN #0.action <> 'submenu' THEN '{ "action" : "show",\n"parameter" : { "menuid" : "' || t0.menuid || '" }\n}'\nELSE 'submenu' END\n		f	f	f
1591372373	admindb	1591372373	admindb	0	5	4ce24d130000	4	0	pos	menupos		f	f	f
1591372373	admindb	1591372373	admindb	-1	6	4ce24d130000	2	0	typ	CASE WHEN #0.action <> 'submenu' THEN 'leaf' ELSE '' END		f	f	f
1591372373	admindb	1591372373	admindb	0	7	4ce24d130000	2	0	ugroup	ugroup		f	f	f
1591372373	admindb	1591372373	admindb	2	8	4ce24d130000	2	0	group	rolname		f	t	f
1591372373	admindb	1591372373	admindb	6	9	4ce24d130000	2	0	rolname	rolname		f	t	f
1591372373	admindb	1591372373	admindb	7	10	4ce24d130000	2	0	parentname	itemname		f	f	f
1591604505	admindb	1591604505	admindb	0	0	5eddf3c80000	2	0	menuid	menuid		f	f	f
1591604505	admindb	1591604505	admindb	0	1	5eddf3c80000	2	0	parentid	parentid		f	t	f
1591604505	admindb	1591604505	admindb	0	2	5eddf3c80000	2	0	menuname	menuname		f	f	f
1591604505	admindb	1591604505	admindb	0	3	5eddf3c80000	2	0	itemname	itemname		f	f	f
1591604505	admindb	1591604505	admindb	2	4	5eddf3c80000	2	0	parentname	itemname		f	f	f
1591604505	admindb	1591604505	admindb	0	5	5eddf3c80000	4	0	menupos	menupos		f	f	f
1591604505	admindb	1591604505	admindb	0	6	5eddf3c80000	2	0	action	action		f	f	f
1591604505	admindb	1591604505	admindb	0	7	5eddf3c80000	2	0	ugroup	ugroup		f	f	f
1591604505	admindb	1591604505	admindb	0	8	5eddf3c80000	1	0	custom	custom		f	f	f
1591604505	admindb	1591604505	admindb	0	9	5eddf3c80000	4	0	createdate	createdate		f	f	f
1591604505	admindb	1591604505	admindb	0	10	5eddf3c80000	2	0	createuser	createuser		f	f	f
1591604505	admindb	1591604505	admindb	0	11	5eddf3c80000	4	0	modifydate	modifydate		f	f	f
1591604505	admindb	1591604505	admindb	0	12	5eddf3c80000	2	0	modifyuser	modifyuser		f	f	f
1605541710	admindb	1605541710	admindb	0	0	50ff99780000	2	0	rolname	rolname		f	t	f
1605541710	admindb	1605541710	admindb	1	1	50ff99780000	2	0	group	rolname		f	t	f
1605541710	admindb	1605541710	admindb	-1	2	50ff99780000	4	0	ismember	CASE WHEN #3.member IS NULL THEN 0 ELSE 1 END		f	f	f
1605541710	admindb	1605541710	admindb	-1	3	50ff99780000	2	0	groupname	COALESCE(#4.text_#mne_langid#, #1.rolname)		f	f	f
1603794803	admindb	1603794803	admindb	0	0	5c18a8bf0000	2	0	htmlcomposetabselectid	htmlcomposetabselectid		f	f	f
1603794803	admindb	1603794803	admindb	0	1	5c18a8bf0000	2	0	htmlcomposetabid	htmlcomposetabselectid		f	f	f
1603794803	admindb	1603794803	admindb	0	2	5c18a8bf0000	2	0	htmlcomposeid	htmlcomposeid		f	f	f
1603794803	admindb	1603794803	admindb	0	3	5c18a8bf0000	2	0	id	id		f	f	f
1603794803	admindb	1603794803	admindb	0	4	5c18a8bf0000	2	0	query	query		f	f	f
1603794803	admindb	1603794803	admindb	0	5	5c18a8bf0000	2	0	schema	schema		f	f	f
1603794803	admindb	1603794803	admindb	0	6	5c18a8bf0000	2	0	element	element		f	f	f
1603794803	admindb	1603794803	admindb	0	7	5c18a8bf0000	2	0	cols	cols		f	f	f
1603794803	admindb	1603794803	admindb	0	8	5c18a8bf0000	2	0	scols	scols		f	f	f
1603794803	admindb	1603794803	admindb	0	9	5c18a8bf0000	2	0	selval	selval		f	t	f
1603794803	admindb	1603794803	admindb	0	10	5c18a8bf0000	2	0	showcols	showcols		f	f	f
1603794803	admindb	1603794803	admindb	0	11	5c18a8bf0000	2	0	showids	showids		f	f	f
1603794803	admindb	1603794803	admindb	0	12	5c18a8bf0000	2	0	showalias	showalias		f	f	f
1603794803	admindb	1603794803	admindb	0	13	5c18a8bf0000	2	0	tab	tab		f	f	f
1603794803	admindb	1603794803	admindb	0	14	5c18a8bf0000	2	0	wcol	wcol		f	f	f
1603794803	admindb	1603794803	admindb	0	15	5c18a8bf0000	2	0	wop	wop		f	f	f
1603794803	admindb	1603794803	admindb	0	16	5c18a8bf0000	2	0	wval	wval		f	f	f
1603794803	admindb	1603794803	admindb	0	17	5c18a8bf0000	2	0	weblet	weblet		f	f	f
1603794803	admindb	1603794803	admindb	0	18	5c18a8bf0000	2	0	type	type		f	f	f
1410256508	admindb	1410256508	admindb	-1	4	4f756c120000	4	0	showhistory	mne_catalog.history_check(CAST( t0.table_schema AS VARCHAR), CAST( t0.table_name AS VARCHAR))		f	f	f
1410256508	admindb	1410256508	admindb	-1	5	4f756c120000	4	0	haveusertimecolumn	mne_catalog.usertimecolumn_check(CAST( t0.table_schema AS VARCHAR), CAST( t0.table_name AS VARCHAR))		f	f	f
1610369005	admindb	1610369005	admindb	-1	0	mne_application_menu_1	2	0	menuname	COALESCE(#10.applicationsid, #0.menuname)		f	f	f
1610369005	admindb	1610369005	admindb	0	1	mne_application_menu_1	2	0	parentid	parentid		f	t	f
1610369005	admindb	1610369005	admindb	0	2	mne_application_menu_1	2	0	menuid	menuid		f	f	f
1610369005	admindb	1610369005	admindb	-1	3	mne_application_menu_1	2	0	item	COALESCE(NULLIF(#1.text_#mne_langid#,''), #0.itemname)		f	f	f
1610369005	admindb	1610369005	admindb	0	4	mne_application_menu_1	2	0	action	action		f	f	f
1610369005	admindb	1610369005	admindb	-1	5	mne_application_menu_1	2	0	show	'{ "action"    : "show",\n   "parameter" : [ "' || #0.menuid || '",'\n               ||  '"' || #0.itemname || '",'\n               ||  '"' || REPLACE(#0.action, '"', '\\\\"') || '" ] }'		f	f	f
1610369005	admindb	1610369005	admindb	-1	6	mne_application_menu_1	2	0	showname	#0.menupos || ' ' || COALESCE(NULLIF(#1.text_#mne_langid#,''), #0.itemname)		f	f	f
1610369005	admindb	1610369005	admindb	-1	7	mne_application_menu_1	2	0	editname	#0.menupos || ' ' || #0.itemname		f	f	f
1610369005	admindb	1610369005	admindb	0	8	mne_application_menu_1	4	0	pos	menupos		f	f	f
1610369005	admindb	1610369005	admindb	-1	9	mne_application_menu_1	2	0	typ	CASE WHEN #9.childid IS NULL\n  THEN 'leaf'\n  ELSE ''\nEND		f	f	f
1610369005	admindb	1610369005	admindb	2	11	mne_application_menu_1	2	0	group	rolname		f	t	f
1610369005	admindb	1610369005	admindb	6	12	mne_application_menu_1	2	0	rolname	rolname		f	t	f
1610369005	admindb	1610369005	admindb	-1	13	mne_application_menu_1	1	0	mymenu	#2.rolname IS NULL OR #6.rolname = session_user OR session_user = 'admindb'		f	f	f
1610519462	admindb	1610519462	admindb	3	0	48cec6760000	2	0	schema	nspname		f	f	f
1610519462	admindb	1610519462	admindb	1	1	48cec6760000	2	0	table	relname		f	f	f
1610519462	admindb	1610519462	admindb	0	2	48cec6760000	2	0	name	conname		f	f	f
1610519462	admindb	1610519462	admindb	-1	3	48cec6760000	2	0	check	pg_get_constraintdef(#0.oid)		f	f	f
1610519462	admindb	1610519462	admindb	2	4	48cec6760000	2	0	cschema	nspname		f	f	f
1610519462	admindb	1610519462	admindb	4	5	48cec6760000	2	0	text_de	text_de		f	f	f
1610519462	admindb	1610519462	admindb	4	6	48cec6760000	2	0	text_en	text_en		f	f	f
1610519462	admindb	1610519462	admindb	4	7	48cec6760000	1	0	custom	custom		f	f	f
\.


--
-- Data for Name: queryname; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.queryname (createdate, createuser, modifydate, modifyuser, selectdistinct, unionall, queryid, unionnum, query, schema) FROM stdin;
1611325733	admindb	1611325733	admindb	t	t	4925b94f0000	1	userpreff	mne_application
1611326745	admindb	1611326745	admindb	f	f	600ae1550000	1	userpref	mne_application
1605541710	admindb	1605541710	admindb	t	t	50ff99780000	1	usergroup	mne_application
1611328123	admindb	1611328123	admindb	t	t	4b41e9050000	1	loginuser	mne_application
1591195919	admindb	1591195919	admindb	t	t	48de01ca0000	1	procedure_access	mne_application
1591372373	admindb	1591372373	admindb	t	t	4ce24d130000	1	menu_tree	mne_application
1591604505	admindb	1591604505	admindb	f	f	5eddf3c80000	1	menu_edit	mne_application
1603197205	admindb	1603197205	admindb	t	t	48b44ed00000	1	weblet_tabs	mne_application
1347537029	admindb	1347537029	admindb	f	t	48e65ec40000	1	user	mne_application
1221575033	admindb	1221575033	admindb	t	t	48cf6c950000	1	table_pkey	mne_application
1222088857	admindb	1222088857	admindb	f	f	48d798200000	1	table_access	mne_application
1224836999	admindb	1224836999	admindb	t	t	48bbe7280000	1	join_all	mne_application
1226406260	admindb	1226406260	admindb	t	t	491979530000	2	user	mne_application
1306422520	admindb	1306422520	admindb	t	t	mne_application_querycols_1	1	query_cols	mne_application
1305796442	admindb	1305796442	admindb	t	t	48e8baa70000	1	table_index	mne_application
1347869187	admindb	1347869187	admindb	f	f	5056d0e30000	1	usertables	mne_application
1305893645	admindb	1305893645	admindb	t	t	48cfa87a0000	1	table_fkeys	mne_application
1262614071	admindb	1262614071	admindb	t	t	4b41f1940000	1	userpasswd	mne_application
1603794803	admindb	1603794803	admindb	f	f	5c18a8bf0000	1	weblet_select	mne_application
1410256508	admindb	1410256508	admindb	t	t	4f756c120000	1	table_all	mne_application
1410243240	admindb	1410243240	admindb	t	t	mne_dbadmin_sqlproc_1	1	procedure	mne_application
1459515687	admindb	1459515687	admindb	f	f	56fcfd960000	1	certca	mne_system
1465828121	admindb	1465828121	admindb	t	t	48b3b18a0001	1	weblet	mne_application
1465828142	admindb	1465828142	admindb	t	t	48b3b18a0000	1	weblet_all	mne_application
1473783246	admindb	1473783246	admindb	f	f	556831b90000	1	shares	mne_system
1477551618	admindb	1477551618	admindb	f	f	5811a5ad0000	1	mailalias	mne_system
1478018905	admindb	1478018905	admindb	f	f	5502b8300000	1	personsharepasswd	mne_system
1512555690	admindb	1512555690	admindb	t	t	48e8bb150000	1	table_index_column	mne_application
1515764924	admindb	1515764924	admindb	t	t	4c85f5440000	1	weblet_detail	mne_application
1516204173	admindb	1516204173	admindb	t	t	4b39feaa0000	1	group	mne_application
1522137609	admindb	1522137609	admindb	t	t	mne_application_table_cols_1	1	table_cols	mne_application
1522155621	admindb	1522155621	admindb	t	t	491822b40000	1	selectlist	mne_application
1553754877	admindb	1553754877	admindb	f	f	569f95b30000	1	apachemod	mne_system
1553755649	admindb	1553755649	admindb	f	f	56a78aed0000	1	apachesite	mne_system
1553766118	admindb	1553766118	admindb	t	t	580a19280000	1	sogo	mne_system
1578380726	admindb	1578380726	admindb	f	f	581c7c020000	1	dnsaddress	mne_system
1578480576	admindb	1578480576	admindb	t	t	57da3e520000	2	network	mne_system
1578499160	admindb	1578499160	admindb	t	t	57d910560000	1	domain	mne_system
1579620562	admindb	1579620562	admindb	t	t	57da3e460000	1	network	mne_system
1579620644	admindb	1579620644	admindb	f	f	5dfa2c070000	1	netparam	mne_system
1610369005	admindb	1610369005	admindb	t	t	mne_application_menu_1	1	menu	mne_application
1610519462	admindb	1610519462	admindb	t	t	48cec6760000	1	table_checks	mne_application
\.


--
-- Data for Name: querytables; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.querytables (createdate, createuser, modifydate, modifyuser, tabnum, typ, deep, tabid, queryid, fcols, op, tcols, tschema, ttab, joindefid) FROM stdin;
1611325733	admindb	1611325733	admindb	0	1	0	0	4925b94f0000				mne_application	userpref	\N
1512555690	admindb	1512555690	admindb	0	1	0	0	48e8bb150000				mne_catalog	table_index_column	\N
1611325733	admindb	1611325733	admindb	3	1	1	1	4925b94f0000	username	=	loginname	mne_personnal	personowndatapublic	4e95b1b00000
1611325733	admindb	1611325733	admindb	4	1	2	2	4925b94f0000	personid	=	personid	mne_crm	person	4e95b2160000
1611325733	admindb	1611325733	admindb	12	1	3	3	4925b94f0000	refid	=	companyid	mne_crm	company	4219bca00001
1611325733	admindb	1611325733	admindb	29	1	4	4	4925b94f0000	companyid	=	companyid	mne_crm	companyown	4bceb3c10000
1611325733	admindb	1611325733	admindb	31	1	5	5	4925b94f0000	companyid	=	companyid	mne_crm	company	\N
1611325733	admindb	1611325733	admindb	33	1	6	6	4925b94f0000		/* haupt */ #0.companyid = #1.refid AND #1.addresstypid = '000000000001'		mne_crm	address	43b9480d0001
1611325733	admindb	1611325733	admindb	48	1	7	7	4925b94f0000	cityid	=	cityid	mne_crm	city	41b9907b0004
1611325733	admindb	1611325733	admindb	52	1	8	8	4925b94f0000	countryid	=	countryid	mne_crm	country	4368c58a0003
1611325733	admindb	1611325733	admindb	38	1	6	9	4925b94f0000	companyid	=	companydataid	mne_crm	companydata	422dacce0001
1611325733	admindb	1611325733	admindb	62	1	5	10	4925b94f0000	currency	=	currency	mne_base	currency	4b42eafa0000
1611325733	admindb	1611325733	admindb	55	1	1	11	4925b94f0000		true		mne_application	update	\N
1611325733	admindb	1611325733	admindb	58	1	1	12	4925b94f0000	startweblet	=	name	mne_application	htmlcompose	575eab870000
1611325733	admindb	1611325733	admindb	59	1	2	13	4925b94f0000	htmlcomposeid	=	htmlcomposeid	mne_application	htmlcomposenames	\N
1611325733	admindb	1611325733	admindb	61	1	1	14	4925b94f0000		true		mne_catalog	uuid	5ab12e460000
1591195919	admindb	1591195919	admindb	0	1	0	0	48de01ca0000				information_schema	routine_privileges	\N
1591195919	admindb	1591195919	admindb	1	1	1	1	48de01ca0000		#0.specific_name = #1.proname || '_' || #1.oid		pg_catalog	pg_proc	48e35f660000
1591195919	admindb	1591195919	admindb	2	1	2	2	48de01ca0000		#0.proowner = #1.oid		pg_catalog	pg_roles	446aff8f0000
1603197205	admindb	1603197205	admindb	0	1	0	0	48b44ed00000				mne_application	htmlcomposetab	\N
1603197205	admindb	1603197205	admindb	2	1	1	1	48b44ed00000	ugroup	=	rolname	pg_catalog	pg_roles	4b44b49d0000
1603197205	admindb	1603197205	admindb	4	1	2	2	48b44ed00000		#0.oid = #1.roleid		pg_catalog	pg_auth_members	\N
1603197205	admindb	1603197205	admindb	6	1	3	3	48b44ed00000	member	=	oid	pg_catalog	pg_roles	4b377c590000
1603197205	admindb	1603197205	admindb	7	1	1	4	48b44ed00000	htmlcomposetabid	=	htmlcomposetabid	mne_application	htmlcomposetabnames	\N
1603197205	admindb	1603197205	admindb	8	1	1	5	48b44ed00000	htmlcomposeid	=	htmlcomposeid	mne_application	htmlcompose	57be95790000
1611326745	admindb	1611326745	admindb	0	0	0	0	600ae1550000				mne_application	userpref	\N
1611326745	admindb	1611326745	admindb	1	1	1	1	600ae1550000	startweblet	=	name	mne_application	htmlcompose	575eab870000
1611326745	admindb	1611326745	admindb	6	1	2	2	600ae1550000	htmlcomposeid	=	htmlcomposeid	mne_application	htmlcomposenames	600ae29b0000
1611326745	admindb	1611326745	admindb	7	1	1	3	600ae1550000		true		mne_catalog	uuid	5ab12e460000
1611328123	admindb	1611328123	admindb	0	1	0	0	4b41e9050000				pg_catalog	pg_user	\N
1611328123	admindb	1611328123	admindb	1	1	1	1	4b41e9050000	usename	=	role	mne_catalog	dbaccessgroup	5052f3a00000
1591372373	admindb	1591372373	admindb	0	1	0	0	4ce24d130000				mne_application	menu	\N
1591372373	admindb	1591372373	admindb	1	1	1	1	4ce24d130000	itemname	=	id	mne_application	translate	475563520000
1591372373	admindb	1591372373	admindb	2	1	1	2	4ce24d130000	ugroup	=	rolname	pg_catalog	pg_roles	4b459ba10000
1591372373	admindb	1591372373	admindb	4	1	2	3	4ce24d130000		#0.oid = #1.roleid		pg_catalog	pg_auth_members	\N
1591372373	admindb	1591372373	admindb	6	1	3	4	4ce24d130000	member	=	oid	pg_catalog	pg_roles	\N
1591372373	admindb	1591372373	admindb	7	1	1	5	4ce24d130000	parentid	=	menuid	mne_application	menu	4ce260e00000
1603794803	admindb	1603794803	admindb	0	1	0	0	5c18a8bf0000				mne_application	htmlcomposetabselect	\N
1591604505	admindb	1591604505	admindb	0	0	0	0	5eddf3c80000				mne_application	menu	\N
1591604505	admindb	1591604505	admindb	2	1	1	2	5eddf3c80000	parentid	=	menuid	mne_application	menu	4ce260e00000
1605541710	admindb	1605541710	admindb	0	1	0	0	50ff99780000				pg_catalog	pg_roles	\N
1605541710	admindb	1605541710	admindb	1	1	1	1	50ff99780000		#0.rolcanlogin = true AND ( #1.rolcanlogin = false OR #1.rolname = 'admindb' ) AND substring(#1.rolname FROM 1 FOR 5 ) != 'login' 		pg_catalog	pg_roles	\N
1605541710	admindb	1605541710	admindb	3	1	2	2	50ff99780000		#0.oid = #1.roleid AND #t0.oid = #1.member		pg_catalog	pg_auth_members	\N
1605541710	admindb	1605541710	admindb	4	1	2	3	50ff99780000		#0.rolname = #1.id		mne_application	translate	\N
1410243240	admindb	1410243240	admindb	1	1	1	1	mne_dbadmin_sqlproc_1		#0.proowner = #1.oid		pg_catalog	pg_roles	446aff8f0000
1410243240	admindb	1410243240	admindb	2	0	1	2	mne_dbadmin_sqlproc_1		(#0.prolang = #1.oid)		pg_catalog	pg_language	43d0dd950000
1410243240	admindb	1410243240	admindb	3	0	1	3	mne_dbadmin_sqlproc_1		(#0.pronamespace = #1.oid)		pg_catalog	pg_namespace	43d0dd2e0000
1410243240	admindb	1410243240	admindb	4	1	1	4	mne_dbadmin_sqlproc_1		#0.prorettype = #1.oid		pg_catalog	pg_type	43f97dc40000
1410243240	admindb	1410243240	admindb	5	1	2	5	mne_dbadmin_sqlproc_1	typrelid	=	oid	pg_catalog	pg_class	4b03e8930000
1410243240	admindb	1410243240	admindb	7	1	3	6	mne_dbadmin_sqlproc_1		#0.relnamespace = #1.oid		pg_catalog	pg_namespace	\N
1216810623	admindb	1216810623	admindb	0	1	0	0	test_1				public	test	\N
1262614071	admindb	1262614071	admindb	0	1	0	0	4b41f1940000				pg_catalog	pg_user	\N
1216811421	admindb	1216811421	admindb	0	1	0	0	488710440000_2				public	test	\N
1108742170	admindb	1108742170	admindb	0	1	0	0	mne_crmbase_country_no_phoneprefix_1				mne_crm	country	\N
1134650009	admindb	1134650009	admindb	0	1	0	0	mne_crmbase_product_detail_1				mne_crm	product	\N
1106570498	admindb	1106570498	admindb	0	1	0	0	mne_crmbase_city_detail_1				mne_crm	city	\N
1216811481	admindb	1216811481	admindb	0	1	0	0	48870fa10000_1				public	test	\N
1347537029	admindb	1347537029	admindb	0	1	0	0	48e65ec40000				pg_catalog	pg_roles	\N
1128001062	admindb	1128001062	admindb	0	1	0	0	mne_crmbase_address_detail_1				mne_crm	address	\N
1107183325	admindb	1107183325	admindb	1	1	1	1	mne_dbadmin_menu_1	itemname	=	id	mne_application	translate	475563520000
1107183325	admindb	1107183325	admindb	2	1	1	2	mne_dbadmin_menu_1	menuname	=	id	mne_application	translate	\N
1132759801	admindb	1132759801	admindb	0	1	0	0	mne_dbadmin_screen_tabs_1				mne_application	htmlcomposetab	\N
1132759801	admindb	1132759801	admindb	3	1	1	1	mne_dbadmin_screen_tabs_1	name,id	=,=	name,id	mne_application	htmlcomposetabnames	43848ad40002
1221575033	admindb	1221575033	admindb	0	1	0	0	48cf6c950000				information_schema	table_constraints	\N
1221575033	admindb	1221575033	admindb	1	1	1	1	48cf6c950000	constraint_catalog,constraint_name,constraint_schema	=,=,=	constraint_catalog,constraint_name,constraint_schema	information_schema	key_column_usage	48cf635f0000
1216810934	admindb	1216810934	admindb	0	1	0	0	48870fa10000_2				public	test	\N
1222088857	admindb	1222088857	admindb	0	1	0	0	48d798200000				information_schema	table_privileges	\N
1224836999	admindb	1224836999	admindb	0	1	0	0	48bbe7280000				mne_application	joindef	\N
1226406260	admindb	1226406260	admindb	0	1	0	0	491979530000				pg_catalog	pg_roles	\N
1106061401	admindb	1106061401	admindb	0	1	0	0	mne_crmbase_country_1				mne_crm	country	\N
1106570498	admindb	1106570498	admindb	1	1	1	1	mne_crmbase_city_detail_1	countryid	=	countryid	mne_crm	country	4368c58a0003
1127831494	admindb	1127831494	admindb	0	1	0	0	mne_crmbase_address_list_1				mne_crm	address	\N
1127831494	admindb	1127831494	admindb	1	1	1	1	mne_crmbase_address_list_1	addresstypid	=	addresstypid	mne_crm	addresstyp	41f4fa5c0006
1127831494	admindb	1127831494	admindb	2	1	1	2	mne_crmbase_address_list_1	cityid	=	cityid	mne_crm	city	41b9907b0004
1127831494	admindb	1127831494	admindb	3	1	2	3	mne_crmbase_address_list_1	countryid	=	countryid	mne_crm	country	4368c58a0003
1128001062	admindb	1128001062	admindb	1	1	1	1	mne_crmbase_address_detail_1	cityid	=	cityid	mne_crm	city	41b9907b0004
1134650009	admindb	1134650009	admindb	1	1	1	1	mne_crmbase_product_detail_1	productid	=	productid	mne_crm	producttree	45474c470000
1134650009	admindb	1134650009	admindb	2	1	2	2	mne_crmbase_product_detail_1	parentid	=	treeid	mne_crm	producttree	43a17ba60004
1107183325	admindb	1107183325	admindb	0	1	0	0	mne_dbadmin_menu_1				mne_application	menu	\N
1305893645	admindb	1305893645	admindb	1	1	1	1	48cfa87a0000	name	=	tableconstraintmessagesid	mne_application	tableconstraintmessages	4dd65aea0000
1306422520	admindb	1306422520	admindb	0	1	0	0	mne_application_querycols_1				mne_application	querycolumns	\N
1306422520	admindb	1306422520	admindb	2	1	1	1	mne_application_querycols_1	queryid,tabnum	=,=	queryid,tabnum	mne_application	querytables	\N
1306422520	admindb	1306422520	admindb	3	1	1	2	mne_application_querycols_1	queryid	=	queryid	mne_application	queryname	\N
1306422520	admindb	1306422520	admindb	1	1	2	3	mne_application_querycols_1	schema,query,t0.colid	=,=,=	schema,query,colid	mne_application	querycolnames	\N
1305796442	admindb	1305796442	admindb	0	1	0	0	48e8baa70000				mne_catalog	table_index	\N
1305796442	admindb	1305796442	admindb	1	1	1	1	48e8baa70000	index	=	tableconstraintmessagesid	mne_application	tableconstraintmessages	4dd4df460000
1305893645	admindb	1305893645	admindb	0	1	0	0	48cfa87a0000				mne_catalog	fkey	\N
1347869187	admindb	1347869187	admindb	0	1	0	0	5056d0e30000				mne_application	usertables	\N
1410243240	admindb	1410243240	admindb	0	1	0	0	mne_dbadmin_sqlproc_1				pg_catalog	pg_proc	\N
1410256508	admindb	1410256508	admindb	0	1	0	0	4f756c120000				information_schema	tables	\N
1410256508	admindb	1410256508	admindb	6	1	1	1	4f756c120000	table_name	=	relname	pg_catalog	pg_class	48e75f9c0000
1410256508	admindb	1410256508	admindb	9	1	2	2	4f756c120000		#0.relowner = #1.oid		pg_catalog	pg_roles	\N
1410256508	admindb	1410256508	admindb	10	1	2	3	4f756c120000		#0.relnamespace = #1.oid		pg_catalog	pg_namespace	48cf6e440000
1478018905	admindb	1478018905	admindb	10	1	2	2	5502b8300000	refid	=	companyid	mne_crm	company	4219bca00001
1478018905	admindb	1478018905	admindb	0	1	0	0	5502b8300000				mne_system	personsharepasswdpublic	\N
1478018905	admindb	1478018905	admindb	1	1	1	1	5502b8300000	personid	=	personid	mne_crm	person	55031ae80000
1478018905	admindb	1478018905	admindb	17	1	2	3	5502b8300000	personid	=	personid	mne_crm	personowndata	57c550a30000
1478018905	admindb	1478018905	admindb	22	1	3	4	5502b8300000		#0.loginname = #1.member AND #1.group = 'erpsmb'		mne_catalog	accessgroup	\N
1478018905	admindb	1478018905	admindb	23	1	3	5	5502b8300000		#0.loginname = #1.member AND #1.group = 'erpdav'		mne_catalog	accessgroup	\N
1459515687	admindb	1459515687	admindb	0	1	0	0	56fcfd960000				mne_system	certca	\N
1465828121	admindb	1465828121	admindb	0	1	0	0	48b3b18a0001				mne_application	htmlcompose	\N
1465828121	admindb	1465828121	admindb	4	1	1	1	48b3b18a0001	htmlcomposeid	=	htmlcomposeid	mne_application	htmlcomposenames	\N
1465828121	admindb	1465828121	admindb	6	1	1	2	48b3b18a0001	htmlcomposeid	=	htmlcomposeid	mne_application	htmlcomposetab	575ea5a70000
1465828121	admindb	1465828121	admindb	7	1	2	3	48b3b18a0001	htmlcomposetabid	=	htmlcomposetabid	mne_application	htmlcomposetabnames	\N
1465828142	admindb	1465828142	admindb	0	1	0	0	48b3b18a0000				mne_application	htmlcompose	\N
1465828142	admindb	1465828142	admindb	4	1	1	1	48b3b18a0000	htmlcomposeid	=	htmlcomposeid	mne_application	htmlcomposenames	\N
1465828142	admindb	1465828142	admindb	5	1	1	2	48b3b18a0000	htmlcomposeid	=	htmlcomposeid	mne_application	htmlcomposetab	575ea5a70000
1465828142	admindb	1465828142	admindb	6	1	2	3	48b3b18a0000	htmlcomposetabid	=	htmlcomposetabid	mne_application	htmlcomposetabnames	\N
1477551618	admindb	1477551618	admindb	0	1	0	0	5811a5ad0000				mne_system	mailalias	\N
1477551618	admindb	1477551618	admindb	1	1	1	1	5811a5ad0000	personid	=	personid	mne_crm	person	5811a5bf0000
1477551618	admindb	1477551618	admindb	9	1	2	9	5811a5ad0000	personid	=	personid	mne_crm	personowndata	57c550a30000
1473783246	admindb	1473783246	admindb	0	1	0	0	556831b90000				mne_system	shares	\N
1473783246	admindb	1473783246	admindb	1	1	1	1	556831b90000	folderid	=	folderid	mne_application	folder	5568312a0000
1473783246	admindb	1473783246	admindb	2	1	1	2	556831b90000	personid	=	personid	mne_crm	person	556831170000
1473783246	admindb	1473783246	admindb	11	1	2	3	556831b90000	refid	=	companyid	mne_crm	company	4219bca00001
1473783246	admindb	1473783246	admindb	18	1	2	10	556831b90000	personid	=	personid	mne_crm	personowndata	57c550a30000
1473783246	admindb	1473783246	admindb	25	1	3	13	556831b90000	loginname	=	rolname	pg_catalog	pg_roles	57c7c4d80000
1473783246	admindb	1473783246	admindb	31	1	4	18	556831b90000		#0.rolname = #1.member AND #1.group = 'erpdav'		mne_catalog	accessgroup	57d825690000
1473783246	admindb	1473783246	admindb	32	1	4	19	556831b90000		#0.rolname = #1.member AND #1.group = 'erpsmb'		mne_catalog	accessgroup	57d825820000
1515764924	admindb	1515764924	admindb	0	1	0	0	4c85f5440000				mne_application	htmlcomposetab	\N
1515764924	admindb	1515764924	admindb	2	1	1	1	4c85f5440000	htmlcomposetabid	=	htmlcomposetabid	mne_application	htmlcomposetabnames	\N
1515764924	admindb	1515764924	admindb	3	1	1	2	4c85f5440000	htmlcomposeid	=	htmlcomposeid	mne_application	htmlcompose	57be95790000
1512555690	admindb	1512555690	admindb	1	1	1	1	48e8bb150000	index	=	tableconstraintmessagesid	mne_application	tableconstraintmessages	4dd4df460000
1516204173	admindb	1516204173	admindb	0	1	0	0	4b39feaa0000				pg_catalog	pg_roles	\N
1522137609	admindb	1522137609	admindb	0	1	0	0	mne_application_table_cols_1				information_schema	columns	\N
1522137609	admindb	1522137609	admindb	1	1	1	1	mne_application_table_cols_1	table_schema,table_name,column_name	=,=,=	schema,tab,colname	mne_application	tablecolnames	48c0f8a40000
1522155621	admindb	1522155621	admindb	0	1	0	0	491822b40000				mne_application	selectlist	\N
1553754877	admindb	1553754877	admindb	0	1	0	0	569f95b30000				mne_system	apachemod	\N
1553755649	admindb	1553755649	admindb	0	1	0	0	56a78aed0000				mne_system	apachesite	\N
1553755649	admindb	1553755649	admindb	1	1	1	1	56a78aed0000	hostname	=	apacheid	mne_system	apache	\N
1553766118	admindb	1553766118	admindb	0	1	0	0	580a19280000				mne_system	sogo	\N
1553766118	admindb	1553766118	admindb	3	1	1	2	580a19280000	sogoid	=	certcaid	mne_system	certca	5c9c96780000
1553766118	admindb	1553766118	admindb	4	1	1	3	580a19280000	sogoid	=	domainid	mne_system	domain	5c9c96d10000
1578380726	admindb	1578380726	admindb	0	1	0	0	581c7c020000				mne_system	dnsaddress	\N
1578480576	admindb	1578480576	admindb	0	1	0	0	57da3e520000				mne_system	network	\N
1578499160	admindb	1578499160	admindb	0	1	0	0	57d910560000				mne_system	domain	\N
1579620562	admindb	1579620562	admindb	0	1	0	0	57da3e460000				mne_system	network	\N
1579620562	admindb	1579620562	admindb	1	1	1	1	57da3e460000		true		mne_application	server	5ddb7b920000
1579620562	admindb	1579620562	admindb	2	1	1	2	57da3e460000	hostname	=	domainid	mne_system	domain	5df8aa4a0000
1579620562	admindb	1579620562	admindb	3	1	2	3	57da3e460000	domainid,netdevice	=,=	hostname,networkid	mne_system	network	5e2716ec0000
1579620644	admindb	1579620644	admindb	0	1	0	0	5dfa2c070000				mne_system	netparam	\N
1579620644	admindb	1579620644	admindb	1	1	1	1	5dfa2c070000	netparamid	=	domainid	mne_system	domain	5dfa2c5e0000
1579620644	admindb	1579620644	admindb	2	1	2	2	5dfa2c070000	domainid,netdevice	=,=	hostname,networkid	mne_system	network	5e2716ec0000
1610369005	admindb	1610369005	admindb	0	1	0	0	mne_application_menu_1				mne_application	menu	\N
1610369005	admindb	1610369005	admindb	1	1	1	1	mne_application_menu_1	itemname	=	id	mne_application	translate	475563520000
1610369005	admindb	1610369005	admindb	2	1	1	2	mne_application_menu_1	ugroup	=	rolname	pg_catalog	pg_roles	4b459ba10000
1610369005	admindb	1610369005	admindb	4	1	2	3	mne_application_menu_1		#0.oid = #1.roleid		pg_catalog	pg_auth_members	\N
1610369005	admindb	1610369005	admindb	6	1	3	4	mne_application_menu_1	member	=	oid	pg_catalog	pg_roles	\N
1610369005	admindb	1610369005	admindb	9	0	1	5	mne_application_menu_1	menuid	=	menuid	mne_application	menu_child	5eddd8250000
1610369005	admindb	1610369005	admindb	10	1	1	6	mne_application_menu_1	menuname	=	menuname	mne_application	applications	5ffc47aa0000
1610519462	admindb	1610519462	admindb	0	1	0	0	48cec6760000				pg_catalog	pg_constraint	\N
1610519462	admindb	1610519462	admindb	1	1	1	1	48cec6760000		#0.conrelid = #1.oid		pg_catalog	pg_class	48cec2bc0000
1610519462	admindb	1610519462	admindb	3	1	2	2	48cec6760000		#0.relnamespace = #1.oid		pg_catalog	pg_namespace	48cf6e440000
1610519462	admindb	1610519462	admindb	2	1	1	3	48cec6760000		#0.connamespace = #1.oid		pg_catalog	pg_namespace	48cec0d90000
1610519462	admindb	1610519462	admindb	4	1	1	4	48cec6760000	conname	=	tableconstraintmessagesid	mne_application	tableconstraintmessages	4dd618170000
\.


--
-- Data for Name: querywheres; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.querywheres (createdate, createuser, modifydate, modifyuser, notoperator, leftbrace, rightbrace, lefttab, righttab, booloperator, wherecol, queryid, leftvalue, rightvalue, operator) FROM stdin;
1611328123	admindb	1611328123	admindb	f	f	f			AND	0	4b41e9050000	#1.dbname	current_database()	=
1611328123	admindb	1611328123	admindb	f	f	f	1		AND	1	4b41e9050000	connect	true	=
1603197205	admindb	1603197205	admindb	f	t	t	0		OR	0	48b44ed00000	ugroup		=
1603197205	admindb	1603197205	admindb	f	t	t	6		OR	1	48b44ed00000	rolname	session_user	=
1603197205	admindb	1603197205	admindb	f	t	t	0		OR	2	48b44ed00000	ugroup	session_user	=
1603197205	admindb	1603197205	admindb	f	t	t				3	48b44ed00000	'admindb'	session_user	=
1605541710	admindb	1605541710	admindb	f	f	f			OR	0	50ff99780000	substring(#1.rolname,1,5)	'admin'	=
1605541710	admindb	1605541710	admindb	f	f	f			OR	1	50ff99780000	substring(#1.rolname,1,3)	'erp'	=
1605541710	admindb	1605541710	admindb	f	f	f				2	50ff99780000	substring(#1.rolname,1,4)	'show'	=
1591195919	admindb	1591195919	admindb	f	t	t	2	0	AND	0	48de01ca0000	rolname	grantor	=
1591372373	admindb	1591372373	admindb	f	t	t	6		OR	0	4ce24d130000	rolname	session_user	=
1591372373	admindb	1591372373	admindb	f	t	t	0		OR	1	4ce24d130000	ugroup	session_user	=
1591372373	admindb	1591372373	admindb	f	t	t	2		OR	2	4ce24d130000	rolname		isnull
1591372373	admindb	1591372373	admindb	f	t	t			AND	3	4ce24d130000	'admindb'	session_user	=
1410243240	admindb	1410243240	admindb	f	f	f	2		AND	0	mne_dbadmin_sqlproc_1	lanname	plpgsql	=
1410243240	admindb	1410243240	admindb	f	t	f	4		OR	1	mne_dbadmin_sqlproc_1	typname	trigger	!=
1410243240	admindb	1410243240	admindb	t	f	t	0		AND	2	mne_dbadmin_sqlproc_1	proname	%history%	like
1410256508	admindb	1410256508	admindb	f	f	f	0	10	AND	0	4f756c120000	table_schema	nspname	=
1221575033	admindb	1221575033	admindb	f	f	f	0		AND	0	48cf6c950000	constraint_type	PRIMARY KEY	=
1108742170	admindb	1108742170	admindb	f	f	f	0		AND	0	mne_crmbase_country_no_phoneprefix_1	phoneprefix		=
1516204173	admindb	1516204173	admindb	f	f	f	0		AND	0	4b39feaa0000	rolcanlogin	false	=
1516204173	admindb	1516204173	admindb	f	t	f			OR	1	4b39feaa0000	substring(#0.rolname FROM 1 FOR 3 )	'erp'	=
1516204173	admindb	1516204173	admindb	f	f	f			OR	2	4b39feaa0000	substring(#0.rolname FROM 1 FOR 4 )	'show'	=
1516204173	admindb	1516204173	admindb	f	f	t				3	4b39feaa0000	substring(#0.rolname FROM 1 FOR 5 )	'admin'	=
1610519462	admindb	1610519462	admindb	f	f	f	0		AND	0	48cec6760000	contype	c	=
1610519462	admindb	1610519462	admindb	f	f	f	0		AND	1	48cec6760000	conrelid	0	!=
\.


--
-- Data for Name: selectlist; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.selectlist (createdate, createuser, modifydate, modifyuser, name, text_de, value, num, text_en, custom) FROM stdin;
1586960869	admindb	1586960869	admindb	tabledpytype	Bool	1	1	bool	f
1586960869	admindb	1586960869	admindb	tabledpytype	Standard	-1	0	default	f
1589975786	admindb	1589975786	admindb	operator	=	=	0	=	f
1586960869	admindb	1586960869	admindb	tabledpytype	Char	2	2	char	f
1586960869	admindb	1586960869	admindb	tabledpytype	Short	3	3	short	f
1586960869	admindb	1586960869	admindb	tabledpytype	Long	4	4	long	f
1586960869	admindb	1586960869	admindb	tabledpytype	Float	5	5	float	f
1586960869	admindb	1586960869	admindb	tabledpytype	Double	6	6	double	f
1586960869	admindb	1586960869	admindb	tabledpytype	Bin??r	100	100	binary	f
1586960869	admindb	1586960869	admindb	tabledpytype	Zeit	1002	1002	time	f
1586960869	admindb	1586960869	admindb	tabledpytype	C Tag/Zeit	1006	1006	cdatetime	f
1586960869	admindb	1586960869	admindb	tabledpytype	C Tag	1007	1007	cdate	f
1586960869	admindb	1586960869	admindb	tabledpytype	C Zeit	1008	1008	ctime	f
1586960869	admindb	1586960869	admindb	tabledpytype	Quartal	1005	1005	quartal	f
1586960869	admindb	1586960869	admindb	tabledpytype	Email	1010	1010	email	f
1586960869	admindb	1586960869	admindb	tabledpytype	Link	1011	1011	link	f
1586960869	admindb	1586960869	admindb	tabledpytype	Farbe	1020	1020	color	f
1586960869	admindb	1586960869	admindb	tabledpytype	Aus Spalte	1100	1100	from column	f
1586959695	admindb	1586959695	admindb	tablecoltype	bool	1	1	bool	f
1586959695	admindb	1586959695	admindb	tablecoltype	short	3	3	short	f
1586959695	admindb	1586959695	admindb	tablecoltype	long	4	4	long	f
1586959695	admindb	1586959695	admindb	tablecoltype	float	5	5	float	f
1586959695	admindb	1586959695	admindb	tablecoltype	double	6	6	double	f
1586958994	admindb	1586958994	admindb	tablecoltype	char	2	2	char	f
1589975817	admindb	1589976040	admindb	operator	<>	<>	1	<>	f
1589976087	admindb	1589976087	admindb	operator	<	<	2	<	f
1589976108	admindb	1589976108	admindb	operator	>	>	3	>	f
1589976146	admindb	1589976146	admindb	operator	<=	<=	4	<=	f
1589976166	admindb	1589976166	admindb	operator	>=	>=	5	>=	f
1589976217	admindb	1589976217	admindb	operator	ist leer	isnull	6	is empty	f
1590674398	admindb	1590674398	admindb	jointype	left	1	0	left	f
1590676474	admindb	1590676509	admindb	jointype	full	3	3	full	f
1590676474	admindb	1590676553	admindb	jointype	inner	0	1	inner	f
1590675114	admindb	1590676558	admindb	jointype	right	2	2	right	f
1586960869	admindb	1600068848	admindb	tabledpytype	Interval	1003	1003	interval	f
1586960869	admindb	1600068906	admindb	tabledpytype	Datum/Zeit	1000	1000	date/time	f
1586960869	admindb	1600068906	admindb	tabledpytype	Datum	1001	1001	date	f
1589976319	admindb	1608046214	admindb	leftbrace	(	true	1	(	f
1589976373	admindb	1608046224	admindb	rightbrace	)	true	1	)	f
1589976355	admindb	1608046276	admindb	rightbrace	 	false	0	 	f
1589976299	admindb	1608046284	admindb	leftbrace	 	false	0	 	f
1611847910	admindb	1611847910	admindb	netaddrtyp	DHCP	dhcp	1	dhcp	f
1611847910	admindb	1611847910	admindb	netaddrtyp	Feste Addresse	static	2	fix	f
1600068880	admindb	1600068880	admindb	tabledpytype	Tag	1004	1004	day	f
1305298791	admindb	1305298791	admindb	provolatile	DEFAULT	v	0	DEFAULT	f
1305298758	admindb	1305298809	admindb	provolatile	STABLE	s	2	STABLE	f
1305298727	admindb	1305298816	admindb	provolatile	IMMUTABLE	i	1	IMMUTABLE	f
1307531543	admindb	1359387301	admindb	regionselect	Schweiz	CH:des	0	switzerland	f
1612169355	admindb	1612169355	admindb	exportencoding		utf-8	0		f
1612169431	admindb	1612169431	admindb	exportencoding		iso8859-1	1		f
1613986711	admindb	1613986711	admindb	domaintyp	Nicht konfiguriert		0	not configured	f
1604565727	admindb	1604565727	admindb	month	Januar	0	0	January	f
1604565855	admindb	1604565855	admindb	month	Februar	1	1	February	f
1604565855	admindb	1604565855	admindb	month	M??rz	2	2	March	f
1604565855	admindb	1604565855	admindb	month	April	3	3	April	f
1604565855	admindb	1604565855	admindb	month	Mai	4	4	May	f
1604565855	admindb	1604565855	admindb	month	Juni	5	5	June	f
1604565988	admindb	1604565988	admindb	month	Juli	6	6	July	f
1604565988	admindb	1604565988	admindb	month	August	7	7	August	f
1604565988	admindb	1604565988	admindb	month	September	8	8	September	f
1604565988	admindb	1604565988	admindb	month	Oktober	9	9	October	f
1604565988	admindb	1604565988	admindb	month	November	10	10	November	f
1604565988	admindb	1604565988	admindb	month	Dezember	11	11	December	f
1604566032	admindb	1604566032	admindb	month	akt. Monat	-1	-1	act. month	f
1604566074	admindb	1604566074	admindb	month	andere Zeit	-2	12	other time	f
1307531573	admindb	1359387318	admindb	regionselect	Deutschland	DE:deu	1	germany	f
1307531660	admindb	1359387328	admindb	regionselect	USA	US:usa	3	USA	f
1129728585	admindb	1226320335	admindb	timezone		America/Los_Angeles	0		f
1129728472	admindb	1226320360	admindb	timezone		MET	0		f
1129728375	admindb	1226320365	admindb	timezone		Europe/Berlin	0		f
1129728462	admindb	1226320373	admindb	timezone		Europe/London	0		f
1129729352	admindb	1226320497	admindb	language	englisch	en	2	english	f
1129728359	admindb	1226320503	admindb	language	deutsch	de	1	german	f
1235643689	admindb	1235643689	admindb	language	unbekannt		0	unknown	f
1307531696	admindb	1359387354	admindb	regionselect	England	GB:eng	4	england	f
1471857350	admindb	1613986677	admindb	domaintyp	Standalone	standalone	1	standalone	f
1471857435	admindb	1613986677	admindb	domaintyp	Prim??rer Domain Controler	primary	2	primary domain controler	f
1471857473	admindb	1613986677	admindb	domaintyp	Second??rer Domain Controler	second	3	second domain controler	f
1478867553	admindb	1478867553	admindb	dns_record	A	A	0	A	f
1478867591	admindb	1478867591	admindb	dns_record	AAAA	AAAA	1	AAAA	f
1478867622	admindb	1478867622	admindb	dns_record	MX	MX	3	MX	f
1478867646	admindb	1478867646	admindb	dns_record	CNAME	CNAME	2	CNAME	f
1516629472	admindb	1516629472	admindb	stylename	Dunkel	dark	2	dark	f
1144670006	admindb	1516692069	admindb	stylename	Grosse Buchstaben	large	1	big letter	f
1516637387	admindb	1516692090	admindb	stylename	Grosse Buchstaben Dunkel	dlarge	3	big letter dark	f
1144669984	admindb	1227211391	admindb	stylename	standart		0	standard	f
1611847853	admindb	1616752576	admindb	netaddrtyp	Nicht konfiguriert		0	not configured	f
\.


--
-- Data for Name: tablecolnames; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.tablecolnames (createdate, createuser, modifydate, modifyuser, schema, tab, colname, text_en, text_de, dpytype, showhistory, regexp, regexphelp, custom, regexpmod) FROM stdin;
1225400409	admindb	1225400409	admindb	mne_application	tablecolnames	regexphelp	Hilfe	help	-1	f		\N	f	\N
1110207615	admindb	1276687352	admindb	mne_application	userpref	language	\N	Sprache	-1	t	notempty	\N	f	\N
1589966151	admindb	1589966151	admindb	mne_application	querycolumns	lang	\N	\N	1	f	\N	\N	f	\N
1590495804	admindb	1590495804	admindb	mne_application	queryname	query	\N	\N	-1	f	alpha_alphanum	\N	f	\N
1590495826	admindb	1590495826	admindb	mne_application	queryname	schema	\N	\N	-1	f	alpha_alphanum	\N	f	\N
1590495850	admindb	1590495850	admindb	mne_application	queryname	unionnum	\N	\N	-1	f	num	\N	f	\N
1589966142	admindb	1589966142	admindb	mne_application	querycolumns	fieldtyp	\N	\N	-1	f	\N	\N	f	\N
1600775092	admindb	1600775092	admindb	mne_application	htmlcomposetabselect	showids	\N	\N	-1	f	\N	\N	f	\N
1603794758	admindb	1603794758	admindb	mne_application	htmlcomposetabselect	showalias	\N	\N	-1	f	\N	\N	f	\N
1226394437	admindb	1589528804	admindb	mne_application	htmlcomposetabselect	wcol	filter column	Filterspalte	-1	t	\N	\N	f	\N
1226394443	admindb	1589528840	admindb	mne_application	htmlcomposetabselect	wval	filter value	Filterwert	-1	t	\N	\N	f	\N
1587366305	admindb	1587366305	admindb	information_schema	columns	column_name	\N	\N	-1	f	alpha_alphanum	\N	f	\N
1587367329	admindb	1587367329	admindb	information_schema	columns	character_maximum_length	\N	\N	-1	f	numoempty	\N	f	\N
1587369942	admindb	1587369942	admindb	information_schema	tables	table_schema	\N	\N	-1	f	notempty	\N	f	\N
1587369952	admindb	1587369952	admindb	information_schema	tables	table_name	\N	\N	-1	f	notempty	\N	f	\N
1587992732	admindb	1587992732	admindb	mne_catalog	table_index_column	position	\N	\N	-1	f	numoempty	\N	f	\N
1587391022	admindb	1587391022	admindb	mne_catalog	pkey	position	\N	\N	-1	f	num	\N	f	\N
1269602452	admindb	1589781947	admindb	mne_application	htmlcomposetabslider	custom	customized	angepasst	-1	f	\N	\N	f	\N
1354030539	admindb	1354030793	admindb	mne_application	menu	custom	\N	\N	-1	f	\N	\N	f	\N
1305795435	admindb	1522144136	admindb	mne_application	tableconstraintmessages	custom	customized	Angepasst	-1	t	\N	\N	f	\N
1269602423	admindb	1269602423	admindb	mne_application	htmlcomposetabselect	custom	customized	angepasst	-1	f	\N	\N	f	\N
1269864497	admindb	1269864497	admindb	mne_application	selectlist	custom	customized	angepasst	-1	f	\N	\N	f	\N
1147249225	admindb	1276687144	admindb	mne_application	userpref	countrycarcode	\N	Int. Kfz-Kennzeichen	-1	t	\N	\N	f	\N
1276687391	admindb	1276687391	admindb	mne_application	userpref	username	\N	Benutzer	-1	f	\N	\N	f	\N
1305795265	admindb	1522144136	admindb	mne_application	tableconstraintmessages	text_de	german	Deutsch	-1	t	\N	\N	f	\N
1305795276	admindb	1522144136	admindb	mne_application	tableconstraintmessages	text_en	english	Englisch	-1	t	\N	\N	f	\N
1305794860	admindb	1522144136	admindb	mne_application	tableconstraintmessages	tableconstraintmessagesid	\N	\N	-1	t	\N	\N	f	\N
1107771136	admindb	1246558357	admindb	mne_application	selectlist	createdate	\N	\N	1000	f	\N	\N	f	\N
1304942086	admindb	1522155269	admindb	mne_application	year	yearmax	\N	gr??sstes Jahr	-1	f	\N	\N	f	\N
1269865489	admindb	1522137626	admindb	mne_application	tablecolnames	custom	customized	angepasst	-1	f	\N	\N	f	\N
1304699598	admindb	1522155269	admindb	mne_application	year	yearmin	\N	kleinstes Jahr	-1	f	\N	\N	f	\N
1522151386	admindb	1522152287	admindb	mne_application	htmlcomposetab	createdate	\N	\N	1000	t	\N	\N	f	\N
1269591347	admindb	1522144234	admindb	mne_application	htmlcomposetab	custom	customized	angepasst	-1	f	\N	\N	f	\N
1262773013	admindb	1522144234	admindb	mne_application	htmlcomposetab	ugroup	\N	Gruppe	-1	f	\N	\N	f	\N
1525436045	admindb	1525436045	admindb			createuser	create user	erstellt von	-1	f	\N	\N	f	\N
1525436132	admindb	1530180517	admindb			modifydate	modify date	ge??ndert am	1000	f	\N	\N	f	\N
1525436157	admindb	1525436157	admindb			modifyuser	modify user	ge??ndert von	-1	f	\N	\N	f	\N
1269591048	admindb	1269591048	admindb	mne_application	htmlcompose	custom	custumized	angepasst	-1	f	\N	\N	f	\N
1269591426	admindb	1269592268	admindb	mne_application	htmlcomposetabnames	custom	own name	eigener Namen	-1	f	\N	\N	f	\N
1236001282	admindb	1236001282	admindb	mne_application	htmlcomposetabselect	weblet	\N	\N	-1	f	\N	\N	f	\N
1226394461	admindb	1260957585	admindb	mne_application	htmlcomposetabselect	showcols	columns for elements	Elementespalten	-1	t	\N	\N	f	\N
1262852898	admindb	1262852898	admindb	mne_application	menu	ugroup	user group	Benutzergruppe	-1	f	\N	\N	f	\N
1237824426	admindb	1237824433	admindb	mne_application	htmlcomposetabslider	sliderpos	\N	\N	-1	f	\N	\N	f	\N
1237824440	admindb	1237824440	admindb	mne_application	htmlcomposetabslider	slidername	\N	\N	-1	f	\N	\N	f	\N
1525435936	admindb	1530180471	admindb			createdate	create date	erstellt am	1000	f	\N	\N	f	\N
1304942180	admindb	1522155269	admindb	mne_application	year	yearid	\N	\N	-1	f	\N	\N	f	\N
1196771024	admindb	1289926186	admindb	mne_application	menu	menuname	\N	Men??name	-1	t	\N	\N	f	\N
1196770847	admindb	1289926193	admindb	mne_application	menu	menupos	\N	Position	-1	t	\N	\N	f	\N
1322820151	admindb	1522155488	admindb	mne_application	customerfunctions	customerfunction	\N	\N	-1	t	\N	\N	f	\N
1322820214	admindb	1522155488	admindb	mne_application	customerfunctions	func	function	Funktion	-1	f	\N	\N	f	\N
1134984154	admindb	1134984154	admindb	mne_application	queryname	createdate	\N	\N	1000	t	\N	\N	f	\N
1134984154	admindb	1134984154	admindb	mne_application	queryname	modifydate	\N	\N	1000	t	\N	\N	f	\N
1129218598	admindb	1276687383	admindb	mne_application	userpref	timezone	\N	Zeitzone	-1	t	\N	\N	f	\N
1196770806	admindb	1196770806	admindb	mne_application	menu	createdate	\N	\N	1000	t	\N	\N	f	\N
1196770806	admindb	1196770806	admindb	mne_application	menu	createuser	\N	\N	-1	t	\N	\N	f	\N
1196770806	admindb	1196770806	admindb	mne_application	menu	modifydate	\N	\N	1000	t	\N	\N	f	\N
1196770806	admindb	1196770806	admindb	mne_application	menu	modifyuser	\N	\N	-1	t	\N	\N	f	\N
1196770820	admindb	1196771009	admindb	mne_application	menu	menuid	\N	\N	-1	t	\N	\N	f	\N
1196770866	admindb	1196777385	admindb	mne_application	menu	parentid	\N	\N	-1	t	\N	\N	f	\N
1226408919	admindb	1226485179	admindb	mne_application	htmlcomposetabselect	cols	columns	Spalten	-1	f		\N	f	\N
1225232693	admindb	1225232693	admindb	mne_application	tableregexp	createdate	\N	\N	1000	f		\N	f	\N
1226394379	admindb	1226485179	admindb	mne_application	htmlcomposetabselect	schema	\N	\N	-1	t		\N	f	\N
1226394312	admindb	1226485179	admindb	mne_application	htmlcomposetabselect	element	\N	\N	-1	t		\N	f	\N
1226394385	admindb	1226485179	admindb	mne_application	htmlcomposetabselect	query	\N	\N	-1	t		\N	f	\N
1225400432	admindb	1225400432	admindb	mne_application	tableregexp	regexphelp	\N	\N	-1	f		\N	f	\N
1107958876	admindb	1522144234	admindb	mne_application	htmlcomposetab	createuser	\N	\N	-1	t	\N	\N	f	\N
1107958876	admindb	1522144234	admindb	mne_application	htmlcomposetab	depend	\N	\N	-1	t	\N	\N	f	\N
1107958876	admindb	1522144234	admindb	mne_application	htmlcomposetab	initpar	\N	\N	-1	t	\N	\N	f	\N
1107958876	admindb	1522144234	admindb	mne_application	htmlcomposetab	modifyuser	\N	\N	-1	t	\N	\N	f	\N
1103897907	admindb	1103897907	admindb	mne_application	translate	modifyuser	\N	\N	-1	t	\N	\N	f	\N
1103897907	admindb	1103899387	admindb	mne_application	translate	categorie	\N	\N	-1	t	\N	\N	f	\N
1107958876	admindb	1522144234	admindb	mne_application	htmlcomposetab	path	\N	\N	-1	t	\N	\N	f	\N
1103897907	admindb	1106901912	admindb	mne_application	translate	text_de	\N	\N	-1	t	\N	\N	f	\N
1103897907	admindb	1106901949	admindb	mne_application	translate	text_en	\N	\N	-1	t	\N	\N	f	\N
1107958876	admindb	1522144234	admindb	mne_application	htmlcomposetab	position	\N	\N	-1	t	\N	\N	f	\N
1107958876	admindb	1522144234	admindb	mne_application	htmlcomposetab	subposition	\N	\N	-1	t	\N	\N	f	\N
1100012050	admindb	1107784773	admindb	mne_application	htmlcomposetabnames	label_de	\N	\N	-1	t	\N	\N	f	\N
1100012031	admindb	1107784780	admindb	mne_application	htmlcomposetabnames	label_en	\N	\N	-1	t	\N	\N	f	\N
1224618953	admindb	1224841646	admindb	mne_application	tablecolnames	regexp	\N	\N	-1	f	\N	\N	f	\N
1224786081	admindb	1225227101	admindb	mne_application	tableregexp	tableregexpid	\N	\N	-1	t		\N	f	\N
1224786177	admindb	1225407332	admindb	mne_application	tableregexp	regexp	Regul??rer Ausdruck	regular expression	-1	f	\N	Mindestens ein Zeichen	f	\N
1099493481	admindb	1225747532	admindb	mne_application	htmlcompose	name	\N	\N	-1	t		\N	f	\N
1196771362	admindb	1289926171	admindb	mne_application	menu	action	\N	Aktion	-1	t	\N	\N	f	\N
1196777475	admindb	1289982149	admindb	mne_application	menu	itemname	\N	Elementname	-1	t	\N	\N	f	\N
1107771136	admindb	1289988515	admindb	mne_application	selectlist	text_de	german	deutsch	-1	f	\N	\N	f	\N
1107771136	admindb	1246558362	admindb	mne_application	selectlist	createuser	\N	\N	-1	f	\N	\N	f	\N
1107771136	admindb	1246558366	admindb	mne_application	selectlist	modifydate	\N	\N	1000	f	\N	\N	f	\N
1107771136	admindb	1246558370	admindb	mne_application	selectlist	modifyuser	\N	\N	-1	f	\N	\N	f	\N
1128081227	admindb	1128081227	admindb	mne_application	tablecolnames	showhistory	\N	\N	-1	t	\N	\N	f	\N
1304932385	admindb	1522143660	admindb	mne_application	yearday	leapyear	\N	\N	-1	f	\N	\N	f	\N
1322820231	admindb	1522155488	admindb	mne_application	customerfunctions	funcschema	\N	Schema	-1	f	\N	\N	f	\N
1107958876	admindb	1522144234	admindb	mne_application	htmlcomposetab	id	\N	\N	-1	f		\N	f	\N
1129801840	admindb	1289988529	admindb	mne_application	selectlist	text_en	english	englisch	-1	f	\N	\N	f	\N
1107772165	admindb	1289988542	admindb	mne_application	selectlist	num	postion	Position	-1	f	\N	\N	f	\N
1103897907	admindb	1226307682	admindb	mne_application	translate	id	\N	\N	-1	f		\N	f	\N
1099493513	admindb	1225783693	admindb	mne_application	htmlcompose	template	\N	\N	-1	t		\N	f	\N
1226394451	admindb	1226485179	admindb	mne_application	htmlcomposetabselect	scols	sorting	sortieren	-1	t		\N	f	\N
1226394292	admindb	1226485179	admindb	mne_application	htmlcomposetabselect	id	\N	\N	-1	t		\N	f	\N
1226394409	admindb	1226485179	admindb	mne_application	htmlcomposetabselect	tab	table	Tabelle	-1	t		\N	f	\N
1308834580	admindb	1308834596	admindb	mne_application	timestyle	language	\N	\N	-1	t	\N	\N	f	\N
1308834608	admindb	1308834616	admindb	mne_application	timestyle	region	\N	\N	-1	t	\N	\N	f	\N
1308834640	admindb	1308834640	admindb	mne_application	timestyle	typ	\N	\N	-1	t	\N	\N	f	\N
1308834651	admindb	1308834651	admindb	mne_application	timestyle	style	\N	\N	-1	t	\N	\N	f	\N
1306392930	admindb	1306394247	admindb	mne_application	querycolumns	musthaving	\N	\N	-1	f	\N	\N	f	\N
1307525990	admindb	1307525990	admindb	mne_application	userpref	region	region	Region	-1	f	\N	\N	f	\N
1288017860	admindb	1310654355	admindb	mne_application	htmlcomposetabselect	selval	search column	Suchspalte	-1	f	\N	\N	f	\N
1144661838	admindb	1319441726	admindb	mne_application	userpref	stylename	\N	Anzeige	-1	t	\N	\N	f	\N
1322130294	admindb	1322135118	admindb	mne_application	trustrequest	action	action	Aktion	-1	f	\N	\N	f	\N
1322130338	admindb	1322135118	admindb	mne_application	trustrequest	ipaddr	ip address	IP Adresse	-1	f	\N	\N	f	\N
1322132447	admindb	1322135118	admindb	mne_application	trustrequest	name	\N	Name	-1	f	\N	\N	f	\N
1322130257	admindb	1322135118	admindb	mne_application	trustrequest	trustrequestid	\N	\N	-1	t	\N	\N	f	\N
1338800120	admindb	1522143660	admindb	mne_application	yearday	vday	\N	Tag	-1	f	\N	\N	f	\N
1338800109	admindb	1522143660	admindb	mne_application	yearday	vmonth	\N	Monat	-1	f	\N	\N	f	\N
1338800081	admindb	1522143660	admindb	mne_application	yearday	vquarter	\N	Quartal	-1	f	\N	\N	f	\N
1338800058	admindb	1522143660	admindb	mne_application	yearday	vyear	\N	Jahr	-1	f	\N	\N	f	\N
1432123214	admindb	1432124145	admindb	mne_catalog	uuid	uuid	\N	\N	-1	t	\N	\N	f	\N
1347866637	admindb	1522140602	admindb	mne_application	usertables	schemaname	\N	\N	-1	f	\N	\N	f	\N
1347866658	admindb	1522140602	admindb	mne_application	usertables	tablename	\N	\N	-1	f	\N	\N	f	\N
1347866630	admindb	1522140602	admindb	mne_application	usertables	text_de	german	Deutsch	-1	f	\N	\N	f	\N
1347869065	admindb	1522140602	admindb	mne_application	usertables	text_en	english	Englisch	-1	f	\N	\N	f	\N
1359387208	admindb	1380112458	admindb	mne_application	userpref	mslanguage	\N	\N	-1	f	\N	\N	f	\N
1391683484	admindb	1391683484	admindb	mne_application	trustrequest	typ	type	Typ	-1	f	\N	\N	f	\N
1393481220	admindb	1393481220	admindb	mne_application	trustrequest	custom	\N	\N	-1	f	\N	\N	f	\N
1396591595	admindb	1396591595	admindb	mne_application	trustrequest	validpar	\N	\N	-1	f	\N	\N	f	\N
1400826666	admindb	1410446927	admindb	mne_application	update	updatehost	\N	\N	-1	f	\N	\N	f	\N
1400826652	admindb	1410446927	admindb	mne_application	update	version	\N	\N	-1	f	\N	\N	f	\N
1400826557	admindb	1410446927	admindb	mne_application	update	updateid	\N	\N	-1	t	\N	\N	f	\N
1429689284	admindb	1429689284	admindb	mne_application	userpref	debug	\N	Debug	-1	f	\N	\N	f	\N
1432123495	admindb	1432124145	admindb	mne_catalog	uuid	uuidid	\N	\N	-1	f	\N	\N	f	\N
1107958876	admindb	1522144234	admindb	mne_application	htmlcomposetab	modifydate	\N	\N	1000	t	\N	\N	f	\N
1110273949	admindb	1110273949	admindb	mne_application	tablecolnames	dpytype	\N	\N	-1	t	\N	\N	f	\N
1103897907	admindb	1110274981	admindb	mne_application	translate	createdate	\N	\N	1000	t	\N	\N	f	\N
1103897907	admindb	1110275010	admindb	mne_application	translate	modifydate	\N	\N	1000	t	\N	\N	f	\N
1136212270	admindb	1136212270	admindb	mne_application	joindef	op	\N	\N	-1	t	\N	\N	f	\N
1226394428	admindb	1589528827	admindb	mne_application	htmlcomposetabselect	wop	filter operator	Filteroperant	-1	t	\N	\N	f	\N
1107771136	admindb	1289988556	admindb	mne_application	selectlist	name	select list	Auswahlliste	-1	f	\N	\N	f	\N
1107771136	admindb	1289988578	admindb	mne_application	selectlist	value	\N	Wert	-1	f	\N	\N	f	\N
1433766380	admindb	1433766380	admindb	mne_application	tableregexp	regexpmod	\N	\N	-1	f	\N	\N	f	\N
1465818092	admindb	1465818092	admindb	mne_application	htmlcompose	htmlcomposeid	\N	\N	-1	f	\N	\N	f	\N
1449236580	admindb	1522143660	admindb	mne_application	yearday	wday	week day	Wochentag	1004	f	\N	\N	f	\N
1465819785	admindb	1465819785	admindb	mne_application	htmlcomposetabselect	htmlcomposetabselectid	\N	\N	-1	f	\N	\N	f	\N
1465823279	admindb	1465823279	admindb	mne_application	htmlcomposetabslider	htmlcomposeid	\N	\N	-1	f	\N	\N	f	\N
1465818239	admindb	1465827496	admindb	mne_application	htmlcomposenames	htmlcomposeid	\N	\N	-1	f	\N	\N	f	\N
1465820825	admindb	1465828097	admindb	mne_application	htmlcomposetabnames	htmlcomposetabid	\N	\N	-1	f	\N	\N	f	\N
1465828245	admindb	1465828245	admindb	mne_application	htmlcomposetabnames	htmlcomposeid	\N	\N	-1	f	\N	\N	f	\N
1465828753	admindb	1465828753	admindb	mne_application	htmlcomposetabselect	htmlcomposeid	\N	\N	-1	f	\N	\N	f	\N
1465820501	admindb	1522144234	admindb	mne_application	htmlcomposetab	htmlcomposeid	\N	\N	-1	f	\N	\N	f	\N
1465818933	admindb	1522144234	admindb	mne_application	htmlcomposetab	htmlcomposetabid	\N	\N	-1	f	\N	\N	f	\N
1449469901	admindb	1603714923	admindb	mne_application	yearday	vfullday	date	Datum	1007	f	\N	\N	f	\N
1271678647	admindb	1510223171	admindb	mne_application	userpref	startweblet	start view	Startmaske	-1	f	\N	\N	f	\N
1522137644	admindb	1522137653	admindb	mne_application	tablecolnames	colname	\N	\N	-1	f	\N	\N	f	\N
1610360737	admindb	1610360737	admindb	mne_application	applications	applicationsid	\N	\N	-1	t	\N	\N	f	\N
1610360755	admindb	1610360755	admindb	mne_application	applications	menuname	\N	\N	-1	t	\N	\N	f	\N
1611326455	admindb	1611326455	admindb	mne_application	userpref	exportencoding	\N	\N	-1	f	\N	\N	f	\N
\.


--
-- Data for Name: tableconstraintmessages; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.tableconstraintmessages (tableconstraintmessagesid, text_de, text_en, custom, createuser, modifyuser, createdate, modifydate) FROM stdin;
htmlcompose_name			f	admindb	admindb	0	0
address_second	Der Adresstyp existiert schon	the address type exists	f	admindb	admindb	1522154653	1522154653
time_second	Es gibt schon einen Eintrag im Bautagebuch mit diesem Startdatum	the start date exists	f	admindb	admindb	1525444726	1525444726
file_four			f	admindb	admindb	0	0
personowndata_third			f	admindb	admindb	0	0
personowndata_personid_idx	Die Person hat schon Personaldaten	the person has personnal data	f	admindb	admindb	1605512005	1605512005
storageoptpart_partid_idx	Das Teil ist schon in der Statistik erfasst	the part have a statistic record	f	admindb	admindb	1608124170	1608124170
test_testid_idx	Nur ein Test	only on test	f	admindb	admindb	1588938463	1588938463
fixturetree_parentid_fkey	Elternelement nicht mehr vorhanden oder hat noch Elemente	parent element not avaible or have elements	f	admindb	admindb	1608287463	1608287463
fixturetree_fixtureid_fkey	Inventar ist nicht vorhanden oder ist noch im Inventarbaum vorhanden	fixture is not avaible or is element in fixture tree	f	admindb	admindb	1608287550	1608287550
			f	admindb	admindb	1588158053	1588158053
public_test2_idx_1588163134234	Nur ein Test		f	admindb	admindb	1588163159	1588163159
uid_second	Die Uid ist schon erfasst	the uid is registered	f	admindb	admindb	0	0
address_refid_check	Die Adresse ben??tigt einen Besitzer	the address needs a owner	f	admindb	admindb	1522154424	1522154424
person_personid_check	Interner Fehler Tabelle mne_crm.person personenid ist nicht vorhanden		f	admindb	admindb	1534260784	1534260784
company_name_check	Die Firma muss einen Namen haben	the company needs a name	f	admindb	admindb	1541754889	1541754889
personpicture_personpictureid_check	Bitte eine Personausw??hlen	please select a person	f	admindb	admindb	1542279433	1542279433
orderproduct_orderid_check	Es muss eine Auftragsnummer existieren	order number is not valid	f	admindb	admindb	1544005986	1544005986
fixturetypecost_second	Die Kosten f??r diesen Typ sind schon hinterlegt	cost for these type a available	f	admindb	admindb	1545058405	1545058405
skill_pkey	Die F??higkeit existiert schon	the skill allready exists	f	admindb	admindb	1547537027	1547537027
producttime_productid_description_idx	Die T??tigkeit ist f??r das Produkt schon vorhanden	the work allready exists for this product	f	admindb	admindb	1550579577	1550579577
offerprobability_offernumber_idx	Die Angebotsnummer existiert schon	the offernumber exists	f	admindb	admindb	1542726809	1542726809
offerprobability_offernumber_check	Bitte eine Angebotsnummer angeben	please give a offer number	f	admindb	admindb	1542782237	1542782237
orderproduct_orderproducttype_check	Der Produkttyp ist unbekannt	the product type is unknown	f	admindb	admindb	1544196806	1544196806
inventorystoragelocation_inventorystorageid_fkey	Das Lager ist unbekannt bzw. das Lager besitzt noch Lagerpl??tze	the stoke is unknown resp. thie stoke has stoke locations	f	admindb	admindb	1544776341	1544776341
storagelocation_storageloctypid_fkey	Der Lagerplatztyp ist unbekannt bzw. der Lagerplatztyp ist einem Lagerplatz zugeordnet	the location typ is unknown resp. the location typ is assigned to an location	f	admindb	admindb	1544776507	1544776507
file_third			f	admindb	admindb	0	0
offerproduct_offerid_check	Das Produkt muss einem Angebot zugeordnet sein		f	admindb	admindb	0	0
file_second			f	admindb	admindb	0	0
bugfile_second	Der Name existiert schon	this name exists	f	admindb	admindb	0	0
present_typ_check	Die Anwesenheitsliste ben??tigt einen Typ		f	admindb	admindb	0	0
invoicetime_second			f	admindb	admindb	0	0
builddiary_second			f	admindb	admindb	0	0
offerproduct_third	Die Produktnummer existiert schon	the product number exists	f	admindb	admindb	0	0
person_firstname_check	F??r die Person muss eine Vorname eingegeben werden	the person needs a first name	f	admindb	admindb	0	0
offerproducttime_offerproductid_fkey	Die T??tigkeit muss einem Produkt zugeordnet sein bzw. das Produkt hat noch T??tigkeiten	the activity must asigned to an product resp. the product have activities	f	admindb	admindb	0	0
offerproductpart_second	Das Teil ist schon in der Materialliste vorhanden	the part exists in the part list	f	admindb	admindb	0	0
offerproductpart_offerproductid_fkey	Das Produkt muss im  Angebot vorhanden sein sein bzw. das Produkt besitzt noch eine Materialplanung	the product must be availble in the offer resp.  the product have a material planning	f	admindb	admindb	0	0
offerproductpart_partid_fkey	Das Teil muss in der Datenbank erfasst sein bzw. es wird in einer Materialplanung verwendet	the part must be availible at the database resp. it is using in a material planning	f	admindb	admindb	0	0
feeextra_second	Ein Vorlageprodukt ist f??r dieses Gesetz schon vorhanden		f	admindb	admindb	0	0
invoicetime_timeid_fkey	Der Zeiteintrag muss erfasst sein bzw. der Zeiteintrag hat noch einen Eintrag in den Rechnungszeiten	the time record must be availble in the database resp. the time record have an invoice time record	f	admindb	admindb	0	0
time_orderid_fkey	Der Bautagebucheintrag muss einem Auftrag zugewiesen werden bzw. der Auftrag besitzt noch Bautagebucheintr??ge		f	admindb	admindb	0	0
purchase_count_check	Die Packungsanzahl muss gr??sser als 0 sein	the package count must be greater than 0	f	admindb	admindb	0	0
purchaseaccount_second	Bitte eine andere Kontoposition w??hlen	please select a other account position	f	admindb	admindb	0	0
parttree_partid_fkey	Die Kategorie besitzt Teile bzw. das Teil muss einer Kategorie zugeordnet werden	the category contains parts resp. the parts must have a category	f	admindb	admindb	0	0
parttree_parentid_fkey	Die Kategorie besitzt Teile bzw. das Teil muss einer Kategorie zugeordnet werden	the category contains parts resp. the parts must have a category	f	admindb	admindb	0	0
repository_name_check	Der Name des Aktenschrankes darf nicht leer sein	the name of the repository must have characters	f	admindb	admindb	0	0
invoicetime_invoiceid_fkey	Die Rechnung muss in der Datenbank erfasst sein bzw. die Rechnung besitzt noch Zeiteintr??ge	the invoice must be avaible in the database resp. the invoice have time invoice records 	f	admindb	admindb	0	0
feeextra_check	Das Standardprodukt darf nur global definiert werden		f	admindb	admindb	0	0
fixture_purchasedeliveryid_fkey	Die Bestellung muss in der Datenbank erfasst sein bzw. die Bestellung ist einem Inventar zugeordnet	the purchase must be avaible in the database resp. the purchase is asigned to an fixture	f	admindb	admindb	0	0
workphase_third	Bitte unterschiedliche Produktnummer vergeben		f	admindb	admindb	0	0
partstoragedata_partid_fkey	Das Teil muss in der Datenbank erfasst sein bzw. es existieren Waren dieser Art im Lager	the part must be availible at the database resp. it exists goods of these in the warehouse	f	admindb	admindb	0	0
producttree_check	Das Elternelement muss ungleich dem Element sein	the parent must be a other as the child	f	admindb	admindb	0	0
partstoragedata_storagelocationid_fkey	Der Lagerplatz muss erfasst sein bzw. es liegen Waren auf dem Lagerplatz	the storage location must be availible at the database resp. it exists goods on the storage location	f	admindb	admindb	0	0
partstoragelocation_partingoingid_fkey	Die Einlagerung muss erfasst sein bzw. es existieren Waren dieser Einlagerung im Lager	the ingoing must be availible resp. it exists goods of these ingoing in the warehouse	f	admindb	admindb	0	0
partstoragelocationmasterdata_partid_fkey	Das Teil muss erfasst sein bzw. es existieren Lagerinformation von diesem Teil	the part must be availible at the database resp. is exist storage location master data of these part	f	admindb	admindb	0	0
invoiceref_invoiceid_fkey	Die Rechnung muss in der Datenbank erfasst sein bzw. hat mehrere Rechnungskontakte	the invoice must be availible at the database resp. have multiply contacts	f	admindb	admindb	0	0
partstoragelocationmasterdata_storagelocationtyp_fkey	Der Lagerplatztyp muss erfasst sein bzw. es existieren Lagerplatzdaten f??r diesen Typ	the storage location type must be availible at the database resp. it exist storage location master data	f	admindb	admindb	0	0
partinventory_partid_fkey	Das Teil muss in der Datenbank erfasst sein bzw. es existieren Lagerdaten f??r diese Teil	the part must be availible at the database resp. it exists storage data of these part	f	admindb	admindb	0	0
folder_folder_check	Der Order muss einen Originalnamen haben	the folder must have a original name	f	admindb	admindb	0	0
partsubpart_parentpartid_fkey	Das Gesamtteil muss in der Datenbank erfasst sein bzw. hat Unterteile	the parent part must be availible at the database resp. it have subparts	f	admindb	admindb	0	0
partsubpart_partid_fkey	Das Teil muss in der Datenbank erfasst sein bzw. ist ein Unterteil eines andren Teils	the part must be availible at the database resp. is subpart of a other part	f	admindb	admindb	0	0
personowndata_personid_fkey	Die Person ist nicht erfasst bzw. die Person besitzt noch einen Eintrag in den Personaldaten 	the person is not availible or have personnal data	f	admindb	admindb	0	0
order_partid_fkey	Das Teil ist unbekannt bzw. es wird bei einer Bestellung verwendet	the part is unknown resp. is used by a purchase	f	admindb	admindb	0	0
offer_ownerid_fkey	Der Betreuer muss in der Datenbank erfasst sein bzw. er ist Betreuer von Offerten	the owner must availible at the database resp. he is owner of offers	f	admindb	admindb	0	0
offerproduct_offerid_fkey	Das Produkt ben??tigt eine Offerte bzw. die Offerte hat noch Produkte	the product needs a offer resp. the offer has products	f	admindb	admindb	0	0
order_contactid_fkey	Der Kontakt muss in der Datenbank erfasst sein bzw. es existieren noch Auftr??ge f??r ihn	the contact must be availible in the database resp he is contact of an order	f	admindb	admindb	0	0
bugtree_second	Der Fehler ist schon erfasst	the bug exists in the tree	f	admindb	admindb	0	0
order_ownerid_fkey	Der Betreuer muss in der Datenbank erfasst sein bzw. betreut noch Auftr??ge	the owner must be availible at the database bzw. is owner of orders	f	admindb	admindb	0	0
orderproduct_orderid_fkey	Das Produkt ben??tigt einen Auftrag bzw. der Auftrag hat noch Produkte	the product needs an order resp. the order have products	f	admindb	admindb	0	0
person_ownerid_fkey	Der Betreuer muss in der Datenbank erfasst sein bzw. betreut noch Personen	this owner must be availible at the database resp. is owner of persons	f	admindb	admindb	0	0
productprice_productid_fkey	Das Produkt muss in der Datenbank erfasst sein bzw. besitzt noch eine Preis	the produkt must be availible at the database resp. have a price	f	admindb	admindb	0	0
productvendor_vendorid_fkey	Der Lieferant muss in der Datenbank erfasst sein bzw. liefert Produkte	the vendor must be availible at the database resp. is vendor of products	f	admindb	admindb	0	0
productvendor_productid_fkey	Das Produkt muss in der Datenbank erfasst sein bzw. besitzt noch Lieferanten	the product must be availible at the database resp. have vendors	f	admindb	admindb	0	0
fixture_partid_fkey	Das Teil muss in der Datenbank erfasst sein bzw. wird als Inventar ben??tigt	the part must be availible at the database resp. is using as fixture	f	admindb	admindb	0	0
fixture_fixturetypeid_fkey	Der Inventartyp muss in der Datenbank erfasst sein bzw. wird verwendet	the fixture type must be availible at the database resp. is using	f	admindb	admindb	0	0
fixture_ownerid_fkey	Der Besitzer muss in der Datenbank erfasst sein bzw. ist in besitzt von Inventar	the owner must be availible at the database resp. have fixture	f	admindb	admindb	0	0
fixturetypecost_fixturetypeid_fkey	Der Inventartyp muss in der Datenbank erfasst sein bzw. hat noch eine Kosteneintrag	the fixturetype must be availible at the database resp. have a cost entry	f	admindb	admindb	0	0
feeextra_productid_fkey	Das Produkt muss in der Datenbank erfasst sein bzw. hat noch eine HOAI Eintrag		f	admindb	admindb	0	0
country_third	Das Land existiert schon	the contry exists	f	admindb	admindb	0	0
purchaseinvoicedelivery_purchaseinvoiceid_check	Es ist keine Rechnung angegeben	please assign a invoice	f	admindb	admindb	0	0
queryname_second	Es existiert ein Query mit gleichem Namen und gleicher Union Nummer	it exists a query with the same name and union number	f	admindb	admindb	0	0
offerprobability_probability_check	Die Wahrscheinlichkeit muss gr??sser oder gleich 0 und kleiner oder gleich 100 sein	the probability must be equal or greater than 0 and lower or equal 100	f	admindb	admindb	0	0
personskill_personid_fkey	Der Mitarbeitende muss in der Datenbank erfasst sein bzw. der Mitarbeitenden hat zugeordnete F??higkeiten	the employee must be availible a the database resp. the employee has assigned skills	f	admindb	admindb	0	0
time_orderproducttimeid_fkey	Die T??tigkeit muss erfasst sein bzw. f??r T??tigkeit sind Zeiten erfasst	the activity must be availible at the database resp. is using at the time registration	f	admindb	admindb	0	0
timemanagement_orderproducttimeid_fkey	Die T??tigkeit muss in der Datenbank erfasst sein bzw. wird in der Zeitplanung verwendet	the activity must be availible at the database resp. is using at the time managment	f	admindb	admindb	0	0
deliverynote_contactid_fkey	Der Kontakt muss in der Datanbank erfasst sein bzw. ist Rechnungskontakt	the contact must be availible at the database resp. is contact of invoices	f	admindb	admindb	0	0
deliverynote_invoiceid_fkey	Die Rechnung muss in der Datenbank erfasst sein bzw. hat Lieferscheine	the invoice must be availible at the database resp. have deliverynotes	f	admindb	admindb	0	0
deliverynote_ownerid_fkey	Der Betreuer muss in der Datenbank erfasst sein bzw. betreut Lieferungen	the owner must be availible at the database resp. is owner of deliverynotes	f	admindb	admindb	0	0
deliverynoteproduct_deliverynoteid_fkey	Der Lieferschein muss in der Datenbank erfasst sein bzw. besitzt Produkte	the delivery note must be availible at the database resp. have products	f	admindb	admindb	0	0
purchaseinvoicedelivery_second	Die Lieferung ist schon einer Rechnung zugeordnet	the delivery is allready assigned	f	admindb	admindb	0	0
invoice_condid_fkey	Die Rechungskondition muss in der Datenbank erfasst sein bzw. wird in eine Rechnung verwendet	the invoice condition must be availible at the database resp. is using at a invoice	f	admindb	admindb	0	0
invoice_contactid_fkey	Der Kontakt muss in der Datenbank erfasst sein bzw. ist Rechnungskontakt	the contact must be availible at the database resp. is contact of a invoice	f	admindb	admindb	0	0
invoice_ownerid_fkey	Der Betreuer muss in der Datenbank erfasst sein bzw. betreut Rechnungen	the owner must be availible at the database resp. is owner of invoices	f	admindb	admindb	0	0
invoice_textid_fkey	Der Rechnungstext muss in der Datenbank erfasst sein bzw. wird in einer Rechnung verwendet	the invoice text must be availible at the database resp. is using in a invoice	f	admindb	admindb	0	0
personskill_second	Die F??higkeit existiert schon f??r die Person	the skill allready exists for the person	f	admindb	admindb	0	0
bug_ownerid_fkey	Der Betreuer muss in der Datenbank erfasst sein bzw. betreut Fehler	the owner must be availible at the database resp. is owner of bugs	f	admindb	admindb	0	0
bugfile_bugid_fkey	Der Fehler muss in der Datenbank erfasst sein bzw. besitzt Dateien	the bug must be availible at the database resp. owns files	f	admindb	admindb	0	0
orderproductpart_partid_fkey	Das Teil muss in der Datenbank erfasst sein bzw. wird in der Materialplanung verwendet	the part must be availible at the database resp. is using at the material planning	f	admindb	admindb	0	0
partcost_partid_fkey	Das Teil muss in der Datenbank erfasst sein bzw. besitzt einen Kosteneintrag	the part must be availible at the database resp. have a cost record	f	admindb	admindb	0	0
folder_name_check	Der Ordner muss einen Namen haben	the folder must have a name	f	admindb	admindb	0	0
purchaseinvoice_companyid_fkey	Die Firma besitzt noch Rechungen f??r Lieferungen bzw. die ausgew??hlte Firma existiert nicht in der Datenbank	the company have assigned invoices of purchase resp. the company dos not exists in the database	f	admindb	admindb	0	0
purchaseinvoicedelivery_purchaseinvoiceid_fkey	Der Rechnung sind Lieferscheine zugeordnet bzw. die Rechnung existiert nicht in der Datenbank	the invoice have assigned delivery notes resp. the invoice do not exists in the database	f	admindb	admindb	0	0
partoutgoing_partingoingid_fkey	Die Auslieferung muss von einer Einlagerung stammen bzw. es existieren Auslagerungen zu der Einlagerung	the ingoing must be valid resp. it exists outgoing for these ingoing	f	admindb	admindb	0	0
person_second	Die Person ist schon erfasst	the company has allready a reference to this person 	f	admindb	admindb	0	0
product_second	Die Produktnummer existiert	the product number exists	f	admindb	admindb	0	0
productvendor_second	Der Lieferant ist schon vorhanden	the vendor exists	f	admindb	admindb	0	0
fixture_second	Die Inventarnummer existiert schon	the fixture number exists	f	admindb	admindb	0	0
workphase_productid_fkey	Das Product muss in der Datenbank erfasst sein bzw. besitzt noch einen HOAI Eintrag		f	admindb	admindb	0	0
time_third	Der Zeiteintrag ??berschneidet sich mit einem anderen Zeiteintrag		f	admindb	admindb	0	0
deliverynote_second	Die Laufnummer existiert schon	the delivery note id exists	f	admindb	admindb	0	0
partsecond	Das Typ des Teils existiert	the typ of the part exists	f	admindb	admindb	0	0
partcost_second	Das Teil hat schon einen Preis	the part has a price	f	admindb	admindb	0	0
partingoing_second	Die Lieferung ist schon erfasst	the delivery exists	f	admindb	admindb	0	0
partstoragelocation_second	Die Lieferung besitzt schon einen Lagerplatz	the deliery have a storage location	f	admindb	admindb	0	0
partstoragelocationmasterdata_second	F??r das Teil ist schon ein Lagerplatztyp konfiguriert	the storage location is allready configured for this part 	f	admindb	admindb	0	0
partvendor_second	Der Lieferant existiert schon f??r das Teil	the vendor exists for the part	f	admindb	admindb	0	0
inventorystoragelocation_second	Der Lagerplatzname existiert schon im Lager	the stoarge location name exist for this storage	f	admindb	admindb	0	0
storagepersonnal_second	Der Lagerist ist f??r diese Lager schon erfasst	the warehouseman is configured for this storage	f	admindb	admindb	0	0
htmlcompose_name_check	Der Name darf nicht leer sein	the name must have content	f	admindb	admindb	0	0
htmlcomposetab_id_check	Die Id darf nicht leer sein	the id must have content	f	admindb	admindb	0	0
selectlist_name_check	Die Liste muss einen Namen haben	the list must have a name	f	admindb	admindb	0	0
userpref_language_check	Die Sprache ist ( de, en ) f??r (deutsch, englisch)	the language is ( de, en ) for (german, english)	f	admindb	admindb	0	0
personemail_personid_fkey	Die Person muss erfasst sein bzw. die Person hat noch Emailadressen	the person must be availible resp. the person have asigned email addresses	f	admindb	admindb	0	0
userpref_htmldatestyle_check	Der Datumsstyle ist ( de, en, us, fr ) f??r (deutsch, englisch, us-englisch, franz??sisch) oder leer	 the date style is  ( de, en, us, fr ) for (german, english, us-english, france) or empty	f	admindb	admindb	0	0
address_addressid_check	Die addressid darf nicht leer sein	addressid must have a content	f	admindb	admindb	0	0
companydatacategorie_text_en_check	Es wird ein deutscher Text ben??tigt	Es wird ein englischer Text ben??tigt	f	admindb	admindb	0	0
companyperson_check	Eine assiziierter Kontakt muss von einer Fremdfirma sein	a associated contact must be from a other company	f	admindb	admindb	0	0
country_name_de_check	Das Land muss einen deutschen Namen haben	the contry must have a german name	f	admindb	admindb	0	0
country_name_en_check	Das Land muss einen englischen Namen haben	the country must have a english name	f	admindb	admindb	0	0
country_countryid_check	Die countryid darf nicht leer sein	the countryid must have a content	f	admindb	admindb	0	0
oderproduct_second	Das Produkt existiert schon	the product exists	f	admindb	admindb	0	0
person_lastname_check	F??r die Person muss ein Nachname eingeben werden	the person needs a last name	f	admindb	admindb	0	0
person_sex_check	Das Geschlecht ist entweder weiblich oder m??nlich	the sex ist fermale or male	f	admindb	admindb	0	0
fixturetype_typ_check	Der Inventartyp muss benannt werden	the fixture type needs a name	f	admindb	admindb	0	0
fixturetypetree_treename_check	Das Element muss einen Namen haben	the element needs a name	f	admindb	admindb	0	0
orderproducttime_setduration_check	Die Solldauer muss gr??sser gleich 0 sein	the set duration must be greater or equal 0	f	admindb	admindb	0	0
offerproducttime_setduration_check	Die Solldauer muss gr??sser gleich 0 sein	the set duration must be greater or equal 0	f	admindb	admindb	0	0
timemanagement_duration_check	Die Dauer muss gr??sser als 0 sein	the duration must be greater than 0	f	admindb	admindb	0	0
deliverynoteproduct_count_check	Die Anzahl der Produkte muss ungleich 0 sein	the count of the products must be not equal 0	f	admindb	admindb	0	0
personfile_personid_fkey	Die Datei muss einer Person zugeordnet werden bzw. die Person hat noch zugeordnete Dokumente	the documents must have a owner resp. the person have documents	f	admindb	admindb	0	0
storage_zcount_check	Die Anzahl 3. Position muss gr??sser 0 sein	the count of the third postion must be greater zero	f	admindb	admindb	0	0
offerfile_offerid_fkey	Das Dokument muss einem Angebot zugeordnet werden bzw. das Angebot hat noch Dokumente	the document must have a reference to an offer resp. the offer have documents	f	admindb	admindb	0	0
orderfile_orderid_fkey	Das Dokument muss einem Auftrag zugeordnet werden bzw. der Auftrag hat noch Dokumente	the document must have a reference to an order resp. the order have documents	f	admindb	admindb	0	0
personskill_skillid_fkey	Die F??higkeit muss in der Datenbank erfasst sein bzw. die F??higkeit ist einem Mitarbeitenden zugeordnet	the skill must be availible at the database resp. is assigned to an employee	f	admindb	admindb	0	0
orderproducttime_skillid_fkey	Die F??higkeit muss erfasst sein bzw. die F??higkeit ist noch einen Auftragsproduct zugeordnet	the skill must be availble resp. the skill ist asigned to an order product	f	admindb	admindb	0	0
companyown_companyid_fkey	Die eigene Firma ben??tigt einen Eintrag in der Datenbank	the own company must be availible at the database	f	admindb	admindb	0	0
offerproducttime_skillid_fkey	Die F??higkeit muss erfasst sein bzw. die F??higkeit ist noch einen Angebotsprodukt zugeordnet	the skill must be availble resp. the skill ist asigned to an offer product	f	admindb	admindb	0	0
mailbox_server_check	Der Servername muss Inhalt besitzen	the server name must have content	f	admindb	admindb	0	0
mailbox_login_check	Der Benutzername darf nicht leer sein	the user name must have content	f	admindb	admindb	0	0
skill_skillid_check	Die T??tigkeitsid darf nicht leer sein	the skillid must have content	f	admindb	admindb	0	0
folder_mailboxid_fkey	Die Mailbox muss registiert sein bzw. die Mailbox besitzt noch Ordner	the mailbox must be availble resp. the mailbox have folder	f	admindb	admindb	0	0
offer_second	Die Offernummer ist mit dieser Version schon vorhanden	offer number exists with this version	f	admindb	admindb	0	0
bug_status_check	Erlaubt Werte f??r den Status: ( known, workaround, fix)	valid for status: ( known, workaround, fix)	f	admindb	admindb	0	0
partstoragelocationmasterdata_maxcount_check	Die Maximalanzahl muss gr??sser 0 sein	the maximal count must be greater than 0	f	admindb	admindb	0	0
menu_second	Das Men?? hat schon ein Element mit dieser Id	it exists a menu element with this id	f	admindb	admindb	0	0
companydata_companyid_fkey	Die Firma muss in der Datenbank erfasst sein	the company must be availible at the database	f	admindb	admindb	0	0
purchaseinvoicedelivery_purchasedeliveryid_fkey	Der Lieferschein ist einer Rechnung zugeordnet bzw. der Lieferschein existiert nicht in der Datenbank	the deliveynote is assigned to an invoice resp. the deliverynote do not exists in the database	f	admindb	admindb	0	0
address_addresstypid_fkey	Der Adresstyp muss in der Datenbank eingetragen sein bzw. wird von einer Adresse benutzt	the address type must be availible at the database resp. is used by a address	f	admindb	admindb	0	0
city_countryid_fkey	Das Land muss in der Datenbank eingetragen sein bzw. wird bei einer Ortschaft benutzt	the country must be availible at the database resp. is needed by a city	f	admindb	admindb	0	0
company_ownerid_fkey	Der Betreuer muss in der Datenbank erfasst sein bzw. betreut eine Firma	the owner must be a valid person of the database resp. is owner of a company	f	admindb	admindb	0	0
companydata_categorie_fkey	Die Firmenkategorie muss in der Datenbank erfasst sein bzw. ist in Benutzung	the categorie must be availible at the database resp. is using	f	admindb	admindb	0	0
purchaseinvoicepay_second			f	admindb	admindb	0	0
offer_contactid_fkey	Der Kontakt muss in der Datenbank erfasst sein bzw. es existieren Offerten f??r ihn	the contact must be availible at the database resp. it exists offers for him	f	admindb	admindb	0	0
companyemail_companyid_fkey	Die Firma muss erfasst sein bzw. die Firma besitzt noch Emailadressen	the company must be availible resp. the company have email addresses	f	admindb	admindb	0	0
joindef_second	Es ist schon ein Join mit dieser Definition vorhanden	a join exists with this definition	f	admindb	admindb	0	0
currency_second	Die W??hrung existiert schon	the currency is availible	f	admindb	admindb	0	0
addresstyp_addresstyp	Der Adresstyp existiert schon	the address type exists	f	admindb	admindb	0	0
city_second	In dieser Stadt existiert schon diese Postleitzahl	the city ist availible	f	admindb	admindb	0	0
purchaseinvoicepay_purchaseinvoiceid_fkey	Die Rechnung wurde schon zur Bezahlung freigegeben	the invoice are all rready release for paying	f	admindb	admindb	0	0
country_second	Das Land existiert schon	the contry exists	f	admindb	admindb	0	0
offerproduct_second	Das Produkt existiert schon	the product exists	f	admindb	admindb	0	0
order_second	Die Auftragsnummer existiert schon	this order number exists	f	admindb	admindb	0	0
fixturetree_treename_check	Das Inventar muss einen Namen haben	the fixture must have a name	f	admindb	admindb	0	0
invoiceaccount_second	Die Buchung ist schon zugewiesen	the accounting entry is allready asigned	f	admindb	admindb	0	0
trustfunction__first			f	admindb	admindb	0	0
deliverynoteproduct_orderproductid_fkey	Das Produkt muss zu einem Auftrag geh??ren bzw. das Produkt wurde ausgeliefert	the product must be a product of a order resp. is delivered	f	admindb	admindb	0	0
purchase_crmorderid_fkey	Der Auftrag besitzt noch eine Bestellung	the order have an material order	f	admindb	admindb	0	0
purchaseinvoice_second	Die Belegnummer ist schon vorhanden	the document number exists	f	admindb	admindb	0	0
partvendor_companyid_fkey	Der Lieferant muss in der Datenbank erfasst sein bzw. die Firma ist Lieferant von Teilen	the vendor must be available in the database resp. the company is vendor of parts	f	admindb	admindb	0	0
purchase_ownerid_fkey	Der Besteller muss in der Datenbank erfasst sein bzw. die Person ist noch Besitzer von Bestellungen	the orderer must be available in the database resp. the person is owner of a material order	f	admindb	admindb	0	0
companyperson_personid_fkey	Der Kontakt muss in der Datenbank erfasst  sein bzw. wird als assoziierter Kontakt zu einer Firma ben??tigt	the person must be availible at the database resp. is a associated contact of a company	f	admindb	admindb	0	0
companyperson_companyid_fkey	Die Firma muss in der Datenbank erfasst sein bzw. besitzt nochassoziiert Kontakte	the company must be availible at the database resp. have associate contacts	f	admindb	admindb	0	0
personaltime_second	Zu jedem Bautagebucheintrag muss es genau einen Tagesrapporteintrag geben	each builddiary record  must have a day report record	f	admindb	admindb	0	0
users_second	Die Person hat schon ein Dav Password	the person have a dav password	f	admindb	admindb	0	0
person_refid_fkey	Die Firma muss in der Datenbank erfasst sein bzw. die Firma hat noch Kontakte	the company must be avaible in the database resp. persons reffers the company	f	admindb	admindb	0	0
companyown_second	Das Prefix darf nur einmal vorhanden sein	the prefix is allready in use	f	admindb	admindb	0	0
productpart_partdescription_check	Das Material muss einen Namen haben	the part must have a name	f	admindb	admindb	0	0
order_companyid_fkey	Die Firma des Auftrages muss in der Datenbank erfasst sein bzw. die Firma besitzt noch Auftr??ge	the company of the order must avaible in the database resp. the company have asigned orders	f	admindb	admindb	0	0
order_personid_fkey	Der Kunde muss in der Datenbank erfasst sein bzw. die Person besitzt Auftr??ge	the customer must be availble in the database resp. the person have order	f	admindb	admindb	0	0
invoiceref_companyid_fkey	Die Firma muss in der Datenbank erfasst sein bzw. die Firma ist noch ein Rechnungskontakt	the company must be avaible in the database resp. the company is a invoice contact	f	admindb	admindb	0	0
invoiceref_personid_fkey	Die Person muss in der Datenbank erfasst sein bzw. die Person ist noch ein Rechnungskontakt	the person must be avaible in the database resp. the person  is a invoice contact	f	admindb	admindb	0	0
partoutgoing_orderproductpartid_fkey	Das Teil muss in der Materialplanung erfasst sein bzw. es besteht ein  Auslagerauftrag f??r Material des Produktes	the part must be availible at the material planning resp. is ready for delivery	f	admindb	admindb	0	0
partingoing_partstoragelocationid_fkey	Der Lagerplatz muss existieren bzw. die Eingangsware ist nicht eingelagert	the storage location must be exists resp. must be stocked	f	admindb	admindb	0	0
purchasedelivery_second	Die Belegnummer existiert schon zu dieser Bestellung	the document number exists for this purchase	f	admindb	admindb	0	0
partingoing_purchasedeliveryid_fkey	Der Lierferschein existiert nicht bzw. die Ware des Lieferscheins ist eingelagert worden	the delivery note do not exists resp. the part are stocked	f	admindb	admindb	0	0
delivery_orderid_fkey	Zu der Bestellung existieren Lieferscheine bzw. die Bestellung muss in der Datenbank erfasst sein	it exists deliverynotes for the order resp. the order must be availible at the database	f	admindb	admindb	0	0
time_personaltimeid_fkey	Der Bautagebucheintrag ben??tigt einen Eintrag in der Zeiterfassung bzw. der Eintrag in der Zeiterfassung ist noch ein Bautagebucheintrag zugeordnet		f	admindb	admindb	0	0
time_duration_check	Die Dauer muss gr??sser als 0 sein	the duration must be greater than 0	f	admindb	admindb	0	0
time_weather_check	Bitte einen Wert f??r das Wetter angeben	please give a value for the weather	f	admindb	admindb	0	0
present_personid_fkey	Die Person muss in der Datenbank erfasst sein bzw. die Person ist im Bautagebuch eingetragen		f	admindb	admindb	0	0
present_timeid_fkey	Der Eintrag in der Anwesendheitsliste muss einem Eintrag im Bautagebuch zugewiesen sein bzw. der Bautagebucheintrag hat noch einen Eintrag in der Anwesenheitsliste		f	admindb	admindb	0	0
orderproducttime_orderproductid_fkey	Das Produkt muss erfasst sein bzw. es existiert noch ein Eintrag in der Zeitplannung f??r dieses Produkt	the product must be availible resp. it exists an record for the time management	f	admindb	admindb	0	0
file_check	Es muss eine Referenz angegeben werden	the document needs a reference	f	admindb	admindb	1594886086	1594886086
fileinterests_second	Die Datei ist schon der Person zugeordnet	the file is allready asigned	f	admindb	admindb	1598971281	1598971281
file_ownerid_fkey	Der Eigner muss in der Datenbank erfasst sein bzw. die Person besitzt noch Dokumente	the owner must be avaible in the database resp. the person have documents	f	admindb	admindb	0	0
comment_timeid_fkey	Der Zeiteintrag im Bautagebuch muss in der Datenbank erfasst sein bzw. es existiert noch ein Kommentar zum Zeiteintrag	the builddiary record must be avaible in the database resp. the builddiary record have assigned comments	f	admindb	admindb	0	0
orderproduct_third	Die Produktnummer existiert schon	the product number exists	f	admindb	admindb	0	0
producttime_productid_fkey	Das Proukt ist nicht vorhanden bzw das Produkt besitzt noch Zeitplannungseintr??ge	the product do not exists resp. the product have time planning records	f	admindb	admindb	0	0
producttime_skillid_fkey	Die T??tigkeit ist nicht konfiguriert bzw. die T??tigkeit wird noch in der Produktzeitplannung verwendet	the skill is not configurated resp. the skill is used in the product time planning	f	admindb	admindb	0	0
personowndata_second	Der Loginname ist schon vergeben	the login name is in use	f	admindb	admindb	0	0
time_userid_fkey	Der Benutzer muss im Personalverzeichnis vorhanden sein bzw. es existieren Zeiteintr??ge f??r die Person	the person must be employer resp. the person have time records	f	admindb	admindb	0	0
present_check	Es muss mindestens eine Person anwesend sein	it must be mininum on person persent	f	admindb	admindb	0	0
present_count_check	Die Anzahl der Mitarbeiter kann nicht negativ sein	the employee count is not negative	f	admindb	admindb	0	0
present_second	Die Person ist schon im Bautagebuch diese Termins	the person is in the build diary of this date	f	admindb	admindb	0	0
orderproductpart_orderproductid_fkey	Es muss ein Produkt aus dem Auftrag ausgew??hlt werden bzw. wird das Produkt besitzt Eintr??ge in der Materialplanung	the product must be selected  from the order  resp. is using at the material planning	f	admindb	admindb	0	0
orderproductpart_ownerid_fkey	Bitte eine Mitarbeiter ausw??hlen bzw. der Mitarbeiter ist noch Manager von Auftragsmaterial	please select a employee or the employee is still manager of order material	f	admindb	admindb	0	0
offerproductpart_ownerid_fkey	Es muss ein Mitarbeiter als Betreuer ausgew??hlt werden bzw. der Mitarbeiter ist noch Betreuer von Angebotsmaterial	It must be selected an employee as manager of offer material resp. the employee is manager of offer material	f	admindb	admindb	0	0
filedata_second	Die Revision ist schon vorhaden	the revision exists	f	admindb	admindb	0	0
fileinterests_personid_fkey	Die Person ist nicht im ERP erfasst bzw. die Person interessiert sich noch f??r Daten im Aktenschrank	the person must be avaible im ERP resp. the person need data of the repository	f	admindb	admindb	0	0
filedata_repositoryid_fkey	Der Akteneintrag muss einem Aktenordner zugeordnet werden bzw. die Aktenordern ist w??hrend des L??schens nicht leer	the file must be contained in a folder resp. during delete of the folder the folder is not empty	f	admindb	admindb	0	0
repository_second	Der Name des Aktenordners existiert schon	the name of the file exists	f	admindb	admindb	0	0
storage_xcount_check	Die Anzahl 1. Position muss gr??sser 0 seint	the count of the first postion must be greater zero	f	admindb	admindb	0	0
storage_ycount_check	Die Anzahl 2. Position muss gr??sser 0 sein	the count of the second postion must be greater zero	f	admindb	admindb	0	0
invoicepaid_second			f	admindb	admindb	0	0
shares_personid_fkey	Die Person muss im ERP erfasst sein bzw. die person besitzt noch Freigaben	the person must be availble at the ERP resp. the person have shares	f	admindb	admindb	0	0
shares_second	Die Person hat schon Zugriff auf die Freigabe	the person have allready access to the share	f	admindb	admindb	0	0
shares_folderid_fkey	Der Ordner muss im ERP existieren bzw. der Ordner hat noch Freigaben	the folder must exist at the ERP resp. the folder have shares	f	admindb	admindb	0	0
personsharepasswd_second	Der Loginname ist schon vergeben	the login name allready exists	f	admindb	admindb	0	0
fixturecost_fixtureid_fkey	Das Inventar muss in der Datenbank erfasst sein bzw. das Inventar besitzt noch eine Kosteneintrag	the fixture must be availible at the database resp. the fixture have a cost entry	f	admindb	admindb	0	0
purchaseinvoice_third	Die Rechnungsnummer existiert schon bei diesem Lieferanten	the invoice number exists for this vendor	f	admindb	admindb	0	0
network_networkid_check	Bitte eine Namen f??r das Interface angeben	please give a name for the interface	f	admindb	admindb	0	0
city_name_check	Bitte eine Namen f??r die Ortschaft angeben	please give a name for the city 	f	admindb	admindb	0	0
tablecolnames_dpytype_check	Der Anzeigetyp ist nicht bekannt	the display type is unknown	f	admindb	admindb	0	0
htmlcomposetab_second	Die Webletid existiert schon	the weblet id exists	f	admindb	admindb	0	0
mailalias_personid_fkey	Die Person muss erfasst sein bzw. die Person besizt noch Mailaliases	the person must be avaible resp. the person have mail aliases	f	admindb	admindb	0	0
personowndata_loginname_idx	Der Loginname ist schon vergeben	the login name is allready in use	f	admindb	admindb	0	0
dnsaddress_record_check	Bitte eine DNS Record Typ angeben	please give an dns record type	f	admindb	admindb	0	0
dnsaddress_name_address_record_idx	Der DNS Eintrag existiert schon	the dns entry exists	f	admindb	admindb	0	0
address_cityid_fkey	Die Stadt muss in der Datenbank erfasst sein bzw. die Stadt wird noch in einer Addresse verwendet	the city must avaible in the database resp. the city is used in a address	f	admindb	admindb	0	0
public_test1_idx_1589470729281			f	admindb	admindb	1589470735	1589470735
producttree_parentid_fkey	Unterpunkt ben??tigt ein Elternelement bzw. Unterpunkt hat noch Unterelemente	item needs an parent resp. items contain subitems	f	admindb	admindb	1600150586	1600150586
mne_crm_producttree_idx_1600172327440	Der Name ist schon vorhanden	the name exists	f	admindb	admindb	1600172362	1600172362
productpart_partid_fkey	Das Produt besizt noch Materialdaten bzw. die Materialdaten sind noch einem Produkt zugeordnet	the product still has material data or the material data is still assigned to a product	f	admindb	admindb	0	0
folder_second	Das Basisverzeichnis ist schon vorhanden	the basefolder exists	f	admindb	admindb	1553790020	1553790020
folder_third	Der Name des Basisverzeichnisses ist schon vorhanden	the name of the basefolder exists	f	admindb	admindb	1553790030	1553790030
offerproducttime_offerproductid_description_idx	Die T??tigkeit ist beim Produkt schon vorhanden	the activity allready exists for this product	f	admindb	admindb	1600866823	1600866823
mne_personnal_personowndata_fkey_1603704827264	Persondaten ist nicht erfasst bzw. die Person besitzt noch einen Eintrag in den internen Personaldaten 	person data is not availible or have internal personnal data	f	admindb	admindb	1603704827	1603704827
mne_personnal_time_check_1605102351054	Es muss eine Startzeit angegeben werden	please give a starttime	f	admindb	admindb	1605102434	1605102434
order_partvendorid_fkey	Der Lieferant f??r dieses Teil ist unbekannt oder wird in einer Bestellung ben??tigt	the vendor of the part is unknown resp. is used by a purchase	f	admindb	admindb	1607704739	1607704739
partstoragemasterdata_second	Das Teil besizt schon Lagerdaten	part storage data exists for the part	f	admindb	admindb	1608032938	1608032938
\.


--
-- Data for Name: tableregexp; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.tableregexp (createdate, createuser, modifydate, modifyuser, tableregexpid, regexp, regexphelp, regexpmod) FROM stdin;
1304336758	admindb	1304337172	admindb	email	.+@.+|^$	Emailaddresse	
1257447284	admindb	1307533102	admindb	floatemptysave	[0-9]*[\\.,][0-9]+|[0-9]+|^$	Bitte Gleitkommazahl mit einem . oder , als Dezimaltrenner eingeben	
1225231635	admindb	1589967209	admindb	num	-{0,1}[0-9]+	Bitte eine Zahl eingeben	
1267106143	admindb	1307537443	admindb	keyvalue	[0-9A-Fa-f]+|################	Schl??sselwert	
1225231444	admindb	1225783642	admindb	notempty	.+	Bitte mindestens ein Zeichen eingeben	
1225231820	admindb	1322730381	admindb	floatsave	([0-9\\.]*,[0-9]+)|([0-9,]*\\.[0-9]+)|([0-9]+)	Bitte Gleitkommazahl mit einem . oder , als Dezimaltrenner eingeben	
1292834974	admindb	1379920701	admindb	keyvalueempty	[0-9A-Fa-f]+|################|^$	Schl??sselwert oder Leer	
1358522650	admindb	1420532643	admindb	color	[\\dA-Fa-f][\\dA-Fa-f][\\dA-Fa-f][\\dA-Fa-f][\\dA-Fa-f][\\dA-Fa-f]|	Bitte 6 Hexadezimalziffern eingeben	
1453898809	admindb	1453901101	admindb	alphanumminus	[a-zA-Z0-9\\-_]+	Bitte Buchstaben, Zahlen, Bindestrich und den Unterstrich eingeben	
1478780812	admindb	1478790326	admindb	macaddr	[0-9,A-F,a-f][0-9,A-F,a-f]:[0-9,A-F,a-f][0-9,A-F,a-f]:[0-9,A-F,a-f][0-9,A-F,a-f]:[0-9,A-F,a-f][0-9,A-F,a-f]:[0-9,A-F,a-f][0-9,A-F,a-f]:[0-9,A-F,a-f][0-9,A-F,a-f]	Bitte eine MAC Addresse eingeben	g
1478857773	admindb	1478857773	admindb	macaddrempty	[0-9,A-F,a-f][0-9,A-F,a-f]:[0-9,A-F,a-f][0-9,A-F,a-f]:[0-9,A-F,a-f][0-9,A-F,a-f]:[0-9,A-F,a-f][0-9,A-F,a-f]:[0-9,A-F,a-f][0-9,A-F,a-f]:[0-9,A-F,a-f][0-9,A-F,a-f]|^$	Bitte eine MAC Addresse eingeben oder leer lassen	g
1224788911	admindb	1530178729	admindb	alpha	[a-zA-Z_]+	Bitte nur Buchstaben ohne Umlaute und den Unterstrich eingeben	
1225231474	admindb	1530178748	admindb	alphanum	[a-zA-Z0-9_]+	Bitte Buchstaben ohne Umlaute, Zahlen und den Unterstrich eingeben	
1225231552	admindb	1530178756	admindb	alpha_alphanum	[a-zA-Z][a-zA-Z0-9_]*	Bitte Buchstaben ohne Umlaute, Zahlen und den Unterstrich beginnend mit einem Buchstaben eingeben	
1225231501	admindb	1530178763	admindb	alphaorempty	[a-zA-Z_]+|^$	Bitte nur Buchstaben ohne Umlaute und den Unterstrich eingeben	
1225231578	admindb	1530178772	admindb	alphanumorempty	[a-zA-Z0-9_]+|^$	Bitte Buchstaben ohne Umlaute, Zahlen und den Unterstrich eingeben	
1225231617	admindb	1530178781	admindb	alpha_alphanumorempty	[a-zA-Z][a-zA-Z0-9_]*|^$	Bitte Buchstaben ohne Umlaute, Zahlen und den Unterstrich beginnend mit einem Buchstaben eingeben	
1225231751	admindb	1589967111	admindb	numoempty	-{0,1}[0-9]+|^$	Bitte eine Zahl eingeben	
1225231652	admindb	1589967231	admindb	num1_num	[1-9][0-9]*	Bitte eine positive Zahl eingeben die nicht mit einer 0 beginnt	
1225231791	admindb	1589967238	admindb	num1_numoempty	[1-9][0-9]*|^$	Bitte eine positive Zahl eingeben die nicht mit einer 0 beginnt	
1225231771	admindb	1589967283	admindb	num1oempty	[1-9]+|^$	Bitten eine positive Zahl ohne 0 eingeben	
1578468448	admindb	1578479789	admindb	ip6addr	^(?:(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){6})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:::(?:(?:(?:[0-9a-fA-F]{1,4})):){5})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){4})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,1}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){3})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,2}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){2})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,3}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:[0-9a-fA-F]{1,4})):)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,4}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,5}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,6}(?:(?:[0-9a-fA-F]{1,4})))?::))))$	Bitte eine IPV6 Addresse eingeben	
1433770650	admindb	1611841955	admindb	ip4addr	^(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])$	Bitte eine Ip4 Addresse eingeben	
1433766450	admindb	1611841965	admindb	ip4addrempty	^((25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]))$|^$	Bitte eine Ip4 Addresse eingeben	
1611819960	admindb	1611841863	admindb	ip6addrmaskempty	^(?:(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){6})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:::(?:(?:(?:[0-9a-fA-F]{1,4})):){5})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){4})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,1}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){3})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,2}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){2})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,3}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:[0-9a-fA-F]{1,4})):)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,4}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,5}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,6}(?:(?:[0-9a-fA-F]{1,4})))?::))))\\/[1-9][0-9]{0,2}$|^$	Bitte eine IPV6 Addresse mit Maske eingeben	
1611837987	admindb	1611841863	admindb	ip6addrmaskmempty	^((?:(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){6})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:::(?:(?:(?:[0-9a-fA-F]{1,4})):){5})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){4})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,1}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){3})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,2}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){2})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,3}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:[0-9a-fA-F]{1,4})):)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,4}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,5}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,6}(?:(?:[0-9a-fA-F]{1,4})))?::))))\\/[1-9][0-9]{0,2}\\n)*((?:(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){6})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:::(?:(?:(?:[0-9a-fA-F]{1,4})):){5})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){4})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,1}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){3})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,2}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){2})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,3}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:[0-9a-fA-F]{1,4})):)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,4}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,5}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,6}(?:(?:[0-9a-fA-F]{1,4})))?::))))\\/[1-9][0-9]{0,2})\\n*$|^$	Bitte eine IPV6 Addresse mit Maske pro Zeile eingeben	
1611841151	admindb	1611842002	admindb	ip4addrmask	^(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\/[1-9][0-9]{0,1}$	Bitte eine Ip4 Addresse mit Maske eingeben	
1611841074	admindb	1611842137	admindb	ip4addrmaskmempty	^((25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\/[1-9][0-9]{0,1}\\n)*((25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\/[1-9][0-9]{0,1})\\n*$|^$	Bitte eine Ip4 Addresse mit Maske pro Zeile eingeben	
1611840767	admindb	1611842476	admindb	ip4addrmempty	^((25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\n)*((25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]))\\n*$|^$	Bitte eine Ip4 Addresse pro Zeile eingeben	
1578468479	admindb	1611841822	admindb	ip6addrempty	^(?:(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){6})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:::(?:(?:(?:[0-9a-fA-F]{1,4})):){5})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){4})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,1}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){3})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,2}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){2})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,3}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:[0-9a-fA-F]{1,4})):)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,4}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,5}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,6}(?:(?:[0-9a-fA-F]{1,4})))?::))))$|^$	Bitte eine IPV6 Addresse eingeben	
1611819016	admindb	1611841863	admindb	ip6addrmask	^(?:(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){6})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:::(?:(?:(?:[0-9a-fA-F]{1,4})):){5})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){4})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,1}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){3})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,2}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){2})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,3}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:[0-9a-fA-F]{1,4})):)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,4}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,5}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,6}(?:(?:[0-9a-fA-F]{1,4})))?::))))\\/[1-9][0-9]{0,2}$	Bitte eine IPV6 Addresse mit Maske eingeben 	
1611842078	admindb	1611842078	admindb	ip4addrmaskm	^((25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\/[1-9][0-9]{0,1}\\n)*((25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\/[1-9][0-9]{0,1})\\n*$	Bitte eine Ip4 Addresse mit Maske pro Zeile eingeben	
1611842332	admindb	1611842332	admindb	ip6addrmaskm	^((?:(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){6})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:::(?:(?:(?:[0-9a-fA-F]{1,4})):){5})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){4})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,1}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){3})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,2}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){2})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,3}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:[0-9a-fA-F]{1,4})):)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,4}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,5}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,6}(?:(?:[0-9a-fA-F]{1,4})))?::))))\\/[1-9][0-9]{0,2}\\n)*((?:(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){6})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:::(?:(?:(?:[0-9a-fA-F]{1,4})):){5})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){4})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,1}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){3})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,2}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){2})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,3}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:[0-9a-fA-F]{1,4})):)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,4}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])).){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,5}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,6}(?:(?:[0-9a-fA-F]{1,4})))?::))))\\/[1-9][0-9]{0,2})\\n*$	Bitte eine IPV6 Addresse mit Maske pro Zeile eingeben	
1611842258	admindb	1611842476	admindb	ip4addrm	^((25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\n)*((25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]).(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9]))\\n*$	Bitte eine Ip4 Addresse pro Zeile eingeben	
1614065085	admindb	1614065085	admindb	ipaddr	^(?:(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){6})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:::(?:(?:(?:[0-9a-fA-F]{1,4})):){5})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){4})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,1}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){3})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,2}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){2})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,3}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:[0-9a-fA-F]{1,4})):)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,4}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,5}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,6}(?:(?:[0-9a-fA-F]{1,4})))?::))))$|^(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])$	Bitte eine IP Addresse eingeben	
1614065136	admindb	1614065136	admindb	ipaddrempty	^(?:(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){6})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:::(?:(?:(?:[0-9a-fA-F]{1,4})):){5})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){4})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,1}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){3})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,2}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:(?:[0-9a-fA-F]{1,4})):){2})(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,3}(?:(?:[0-9a-fA-F]{1,4})))?::(?:(?:[0-9a-fA-F]{1,4})):)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,4}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9]))\\.){3}(?:(?:25[0-5]|(?:[1-9]|1[0-9]|2[0-4])?[0-9])))))))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,5}(?:(?:[0-9a-fA-F]{1,4})))?::)(?:(?:[0-9a-fA-F]{1,4})))|(?:(?:(?:(?:(?:(?:[0-9a-fA-F]{1,4})):){0,6}(?:(?:[0-9a-fA-F]{1,4})))?::))))$|^(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9]?[0-9])$|^$	Bitte eine IP Addresse eingeben	
\.


--
-- Data for Name: timestyle; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.timestyle (createdate, createuser, language, modifydate, modifyuser, region, style, typ) FROM stdin;
\.


--
-- Data for Name: translate; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.translate (createdate, createuser, modifydate, modifyuser, id, text_de, text_en, categorie, accesstime) FROM stdin;
1098171178	admindb	1098176417	admindb	falsch		false		\N
1383931504	admindb	1383931504	admindb	Lager		stock		\N
1478853269	admindb	1478853269	admindb	\n				\N
1614084027	admindb	1614084027	admindb	Typ"			HttpTranslate	\N
1351237472	admindb	1381276899	admindb	Gesamt		entire	DbQuery	\N
1130508768	admindb	1135341651	admindb	Mai		may	Http	\N
1590648144	admindb	1600336203	admindb	Abfrage		query	HttpTranslate	\N
1591614618	admindb	1600336207	admindb	Neue Liste		new list	HttpTranslate	\N
1596625868	admindb	1600336211	admindb	Ansehen		show	HttpTranslate	\N
1597934784	admindb	1600336031	admindb	Mitarbeiter hinzuf??gen		add employee	HttpTranslate	\N
1606732474	admindb	1607409458	admindb	Monat		month	HttpTranslate	0
1599126686	admindb	1600336120	admindb	Benutzer <%>existiert schon bitte anderen Namen w??hlen		user <%> exists - please give a other name	DbConnect	\N
1599126686	admindb	1600336164	admindb	Benutzer <%> existiert schon und hat eventuell Zugriff zu einer anderen Datenbank		uer <%> exists and have perhaps access to an other database 	DbConnect	\N
1599136874	admindb	1600336178	admindb	Datenbankbenutzer nicht gefunden		database user not found	DbConnect	\N
1585636855	admindb	1585636855	admindb	MneViewWeblet:getIdparam ist nur im Modifymodus erlaubt		MneViewWeblet:getIdparam only for modify	HttpTranslate	\N
1583821572	admindb	1583821572	admindb	Falscher Status 		wrong status	HttpTranslate	\N
1583825117	admindb	1583825117	admindb	Kein Weblet 		no weblet	HttpTranslate	\N
1584080721	admindb	1584080721	admindb	Kein View Path		no view path	HttpTranslate	\N
1584428511	admindb	1584428511	admindb	Elternelement ist kein Weblet		parent is not a weblet	HttpTranslate	\N
1584428511	admindb	1584428511	admindb	Container ist kein HTML Element		container is not an html element	HttpTranslate	\N
1585892196	admindb	1585892196	admindb	Uhr		clock	HttpTranslate	\N
1587130121	admindb	1589297545	admindb	Editieren		edit	HttpTranslate	\N
1590572614	admindb	1590572874	admindb	Bitte einen Wert f??r <$1> angeben		please give a value for <$1>	HttpTranslate	\N
1589287427	admindb	1600335861	admindb	Mysql		mysql	HttpTranslate	\N
1589299353	admindb	1600335870	admindb	keine Leseurl f??r 		no read url	HttpTranslate	\N
1589783133	admindb	1600335877	admindb	und andere		and other	HttpTranslate	\N
1590497798	admindb	1600335895	admindb	Zeile $1 wirklich l??schen		delete row $1 realy ?	HttpTranslate	\N
1591345493	admindb	1600335909	admindb	Kommando		comand	HttpTranslate	\N
1592472730	admindb	1600335914	admindb	Textgr??sse		textsize	HttpTranslate	\N
1593604274	admindb	1600335923	admindb	R??ckg??ngig machen		rollback	HttpTranslate	\N
1593604274	admindb	1600335932	admindb	Wiederhohlen		repeat	HttpTranslate	\N
1593681773	admindb	1600335937	admindb	Sichern		save	HttpTranslate	\N
1595517535	admindb	1600335945	admindb	Neue Notiz		new notice	HttpTranslate	\N
1596546431	admindb	1600335949	admindb	Print		print	HttpTranslate	\N
1597749914	admindb	1600335966	admindb	Bild l??schen		delete picture	HttpTranslate	\N
1597750232	admindb	1600335982	admindb	Bild wirklich l??schen ?		delete picture realy ?	HttpTranslate	\N
1597928363	admindb	1600336012	admindb	Datei ist gr??sser als 5MB		file size larger than 5MB 	HttpTranslate	\N
1599836671	admindb	1600336189	admindb	Berechne Kosten		compute cost	HttpTranslate	\N
1599059102	admindb	1600336048	admindb	Mitarbeiter hinzuf??gen/bearbeiten		add/modify employee	HttpTranslate	\N
1600353933	admindb	1603188626	admindb	Alle Kosten berechnen		compute all cost	HttpTranslate	0
1600356198	admindb	1603188652	admindb	F??r das Produkt k??nnen die Kosten nicht berechnet werden		cost can not be compute for these product	DbConnect	0
1600843974	admindb	1603189316	admindb	Angebotsnummer wird schon bei einem anderen Kunden verwendet		offer number is in use	DbConnect	0
1600863270	admindb	1603358799	admindb	keine Summen		no sum	HttpTranslate	0
1603117385	admindb	1603358822	admindb	Prozentsumme ist ungleich 100		sum of percent is not 100	HttpTranslate	0
1603708770	admindb	1605023345	admindb	Query %s:%s:%d existiert schon		query %s:%s:%d exists	DbQueryCreator	0
1605168763	admindb	1607409449	admindb	Datum		date	HttpTranslate	0
1605523599	admindb	1607409453	admindb	Mitglied		member	HttpTranslate	0
1606820267	admindb	1607409462	admindb	Startzeit		start time	HttpTranslate	0
1607088272	admindb	1607409470	admindb	Alle Personen		all person	HttpTranslate	0
1607705472	admindb	1609750305	admindb	Der Lieferant liefert dieses Teil nicht		the supplier does not deliver this part	DbConnect	0
1607956753	admindb	1609750347	admindb	Die Kosten werden noch von einem Angebot ben??tigt		the costs are still required from an offer	DbConnect	0
1609743588	admindb	1609750347	admindb	Folder		folder	DbHttpUtilsImap	0
1609750183	admindb	1609750347	admindb	??berpr??fen		check	HttpTranslate	0
1609752307	admindb	1609752403	admindb	Komplett lesen		read complete	HttpTranslate	0
1358847380	admindb	1381277049	admindb	Rechnungszuordnung bearbeiten		modify invoice assignment	HttpTranslate	\N
1358847380	admindb	1589297513	admindb	Rechnungszuordnung hinzuf??gen		add invoice assignment	HttpTranslate	\N
1587482874	admindb	1589297604	admindb	Position		postition	HttpTranslate	\N
1587456569	admindb	1600336194	admindb	Detail		detail	HttpTranslate	\N
1649917863	admindb	1649917863	admindb	Name"			HttpTranslate	\N
1590646566	admindb	1600336198	admindb	letzte Abfrage		last query	HttpTranslate	\N
1410784641	admindb	1410784641	admindb					\N
1598002633	admindb	1600336233	admindb	Der Aktenschrank <%s> existiert nicht		the filling cabinet don't exist	DbHttpUtilsRepository	\N
1603189456	admindb	1603189456	admindb	Angebot war eine Vorlage und wurde kopiert		offer is a template and is copied	DbConnect	0
1603189604	admindb	1603189604	admindb	Angebot ohne Referenz kann nicht zum Auftrag werden		can not make a offer to a order without reference	DbConnect	0
1600936734	admindb	1605023375	admindb	Letze Abfrage: keine werte angefordert		last query: no values requested	DbHttpUtilsQuery	0
1605080618	admindb	1605080618	admindb	Bautagebuch		builddiary		0
1605541834	admindb	1605541834	admindb	admindb	Datenbankadministrator	database admin	DbGroup	0
1605541943	admindb	1605541943	admindb	adminbuilddiary	Verwaltung Bautagebuch	admin builddiary	DbGroup	0
1605542122	admindb	1605542122	admindb	adminfixture	Verwaltung Inventar	admin fixture	DbGroup	0
1605542152	admindb	1605542152	admindb	adminmail	Verwaltung Mail	admin mail	DbGroup	0
1605542206	admindb	1605542206	admindb	adminpersonnal	Verwaltung Personal	admin personnal	DbGroup	0
1605542249	admindb	1605542249	admindb	adminpersonnaltime	Verwaltung Zeiteintr??ge	admin time recording	DbGroup	0
1605542279	admindb	1605542279	admindb	adminrepository	Verwaltung Aktenschrank	admin repository	DbGroup	0
1605542308	admindb	1605542308	admindb	adminshare	Verwaltung Freigaben	admin shares	DbGroup	0
1605542360	admindb	1605542360	admindb	adminshipment	Verwaltung Auslieferung	admin shipment	DbGroup	0
1605542398	admindb	1605542398	admindb	adminsystem	Verwaltung Betriebssystem	admin system	DbGroup	0
1605542432	admindb	1605542432	admindb	adminwarehouse	Verwaltung Lager	admin warehouse	DbGroup	0
1605542895	admindb	1605542895	admindb	showhoai	Zeige HOAI Rechner	show compute hoai 	DbGroup	0
1605541908	admindb	1605597714	admindb	admincrm	Verwaltung Kontakt/Auftr??ge	admin contact/order	DbGroup	0
1608111564	admindb	1609750347	admindb	Auslagerung		outgoing	DbQuerySingle	0
1608121320	admindb	1609750464	admindb	Das Teil ist f??r einen Auftrag reserviert		the part is reserved for an order	DbConnect	0
1608121654	admindb	1609750464	admindb	Lagerplatz enth??lt keine passende Teile		storage location does not contain matching parts	DbConnect	0
1608121654	admindb	1609750464	admindb	Es existiert ein Lagerplatz mit reservierten Teilen f??r diesen Auftrag		there is a storage location with reserved parts for this order	DbConnect	0
1608121654	admindb	1609750464	admindb	 Lagerplatz geh??hrt zu einer Auslagerung		storage space is part of an outsourcing	DbConnect	0
1608121654	admindb	1609750504	admindb	Die Teile k??nnen keinem anderen Auftrag zugeordnet werden		the parts cannot be assigned to any other order	DbConnect	0
1608122308	admindb	1609750504	admindb	Lieferung ist noch nicht ausgelagert		delivery has not yet been outsourced	DbConnect	0
1608122862	admindb	1609750524	admindb	Reservierung f??r einen Auftrag wurde aufgehoben		reservation for an order has been canceled	DbConnect	0
1605542629	admindb	1609770885	admindb	erpbuilddiary	Lesen Bautagebuch	builddiary	DbGroup	0
1605542657	admindb	1609770885	admindb	erpfixture	Lesen Inventar	fixture	DbGroup	0
1605542673	admindb	1609770885	admindb	erpmail	Lesen Mail	mail	DbGroup	0
1605542690	admindb	1609770885	admindb	erppersonnal	Lesen Personal	personnal	DbGroup	0
1605542726	admindb	1609770885	admindb	erprepository	Lesen Aktenschrank	repository	DbGroup	0
1605542743	admindb	1609770885	admindb	erpshare	Lesen Freigaben	shares	DbGroup	0
1605542762	admindb	1609770885	admindb	erpshipment	Lesen Auslieferung	shipment	DbGroup	0
1605542791	admindb	1609770885	admindb	erpsystem	Lesen Betriebssystem	system	DbGroup	0
1605542815	admindb	1609770885	admindb	erpwarehouse	Lesen Lager	warehouse	DbGroup	0
1605543048	admindb	1609770885	admindb	erpsmb	Nutzen Freigaben	use share	DbGroup	0
1605543268	admindb	1609770885	admindb	erpdav	Nutzen Kalender/Kontakt Export	use calendar/contact export	DbGroup	0
1605542605	admindb	1609770885	admindb	erpcrm	Lesen Kontakt/Auftr??ge	contact/order	DbGroup	0
1609770949	admindb	1609771042	admindb	erpdb	Verwalten Benutzer Tabellen	admin user tables	DbGroup	0
1597038918	admindb	1600336244	admindb	Abfrage hat mehr als ein Ergebnis		query have more than one result	DbHttpUtilsTable	\N
1598261049	admindb	1600336271	admindb	Datei versionieren		add version	HttpTranslate	\N
1601384105	admindb	1603358849	admindb	Kal. Kosten ??ndern		modify calc. cost	HttpTranslate	0
1603198592	admindb	1603358900	admindb	Lieferung ist erfolgt - der Lieferschein kann nicht gel??scht werden		is delivered - can not modify deliverynote	DbConnect	0
1603205181	admindb	1603358919	admindb	Bestellung ist noch nicht offen		order not open	DbConnect	0
1426492809	admindb	1605702912	admindb	Benutzer hat ERP Zugriff - bitte im Personalmodul verwalten		user has ERP access - please manage in the personnal module	DbConnect	0
1605703026	admindb	1605703026	admindb	Qualifikationen		skills	HttpTranslate	0
1597220728	admindb	1600336277	admindb	kein Subject		no subject	HttpTranslate	\N
1597231683	admindb	1600336284	admindb	Vcard		vcard	HttpTranslate	\N
1597307978	admindb	1600336292	admindb	ignorieren		ignore	HttpTranslate	\N
1597311160	admindb	1600336297	admindb	Hinzuf??gen/??ndern		add/modify	HttpTranslate	\N
1598271745	admindb	1600335854	admindb	Keine Daten gefunden		no data found	HttpFilesystem	\N
1603358677	admindb	1603358788	admindb	nicht in Rechnung gestellt		not invoiced	DbQuerySingle	0
1603291345	admindb	1603358936	admindb	Lieferung ist noch nicht erfolgt		not delivered	DbConnect	0
1603290386	admindb	1605023394	admindb	wval <%s> nicht gefunden		wval <%s> not found	DbHttpReport	0
1598335318	admindb	1600336303	admindb	Keine Notiz		no notiz	DbHttpUtilsRepository	\N
1603444256	admindb	1605023412	admindb	Rechnung wurde schon verschickt		invoice is sended	DbConnect	0
1603457802	admindb	1605023454	admindb	Die Rechnung ist erfolgt und kann nicht gel??scht werden		invoice is sended and can't delete	DbConnect	0
1598340712	admindb	1600336330	admindb	Der Name der Datei darf nicht leer sein		please give a name	DbHttpUtilsRepository	\N
1603468126	admindb	1605023520	admindb	Vorschau 1. Mahnung		preview first reminder	HttpTranslate	0
1603468389	admindb	1605023520	admindb	Vorschau 2. Mahnung		preview second reminder	HttpTranslate	0
1603468389	admindb	1605023520	admindb	Vorschau 3. Mahnung		preview third reminder	HttpTranslate	0
1598343245	admindb	1600336346	admindb	Ordner/Datei		directory/file	HttpTranslate	\N
1598342554	admindb	1598342961	admindb	??nderungsnotiz		modify note	HttpTranslate	\N
1391603266	admindb	1598343440	admindb	Ordner/Datei\n		folder/file	HttpTranslate	\N
1598449020	admindb	1600336375	admindb	kann tempor??res f??r <%s> nicht ??ffnen		kann open temp for <%s>	TmpFile	\N
1598516754	admindb	1598516866	admindb	interesse		interest	DbQuerySingle	\N
1598516754	admindb	1598516866	admindb	inaktiv		inactive	DbQuerySingle	\N
1100158135	admindb	1100158238	admindb	Company		company		\N
1383931202	admindb	1383931202	admindb	Logout		logout		\N
1418990098	admindb	1576762335	admindb	Rot		red	HttpTranslate	\N
1351236365	admindb	1381276711	admindb	neue Version		new version	HttpTranslate	\N
1534346356	admindb	1576760261	admindb	Zugriff nicht m??glich		no access	HttpTranslate	\N
1351236297	admindb	1370626121	admindb	Produkt Schritt		product step	DbQuery	\N
1351236297	admindb	1370626130	admindb	Produktzeiten		product times	DbQuery	\N
1351236297	admindb	1370626136	admindb	Eigene Zeit		own time	DbQuery	\N
1351236297	admindb	1370626153	admindb	eigene Zeiten		own time	DbQuery	\N
1351236297	admindb	1370626161	admindb	Total		total	HttpTranslate	\N
1351236328	admindb	1370626266	admindb	Bitte eine Zahl eingeben		only numbers	HttpTranslate	\N
1351237472	admindb	1381276835	admindb	leer		empty	HttpTranslate	\N
1351236328	admindb	1370626284	admindb	Bitten eine Zahl ohne 0 eingeben		only number expected 0	HttpTranslate	\N
1351236328	admindb	1370626343	admindb	Schl??sselwert		key value	HttpTranslate	\N
1351236328	admindb	1370626361	admindb	Letzter Kindknoten ist kein Textknoten		last childnode is a text node	HttpTranslate	\N
1351236084	admindb	1370626366	admindb	Optionen		options	DbQuery	\N
1351236084	admindb	1370626379	admindb	Wartung Optionen		support options	DbQuery	\N
1351236328	admindb	1370626392	admindb	Text fett schreiben		text bold	HttpTranslate	\N
1351236328	admindb	1370626399	admindb	Text kursiv schreiben		text italic	HttpTranslate	\N
1351236328	admindb	1370626511	admindb	Abschnitt links justiert formatieren		adjust section left 	HttpTranslate	\N
1351236328	admindb	1370626520	admindb	Abschnitt rechts justiert formatieren		adjust section right	HttpTranslate	\N
1351236328	admindb	1370626529	admindb	Abschitt zentrieren		adjust section center	HttpTranslate	\N
1351236328	admindb	1370626534	admindb	Element		element	HttpTranslate	\N
1351236328	admindb	1370626557	admindb	Klassen		classes	HttpTranslate	\N
1351236328	admindb	1370626562	admindb	Absatz		section	HttpTranslate	\N
1351236328	admindb	1370626577	admindb	kann Cursor nach undo nicht setzen		can't set cursor after undo	HttpTranslate	\N
1351236328	admindb	1370626589	admindb	??nderung r??ckg??ngig machen		reverse changes	HttpTranslate	\N
1351236328	admindb	1370626631	admindb	??nderung wieder herstellen		making change back	HttpTranslate	\N
1351236328	admindb	1370626664	admindb	Aufz??hlung einf??gen		insert list	HttpTranslate	\N
1351236328	admindb	1370626724	admindb	Bitte eine Zahl mit einem $1 eingeben		please input a number with $1	HttpTranslate	\N
1351236328	admindb	1370626751	admindb	Bitte eine Zahl mit einem $1 eingeben oder leer lassen		pleas insert number with a $1 or empty	HttpTranslate	\N
1351236328	admindb	1370626767	admindb	 Fehler beim Schreiben in die Datenbank gefunden		error during writting into the database	HttpTranslate	\N
1351236328	admindb	1370626814	admindb	Knoten 		node	HttpTranslate	\N
1351236328	admindb	1370626868	admindb	$1 auserhalb einer Tabelle gefunden - wird ignoriert		$1 found a table outside - is ignored	HttpTranslate	\N
1351236328	admindb	1370626883	admindb	Unbekannter Tag 		inknown tag	HttpTranslate	\N
1351236328	admindb	1370626894	admindb	Kann Text nicht einf??gen		can't insert text	HttpTranslate	\N
1351236328	admindb	1370626955	admindb	Auswahl in das Clipboard ??bertragen		transfer choise into clipboard	HttpTranslate	\N
1351236328	admindb	1381273338	admindb	Inhalt des Clipboards in die Auswahl einsetzen		insert the content of the clipbord in the selection	HttpTranslate	\N
1351236328	admindb	1381273568	admindb	Keine Spalte zum l??schen gefunden		no column found to delete	HttpTranslate	\N
1351236328	admindb	1381273602	admindb	Kann Spalte nur in eine Zeile einf??gen		can column only insert into a row	HttpTranslate	\N
1351236329	admindb	1381273622	admindb	Kann Zeile nur in eine Tabelle einf??gen		can insert a row only in a table	HttpTranslate	\N
1351236329	admindb	1381273685	admindb	Kann nur in eine Tabelle eine Zeile einf??gen		can insert a row only in a table	HttpTranslate	\N
1351236329	admindb	1381273740	admindb	Keine Tabelle zum L??schen selektiert		no table selected for deletion	HttpTranslate	\N
1351236329	admindb	1381273767	admindb	Spalte vor die aktuelle Spalte hinzuf??gen		insert a column before the actual column	HttpTranslate	\N
1351236329	admindb	1381273782	admindb	Spalte hinter die aktuelle Spalte hinzuf??gen		insert a column behind the actual column	HttpTranslate	\N
1351236329	admindb	1381273796	admindb	aktuelle Spalte l??schen		delete actual column	HttpTranslate	\N
1351236329	admindb	1381273823	admindb	Zeile hinter die aktuelle Zeile hinzuf??gen		insert a row behind actual row	HttpTranslate	\N
1351236329	admindb	1381273831	admindb	aktuelle Zeile l??schen		delete actual row	HttpTranslate	\N
1351236329	admindb	1381273837	admindb	Zelle		cell	HttpTranslate	\N
1351236329	admindb	1381273873	admindb	Sicher		safe	HttpTranslate	\N
1351236362	admindb	1381273883	admindb	Kein Template gefunden		no template found	HttpTranslate	\N
1351236362	admindb	1381273938	admindb	Keine Eingabefeld f??r 		no input field for	HttpTranslate	\N
1351236362	admindb	1381273947	admindb	keine Abfrage und keine Table f??r 		no query or table for	HttpTranslate	\N
1351236362	admindb	1381273980	admindb	Keine Aktion bzw. Abfrage oder Table zum Lesen definiert		no action resp. query or table defined for reading	HttpTranslate	\N
1351236362	admindb	1381273996	admindb	Keine Werte f??r $1:$2 gefunden		no values for $1:$2 found	HttpTranslate	\N
1351236362	admindb	1381274032	admindb	Mehr als einen Wertesatz gefunden f??r $1:$2 gefunden		more than one data set found for $1:$2	HttpTranslate	\N
1351236362	admindb	1381274130	admindb	Zeilennummer oder Spaltennummer sind ausserhalb des Bereichs		row number or col number outside the valid area	HttpTranslate	\N
1351236362	admindb	1381274137	admindb	Meldungen		message	HttpTranslate	\N
1351236365	admindb	1381274146	admindb	Angebot hinzuf??gen		add offer	HttpTranslate	\N
1107781963	admindb	1107789659	admindb	Web		web		\N
1351236365	admindb	1381274156	admindb	Angebot bearbeiten		modify offer	HttpTranslate	\N
1351236365	admindb	1381274161	admindb	Angebot 		offer	HttpTranslate	\N
1351254746	admindb	1382442289	admindb	Leistungsphasen		working steps	HttpTranslate	\N
1351236328	admindb	1530178873	admindb	Bitte nur Buchstaben ohne Umlaute, Zahlen, den Unterstrich und den Schr??gstrich eingeben		only letter, number, underscore order slash	HttpTranslate	\N
1098343532	admindb	1098776657	admindb	Neues Schema		new schema	Http	\N
1351236365	admindb	1381276543	admindb	Wirklich alle manuell ver??nderten Kosten der Produkte ??berschreiben?		Really overwrite any manual changes in cost of products?	HttpTranslate	\N
1351236365	admindb	1381276696	admindb	Angebot kopieren		copy offer	HttpTranslate	\N
1351236365	admindb	1381276704	admindb	Kosten berechnen		compute cost	HttpTranslate	\N
1535609341	admindb	1576760273	admindb	fehlerhaftes XMLn		error in xml	HttpTranslate	\N
1351236365	admindb	1381276753	admindb	Produktstandard ??bernehmen		take over product standard	HttpTranslate	\N
1351236365	admindb	1381276760	admindb	Exportieren		export	HttpTranslate	\N
1351236365	admindb	1381276797	admindb	Die Spalte wurde ge??ndert - sollen die Werte geschrieben werden ?		row was changed - write changes ?	HttpTranslate	\N
1351236371	admindb	1381276804	admindb	Produkt hinzuf??gen		add product	HttpTranslate	\N
1351236371	admindb	1381276813	admindb	Das Angebot ist geschlossen		offer is closed	HttpTranslate	\N
1351236371	admindb	1381276820	admindb	berechnen		compute	HttpTranslate	\N
1351237472	admindb	1381276829	admindb	Abfrage Zeigen		show query	HttpTranslate	\N
1351237472	admindb	1381276840	admindb	nicht leer		not empty	HttpTranslate	\N
1351237472	admindb	1381276869	admindb	??nhlich	??hnlich	similarly	HttpTranslate	\N
1351237472	admindb	1381276892	admindb	Gesamte Tabelle		entire table	HttpTranslate	\N
1351259620	admindb	1382444639	admindb	neue Spalte		new column	HttpTranslate	\N
1351237479	admindb	1381276913	admindb	Bearbeitungsschritt hinzuf??gen		add working step	HttpTranslate	\N
1351237479	admindb	1381276923	admindb	Bearbeitungsschritt bearbeiten		modify working step	HttpTranslate	\N
1351238105	admindb	1381276931	admindb	Produktmaterial		product material	DbQuery	\N
1351238105	admindb	1381276937	admindb	keine Teile		no parts	DbQuery	\N
1351238105	admindb	1381276950	admindb	Eigenes Material		own parts	DbQuery	\N
1351239505	admindb	1381276964	admindb	Produkt 		product	HttpTranslate	\N
1351239505	admindb	1381276970	admindb	Preis hinzuf??gen		add price	HttpTranslate	\N
1351239505	admindb	1381276976	admindb	Preis 		price	HttpTranslate	\N
1351239505	admindb	1381276996	admindb	W??hrung bitte w??hlen		select currency	HttpTranslate	\N
1351239505	admindb	1381277004	admindb	Kein Preis		no price	DbQuery	\N
1358851875	admindb	1381277071	admindb	Es existiert schon ein Produkt mit gleichem Namen		there is already a product with the same name	DbConnect	\N
1362552848	admindb	1381277089	admindb	Fehler beim Schreiben zum Client %d		error during writing to client %d	ServerSocket	\N
1362570271	admindb	1381277099	admindb	??berschriften hinzuf??gen		add headline	HttpTranslate	\N
1362570271	admindb	1381277109	admindb	??berschriften bearbeiten		modify headline	HttpTranslate	\N
1362570271	admindb	1381277115	admindb	??berschriften 		headline	HttpTranslate	\N
1362570271	admindb	1381277131	admindb	??berschriftdatei ??bertragen		transfer headline file	HttpTranslate	\N
1362570271	admindb	1381277142	admindb	Art		typ	HttpTranslate	\N
1363680416	admindb	1381277170	admindb	assoziierten Kontakt bearbeiten		modify associated contact	HttpTranslate	\N
1363680416	admindb	1381277174	admindb	hinzuf??gen		add	HttpTranslate	\N
1363682752	admindb	1381277196	admindb	Ohne Bestellung		without purchase	DbQuery	\N
1363682752	admindb	1381277238	admindb	Lagerauftrag hinzuf??gen		add storage task	HttpTranslate	\N
1363682752	admindb	1382441259	admindb	Lagerauftrag bearbeiten		modify storage task	HttpTranslate	\N
1363682906	admindb	1382441348	admindb	Auslagerung hinzuf??gen		add stock removal 	HttpTranslate	\N
1363682906	admindb	1382441361	admindb	Auslagerung bearbeiten		modify stock removal 	HttpTranslate	\N
1363682906	admindb	1382441420	admindb	Kein Ziellagerplatz ausgew??hlt		no destination storage selected	HttpTranslate	\N
1363682752	admindb	1382441915	admindb	Fertig		ready	HttpTranslate	\N
1363682906	admindb	1382441937	admindb	Abgeholt		fetched	HttpTranslate	\N
1363682906	admindb	1382441950	admindb	Auftrag setzen		set order	HttpTranslate	\N
1363682906	admindb	1382441956	admindb	fertig		ready	HttpTranslate	\N
1351236365	admindb	1600671601	admindb	Kopie von 		copy of 	HttpTranslate	\N
1364481750	admindb	1382441964	admindb	bearbeiten		modify	HttpTranslate	\N
1364481750	admindb	1382441973	admindb	Kategorie		categorie	HttpTranslate	\N
1364481750	admindb	1382442005	admindb	Unbekannt		umknown	HttpTranslate	\N
1351242940	admindb	1382442015	admindb	neue Abfrage		new query	HttpTranslate	\N
1351242940	admindb	1382442025	admindb	Abfrage bearbeiten		modify query	HttpTranslate	\N
1351242940	admindb	1382442040	admindb	Query wirklich l??schen		delete query	HttpTranslate	\N
1351242940	admindb	1382442053	admindb	Keine Werte f??r 		no values for	HttpTranslate	\N
1351242940	admindb	1382442061	admindb	Keine Tabellen definiert		no table defined	HttpTranslate	\N
1351242969	admindb	1382442068	admindb	neue Tabelle		new table	HttpTranslate	\N
1351242969	admindb	1382442075	admindb	Tabelle bearbeiten		modify table	HttpTranslate	\N
1351242969	admindb	1382442081	admindb	Tabelle wirklich l??schen		delete table	HttpTranslate	\N
1351242969	admindb	1382442086	admindb	Tabelle 		table	HttpTranslate	\N
1351242994	admindb	1382442109	admindb	Spalte hinzuf??gen		add column	HttpTranslate	\N
1351242994	admindb	1382442118	admindb	Spalte bearbeiten		modify column	HttpTranslate	\N
1351242994	admindb	1382442129	admindb	editieren nicht m??glich		modify not posible	HttpTranslate	\N
1351245691	admindb	1382442147	admindb	Auftrag 		order	HttpTranslate	\N
1351245691	admindb	1382442154	admindb	geschlossen		closed	DbQuery	\N
1351245691	admindb	1382442159	admindb	offen		open	DbQuery	\N
1351245700	admindb	1382442204	admindb	ver??ndern		modify	HttpTranslate	\N
1351245710	admindb	1382442210	admindb	Schritt		step	DbQuery	\N
1351245850	admindb	1382442234	admindb	Reportroot ist nicht vorhanden		report root is not availble	ReportText	\N
1351254229	admindb	1382442247	admindb	Keine Zeile ausgew??hlt		no row selected	HttpTranslate	\N
1351254229	admindb	1382442258	admindb	Kein Feld ausgew??hlt		no field selected	HttpTranslate	\N
1351254746	admindb	1382442273	admindb	Leistungsphasen bearbeiten		modify working step	HttpTranslate	\N
1351254746	admindb	1382442280	admindb	Berechnen		compute	HttpTranslate	\N
1351254746	admindb	1382442310	admindb	Honorarzone		charge zone	HttpTranslate	\N
1351254746	admindb	1382442334	admindb	Erbrachte Leistung		 services rendered	HttpTranslate	\N
1351254746	admindb	1382442356	admindb	Honoraransatz		honorary approach	HttpTranslate	\N
1351254746	admindb	1382442378	admindb	Anrechenbare Kosten		 eligible costs	HttpTranslate	\N
1351254746	admindb	1382442400	admindb	Zuschlag		addition	HttpTranslate	\N
1351254746	admindb	1382442407	admindb	Zeithonorar		time fee	HttpTranslate	\N
1351254746	admindb	1382442441	admindb	Besondere Leistungen		extra benefit	HttpTranslate	\N
1351254746	admindb	1382442448	admindb	Zus??tzliche Leistungen		aditonal benefit	HttpTranslate	\N
1102679424	admindb	1106131885	admindb	neue Addresse		new address	Http	\N
1351255078	admindb	1382442548	admindb	Arbeitsschritte Pauschal		working steps flatrate	HttpTranslate	\N
1351255380	admindb	1382444560	admindb	Vorlageprodukt		produkt template	HttpTranslate	\N
1351255380	admindb	1382444568	admindb	Produktnummer		product number	HttpTranslate	\N
1351255827	admindb	1382444575	admindb	neue Funktion		new function	HttpTranslate	\N
1351255827	admindb	1382444582	admindb	Funktion bearbeiten		modify function	HttpTranslate	\N
1351255827	admindb	1382444597	admindb	Funktion 		function	HttpTranslate	\N
1351257478	admindb	1382444612	admindb	F??higkeit hinzuf??gen		add skill	HttpTranslate	\N
1351257478	admindb	1382444623	admindb	F??higkeit bearbeiten		modify skill	HttpTranslate	\N
1351259294	admindb	1382444630	admindb	Kontakt		contact	DbQuery	\N
1351259620	admindb	1382444645	admindb	Spalte 		column	HttpTranslate	\N
1351264106	admindb	1382444683	admindb	Umbenennen		rename	HttpTranslate	\N
1351264106	admindb	1382444692	admindb	Bitte eine Wert eingeben		please select a value	HttpTranslate	\N
1351264106	admindb	1382444706	admindb	Kann die Referenz nicht l??schen		can not delete the reference	HttpTranslate	\N
1351323647	admindb	1382444792	admindb	Firma hinzuf??gen		add company	HttpTranslate	\N
1351323647	admindb	1382444798	admindb	Firma 		company	HttpTranslate	\N
1351323647	admindb	1382444804	admindb	Import		import	HttpTranslate	\N
1351323647	admindb	1382444812	admindb	??berschriftdateien		header file	HttpTranslate	\N
1351323647	admindb	1382444817	admindb	Hochladen		upload	HttpTranslate	\N
1352797123	admindb	1382444914	admindb	Selektionstabelle hinzuf??gen		add selection table	HttpTranslate	\N
1352797123	admindb	1382444923	admindb	Selektionstabelle bearbeiten		modify selection table	HttpTranslate	\N
1352797123	admindb	1382444933	admindb	Bitte erst ein Weblet ausw??hlen		please select a weblet	HttpTranslate	\N
1352797415	admindb	1382445042	admindb	neues Subweblet		new subweblet	HttpTranslate	\N
1352797415	admindb	1382445058	admindb	Subweblet 		subweblet	HttpTranslate	\N
1352977022	admindb	1382445066	admindb	Index hinzuf??gen		add index	HttpTranslate	\N
1352977022	admindb	1382445086	admindb	Fehler beim L??schen des Index		error during delete the index	HttpTranslate	\N
1352983940	admindb	1382445099	admindb	Extraleistung ist unbekannt		extra fee unkown	DbConnect	\N
1352984992	admindb	1382445114	admindb	HOAI Exraleistung hinzuf??gen		add HOAI extra fee	HttpTranslate	\N
1352984992	admindb	1382445127	admindb	HOAI Extraleistung bearbeiten		modify HOAI extra fee	HttpTranslate	\N
1352985471	admindb	1382445146	admindb	Checkconstraint bearbeiten		modify check contraint	HttpTranslate	\N
1352985471	admindb	1382445178	admindb	Checkconstraint wirklich l??schen		really delete check contraint	HttpTranslate	\N
1352985471	admindb	1382445187	admindb	bitte erst eine Tabelle ausw??hlen		please select a table	HttpTranslate	\N
1352985471	admindb	1382445197	admindb	Checkconstraint 		check constraint	HttpTranslate	\N
1352985952	admindb	1382445205	admindb	Kategorie hinzuf??gen		add categorie	HttpTranslate	\N
1352985952	admindb	1382445224	admindb	Kategorie 		categorie	HttpTranslate	\N
1353050850	admindb	1382445233	admindb	Addresse hinzuf??gen		add adress	HttpTranslate	\N
1353051982	admindb	1382445266	admindb	Bautagebucheintrag hinzuf??gen		add builddiary item	HttpTranslate	\N
1353051982	admindb	1382445279	admindb	Bautagebucheintrag bearbeiten		modify builddiary item	HttpTranslate	\N
1353051982	admindb	1382445289	admindb	Bautagebucheintrag 		builddiary item	HttpTranslate	\N
1353051982	admindb	1382445304	admindb	Bitte die Zeiteingaben ??berpr??fen		please check time item	HttpTranslate	\N
1353051989	admindb	1382445312	admindb	Zeiteintrag hinzuf??gen		add time item	HttpTranslate	\N
1353051989	admindb	1382445324	admindb	Eintrag 		item	HttpTranslate	\N
1353051989	admindb	1382445391	admindb	Soll die Zeit auf den aktuellen Projektschritt erfasst werden ?		should be recorded the time to the current project step ?	HttpTranslate	\N
1353051989	admindb	1382445398	admindb	Ok/Hinzuf??gen		ok/add	HttpTranslate	\N
1353051989	admindb	1382445404	admindb	Neuer Schritt		new step	HttpTranslate	\N
1353051989	admindb	1382445411	admindb	aktueller Tag		current day	HttpTranslate	\N
1353051996	admindb	1382439342	admindb	Bitte die Temperatur angeben		please give a temperature	HttpTranslate	\N
1353051996	admindb	1382445455	admindb	Bitte die Zeiteingaben Bautagebuch ??berpr??fen		please check the time items of the builddiary	HttpTranslate	\N
1353051996	admindb	1382445533	admindb	Zeiteintrag:		time item:	HttpTranslate	\N
1353052042	admindb	1382445538	admindb	Beginn		start	HttpTranslate	\N
1353052042	admindb	1382445543	admindb	Ende		end	HttpTranslate	\N
1353052042	admindb	1382445554	admindb	Monatsauswahl		month select	HttpTranslate	\N
1353052042	admindb	1382445562	admindb	Aktueller Monat		actual month	HttpTranslate	\N
1353052042	admindb	1382445618	admindb	Sebtember	September	september	HttpTranslate	\N
1353052042	admindb	1382445625	admindb	Andere Zeit		other time	HttpTranslate	\N
1353052042	admindb	1382445630	admindb	meine Zeiten		my time	HttpTranslate	\N
1353052679	admindb	1382445638	admindb	keine Firma		no company	DbQuery	\N
1353053104	admindb	1382445647	admindb	Bautagebuch drucken		print builddiary	HttpTranslate	\N
1353053157	admindb	1382445653	admindb	wichtig		important	HttpTranslate	\N
1353053157	admindb	1382445659	admindb	Komentar		comment	HttpTranslate	\N
1353321718	admindb	1382445670	admindb	Kann Datei %s/%s nicht finden		cant find file %s/%s	Http	\N
1353336360	admindb	1382445678	admindb	Teil hinzuf??gen		add part	HttpTranslate	\N
1353336360	admindb	1382445686	admindb	Teil bearbeiten		modify part	HttpTranslate	\N
1353414079	admindb	1382445735	admindb	Sql Kommando ausf??hren		execute sql command	HttpTranslate	\N
1353414079	admindb	1382445739	admindb	Start		start	HttpTranslate	\N
1353414079	admindb	1382445744	admindb	Ergebnis		result	HttpTranslate	\N
1353421861	admindb	1382445771	admindb	Benutzer wirklich l??schen		really delete user	HttpTranslate	\N
1353421861	admindb	1382445777	admindb	gel??scht		deleted	HttpTranslate	\N
1353422172	admindb	1382445797	admindb	Men??eintrag hinzuf??gen		add menu item	HttpTranslate	\N
1353422172	admindb	1382445807	admindb	Men??eintrag bearbeiten		modify menu item	HttpTranslate	\N
1353422734	admindb	1382445816	admindb	Element hinzuf??gen		add element	HttpTranslate	\N
1353422734	admindb	1382445823	admindb	Element bearbeiten		modify element	HttpTranslate	\N
1353478666	admindb	1382445831	admindb	Primary Key hinzuf??gen		add primary key	HttpTranslate	\N
1353478666	admindb	1382445841	admindb	Primary Key bearbeiten		modify primary key	HttpTranslate	\N
1353484291	admindb	1382445851	admindb	Rechnung hinzuf??gen		add invoice	HttpTranslate	\N
1353484291	admindb	1382445866	admindb	Rechnung bearbeiten		modify invoice	HttpTranslate	\N
1353484291	admindb	1382445872	admindb	Rechnung 		invoice	HttpTranslate	\N
1353484291	admindb	1382445912	admindb	Bitte Rechnungstext ausw??hlen		please select invoice text	HttpTranslate	\N
1353484291	admindb	1382445928	admindb	1. Mahnung		first reminder	HttpTranslate	\N
1353484291	admindb	1382445936	admindb	2. Mahnung		second reminder	HttpTranslate	\N
1353484291	admindb	1382445945	admindb	3. Mahnung		third reminder	HttpTranslate	\N
1353484291	admindb	1382445962	admindb	Bezahlt		paid	HttpTranslate	\N
1353484291	admindb	1382445968	admindb	Versenden		send	HttpTranslate	\N
1353484291	admindb	1382445974	admindb	Tage		days	HttpTranslate	\N
1353484291	admindb	1382446014	admindb	nicht gestellt		not posed	DbQuery	\N
1353484291	admindb	1382446020	admindb	gestellt		posed	DbQuery	\N
1353484291	admindb	1382446027	admindb	bezahlt		paid	DbQuery	\N
1353484291	admindb	1382446034	admindb	Rechnungsnr.		invoice number	DbQuery	\N
1353492218	admindb	1382446059	admindb	kann datei <%s> nicht finden		can not find file <%s>	HttpSearchPath	\N
1353499223	admindb	1382446064	admindb	Person		person	DbQuery	\N
1353499223	admindb	1382446074	admindb	Brief 		letter	HttpTranslate	\N
1353499223	admindb	1382446154	admindb	Brief ist versendet worden - als neuen Brief speichern ?		letter is sended - save as a new letter ?	HttpTranslate	\N
1353499223	admindb	1382446190	admindb	Fehler w??hrend des Druckens gefunden		error during printing	HttpTranslate	\N
1353499225	admindb	1382446196	admindb	Editor		editor	HttpTranslate	\N
1353591454	admindb	1382446205	admindb	Preis wirklich l??schen		delete price	HttpTranslate	\N
1354009417	admindb	1382446225	admindb	Der Report <%s> hat keine Zeilen		the report <%s> has no rows	DbHttpReport	\N
1354012211	admindb	1382446507	admindb	Kein Lieferant		no vendor	DbQuery	\N
1354010851	admindb	1382446314	admindb	Sehr geehrte Frau 		dear Madam	DbQuery	\N
1354010851	admindb	1382446363	admindb	Sehr geehrter Herr 		Dear Sir	DbQuery	\N
1354012250	admindb	1382446535	admindb	keine Bestellnummer		no purchase number	DbQuery	\N
1354012276	admindb	1382446547	admindb	Teil zu einer Bestellung hinzuf??gen		add part to a purchase	HttpTranslate	\N
1354012276	admindb	1382446580	admindb	Soll die Bestellung jetzt versendet werden ?		send the purchase now ?	HttpTranslate	\N
1354012276	admindb	1382446602	admindb	Der Auftrag ben??tig dieses Teil nicht		the order do not need this part	HttpTranslate	\N
1354012276	admindb	1382446612	admindb	Einzeldruck		single print	HttpTranslate	\N
1354012276	admindb	1382446620	admindb	Einzeln versenden		send single	HttpTranslate	\N
1354012276	admindb	1382446627	admindb	kein Lieferant		no vendor	DbQuery	\N
1354012276	admindb	1382446653	admindb	gesamt		total	DbQuery	\N
1354012962	admindb	1382446663	admindb	Lieferschein hinzuf??gen		add delivery note	HttpTranslate	\N
1354012962	admindb	1382446680	admindb	Keine Lieferschein ausgew??hlt		no delivery note selected	HttpTranslate	\N
1354012962	admindb	1382446686	admindb	Rechnung		invoice	HttpTranslate	\N
1354012992	admindb	1382446698	admindb	Ihr Anteil Total		your part total	HttpTranslate	\N
1354027830	admindb	1382446708	admindb	neuer Foreign Key		new foreign key	HttpTranslate	\N
1354027830	admindb	1382446728	admindb	Foreign Key 		foreign key	HttpTranslate	\N
1322639565	admindb	1322641381	admindb	Letze Abfrage:		last query	DbHttpUtilsTable	\N
1322640867	admindb	1322641393	admindb	Sonntag		sunday	HttpTranslate	\N
1322640867	admindb	1322641452	admindb	Bitte mindestens ein Zeichen eingeben		input one or more character	HttpTranslate	\N
1322640867	admindb	1322641628	admindb	Wirklich L??schen		delete real	HttpTranslate	\N
1322640867	admindb	1322641904	admindb	Element 		element	HttpTranslate	\N
1322640867	admindb	1322642085	admindb	Labelobjekt 		label object	HttpTranslate	\N
1322640867	admindb	1322641530	admindb	M??gliche Werte von: 		posible values of:	HttpTranslate	\N
1322640868	admindb	1322642100	admindb	Id Parameter 		id parameter	HttpTranslate	\N
1322640868	admindb	1322642184	admindb	Objekt f??r name 		object for name	HttpTranslate	\N
1108988430	admindb	1109079523	admindb	Keine Referenz ausgew??hlt		no referenz selected	Http	\N
1358258919	admindb	1382441600	admindb	Kein Lager		no stock	DbQuery	\N
1358246660	admindb	1382441502	admindb	Lagerplatz hinzuf??gen		add bin location	HttpTranslate	\N
1358253456	admindb	1382441579	admindb	Lager unbekannt		unknown stock	HttpTranslate	\N
1358246656	admindb	1382441593	admindb	Lager bearbeiten		modify stock	HttpTranslate	\N
1358258918	admindb	1382441606	admindb	Alle Lager		all stocks	DbQuery	\N
1354112501	admindb	1382446757	admindb	Es wurden schon Zeiten zu diesem Auftrag erfasst		there are time items recorded to this order	DbConnect	\N
1354281338	admindb	1382446764	admindb	neuer Join		new join	HttpTranslate	\N
1354281338	admindb	1382446772	admindb	Join bearbeiten		modify join	HttpTranslate	\N
1354281338	admindb	1382446778	admindb	erste Tabelle		first table	HttpTranslate	\N
1354281338	admindb	1382446784	admindb	zweite Tabelle		second table	HttpTranslate	\N
1355222007	admindb	1382446805	admindb	alle Gruppen		all groups	HttpTranslate	\N
1355222007	admindb	1382446813	admindb	Gruppenzugeh??rigkeit		member of group	HttpTranslate	\N
1355307329	admindb	1382446822	admindb	Password bearbeiten		modify password	HttpTranslate	\N
1355307329	admindb	1382446840	admindb	Passworte sind nicht gleich		passwords are different	HttpTranslate	\N
1355307347	admindb	1382446858	admindb	Benutzereinstellungen hinzuf??gen		add user settings	HttpTranslate	\N
1098345264	admindb	1098776666	admindb	Berechtigungen		access	Http	\N
1355307347	admindb	1382446867	admindb	Bitte Benutzer ausw??hlen		modify user settings	HttpTranslate	\N
1355307408	admindb	1382446894	admindb	geerbte Adresse		inherited adress	HttpTranslate	\N
1355307408	admindb	1382446900	admindb	eigene Adresse		own adress	HttpTranslate	\N
1355307408	admindb	1382446907	admindb	Kontakt hinzuf??gen		add contact	HttpTranslate	\N
1355307408	admindb	1382446914	admindb	Kontakt bearbeiten		modify contact	HttpTranslate	\N
1355307408	admindb	1382446919	admindb	Kontakt 		contact	HttpTranslate	\N
1355307422	admindb	1382446938	admindb	Personendaten bearbeiten		modify personnal data	HttpTranslate	\N
1358244340	admindb	1382446949	admindb	1.Mahnung		first reminder	DbQuery	\N
1358244340	admindb	1382446957	admindb	2.Mahnung		second reminder	DbQuery	\N
1358244340	admindb	1382446965	admindb	3.Mahnung		third reminder	DbQuery	\N
1358244340	admindb	1382447039	admindb	Vorschau Rechnungslauf		preview invoice run	HttpTranslate	\N
1358244340	admindb	1382447046	admindb	Neuer Rechnungslauf		new invoice run	HttpTranslate	\N
1358244342	admindb	1382447060	admindb	Es besteht keine Verbindung zur Datenbank		no connection to the database	Database	\N
1358522811	admindb	1382447098	admindb	Bitte 6 Hexadezimalziffern eingeben		please enter 6 hex digits	DbHttpAdminTable	\N
1113204273	admindb	1113205883	admindb	Kontakte		contacts	Http	\N
1358522872	admindb	1382447134	admindb	adezimalziffern eingeben	Hexadezimalziffer eingeben	enter a hex digit	DbHttpAdminTable	\N
1358522876	admindb	1382447139	admindb	 eingeben		enter	DbHttpAdminTable	\N
1358763543	admindb	1382447163	admindb	Konto anzeigen		show account	HttpTranslate	\N
1358763543	admindb	1382447228	admindb	Quitieren	Quittieren	accept	HttpTranslate	\N
1358763543	admindb	1382447256	admindb	Zuordnen		assign	HttpTranslate	\N
1358772802	admindb	1382447262	admindb	Heute		today	HttpTranslate	\N
1358245346	admindb	1382447317	admindb	Der Autoreport <%s> hat keine Zeilen		the report <%s> has no rows	DbHttpReport	\N
1358245549	admindb	1382447629	admindb	Rechnungskonditionen hinzuf??gen		add incoive terms	HttpTranslate	\N
1358245549	admindb	1382447638	admindb	Rechnungskonditionen bearbeiten		modify invoice terms	HttpTranslate	\N
1358245549	admindb	1382447644	admindb	Rechnungskonditionen 		invoice terms	HttpTranslate	\N
1358245549	admindb	1382447661	admindb	Individuell		individually	HttpTranslate	\N
1358245549	admindb	1382447702	admindb	Standarttexte k??nnen nicht gel??scht werden		standard texts can not deleted	HttpTranslate	\N
1358253963	admindb	1382447708	admindb	Lieferanten hinzuf??gen		add vendor	HttpTranslate	\N
1358253963	admindb	1382447713	admindb	Lieferanten bearbeiten		modify vendor	HttpTranslate	\N
1358258918	admindb	1382447754	admindb	Lieferung hinzuf??gen		add shipment	HttpTranslate	\N
1358258918	admindb	1382447763	admindb	Lieferung bearbeiten		modify shipment	HttpTranslate	\N
1358258974	admindb	1382447770	admindb	Rechung hinzuf??gen		add invoice	HttpTranslate	\N
1358258974	admindb	1382447778	admindb	Bezahlen		pay	HttpTranslate	\N
1358315997	admindb	1382447817	admindb	Bitte eine Jahreszahl eingeben		please enter a year	HttpTranslate	\N
1358315997	admindb	1382447864	admindb	Bearbeiter hinzuf??gen		add issuer	HttpTranslate	\N
1358315997	admindb	1382447893	admindb	Zeitplanung bearbeiten		modify time planning	HttpTranslate	\N
1358315997	admindb	1382447907	admindb	Bitte Arbeitsschritt ausw??hlen		please select a working step	HttpTranslate	\N
1358315997	admindb	1382447915	admindb	alle Personen		all persons	HttpTranslate	\N
1358315997	admindb	1382447941	admindb	Bereinigen		purge	HttpTranslate	\N
1322640868	admindb	1322642171	admindb	MneAjaxWeblet:getIdparam ist nur im Modifymodus erlaubt		MneAjaxWeblet:getIdparam is only allowed during modify	HttpTranslate	\N
1322640868	admindb	1322642196	admindb	keine Buttonaktion f??r 		no button action for	HttpTranslate	\N
1124284460	admindb	1152881754	admindb	Briefe		letter	Http	\N
1245403011	admindb	1305880971	admindb	Aktualisieren		refresh	HttpTranslate	\N
1100785141	admindb	1101396579	admindb	Addressen		addresses		\N
1131177093	admindb	1131980194	admindb	Produkt Hinzuf??gen		add product	Http	\N
1131971753	admindb	1131980205	admindb	Verschieben		move	Http	\N
1131636583	admindb	1131980223	admindb	gr??sser		greater	Http	\N
1131366207	admindb	1132146085	admindb	Dokumentation		documentation		\N
1131636583	admindb	1131980229	admindb	kleiner		lower	Http	\N
1131177093	admindb	1131980252	admindb	Produkt L??schen		delete product	Http	\N
1131177093	admindb	1131980268	admindb	Produkt <$1> wirklich l??schen ?		delete product <$1> ?	Http	\N
1131636637	admindb	1131980277	admindb	Parameter		parameter	Http	\N
1131977900	admindb	1132143553	admindb	Verzeichnis umbenennen		rename folder	Http	\N
1132145067	admindb	1132145067	admindb	Edidieren		edit		\N
1133794528	admindb	1133794580	admindb	keine Funktion <$1setTreeparams> vorhanden		no function <$1setTreeparams> avaible	Http	\N
1135005792	admindb	1135012585	admindb	Summe	Summe	amount		\N
1132592779	admindb	1135341530	admindb	Brief <$1> wirklich l??schen ?		delete letter <$1> ?	Http	\N
1130508768	admindb	1135341626	admindb	Dienstag		tuesday	Http	\N
1134909535	admindb	1135341631	admindb	Gruppieren		group	Http	\N
1144758970	admindb	1144830709	admindb	Order		order	Http	\N
1131366484	admindb	1135341665	admindb	Referenzmanual L??schen		delete referenz manual ?	Http	\N
1124719750	admindb	1126180620	admindb	Brief <$1/$2/$3> wirklich l??schen ?		delete letter <$1/$2/$3> ?	Http	\N
1098109177	admindb	1098114075	admindb	Operator		operator	Http	\N
1098112255	admindb	1098114093	admindb	Sicht l??schen		delete view	Http	\N
1098112255	admindb	1098114109	admindb	zeige Joins		show join	Http	\N
1098112255	admindb	1098114249	admindb	Bitte Eingabefeld ausw??hlen		select input field	Http	\N
1098112255	admindb	1098114274	admindb	Bitte eine Zeile ausw??hlen		select a row	Http	\N
1098112255	admindb	1098114286	admindb	Select		select	Http	\N
1098112255	admindb	1098114307	admindb	neue Zeile		new row	Http	\N
1098114027	admindb	1098114337	admindb	f??r Sql-Befehl		for sql statement	DbConn	\N
1098171178	admindb	1098176429	admindb	wahr		true		\N
1098116843	admindb	1098176447	admindb	l??schen		delete	Http	\N
1098283406	admindb	1098776616	admindb	alle		all		\N
1101401559	admindb	1102329015	admindb	Ergebnis der Abfrage im Weblet <$1> hat mehr als ein Ergebnis		query result in weblet <$1> has more than one row	Http	\N
1101909975	admindb	1102329069	admindb	Ortschaft gel??scht		city deleted	Http	\N
1101402530	admindb	1102329086	admindb	Land <$1> wirklich l??schen ?		delete country <$1> ?	Http	\N
1101909377	admindb	1102329095	admindb	Ortschaften		Citys	Http	\N
1101905614	admindb	1102329111	admindb	Notiz: %s		notice: %s	DbConnect	\N
1101822659	admindb	1102329128	admindb	Konnte mich nicht zur Datenbank %s verbinden		can't connect to database %s	DbConnect	\N
1101909975	admindb	1102329136	admindb	neue Ortschaft		new city	Http	\N
1102501059	admindb	1102517158	admindb	gleich		equal	Http	\N
1102501059	admindb	1102517169	admindb	beinhaltet		contains	Http	\N
1102512917	admindb	1102517189	admindb	endet		ends	Http	\N
1102501399	admindb	1102517197	admindb	suchen		search	Http	\N
1102348793	admindb	1102517203	admindb	Neu		new	Http	\N
1102517377	admindb	1102517398	admindb	ungleich		not equal	Http	\N
1102517377	admindb	1102517408	admindb	beginnt mit		starts with	Http	\N
1102517377	admindb	1102517416	admindb	endet mit		ends with	Http	\N
1102517377	admindb	1102517427	admindb	Weblet <$1> nicht gefunden		weblet <$1> not found	Http	\N
1132146085	admindb	1132146085	admindb	Referenzen		references		\N
1102612907	admindb	1106131846	admindb	Ortschaft		city	Http	\N
1103018793	admindb	1106131898	admindb	englisch		english	Http	\N
1105971658	admindb	1106131955	admindb	Zum Join von Tabelle %s werden Spalten- und Operatorangaben ben??tigt		joining the table %s needs columnnames and operators	PgJoin	\N
1102612907	admindb	1106131970	admindb	Addresse gel??scht		address deleted	Http	\N
1103630492	admindb	1106138388	admindb	Kommando %s konnte nicht ausgef??hrt werden		comand %s can't be executed	Http	\N
1103561233	admindb	1106138623	admindb	Tabelle ist unbekannt und kann nicht freigegeben werden		table unknown and can't be released	Database	\N
1102613385	admindb	1106138648	admindb	Addresse bearbeiten		modify address	Http	\N
1109175614	admindb	1109848194	admindb	Person hat kein Elternobjekt		person has no parent	Http	\N
1098088863	admindb	1098091245	admindb	Daten		data	Http	\N
1097767924	admindb	1097768033	admindb	Null		null		\N
1305880369	admindb	1305880408	admindb	hinzuf??gen/??ndern		add/modify	HttpTranslate	\N
1108117495	admindb	1108978543	admindb	Beschriftung		label	Http	\N
1107970021	admindb	1108978553	admindb	Kein Weblet ausgew??hlt		no weblet selected	Http	\N
1108464818	admindb	1108978574	admindb	Foreign Keys		foreign keys	Http	\N
1107961232	admindb	1108978582	admindb	Modifizieren		modify	Http	\N
1108373074	admindb	1108978602	admindb	Ausdruck		expression		\N
1108637777	admindb	1108978644	admindb	Auswahlliste <$1> konnte nicht gefunden werden		select list <$1> not found	Http	\N
1107970021	admindb	1108978659	admindb	Weblet <$1> wirklich l??schen ?		delete weblet <$1> ?	Http	\N
1108978135	admindb	1108978669	admindb	abbrechen		cancel	Http	\N
1108117495	admindb	1108978684	admindb	Keine Maske ausgew??hlt		no screen selected	Http	\N
1100619107	admindb	1108978694	admindb	%s	%s	%s	DbConnect	\N
1106923199	admindb	1108978707	admindb	%s: %s	%s: %s	%s: %s	Http	\N
1103021526	admindb	1109060058	admindb	Tabelle <%s> oder Spalte <%s> beim addieren zum Selektieren nicht vorhanden		table <%s> or column <%s> not avaible during adding for select	DbHttpAdminView	\N
1108989835	admindb	1109079534	admindb	Person bearbeiten		modify person	Http	\N
1108744800	admindb	1226562738	admindb	Ortschaft hinzuf??gen		add city	Http	\N
1108988430	admindb	1109079560	admindb	Kein Person ausgew??hlt		no person selected	Http	\N
1109063904	admindb	1109079576	admindb	Konstante		constant	Http	\N
1097767924	admindb	1097768013	admindb	Wert		value		\N
1127314659	admindb	1152881882	admindb	Kunden		customer		\N
1136478095	admindb	1153736806	admindb	Sehr geehrte Frau		Dear Mrs.		\N
1162301259	admindb	1162301363	admindb	Lagerverwaltung		warehouse management		\N
1162301259	admindb	1162301363	admindb	Artikel		article		\N
1131112961	admindb	1169131807	admindb	Produkte		products		\N
1137752653	admindb	1169131887	admindb	Auftr??ge		orders		\N
1222161495	admindb	1222161495	admindb	Datenbank	Datenbank	database	HttpMenu	\N
1222161554	admindb	1222161554	admindb	Abfragen	Abfragen	querys	HttpMenu	\N
1222161578	admindb	1222161578	admindb	Prozeduren	Prozeduren	procedures	HttpMenu	\N
1222161599	admindb	1222161599	admindb	Weblets	Weblets	weblets	HttpMenu	\N
1237488730	admindb	1237488730	admindb	Extras		extras		\N
1237488817	admindb	1237488817	admindb	Angebote		offer's		\N
1237477477	admindb	1237489464	admindb	Ausliefern	Ausliefern	shipment	HttpTranslate	\N
1108744800	admindb	1226562746	admindb	Ortschaft l??schen		delete city	Http	\N
1108713406	admindb	1226582622	admindb	Land hinzuf??gen		add country	Http	\N
1108713406	admindb	1226582641	admindb	Land l??schen		delete country	Http	\N
1245357732	admindb	1245357763	admindb	Vorschau		preview	HttpTranslate	\N
1245357732	admindb	1245357782	admindb	Wert f??r 		value for	HttpTranslate	\N
1245398289	admindb	1245398316	admindb	Rechnungsl??ufe		invoice treatments		\N
1131177093	admindb	1131980151	admindb	Produkt bearbeiten		edit product	Http	\N
1131177093	admindb	1131980171	admindb	neues Produkt		new Product	Http	\N
1131891748	admindb	1131980179	admindb	Neues Verzeichnis		new folder	Http	\N
1147270767	admindb	1147792111	admindb	Lieferschein bearbeiten		modify delivery note	Http	\N
1145624078	admindb	1147792163	admindb	Angebot		offer	Http	\N
1131976499	admindb	1131980187	admindb	Verzeichnis l??schen		delete folder	Http	\N
1109781760	admindb	1109848249	admindb	neue Person		new person	Http	\N
1109175614	admindb	1109848169	admindb	Person hat schon geerbte Addresse		person has allready the parent adress	Http	\N
1099298078	admindb	1099300550	admindb	Anzeigenid		displayid	Http	\N
1099298387	admindb	1099300562	admindb	Spalte/Wert		row/value	Http	\N
1097767924	admindb	1098180145	admindb	Default		default		\N
1098180898	admindb	1098180968	admindb	Sicht <$1> wirklich l??schen ?		delete view <$1> ?	Http	\N
1098181060	admindb	1098776576	admindb	Ben??tige einen Namen zum Editieren einer Sicht		need a name for editing a view	DbHttp	\N
1098277674	admindb	1098776587	admindb	Schemas		schemas		\N
1098281216	admindb	1098776605	admindb	unbekannt		unknown		\N
1098283406	admindb	1098776631	admindb	lesen		read		\N
1098283406	admindb	1098776642	admindb	schreiben		write		\N
1098346225	admindb	1098776677	admindb	alles		all		\N
1098347052	admindb	1098776718	admindb	Schema <$1> mit gesammten Inhalt wirklich l??schen ?		delete schema <$1> with all contents ?	Http	\N
1098347052	admindb	1098776732	admindb	Schema gel??scht		schema deleted	Http	\N
1098347851	admindb	1098776760	admindb	kein Schema gew??hlt		no schema selected	Http	\N
1098350497	admindb	1098776774	admindb	Bitte einen Benutzer ausw??hlen		please select a user	Http	\N
1098719038	admindb	1098776827	admindb	1.Tabelle		first table	Http	\N
1098719038	admindb	1098776838	admindb	2.Tabelle		second table	Http	\N
1098797157	admindb	1098890786	admindb	Kein Tabellenname beim addieren einer Spalte vorhanden		no table name during adding a Row	PgTabl	\N
1098797332	admindb	1098890831	admindb	kann Tabelle %s nicht erzeugen - Tabelle existiert		unable to create table %s - table exist	PgTabl	\N
1098807168	admindb	1098891594	admindb	Neue Tabelle		new table	Http	\N
1098807283	admindb	1098891616	admindb	keine Tabelle ausgew??hlt		no table selected	Http	\N
1107875406	admindb	1107958486	admindb	neues Weblet		new weblet	Http	\N
1107786488	admindb	1107958494	admindb	Maske Hinzuf??gen		new screen	Http	\N
1110286355	admindb	1110286934	admindb	Datumsformat		date format		\N
1098718132	admindb	1110286945	admindb	Sprache		language		\N
1146834409	admindb	1152522697	admindb	Rechnungen		invoices		\N
1119606751	admindb	1119876073	admindb	Kein Indexname beim Erzeugen des Indexes vorhanden		no index name during make a index	PgIndex	\N
1098102416	admindb	1098103682	admindb	Zeile l??schen		delete row	Http	\N
1099485640	admindb	1099995774	admindb	weiter		next	Http	\N
1115990016	admindb	1119876130	admindb	Spalte %s ist in der Tabelle %s beim Modifizieren nicht forhanden		column %s not availble during modify table %s	PgTable	\N
1118750440	admindb	1119876157	admindb	kann datei %s nicht finden		can't find file %s	ReportText	\N
1119876006	admindb	1119876182	admindb	Report %s nicht vorhanden		report %s not availble	ReportText	\N
1118750439	admindb	1119876201	admindb	%s ist keinen Zeichenkettenargument		%s is not a character argument	Argument	\N
1115791869	admindb	1119876209	admindb	History		history	Http	\N
1103019431	admindb	1124111912	admindb	mne_langid	de	en	Http	\N
1126013479	admindb	1126180314	admindb	Html Element		html element	Http	\N
1126110580	admindb	1126180336	admindb	Spaltenanzahl vom Index <%s> ist ungleich 1		column count from index <%s> is not 1	DbHttpAdminTable	\N
1126013479	admindb	1126180343	admindb	Breite		width	Http	\N
1107010992	admindb	1107958151	admindb	Men??punkt Hinzuf??gen		add menu entry	Http	\N
1124705198	admindb	1126180418	admindb	Ausgabe konnte wegen Fehlern im XML nicht erzeugt werden		output can't be generated during error in XML code	XmlParse	\N
1124976852	admindb	1126180489	admindb	Datenvektor gr??sser als 1! Rest wird ignoriert		result vector greater tham 1! overflow ignored	Http	\N
1124282548	admindb	1126180495	admindb	sichern		save	Http	\N
1124705198	admindb	1126180510	admindb	Das Element <%s> besitzt keinen Endtag		element <%s> has no end tag	XmlParse	\N
1124986145	admindb	1126180530	admindb	kann DbViewCreator nicht finden		can't find DbViewCreator	Database	\N
1124284460	admindb	1126180537	admindb	neuer Brief		new letter	Http	\N
1124289437	admindb	1126180560	admindb	Brief bearbeiten		modify letter	Http	\N
1119963834	admindb	1126180568	admindb	Firmen Briefe		company letter		\N
1098103404	admindb	1098103806	admindb	Neuer Index		new index	Http	\N
1130508768	admindb	1135341691	admindb	Mi		we	Http	\N
1130508768	admindb	1135341697	admindb	Montag		monday	Http	\N
1132145094	admindb	1135341710	admindb	Kann Spalte %s nicht finden		can't find column %s	DbHttpUtilsTable	\N
1130508768	admindb	1135341716	admindb	Januar		januar	Http	\N
1131987244	admindb	1135341727	admindb	Cancel	Abbrechen	cancel	Http	\N
1098087728	admindb	1098087767	admindb	neuer Benutzer		new User	Http	\N
1146205954	admindb	1147792409	admindb	Lieferung		delivery	Http	\N
1144760166	admindb	1144830784	admindb	Auftrag bearbeiten		modify order	Http	\N
1137407106	admindb	1137407690	admindb	<%s> kann nicht ??bersetzt werden		can't translate <%s>	DbView	\N
1124889063	admindb	1137413267	admindb	Der Typ %d von Spalte %s ist unbekannt		type %d from column %s is unknown	DbConnect	\N
1137767766	admindb	1144830664	admindb	Sql Prozeduren		sql procedures	Http	\N
1140187772	admindb	1144830671	admindb	Sql Prozedur		sql procedure	Http	\N
1140187772	admindb	1144830680	admindb	Prozedur 		procedure	Http	\N
1140187772	admindb	1144830687	admindb	Berechtigung		access	Http	\N
1144760166	admindb	1144830741	admindb	neue Auftrag		new order	Http	\N
1144760166	admindb	1144830763	admindb	Auftrag <$1> wirklich l??schen ?		delete order <$1> ?	Http	\N
1144760166	admindb	1144830770	admindb	Auftrag Hinzuf??gen		add order	Http	\N
1144760166	admindb	1144830776	admindb	Auftrag L??schen		delete order	Http	\N
1144832805	admindb	1144845933	admindb	Preise setzen		fix price	Http	\N
1144846164	admindb	1144846232	admindb	Preise wirklich ??berschreiben		overwrite own prices	Http	\N
1146834409	admindb	1147269273	admindb	Lieferscheine		delivery notes		\N
1147791158	admindb	1147791241	admindb	Entwurf		draft	Http	\N
1147421744	admindb	1147791399	admindb	Nr.		No.	Http	\N
1130508768	admindb	1135341739	admindb	Juli		july	Http	\N
1134061334	admindb	1135341748	admindb	Kopieren		copy	Http	\N
1132592779	admindb	1135341753	admindb	Brief Hinzuf??gen		add letter	Http	\N
1132057219	admindb	1135341759	admindb	Administrator		adminstrator	Http	\N
1134745899	admindb	1135341773	admindb	Eintrag wirklich l??schen ?		delete content ?	Http	\N
1130508768	admindb	1135341816	admindb	Di		tu	Http	\N
1130508768	admindb	1135341833	admindb	M??rz		march	Http	\N
1130508768	admindb	1135341850	admindb	Samstag		saturday	Http	\N
1132060665	admindb	1135341858	admindb	Preis bearbeiten		edit price	Http	\N
1130508768	admindb	1135341869	admindb	Oktober		october	Http	\N
1131366484	admindb	1135341880	admindb	Referenzmanual bearbeiten		edit referenz manual	Http	\N
1130508768	admindb	1135341898	admindb	Freitag		friday	Http	\N
1130775179	admindb	1135341911	admindb	Jahre		Years	Http	\N
1144931205	admindb	1147792169	admindb	Auftrag		order	Http	\N
1101401125	admindb	1131108282	admindb	abschliessen		close transaction		\N
1146206236	admindb	1147792271	admindb	Keine Produkte zur Auslieferung fertig		no products for delivery ready		\N
1145113099	admindb	1147792286	admindb	unbekannter Typ		unknown typ		\N
1146839097	admindb	1147792309	admindb	Lieferschein		delivery note	Http	\N
1144930138	admindb	1147792314	admindb	Gesammt		all	Http	\N
1097767924	admindb	1097768042	admindb	Gr??sse		size		\N
1145623792	admindb	1147792354	admindb	Auftragsbest??tigung		confirmation	Http	\N
1145522270	admindb	1147792360	admindb	Einmalig		single	Http	\N
1147270767	admindb	1147792381	admindb	Lieferschein <$1> wirklich l??schen ?		delete delivery not <$1> ?	Http	\N
1147860594	admindb	1147864283	admindb	??ndern		modify		\N
1147860594	admindb	1147864288	admindb	einf??gen		insert		\N
1147860666	admindb	1147864295	admindb	spezial		special	Http	\N
1098116259	admindb	1151930165	admindb	Tabellen		tables		\N
1098116259	admindb	1151930166	admindb	Inhalte		contents		\N
1131108243	admindb	1152881754	admindb	Auswahllisten		select lists		\N
1106657190	admindb	1106754100	admindb	Firma Hinzuf??gen		add company	Http	\N
1106658932	admindb	1106754137	admindb	Ergebnis der Abfrage im Weblet <$1> hat kein Ergebnis		result of the query in weblet <$1> has no result	Http	\N
1106573353	admindb	1106754151	admindb	Firma wirklich l??schen ?		delete company ?	Http	\N
1106573353	admindb	1106754167	admindb	Firma bearbeiten		modify company	Http	\N
1106573353	admindb	1106754177	admindb	neue Firma		new company	Http	\N
1106754220	admindb	1106754344	admindb	Firma L??schen		delete company	Http	\N
1106754220	admindb	1106754383	admindb	Kann Element <$1:$2> nicht lesen		can't read element<$1:$2>	Http	\N
1098103403	admindb	1098103713	admindb	Tabelle gel??scht		table deleted	Http	\N
1100158138	admindb	1100158252	admindb	Name <%s> ist unbenannt		name <%s> is unknown	DbHtml	\N
1106754422	admindb	1106754450	admindb	Kann Element <$1:$2> nicht vorbesetzen		can't preset element <$1:$2>	Http	\N
1106754220	admindb	1107269039	admindb	Element mit id <$1> ist unbekannt		element with id <$1> is unknown	Http	\N
1107782479	admindb	1107782604	admindb	screen		screen		\N
1106850234	admindb	1107783033	admindb	Men??s		menu		\N
1097767982	admindb	1107783046	admindb	Sichten		views		\N
1098116259	admindb	1107783051	admindb	Joins		joins		\N
1098116259	admindb	1107783062	admindb	Definitionen		definition		\N
1107788788	admindb	1107788788	admindb	testt		test		\N
1107782574	admindb	1107788851	admindb	test		test		\N
1106850700	admindb	1107789659	admindb	Masken		screen		\N
1107853262	admindb	1107958060	admindb	Ausgabetabelle <$1> nicht gefunden		output table <$1> not found	Http	\N
1107786488	admindb	1107958134	admindb	Maske L??schen		delete screen	Http	\N
1107873898	admindb	1107958171	admindb	Weblet bearbeiten		modify weblet	Http	\N
1107875592	admindb	1107958177	admindb	Schliessen		close	Http	\N
1106923199	admindb	1107958195	admindb	Browser		brouwser		\N
1106923200	admindb	1107958209	admindb	Version		version		\N
1107786488	admindb	1107958218	admindb	Maske bearbeiten		modify screen	Http	\N
1106923199	admindb	1107958227	admindb	Type	Typ	type		\N
1107263677	admindb	1107958256	admindb	Tabellenname kann nicht von %s.%s zu %s.%s ver??ndert werden		can't change table name from %s.%s to %s.%s	PgTable	\N
1106923199	admindb	1107958269	admindb	Filename	Dateiname	file name		\N
1107010992	admindb	1107958290	admindb	neuer Men??punkt		add menu entry	Http	\N
1132317535	admindb	1135341934	admindb	Alter style in data f??r %s.old		old style for %s.old in data	DbHttpUtilsView	\N
1130508768	admindb	1135341956	admindb	Donnerstag		thursday	Http	\N
1134137308	admindb	1135341964	admindb	Brief nicht gefunden		letter not found	Http	\N
1132060665	admindb	1135341979	admindb	Produktpreis		product price	Http	\N
1135261058	admindb	1135341993	admindb	Ok 		ok	Http	\N
1130508768	admindb	1135342026	admindb	November		november	Http	\N
1130769967	admindb	1135342095	admindb	kann Zeit nur bei Monaten berechnen		comupte time only available for month	Http	\N
1130508768	admindb	1135342100	admindb	Do		th	Http	\N
1130508768	admindb	1135342102	admindb	Fr		fr	Http	\N
1131366484	admindb	1135342115	admindb	neue Referenzmanual		new referenz manual	Http	\N
1130508768	admindb	1135342120	admindb	Juni		june	Http	\N
1130508768	admindb	1135342127	admindb	Sa		Sa	Http	\N
1130508768	admindb	1135342136	admindb	So		so	Http	\N
1134655324	admindb	1135342141	admindb	Format		format	Http	\N
1130508768	admindb	1135342147	admindb	April		april	Http	\N
1131366484	admindb	1135342157	admindb	Referenzmanual Hinzuf??gen		add referenz manual	Http	\N
1132592779	admindb	1135342163	admindb	Brief L??schen		delete letter	Http	\N
1130508768	admindb	1135342169	admindb	Dezember		december	Http	\N
1130508768	admindb	1135342177	admindb	September		september	Http	\N
1130508768	admindb	1135342186	admindb	Mittwoch		wendsday	Http	\N
1130508768	admindb	1135342191	admindb	Mo		mo	Http	\N
1131366484	admindb	1135342217	admindb	Referenzmanual <$1> wirklich l??schen ?		delete referenz manual <$1> ?	Http	\N
1130508768	admindb	1135342223	admindb	Sontag		sonday	Http	\N
1130508768	admindb	1135342251	admindb	Februar		february	Http	\N
1130775179	admindb	1135342259	admindb	Monate		mounths	Http	\N
1136196328	admindb	1136802679	admindb	f??r		for	Http	\N
1136737357	admindb	1136737608	admindb	Sehr geehrte Damen und Herren		Dear Sir or Madam	Http	\N
1136802223	admindb	1136802593	admindb	Preis		price	Http	\N
1136802558	admindb	1136802667	admindb	Gesammt Preis		sum price	Http	\N
1135350968	admindb	1136802687	admindb	Kopie von		copy from	Http	\N
1136211498	admindb	1136802697	admindb	Expression		expression	Http	\N
1135781149	admindb	1136802728	admindb	Ausgabeobjekt f??r id <$1> in Weblet <$2> nicht gefunden		output object for id <$1> in weblet <$2> not found	Http	\N
1136212580	admindb	1136802748	admindb	Ben??tige Spalten der ersten Tabelle		need colums in the first table	DbHttpAdminJoin	\N
1135860654	admindb	1136802755	admindb	keiner		nobody	Http	\N
1109081523	admindb	1109848214	admindb	Sicht <$1:$2> wirklich l??schen ?		delete view <$1:$2> ?	Http	\N
1109846990	admindb	1109848241	admindb	Person <$1> wirklich l??schen ?		delete person <$1>	Http	\N
1109839942	admindb	1109848264	admindb	Addiere Referenz		add referenz	Http	\N
1109848274	admindb	1109854136	admindb	Person wirklich l??schen ?		delete person ?	Http	\N
1109081674	admindb	1109854199	admindb	Table <%s,%s> oder Spalte <%s,%s> beim addieren zur Whereclause nicht vorhanden		table <%s,%s> or row <%s,%s> not availble during adding to the where clause	DbHttpAdminView	\N
1109949147	admindb	1110117720	admindb	ausw??hlen		select	Http	\N
1109950080	admindb	1110117782	admindb	Referenz wirklich l??schen		delete referenz	Http	\N
1109931296	admindb	1110117789	admindb	Weblet 		weblet	Http	\N
1098087728	admindb	1098087779	admindb	Benutzer ??ndern		change user	Http	\N
1099320676	admindb	1110208247	admindb	Sprache f??r Kategorie <%s> zu <%s> gesetzt		language for categorie <%s> set to <%s>		\N
1098103403	admindb	1110286745	admindb	Schema		schema		\N
1098087728	admindb	1110286754	admindb	Benutzer		user		\N
1098718132	admindb	1110286842	admindb	Deutsch		german		\N
1098718132	admindb	1110286849	admindb	Englisch		english		\N
1106059977	admindb	1106138980	admindb	Action "%s" bei group_edit unbekannt		action "%s" unknown for group_edit	DbHttpAdminGroup	\N
1099298907	admindb	1099300950	admindb	Spalte %s ist in der Tabelle %s beim Einf??gen nicht forhanden		row %s do not exists in table %s during insert	PgTabl	\N
1099298907	admindb	1099300973	admindb	Spalte %s ben??tigt einen Wert		row %s needs a value	DbTabl	\N
1099299807	admindb	1099301005	admindb	viewid ist falsch - vieleicht 2 Sichteditoren offen		wrong viewid - perhaps 2 view editors open	DbHttp	\N
1383931735	admindb	1605702912	admindb	Personaldaten		personnal data		0
1099311930	admindb	1099483717	admindb	Keine Spalten zum Einf??gen in die Tabelle %s vorhanden		now row avalible during insert into table %s	PgTabl	\N
1099393527	admindb	1099483755	admindb	Anwendung		application	Http	\N
1099393527	admindb	1099483765	admindb	Administration		adminstration	Http	\N
1099927721	admindb	1099995332	admindb	Registerkarte 		register card	Http	\N
1099487296	admindb	1099995658	admindb	Sicht		view		\N
1099931005	admindb	1099995688	admindb	Keine Inc num <%ld> vorhanden		no inc num<%ld>	DbHtml	\N
1099926361	admindb	1099995714	admindb	Attribut %s ist im falschen Format		wrong format for attribute %s	DbHtml	\N
1099497783	admindb	1099995743	admindb	mk_where(): Spalte <%s> ist unbekannt		mk_where(): column <%s> unknown	PgTabl	\N
1100095298	admindb	1100158274	admindb	DbHtmlComposer: Include <%s> nicht gefunden		DbHtmlComppser: include <%s> not found	DbHtml	\N
1100182627	admindb	1100182655	admindb	DB Tabelleninhalte		db table contents	Http	\N
1100182619	admindb	1100182665	admindb	DBA Benutzer		dba user	Http	\N
1100185463	admindb	1100191266	admindb	Tabelle %s.%s existiert nicht mehr		table %s.%s is deleted	DbView	\N
1100186340	admindb	1100191276	admindb	DBA Tabellen		DBA tables	Http	\N
1100185441	admindb	1100191295	admindb	DBA Sichten		dba views	Http	\N
1100765808	admindb	1100765878	admindb	Interner Ansprechpartner		internal contact	Http	\N
1100783100	admindb	1100784666	admindb	Vorbild Name		template table name	Http	\N
1100539171	admindb	1100784683	admindb	DBA Schemas		dba schemas	Http	\N
1100773157	admindb	1100784690	admindb	Gruppe		group	Http	\N
1100509881	admindb	1100784774	admindb	DBA Joins		dba joins	Http	\N
1100769600	admindb	1100784788	admindb	Template <%s> nicht gefunden		template <%s> not found	DbHtmlComposer	\N
1100247975	admindb	1100784803	admindb	Spalte <%s> unbekannt		column <%s> unknown	DbHttp	\N
1100784620	admindb	1100784837	admindb	Firma Details		company details		\N
1100783100	admindb	1100784846	admindb	Vorbild Schema		template schema	Http	\N
1101392208	admindb	1101396414	admindb	L??nder		countrys	Http	\N
1101384519	admindb	1101396422	admindb	neues Land		new country	Http	\N
1101391533	admindb	1101396434	admindb	Land gel??scht		country deleted	Http	\N
1101370996	admindb	1101396458	admindb	Land bearbeiten		modify country	Http	\N
1100784869	admindb	1101396505	admindb	Ausgabeobjekt f??r id <$1> nicht gefunden		output object for id <$1> not found	Http	\N
1100790204	admindb	1101396513	admindb	Land		country	Http	\N
1127372900	admindb	1127379705	admindb	eigene Addresse		own adress		\N
1127380308	admindb	1127380347	admindb	Firma		company		\N
1109175614	admindb	1127380451	admindb	geerbte Addresse		parent address	Http	\N
1127653378	admindb	1127653378	admindb	us		us		\N
1127829805	admindb	1127838129	admindb	Stadt		city	Http	\N
1128084754	admindb	1129032399	admindb	Person L??schen		delete person	Http	\N
1130508768	admindb	1135341984	admindb	August		august	Http	\N
1129024846	admindb	1129032271	admindb	Spaltenid <%s> zum Sortieren in Sicht <%s> nicht gefunden		columnid <%s> for sorting in view <%s> not found	DbView	\N
1107010992	admindb	1107958370	admindb	Men??punkt bearbeiten		modify menu entry	Http	\N
1129024845	admindb	1129032299	admindb	Spaltenid <%s> f??r Whereclause in Sicht <%s> nicht gefunden		columnid <%s> for where clause in view <%s> not found	DbView	\N
1099297994	admindb	1129032322	admindb	Spaltenid		columnid	Http	\N
1128602573	admindb	1129032373	admindb	Anforderungszeile %s ist im falschen Format		request line %s has a wrong format	Http	\N
1128174211	admindb	1129032407	admindb	keine Person ausgew??hlt		no person selected	Http	\N
1126187645	admindb	1129032421	admindb	Innenabstand		padding	Http	\N
1127829805	admindb	1129032444	admindb	Addresse <$1:$2> wirklich l??schen ?		delete address <$1:$2> ?	Http	\N
1126364215	admindb	1129032450	admindb	Text		text	Http	\N
1128437359	admindb	1129032458	admindb	Objekt 		object	Http	\N
1128934107	admindb	1129032465	admindb	%s: %d		%s: %d	Http	\N
1128952918	admindb	1129032472	admindb	Firmen Daten		company data		\N
1128084754	admindb	1129032479	admindb	Person Hinzuf??gen		add person	Http	\N
1126187645	admindb	1129032483	admindb	Rahmen		frame	Http	\N
1128340406	admindb	1129032511	admindb	Firmenmitglied		member of company		\N
1128602639	admindb	1129033196	admindb	Zu wenig Zeilen im Request		not enough request lines	Http	\N
1127829805	admindb	1129033208	admindb	Adresse bearbeiten		modify address	Http	\N
1126187645	admindb	1129033217	admindb	Vertikale Ausrichtung		vertical align	Http	\N
1129034915	admindb	1129102604	admindb	 konnte nicht gefunden werden		can not be found	Http	\N
1098116259	admindb	1137766631	admindb	Datei		file		\N
1130153638	admindb	1130153638	admindb	Kalender		calendar		\N
1130153638	admindb	1130153638	admindb	Tag		day		\N
1137766574	admindb	1137766631	admindb	SQLProzeduren		sql procedure		\N
1100785141	admindb	1131108243	admindb	Orte		citys		\N
1101396661	admindb	1131108263	admindb	Laender	L??nder	countrys		\N
1129298400	admindb	1131108276	admindb	Einstellungen		options		\N
1098116259	admindb	1131108294	admindb	Bearbeiten		edit		\N
1108989835	admindb	1131108304	admindb	Personen		person's		\N
1119876367	admindb	1131108448	admindb	Firmen Liste		company list		\N
1131109777	admindb	1131109955	admindb	Sprachcache l??schen		clear language cache		\N
1106573353	admindb	1131110010	admindb	Firmen		company's		\N
1131366207	admindb	1131366457	admindb	Referenzmanual		reference manual		\N
1130763665	admindb	1131627231	admindb	Auswahl		select	Http	\N
1131627187	admindb	1131627262	admindb	Funktion		function	Http	\N
1102613407	admindb	1106138954	admindb	Keine Spalten zum Modifizieren der Tabelle %s vorhanden		no column avalible for modify the table %s	PgTable	\N
1109176310	admindb	1109848230	admindb	Eigene Addresse wirklich l??schen ?		delete own adress ?	Http	\N
1103018793	admindb	1106138993	admindb	deutsch		german	Http	\N
1103724760	admindb	1106139002	admindb	Drucken		print	Http	\N
1102612907	admindb	1106139481	admindb	Addresse wirklich l??schen ?		delete address ?	Http	\N
1106150048	admindb	1106754034	admindb	Konnte Pdf-Datei nicht ??ffnen		can't open pdf file	DbHttpUtilsTable	\N
1098088863	admindb	1098091254	admindb	Addieren		add	Http	\N
1098088863	admindb	1098091273	admindb	keine Spalte ausgew??hlt		no row selected	Http	\N
1472112302	admindb	1472112302	admindb	Active Sync		active sync	HttpMenu	\N
1098088863	admindb	1098091315	admindb	Zeile wirklich l??schen		delete row	Http	\N
1098088863	admindb	1098091342	admindb	Tabelleneintrag ??ndern		change table data	Http	\N
1098091358	admindb	1098092139	admindb	Benutzer $1 wirklich l??schen ?		delete user $1 ?	Http	\N
1098088506	admindb	1098093868	admindb	Gruppenmitglied $1 wirklich l??schen ?		delete group member $1 ?	Http	\N
1098094309	admindb	1098094334	admindb	Gruppen		groups	Http	\N
1351236297	admindb	1370626146	admindb	Angebot Schritt		offer step	DbQuery	\N
1098088506	admindb	1098102625	admindb	Gruppenmitglied hinzuf??gen		add group member	Http	\N
1098102384	admindb	1098103558	admindb	Benutzer Hinzuf??gen		add user	Http	\N
1098102384	admindb	1098103575	admindb	Benutzer ??ndern		modify user	Http	\N
1098102384	admindb	1098103589	admindb	Benutzer L??schen		delete user	Http	\N
1098102384	admindb	1098103607	admindb	Gruppe Hinzuf??gen		add group	Http	\N
1098102384	admindb	1098103623	admindb	Gruppe ??ndern		modify group	Http	\N
1098102384	admindb	1098103639	admindb	Gruppe L??schen		delete group	Http	\N
1098102416	admindb	1098103652	admindb	Zeile hinzuf??gen		add row	Http	\N
1098102416	admindb	1098103667	admindb	Zeile ??ndern		modify row	Http	\N
1098103403	admindb	1098103742	admindb	Benutzer/Zeit Spalten		user/time rows	Http	\N
1098103403	admindb	1098103782	admindb	Defaultwert		default value	Http	\N
1098103404	admindb	1098103822	admindb	kein Index ausgew??hlt		no index selected	Http	\N
1098103404	admindb	1098103850	admindb	Keinen Benutzer ausgew??hlt		no user selected	Http	\N
1098103404	admindb	1098103881	admindb	Lesen		read	Http	\N
1098103404	admindb	1098103895	admindb	Schreiben		write	Http	\N
1098103404	admindb	1098103914	admindb	Spezial		special	Http	\N
1098103404	admindb	1098103925	admindb	Alles		all	Http	\N
1098103404	admindb	1098103944	admindb	Tabelle hinzuf??gen		add table	Http	\N
1098103404	admindb	1098103957	admindb	Tabelle ??ndern		modify table	Http	\N
1098103404	admindb	1098103971	admindb	Tabelle l??schen		delete table	Http	\N
1098088863	admindb	1098091235	admindb	wird nicht unterst??tzt		no support	Http	\N
1098103404	admindb	1098103998	admindb	Index		index	Http	\N
1098103404	admindb	1098104008	admindb	Zugriff		access	Http	\N
1098103404	admindb	1098104022	admindb	keine Tabelle		no table	Http	\N
1098104926	admindb	1098105027	admindb	Spalte <$1> aus Tabelle <$2> wirklich l??schen ?		delete row <$1> from table <$2> ?	Http	\N
1098104925	admindb	1098105047	admindb	Tabelle <$1> wirklich l??schen ?		delete table <$1> ?	Http	\N
1098104926	admindb	1098105060	admindb	Spalten		rows	Http	\N
1098104926	admindb	1098105085	admindb	Zugriff f??r Benutzer <$1> wirklich l??schen ?		delete access for user <$1> ?	Http	\N
1098104926	admindb	1098105105	admindb	Index <$1> wirklich l??schen ?		delete index <$1> ?	Http	\N
1098108875	admindb	1098113817	admindb	Grund: %s		reason: %s	DbConn	\N
1098109177	admindb	1098113883	admindb	Join <$1> wirklich l??schen ?		delete join <$1> ?	Http	\N
1098109177	admindb	1098113899	admindb	L??sche Join		delete join	Http	\N
1098109177	admindb	1098113914	admindb	Tabelle		table	Http	\N
1098109177	admindb	1098114060	admindb	Join		join	Http	\N
1107786488	admindb	1107958304	admindb	Maske wirklich l??schen ?		delete screen ?	Http	\N
1107263678	admindb	1107958352	admindb	kann Tabelle %s nicht l??schen		can't delete table	PgTable	\N
1107781964	admindb	1107958360	admindb	compose		compose		\N
1106923200	admindb	1107958379	admindb	User	Benutzer	user		\N
1106923199	admindb	1107958393	admindb	Headerdaten:		header data:	Http	\N
1107010992	admindb	1107958404	admindb	Men??punkt wirklich l??schen ?		delete menu entry ?	Http	\N
1107786488	admindb	1107958412	admindb	neue Maske		new screen	Http	\N
1107010992	admindb	1107958424	admindb	Men??punkt L??schen		delete menu entry ?	Http	\N
1106923199	admindb	1107958451	admindb	Protokoll		protokoll		\N
1106923199	admindb	1107958466	admindb	Hostname		hostn		\N
1107958160	admindb	1107958502	admindb	Dirname		dirname		\N
1108374293	admindb	1108374341	admindb	Constraints		constraints	Http	\N
1107961232	admindb	1108978286	admindb	Weblet wirklich l??schen ?		delete weblet ?	Http	\N
1108978135	admindb	1108978390	admindb	warte auf		wait for	Http	\N
1108474506	admindb	1108978417	admindb	Table	Tabelle	table	Http	\N
1108474506	admindb	1108978458	admindb	Foreign Key <$1> aus Tabelle <$2> wirklich l??schen ?		delete foreign key <$1> for table <$1> ?	Http	\N
1108744800	admindb	1108978469	admindb	Ortschaft bearbeiten		modify city	Http	\N
1108029748	admindb	1108978490	admindb	Maske <$1> wirklich l??schen ?		delete screen <$1> ?	Http	\N
1102501059	admindb	1102517178	admindb	beginnt		starts	Http	\N
1108375818	admindb	1108978518	admindb	Constraint <$1> aus Tabelle <$2> wirklich l??schen ?		delete constraint <$1> for table <$2> ?	Http	\N
1097767924	admindb	1097768048	admindb	Typ		type		\N
1097767924	admindb	1097768056	admindb	Name		name		\N
1097767924	admindb	1097768063	admindb	ja		yes		\N
1097767924	admindb	1097768069	admindb	nein		no		\N
1098085730	admindb	1098085752	admindb	Ok		ok	Http	\N
1098085730	admindb	1098085761	admindb	Abbrechen		cancel	Http	\N
1098087728	admindb	1098087753	admindb	Passw??rter stimmen nicht ??berein		passwords are not equal	Http	\N
1098087728	admindb	1098087805	admindb	keine Zeile ausgew??hlt		no row selected	Http	\N
1098087728	admindb	1098087857	admindb	Hinzuf??gen		add	Http	\N
1098087728	admindb	1098087866	admindb	??ndern		modify	Http	\N
1098087728	admindb	1098087876	admindb	L??schen		delete	Http	\N
1098087728	admindb	1098087885	admindb	Password		password	Http	\N
1098087728	admindb	1098087894	admindb	Admin		admin	Http	\N
1098088506	admindb	1098091034	admindb	neue Gruppe		new Group	Http	\N
1098088506	admindb	1098091051	admindb	Gruppe ??ndern		change group	Http	\N
1098088506	admindb	1098091109	admindb	Gruppe $1 wirklich l??schen ?		delete group $1	Http	\N
1098088506	admindb	1098091131	admindb	keine Gruppe ausgew??hlt		no group selected	Http	\N
1098088506	admindb	1098091204	admindb	Mitglieder		member	Http	\N
1098088506	admindb	1098091217	admindb	Id		id	Http	\N
1099052545	admindb	1099052610	admindb	Neuer Tabelleneintrag		new table row	Http	\N
1099297993	admindb	1099300525	admindb	TNR		tnr	Http	\N
1472112330	admindb	1472112330	admindb	Zertifikate		certificates	HttpMenu	\N
1099297138	admindb	1099300514	admindb	Tabelle %s exitiert nicht oder besitzt keine Spalten		table %s do not exists or contain no rows	PgJoin	\N
1099297994	admindb	1099300532	admindb	Spalte		row	Http	\N
1100790297	admindb	1101396531	admindb	Kein Tabellenname beim Einf??gen in die  Tabelle vorhanden		no tablename during insert into table	PgTable	\N
1100785141	admindb	1101396538	admindb	Addresse		address		\N
1101384269	admindb	1101396571	admindb	Transaktion ist beim Start nicht abgeschlossen		transaction not closed during starting a new transaction	DbConnect	\N
1101396801	admindb	1101396918	admindb	Kein Tabellenname beim Modifizieren in die  Tabelle vorhanden		no tablename during modify a table	PgTable	\N
1102326767	admindb	1102328894	admindb	letzter SQL-Befehl		last sql command	DbConnect	\N
1102324970	admindb	1102328983	admindb	Keine Spalte ausgew??hlt		no column selected	Http	\N
1101998338	admindb	1102328918	admindb	Keine Incid <%s> vorhanden		no inc id <%s> avalible	DbHtmlComposer	\N
1102328704	admindb	1102328969	admindb	Ortschaft <$1:$2> wirklich l??schen ?		delete city <$1:$2> ?	Http	\N
1351236297	admindb	1370626107	admindb	Produktzeit		product time	DbQuery	\N
1351236328	admindb	1370626304	admindb	Bitte eine Zahl eingeben die nicht mit einer 0 beginnt		only numbers not starting with a 0	HttpTranslate	\N
1351236328	admindb	1370626552	admindb	 keine Funktion zum setzen der Attribute definiert		no function defined for setting attributes	HttpTranslate	\N
1351236328	admindb	1370626698	admindb	numerierte Aufz??hlung einf??gen		insert numbered list	HttpTranslate	\N
1351236328	admindb	1370626809	admindb	SPAN mit komplexen Inhalt gefunden - wandele in Text		SPAN with complex content found - will change in text	HttpTranslate	\N
1370660436	admindb	1382447958	admindb	Produkt		product	DbQuery	\N
1370660436	admindb	1382447982	admindb	Zeitplannung		time planning	DbQuery	\N
1370660436	admindb	1382447991	admindb	Materialplannung		material planning	DbQuery	\N
1370660436	admindb	1382447997	admindb	W??hrung		currency	DbQuery	\N
1377077133	admindb	1382448005	admindb	Fehler hinzuf??gen		add bug	HttpTranslate	\N
1377077133	admindb	1382448011	admindb	Fehler bearbeiten		modify bug	HttpTranslate	\N
1377103087	admindb	1382448025	admindb	Tag <%s> ist unbekannt		day <%> is unknown	XmlParse	\N
1377235909	admindb	1382448032	admindb	Zeitplanung hinzuf??gen		add time planning	HttpTranslate	\N
1377864837	admindb	1382448064	admindb	warte auf Daten		wait for data	HttpTranslate	\N
1136475331	admindb	1382446349	admindb	Sehr geehrter Herr		Dear Sir		\N
1379404833	admindb	1382448132	admindb	Datei hinzuf??gen		add file	HttpTranslate	\N
1379404833	admindb	1382448144	admindb	Hinzugef??gte Datei bearbeiten		modify added file	HttpTranslate	\N
1379404840	admindb	1382448152	admindb	Daten werden geschrieben		data written	HttpTranslate	\N
1379404840	admindb	1382448163	admindb	Fehlerdatei hinzuf??gen		add bug file	HttpTranslate	\N
1379404840	admindb	1382448170	admindb	Fehlerdatei bearbeiten		modify bug file	HttpTranslate	\N
1379404840	admindb	1382448183	admindb	Fehler beim schreiben der Datei		error during writting the file	HttpTranslate	\N
1379416094	admindb	1382448191	admindb	Mailbox hinzuf??gen		add mailbox	HttpTranslate	\N
1379416094	admindb	1382448199	admindb	Mailbox bearbeiten		modify mailbox	HttpTranslate	\N
1379416094	admindb	1382448214	admindb	aktivieren		activate	HttpTranslate	\N
1379416094	admindb	1382448321	admindb	Server neu lesen		reading server	HttpTranslate	\N
1379416094	admindb	1382448337	admindb	Sende-/Empfangsbox		send/receive box	HttpTranslate	\N
1379416094	admindb	1382448351	admindb	Bitte eine Mailbox ausw??hlen		please select a mailbox	HttpTranslate	\N
1379416097	admindb	1382448367	admindb	Absender		sender	DbHttpUtilsImap	\N
1379416097	admindb	1382448380	admindb	Betreff		subject	DbHttpUtilsImap	\N
1379482686	admindb	1382448414	admindb	Unerwartete Anwort - breche Verbindung ab		unexpected answer - disconnect connection	Imap	\N
1379482686	admindb	1382448423	admindb	Fehler beim Schreiben		error during writing	Imap	\N
1379692043	admindb	1382448598	admindb	Fehler		error	DbQuery	\N
1379916760	admindb	1382448605	admindb	Datei bearbeiten		modify file	HttpTranslate	\N
1379922425	admindb	1382448614	admindb	Vorhersage hinzuf??gen		add forecast	HttpTranslate	\N
1379922425	admindb	1382448622	admindb	Vorhersage bearbeiten		modify forecast	HttpTranslate	\N
1380022128	admindb	1382448786	admindb	Email hinzuf??gen		add email	HttpTranslate	\N
1380022128	admindb	1382448793	admindb	Email bearbeiten		modify email	HttpTranslate	\N
1380022128	admindb	1382448802	admindb	Bitte eine Firma ausw??hlen		please select a company	HttpTranslate	\N
1380087775	admindb	1382448812	admindb	Fehler 		error 	DbQuery	\N
1380108930	admindb	1382448845	admindb	keine Spalte <%s> vorhanden		no column <%s> availble	PgTable	\N
1380111957	admindb	1382448852	admindb	neuen Benutzer erstellen		add user	HttpTranslate	\N
1380119138	admindb	1382448871	admindb	Login wirklich l??schen		really delete login	HttpTranslate	\N
1377270253	admindb	1382448890	admindb	Es wurden Teile der Bestellung ausgeliefert		parts of the order are delivered	DbConnect	\N
1377270253	admindb	1382448934	admindb	Es wurde am Auftrag gearbeitet		the order as time recording  items	DbConnect	\N
1351236328	admindb	1381273349	admindb	Auswahl in das Clipboard ??bertragen und l??schen		transfer selection to the clipboard and delete it	HttpTranslate	\N
1351236329	admindb	1381273641	admindb	Kann nur aus einer Tabelle Zeilen l??schen		can delete rows only from a table	HttpTranslate	\N
1351236329	admindb	1381273812	admindb	Zeile vor die aktuelle Zeile hinzuf??gen		insert a row before actual row	HttpTranslate	\N
1351236362	admindb	1381273928	admindb	MneAjaxWebet:readData:$1 weblet.act_values besitzt keine Daten f??r 		MneAjaxWebet:readData:$1 weblet.act_values do not contain data for	HttpTranslate	\N
1351236362	admindb	1381274066	admindb	 Fehler in Reihe $1 und Spalte $2		error in row $1 col $2	HttpTranslate	\N
1351236365	admindb	1381276684	admindb	Wirklich alle indiduellen Einstellungen der Produkte ??berschreiben?	Wirklich alle individuellen Einstellungen der Produkte ??berschreiben?	really overwrite all  individual settings of the products?	HttpTranslate	\N
1351238113	admindb	1381276957	admindb	Gesammte Tabelle		entire table	HttpTranslate	\N
1363680416	admindb	1381277163	admindb	assoziierten Kontakt hinzuf??gen		add associated contact	HttpTranslate	\N
1353051996	admindb	1382439318	admindb	Bitte das Wetter angeben		please select the wheater	HttpTranslate	\N
1381252973	admindb	1382439352	admindb	Bitte Benutzernamen angeben		please give a user name	DbConnect	\N
1358246656	admindb	1382441427	admindb	Lager hinzuf??gen		add storage	HttpTranslate	\N
1358246660	admindb	1382441525	admindb	Lagerplatz bearbeiten		modify bin location	HttpTranslate	\N
1382374301	admindb	1382441838	admindb	Teil kann entweder ein Lagerteil oder Inventar sein		part can be a bearing part or inventory	DbConnect	\N
1382374301	admindb	1382441897	admindb	Lagerteil hat keine hinterlegten Kosten		storage part  has not filed cost	DbConnect	\N
1364481750	admindb	1382441998	admindb	Vcard Version ist unbekannt - es kann zu Fehlern kommen		vcard version is unknown - errors posible	HttpTranslate	\N
1351242994	admindb	1382442095	admindb	Bitte erst Tabellen ausw??hlen		please select table	HttpTranslate	\N
1351245691	admindb	1382442138	admindb	Auftrag hinzuf??gen		add order	HttpTranslate	\N
1351245698	admindb	1382442168	admindb	Auftrag ist geschlossen		order is closed	HttpTranslate	\N
1351245698	admindb	1382442199	admindb	Das Produkt besitzt Lieferscheine und kann nicht mehr ge??ndert werden		the product has delivery notes and can't be modifyed	HttpTranslate	\N
1351254746	admindb	1382442468	admindb	Nebenkosten		accessory charges	HttpTranslate	\N
1351256813	admindb	1382444606	admindb	Kein Produkt ausgew??hlt		no product selected	HttpTranslate	\N
1351263532	admindb	1382444676	admindb	Spaltenid <%s> unbekannt	Spaltenid <%s> ist unbekannt	column <%s> is unknown	DbHttpUtilsQuery	\N
1351323647	admindb	1382444906	admindb	Assoziierten hinzuf??gen/??ndern		add/modify associated 	HttpTranslate	\N
1352977022	admindb	1382445072	admindb	Index bearbeiten		modify index	HttpTranslate	\N
1352985471	admindb	1382445136	admindb	neue Checkconstraint		new check contraint	HttpTranslate	\N
1352985952	admindb	1382445217	admindb	Kategorie bearbeiten		modify categorie	HttpTranslate	\N
1353051989	admindb	1382445319	admindb	Zeiteintrag bearbeiten		modify time item	HttpTranslate	\N
1353051996	admindb	1382445429	admindb	Bitte die Zeiteingaben  ??berpr??fen		please check the time values	HttpTranslate	\N
1353051996	admindb	1382445523	admindb	Zeitangaben Bautagebuch und Zeiterfassung ??berschneiden sich		time items at the builddiary and the time recording overlaps	HttpTranslate	\N
1353421861	admindb	1382445755	admindb	Benutzereinstellungen bearbeiten		modify user settings	HttpTranslate	\N
1353484291	admindb	1382445892	admindb	Bitte Rechnungskonditionen ausw??hlen		please select incoice conditions	HttpTranslate	\N
1353499223	admindb	1382446070	admindb	Brief hinzuf??gen		add letter	HttpTranslate	\N
1353499223	admindb	1382446179	admindb	Zum Versenden muss der Brief gespeichert werden		the letter must be saved before sending	HttpTranslate	\N
1354012276	admindb	1382446564	admindb	Teil einer Bestellung bearbeiten		modify part from a purchase	HttpTranslate	\N
1354012962	admindb	1382446670	admindb	Lieferschein 		delivery note	HttpTranslate	\N
1354027830	admindb	1382446717	admindb	Foreign Key bearbeiten		modify foreign key	HttpTranslate	\N
1354281338	admindb	1382446799	admindb	Bitte erst die erste und die zweite Tabelle aussuchen		please select first and second table	HttpTranslate	\N
1355307422	admindb	1382446929	admindb	Personendaten hinzuf??gen		add personnal data	HttpTranslate	\N
1380177071	admindb	1382448950	admindb	Qualifikation bearbeiten		modify skill	HttpTranslate	\N
1380192423	admindb	1382448992	admindb	keine Berechtigung das Passwort zu ??ndern		no authorization to change the password	DbConnect	\N
1380634953	admindb	1382449002	admindb	Material hinzuf??gen		add material	HttpTranslate	\N
1380634953	admindb	1382449014	admindb	Material bearbeiten		modify material	HttpTranslate	\N
1381930252	admindb	1382449163	admindb	Blatt drucken		print page	HttpTranslate	\N
1382385379	admindb	1382449288	admindb	keine Summen: 		no sum:	HttpTranslate	\N
1382403439	admindb	1382449297	admindb	Benutzer nicht gefunden		user not found	DbConnect	\N
1382438552	admindb	1382449352	admindb	Benutzer existiert schon und hat eventuell Zugriff zu einer anderen Datenbank		user exists and have possible access to a other database	DbConnect	\N
1382441660	admindb	1382449409	admindb	Inventar hat keine hinterlegten Kosten		inventory has no deposited costs	DbConnect	\N
1358244340	admindb	1382447019	admindb	Kein Rechnungslauf ausgew??hlt		select invoice run	HttpTranslate	\N
1358245319	admindb	1382447298	admindb	Der Autoreport <%s> ist unbekannt		the report <%s> is unknown	DbHttpReport	\N
1358253963	admindb	1382447722	admindb	Bitte Teil ausw??hlen		please select part	HttpTranslate	\N
1358316926	admindb	1382447953	admindb	Start liegt in der Vergangenheit		start are in the past	DbConnect	\N
1380177071	admindb	1382448941	admindb	Qualifikation hinzuf??gen		add skill	HttpTranslate	\N
1383931095	admindb	1383931095	admindb	Benutzer Einstellungen		user settings		\N
1383931184	admindb	1383931184	admindb	Kontaktdaten		contacts		\N
1383931229	admindb	1383931229	admindb	Mail Administration		mail administration		\N
1383931251	admindb	1383931251	admindb	Datenbankadministration		database administration		\N
1383931273	admindb	1383931273	admindb	Rechnungskonditionen		invoice conditions		\N
1383931311	admindb	1383931311	admindb	Materialwirtschaft		materials management		\N
1383931369	admindb	1383931369	admindb	Wareneingang		stock receipt		\N
1383931483	admindb	1383931483	admindb	Warenausgang		stock removal		\N
1383931493	admindb	1383931493	admindb	Teile		parts		\N
1383931532	admindb	1383931532	admindb	Bestellungen		purchases		\N
1383931560	admindb	1383931560	admindb	Inventar		fixtures		\N
1383931584	admindb	1383931584	admindb	Inventarart		type of fixtures		\N
1383931600	admindb	1383931600	admindb	Personal		personnal		\N
1383931644	admindb	1383931644	admindb	Tagesrapport		day time recording		\N
1383931667	admindb	1383931667	admindb	Zeiterfassung		time recording		\N
1383931691	admindb	1383931691	admindb	Zeitplanung		time management		\N
1383931754	admindb	1383931754	admindb	F??higkeiten		skills		\N
1383931770	admindb	1383931770	admindb	Konten		accounts		\N
1383931789	admindb	1383931789	admindb	Hilfe		help		\N
1383931797	admindb	1383931797	admindb	Handbuch		manual		\N
1382458805	admindb	1383931869	admindb	Bitte eine Datei ausw??hlen		please select a file	HttpTranslate	\N
1382530152	admindb	1383931919	admindb	Erg??nze letzten Lieferschein		amend last delivery note	DbConnect	\N
1382532883	admindb	1383931935	admindb	Status des Kindprozesses ist <%d>		state of the child procress is <%d>	DbHttpReport	\N
1391603266	admindb	1399367884	admindb	Ordner Hinzuf??gen		add folder	HttpTranslate	\N
1382536350	admindb	1383931974	admindb	Keine Rechnungen zum versenden vorhanden		no invoice for sending  available	HttpTranslate	\N
1382536904	admindb	1383931987	admindb	Keine Mahnungen zum versenden vorhanden		no reminder  available for sending	HttpTranslate	\N
1382536993	admindb	1383932015	admindb	Lieferschein ist schon einer Rechnung zugeordnet		delievery note is allready assigned to an invoice	DbConnect	\N
1382537037	admindb	1383932036	admindb	Die Rechnung ist erfolgt und kann nicht ge??ndert werden		the invoice is sended and can't modify	DbConnect	\N
1382537219	admindb	1383932051	admindb	Ware ist schon eingelagert		the parts are stocked	DbConnect	\N
1382537267	admindb	1383932121	admindb	Zur Lieferung gibt es keine Bestellung		there are no purchase for this shipment	DbConnect	\N
1382537366	admindb	1383932169	admindb	Gelieferte Menge ist gr??sser als bestellte Menge		the shiped quantity is greater than the ordered quantity	DbConnect	\N
1382537398	admindb	1383932185	admindb	Bestellung ist schon erfolgt		purchase are sended	DbConnect	\N
1382540299	admindb	1383932216	admindb	Gelieferte Menge ist vollst??ndig		shiped quantity is complete	DbConnect	\N
1382540372	admindb	1383932247	admindb	Lagerstammdaten hinzuf??gen		add storage master data	HttpTranslate	\N
1382540372	admindb	1383932259	admindb	Lagerstammdaten bearbeiten		modify storage master data	HttpTranslate	\N
1382540376	admindb	1383932277	admindb	Lagerortstammdaten hinzuf??gen		add storage place master data	HttpTranslate	\N
1382540376	admindb	1383932291	admindb	Lagerortstammdaten bearbeiten		modify storage place master data	HttpTranslate	\N
1382540569	admindb	1383932367	admindb	Bestellung wurde schon komplett geliefert		purchase are completed received	DbConnect	\N
1382541774	admindb	1383932390	admindb	Lieferung zur Rechnung hinzuf??gen		add purchase to invoice	HttpTranslate	\N
1382541774	admindb	1383932401	admindb	Lieferung zur Rechnung bearbeiten		modify purchace to invoice	HttpTranslate	\N
1382541774	admindb	1383932431	admindb	Die Rechnung ist schon freigegeben		invoice is released	HttpTranslate	\N
1382541821	admindb	1383932461	admindb	Der Rechnung sind keine Lieferscheine zugeordnet		the invoice has no delivery notes assigned	DbConnect	\N
1382544553	admindb	1383932477	admindb	Inventarartikel hinzuf??gen		add inventory part	HttpTranslate	\N
1382544553	admindb	1383932486	admindb	Inventarartikel bearbeiten		modify inventory part	HttpTranslate	\N
1382544553	admindb	1383932514	admindb	Teil ohne Bestellung inventarisieren ?		add part to the inventory without purchase ?	HttpTranslate	\N
1382544553	admindb	1383932529	admindb	Kosten hinzuf??gen		add costs	HttpTranslate	\N
1382544553	admindb	1383932536	admindb	Kosten bearbeiten		modify costs	HttpTranslate	\N
1382544673	admindb	1383932544	admindb	Inventarart hinzuf??gen		add typ of inventory	HttpTranslate	\N
1382544673	admindb	1383932554	admindb	Inventarart bearbeiten		modify type of inventory	HttpTranslate	\N
1385759765	admindb	1387970554	admindb	Gesetz		law	HttpTranslate	\N
1385769558	admindb	1387970696	admindb	Trenner		seperator	HttpTranslate	\N
1385769558	admindb	1387970719	admindb	keine Koordinaten		koordinates	HttpTranslate	\N
1385771794	admindb	1387970730	admindb	Jahr		year	HttpTranslate	\N
1385776454	admindb	1387970735	admindb	Zonen		zone	HttpTranslate	\N
1386851422	admindb	1387978327	admindb	Mitarbeitender hat kein login		employee has no login	DbConnect	\N
1385765349	admindb	1387970678	admindb	Es wurde schon Material zu diesem Auftrag erfasst		there are allready parts registered to this order	DbConnect	\N
1386965867	admindb	1387970753	admindb	Person hinzuf??gen		add person	HttpTranslate	\N
1386980541	admindb	1387970761	admindb	Navigator		navigator	HttpTranslate	\N
1386980737	admindb	1387970765	admindb	OS		os	HttpTranslate	\N
1386980737	admindb	1387970772	admindb	Pdf Plugin		pdf plugin	HttpTranslate	\N
1387321871	admindb	1387970783	admindb	Sliderposition hinzuf??gen		add slider position	HttpTranslate	\N
1387321871	admindb	1387970794	admindb	Sliderposition bearbeiten		modify sliderposition	HttpTranslate	\N
1387325768	admindb	1387970808	admindb	Das Produkt existiert nicht		the product exists	DbConnect	\N
1387524155	admindb	1387970856	admindb	Der letzte Arbeitsschritt darf nicht gel??scht werden		this last working step should not delete	DbConnect	\N
1387526293	admindb	1387970868	admindb	Wirklich l??schen ?		realy delete ?	HttpTranslate	\N
1387535669	admindb	1387970914	admindb	Zum Versenden muss der Auftrag gespeichert sein		please save the order before sending	HttpTranslate	\N
1387535669	admindb	1387970947	admindb	Auftragsbest??tigung vom		sales confirmation from	HttpTranslate	\N
1387548278	admindb	1387970977	admindb	Teile sind schon ausgelagert		parts are released	DbConnect	\N
1387549342	admindb	1387971045	admindb	Teil ist Lagerteil und die Anzahl wird ??ber die Lagerverwaltung verwaltet		the part is a stoked part and will be managed in the stock	DbConnect	\N
1387970480	admindb	1387971055	admindb	Inventarart Kosten hinzuf??gen		add inventory cost	HttpTranslate	\N
1387970480	admindb	1387971066	admindb	Inventarart Kosten bearbeiten		modify inventory cost	HttpTranslate	\N
1386851422	admindb	1387978418	admindb	Zeiteintrag ??berschneidet sich mit einem anderen Zeiteintrag		time entry overlap a other time entry	DbConnect	\N
1134139143	admindb	1391520466	admindb	Vorlage	Vorlage	template	Http	\N
1391520525	admindb	1391520546	admindb	RepositoryVorlage	Vorlage	template	DbHttpUtilsRepository	\N
1391584665	admindb	1399367456	admindb	Aktenordner hinzuf??gen		new file	HttpTranslate	\N
1391584665	admindb	1399367466	admindb	Aktenordner bearbeiten		modify file	HttpTranslate	\N
1391584665	admindb	1399367471	admindb	Aktenordner 		file	HttpTranslate	\N
1391584665	admindb	1399367488	admindb	??nderungsmitteilung ist leer - fortfahren ?		modify message is empty - continue ?	HttpTranslate	\N
1391584665	admindb	1399367542	admindb	??nderungen akzeptieren		accept  modifications	HttpTranslate	\N
1391585336	admindb	1399367559	admindb	Die Datei <%s> wurde nicht gefunden		the file <%s> was not found	HttpFilesystem	\N
1391588823	admindb	1399367580	admindb	Der Aktenordner muss einen Namen haben		the file must be a name	DbHttpUtilsRepository	\N
1391588823	admindb	1399367599	admindb	Der Ordner <%s> wurde nicht gefunden		the folder <%s> was not found	HttpFilesystem	\N
1391590435	admindb	1399367618	admindb	Der Aktenordner <%s> existiert nicht		the file <%s> don't exists	DbHttpUtilsRepository	\N
1391594218	admindb	1399367637	admindb	Fehler w??hrend des Listens eines Ordners		error during listing the folder	DbHttpUtilsRepository	\N
1391598781	admindb	1399367651	admindb	kann nicht in Ordner <%s> wechseln		can't change to folder <%s>	PROCESS	\N
1391598781	admindb	1399367669	admindb	Fehler w??hrend des Umbenennen eines Aktenordners		error during renaming a folder	DbHttpUtilsRepository	\N
1391601494	admindb	1399367683	admindb	Initialversion aus Vorlage		initial version from template	DbHttpUtilsRepository	\N
1391603266	admindb	1399367709	admindb	Keine Ok - Aktion definiert		no ok action defined	HttpTranslate	\N
1391603266	admindb	1399367892	admindb	Datei Hinzuf??gen		add file	HttpTranslate	\N
1391603269	admindb	1399367969	admindb	Notiz		note	HttpTranslate	\N
1391603286	admindb	1399367977	admindb	Neu hinzugef??gt		new added	DbHttpUtilsRepository	\N
1391603661	admindb	1399367985	admindb	umbenannt von: 		renamed from:	DbHttpUtilsRepository	\N
1391607289	admindb	1399367995	admindb	Bitte eine Person ausw??hlen		please select a person	HttpTranslate	\N
1391675694	admindb	1399368031	admindb	Ben??tige zum Erzeugen eines Aktenorderns einen Auftrag		need a order for generates a file	HttpTranslate	\N
1391677889	admindb	1399368043	admindb	Der Aktenordner <%s> existiert schon		the file <%s> exists	DbHttpUtilsRepository	\N
1391678069	admindb	1399368061	admindb	Fehler w??hrend des Erzeugens eines Aktenordners		error during generation a file	DbHttpUtilsRepository	\N
1391685306	admindb	1399368077	admindb	keine Funktion f??r den Namen <%s> gefunden		no function for name <%s> found	DbHttpUtilsTrust	\N
1391688314	admindb	1399368120	admindb	Kommando <%s> konnte nicht ausgef??hrt werden		could not start command <%s> 	PROCESS	\N
1391793560	admindb	1399368151	admindb	Fehler w??hrend des L??schens einer Datei		error during deleting a file	DbHttpUtilsRepository	\N
1393330421	admindb	1399368157	admindb	Mails versendet		mails send	HttpTranslate	\N
1393481269	admindb	1399368179	admindb	Kommando <%s> konnte nicht gestartet werden		could not start command <%s>	PROCESS	\N
1393920001	admindb	1399368228	admindb	Es ist mehr als eine Spalte angebegen	Es ist mehr als eine Spalte angegegen	there is more than one column	DbHttpUtilsTable	\N
1394001772	admindb	1399368237	admindb	nicht gesendet		not sended	DbQuery	\N
1394607050	admindb	1399368253	admindb	Der Typ %d wird nicht unterst??tzt		the type %d is not supported	PgTable	\N
1394618543	admindb	1399368274	admindb	Fehler w??hrend des Listens der ??nderungsnotizen		error during listing of change messages	DbHttpUtilsRepository	\N
1394625605	admindb	1399368282	admindb	Neue Version		new version	HttpTranslate	\N
1394629718	admindb	1399368292	admindb	Fehler w??hrend des Hinzuf??gen einer Datei		error during adding a file	DbHttpUtilsRepository	\N
1394630737	admindb	1399368302	admindb	Neue Version hinzugef??gt		new version added	DbHttpUtilsRepository	\N
1396529661	admindb	1399368312	admindb	nicht abgeholt		not fetched	DbQuery	\N
1399368352	admindb	1399368352	admindb	Aktenschrank		repository		\N
1400229520	admindb	1400230376	admindb	Lager ist unbekannt		storage unknown	DbConnect	\N
1400219202	admindb	1400230390	admindb	Kurzbezeichnung		short label	HttpTranslate	\N
1400159741	admindb	1400230395	admindb	Anzahl		count	HttpTranslate	\N
1400159595	admindb	1400230405	admindb	Lager erstellen		create storage	HttpTranslate	\N
1400155757	admindb	1400230411	admindb	Erstellen		create	HttpTranslate	\N
1400066956	admindb	1400230736	admindb	Teile Lagercharge		parting charge	DbConnect	\N
1400059627	admindb	1400230765	admindb	Zeichnungen		drawing	HttpTranslate	\N
1399368358	admindb	1400230772	admindb	fehlerhaftes XML		error in XML	HttpTranslate	\N
1400230896	admindb	1401875101	admindb	Parameter Lageroptimierung 		parameter storage optimization	HttpTranslate	\N
1400479878	admindb	1401875201	admindb	Erg??nze Bestand		restock	DbConnect	\N
1400482799	admindb	1401875249	admindb	Lieferung ist schon abgeholt		the delivery is picked up	DbConnect	\N
1400504369	admindb	1401875271	admindb	F??r die Waren existieren Umlagerauftr??ge		for the parts exists relocations	DbConnect	\N
1400574638	admindb	1401875312	admindb	Bitte einen Lagerplatz ausw??hlen		please select a bin location	DbConnect	\N
1400576623	admindb	1401875330	admindb	Optimierung		optimize	HttpTranslate	\N
1400579368	admindb	1401875337	admindb	Lager 		stock	HttpTranslate	\N
1400651727	admindb	1401875373	admindb	Zur Lieferung gibt es keine Bestellung - erstelle eine		there is no order for the delivery - create one	DbConnect	\N
1400651727	admindb	1401875387	admindb	Bestellung ist noch nicht versendet worden		the order is not sended	DbConnect	\N
1400651727	admindb	1401875427	admindb	Der Lieferschein dieser Bestellung wurde schon erfasst		the delivery note of the order is allready registered	DbConnect	\N
1400756309	admindb	1401875445	admindb	Unbekannter Server <%s>		unknown server <%>	HttpUtils	\N
1401103037	admindb	1401875459	admindb	Kann Table mit Id %d nicht finden		can't find table with id %d	DbQuery	\N
1401174289	admindb	1401875465	admindb	Komentare		comment	HttpTranslate	\N
1401432419	admindb	1401875488	admindb	kann mich nicht mit server <%s:%d> verbinden		can't connect to server < %s:%d>	HttpUtils	\N
1401779431	admindb	1401875505	admindb	Ihr Browser wird nicht komplett unterst??tzt		you browser is not complete supported	HttpTranslate	\N
1400651727	admindb	1401875548	admindb	Das gelieferte Teil darf nicht ver??ndert werden - bitte l??schen und neu anlegen		the delivered part can't modified - please delete it an create a new	DbConnect	\N
1403595903	admindb	1576760393	admindb	Lagerangestellten bearbeiten		modify warehouse employee	HttpTranslate	\N
1404199651	admindb	1576761587	admindb	Erg??nze letzte Rechnung		complete last invoice	DbConnect	\N
1407397445	admindb	1576761728	admindb	Die Buchung existiert nicht		the booking does not exist	DbConnect	\N
1407398344	admindb	1576761749	admindb	Der Rechnungsbetrag stimmt nicht mit dem Umsatz ??berein		the invoice amount does not match the sales	DbConnect	\N
1408440266	admindb	1576761767	admindb	Revision		revision	HttpTranslate	\N
1409730854	admindb	1576761779	admindb	Bild hinzuf??gen		add pictures	HttpTranslate	\N
1409730854	admindb	1576761789	admindb	Bild bearbeiten		modify pictures	HttpTranslate	\N
1409934120	admindb	1576761932	admindb	Angebot geh??rt zu einem Auftrag		offer belongs to an order	DbConnect	\N
1410159318	admindb	1576761949	admindb	Rechnung hat mehr als einen Empf??nger - bitte einzeln quitieren		invoice has more than one recipient - please acknowledge individually	DbConnect	\N
1410162017	admindb	1576761972	admindb	Rechnung wurde nicht verschickt		invoice was not sent	DbConnect	\N
1410162017	admindb	1576761992	admindb	Rechnung ist schon als bezahlt makiert		invoice is already marked as paid	DbConnect	\N
1410178850	admindb	1576762027	admindb	Bitte bezahlte Summe bei den Rechnungskontakten eintragen		please enter the amount paid in the billing contacts	DbConnect	\N
1410241523	admindb	1576762046	admindb	Mahnung noch nicht notwendig oder schon versendet - wirklich drucken ?		reminder not yet necessary or already sent - really print?	HttpTranslate	\N
1410244141	admindb	1576762063	admindb	1. Mahnung ist noch nicht notwendig		1. reminder is not yet necessary	DbConnect	\N
1410244209	admindb	1576762102	admindb	Das Produkt ist unbekannt		the product is unknown	DbConnect	\N
1422268547	admindb	1422268547	admindb	webdav	Freigabe	sharing	HttpMenu	\N
1424875908	admindb	1424875908	admindb	Konfiguration neu laden		reload configuration		\N
1425634846	admindb	1472110456	admindb	Fehler gefunden		error found		\N
1422274861	admindb	1475159130	admindb	Freigabe 		share	HttpTranslate	\N
1410246946	admindb	1576762081	admindb	3. Mahnung ist noch nicht notwendig		3. Reminder is not yet necessary	DbConnect	\N
1410246793	admindb	1576762124	admindb	1. Mahnung wurde nicht verschickt		1st reminder was not sent	DbConnect	\N
1410246946	admindb	1576762142	admindb	2. Mahnung wurde nicht verschickt		2nd reminder was not sent	DbConnect	\N
1410784641	admindb	1576762197	admindb	Carddav Konfiguration hinzuf??gen		add card dav configuration 	HttpTranslate	\N
1410784641	admindb	1576762213	admindb	Carddav Konfiguration bearbeiten		modify card dav configuration	HttpTranslate	\N
1411639217	admindb	1576762245	admindb	Datei ist keine PDF Datei		file is not a PDF file	DbHttpReport	\N
1414131177	admindb	1576762262	admindb	Ben??tige einen Dateinamen		need a file name	HttpFilesystem	\N
1415110624	admindb	1576762281	admindb	Fehler w??hrend des L??schens eines Aktenordners		error while deleting a file folder	DbHttpUtilsRepository	\N
1415111718	admindb	1576762298	admindb	Keine ??nderungen gefunden		no changes found	DbHttpUtilsRepository	\N
1415343073	admindb	1576762306	admindb	Person l??schen		delete person	HttpTranslate	\N
1415344374	admindb	1576762313	admindb	Datei l??schen		delete file	HttpTranslate	\N
1418990098	admindb	1576762340	admindb	Gr??n		green	HttpTranslate	\N
1418990098	admindb	1576762346	admindb	Blau		blue	HttpTranslate	\N
1419332971	admindb	1576762352	admindb	keine Farbe		no color	HttpTranslate	\N
1420538302	admindb	1576762371	admindb	Bitte eine Lieferscheinnummer angeben		please provide a delivery note number	DbConnect	\N
1422262194	admindb	1576762384	admindb	keine Zugeh??rigkeit		no affiliation	DbQuery	\N
1422274861	admindb	1576762405	admindb	Freigabe hinzuf??gen		add share	HttpTranslate	\N
1422274861	admindb	1576762412	admindb	Freigabe bearbeiten		modify share	HttpTranslate	\N
1425373093	admindb	1576762481	admindb	Kann tempor??re Datei <%s> nicht ??ffnen		cannot open temporary file <%s>	Http	\N
1425390780	admindb	1576762504	admindb	Fehler w??hrend des Akzeptierens der ??nderungen		error while accepting the changes	DbHttpUtilsRepository	\N
1425399254	admindb	1576762523	admindb	konnte logfile <%s> nicht ??ffnen		could not open logfile <%s>	PROCESS	\N
1425894015	admindb	1576762560	admindb	Provider %s unterst??tzt %s/%s nicht		provider %s does not support %s/%s	Http	\N
1426236659	admindb	1576762618	admindb	Freigabepasswort hinzuf??gen		add share password	HttpTranslate	\N
1426236659	admindb	1576762627	admindb	Freigabepasswort bearbeiten		modify share password	HttpTranslate	\N
1426236659	admindb	1576762641	admindb	Freigabepasswort wirklich l??schen ?		delete share password ?	HttpTranslate	\N
1426249718	admindb	1576762663	admindb	Der Loginname ist schon vergeben		login name is already taken	DbConnect	\N
1426492357	admindb	1576762852	admindb	Bitte Passwort angeben		please give password	DbConnect	\N
1426497127	admindb	1576762898	admindb	Benutzer nicht angegeben		user not specified	DbConnect	\N
1429514998	admindb	1576762918	admindb	Neuen Datensatz hinzugef??gt		add new record	HttpTranslate	\N
1429617826	admindb	1576762927	admindb	Keine Verbindung zur Datenbank:		no connection to database	DbConnect	\N
1429792174	admindb	1576762954	admindb	Element ist schon Bestandteil des Teiles		element is already part of the part 	DbConnect	\N
1430414753	admindb	1576762968	admindb	signal signalfound		signal signalfound	Sigschild	\N
1432889576	admindb	1576762979	admindb	Active Sync Konfiguration hinzuf??gen		add active sync configuration	HttpTranslate	\N
1433142797	admindb	1576763003	admindb	terminate signal emfangen		terminate signal found	Signal	\N
1433328348	admindb	1576763010	admindb	Interface hinzuf??gen		add interface	HttpTranslate	\N
1433328348	admindb	1576763017	admindb	Interface bearbeiten		modify interface	HttpTranslate	\N
1433764836	admindb	1576763030	admindb	Bitte eine Ip4 Addresse eingeben		please give a ip4 adress	HttpTranslate	\N
1434352218	admindb	1576763054	admindb	Aktuelle Werte Netzwerk		actual network values	HttpTranslate	\N
1433831570	admindb	1576763044	admindb	Typeauswahl		type selection	HttpTranslate	\N
1434352332	admindb	1576763062	admindb	Netzwerk aktuell		actual network	HttpTranslate	\N
1440061772	admindb	1576763066	admindb	Export		export	HttpTranslate	\N
1441007635	admindb	1576763075	admindb	Bitte ein Passwort angeben		please give a password	DbConnect	\N
1447311606	admindb	1576763106	admindb	Die Person hat kein login		person has no login	HttpTranslate	\N
1447336665	admindb	1576763117	admindb	Kann Tempfile <%s> nicht ??ffnen		can't open temp file	DbHttpReport	\N
1453800257	admindb	1576763130	admindb	Daten werden gelesen/geschrieben		reading/writing data	HttpTranslate	\N
1453800709	admindb	1576763144	admindb	Apache Konfiguration hinzuf??gen		add apache configuration	HttpTranslate	\N
1453800709	admindb	1576763152	admindb	Apache Konfiguration bearbeiten		modify apache konfiguration	HttpTranslate	\N
1478676125	admindb	1576763174	admindb	DHCP		DHCP	HttpTranslate	\N
1453800709	admindb	1576763190	admindb	Aktivieren		activate	HttpTranslate	\N
1453824770	admindb	1576763195	admindb	Webseite hinzuf??gen		add web site	HttpTranslate	\N
1453824770	admindb	1576763201	admindb	webseite bearbeiten		modify web stite	HttpTranslate	\N
1453824770	admindb	1576763206	admindb	Webseite 		website	HttpTranslate	\N
1453999098	admindb	1576763213	admindb	Webseite bearbeiten		modify web site	HttpTranslate	\N
1541584654	admindb	1576763225	admindb	Die Mailbox <%s> wurde nicht gefunden		mail box <%s> not found	ImapScan	\N
1541593886	admindb	1576763236	admindb	Summe ist ungleich 100		sum not equal 100	DbConnect	\N
1472110031	admindb	1472110416	admindb	wirklich l??schen		really delete	HttpTranslate	\N
1425652584	admindb	1472110463	admindb	Message gefunden		message found		\N
1352797415	admindb	1472111002	admindb	Subweblet bearbeiten		modify subweblet	HttpTranslate	\N
1472111086	admindb	1472111086	admindb	Sql ausf??hren		execute sql	HttpMenu	\N
1472112353	admindb	1472112353	admindb	Domain		domain	HttpMenu	\N
1472112392	admindb	1472112392	admindb	Netzwerk		network	HttpMenu	\N
1472112427	admindb	1472112427	admindb	Apache		apache	HttpMenu	\N
1472112444	admindb	1472112444	admindb	Erp		erp	HttpMenu	\N
1544191080	admindb	1576763267	admindb	Kosten werden mit hinterlegten Kosten ??berschrieben		costs are overwritten with the stored costs	DbConnect	\N
1545059127	admindb	1576763288	admindb	Die Kosten werden noch von einem Produkt ben??tigt		the costs are still required by a product	DbConnect	\N
1545060855	admindb	1576763296	admindb	Benutzer kann sich nicht einloggen		user can't login	HttpTranslate	\N
1545302195	admindb	1576763333	admindb	letzte Auftr??ge		last orders	HttpTranslate	\N
1547190029	admindb	1576763338	admindb	Neue Zeit		new time	HttpTranslate	\N
1547621828	admindb	1576763360	admindb	Datei nicht gefunden.txt	Datei nicht gefunden	file not found	HttpFilesystem	\N
1547622458	admindb	1576763379	admindb	Netzparameter ??bernehmen		apply network parameters	HttpTranslate	\N
1547622522	admindb	1576763389	admindb	Groupware hinzuf??gen		add groupware	HttpTranslate	\N
1547622522	admindb	1576763398	admindb	Groupware bearbeiten		modify groupware	HttpTranslate	\N
1547622522	admindb	1576763406	admindb	Groupware wirklich l??schen?		delete groupware ?	HttpTranslate	\N
1548059470	admindb	1576763414	admindb	Kein Tabellenname definiert		no table name defined	PgConstraint	\N
1548060228	admindb	1576763433	admindb	Unbekannter Mailserver <%s>		unknown mail server <%s>	Imap	\N
1457686930	admindb	1576763478	admindb	Fehler w??hrend des L??schen eines Ordners		error while deleting a folder	HttpFilesystem	\N
1457687995	admindb	1576763496	admindb	Fehler w??hrend des Erstellens eines Ordners		error while creating a folder	HttpFilesystem	\N
1457702950	admindb	1576763530	admindb	Verzeichnis ausw??hlen		select directory	HttpTranslate	\N
1457702950	admindb	1576763537	admindb	Listenansicht		list view	HttpTranslate	\N
1457702950	admindb	1576763544	admindb	Symbolansicht		symbol view	HttpTranslate	\N
1457702950	admindb	1576763564	admindb	Reihenfolge wurde ver??ndern - neu anzeigen ?		order was changed - redisplay?	HttpTranslate	\N
1457702950	admindb	1576763569	admindb	Erstellt		created	HttpTranslate	\N
1457702950	admindb	1576763580	admindb	Modifiziert		modified	HttpTranslate	\N
1457702950	admindb	1576763587	admindb	letzter Zugriff		last access	HttpTranslate	\N
1457702950	admindb	1576763594	admindb	Dateien wirklich l??schen ?		delete file ?	HttpTranslate	\N
1458632138	admindb	1576763615	admindb	Add Zertifikat		add certificate	HttpTranslate	\N
1459319608	admindb	1576763639	admindb	Zertifizierungsstelle bearbeiten		modify certification authority	HttpTranslate	\N
1459319608	admindb	1576763645	admindb	Zertifizierungsstelle 		certification authority	HttpTranslate	\N
1544430043	admindb	1576763655	admindb	Kontakt ist schon hinzugef??gt		contact all ready added	DbConnect	\N
1459528767	admindb	1576763672	admindb	Fehler w??hrend des Umbenennes eines Ordner oder Datei		error while renaming a folder or file	HttpFilesystem	\N
1544527550	admindb	1576763709	admindb	Bauteil hinzuf??gen		add component	HttpTranslate	\N
1459840954	admindb	1576763719	admindb	Download CA		download CA	HttpTranslate	\N
1544598323	admindb	1576763760	admindb	Lieferant wurde gewechselt		Supplier has been changed	DbConnect	\N
1544527550	admindb	1576763742	admindb	Bauteil bearbeiten		modify component	HttpTranslate	\N
1544612578	admindb	1576763779	admindb	Anzahl zum Umlagern ist 0		number to be transferred is 0	DbConnect	\N
1544612578	admindb	1576767680	admindb	Umlagerauftr??ge f??r Ausgangsware darf nicht ver??ndert werden		transfer orders for outgoing goods may not be changed	DbConnect	\N
1544612719	admindb	1576767971	admindb	Anzahl passt nicht auf Ziellagerplatz		number does not fit the target storage	DbConnect	\N
1544612578	admindb	1576768002	admindb	Bitte andere Laufnummer w??hlen		please choose another serial number	DbConnect	\N
1544693664	admindb	1576768021	admindb	Keine Umlagerung m??glich		no relocation possible	HttpTranslate	\N
1460022057	admindb	1576768031	admindb	Ge??ndert		modified	HttpTranslate	\N
1460022057	admindb	1576768037	admindb	Attribute		attribute	HttpTranslate	\N
1544771910	admindb	1576768055	admindb	Ware bitte wieder einlagern		please store the goods again	DbConnect	\N
1544772204	admindb	1576768072	admindb	Lagerplatz enth??lt zu wenige Teile		storage space contains too few parts	DbConnect	\N
1544795504	admindb	1576768083	admindb	Popup unbekannt		popup unknown	HttpTranslate	\N
1462284988	admindb	1576768097	admindb	Zeitdauer muss gr??sser 0 sein		time must be larger than 0	DbConnect	\N
1462799399	admindb	1576768112	admindb	Fehler <%d> im Script <%s> gefunden		error ,%s> in script <%s> found	PROCESS	\N
1473923888	admindb	1576768122	admindb	Bitte eine Password eingeben		please give password	HttpTranslate	\N
1473843828	admindb	1576768161	admindb	Wirklich alles l??schen?		delete all realy ?	HttpTranslate	\N
1471855000	admindb	1576768198	admindb	Domain hinzuf??gen		add domain	HttpTranslate	\N
1471855000	admindb	1576768205	admindb	Domain bearbeiten		modify domain	HttpTranslate	\N
1471855000	admindb	1576768210	admindb	Domain 		domain	HttpTranslate	\N
1472459919	admindb	1576768226	admindb	konnte Pdfdaten nicht lesen		can't read PDF data	DbHttpReport	\N
1472534904	admindb	1576768252	admindb	Ordner nicht leer		directory not empty	DbHttpUtilsRepository	\N
1472474084	admindb	1576768242	admindb	konnte PDF Datei nicht ??ffnen		can't open PDF file	DbHttpReport	\N
1351236328	admindb	1530178850	admindb	Bitte nur Buchstaben ohne Umlaute und den Unterstrich eingeben		only letter and underscore please	HttpTranslate	\N
1351236328	admindb	1530178864	admindb	Bitte Buchstaben ohne Umlaute, Zahlen und den Unterstrich beginnend mit einem Buchstaben eingeben		only letter, numbers and underscore starting with a letter	HttpTranslate	\N
1351236328	admindb	1530178882	admindb	Bitte Buchstaben ohne Umlaute, Zahlen und den Unterstrich eingeben		only letter, numbers and underscore	HttpTranslate	\N
1530619309	admindb	1530619309	admindb	System		system	HttpTranslate	\N
1531399952	admindb	1576760248	admindb	keine Berechtigung		no authorization	HttpSysexec	\N
1537521316	admindb	1576760284	admindb	%s %s		%s %s	HttpFilesystem	\N
1537774346	admindb	1576760310	admindb	Kein Tabellenname beim Erzeugen der Tabelle vorhanden		no table name during create the table	PgTable	\N
1473922424	admindb	1576760339	admindb	keine		no	DbQuery	\N
1403595903	admindb	1576760382	admindb	Lagerangestellen hinzuf??gen		add warehouse employee	HttpTranslate	\N
1613988901	admindb	1613988901	admindb	Device","			HttpTranslate	\N
1407327352	admindb	1576761644	admindb	Lieferung ist schon eingelagert		delivery is already stored	DbConnect	\N
1409733147	admindb	1576761811	admindb	Modifizieren der gesammten Tabelle nicht gestattet		modification of the entire table is not permitted	DbHttpUtilsTable	\N
1410170389	admindb	1576762010	admindb	L??schen der gesammten Tabelle nicht gestattet		deletion of the entire table is not permitted	DbHttpUtilsTable	\N
1410246794	admindb	1576762072	admindb	2. Mahnung ist noch nicht notwendig		2. Reminder is not yet necessary	DbConnect	\N
1410251086	admindb	1576762163	admindb	Tabelle mit Nummber %d wurde nicht gefunden		table with number %d was not found	DbQueryCreator	\N
1417611973	admindb	1576762331	admindb	Es existiert schon ein Produkt mit gleicher Produktnummer		a product with the same product number already exists	DbConnect	\N
1478851338	admindb	1576768399	admindb	 Der Name existiert schon mit einem A bzw. AAAA Eintrag		The name already exists with a A resp. AAAA entry	DbConnect	\N
1475159921	admindb	1576768408	admindb	Die Passworte sind nicht gleich		password not match	HttpTranslate	\N
1475159921	admindb	1576768413	admindb	Password check		password check	HttpTranslate	\N
1506412209	admindb	1576768424	admindb	Warte noch auf anderen Request		wait of an other request	HttpTranslate	\N
1506503203	admindb	1576768449	admindb	Kann Element nicht klonen - der Type ist unbekannt		can't clone element - unknown type	HttpTranslate	\N
1510328005	admindb	1576768461	admindb	Keine Aktion zum Lesen definiert		no action for reading	HttpTranslate	\N
1513349603	admindb	1576768469	admindb	Datei <%s> wurde nicht gefunden		file <%s> not found	DbHttpUtilsRepository	\N
1510332722	admindb	1576768477	admindb	OK		OK	HttpTranslate	\N
1513925757	admindb	1576768485	admindb	Material 		material	HttpTranslate	\N
1515087988	admindb	1576768494	admindb	Keine Rechnung vorhanden		no invoice found	HttpTranslate	\N
1515169404	admindb	1576768538	admindb	Aus dem Ausgang darf nicht umgelagert werden		no relocation is permitted from the outbound storage	DbConnect	\N
1515666071	admindb	1576768569	admindb	Kein Auftrag ausgew??hlt		no order selected	HttpTranslate	\N
1515746922	admindb	1576768577	admindb	Keine Gruppe angegeben		no group selected	DbConnect	\N
1515750580	admindb	1576768582	admindb	Function		function	HttpTranslate	\N
1516203126	admindb	1576768596	admindb	ok		ok	DbHttpUtilsConnect	\N
1521215263	admindb	1576768601	admindb	Bestellung		order	DbQuery	\N
1521215431	admindb	1576768626	admindb	Angebotsmaterial		offer material	DbQuery	\N
1521215482	admindb	1576768636	admindb	Auftragsmaterial		order material	DbQuery	\N
1521701817	admindb	1576768643	admindb	Fehler gefunden %d		error found %d	HttpSysexec	\N
1522136973	admindb	1576768661	admindb	eine beliebige Zeichenkette bis 16 Zeichen		any character string up to 16 characters	DbHttpAdminTable	\N
1522161924	admindb	1576768678	admindb	Bitte alle Werte korrekt ausf??llen		please fill in all values correctly	HttpTranslate	\N
1522739567	admindb	1576768696	admindb	Anzahl der Selektfelder ist nicht gleich bei unionnum <%d>		the number of select fields is not the same for unionnum <% d>	DbQuery	\N
1524473734	admindb	1576768722	admindb	Konnte <%d> nicht in einen Zeitstruktur wandeln		could not convert <%d> into a time structure	DbHttpUtilsQuery	\N
1525677273	admindb	1576768741	admindb	Bitte Bautagebuch gegebenenfalls korrigieren		please correct the building diary if necessary	DbConnect	\N
1526451328	admindb	1576768783	admindb	Bitte eine Temperatur angeben		please indicate a temperature	HttpTranslate	\N
1530179043	admindb	1576768801	admindb	Bitte nur Buchstaben und den Unterstrich eingeben		please only enter letters and the underscore	HttpTranslate	\N
1530179043	admindb	1576768818	admindb	Bitte Buchstaben, Zahlen und den Unterstrich eingeben		Please enter letters, numbers and the underscore	HttpTranslate	\N
1530179043	admindb	1576768839	admindb	Bitte Buchstaben, Zahlen und den Unterstrich beginnend mit einem Buchstaben eingeben		please enter letters, numbers and the underscore starting with a letter	HttpTranslate	\N
1530619248	admindb	1576768883	admindb	Verbindung zum Server unterbrochen		connection to the server interrupted	HttpTranslate	\N
1530619342	admindb	1576768890	admindb	Domain Parameter		domain parameter	HttpTranslate	\N
1530619359	admindb	1576768905	admindb	Benutzer hat kein login		user has no login	HttpTranslate	\N
1552387053	admindb	1576768915	admindb	Admindb kann nicht gel??scht werden		can't delete admindb	DbConnect	\N
1552569271	admindb	1576768922	admindb	Synchronisation hinzuf??gen		add synchronisation	HttpTranslate	\N
1552569271	admindb	1576768932	admindb	Synchronisation bearbeiten		modify synchronisation	HttpTranslate	\N
1552569271	admindb	1576768942	admindb	Synchronisation wirklich l??schen ?		delete synchronisation ?	HttpTranslate	\N
1553176200	admindb	1576768958	admindb	Spalte <%s> ist schon vorhanden		column <%s> allready exists	DbHttpAdminTable	\N
1553596956	admindb	1576768967	admindb	keine Domain definiert		no domain defined	DbConnect	\N
1553697209	admindb	1576768974	admindb	CA Password		CA password	HttpTranslate	\N
1553700359	admindb	1576768982	admindb	??berschreiben		overwrite	HttpTranslate	\N
1553700990	admindb	1576769015	admindb	Datei existiert und wird nicht ??berschrieben		file exists and is not overwritten	HttpFilesystem	\N
1554106162	admindb	1576769023	admindb	CA Zertifikat		CA certificate	HttpTranslate	\N
1426147915	admindb	1576762590	admindb	Fehler w??hrend des Erzeugens der Versionsverwaltung		error while creating version control	DbHttpUtilsRepository	\N
1432889576	admindb	1576762988	admindb	Active Sync Konfiguration bearbeiten		modify active sync konfiguration	HttpTranslate	\N
1441009274	admindb	1576763098	admindb	Passwort bitte in der Mitarbeitermaske ??ndern		please modify passwrod in employee mask	DbConnect	\N
1453800709	admindb	1576763168	admindb	Apache Konfiguration wirklich l??schen ?		delete apache configuration ?	HttpTranslate	\N
1542374275	admindb	1576763247	admindb	Neue Unterkategorie		new sub category	HttpTranslate	\N
1545229701	admindb	1576763324	admindb	Bitte eine Temperatur eingeben		please give a temperature	HttpTranslate	\N
1548751086	admindb	1576763456	admindb	Es existiert kein Preis f??r das Produkt - bitte erst einen Preis anlegen		there is no price for the product - please create a price first	DbConnect	\N
1459319608	admindb	1576763632	admindb	Zertifizierungsstelle hinzuf??gen		add certification authority	HttpTranslate	\N
1544511608	admindb	1576763692	admindb	Anzahl zum Umlagern ist zu gross		the number to be transferred is too large	DbConnect	\N
1613988901	admindb	1613988901	admindb	Password","			HttpTranslate	\N
1613988901	admindb	1613988901	admindb	Primary Server","			HttpTranslate	\N
1473843828	admindb	1576768146	admindb	Domaindaten wirklich ??ndern? Alle Domaindaten ins besondere die Benutzer und deren Passw??rter werden gel??scht		Really change domain data? All domain data, in particular the users and their passwords, are deleted	HttpTranslate	\N
1472540056	admindb	1576768272	admindb	Fehler w??hrend des Umbenenens einer Datei		error while renaming a file	DbHttpUtilsRepository	\N
1478851338	admindb	1576768380	admindb	 Der Name existiert schon mit einem CNAME Eintrag		the name already exists with a CNAME entry	DbConnect	\N
1515145196	admindb	1576768509	admindb	Der Autoreport <%s> ist schon gestartet		auto report <%s> is running	DbHttpReport	\N
1515170898	admindb	1576768561	admindb	 Ware kann nicht in den ausgew??hlten Speicherplatz eingelagert werden		goods cannot be stored in the selected storage location	DbConnect	\N
1525695684	admindb	1576768765	admindb	Bautagebuch enth??lt 2 Eintr??ge f??r den ausgew??hlten Zeitraum - Eintrag wird nicht ver??ndert		construction diary contains 2 entries for the selected period - entry is not changed	DbConnect	\N
1530179043	admindb	1576768864	admindb	Bitte nur Buchstaben, Zahlen, den Unterstrich und den Schr??gstrich eingeben		please only enter letters, numbers, the underscore and the slash	HttpTranslate	\N
1611676719	admindb	1611676821	admindb	Server		server	HttpTranslate	0
1611676719	admindb	1611676821	admindb	Nameserver		name server	HttpTranslate	0
1611676719	admindb	1611676821	admindb	Suchdomain		search	HttpTranslate	0
1611676719	admindb	1611676821	admindb	Gateway		gateway	HttpTranslate	0
1611676719	admindb	1611676821	admindb	Lesezeit		reading time	HttpTranslate	0
1611676719	admindb	1611676821	admindb	Rechnername		Host	HttpTranslate	0
1611676719	admindb	1611676821	admindb	Schnittstelle		device	HttpTranslate	0
1611676719	admindb	1611676834	admindb	Mask		mask	HttpTranslate	0
1611676719	admindb	1611676834	admindb	Broadcast		broadcast	HttpTranslate	0
1612168974	admindb	1612169073	admindb	Meine Firma		my company	HttpTranslate	0
1612168974	admindb	1612169073	admindb	Meine Abteilung		my unit	HttpTranslate	0
1612169479	admindb	1612169625	admindb	Mein Land		my country	HttpTranslate	0
1612169479	admindb	1612169625	admindb	Meine Region		my state	HttpTranslate	0
1612169479	admindb	1612169625	admindb	Meine Stadt		my city	HttpTranslate	0
1612169479	admindb	1612169625	admindb	email@meine.domain		email@my.domain	HttpTranslate	0
1612169479	admindb	1612169625	admindb	Orgnisation		organisation	HttpTranslate	0
1612169479	admindb	1612169625	admindb	Org. Einheit		org. unit	HttpTranslate	0
1612169479	admindb	1612169625	admindb	Email		email	HttpTranslate	0
1612169479	admindb	1612169625	admindb	??berschreiben		overwrite	HttpTranslate	0
1612177135	admindb	1612177156	admindb	Falsches Password		wrong password	HttpTranslate	0
1612177169	admindb	1612177206	admindb	CA exitiert bereits		ca exists	HttpTranslate	0
1612169644	admindb	1612177212	admindb	Region		region	HttpTranslate	0
1612169100	admindb	1612177223	admindb	DNS Suchdomains		dns search	HttpTranslate	0
1612169100	admindb	1612177250	admindb	Ipv6 Addresse		ipv6 address	HttpTranslate	0
1612169100	admindb	1612177250	admindb	Ipv4 Addresse		ipv4 address	HttpTranslate	0
1612183634	admindb	1612251487	admindb	Zertifikat		certificate	HttpTranslate	0
1612187619	admindb	1612251505	admindb	Spalten stimmen nicht ??berein		cols are not equal	HttpTranslate	0
1612186843	admindb	1612251542	admindb	CA		CA	HttpTranslate	0
1612186843	admindb	1612251542	admindb	DNS		DNS	HttpTranslate	0
1612186843	admindb	1612251542	admindb	g??ltig bis		valid until	HttpTranslate	0
1612251092	admindb	1612251562	admindb	Ordner		folder	HttpTranslate	0
1612247557	admindb	1612251567	admindb	Download		download	HttpTranslate	0
1612254366	admindb	1612254366	admindb	%s %d			HttpSysexec	\N
1612261849	admindb	1612334770	admindb	Falscher Dateityp		wrong file type	HttpTranslate	0
1612263036	admindb	1612334770	admindb	Kein Zertifikat		no certificate	HttpTranslate	0
1612334280	admindb	1612334770	admindb	Port		port	HttpTranslate	0
1612334280	admindb	1612334770	admindb	Secure Port		secure port	HttpTranslate	0
1612335531	admindb	1612335531	admindb	Fehler:			HttpTranslate	\N
1612348881	admindb	1612348881	admindb	Port","			HttpTranslate	\N
1612348881	admindb	1612348881	admindb	Lesezeit" ], n  "typs"    : [ "2","2","1000" ], n  "formats" : [ "","","" ], n  "regexps" : [ "","","" ], n 1			HttpTranslate	\N
1612348881	admindb	1612348881	admindb	Lesezeit" ], n  "typs"    : [ "2","2","1000" ], n  "formats" : [ "","","" ], n  "regexps" : [ "","","" ], n			HttpTranslate	\N
1612349009	admindb	1612349009	admindb	Lesezeit" ], n  "typs"    : [ "2","2","1000" ], n  "formats" : [ "","","" ], n  "regexps" : [ "","","" ], nget_portn 1			HttpTranslate	\N
1612349009	admindb	1612349009	admindb	Lesezeit" ], n  "typs"    : [ "2","2","1000" ], n  "formats" : [ "","","" ], n  "regexps" : [ "","","" ], nget_portn			HttpTranslate	\N
1612349230	admindb	1612349230	admindb	enabled			HttpTranslate	\N
1612349230	admindb	1612349230	admindb	Aliases			HttpTranslate	\N
1612349230	admindb	1612349230	admindb	Documentroot			HttpTranslate	\N
1612349230	admindb	1612349230	admindb	Konfiguration			HttpTranslate	\N
1612349230	admindb	1612349230	admindb	httpsonly			HttpTranslate	\N
1612349230	admindb	1612349230	admindb	Name","			HttpTranslate	\N
1612349230	admindb	1612349230	admindb	Email","			HttpTranslate	\N
1612349230	admindb	1612349230	admindb	Konfiguration","			HttpTranslate	\N
1612428322	admindb	1612428322	admindb	Zertifikat erneuern			HttpTranslate	\N
1612431869	admindb	1612431869	admindb	Zertifikat erneuern" ], n  "typs"    : [ "2","2","2","2","2","2","2","2","2" ], n  "formats" : [ "","","","","","","","","" ], n  "regexps" : [ "","","notempty","","","","","","" ], n"values" : [ n 1			HttpTranslate	\N
1612431869	admindb	1612431869	admindb	Zertifikat erneuern" ], n  "typs"    : [ "2","2","2","2","2","2","2","2","2" ], n  "formats" : [ "","","","","","","","","" ], n  "regexps" : [ "","","notempty","","","","","","" ], n"values" : [ n			HttpTranslate	\N
1614074040	admindb	1614074040	admindb	Erstelle Rechnerzertifikat			HttpTranslate	\N
1612435062	admindb	1612435062	admindb	Zertifikat erneuern" ], n  "typs"    : [ "2","2","2","2","2","2","2","2","2" ], n  "formats" : [ "","","","","","","","","" ], n  "regexps" : [ "","","notempty","","","","","","" ], n/etc/apache2/sites-available/000-default-ssl.confn/etc/apache2/sites-available/000-default.confn/etc/apache2/sites-available/mne_erpnnur.confn/etc/apache2/sites-available/mne_erp.confn"values" : [ n 1			HttpTranslate	\N
1612435062	admindb	1612435062	admindb	Zertifikat erneuern" ], n  "typs"    : [ "2","2","2","2","2","2","2","2","2" ], n  "formats" : [ "","","","","","","","","" ], n  "regexps" : [ "","","notempty","","","","","","" ], n/etc/apache2/sites-available/000-default-ssl.confn/etc/apache2/sites-available/000-default.confn/etc/apache2/sites-available/mne_erpnnur.confn/etc/apache2/sites-available/mne_erp.confn"values" : [ n			HttpTranslate	\N
1612435088	admindb	1612435088	admindb	Zertifikat erneuern" ], n  "typs"    : [ "2","2","2","2","2","2","2","2","2" ], n  "formats" : [ "","","","","","","","","" ], n  "regexps" : [ "","","notempty","","","","","","" ], n/etc/apache2/sites-available/000-default-ssl.confn/etc/apache2/sites-available/000-default.confn/etc/apache2/sites-available/mne_erp nur.confn/etc/apache2/sites-available/mne_erp.confn"values" : [ n 1			HttpTranslate	\N
1612435088	admindb	1612435088	admindb	Zertifikat erneuern" ], n  "typs"    : [ "2","2","2","2","2","2","2","2","2" ], n  "formats" : [ "","","","","","","","","" ], n  "regexps" : [ "","","notempty","","","","","","" ], n/etc/apache2/sites-available/000-default-ssl.confn/etc/apache2/sites-available/000-default.confn/etc/apache2/sites-available/mne_erp nur.confn/etc/apache2/sites-available/mne_erp.confn"values" : [ n			HttpTranslate	\N
1612435110	admindb	1612435110	admindb	Zertifikat erneuern" ], n  "typs"    : [ "2","2","2","2","2","2","2","2","2" ], n  "formats" : [ "","","","","","","","","" ], n  "regexps" : [ "","","notempty","","","","","","" ], n000-default-ssl.confn000-default.confnmne_erp nur.confnmne_erp.confn"values" : [ n 1			HttpTranslate	\N
1612435110	admindb	1612435110	admindb	Zertifikat erneuern" ], n  "typs"    : [ "2","2","2","2","2","2","2","2","2" ], n  "formats" : [ "","","","","","","","","" ], n  "regexps" : [ "","","notempty","","","","","","" ], n000-default-ssl.confn000-default.confnmne_erp nur.confnmne_erp.confn"values" : [ n			HttpTranslate	\N
1612435229	admindb	1612435229	admindb	Zertifikat erneuern" ], n  "typs"    : [ "2","2","2","2","2","2","2","2","2" ], n  "formats" : [ "","","","","","","","","" ], n  "regexps" : [ "","","notempty","","","","","","" ], nttt000-default-ssl.confn000-default.confnmne_erp nur.confnmne_erp.conf....n"values" : [ n 1			HttpTranslate	\N
1612435229	admindb	1612435229	admindb	Zertifikat erneuern" ], n  "typs"    : [ "2","2","2","2","2","2","2","2","2" ], n  "formats" : [ "","","","","","","","","" ], n  "regexps" : [ "","","notempty","","","","","","" ], nttt000-default-ssl.confn000-default.confnmne_erp nur.confnmne_erp.conf....n"values" : [ n			HttpTranslate	\N
1612435433	admindb	1612435433	admindb	Zertifikat erneuern" ], n  "typs"    : [ "2","2","2","2","2","2","2","2","2" ], n  "formats" : [ "","","","","","","","","" ], n  "regexps" : [ "","","notempty","","","","","","" ], n 1			HttpTranslate	\N
1612435433	admindb	1612435433	admindb	Zertifikat erneuern" ], n  "typs"    : [ "2","2","2","2","2","2","2","2","2" ], n  "formats" : [ "","","","","","","","","" ], n  "regexps" : [ "","","notempty","","","","","","" ], n			HttpTranslate	\N
1612435907	admindb	1612435907	admindb	Zertifikat erneuern" ], n  "typs"    : [ "2","2","2","2","2","2","2","2","2" ], n  "formats" : [ "","","","","","","","","" ], n  "regexps" : [ "","","notempty","","","","","","" ], n"values" : [ n 2			HttpTranslate	\N
1612514978	admindb	1612514978	admindb	Bitte CA Password eingeben			HttpTranslate	\N
1612531451	admindb	1612531451	admindb	Bitte Password eingeben			HttpTranslate	\N
1613985977	admindb	1613985977	admindb	typ			HttpTranslate	\N
1613985977	admindb	1613985977	admindb	domain			HttpTranslate	\N
1613985977	admindb	1613985977	admindb	workgroup			HttpTranslate	\N
1613985977	admindb	1613985977	admindb	description			HttpTranslate	\N
1613985977	admindb	1613985977	admindb	netdevice			HttpTranslate	\N
1613985977	admindb	1613985977	admindb	admin			HttpTranslate	\N
1613985977	admindb	1613985977	admindb	adminpassword			HttpTranslate	\N
1613985977	admindb	1613985977	admindb	adminpassword2			HttpTranslate	\N
1613985977	admindb	1613985977	admindb	primaryname			HttpTranslate	\N
1613985977	admindb	1613985977	admindb	primaryaddr			HttpTranslate	\N
1613985977	admindb	1613985977	admindb	dnsforwarder			HttpTranslate	\N
1613985977	admindb	1613985977	admindb	dnssearch			HttpTranslate	\N
1613985977	admindb	1613985977	admindb	dhcpstart			HttpTranslate	\N
1613985977	admindb	1613985977	admindb	dhcpend			HttpTranslate	\N
1613985977	admindb	1613985977	admindb	dhcp6start			HttpTranslate	\N
1613985977	admindb	1613985977	admindb	dhcp6end			HttpTranslate	\N
1613986656	admindb	1613986656	admindb	domaintyp			HttpTranslate	\N
1613987084	admindb	1613987084	admindb	Domainname			HttpTranslate	\N
1613987084	admindb	1613987084	admindb	Workgroup			HttpTranslate	\N
1613987084	admindb	1613987084	admindb	Beschreibung			HttpTranslate	\N
1613987084	admindb	1613987084	admindb	Device			HttpTranslate	\N
1613987084	admindb	1613987084	admindb	Wiederholen			HttpTranslate	\N
1613987084	admindb	1613987084	admindb	Primary Server			HttpTranslate	\N
1613987084	admindb	1613987084	admindb	Primary Adresse			HttpTranslate	\N
1613987084	admindb	1613987084	admindb	DNS Forward			HttpTranslate	\N
1613987084	admindb	1613987084	admindb	DNS Suche			HttpTranslate	\N
1613987084	admindb	1613987084	admindb	IPv4 Start			HttpTranslate	\N
1613987084	admindb	1613987084	admindb	IPv4 Ende			HttpTranslate	\N
1613987084	admindb	1613987084	admindb	IPv6 Start			HttpTranslate	\N
1613987084	admindb	1613987084	admindb	IPv6 Ende			HttpTranslate	\N
1613988901	admindb	1613988901	admindb	Typ","			HttpTranslate	\N
1613988901	admindb	1613988901	admindb	Workgroup","			HttpTranslate	\N
1613988901	admindb	1613988901	admindb	DNS Forward","			HttpTranslate	\N
1613988901	admindb	1613988901	admindb	IPv4 Start","			HttpTranslate	\N
1613988901	admindb	1613988901	admindb	IPv6 Start","			HttpTranslate	\N
1614084027	admindb	1614084027	admindb	Workgroup"			HttpTranslate	\N
1614084027	admindb	1614084027	admindb	Beschreibung"			HttpTranslate	\N
1614084027	admindb	1614084027	admindb	Device"			HttpTranslate	\N
1614249256	admindb	1614249256	admindb	falsches Netzwerk der DHCP IPv6 Startadresse			HttpTranslate	\N
1614249265	admindb	1614249265	admindb	falsches Netzwerk der DHCP IPv6 Endadresse			HttpTranslate	\N
1614256618	admindb	1614256618	admindb	Wiederholen","			HttpTranslate	\N
1614256618	admindb	1614256618	admindb	Primary Adresse","			HttpTranslate	\N
1614256618	admindb	1614256618	admindb	DNS Suche","			HttpTranslate	\N
1614256618	admindb	1614256618	admindb	IPv4 Ende","			HttpTranslate	\N
1614256618	admindb	1614256618	admindb	IPv6 Ende" ], n  "typs"    : [ "2","2","2","2","2","2","2","2","2","2","2","2","2","2","2" ], n  "formats" : [ "","","","","","","","","","","","","","","" ], n  "regexps" : [ "","","","","","notempty","","","ipaddrempty","","","ip4addrempty","ip4addrempty","ip6addrempty","ip6addrempty" ], n 1			HttpTranslate	\N
1614256618	admindb	1614256618	admindb	IPv6 Ende" ], n  "typs"    : [ "2","2","2","2","2","2","2","2","2","2","2","2","2","2","2" ], n  "formats" : [ "","","","","","","","","","","","","","","" ], n  "regexps" : [ "","","","","","notempty","","","ipaddrempty","","","ip4addrempty","ip4addrempty","ip6addrempty","ip6addrempty" ], n			HttpTranslate	\N
1614583129	admindb	1614583129	admindb	Netzwerk ??bernehmen			HttpTranslate	\N
1614591493	admindb	1614591493	admindb	Addresstyp			HttpTranslate	\N
1614591493	admindb	1614591493	admindb	Adresse			HttpTranslate	\N
1614591493	admindb	1614591493	admindb	Adresse" ], n  "typs"    : [ "2","2","2" ], n  "formats" : [ "","","" ], n  "regexps" : [ "","","" ], n  "values"  : [ n 1			HttpTranslate	\N
1614591493	admindb	1614591493	admindb	Adresse" ], n  "typs"    : [ "2","2","2" ], n  "formats" : [ "","","" ], n  "regexps" : [ "","","" ], n  "values"  : [ n			HttpTranslate	\N
1614591685	admindb	1614591685	admindb	Adresse" ], n  "typs"    : [ "2","2","2" ], n  "formats" : [ "","","" ], n  "regexps" : [ "","","" ], n  "values"  : [ ]n 1			HttpTranslate	\N
1614591685	admindb	1614591685	admindb	Adresse" ], n  "typs"    : [ "2","2","2" ], n  "formats" : [ "","","" ], n  "regexps" : [ "","","" ], n  "values"  : [ ]n			HttpTranslate	\N
1614593952	admindb	1614593952	admindb	Gelesen am			HttpTranslate	\N
1614604505	admindb	1614604505	admindb	 Kann Addresse nicht hinzuf??gen			HttpTranslate	\N
1614610149	admindb	1614610149	admindb	Server","			HttpTranslate	\N
1614610149	admindb	1614610149	admindb	Nameserver","			HttpTranslate	\N
1614610149	admindb	1614610149	admindb	Gateway","			HttpTranslate	\N
1614694647	admindb	1614694647	admindb	HW Adresse			HttpTranslate	\N
1614695164	admindb	1614695164	admindb	feste Adresse			HttpTranslate	\N
1614697793	admindb	1614697793	admindb	HW Address unterschiedlich			HttpTranslate	\N
1615185698	admindb	1615185698	admindb	Name als Maildaddresse			HttpTranslate	\N
1615185698	admindb	1615185698	admindb	Mail Relay Sever			HttpTranslate	\N
1615185698	admindb	1615185698	admindb	 Mail Relay User			HttpTranslate	\N
1615185698	admindb	1615185698	admindb	 Mail Relay Password			HttpTranslate	\N
1615272922	admindb	1615272922	admindb	Login			HttpTranslate	\N
1615273025	admindb	1615273025	admindb	Test			HttpTranslate	\N
1615278368	admindb	1615278368	admindb	Vorname			HttpTranslate	\N
1615278368	admindb	1615278368	admindb	Nachname			HttpTranslate	\N
1615278368	admindb	1615278368	admindb	Strasse			HttpTranslate	\N
1615278368	admindb	1615278368	admindb	Postfach			HttpTranslate	\N
1615278368	admindb	1615278368	admindb	Ort			HttpTranslate	\N
1615278368	admindb	1615278368	admindb	K??rzel			HttpTranslate	\N
1615278368	admindb	1615278368	admindb	Fon priv			HttpTranslate	\N
1615278368	admindb	1615278368	admindb	Fon gesch			HttpTranslate	\N
1615278368	admindb	1615278368	admindb	Fon mobil			HttpTranslate	\N
1615278368	admindb	1615278368	admindb	http			HttpTranslate	\N
1615278368	admindb	1615278368	admindb	PLZ			HttpTranslate	\N
1615283468	admindb	1615283468	admindb	Administrator Password			HttpTranslate	\N
1615458907	admindb	1615458907	admindb	Uid			HttpTranslate	\N
1615458907	admindb	1615458907	admindb	Gid			HttpTranslate	\N
1615458907	admindb	1615458907	admindb	Homedir			HttpTranslate	\N
1615458907	admindb	1615458907	admindb	Login Shell			HttpTranslate	\N
1615459167	admindb	1615459167	admindb	Unix Attribute			HttpTranslate	\N
1615802457	admindb	1615802457	admindb	Gruppe umbenennen nicht m??glich			HttpTranslate	\N
1615882233	admindb	1615882233	admindb	Email Addresse			HttpTranslate	\N
1615898677	admindb	1615898677	admindb	Schl??ssel l??schen			HttpTranslate	\N
1616063307	admindb	1616063307	admindb	AD Domain ist nicht eingerichtet			HttpTranslate	\N
1616063355	admindb	1616063355	admindb	Bitte Mail Relay Password eingeben			HttpTranslate	\N
1616063497	admindb	1616063497	admindb	Benutze altes Mail Relay Password			HttpTranslate	\N
1616148908	admindb	1616148908	admindb	Freigabe			HttpTranslate	\N
1616151102	admindb	1616151102	admindb	Nur Lesen			HttpTranslate	\N
1616404644	admindb	1616404644	admindb	Aktion			HttpTranslate	\N
1616404644	admindb	1616404644	admindb	Item			HttpTranslate	\N
1616404644	admindb	1616404644	admindb	Menuid			HttpTranslate	\N
1616508459	admindb	1616508459	admindb	Bitte 2 stelliges Landeskenzeichen eingeben			HttpTranslate	\N
1616578525	admindb	1616578525	admindb	Ordner ist nicht korrekt			HttpTranslate	\N
1616581866	admindb	1616581866	admindb	Nur lesend			HttpTranslate	\N
1616658432	admindb	1616658432	admindb	Schl??ssel			HttpTranslate	\N
1616741111	admindb	1616741111	admindb	Schreibzugriff			HttpTranslate	\N
1620308999	admindb	1620308999	admindb	Prim??rer CA			HttpTranslate	\N
1620308999	admindb	1620308999	admindb	CA Daten			HttpTranslate	\N
1620367076	admindb	1620367076	admindb	Fehler w??hrend des Signierens			HttpTranslate	\N
1620367416	admindb	1620367416	admindb	File scheint kein Zertifikatrequest zu sein			HttpTranslate	\N
1620373846	admindb	1620373846	admindb	Request geh??rt nicht zum Schl??ssel			HttpTranslate	\N
1649917445	admindb	1649917445	admindb	Bitte auf dem Hauptrechner zertifizieren			HttpTranslate	\N
1649917863	admindb	1649917863	admindb	Addresstyp"			HttpTranslate	\N
1649917863	admindb	1649917863	admindb	Adresse"			HttpTranslate	\N
1649917863	admindb	1649917863	admindb	feste Adresse"			HttpTranslate	\N
1649917863	admindb	1649917863	admindb	HW Adresse"			HttpTranslate	\N
1649917863	admindb	1649917863	admindb	Komentar"			HttpTranslate	\N
1649917863	admindb	1649917863	admindb	Gelesen am"			HttpTranslate	\N
1649917863	admindb	1649917863	admindb	HW Address unterschiedlich"			HttpTranslate	\N
1649929138	admindb	1649929138	admindb	WLan			HttpTranslate	\N
1649929138	admindb	1649929138	admindb	versteckt			HttpTranslate	\N
\.


--
-- Data for Name: trustrequest; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.trustrequest (createdate, createuser, modifydate, modifyuser, trustrequestid, action, ipaddr, name, typ, custom, validpar) FROM stdin;
\.


--
-- Data for Name: update; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.update (updateid, version, updatehost) FROM stdin;
0	12	update.nelson-it.ch
\.


--
-- Data for Name: userpref; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.userpref (createdate, createuser, modifydate, modifyuser, username, language, timezone, stylename, countrycarcode, startweblet, region, mslanguage, debug, exportencoding) FROM stdin;
1319441942	admindb	1626252334	admindb	admindb	de	MET	large	CH	user_settings	DE	deu	1	utf-8
\.


--
-- Data for Name: usertables; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.usertables (text_de, schemaname, tablename, text_en, createuser, modifyuser, createdate, modifydate) FROM stdin;
\.


--
-- Data for Name: year; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.year (yearmin, yearmax, yearid, createuser, modifyuser, createdate, modifydate) FROM stdin;
2021	2023	0	admindb	admindb	1522155360	1522155360
\.


--
-- Data for Name: yearday; Type: TABLE DATA; Schema: mne_application; Owner: admindb
--

COPY mne_application.yearday (leapyear, vyear, vquarter, vmonth, vday, wday, vfullday, createuser, modifyuser, createdate, modifydate) FROM stdin;
f	2021	1	1	1	6	01012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	2	7	02012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	3	1	03012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	4	2	04012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	5	3	05012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	6	4	06012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	7	5	07012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	8	6	08012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	9	7	09012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	10	1	10012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	11	2	11012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	12	3	12012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	13	4	13012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	14	5	14012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	15	6	15012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	16	7	16012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	17	1	17012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	18	2	18012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	19	3	19012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	20	4	20012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	21	5	21012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	22	6	22012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	23	7	23012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	24	1	24012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	25	2	25012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	26	3	26012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	27	4	27012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	28	5	28012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	29	6	29012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	30	7	30012021	admindb	admindb	1653294601	1653294601
f	2021	1	1	31	1	31012021	admindb	admindb	1653294601	1653294601
f	2021	1	2	1	2	01022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	2	3	02022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	3	4	03022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	4	5	04022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	5	6	05022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	6	7	06022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	7	1	07022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	8	2	08022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	9	3	09022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	10	4	10022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	11	5	11022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	12	6	12022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	13	7	13022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	14	1	14022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	15	2	15022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	16	3	16022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	17	4	17022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	18	5	18022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	19	6	19022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	20	7	20022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	21	1	21022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	22	2	22022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	23	3	23022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	24	4	24022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	25	5	25022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	26	6	26022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	27	7	27022021	admindb	admindb	1653294601	1653294601
f	2021	1	2	28	1	28022021	admindb	admindb	1653294601	1653294601
f	2021	1	3	1	2	01032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	2	3	02032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	3	4	03032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	4	5	04032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	5	6	05032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	6	7	06032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	7	1	07032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	8	2	08032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	9	3	09032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	10	4	10032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	11	5	11032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	12	6	12032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	13	7	13032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	14	1	14032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	15	2	15032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	16	3	16032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	17	4	17032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	18	5	18032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	19	6	19032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	20	7	20032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	21	1	21032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	22	2	22032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	23	3	23032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	24	4	24032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	25	5	25032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	26	6	26032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	27	7	27032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	28	1	28032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	29	2	29032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	30	3	30032021	admindb	admindb	1653294601	1653294601
f	2021	1	3	31	4	31032021	admindb	admindb	1653294601	1653294601
f	2021	2	4	1	5	01042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	2	6	02042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	3	7	03042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	4	1	04042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	5	2	05042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	6	3	06042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	7	4	07042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	8	5	08042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	9	6	09042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	10	7	10042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	11	1	11042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	12	2	12042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	13	3	13042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	14	4	14042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	15	5	15042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	16	6	16042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	17	7	17042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	18	1	18042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	19	2	19042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	20	3	20042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	21	4	21042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	22	5	22042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	23	6	23042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	24	7	24042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	25	1	25042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	26	2	26042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	27	3	27042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	28	4	28042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	29	5	29042021	admindb	admindb	1653294601	1653294601
f	2021	2	4	30	6	30042021	admindb	admindb	1653294601	1653294601
f	2021	2	5	1	7	01052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	2	1	02052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	3	2	03052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	4	3	04052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	5	4	05052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	6	5	06052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	7	6	07052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	8	7	08052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	9	1	09052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	10	2	10052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	11	3	11052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	12	4	12052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	13	5	13052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	14	6	14052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	15	7	15052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	16	1	16052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	17	2	17052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	18	3	18052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	19	4	19052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	20	5	20052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	21	6	21052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	22	7	22052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	23	1	23052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	24	2	24052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	25	3	25052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	26	4	26052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	27	5	27052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	28	6	28052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	29	7	29052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	30	1	30052021	admindb	admindb	1653294601	1653294601
f	2021	2	5	31	2	31052021	admindb	admindb	1653294601	1653294601
f	2021	2	6	1	3	01062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	2	4	02062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	3	5	03062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	4	6	04062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	5	7	05062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	6	1	06062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	7	2	07062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	8	3	08062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	9	4	09062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	10	5	10062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	11	6	11062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	12	7	12062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	13	1	13062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	14	2	14062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	15	3	15062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	16	4	16062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	17	5	17062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	18	6	18062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	19	7	19062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	20	1	20062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	21	2	21062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	22	3	22062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	23	4	23062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	24	5	24062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	25	6	25062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	26	7	26062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	27	1	27062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	28	2	28062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	29	3	29062021	admindb	admindb	1653294601	1653294601
f	2021	2	6	30	4	30062021	admindb	admindb	1653294601	1653294601
f	2021	3	7	1	5	01072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	2	6	02072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	3	7	03072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	4	1	04072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	5	2	05072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	6	3	06072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	7	4	07072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	8	5	08072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	9	6	09072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	10	7	10072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	11	1	11072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	12	2	12072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	13	3	13072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	14	4	14072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	15	5	15072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	16	6	16072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	17	7	17072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	18	1	18072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	19	2	19072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	20	3	20072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	21	4	21072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	22	5	22072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	23	6	23072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	24	7	24072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	25	1	25072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	26	2	26072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	27	3	27072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	28	4	28072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	29	5	29072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	30	6	30072021	admindb	admindb	1653294601	1653294601
f	2021	3	7	31	7	31072021	admindb	admindb	1653294601	1653294601
f	2021	3	8	1	1	01082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	2	2	02082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	3	3	03082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	4	4	04082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	5	5	05082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	6	6	06082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	7	7	07082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	8	1	08082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	9	2	09082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	10	3	10082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	11	4	11082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	12	5	12082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	13	6	13082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	14	7	14082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	15	1	15082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	16	2	16082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	17	3	17082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	18	4	18082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	19	5	19082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	20	6	20082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	21	7	21082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	22	1	22082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	23	2	23082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	24	3	24082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	25	4	25082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	26	5	26082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	27	6	27082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	28	7	28082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	29	1	29082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	30	2	30082021	admindb	admindb	1653294601	1653294601
f	2021	3	8	31	3	31082021	admindb	admindb	1653294601	1653294601
f	2021	3	9	1	4	01092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	2	5	02092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	3	6	03092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	4	7	04092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	5	1	05092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	6	2	06092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	7	3	07092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	8	4	08092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	9	5	09092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	10	6	10092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	11	7	11092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	12	1	12092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	13	2	13092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	14	3	14092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	15	4	15092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	16	5	16092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	17	6	17092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	18	7	18092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	19	1	19092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	20	2	20092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	21	3	21092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	22	4	22092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	23	5	23092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	24	6	24092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	25	7	25092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	26	1	26092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	27	2	27092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	28	3	28092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	29	4	29092021	admindb	admindb	1653294601	1653294601
f	2021	3	9	30	5	30092021	admindb	admindb	1653294601	1653294601
f	2021	4	10	1	6	01102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	2	7	02102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	3	1	03102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	4	2	04102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	5	3	05102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	6	4	06102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	7	5	07102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	8	6	08102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	9	7	09102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	10	1	10102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	11	2	11102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	12	3	12102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	13	4	13102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	14	5	14102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	15	6	15102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	16	7	16102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	17	1	17102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	18	2	18102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	19	3	19102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	20	4	20102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	21	5	21102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	22	6	22102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	23	7	23102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	24	1	24102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	25	2	25102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	26	3	26102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	27	4	27102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	28	5	28102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	29	6	29102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	30	7	30102021	admindb	admindb	1653294601	1653294601
f	2021	4	10	31	1	31102021	admindb	admindb	1653294601	1653294601
f	2021	4	11	1	2	01112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	2	3	02112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	3	4	03112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	4	5	04112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	5	6	05112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	6	7	06112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	7	1	07112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	8	2	08112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	9	3	09112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	10	4	10112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	11	5	11112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	12	6	12112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	13	7	13112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	14	1	14112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	15	2	15112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	16	3	16112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	17	4	17112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	18	5	18112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	19	6	19112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	20	7	20112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	21	1	21112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	22	2	22112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	23	3	23112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	24	4	24112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	25	5	25112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	26	6	26112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	27	7	27112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	28	1	28112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	29	2	29112021	admindb	admindb	1653294601	1653294601
f	2021	4	11	30	3	30112021	admindb	admindb	1653294601	1653294601
f	2021	4	12	1	4	01122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	2	5	02122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	3	6	03122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	4	7	04122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	5	1	05122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	6	2	06122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	7	3	07122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	8	4	08122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	9	5	09122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	10	6	10122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	11	7	11122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	12	1	12122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	13	2	13122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	14	3	14122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	15	4	15122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	16	5	16122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	17	6	17122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	18	7	18122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	19	1	19122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	20	2	20122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	21	3	21122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	22	4	22122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	23	5	23122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	24	6	24122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	25	7	25122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	26	1	26122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	27	2	27122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	28	3	28122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	29	4	29122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	30	5	30122021	admindb	admindb	1653294601	1653294601
f	2021	4	12	31	6	31122021	admindb	admindb	1653294601	1653294601
f	2022	1	1	1	7	01012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	2	1	02012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	3	2	03012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	4	3	04012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	5	4	05012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	6	5	06012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	7	6	07012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	8	7	08012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	9	1	09012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	10	2	10012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	11	3	11012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	12	4	12012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	13	5	13012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	14	6	14012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	15	7	15012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	16	1	16012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	17	2	17012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	18	3	18012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	19	4	19012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	20	5	20012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	21	6	21012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	22	7	22012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	23	1	23012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	24	2	24012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	25	3	25012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	26	4	26012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	27	5	27012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	28	6	28012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	29	7	29012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	30	1	30012022	admindb	admindb	1653294601	1653294601
f	2022	1	1	31	2	31012022	admindb	admindb	1653294601	1653294601
f	2022	1	2	1	3	01022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	2	4	02022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	3	5	03022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	4	6	04022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	5	7	05022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	6	1	06022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	7	2	07022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	8	3	08022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	9	4	09022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	10	5	10022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	11	6	11022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	12	7	12022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	13	1	13022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	14	2	14022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	15	3	15022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	16	4	16022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	17	5	17022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	18	6	18022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	19	7	19022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	20	1	20022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	21	2	21022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	22	3	22022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	23	4	23022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	24	5	24022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	25	6	25022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	26	7	26022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	27	1	27022022	admindb	admindb	1653294601	1653294601
f	2022	1	2	28	2	28022022	admindb	admindb	1653294601	1653294601
f	2022	1	3	1	3	01032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	2	4	02032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	3	5	03032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	4	6	04032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	5	7	05032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	6	1	06032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	7	2	07032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	8	3	08032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	9	4	09032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	10	5	10032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	11	6	11032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	12	7	12032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	13	1	13032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	14	2	14032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	15	3	15032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	16	4	16032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	17	5	17032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	18	6	18032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	19	7	19032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	20	1	20032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	21	2	21032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	22	3	22032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	23	4	23032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	24	5	24032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	25	6	25032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	26	7	26032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	27	1	27032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	28	2	28032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	29	3	29032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	30	4	30032022	admindb	admindb	1653294601	1653294601
f	2022	1	3	31	5	31032022	admindb	admindb	1653294601	1653294601
f	2022	2	4	1	6	01042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	2	7	02042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	3	1	03042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	4	2	04042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	5	3	05042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	6	4	06042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	7	5	07042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	8	6	08042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	9	7	09042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	10	1	10042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	11	2	11042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	12	3	12042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	13	4	13042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	14	5	14042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	15	6	15042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	16	7	16042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	17	1	17042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	18	2	18042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	19	3	19042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	20	4	20042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	21	5	21042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	22	6	22042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	23	7	23042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	24	1	24042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	25	2	25042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	26	3	26042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	27	4	27042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	28	5	28042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	29	6	29042022	admindb	admindb	1653294601	1653294601
f	2022	2	4	30	7	30042022	admindb	admindb	1653294601	1653294601
f	2022	2	5	1	1	01052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	2	2	02052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	3	3	03052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	4	4	04052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	5	5	05052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	6	6	06052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	7	7	07052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	8	1	08052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	9	2	09052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	10	3	10052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	11	4	11052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	12	5	12052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	13	6	13052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	14	7	14052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	15	1	15052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	16	2	16052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	17	3	17052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	18	4	18052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	19	5	19052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	20	6	20052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	21	7	21052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	22	1	22052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	23	2	23052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	24	3	24052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	25	4	25052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	26	5	26052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	27	6	27052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	28	7	28052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	29	1	29052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	30	2	30052022	admindb	admindb	1653294601	1653294601
f	2022	2	5	31	3	31052022	admindb	admindb	1653294601	1653294601
f	2022	2	6	1	4	01062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	2	5	02062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	3	6	03062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	4	7	04062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	5	1	05062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	6	2	06062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	7	3	07062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	8	4	08062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	9	5	09062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	10	6	10062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	11	7	11062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	12	1	12062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	13	2	13062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	14	3	14062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	15	4	15062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	16	5	16062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	17	6	17062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	18	7	18062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	19	1	19062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	20	2	20062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	21	3	21062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	22	4	22062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	23	5	23062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	24	6	24062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	25	7	25062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	26	1	26062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	27	2	27062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	28	3	28062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	29	4	29062022	admindb	admindb	1653294601	1653294601
f	2022	2	6	30	5	30062022	admindb	admindb	1653294601	1653294601
f	2022	3	7	1	6	01072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	2	7	02072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	3	1	03072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	4	2	04072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	5	3	05072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	6	4	06072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	7	5	07072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	8	6	08072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	9	7	09072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	10	1	10072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	11	2	11072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	12	3	12072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	13	4	13072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	14	5	14072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	15	6	15072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	16	7	16072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	17	1	17072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	18	2	18072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	19	3	19072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	20	4	20072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	21	5	21072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	22	6	22072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	23	7	23072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	24	1	24072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	25	2	25072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	26	3	26072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	27	4	27072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	28	5	28072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	29	6	29072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	30	7	30072022	admindb	admindb	1653294601	1653294601
f	2022	3	7	31	1	31072022	admindb	admindb	1653294601	1653294601
f	2022	3	8	1	2	01082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	2	3	02082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	3	4	03082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	4	5	04082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	5	6	05082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	6	7	06082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	7	1	07082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	8	2	08082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	9	3	09082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	10	4	10082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	11	5	11082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	12	6	12082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	13	7	13082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	14	1	14082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	15	2	15082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	16	3	16082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	17	4	17082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	18	5	18082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	19	6	19082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	20	7	20082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	21	1	21082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	22	2	22082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	23	3	23082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	24	4	24082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	25	5	25082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	26	6	26082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	27	7	27082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	28	1	28082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	29	2	29082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	30	3	30082022	admindb	admindb	1653294601	1653294601
f	2022	3	8	31	4	31082022	admindb	admindb	1653294601	1653294601
f	2022	3	9	1	5	01092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	2	6	02092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	3	7	03092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	4	1	04092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	5	2	05092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	6	3	06092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	7	4	07092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	8	5	08092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	9	6	09092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	10	7	10092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	11	1	11092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	12	2	12092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	13	3	13092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	14	4	14092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	15	5	15092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	16	6	16092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	17	7	17092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	18	1	18092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	19	2	19092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	20	3	20092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	21	4	21092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	22	5	22092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	23	6	23092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	24	7	24092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	25	1	25092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	26	2	26092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	27	3	27092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	28	4	28092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	29	5	29092022	admindb	admindb	1653294601	1653294601
f	2022	3	9	30	6	30092022	admindb	admindb	1653294601	1653294601
f	2022	4	10	1	7	01102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	2	1	02102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	3	2	03102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	4	3	04102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	5	4	05102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	6	5	06102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	7	6	07102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	8	7	08102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	9	1	09102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	10	2	10102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	11	3	11102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	12	4	12102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	13	5	13102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	14	6	14102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	15	7	15102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	16	1	16102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	17	2	17102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	18	3	18102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	19	4	19102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	20	5	20102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	21	6	21102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	22	7	22102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	23	1	23102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	24	2	24102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	25	3	25102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	26	4	26102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	27	5	27102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	28	6	28102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	29	7	29102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	30	1	30102022	admindb	admindb	1653294601	1653294601
f	2022	4	10	31	2	31102022	admindb	admindb	1653294601	1653294601
f	2022	4	11	1	3	01112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	2	4	02112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	3	5	03112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	4	6	04112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	5	7	05112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	6	1	06112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	7	2	07112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	8	3	08112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	9	4	09112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	10	5	10112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	11	6	11112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	12	7	12112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	13	1	13112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	14	2	14112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	15	3	15112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	16	4	16112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	17	5	17112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	18	6	18112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	19	7	19112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	20	1	20112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	21	2	21112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	22	3	22112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	23	4	23112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	24	5	24112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	25	6	25112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	26	7	26112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	27	1	27112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	28	2	28112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	29	3	29112022	admindb	admindb	1653294601	1653294601
f	2022	4	11	30	4	30112022	admindb	admindb	1653294601	1653294601
f	2022	4	12	1	5	01122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	2	6	02122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	3	7	03122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	4	1	04122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	5	2	05122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	6	3	06122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	7	4	07122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	8	5	08122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	9	6	09122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	10	7	10122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	11	1	11122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	12	2	12122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	13	3	13122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	14	4	14122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	15	5	15122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	16	6	16122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	17	7	17122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	18	1	18122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	19	2	19122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	20	3	20122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	21	4	21122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	22	5	22122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	23	6	23122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	24	7	24122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	25	1	25122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	26	2	26122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	27	3	27122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	28	4	28122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	29	5	29122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	30	6	30122022	admindb	admindb	1653294601	1653294601
f	2022	4	12	31	7	31122022	admindb	admindb	1653294601	1653294601
f	2023	1	1	1	1	01012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	2	2	02012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	3	3	03012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	4	4	04012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	5	5	05012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	6	6	06012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	7	7	07012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	8	1	08012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	9	2	09012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	10	3	10012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	11	4	11012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	12	5	12012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	13	6	13012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	14	7	14012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	15	1	15012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	16	2	16012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	17	3	17012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	18	4	18012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	19	5	19012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	20	6	20012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	21	7	21012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	22	1	22012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	23	2	23012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	24	3	24012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	25	4	25012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	26	5	26012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	27	6	27012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	28	7	28012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	29	1	29012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	30	2	30012023	admindb	admindb	1653294601	1653294601
f	2023	1	1	31	3	31012023	admindb	admindb	1653294601	1653294601
f	2023	1	2	1	4	01022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	2	5	02022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	3	6	03022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	4	7	04022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	5	1	05022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	6	2	06022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	7	3	07022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	8	4	08022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	9	5	09022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	10	6	10022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	11	7	11022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	12	1	12022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	13	2	13022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	14	3	14022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	15	4	15022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	16	5	16022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	17	6	17022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	18	7	18022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	19	1	19022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	20	2	20022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	21	3	21022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	22	4	22022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	23	5	23022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	24	6	24022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	25	7	25022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	26	1	26022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	27	2	27022023	admindb	admindb	1653294601	1653294601
f	2023	1	2	28	3	28022023	admindb	admindb	1653294601	1653294601
f	2023	1	3	1	4	01032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	2	5	02032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	3	6	03032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	4	7	04032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	5	1	05032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	6	2	06032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	7	3	07032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	8	4	08032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	9	5	09032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	10	6	10032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	11	7	11032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	12	1	12032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	13	2	13032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	14	3	14032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	15	4	15032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	16	5	16032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	17	6	17032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	18	7	18032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	19	1	19032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	20	2	20032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	21	3	21032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	22	4	22032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	23	5	23032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	24	6	24032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	25	7	25032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	26	1	26032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	27	2	27032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	28	3	28032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	29	4	29032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	30	5	30032023	admindb	admindb	1653294601	1653294601
f	2023	1	3	31	6	31032023	admindb	admindb	1653294601	1653294601
f	2023	2	4	1	7	01042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	2	1	02042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	3	2	03042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	4	3	04042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	5	4	05042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	6	5	06042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	7	6	07042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	8	7	08042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	9	1	09042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	10	2	10042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	11	3	11042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	12	4	12042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	13	5	13042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	14	6	14042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	15	7	15042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	16	1	16042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	17	2	17042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	18	3	18042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	19	4	19042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	20	5	20042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	21	6	21042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	22	7	22042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	23	1	23042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	24	2	24042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	25	3	25042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	26	4	26042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	27	5	27042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	28	6	28042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	29	7	29042023	admindb	admindb	1653294601	1653294601
f	2023	2	4	30	1	30042023	admindb	admindb	1653294601	1653294601
f	2023	2	5	1	2	01052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	2	3	02052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	3	4	03052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	4	5	04052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	5	6	05052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	6	7	06052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	7	1	07052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	8	2	08052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	9	3	09052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	10	4	10052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	11	5	11052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	12	6	12052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	13	7	13052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	14	1	14052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	15	2	15052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	16	3	16052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	17	4	17052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	18	5	18052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	19	6	19052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	20	7	20052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	21	1	21052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	22	2	22052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	23	3	23052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	24	4	24052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	25	5	25052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	26	6	26052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	27	7	27052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	28	1	28052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	29	2	29052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	30	3	30052023	admindb	admindb	1653294601	1653294601
f	2023	2	5	31	4	31052023	admindb	admindb	1653294601	1653294601
f	2023	2	6	1	5	01062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	2	6	02062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	3	7	03062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	4	1	04062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	5	2	05062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	6	3	06062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	7	4	07062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	8	5	08062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	9	6	09062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	10	7	10062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	11	1	11062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	12	2	12062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	13	3	13062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	14	4	14062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	15	5	15062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	16	6	16062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	17	7	17062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	18	1	18062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	19	2	19062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	20	3	20062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	21	4	21062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	22	5	22062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	23	6	23062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	24	7	24062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	25	1	25062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	26	2	26062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	27	3	27062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	28	4	28062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	29	5	29062023	admindb	admindb	1653294601	1653294601
f	2023	2	6	30	6	30062023	admindb	admindb	1653294601	1653294601
f	2023	3	7	1	7	01072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	2	1	02072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	3	2	03072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	4	3	04072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	5	4	05072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	6	5	06072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	7	6	07072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	8	7	08072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	9	1	09072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	10	2	10072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	11	3	11072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	12	4	12072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	13	5	13072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	14	6	14072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	15	7	15072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	16	1	16072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	17	2	17072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	18	3	18072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	19	4	19072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	20	5	20072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	21	6	21072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	22	7	22072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	23	1	23072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	24	2	24072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	25	3	25072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	26	4	26072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	27	5	27072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	28	6	28072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	29	7	29072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	30	1	30072023	admindb	admindb	1653294601	1653294601
f	2023	3	7	31	2	31072023	admindb	admindb	1653294601	1653294601
f	2023	3	8	1	3	01082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	2	4	02082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	3	5	03082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	4	6	04082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	5	7	05082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	6	1	06082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	7	2	07082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	8	3	08082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	9	4	09082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	10	5	10082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	11	6	11082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	12	7	12082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	13	1	13082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	14	2	14082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	15	3	15082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	16	4	16082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	17	5	17082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	18	6	18082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	19	7	19082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	20	1	20082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	21	2	21082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	22	3	22082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	23	4	23082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	24	5	24082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	25	6	25082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	26	7	26082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	27	1	27082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	28	2	28082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	29	3	29082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	30	4	30082023	admindb	admindb	1653294601	1653294601
f	2023	3	8	31	5	31082023	admindb	admindb	1653294601	1653294601
f	2023	3	9	1	6	01092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	2	7	02092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	3	1	03092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	4	2	04092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	5	3	05092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	6	4	06092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	7	5	07092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	8	6	08092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	9	7	09092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	10	1	10092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	11	2	11092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	12	3	12092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	13	4	13092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	14	5	14092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	15	6	15092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	16	7	16092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	17	1	17092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	18	2	18092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	19	3	19092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	20	4	20092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	21	5	21092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	22	6	22092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	23	7	23092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	24	1	24092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	25	2	25092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	26	3	26092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	27	4	27092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	28	5	28092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	29	6	29092023	admindb	admindb	1653294601	1653294601
f	2023	3	9	30	7	30092023	admindb	admindb	1653294601	1653294601
f	2023	4	10	1	1	01102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	2	2	02102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	3	3	03102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	4	4	04102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	5	5	05102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	6	6	06102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	7	7	07102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	8	1	08102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	9	2	09102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	10	3	10102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	11	4	11102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	12	5	12102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	13	6	13102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	14	7	14102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	15	1	15102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	16	2	16102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	17	3	17102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	18	4	18102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	19	5	19102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	20	6	20102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	21	7	21102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	22	1	22102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	23	2	23102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	24	3	24102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	25	4	25102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	26	5	26102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	27	6	27102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	28	7	28102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	29	1	29102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	30	2	30102023	admindb	admindb	1653294601	1653294601
f	2023	4	10	31	3	31102023	admindb	admindb	1653294601	1653294601
f	2023	4	11	1	4	01112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	2	5	02112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	3	6	03112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	4	7	04112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	5	1	05112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	6	2	06112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	7	3	07112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	8	4	08112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	9	5	09112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	10	6	10112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	11	7	11112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	12	1	12112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	13	2	13112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	14	3	14112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	15	4	15112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	16	5	16112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	17	6	17112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	18	7	18112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	19	1	19112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	20	2	20112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	21	3	21112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	22	4	22112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	23	5	23112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	24	6	24112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	25	7	25112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	26	1	26112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	27	2	27112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	28	3	28112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	29	4	29112023	admindb	admindb	1653294601	1653294601
f	2023	4	11	30	5	30112023	admindb	admindb	1653294601	1653294601
f	2023	4	12	1	6	01122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	2	7	02122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	3	1	03122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	4	2	04122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	5	3	05122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	6	4	06122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	7	5	07122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	8	6	08122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	9	7	09122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	10	1	10122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	11	2	11122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	12	3	12122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	13	4	13122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	14	5	14122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	15	6	15122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	16	7	16122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	17	1	17122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	18	2	18122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	19	3	19122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	20	4	20122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	21	5	21122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	22	6	22122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	23	7	23122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	24	1	24122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	25	2	25122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	26	3	26122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	27	4	27122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	28	5	28122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	29	6	29122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	30	7	30122023	admindb	admindb	1653294601	1653294601
f	2023	4	12	31	1	31122023	admindb	admindb	1653294601	1653294601
\.


--
-- Data for Name: id_count; Type: TABLE DATA; Schema: mne_catalog; Owner: admindb
--

COPY mne_catalog.id_count (index, id, lasttime) FROM stdin;
0	32768	1616741328
\.


--
-- Data for Name: uuid; Type: TABLE DATA; Schema: mne_catalog; Owner: admindb
--

COPY mne_catalog.uuid (uuid, uuidid) FROM stdin;
\.


--
-- Name: sogo_folder_info_c_folder_id_seq; Type: SEQUENCE SET; Schema: ext_sogo; Owner: sogogaia
--

SELECT pg_catalog.setval('ext_sogo.sogo_folder_info_c_folder_id_seq', 4, true);


--
-- Name: sogo_cache_folder_manny sogo_cache_folder_manny_pkey; Type: CONSTRAINT; Schema: ext_sogo; Owner: sogogaia
--

ALTER TABLE ONLY ext_sogo.sogo_cache_folder_manny
    ADD CONSTRAINT sogo_cache_folder_manny_pkey PRIMARY KEY (c_path);


--
-- Name: sogo_folder_info sogo_folder_info_pkey; Type: CONSTRAINT; Schema: ext_sogo; Owner: sogogaia
--

ALTER TABLE ONLY ext_sogo.sogo_folder_info
    ADD CONSTRAINT sogo_folder_info_pkey PRIMARY KEY (c_path);


--
-- Name: sogo_sessions_folder sogo_sessions_folder_pkey; Type: CONSTRAINT; Schema: ext_sogo; Owner: sogogaia
--

ALTER TABLE ONLY ext_sogo.sogo_sessions_folder
    ADD CONSTRAINT sogo_sessions_folder_pkey PRIMARY KEY (c_id);


--
-- Name: sogo_user_profile sogo_user_profile_pkey; Type: CONSTRAINT; Schema: ext_sogo; Owner: sogogaia
--

ALTER TABLE ONLY ext_sogo.sogo_user_profile
    ADD CONSTRAINT sogo_user_profile_pkey PRIMARY KEY (c_uid);


--
-- Name: sogomanny0012a410d78 sogomanny0012a410d78_pkey; Type: CONSTRAINT; Schema: ext_sogo; Owner: sogogaia
--

ALTER TABLE ONLY ext_sogo.sogomanny0012a410d78
    ADD CONSTRAINT sogomanny0012a410d78_pkey PRIMARY KEY (c_name);


--
-- Name: sogomanny0012a410d78_quick sogomanny0012a410d78_quick_pkey; Type: CONSTRAINT; Schema: ext_sogo; Owner: sogogaia
--

ALTER TABLE ONLY ext_sogo.sogomanny0012a410d78_quick
    ADD CONSTRAINT sogomanny0012a410d78_quick_pkey PRIMARY KEY (c_name);


--
-- Name: sogomanny001611f754f sogomanny001611f754f_pkey; Type: CONSTRAINT; Schema: ext_sogo; Owner: sogogaia
--

ALTER TABLE ONLY ext_sogo.sogomanny001611f754f
    ADD CONSTRAINT sogomanny001611f754f_pkey PRIMARY KEY (c_name);


--
-- Name: sogomanny001611f754f_quick sogomanny001611f754f_quick_pkey; Type: CONSTRAINT; Schema: ext_sogo; Owner: sogogaia
--

ALTER TABLE ONLY ext_sogo.sogomanny001611f754f_quick
    ADD CONSTRAINT sogomanny001611f754f_quick_pkey PRIMARY KEY (c_name);


--
-- Name: sogotest001587c6ced sogotest001587c6ced_pkey; Type: CONSTRAINT; Schema: ext_sogo; Owner: sogogaia
--

ALTER TABLE ONLY ext_sogo.sogotest001587c6ced
    ADD CONSTRAINT sogotest001587c6ced_pkey PRIMARY KEY (c_name);


--
-- Name: sogotest001587c6ced_quick sogotest001587c6ced_quick_pkey; Type: CONSTRAINT; Schema: ext_sogo; Owner: sogogaia
--

ALTER TABLE ONLY ext_sogo.sogotest001587c6ced_quick
    ADD CONSTRAINT sogotest001587c6ced_quick_pkey PRIMARY KEY (c_name);


--
-- Name: sogotest00223211dc6 sogotest00223211dc6_pkey; Type: CONSTRAINT; Schema: ext_sogo; Owner: sogogaia
--

ALTER TABLE ONLY ext_sogo.sogotest00223211dc6
    ADD CONSTRAINT sogotest00223211dc6_pkey PRIMARY KEY (c_name);


--
-- Name: sogotest00223211dc6_quick sogotest00223211dc6_quick_pkey; Type: CONSTRAINT; Schema: ext_sogo; Owner: sogogaia
--

ALTER TABLE ONLY ext_sogo.sogotest00223211dc6_quick
    ADD CONSTRAINT sogotest00223211dc6_quick_pkey PRIMARY KEY (c_name);


--
-- Name: applications applications_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.applications
    ADD CONSTRAINT applications_pkey PRIMARY KEY (applicationsid);


--
-- Name: customerfunctions customerfunctions_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.customerfunctions
    ADD CONSTRAINT customerfunctions_pkey PRIMARY KEY (customerfunction);


--
-- Name: htmlcompose htmlcompose_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.htmlcompose
    ADD CONSTRAINT htmlcompose_pkey PRIMARY KEY (htmlcomposeid);


--
-- Name: htmlcomposenames htmlcomposenames_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.htmlcomposenames
    ADD CONSTRAINT htmlcomposenames_pkey PRIMARY KEY (htmlcomposeid);


--
-- Name: htmlcomposetab htmlcomposetab_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.htmlcomposetab
    ADD CONSTRAINT htmlcomposetab_pkey PRIMARY KEY (htmlcomposetabid);


--
-- Name: htmlcomposetabnames htmlcomposetabnames_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.htmlcomposetabnames
    ADD CONSTRAINT htmlcomposetabnames_pkey PRIMARY KEY (htmlcomposetabid);


--
-- Name: htmlcomposetabselect htmlcomposetabselect_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.htmlcomposetabselect
    ADD CONSTRAINT htmlcomposetabselect_pkey PRIMARY KEY (htmlcomposetabselectid);


--
-- Name: htmlcomposetabslider htmlcomposetabslider_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.htmlcomposetabslider
    ADD CONSTRAINT htmlcomposetabslider_pkey PRIMARY KEY (htmlcomposeid, slidername);


--
-- Name: joindef joindef_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.joindef
    ADD CONSTRAINT joindef_pkey PRIMARY KEY (joindefid);


--
-- Name: menu menu_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.menu
    ADD CONSTRAINT menu_pkey PRIMARY KEY (menuid);


--
-- Name: querycolnames querycolnames_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.querycolnames
    ADD CONSTRAINT querycolnames_pkey PRIMARY KEY (schema, query, colid);


--
-- Name: querycolumns querycolumns_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.querycolumns
    ADD CONSTRAINT querycolumns_pkey PRIMARY KEY (queryid, colnum);


--
-- Name: queryname queryname_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.queryname
    ADD CONSTRAINT queryname_pkey PRIMARY KEY (queryid);


--
-- Name: querytables querytables_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.querytables
    ADD CONSTRAINT querytables_pkey PRIMARY KEY (queryid, tabid);


--
-- Name: querywheres querywheres_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.querywheres
    ADD CONSTRAINT querywheres_pkey PRIMARY KEY (queryid, wherecol);


--
-- Name: selectlist selectlist_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.selectlist
    ADD CONSTRAINT selectlist_pkey PRIMARY KEY (name, value);


--
-- Name: tablecolnames tablecolnames_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.tablecolnames
    ADD CONSTRAINT tablecolnames_pkey PRIMARY KEY (schema, tab, colname);


--
-- Name: tableconstraintmessages tableconstraintmessages_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.tableconstraintmessages
    ADD CONSTRAINT tableconstraintmessages_pkey PRIMARY KEY (tableconstraintmessagesid);


--
-- Name: tableregexp tableregexp_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.tableregexp
    ADD CONSTRAINT tableregexp_pkey PRIMARY KEY (tableregexpid);


--
-- Name: timestyle timestyle_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.timestyle
    ADD CONSTRAINT timestyle_pkey PRIMARY KEY (language, region, typ);


--
-- Name: translate translate_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.translate
    ADD CONSTRAINT translate_pkey PRIMARY KEY (id);


--
-- Name: trustrequest trustfunction_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.trustrequest
    ADD CONSTRAINT trustfunction_pkey PRIMARY KEY (trustrequestid);


--
-- Name: userpref userpref_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.userpref
    ADD CONSTRAINT userpref_pkey PRIMARY KEY (username);


--
-- Name: usertables usertables_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.usertables
    ADD CONSTRAINT usertables_pkey PRIMARY KEY (text_de);


--
-- Name: update version_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.update
    ADD CONSTRAINT version_pkey PRIMARY KEY (updateid);


--
-- Name: year year_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.year
    ADD CONSTRAINT year_pkey PRIMARY KEY (yearid);


--
-- Name: yearday yearday_pkey; Type: CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.yearday
    ADD CONSTRAINT yearday_pkey PRIMARY KEY (vfullday);


--
-- Name: id_count id_count_pkey; Type: CONSTRAINT; Schema: mne_catalog; Owner: admindb
--

ALTER TABLE ONLY mne_catalog.id_count
    ADD CONSTRAINT id_count_pkey PRIMARY KEY (index);


--
-- Name: uuid uuid_pkey; Type: CONSTRAINT; Schema: mne_catalog; Owner: admindb
--

ALTER TABLE ONLY mne_catalog.uuid
    ADD CONSTRAINT uuid_pkey PRIMARY KEY (uuidid);


--
-- Name: htmlcompose_name; Type: INDEX; Schema: mne_application; Owner: admindb
--

CREATE UNIQUE INDEX htmlcompose_name ON mne_application.htmlcompose USING btree (name);


--
-- Name: htmlcomposetab_id; Type: INDEX; Schema: mne_application; Owner: admindb
--

CREATE UNIQUE INDEX htmlcomposetab_id ON mne_application.htmlcomposetab USING btree (htmlcomposeid, id);


--
-- Name: joindef_second; Type: INDEX; Schema: mne_application; Owner: admindb
--

CREATE UNIQUE INDEX joindef_second ON mne_application.joindef USING btree (fschema, ftab, fcols, tschema, ttab, tcols, op, typ);


--
-- Name: menu_second; Type: INDEX; Schema: mne_application; Owner: admindb
--

CREATE UNIQUE INDEX menu_second ON mne_application.menu USING btree (menuname, menuid);


--
-- Name: queryname_second; Type: INDEX; Schema: mne_application; Owner: admindb
--

CREATE UNIQUE INDEX queryname_second ON mne_application.queryname USING btree (schema, query, unionnum);


--
-- Name: trustfunction__first; Type: INDEX; Schema: mne_application; Owner: admindb
--

CREATE UNIQUE INDEX trustfunction__first ON mne_application.trustrequest USING btree (action, ipaddr);


--
-- Name: applications mne_history; Type: TRIGGER; Schema: mne_application; Owner: admindb
--

CREATE TRIGGER mne_history AFTER DELETE OR UPDATE ON mne_application.applications FOR EACH ROW EXECUTE FUNCTION mne_application.mne_history_applications();


--
-- Name: htmlcomposenames htmlcomposenames_htmlcomposenamesid_fkey; Type: FK CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.htmlcomposenames
    ADD CONSTRAINT htmlcomposenames_htmlcomposenamesid_fkey FOREIGN KEY (htmlcomposeid) REFERENCES mne_application.htmlcompose(htmlcomposeid);


--
-- Name: htmlcomposetab htmlcomposetab_htmlcomposeid_fkey; Type: FK CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.htmlcomposetab
    ADD CONSTRAINT htmlcomposetab_htmlcomposeid_fkey FOREIGN KEY (htmlcomposeid) REFERENCES mne_application.htmlcompose(htmlcomposeid);


--
-- Name: htmlcomposetabnames htmlcomposetabnames_htmlcomposeid_fkey; Type: FK CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.htmlcomposetabnames
    ADD CONSTRAINT htmlcomposetabnames_htmlcomposeid_fkey FOREIGN KEY (htmlcomposeid) REFERENCES mne_application.htmlcompose(htmlcomposeid);


--
-- Name: htmlcomposetabnames htmlcomposetabnames_htmlcomposetabid_fkey; Type: FK CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.htmlcomposetabnames
    ADD CONSTRAINT htmlcomposetabnames_htmlcomposetabid_fkey FOREIGN KEY (htmlcomposetabid) REFERENCES mne_application.htmlcomposetab(htmlcomposetabid);


--
-- Name: htmlcomposetabselect htmlcomposetabselect_htmlcomposeid_fkey; Type: FK CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.htmlcomposetabselect
    ADD CONSTRAINT htmlcomposetabselect_htmlcomposeid_fkey FOREIGN KEY (htmlcomposeid) REFERENCES mne_application.htmlcompose(htmlcomposeid);


--
-- Name: menu menu_parentid_fkey; Type: FK CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.menu
    ADD CONSTRAINT menu_parentid_fkey FOREIGN KEY (menuname, parentid) REFERENCES mne_application.menu(menuname, menuid);


--
-- Name: querytables querytables_joindefid_fkey; Type: FK CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.querytables
    ADD CONSTRAINT querytables_joindefid_fkey FOREIGN KEY (joindefid) REFERENCES mne_application.joindef(joindefid);


--
-- Name: userpref userpref_startweblet_fkey; Type: FK CONSTRAINT; Schema: mne_application; Owner: admindb
--

ALTER TABLE ONLY mne_application.userpref
    ADD CONSTRAINT userpref_startweblet_fkey FOREIGN KEY (startweblet) REFERENCES mne_application.htmlcompose(name);


--
-- Name: SCHEMA mne_application; Type: ACL; Schema: -; Owner: admindb
--

GRANT USAGE ON SCHEMA mne_application TO PUBLIC;


--
-- Name: SCHEMA mne_catalog; Type: ACL; Schema: -; Owner: admindb
--

GRANT USAGE ON SCHEMA mne_catalog TO PUBLIC;


--
-- Name: FUNCTION history_create(schema character varying, tabname character varying, refname character varying, historytab character varying); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.history_create(schema character varying, tabname character varying, refname character varying, historytab character varying) FROM PUBLIC;


--
-- Name: FUNCTION history_drop(schema character varying, tabname character varying); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.history_drop(schema character varying, tabname character varying) FROM PUBLIC;


--
-- Name: FUNCTION pgplsql_proc_access_add(p_schema character varying, p_name character varying, p_user character varying); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.pgplsql_proc_access_add(p_schema character varying, p_name character varying, p_user character varying) FROM PUBLIC;


--
-- Name: FUNCTION pgplsql_proc_access_del(p_schema character varying, p_name character varying, p_user character varying); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.pgplsql_proc_access_del(p_schema character varying, p_name character varying, p_user character varying) FROM PUBLIC;


--
-- Name: FUNCTION pgplsql_proc_create(schema character varying, name character varying, rettyp character varying, text character varying, asowner boolean, vol character varying, owner character varying); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.pgplsql_proc_create(schema character varying, name character varying, rettyp character varying, text character varying, asowner boolean, vol character varying, owner character varying) FROM PUBLIC;


--
-- Name: FUNCTION pgplsql_proc_del(schema character varying, name character varying); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.pgplsql_proc_del(schema character varying, name character varying) FROM PUBLIC;


--
-- Name: FUNCTION pgplsql_proc_drop(schema character varying, name character varying); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.pgplsql_proc_drop(schema character varying, name character varying) FROM PUBLIC;


--
-- Name: FUNCTION subweblet_del(p_htmlcomposetabid character varying); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.subweblet_del(p_htmlcomposetabid character varying) FROM PUBLIC;


--
-- Name: FUNCTION subweblet_ok(p_htmlcomposeid character varying, p_htmlcomposetabid character varying, p_id character varying, p_position character varying, p_subposition integer, p_loadpos integer, p_path character varying, p_initpar character varying, p_depend character varying, p_ugroup character varying, p_custom boolean, p_label_de character varying, p_label_en character varying, p_namecustom boolean); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.subweblet_ok(p_htmlcomposeid character varying, p_htmlcomposetabid character varying, p_id character varying, p_position character varying, p_subposition integer, p_loadpos integer, p_path character varying, p_initpar character varying, p_depend character varying, p_ugroup character varying, p_custom boolean, p_label_de character varying, p_label_en character varying, p_namecustom boolean) FROM PUBLIC;


--
-- Name: FUNCTION table_access_add(schema character varying, tabname character varying, name character varying, access character varying); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.table_access_add(schema character varying, tabname character varying, name character varying, access character varying) FROM PUBLIC;


--
-- Name: FUNCTION table_access_drop(schema character varying, tabname character varying, name character varying, accesstyp character varying); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.table_access_drop(schema character varying, tabname character varying, name character varying, accesstyp character varying) FROM PUBLIC;


--
-- Name: FUNCTION table_access_ok(schema character varying, tabname character varying, name character varying, p_select boolean, p_insert boolean, p_update boolean, p_delete boolean, p_reference boolean, p_trigger boolean); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.table_access_ok(schema character varying, tabname character varying, name character varying, p_select boolean, p_insert boolean, p_update boolean, p_delete boolean, p_reference boolean, p_trigger boolean) FROM PUBLIC;


--
-- Name: FUNCTION table_index_add(schema character varying, tabname character varying, indname character varying, isunique boolean, cols character varying[], p_text_de character varying, p_text_en character varying, p_custom boolean); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.table_index_add(schema character varying, tabname character varying, indname character varying, isunique boolean, cols character varying[], p_text_de character varying, p_text_en character varying, p_custom boolean) FROM PUBLIC;


--
-- Name: FUNCTION table_index_drop(p_schema character varying, p_index character varying); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.table_index_drop(p_schema character varying, p_index character varying) FROM PUBLIC;


--
-- Name: FUNCTION table_owner(schema character varying, tabname character varying, owner character varying); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.table_owner(schema character varying, tabname character varying, owner character varying) FROM PUBLIC;


--
-- Name: FUNCTION useradd(p_username character varying, p_canlogin boolean, p_valid integer); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.useradd(p_username character varying, p_canlogin boolean, p_valid integer) FROM PUBLIC;


--
-- Name: FUNCTION userdel(p_username character varying); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.userdel(p_username character varying) FROM PUBLIC;


--
-- Name: FUNCTION usergroupadd(p_user character varying, p_group character varying); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.usergroupadd(p_user character varying, p_group character varying) FROM PUBLIC;
GRANT ALL ON FUNCTION mne_catalog.usergroupadd(p_user character varying, p_group character varying) TO admerppersonnal;


--
-- Name: FUNCTION usergroupdel(p_user character varying, p_group character varying); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.usergroupdel(p_user character varying, p_group character varying) FROM PUBLIC;
GRANT ALL ON FUNCTION mne_catalog.usergroupdel(p_user character varying, p_group character varying) TO admerppersonnal;


--
-- Name: FUNCTION usermod(p_username character varying, p_canlogin boolean, p_valid integer); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.usermod(p_username character varying, p_canlogin boolean, p_valid integer) FROM PUBLIC;


--
-- Name: FUNCTION usertimecolumn_check(schema character varying, tabname character varying); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.usertimecolumn_check(schema character varying, tabname character varying) FROM PUBLIC;
GRANT ALL ON FUNCTION mne_catalog.usertimecolumn_check(schema character varying, tabname character varying) TO erpdb;


--
-- Name: FUNCTION weblet_del(p_htmlcomposeid character varying); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.weblet_del(p_htmlcomposeid character varying) FROM PUBLIC;


--
-- Name: FUNCTION weblet_ok(p_htmlcomposeid character varying, p_name character varying, p_template character varying, p_label_de character varying, p_label_en character varying, p_custom boolean); Type: ACL; Schema: mne_catalog; Owner: admindb
--

REVOKE ALL ON FUNCTION mne_catalog.weblet_ok(p_htmlcomposeid character varying, p_name character varying, p_template character varying, p_label_de character varying, p_label_en character varying, p_custom boolean) FROM PUBLIC;


--
-- Name: TABLE yearday; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.yearday TO PUBLIC;


--
-- Name: TABLE applications; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.applications TO mne_translate;


--
-- Name: TABLE customerfunctions; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.customerfunctions TO PUBLIC;


--
-- Name: TABLE htmlcompose; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.htmlcompose TO PUBLIC;


--
-- Name: TABLE htmlcomposenames; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.htmlcomposenames TO PUBLIC;


--
-- Name: TABLE htmlcomposetab; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.htmlcomposetab TO PUBLIC;


--
-- Name: TABLE htmlcomposetabnames; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.htmlcomposetabnames TO PUBLIC;


--
-- Name: TABLE htmlcomposetabselect; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.htmlcomposetabselect TO PUBLIC;


--
-- Name: TABLE htmlcomposetabslider; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.htmlcomposetabslider TO PUBLIC;


--
-- Name: TABLE joindef; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.joindef TO PUBLIC;


--
-- Name: TABLE menu; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.menu TO PUBLIC;


--
-- Name: TABLE menu_child; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.menu_child TO PUBLIC;


--
-- Name: TABLE querycolnames; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.querycolnames TO PUBLIC;


--
-- Name: TABLE querycolumns; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.querycolumns TO PUBLIC;


--
-- Name: TABLE queryname; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.queryname TO PUBLIC;


--
-- Name: TABLE querytables; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.querytables TO PUBLIC;


--
-- Name: TABLE querywheres; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.querywheres TO PUBLIC;


--
-- Name: TABLE selectlist; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.selectlist TO PUBLIC;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mne_application.selectlist TO erpdb;


--
-- Name: TABLE tablecolnames; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.tablecolnames TO PUBLIC;


--
-- Name: TABLE tableconstraintmessages; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.tableconstraintmessages TO PUBLIC;


--
-- Name: TABLE tableregexp; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.tableregexp TO PUBLIC;


--
-- Name: TABLE timestyle; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.timestyle TO PUBLIC;


--
-- Name: TABLE translate; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT ALL ON TABLE mne_application.translate TO mne_translate;
GRANT SELECT ON TABLE mne_application.translate TO PUBLIC;


--
-- Name: TABLE trustrequest; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.trustrequest TO PUBLIC;


--
-- Name: TABLE update; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.update TO PUBLIC;


--
-- Name: TABLE userpref; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE mne_application.userpref TO PUBLIC;


--
-- Name: TABLE usertables; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.usertables TO erpdb;


--
-- Name: TABLE year; Type: ACL; Schema: mne_application; Owner: admindb
--

GRANT SELECT ON TABLE mne_application.year TO PUBLIC;


--
-- Name: TABLE accessgroup; Type: ACL; Schema: mne_catalog; Owner: admindb
--

GRANT SELECT ON TABLE mne_catalog.accessgroup TO PUBLIC;


--
-- Name: TABLE dbaccessgroup; Type: ACL; Schema: mne_catalog; Owner: admindb
--

GRANT SELECT ON TABLE mne_catalog.dbaccessgroup TO PUBLIC;


--
-- Name: TABLE dbaccessuser; Type: ACL; Schema: mne_catalog; Owner: admindb
--

GRANT SELECT ON TABLE mne_catalog.dbaccessuser TO PUBLIC;


--
-- Name: TABLE id_count; Type: ACL; Schema: mne_catalog; Owner: admindb
--

GRANT ALL ON TABLE mne_catalog.id_count TO PUBLIC;


--
-- Name: TABLE pg_timezone_names; Type: ACL; Schema: mne_catalog; Owner: admindb
--

GRANT SELECT ON TABLE mne_catalog.pg_timezone_names TO PUBLIC;


--
-- Name: TABLE uuid; Type: ACL; Schema: mne_catalog; Owner: admindb
--

GRANT SELECT ON TABLE mne_catalog.uuid TO PUBLIC;


--
-- PostgreSQL database dump complete
--

