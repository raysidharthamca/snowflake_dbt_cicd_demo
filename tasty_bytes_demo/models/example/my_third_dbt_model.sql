{{ config(materialized='table') }}

/*
    Demonstrates dbt_utils macros:
    - generate_surrogate_key: hashes column(s) into a unique row identifier
    - safe_divide: division that returns null instead of erroring on divide-by-zero
*/

with base as (

    select
        id,
        {{ dbt_utils.generate_surrogate_key(['id']) }} as surrogate_key,
        {{ dbt_utils.safe_divide('id', 'id') }}        as id_divided_by_itself

    from {{ ref('my_first_dbt_model') }}

)

select * from base
