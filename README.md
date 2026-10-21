# postgresql-functions

Small PostgreSQL functions. Load each file with `psql -f <file>`. `last.sql` needs `second.sql` loaded first.

- `second.sql`: `second(a, b)` returns its second argument, and returns NULL if either argument is NULL.
- `last.sql`: `last(x)` is an aggregate function that returns the last non-null value of a group, built on `second`; the result depends on the row order of the group.
- `to_dtype.sql`: `to_dtype(ord_value, dtype)` pulls a number out of a text value such as `<5 mg` or `1/2 Lpm` and returns it as text; `dtype` is `integer`, `decimal`, `fraction` or `quantity` (a number, or a fraction as its decimal value), any other `dtype` returns the value unchanged, and a value with no match gives NULL.

## License

MIT, see `LICENSE`.
