CREATE OR REPLACE FUNCTION to_dtype(
    ord_value text
  , dtype     text
)
RETURNS text
LANGUAGE sql
IMMUTABLE
PARALLEL SAFE
AS
$$
-- Each pattern is anchored (^ ... $) so the whole value must match.
-- The capture group (...) is what SUBSTRING returns. No match gives NULL.
SELECT
    CASE
      -- no digits at all -> NULL
      WHEN TRANSLATE(ord_value, '0123456789', '') = ord_value
        THEN NULL

      WHEN dtype = 'integer'
        AND TRANSLATE(ord_value, '0123456789', '') NOT IN ('')
        THEN SUBSTRING(ord_value FROM '^[^\d.]*(\d+)\D*$')

      WHEN
        dtype = 'decimal'
        AND TRANSLATE(ord_value, '0123456789', '') NOT IN ('', '.')
        THEN SUBSTRING(ord_value FROM '^[^\d.]*(\d*\.?\d+)\D*$')

      WHEN
        dtype = 'fraction'
        AND TRANSLATE(ord_value, '0123456789', '') NOT IN ('/')
        THEN SUBSTRING(ord_value FROM '^[^\d.]*(\d+/\d+)\D*$')

      ELSE ord_value
    END
$$
