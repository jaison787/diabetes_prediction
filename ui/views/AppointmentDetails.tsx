
import React from 'react';
import { useParams, useNavigate } from 'react-router-dom';

const AppointmentDetails: React.FC = () => {
  const { id } = useParams();
  const navigate = useNavigate();

  return (
    <div className="px-6 py-6 space-y-10 animate-in fade-in zoom-in duration-500 pb-40">
      <header className="flex items-center justify-between">
        <button onClick={() => navigate(-1)} className="w-10 h-10 flex items-center justify-center rounded-full glass-card">
          <span className="material-symbols-outlined text-white">arrow_back_ios_new</span>
        </button>
        <h1 className="text-sm font-bold uppercase tracking-widest text-silver-300">Appointment</h1>
        <button className="w-10 h-10 flex items-center justify-center rounded-full glass-card">
          <span className="material-symbols-outlined text-white text-xl">more_horiz</span>
        </button>
      </header>

      <div className="flex flex-col items-center text-center">
        <div className="relative mb-6">
          <div className="w-28 h-28 rounded-full border-2 border-white/20 p-1.5 glass-card overflow-hidden">
            <img 
              alt="Dr. Adam Max" 
              className="w-full h-full object-cover rounded-full grayscale-[0.2]" 
              src="https://lh3.googleusercontent.com/aida-public/AB6AXuDyxoWDidlcK9jdFEBts3559-NnJfKwWt9r9jE8jfNPVtGaujIJMUOoLGXNumBl5j8M9he9isejyBD1nnfkR2Pg6FoIYBvFt2ASUD1NhYZMVZ78acHENAT7i-wE5KkQdLxIParA1XrJdJ4P95HbHFU3MHF79g0s2WYvY5MyjmciFAZBObmWgFeNE99ZJEopxcpkq8QsCStwnPYF50943Ia889XYL5DS2PlT73tnDDkFNeLb-UHgcUZC6F9OUx0gV11afabfQaBXNm4"
            />
          </div>
        </div>
        <h2 className="text-3xl font-bold text-white tracking-tight">Dr. Adam Max</h2>
        <p className="text-silver-400 text-sm mb-8 font-medium">Endocrinologist • Diabetes Specialist</p>
        <div className="flex items-center gap-2 px-6 py-3 glass-card rounded-full text-white font-bold text-sm">
          <span className="material-symbols-outlined text-[18px] text-silver-300">calendar_month</span>
          March 25th, 12:30 PM
        </div>
      </div>

      <div className="grid grid-cols-3 gap-4">
        {[
          { icon: 'call', label: 'Call' },
          { icon: 'event_available', label: 'Calendar' },
          { icon: 'directions', label: 'Directions' }
        ].map((btn, idx) => (
          <button key={idx} className="flex flex-col items-center gap-2 group active:scale-95 transition-all">
            <div className="w-14 h-14 flex items-center justify-center rounded-2xl glass-card group-active:bg-white/10 transition-colors">
              <span className="material-symbols-outlined text-white text-2xl">{btn.icon}</span>
            </div>
            <span className="text-[10px] font-bold uppercase tracking-widest text-silver-400">{btn.label}</span>
          </button>
        ))}
      </div>

      <section>
        <h3 className="text-base font-bold mb-4 flex items-center gap-2 text-white uppercase tracking-wider">
          <span className="material-symbols-outlined text-xl text-silver-400">task_alt</span>
          Checklist
        </h3>
        <div className="space-y-3">
          <div className="flex items-center p-4 glass-card rounded-2xl">
            <div className="w-6 h-6 rounded-full border border-white/30 flex-shrink-0"></div>
            <div className="ml-4 flex-1">
              <p className="font-semibold text-sm text-white">Medical insurance</p>
              <p className="text-[10px] text-silver-500 uppercase font-bold tracking-tight">Required for claim</p>
            </div>
            <span className="material-symbols-outlined text-white/40">chevron_right</span>
          </div>
          <div className="flex items-center p-4 glass-card rounded-2xl bg-white/5 border-white/20">
            <div className="w-6 h-6 rounded-full bg-white flex items-center justify-center flex-shrink-0">
              <span className="material-symbols-outlined text-black text-[16px] font-bold">check</span>
            </div>
            <div className="ml-4 flex-1">
              <p className="font-semibold text-sm text-white">Upload Photo ID</p>
              <p className="text-[10px] text-silver-200 uppercase font-bold tracking-tight">Completed</p>
            </div>
            <span className="material-symbols-outlined text-white/40">chevron_right</span>
          </div>
        </div>
      </section>

      <section>
        <h3 className="text-base font-bold mb-4 text-white uppercase tracking-wider">Insurance Details</h3>
        <div className="p-5 glass-card rounded-3xl border-white/10 bg-gradient-to-br from-white/5 to-transparent">
          <div className="flex items-center justify-between mb-4">
            <div>
              <p className="text-[10px] text-silver-500 uppercase tracking-widest font-bold mb-1">Provider</p>
              <p className="font-semibold text-white">Medicare Original Part A & B</p>
            </div>
            <div className="w-8 h-8 rounded-full glass-card flex items-center justify-center">
              <span className="material-symbols-outlined text-white text-sm">info</span>
            </div>
          </div>
          <div className="pt-4 border-t border-white/5">
            <p className="text-[10px] text-silver-500 uppercase tracking-widest font-bold mb-1">Member ID</p>
            <p className="font-bold text-white tracking-[0.2em] font-mono">1EG4-TE5-MK21</p>
          </div>
        </div>
      </section>

      <section>
        <h3 className="text-base font-bold mb-4 text-white uppercase tracking-wider">Office Location</h3>
        <div className="relative h-48 rounded-[2rem] overflow-hidden glass-card group">
          <img 
            alt="Map" 
            className="w-full h-full object-cover opacity-40 contrast-125 grayscale" 
            src="https://lh3.googleusercontent.com/aida-public/AB6AXuDdb6R6EKo3NI00hZho2ViBFU7ykCllxuefZ3kK50PCzJ6-JR_fA8W_wc99oHAPIx4eUf5r2OVXwebRShe9nXQTiypmA9bfe7ZhSqiSOvacGqXTLZKGvIOf9JBG2I1_HXbva1N1b58wSULY2xs4bvTAGGrWQZceKgfAnqS8AOZLh3w_fGR_l_iM7ptYndiD49H4W5CNBE7p-Q-oNZHaEo4oaEtxN2aPf0Rj24X722gHrhOj7sdVMaDzN5hfqcgJzWq2IHPxX23qsHE"
          />
          <div className="absolute inset-0 flex items-center justify-center">
            <div className="w-12 h-12 bg-white rounded-full flex items-center justify-center shadow-2xl ring-4 ring-white/10">
              <span className="material-symbols-outlined text-black text-2xl font-bold">location_on</span>
            </div>
          </div>
          <div className="absolute bottom-4 right-4 glass-card px-4 py-2 rounded-xl text-[10px] font-bold text-white uppercase tracking-widest">
            Open in Maps
          </div>
        </div>
      </section>

      <div className="fixed bottom-0 left-1/2 -translate-x-1/2 w-full max-w-md p-6 bg-black/60 backdrop-blur-2xl border-t border-white/10 flex flex-col gap-3 z-[150]">
        <button className="w-full py-4 bg-white text-black font-bold rounded-2xl active:scale-[0.98] transition-all flex items-center justify-center gap-2 shadow-lg shadow-white/5">
          <span className="material-symbols-outlined text-xl">edit_calendar</span>
          Modify Appointment
        </button>
        <button className="w-full py-4 glass-card text-white font-semibold rounded-2xl active:bg-white/10 transition-colors uppercase text-xs tracking-widest">
          Cancel Appointment
        </button>
      </div>
    </div>
  );
};

export default AppointmentDetails;
