import Navbar from '@/components/Navbar';
import Hero from '@/components/Hero';
import VaultShowcase from '@/components/VaultShowcase';
import AiClaimsDemo from '@/components/AiClaimsDemo';
import ComparisonSection from '@/components/ComparisonSection';
import ContactForm from '@/components/ContactForm';
import Footer from '@/components/Footer';

export default function Home() {
  return (
    <div className="min-h-screen bg-[#001219] text-white">
      <Navbar />
      <main>
        <Hero />
        <VaultShowcase />
        <AiClaimsDemo />
        <ComparisonSection />
        <ContactForm />
      </main>
      <Footer />
    </div>
  );
}
