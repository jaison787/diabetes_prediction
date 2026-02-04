
import React from 'react';
import { useNavigate } from 'react-router-dom';

const Dashboard: React.FC = () => {
  const navigate = useNavigate();

  return (
    <div className="px-6 py-6 space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-700">
      <header className="flex justify-between items-center">
        <div>
          <h2 className="text-xs font-medium text-silver-400 tracking-wide uppercase">Good Morning,</h2>
          <h1 className="text-2xl font-bold silver-gradient-text">Alex Johnson</h1>
        </div>
        <div className="relative">
          <div className="p-0.5 rounded-full bg-gradient-to-tr from-white/20 to-white/40">
            <img 
              alt="Profile" 
              className="w-12 h-12 rounded-full object-cover border border-white/10" 
              src="https://lh3.googleusercontent.com/aida-public/AB6AXuDoiC-bPFms3pLg8hn98qQghmQXZZmv-5nsrSb8jlfbh_64FVw5WD34SAQHjmm0pzu3BpbqFgUcaJ-quGKp2qBmJxaL2LdZ4kIaTWODol91QCojkcbZciHVzDsu4u8y--S7lTFId3zCfgPBhaXBZs3fKtOoa0Jlz-i9QAViWrpdz197VpxMVO-Tsuj4QDUP4oLewUz1Xdo9AYClDzZaS4S_ZdhcmKp0WgLYAe6UgYSf6Bc1PwnxncGJ90xx2Jsi7Uq2fIRA1YBaxnk"
            />
          </div>
          <div className="absolute -top-0.5 -right-0.5 w-3.5 h-3.5 bg-silver-200 border-2 border-black rounded-full"></div>
        </div>
      </header>

      <section 
        onClick={() => navigate('/analysis')}
        className="glass-card-bright rounded-[2rem] p-6 relative overflow-hidden cursor-pointer group active:scale-[0.98] transition-all"
      >
        <div className="absolute top-0 right-0 w-32 h-32 bg-white/5 blur-3xl -mr-10 -mt-10 rounded-full"></div>
        <div className="flex justify-between items-start mb-4 relative z-10">
          <div>
            <h3 className="text-lg font-bold silver-gradient-text">Risk Assessment</h3>
            <p className="text-xs text-silver-400">Next check in 14 days</p>
          </div>
          <button className="w-8 h-8 flex items-center justify-center bg-white/10 rounded-full border border-white/10">
            <span className="material-symbols-outlined text-silver-300 text-lg">info</span>
          </button>
        </div>
        
        <div className="flex items-center justify-around py-2 relative z-10">
          <div className="relative w-36 h-36 flex items-center justify-center">
            {/* Simple CSS-based circular progress */}
            <div className="absolute inset-0 rounded-full" style={{ background: 'conic-gradient(rgba(226, 232, 240, 0.8) 12%, rgba(255, 255, 255, 0.05) 0deg)' }}></div>
            <div className="absolute inset-3 bg-[#111] rounded-full flex flex-col items-center justify-center shadow-2xl border border-white/5">
              <span className="text-3xl font-bold silver-gradient-text leading-none">12%</span>
              <span className="text-[9px] uppercase tracking-[0.1em] font-semibold text-silver-400 mt-1">Low Risk</span>
            </div>
          </div>
          <div className="space-y-5">
            <div className="flex items-center space-x-3">
              <div className="w-1.5 h-8 bg-white/80 rounded-full"></div>
              <div>
                <p className="text-[9px] uppercase font-bold text-silver-500 tracking-wider">Health Score</p>
                <p className="text-lg font-bold">88/100</p>
              </div>
            </div>
            <div className="flex items-center space-x-3">
              <div className="w-1.5 h-8 bg-silver-400/40 rounded-full"></div>
              <div>
                <p className="text-[9px] uppercase font-bold text-silver-500 tracking-wider">Last Update</p>
                <p className="text-lg font-bold">2 days ago</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section>
        <div className="flex justify-between items-center mb-4">
          <h3 className="text-base font-bold text-white">Quick Stats</h3>
          <button className="text-silver-300 text-xs font-semibold">See details</button>
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div className="glass-card p-4 rounded-2xl">
            <div className="flex items-center space-x-2 text-silver-200 mb-2">
              <span className="material-symbols-outlined text-lg">water_drop</span>
              <span className="text-[10px] font-bold uppercase tracking-widest">Glucose</span>
            </div>
            <p className="text-2xl font-bold">98 <span className="text-sm font-normal text-silver-500">mg/dL</span></p>
            <p className="text-[10px] text-white/60 mt-2 flex items-center">
              <span className="material-symbols-outlined text-[12px] mr-1">trending_down</span> -2% today
            </p>
          </div>
          <div className="glass-card p-4 rounded-2xl">
            <div className="flex items-center space-x-2 text-silver-200 mb-2">
              <span className="material-symbols-outlined text-lg">science</span>
              <span className="text-[10px] font-bold uppercase tracking-widest">HbA1c</span>
            </div>
            <p className="text-2xl font-bold">5.4 <span className="text-sm font-normal text-silver-500">%</span></p>
            <p className="text-[10px] text-silver-500 mt-2 uppercase tracking-tighter">Normal Range</p>
          </div>
        </div>
      </section>

      <section>
        <div className="flex justify-between items-center mb-4">
          <div className="flex items-center space-x-2">
            <h3 className="text-base font-bold text-white">Appointments</h3>
            <span className="bg-white/10 text-white text-[10px] px-2 py-0.5 rounded-full border border-white/10 font-bold">2</span>
          </div>
          <button onClick={() => navigate('/schedule')} className="text-silver-300 text-xs font-semibold">View all</button>
        </div>
        <div className="space-y-4">
          <div 
            onClick={() => navigate('/appointment/1')}
            className="glass-card-bright rounded-2xl p-5 relative overflow-hidden flex shadow-2xl cursor-pointer active:scale-[0.98] transition-all"
          >
            <div className="absolute -right-6 -bottom-6 w-32 h-32 bg-white/5 rounded-full blur-2xl"></div>
            <div className="flex-1 z-10">
              <div className="flex items-center space-x-2 bg-white/5 w-max px-3 py-1 rounded-full mb-3 border border-white/10">
                <span className="material-symbols-outlined text-[14px] text-silver-300">calendar_today</span>
                <span className="text-[10px] font-medium text-silver-200">March 25th, 12:30 PM</span>
              </div>
              <h4 className="text-lg font-bold silver-gradient-text">Dr. Adam Max</h4>
              <p className="text-silver-400 text-xs mb-4">Endocrinologist</p>
              <div className="flex space-x-2">
                <button className="bg-white text-black text-[10px] font-bold px-4 py-2 rounded-lg uppercase tracking-wider">Confirm</button>
                <button className="bg-white/10 text-white text-[10px] font-bold px-4 py-2 rounded-lg uppercase tracking-wider border border-white/10">Reschedule</button>
              </div>
            </div>
            <div className="z-10 relative">
              <img 
                alt="Dr. Adam Max" 
                className="w-20 h-20 rounded-2xl object-cover shadow-2xl border border-white/20" 
                src="https://lh3.googleusercontent.com/aida-public/AB6AXuBzLC3lJ_kIx49_QqCu83IeZksEkFnWC2nid0M_rpkj8jQqnQz7-o8q7KRD7TyxXK9yaieUY0yCCuObF8etXc5gfuV1cjbs3F5R398xXjN-1wrzTn1WgLxsNjA6K7ru1ucvqQz9KRy0nBQz5ls_nKo3FU9aibTGtvIGfMATCH3JZowro15nIQDNLvOA2LjmXQfXrFY6uMgZ-mFr1uno_hq9japLA8aBoQX5X93qEtx8eBq2qz5lWqQ58JaYarnxmd-YlxuJ4d-MaTw"
              />
              <div className="absolute -bottom-1 -right-1 bg-white p-1 rounded-lg">
                <span className="material-symbols-outlined text-[14px] text-black">videocam</span>
              </div>
            </div>
          </div>
        </div>
      </section>

      <section>
        <h3 className="text-base font-bold mb-4">Health Activity</h3>
        <div className="space-y-3">
          <div className="flex items-center justify-between p-4 glass-card rounded-2xl">
            <div className="flex items-center space-x-4">
              <div className="w-10 h-10 rounded-full bg-white/5 flex items-center justify-center border border-white/10">
                <span className="material-symbols-outlined text-silver-300 text-xl">directions_walk</span>
              </div>
              <div>
                <h4 className="text-sm font-bold">Evening Walk</h4>
                <p className="text-[10px] text-silver-500">4,250 steps • Today, 6:00 PM</p>
              </div>
            </div>
            <p className="text-sm font-bold text-white">+120 pts</p>
          </div>
        </div>
      </section>
    </div>
  );
};

export default Dashboard;
