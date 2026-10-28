-- Always returns the second parameter value
CREATE OR REPLACE FUNCTION second (anyelement, anyelement)
  RETURNS anyelement
  LANGUAGE sql
  IMMUTABLE
  STRICT -- Skips if any of the values is null
  PARALLEL SAFE AS
$$
SELECT $2
$$
