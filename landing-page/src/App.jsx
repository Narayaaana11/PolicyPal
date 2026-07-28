import React, { useState } from 'react';
import Navbar from './components/Navbar';
import Hero from './components/Hero';
import Features from './components/Features';
import ContactForm from './components/ContactForm';
import Footer from './components/Footer';
import PrivacyPage from './pages/PrivacyPage';
import TermsPage from './pages/TermsPage';

export default function App() {
  const [currentPage, setCurrentPage] = useState('home');

  return (
    <div>
      <Navbar />

      {currentPage === 'home' && (
        <main>
          <Hero />
          <Features />
          <ContactForm />
        </main>
      )}

      {currentPage === 'privacy' && <PrivacyPage onBack={() => setCurrentPage('home')} />}
      {currentPage === 'terms' && <TermsPage onBack={() => setCurrentPage('home')} />}

      <Footer onNavigate={(page) => setCurrentPage(page)} />
    </div>
  );
}
