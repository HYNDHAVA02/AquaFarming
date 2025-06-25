
import React from 'react';
import { Calendar, MapPin, Edit, Trash2 } from 'lucide-react';

interface ExpenseCardProps {
  expense: {
    id: string;
    pond_name: string;
    category_name: string;
    amount: number;
    date: string;
    description?: string;
  };
  onEdit?: (expense: any) => void;
  onDelete?: (expense: any) => void;
}

const ExpenseCard: React.FC<ExpenseCardProps> = ({ expense, onEdit, onDelete }) => {
  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', { 
      day: 'numeric', 
      month: 'short',
      year: 'numeric'
    });
  };

  const formatAmount = (amount: number) => {
    return new Intl.NumberFormat('en-IN', {
      style: 'currency',
      currency: 'INR',
      maximumFractionDigits: 0
    }).format(amount);
  };

  return (
    <div className="bg-white rounded-lg shadow-sm border border-gray-100 p-4 hover:shadow-md transition-shadow">
      <div className="flex justify-between items-start mb-2">
        <div className="flex-1">
          <div className="flex justify-between items-start">
            <div>
              <h3 className="font-semibold text-gray-900 text-lg">{expense.category_name}</h3>
              <div className="flex items-center text-gray-600 text-sm mt-1">
                <MapPin size={14} className="mr-1" />
                <span>{expense.pond_name}</span>
              </div>
            </div>
            <div className="flex space-x-1 ml-2">
              {onEdit && (
                <button
                  onClick={() => onEdit(expense)}
                  className="text-gray-400 hover:text-blue-600 p-1"
                  title="Edit expense"
                >
                  <Edit size={14} />
                </button>
              )}
              {onDelete && (
                <button
                  onClick={() => onDelete(expense)}
                  className="text-gray-400 hover:text-red-600 p-1"
                  title="Delete expense"
                >
                  <Trash2 size={14} />
                </button>
              )}
            </div>
          </div>
        </div>
        <div className="text-right">
          <div className="text-xl font-bold text-green-600">
            {formatAmount(expense.amount)}
          </div>
          <div className="flex items-center text-gray-500 text-sm mt-1">
            <Calendar size={14} className="mr-1" />
            <span>{formatDate(expense.date)}</span>
          </div>
        </div>
      </div>
      {expense.description && (
        <p className="text-gray-600 text-sm mt-2 italic">{expense.description}</p>
      )}
    </div>
  );
};

export default ExpenseCard;
