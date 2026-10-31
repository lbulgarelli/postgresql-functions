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
-- A minus sign right before the digits is part of the number: -4 stays -4.
SELECT
    CASE
      -- no digits at all -> NULL
      WHEN TRANSLATE(ord_value, '0123456789', '') = ord_value
        THEN NULL

      WHEN dtype = 'integer'
        AND TRANSLATE(ord_value, '0123456789', '') NOT IN ('')
        THEN SUBSTRING(ord_value FROM '^[^\d.-]*(-?\d+)\D*$')

      WHEN
        dtype = 'decimal'
        AND TRANSLATE(ord_value, '0123456789', '') NOT IN ('', '.')
        THEN SUBSTRING(ord_value FROM '^[^\d.-]*(-?\d*\.?\d+)\D*$')

      WHEN
        dtype = 'fraction'
        AND TRANSLATE(ord_value, '0123456789', '') NOT IN ('/')
        THEN SUBSTRING(ord_value FROM '^[^\d.]*(\d+/\d+)\D*$')

      -- a number, or a fraction written as a number such as 1/2 Lpm: 0.5
      WHEN dtype = 'quantity'
        THEN COALESCE(
            SUBSTRING(ord_value FROM '^[^\d.-]*(-?\d*\.?\d+)\D*$')
          , ROUND(
                (REGEXP_MATCH(ord_value, '^[^\d.]*(\d+)/(\d+)\D*$'))[1]::NUMERIC
                / NULLIF((REGEXP_MATCH(ord_value, '^[^\d.]*(\d+)/(\d+)\D*$'))[2]::NUMERIC, 0)
              , 6
            )::TEXT
          )

      ELSE ord_value
    END
$$
