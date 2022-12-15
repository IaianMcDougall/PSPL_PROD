DROP TABLE IF EXISTS :outTbl;
CREATE TABLE :outTbl(
  id1 integer,
  id2 VARCHAR(20),
  latitude double precision,
  longitude double precision,
  elevation integer,
  mat double precision,
  mwmt double precision,
  mcmt double precision,
  td double precision,
  map double precision,
  msp double precision,
  ahm double precision,
  shm double precision,
  DDlt0 integer,
  DDgt5 integer,
  DDlt18 integer,
  DDgt18 integer,
  NFFD integer,
  bffp integer,
  effp integer,
  ffp integer,
  pas integer,
  emt double precision,
  eref integer,
  cmd integer);