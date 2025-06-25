
import React from 'react';
import { MapPin, TrendingUp, IndianRupee, Edit, Trash2 } from 'lucide-react';

interface PondCardProps {
  pond: {
    id: string;
    name: string;
    size: number;
    location: string;
    lease_amount: number;
    monthly_expense_budget: number;
  };
  onEdit?: (pond: any) => void;
  onDelete?: (pond: any) => void;
}

const PondCard: React.FC<PondCardProps> = ({ pond, onEdit, onDelete }) => {
  const formatAmount = (amount: number) => {
    return new Intl.NumberFormat('en-IN', {
      style: 'currency',
      currency: 'INR',
      maximumFractionDigits: 0
    }).format(amount);
  };

  return (
    <div className="bg-white rounded-lg shadow-sm border border-gray-100 p-4 hover:shadow-md transition-shadow">
      <div className="flex justify-between items-start mb-3">
        <div>
          <h3 className="text-xl font-bold text-gray-900">{pond.name}</h3>
          <div className="flex items-center text-gray-600 text-sm mt-1">
            <MapPin size={14} className="mr-1" />
            <span>{pond.location} • {pond.size} acres</span>
          </div>
        </div>
        <div className="flex space-x-1">
          <button
            onClick={() => onEdit?.(pond)}
            className="text-gray-400 hover:text-blue-600 p-1"
            title="Edit pond"
          >
            <Edit size={16} />
          </button>
          <button
            onClick={() => onDelete?.(pond)}
            className="text-gray-400 hover:text-red-600 p-1"
            title="Delete pond"
          >
            <Trash2 size={16} />
          </button>
        </div>
      </div>

      <div className="space-y-3">
        <div className="flex justify-between items-center">
          <span className="text-gray-600">Monthly Expense</span>
          <div className="flex items-center">
            <TrendingUp size={16} className="text-green-500 mr-1" />
            <span className="text-lg font-semibold text-green-600">
              {formatAmount(pond.monthly_expense_budget)}
            </span>
          </div>
        </div>

        <div className="flex justify-between items-center">
          <span className="text-gray-600">Lease Amount</span>
          <div className="flex items-center">
            <IndianRupee size={16} className="text-gray-500 mr-1" />
            <span className="text-lg font-semibold text-gray-900">
              {formatAmount(pond.lease_amount)}
            </span>
          </div>
        </div>
      </div>
    </div>
  );
};

export default PondCard;
