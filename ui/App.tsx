
import React, { useState } from 'react';
import { HashRouter, Routes, Route, Navigate, useLocation, useNavigate } from 'react-router-dom';
import Dashboard from './views/Dashboard';
import Predict from './views/Predict';
import Analysis from './views/Analysis';
import Schedule from './views/Schedule';
import AppointmentDetails from './views/AppointmentDetails';
import BottomNav from './components/BottomNav';
import StatusBar from './components/StatusBar';

const App: React.FC = () => {
  return (
    <HashRouter>
      <div className="flex flex-col min-h-screen bg-black overflow-hidden relative select-none max-w-md mx-auto border-x border-white/10">
        <StatusBar />
        
        <main className="flex-1 overflow-y-auto pb-32">
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/predict" element={<Predict />} />
            <Route path="/analysis" element={<Analysis />} />
            <Route path="/schedule" element={<Schedule />} />
            <Route path="/appointment/:id" element={<AppointmentDetails />} />
            <Route path="*" element={<Navigate to="/" />} />
          </Routes>
        </main>

        <BottomNav />
      </div>
    </HashRouter>
  );
};

export default App;
