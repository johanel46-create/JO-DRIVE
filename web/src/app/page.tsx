export default function Home() {
  return (
    <main className="min-h-screen bg-[#0A0A0A] text-white">
      <nav className="fixed top-0 w-full bg-black/80 backdrop-blur border-b border-[#2A2A2A] z-50 px-6 py-4 flex justify-between items-center">
        <span className="text-2xl font-black">JO<span className="text-[#E30613]">'</span>DRIVE</span>
        <div className="hidden md:flex gap-8 text-sm text-gray-400">
          <a href="/reservation" className="hover:text-white">Réserver</a>
          <a href="/transporteur" className="hover:text-white">Devenir transporteur</a>
          <a href="/contact" className="hover:text-white">Contact</a>
        </div>
        <a href="/reservation" className="bg-[#E30613] text-white px-4 py-2 rounded text-sm font-semibold hover:bg-red-700">Réserver</a>
      </nav>
      <section className="pt-32 pb-20 px-6 text-center">
        <h1 className="text-5xl md:text-7xl font-black mb-6">
          Une seule plateforme pour vos<br/>
          <span className="text-[#E30613]">livraisons, transports</span><br/>
          et courses.
        </h1>
        <p className="text-xl text-gray-400 mb-10 max-w-2xl mx-auto">
          Trouvez rapidement un transporteur disponible partout en Guyane.
        </p>
        <div className="flex gap-4 justify-center flex-wrap">
          <a href="/reservation" className="bg-[#E30613] text-white px-8 py-4 rounded-lg font-bold text-lg hover:bg-red-700">Réserver maintenant</a>
          <a href="/transporteur" className="border border-white text-white px-8 py-4 rounded-lg font-bold text-lg hover:bg-white hover:text-black">Devenir transporteur</a>
        </div>
      </section>
      <section className="py-16 px-6 grid grid-cols-1 md:grid-cols-3 gap-6 max-w-5xl mx-auto">
        {[
          {title:'Livraison',desc:'Meubles, électroménager, colis, marchandises',icon:'📦'},
          {title:'Transport',desc:'Matériaux, bois, chantier, équipements',icon:'🚛'},
          {title:'Course',desc:'Récupération, livraison rapide, mission ponctuelle',icon:'⚡'},
        ].map(s => (
          <div key={s.title} className="bg-[#1A1A1A] border border-[#2A2A2A] rounded-xl p-6 hover:border-[#E30613] transition-colors">
            <div className="text-4xl mb-4">{s.icon}</div>
            <h3 className="text-xl font-bold mb-2">{s.title}</h3>
            <p className="text-gray-400">{s.desc}</p>
          </div>
        ))}
      </section>
      <footer className="border-t border-[#2A2A2A] py-8 text-center text-gray-500 text-sm">
        <p className="text-white font-black text-xl mb-2">JO<span className="text-[#E30613]">'</span>DRIVE</p>
        <p>Mobilité • Livraison • Course — Disponible en Guyane française</p>
      </footer>
    </main>
  )
}
