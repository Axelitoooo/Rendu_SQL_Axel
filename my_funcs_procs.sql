CREATE OR REPLACE FUNCTION GET_NB_WORKERS(FACTORY_ID NUMBER) RETURN NUMBER IS
  nb_workers NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO nb_workers
  FROM ALL_WORKERS
  WHERE factory_id = FACTORY_ID;
  RETURN nb_workers;
END;
/

CREATE OR REPLACE FUNCTION GET_NB_BIG_ROBOTS RETURN NUMBER IS
  nb_big_robots NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO nb_big_robots
  FROM ROBOTS_FACTORIES
  WHERE num_pieces > 3;
  RETURN nb_big_robots;
END;
/

CREATE OR REPLACE FUNCTION GET_BEST_SUPPLIER RETURN VARCHAR2 IS
  best_supplier VARCHAR2(100);
BEGIN
  SELECT supplier_name
  INTO best_supplier
  FROM BEST_SUPPLIERS
  WHERE ROWNUM = 1
  ORDER BY num_pieces DESC;
  RETURN best_supplier;
END;
/

CREATE OR REPLACE FUNCTION GET_OLDEST_WORKER RETURN NUMBER IS
  oldest_worker_id NUMBER;
BEGIN
  SELECT worker_id
  INTO oldest_worker_id
  FROM ALL_WORKERS
  ORDER BY start_date ASC
  FETCH FIRST ROW ONLY;
  RETURN oldest_worker_id;
END;
/

CREATE OR REPLACE PROCEDURE SEED_DATA_WORKERS(NB_WORKERS NUMBER, FACTORY_ID NUMBER) IS
BEGIN
  FOR i IN 1..NB_WORKERS LOOP
    INSERT INTO WORKERS (worker_id, first_name, last_name, start_date, factory_id)
    VALUES (
      WORKERS_SEQ.NEXTVAL,
      'worker_f_' || WORKERS_SEQ.CURRVAL,
      'worker_l_' || WORKERS_SEQ.CURRVAL,
      (SELECT TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2065-01-01','J'), TO_CHAR(DATE '2070-01-01','J'))), 'J') FROM DUAL),
      FACTORY_ID
    );
  END LOOP;
END;
/

CREATE OR REPLACE PROCEDURE ADD_NEW_ROBOT(MODEL_NAME VARCHAR2) IS
BEGIN
  INSERT INTO ROBOTS (model_name, factory_id, assembly_date)
  VALUES (MODEL_NAME, (SELECT factory_id FROM ROBOTS_FACTORIES WHERE ROWNUM = 1), SYSDATE);
END;
/

CREATE OR REPLACE PROCEDURE SEED_DATA_SPARE_PARTS(NB_SPARE_PARTS NUMBER) IS
BEGIN
  FOR i IN 1..NB_SPARE_PARTS LOOP
    INSERT INTO SPARE_PARTS (part_id, part_name)
    VALUES (SPARE_PARTS_SEQ.NEXTVAL, 'spare_part_' || SPARE_PARTS_SEQ.CURRVAL);
  END LOOP;
END;
/