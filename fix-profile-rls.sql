-- Fix profile RLS policy that's causing loading hang

-- Check current profile policies
SELECT schemaname, tablename, policyname, roles, cmd, qual, with_check 
FROM pg_policies 
WHERE tablename = 'profiles';

-- Check if user has profile
SELECT id, email, full_name, farm_name FROM profiles 
WHERE id = '45c6a09d-fbcb-41fa-a0cf-34ddf9bf6afb';

-- Temporarily disable RLS on profiles to test
ALTER TABLE profiles DISABLE ROW LEVEL SECURITY;

-- Test profile access
SELECT * FROM profiles WHERE id = '45c6a09d-fbcb-41fa-a0cf-34ddf9bf6afb';

-- Re-enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Drop existing restrictive policies
DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;

-- Create simple policy for authenticated users
CREATE POLICY "Authenticated users can manage profiles" ON profiles
  FOR ALL 
  USING (auth.role() = 'authenticated')
  WITH CHECK (auth.role() = 'authenticated');

-- Test again
SELECT * FROM profiles WHERE id = '45c6a09d-fbcb-41fa-a0cf-34ddf9bf6afb';