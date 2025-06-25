-- CRITICAL SECURITY FIX: Safe version that handles existing policies
-- This fixes Row Level Security policies to properly isolate user data

-- 1. Check current RLS policies
SELECT schemaname, tablename, policyname, roles, cmd, qual, with_check 
FROM pg_policies 
WHERE tablename IN ('expenses', 'ponds', 'profiles', 'expense_categories');

-- 2. Drop ALL existing policies (safe - handles non-existent policies)
DROP POLICY IF EXISTS "Users can view own expenses" ON expenses;
DROP POLICY IF EXISTS "Users can insert own expenses" ON expenses;
DROP POLICY IF EXISTS "Users can update own expenses" ON expenses;
DROP POLICY IF EXISTS "Users can delete own expenses" ON expenses;
DROP POLICY IF EXISTS "Authenticated users can manage expenses" ON expenses;

DROP POLICY IF EXISTS "Users can view own ponds" ON ponds;
DROP POLICY IF EXISTS "Users can insert own ponds" ON ponds;
DROP POLICY IF EXISTS "Users can update own ponds" ON ponds;
DROP POLICY IF EXISTS "Users can delete own ponds" ON ponds;
DROP POLICY IF EXISTS "Authenticated users can manage ponds" ON ponds;

DROP POLICY IF EXISTS "Users can view own profile" ON profiles;
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;
DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
DROP POLICY IF EXISTS "Authenticated users can manage profiles" ON profiles;

DROP POLICY IF EXISTS "Authenticated users can view expense categories" ON expense_categories;

-- 3. Create SECURE user-isolated RLS policies for EXPENSES
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

-- 4. Create SECURE user-isolated RLS policies for PONDS
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

-- 5. Create SECURE user-isolated RLS policies for PROFILES
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

-- 6. EXPENSE CATEGORIES - Shared data (no user isolation needed)
CREATE POLICY "Authenticated users can view expense categories" ON expense_categories
  FOR SELECT 
  USING (auth.role() = 'authenticated');

-- 7. Verify the new SECURE policies are in place
SELECT 
  tablename, 
  policyname, 
  cmd, 
  CASE 
    WHEN qual LIKE '%auth.uid() = user_id%' THEN '✅ USER ISOLATED'
    WHEN qual LIKE '%auth.uid() = id%' THEN '✅ USER ISOLATED' 
    WHEN qual LIKE '%auth.role()%' THEN '⚠️ ROLE BASED'
    ELSE '❌ UNKNOWN'
  END as security_level,
  qual
FROM pg_policies 
WHERE tablename IN ('expenses', 'ponds', 'profiles', 'expense_categories')
ORDER BY tablename, policyname;

-- 8. Test current user's data visibility
SELECT 
  'Current user ID: ' || auth.uid() as user_info
UNION ALL
SELECT 
  'Visible expenses: ' || count(*)::text 
FROM expenses
UNION ALL
SELECT 
  'Visible ponds: ' || count(*)::text 
FROM ponds;