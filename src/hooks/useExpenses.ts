import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { expenseService, type Expense, type ExpenseInsert, type ExpenseUpdate } from '@/services/supabase'

export function useExpenses() {
  return useQuery({
    queryKey: ['expenses'],
    queryFn: expenseService.getAll,
  })
}

export function useExpensesByPond(pondId: string) {
  return useQuery({
    queryKey: ['expenses', 'pond', pondId],
    queryFn: () => expenseService.getByPond(pondId),
    enabled: !!pondId,
  })
}

export function useCreateExpense() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: (expense: Omit<ExpenseInsert, 'user_id'>) => expenseService.create(expense),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['expenses'] })
    },
  })
}

export function useUpdateExpense() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: ({ id, updates }: { id: string; updates: ExpenseUpdate }) =>
      expenseService.update(id, updates),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['expenses'] })
    },
  })
}

export function useDeleteExpense() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: (id: string) => expenseService.delete(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['expenses'] })
    },
  })
}

export function useMonthlyExpenseTrend(year: number = new Date().getFullYear()) {
  return useQuery({
    queryKey: ['expenses', 'monthly-trend', year],
    queryFn: () => expenseService.getMonthlyTotals(year),
  })
}

export function useCategoryBreakdown() {
  return useQuery({
    queryKey: ['expenses', 'category-breakdown'],
    queryFn: expenseService.getCategoryBreakdown,
  })
}