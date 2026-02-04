
import React from 'react';

const StatusBar: React.FC = () => {
  return (
    <div className="flex justify-between items-end px-8 pt-4 pb-2 text-[13px] font-semibold sticky top-0 bg-black/40 backdrop-blur-md z-[100] w-full">
      <span>9:41</span>
      <div className="flex items-center space-x-1.5">
        <span className="material-symbols-outlined text-[16px]">signal_cellular_alt</span>
        <span className="material-symbols-outlined text-[16px]">wifi</span>
        <span className="material-symbols-outlined text-[16px]">battery_full</span>
      </div>
    </div>
  );
};

export default StatusBar;
