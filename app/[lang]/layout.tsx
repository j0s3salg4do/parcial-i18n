import type { Metadata } from "next";
import Header from "@/components/Header";
import Footer from "@/components/Footer";
import { getDictionary } from "@/lib/dictionaries";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ lang: "es" | "en" }>;
}): Promise<Metadata> {
  const { lang } = await params;

  return {
    title: lang === "es"
      ? "Listado de personajes - HarryPotterApp"
      : "Character list - HarryPotterApp",
    description: lang === "es"
      ? "Explora el universo mÃ¡gico de Harry Potter: un listado completo de personajes con su casa y detalles principales."
      : "Explore the magical universe of Harry Potter: a complete list of characters with their house and main details.",
  };
}

export default async function LangLayout({
  children,
  params,
}: Readonly<{
  children: React.ReactNode;
  params: Promise<{ lang: "es" | "en" }>;
}>) {
  const { lang } = await params;
  const dict = await getDictionary(lang);

  return (
    <html lang={lang}>
      <body className="min-h-screen bg-[#e0e0e0]">
        <Header lang={lang} />
        <main className="min-h-[calc(100vh-140px)]">{children}</main>
        <Footer rights={dict.footerRights} dev={dict.footerDev} />
      </body>
    </html>
  );
}