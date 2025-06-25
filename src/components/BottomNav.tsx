
import React from 'react';
import { Home, Waves, Plus, ChartBar, Receipt } from 'lucide-react';

interface BottomNavProps {
  activeTab: string;
  onTabChange: (tab: string) => void;
}

const BottomNav: React.FC<BottomNavProps> = ({ activeTab, onTabChange }) => {
  const tabs = [
    { id: 'dashboard', label: 'Dashboard', icon: Home },
    { id: 'ponds', label: 'Ponds', icon: Waves },
    { id: 'add-expense', label: 'Add', icon: Plus },
    { id: 'reports', label: 'Reports', icon: ChartBar },
    { id: 'transactions', label: 'Transactions', icon: Receipt }
  ];

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-200 z-50">
      <div className="flex justify-around items-center h-16 max-w-md mx-auto">
        {tabs.map((tab) => {
          const Icon = tab.icon;
          const isActive = activeTab === tab.id;
          
          return (
            <button
              key={tab.id}
              onClick={() => onTabChange(tab.id)}
              className={`flex flex-col items-center justify-center flex-1 h-full transition-colors ${
                isActive 
                  ? 'text-blue-600' 
                  : 'text-gray-500 hover:text-blue-400'
              } ${tab.id === 'add-expense' ? 'transform scale-110' : ''}`}
            >
              <Icon 
                size={tab.id === 'add-expense' ? 28 : 24} 
                className={tab.id === 'add-expense' ? 'text-blue-600' : ''}
              />
              <span className="text-xs mt-1 font-medium">{tab.label}</span>
            </button>
          );
        })}
      </div>
    </div>
  );
};

export default BottomNav;
