-- Wrap element-wise last in an aggregate function
CREATE OR REPLACE AGGREGATE last (anyelement) (
    SFUNC    = second
  , STYPE    = anyelement
  , PARALLEL = safe
)
