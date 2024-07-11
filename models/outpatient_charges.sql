
--outpatient-charges

select 
  provider_name||' ('||provider_id||')' as provider_name_and_id,
  provider_id,
  provider_name,
  provider_city,
  provider_state,
  hospital_referral_region,
  apc as ambulatory_payment_classification,
  outpatient_services,
  average_total_payments,
  average_estimated_submitted_charges

from {{ source('medicare','outpatient_charges_2015') }}