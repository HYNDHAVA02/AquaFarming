-- Check current profile data for your user
SELECT 
    id,
    email,
    full_name,
    phone,
    farm_name,
    location,
    avatar_url,
    created_at,
    updated_at
FROM profiles 
WHERE id = '45c6a09d-fbcb-41fa-a0cf-34ddf9bf6afb';

-- Check if any fields are NULL or empty
SELECT 
    id,
    CASE WHEN full_name IS NULL OR full_name = '' THEN 'MISSING' ELSE full_name END as full_name_status,
    CASE WHEN phone IS NULL OR phone = '' THEN 'MISSING' ELSE phone END as phone_status,
    CASE WHEN farm_name IS NULL OR farm_name = '' THEN 'MISSING' ELSE farm_name END as farm_name_status,
    CASE WHEN location IS NULL OR location = '' THEN 'MISSING' ELSE location END as location_status
FROM profiles 
WHERE id = '45c6a09d-fbcb-41fa-a0cf-34ddf9bf6afb';