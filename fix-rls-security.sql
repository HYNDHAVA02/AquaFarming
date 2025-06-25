-- CRITICAL SECURITY FIX: Users seeing other users' data
-- This fixes Row Level Security policies to properly isolate user data

-- 1. Check current RLS policies
SELECT schemaname, tablename, policyname, roles, cmd, qual, with_check 
FROM pg_policies 
WHERE tablename IN ('expenses', 'ponds', 'profiles');

-- 2. Drop existing overly permissive policies
DROP POLICY IF EXISTS "Authenticated users can manage expenses" ON expenses;
DROP POLICY IF EXISTS "Authenticated users can manage ponds" ON ponds;
DROP POLICY IF EXISTS "Authenticated users can manage profiles" ON profiles;

-- 3. Create proper user-isolated RLS policies for EXPENSES
CREATE POLICY "Users can view own expenses" ON expenses
  FOR SELECT 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own expenses" ON expenses
  FOR INSERT 
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own expenses" ON expenses
  FOR UPDATE 
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own expenses" ON expenses
  FOR DELETE 
  USING (auth.uid() = user_id);

-- 4. Create proper user-isolated RLS policies for PONDS
CREATE POLICY "Users can view own ponds" ON ponds
  FOR SELECT 
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own ponds" ON ponds
  FOR INSERT 
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own ponds" ON ponds
  FOR UPDATE 
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own ponds" ON ponds
  FOR DELETE 
  USING (auth.uid() = user_id);

-- 5. Create proper user-isolated RLS policies for PROFILES
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT 
  USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON profiles
  FOR INSERT 
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE 
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- 6. EXPENSE CATEGORIES - These can be shared (no user_id)
DROP POLICY IF EXISTS "Authenticated users can view expense categories" ON expense_categories;
CREATE POLICY "Authenticated users can view expense categories" ON expense_categories
  FOR SELECT 
  USING (auth.role() = 'authenticated');

-- 7. Verify the new policies are working
SELECT schemaname, tablename, policyname, roles, cmd, qual, with_check 
FROM pg_policies 
WHERE tablename IN ('expenses', 'ponds', 'profiles', 'expense_categories')
ORDER BY tablename, policyname;

-- 8. Test data isolation (replace with actual user IDs)
-- This should only return data for the current user
SELECT 'expenses' as table_name, count(*) as visible_records FROM expenses;
SELECT 'ponds' as table_name, count(*) as visible_records FROM ponds;
SELECT 'profiles' as table_name, count(*) as visible_records FROM profiles;