
import React from 'react';
import { useNavigate } from 'react-router-dom';

const Schedule: React.FC = () => {
  const navigate = useNavigate();

  const appointments = [
    {
      id: 1,
      name: 'Dr. Adam Max',
      role: 'Endocrinologist',
      date: 'March 25th • 12:30 PM',
      type: 'Follow-up Visit',
      img: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDndrll3daHBEC86jquscSQIECgVTYbgE7vmboXcKJgIDaETYrlSRxf74wVFnKzWoe_HHj7oBYC_XBGg-DxE50RTf4hve-wVZ16-Ir-O8qqfcIpTZ7M2GaLJnA47P64VOhQZlakc9X3vuHLWlJ5S8HbP05gz6_nOLrlBGx-qvXC9ER1CUxUpQGDXqzfozxNkW8ziBCICBqBXVcKb_JMjwALKO9Hpv33xAvQ1f7SAq-1SlyIx0odez7jd2HYZl7B0yDH5gYdydyK21U'
    },
    {
      id: 2,
      name: 'Dr. Sarah Jenkins',
      role: 'General Practitioner',
      date: 'March 28th • 09:15 AM',
      type: 'Risk Assessment',
      img: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAq9Rx_NjM52qyg-vG__qwMnh-SQ-0rdZbfuNCteKQEbOqXiCJ5kDldYvTKkbZOszo5IP7hlv4ORMKqxGEcrIBEOhPZlGreeJ-9QyovIRL1IyKVImEB6nQL-UYdwPU15omyQOeiDZTgKwIZdt4ZOcJoSTBXOM2f5mGqhTOFfEuL5nywbytEidq_n9gvyrkMK-GB5yg6sRAjHxtwvmLucVwCPfrfwghsFZA-7Ayu1CA5pRHDpezlLLuFU2gEXHDeFy9IH_XJS4V-2G0'
    },
    {
      id: 3,
      name: 'Dr. Robert Chen',
      role: 'Nutrition Specialist',
      date: 'April 2nd • 02:00 PM',
      type: 'Dietary Review',
      img: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAuoeTjmB8sWTGop5YavNEoe87HhyHECNukzgvHMf75ScF4R0CsBM7lRIGAIYGONdCAFj5y-D9Cr4_c3p9zZ_kYzuJWqDUqKHR6r3qTI3GegXCp425FQGdEvpe_Uto1KTcKQSeCIh371Z52t1HUJg6y0Lse7ewfybDt58YRmjmq1CVr03j681mNubXE1WeZPWB1MhrkckHut4piHW7N_VOi5uz280Va-vtA_VgRGk8cD-0haVxrYjtKE-uvDidLYwiullhbybe_5b8'
    }
  ];

  return (
    <div className="px-6 py-6 space-y-8 animate-in fade-in slide-in-from-left-4 duration-500">
      <div className="flex items-center justify-between mb-8">
        <div className="flex items-center space-x-3">
          <h1 className="text-2xl font-bold tracking-tight">Upcoming Appointments</h1>
          <span className="bg-white text-black text-[10px] font-bold px-2 py-0.5 rounded-full">3</span>
        </div>
        <button className="p-2.5 rounded-full bg-white/5 border border-white/10 text-white/70 active:scale-95 transition-transform">
          <span className="material-symbols-outlined text-[20px]">tune</span>
        </button>
      </div>

      <div className="space-y-4">
        {appointments.map((apt) => (
          <div 
            key={apt.id}
            onClick={() => navigate(`/appointment/${apt.id}`)}
            className="relative overflow-hidden rounded-[2rem] glass-card p-6 cursor-pointer active:scale-[0.98] transition-all group hover:bg-white/10"
          >
            <div className="absolute top-0 right-0 w-40 h-40 bg-white/5 rounded-full -mr-16 -mt-16 blur-3xl"></div>
            <div className="relative z-10 flex items-start justify-between">
              <div className="space-y-4 w-2/3">
                <div className="flex items-center space-x-2 text-white/60 text-[10px] font-bold uppercase tracking-wider">
                  <span className="material-symbols-outlined text-[14px]">calendar_today</span>
                  <span>{apt.date}</span>
                </div>
                <div>
                  <h3 className="text-xl font-bold text-white">{apt.name}</h3>
                  <p className="text-white/50 text-sm">{apt.role}</p>
                </div>
                <div className="pt-2">
                  <span className="bg-white/10 px-3 py-1 rounded-full text-[10px] font-bold border border-white/20 text-white/80 uppercase tracking-tight">
                    {apt.type}
                  </span>
                </div>
              </div>
              <div className="w-1/3 flex justify-end">
                <div className="relative">
                  <div className="w-20 h-20 rounded-2xl overflow-hidden border border-white/20">
                    <img 
                      alt={apt.name} 
                      className="w-full h-full object-cover grayscale brightness-110" 
                      src={apt.img}
                    />
                  </div>
                  {apt.id === 1 && (
                    <div className="absolute -bottom-1 -right-1 bg-white w-4 h-4 rounded-full border-2 border-black"></div>
                  )}
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Schedule;
