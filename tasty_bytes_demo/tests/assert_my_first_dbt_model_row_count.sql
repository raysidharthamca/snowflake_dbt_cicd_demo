-- Singular test: asserts that my_first_dbt_model always has exactly 2 rows.
-- Returns a row (failing the test) if the count is not 2.

select count(*) as row_count
from {{ ref('my_first_dbt_model') }}
having count(*) != 2
