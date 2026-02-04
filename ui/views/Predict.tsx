
import React from 'react';
import { useNavigate } from 'react-router-dom';

const Predict: React.FC = () => {
  const navigate = useNavigate();

  return (
    <div className="px-6 py-6 space-y-8 animate-in fade-in slide-in-from-right-4 duration-500">
      <header className="flex items-center justify-between border-b border-white/10 pb-4 -mx-6 px-6">
        <div className="flex items-center gap-4">
          <button onClick={() => navigate(-1)} className="w-10 h-10 flex items-center justify-center rounded-full glass-card text-white">
            <span className="material-symbols-outlined">arrow_back_ios_new</span>
          </button>
          <h1 className="text-lg font-bold tracking-tight">Risk Assessment</h1>
        </div>
        <button className="w-10 h-10 flex items-center justify-center rounded-full glass-card text-white">
          <span className="material-symbols-outlined">info</span>
        </button>
      </header>

      <div className="space-y-2">
        <h2 className="text-2xl font-bold tracking-tight">Clinical Data</h2>
        <p className="text-white/50 text-sm leading-relaxed">Enter patient metrics for high-precision diabetes risk assessment.</p>
      </div>

      <form className="space-y-6" onSubmit={(e) => { e.preventDefault(); navigate('/analysis'); }}>
        <div className="grid grid-cols-2 gap-4">
          <div className="space-y-2">
            <label className="block text-[10px] font-bold uppercase tracking-[0.1em] text-white/40 px-1">Gender</label>
            <select className="w-full bg-white/5 border border-white/10 rounded-2xl py-3 px-4 focus:ring-0 focus:border-white transition-all text-sm outline-none">
              <option className="bg-zinc-900">Male</option>
              <option className="bg-zinc-900">Female</option>
              <option className="bg-zinc-900">Other</option>
            </select>
          </div>
          <div className="space-y-2">
            <label className="block text-[10px] font-bold uppercase tracking-[0.1em] text-white/40 px-1">Age</label>
            <input 
              className="w-full bg-white/5 border border-white/10 rounded-2xl py-3 px-4 focus:ring-0 focus:border-white transition-all text-sm outline-none" 
              placeholder="e.g. 45" 
              type="number"
            />
          </div>
        </div>

        <div className="space-y-3">
          <div className="flex items-center justify-between p-4 glass-card rounded-2xl">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-xl bg-white/10 flex items-center justify-center text-silver-200">
                <span className="material-symbols-outlined">monitor_heart</span>
              </div>
              <div>
                <p className="text-[15px] font-semibold">Hypertension</p>
                <p className="text-[11px] text-white/40">History of high blood pressure</p>
              </div>
            </div>
            <label className="relative inline-flex items-center cursor-pointer">
              <input className="sr-only peer" type="checkbox" />
              <div className="w-12 h-6 bg-white/10 rounded-full peer peer-checked:after:translate-x-6 after:content-[''] after:absolute after:top-[3px] after:left-[3px] after:bg-white after:rounded-full after:h-[18px] after:w-[18px] after:transition-all peer-checked:bg-silver-400"></div>
            </label>
          </div>
          
          <div className="flex items-center justify-between p-4 glass-card rounded-2xl">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-xl bg-white/10 flex items-center justify-center text-silver-200">
                <span className="material-symbols-outlined">favorite</span>
              </div>
              <div>
                <p className="text-[15px] font-semibold">Heart Disease</p>
                <p className="text-[11px] text-white/40">Any cardiovascular conditions</p>
              </div>
            </div>
            <label className="relative inline-flex items-center cursor-pointer">
              <input className="sr-only peer" type="checkbox" />
              <div className="w-12 h-6 bg-white/10 rounded-full peer peer-checked:after:translate-x-6 after:content-[''] after:absolute after:top-[3px] after:left-[3px] after:bg-white after:rounded-full after:h-[18px] after:w-[18px] after:transition-all peer-checked:bg-silver-400"></div>
            </label>
          </div>
        </div>

        <div className="space-y-4">
          <div className="space-y-2">
            <label className="block text-[10px] font-bold uppercase tracking-[0.1em] text-white/40 px-1">Smoking History</label>
            <select className="w-full bg-white/5 border border-white/10 rounded-2xl py-3 px-4 focus:ring-0 focus:border-white text-sm outline-none">
              <option className="bg-zinc-900">Never</option>
              <option className="bg-zinc-900">Former smoker</option>
              <option className="bg-zinc-900">Current smoker</option>
            </select>
          </div>
          <div className="space-y-2">
            <label className="block text-[10px] font-bold uppercase tracking-[0.1em] text-white/40 px-1">Body Mass Index (BMI)</label>
            <div className="relative">
              <input className="w-full bg-white/5 border border-white/10 rounded-2xl py-3 px-4 focus:ring-0 focus:border-white text-sm outline-none pr-16" placeholder="24.5" step="0.1" type="number" />
              <span className="absolute right-4 top-3.5 text-white/30 text-xs font-medium">kg/m²</span>
            </div>
          </div>
        </div>

        <div className="grid grid-cols-2 gap-4">
          <div className="space-y-2">
            <label className="block text-[10px] font-bold uppercase tracking-[0.1em] text-white/40 px-1">HbA1c Level</label>
            <div className="relative">
              <input className="w-full bg-white/5 border border-white/10 rounded-2xl py-3 px-4 focus:ring-0 focus:border-white text-sm outline-none pr-10" placeholder="5.7" step="0.1" type="number" />
              <span className="absolute right-4 top-3.5 text-white/30 text-xs font-medium">%</span>
            </div>
          </div>
          <div className="space-y-2">
            <label className="block text-[10px] font-bold uppercase tracking-[0.1em] text-white/40 px-1">Blood Glucose</label>
            <div className="relative">
              <input className="w-full bg-white/5 border border-white/10 rounded-2xl py-3 px-4 focus:ring-0 focus:border-white text-sm outline-none pr-14" placeholder="140" type="number" />
              <span className="absolute right-4 top-3.5 text-white/30 text-xs font-medium">mg/dL</span>
            </div>
          </div>
        </div>

        <button 
          type="submit"
          className="w-full bg-white text-black font-bold py-4 rounded-2xl shadow-[0_0_20px_rgba(255,255,255,0.15)] active:scale-[0.97] transition-all flex items-center justify-center gap-2 mb-12"
        >
          <span className="material-symbols-outlined">analytics</span>
          Run Risk Assessment
        </button>
      </form>
    </div>
  );
};

export default Predict;
