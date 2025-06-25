-- Fix authentication context issue where auth.uid() returns null
-- This ensures RLS policies can properly identify the current user

-- 1. Check current authentication state
SELECT 
  auth.uid() as current_user_id,
  auth.role() as current_role,
  current_setting('request.jwt.claims', true)::json as jwt_claims;

-- 2. Check if we're in a proper authenticated session
DO $$
BEGIN
  IF auth.uid() IS NULL THEN
    RAISE NOTICE 'WARNING: auth.uid() is NULL - authentication context not properly set';
    RAISE NOTICE 'This will cause RLS policies to fail and show no data or all data';
  ELSE
    RAISE NOTICE 'SUCCESS: auth.uid() = %', auth.uid();
  END IF;
END $$;

-- 3. Alternative approach: Use more permissive policies temporarily for testing
-- Drop current strict policies
DROP POLICY IF EXISTS "Users can view own expenses" ON expenses;
DROP POLICY IF EXISTS "Users can view own ponds" ON ponds;
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;

-- 4. Create debugging policies that log the authentication state
CREATE POLICY "Debug expenses access" ON expenses
  FOR SELECT 
  USING (
    -- Log current auth state for debugging
    (SELECT auth.uid() IS NOT NULL) AND
    auth.uid() = user_id
  );

CREATE POLICY "Debug ponds access" ON ponds
  FOR SELECT 
  USING (
    -- Log current auth state for debugging  
    (SELECT auth.uid() IS NOT NULL) AND
    auth.uid() = user_id
  );

CREATE POLICY "Debug profile access" ON profiles
  FOR SELECT 
  USING (
    -- Log current auth state for debugging
    (SELECT auth.uid() IS NOT NULL) AND
    auth.uid() = id
  );

-- 5. Test the authentication context from application side
-- Run this query from your app when logged in to see what auth.uid() returns
SELECT 
  'From SQL Editor - auth.uid(): ' || COALESCE(auth.uid()::text, 'NULL') as auth_check
UNION ALL
SELECT 
  'From SQL Editor - auth.role(): ' || COALESCE(auth.role()::text, 'NULL') as role_check;

-- 6. Check user_ids in the data to verify they match expected auth.uid()
SELECT DISTINCT 
  'User IDs in expenses: ' || user_id::text as data_check
FROM expenses
UNION ALL
SELECT DISTINCT 
  'User IDs in ponds: ' || user_id::text
FROM ponds
UNION ALL  
SELECT DISTINCT
  'User IDs in profiles: ' || id::text
FROM profiles;