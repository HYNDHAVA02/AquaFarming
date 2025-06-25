-- Add cascade deletion for expenses when pond is deleted

-- First, drop the existing foreign key constraint
ALTER TABLE expenses DROP CONSTRAINT IF EXISTS expenses_pond_id_fkey;

-- Add the foreign key constraint with CASCADE deletion
ALTER TABLE expenses 
ADD CONSTRAINT expenses_pond_id_fkey 
FOREIGN KEY (pond_id) REFERENCES ponds(id) ON DELETE CASCADE;

-- Verify the constraint was added
SELECT 
    tc.table_name, 
    kcu.column_name, 
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name,
    rc.delete_rule
FROM information_schema.table_constraints AS tc 
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
JOIN information_schema.referential_constraints AS rc
    ON tc.constraint_name = rc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY' 
    AND tc.table_name = 'expenses';