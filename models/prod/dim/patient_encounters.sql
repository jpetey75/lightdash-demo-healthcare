{{
    config(
        tags=['prod'],
        materialized='table',
        meta={
            'primary_key': 'encounter_id'
        }
    )
}}

with inpatient as (
    select
        provider_id,
        provider_name,
        provider_city,
        provider_state,
        provider_division,
        provider_region,
        drg_definition as service_description,
        drg_code as service_code,
        'Inpatient' as encounter_type,
        service_year
    from {{ ref('stg_medicare__inpatient_charges') }}
),

outpatient as (
    select
        provider_id,
        provider_name,
        provider_city,
        provider_state,
        provider_division,
        provider_region,
        apc as service_description,
        apc_code as service_code,
        'Outpatient' as encounter_type,
        service_year
    from {{ ref('stg_medicare__outpatient_charges') }}
),

combined as (
    select * from inpatient
    union all
    select * from outpatient
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['provider_id', 'service_year', 'service_code', 'provider_name', 'provider_city']) }} as encounter_id,
        provider_id,
        provider_name,
        provider_city,
        provider_state,
        provider_division,
        provider_region,
        service_description,
        service_code,
        encounter_type,
        service_year
    from combined
)

select * from final