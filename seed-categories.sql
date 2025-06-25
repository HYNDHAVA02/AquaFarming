-- Seed expense categories for the application
-- This fixes the AddExpense loading issue

-- First, check if categories already exist
SELECT COUNT(*) as category_count FROM expense_categories;

-- Insert standard aqua farm expense categories
INSERT INTO expense_categories (name, description, is_recurring) VALUES
('Feed', 'Fish feed and nutrition', true),
('Pond Maintenance', 'Cleaning, repairs, and upkeep', true),
('Equipment', 'Pumps, filters, and other equipment', false),
('Utilities', 'Electricity, water bills', true),
('Labor', 'Worker wages and salaries', true),
('Fingerlings', 'Young fish for stocking', false),
('Medicine', 'Fish health and treatment', false),
('Fuel', 'Generator fuel and transportation', true),
('Pond Lease', 'Land rental costs', true),
('Insurance', 'Equipment and livestock insurance', true),
('Transportation', 'Vehicle costs and delivery', false),
('Testing', 'Water quality testing and analysis', false),
('Certification', 'Licenses and certifications', false),
('Marketing', 'Sales and promotion costs', false),
('Miscellaneous', 'Other expenses', false)
ON CONFLICT (name) DO NOTHING;

-- Verify the insert worked
SELECT COUNT(*) as inserted_categories FROM expense_categories;
SELECT name, is_recurring FROM expense_categories ORDER BY name;