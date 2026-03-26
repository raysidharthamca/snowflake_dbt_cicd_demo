-- Singular test: asserts that every surrogate_key in my_third_dbt_model is exactly 32 chars
-- (MD5 hex string produced by dbt_utils.generate_surrogate_key).
-- Returns rows where the length is wrong, causing the test to fail.

select surrogate_key
from {{ ref('my_third_dbt_model') }}
where length(surrogate_key) != 32
