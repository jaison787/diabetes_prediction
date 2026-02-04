
import React from 'react';
import { useNavigate } from 'react-router-dom';

const Analysis: React.FC = () => {
  const navigate = useNavigate();

  return (
    <div className="px-6 py-6 space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
      <header className="flex items-center justify-between">
        <button onClick={() => navigate(-1)} className="w-10 h-10 flex items-center justify-center glass-card rounded-full text-white/80">
          <span className="material-symbols-outlined">chevron_left</span>
        </button>
        <h1 className="text-base font-medium text-white tracking-wide uppercase">Assessment</h1>
        <button className="w-10 h-10 flex items-center justify-center glass-card rounded-full text-white/80">
          <span className="material-symbols-outlined">more_horiz</span>
        </button>
      </header>

      <div className="mt-4 glass-card rounded-[2.5rem] p-8 flex flex-col items-center relative overflow-hidden">
        <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-silver-600 via-white to-silver-600 opacity-20"></div>
        
        {/* Semi-circular gauge */}
        <div className="relative w-60 h-32 overflow-hidden mb-6">
          <div className="w-60 h-60 rounded-full border-[12px] border-white/5 absolute top-0 left-0"></div>
          <div 
            className="w-60 h-60 rounded-full border-[12px] border-transparent border-t-white/80 border-r-white/40 absolute top-0 left-0 transition-transform duration-1000 ease-out"
            style={{ transform: 'rotate(135deg)', filter: 'drop-shadow(0 0 8px rgba(255,255,255,0.2))' }}
          ></div>
          <div className="absolute inset-0 flex flex-col items-center justify-end pb-2">
            <span className="text-2xl font-light silver-gradient-text tracking-tight uppercase">Moderate</span>
            <p className="text-[9px] text-zinc-500 font-bold uppercase tracking-[0.2em] mt-1">Risk Profile</p>
          </div>
        </div>

        <div className="w-full h-[2px] bg-zinc-800 rounded-full overflow-hidden flex">
          <div className="h-full bg-zinc-400 w-1/3 opacity-30"></div>
          <div className="h-full bg-gradient-to-r from-zinc-400 to-white w-1/3"></div>
          <div className="h-full bg-zinc-800 w-1/3"></div>
        </div>
        <div className="w-full flex justify-between mt-3 text-[9px] font-bold text-zinc-500 uppercase tracking-widest">
          <span>Low</span>
          <span className="text-zinc-300">Moderate</span>
          <span>High</span>
        </div>
      </div>

      <section>
        <h2 className="text-xs font-semibold text-zinc-400 uppercase tracking-widest mb-4 px-1">Primary Metrics</h2>
        <div className="space-y-3">
          <div className="flex items-center p-4 glass-card rounded-2xl group active:scale-[0.98] transition-all">
            <div className="w-11 h-11 bg-white/10 rounded-xl flex items-center justify-center mr-4 border border-white/10">
              <span className="material-symbols-outlined text-zinc-300">science</span>
            </div>
            <div className="flex-1">
              <h3 className="font-medium text-white text-sm">HbA1c Levels</h3>
              <p className="text-xs text-zinc-500">Value: 6.2% (Pre-diabetic)</p>
            </div>
            <span className="material-symbols-outlined text-white/40 text-sm">info</span>
          </div>
          <div className="flex items-center p-4 glass-card rounded-2xl group active:scale-[0.98] transition-all">
            <div className="w-11 h-11 bg-white/10 rounded-xl flex items-center justify-center mr-4 border border-white/10">
              <span className="material-symbols-outlined text-zinc-300">monitor_weight</span>
            </div>
            <div className="flex-1">
              <h3 className="font-medium text-white text-sm">Body Mass Index</h3>
              <p className="text-xs text-zinc-500">BMI of 27.4 (Overweight)</p>
            </div>
            <span className="material-symbols-outlined text-white/40 text-sm">info</span>
          </div>
        </div>
      </section>

      <section>
        <div className="p-5 rounded-3xl border border-white/5 bg-gradient-to-br from-zinc-900 to-black">
          <div className="flex items-start gap-4">
            <div className="mt-1 p-2 rounded-lg bg-zinc-800 border border-white/10">
              <span className="material-symbols-outlined text-zinc-300 text-lg">lightbulb</span>
            </div>
            <div>
              <h4 className="font-semibold text-zinc-100 text-sm mb-1">Professional Insight</h4>
              <p className="text-xs text-zinc-500 leading-relaxed">
                Moderate risk detected. Improving glycemic control through diet and monitored exercise can significantly lower future cardiovascular complications.
              </p>
            </div>
          </div>
        </div>
      </section>

      <button className="w-full bg-white py-4 rounded-2xl text-black font-bold flex items-center justify-center gap-2 shadow-[0_0_20px_rgba(255,255,255,0.1)] active:scale-95 transition-transform">
        <span className="material-symbols-outlined">event</span>
        <span className="uppercase tracking-widest text-xs">Book Specialist</span>
      </button>
    </div>
  );
};

export default Analysis;
