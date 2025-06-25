import { useQuery } from '@tanstack/react-query'
import { expenseCategoryService } from '@/services/supabase'

export function useExpenseCategories() {
  return useQuery({
    queryKey: ['expense-categories'],
    queryFn: expenseCategoryService.getAll,
  })
}