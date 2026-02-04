
import React from 'react';
import { useLocation, useNavigate } from 'react-router-dom';

const BottomNav: React.FC = () => {
  const location = useLocation();
  const navigate = useNavigate();

  const navItems = [
    { icon: 'home', label: 'Home', path: '/' },
    { icon: 'assignment', label: 'Predict', path: '/predict' },
    { icon: 'add', label: '', path: '/predict', isCenter: true },
    { icon: 'medical_services', label: 'Doctors', path: '/schedule' },
    { icon: 'person', label: 'Profile', path: '/profile' }
  ];

  return (
    <nav className="fixed bottom-0 w-full max-w-md bg-black/80 backdrop-blur-2xl border-t border-white/10 pb-8 pt-4 z-[100]">
      <div className="flex justify-around items-center px-4 relative">
        {navItems.map((item, idx) => {
          if (item.isCenter) {
            return (
              <div key={idx} className="relative -top-10">
                <button 
                  onClick={() => navigate(item.path)}
                  className="w-14 h-14 bg-white text-black rounded-2xl shadow-xl shadow-white/5 flex items-center justify-center active:scale-90 transition-transform"
                >
                  <span className="material-symbols-outlined text-3xl font-bold">add</span>
                </button>
              </div>
            );
          }

          const isActive = location.pathname === item.path;
          return (
            <button
              key={idx}
              onClick={() => navigate(item.path)}
              className={`flex flex-col items-center gap-0.5 transition-colors ${isActive ? 'text-white' : 'text-white/30'}`}
            >
              <span className={`material-symbols-outlined text-[24px] ${isActive ? 'font-bold' : ''}`}>
                {item.icon}
              </span>
              <span className={`text-[9px] uppercase tracking-widest font-bold`}>{item.label}</span>
            </button>
          );
        })}
      </div>
      <div className="absolute bottom-2 left-1/2 -translate-x-1/2 w-32 h-1.5 bg-white/20 rounded-full"></div>
    </nav>
  );
};

export default BottomNav;
