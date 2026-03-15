import type { Metadata } from "next";
import { notFound } from "next/navigation";
import CharacterDetail from "@/components/CharacterDetail";
import { getCharacterById } from "@/lib/api";
import { getDictionary } from "@/lib/dictionaries";

export async function generateMetadata({
  params,
}: {
  params: Promise<{ lang: "es" | "en"; id: string }>;
}): Promise<Metadata> {
  const { lang, id } = await params;
  const dict = await getDictionary(lang);
  const character = await getCharacterById(id);

  if (!character) {
    return {
      title: lang === "es" ? "Detalle - HarryPotterApp" : "Detail - HarryPotterApp",
      description: dict.detailDescription,
    };
  }

  return {
    title: lang === "es"
      ? `Detalle de ${character.name} - HarryPotterApp`
      : `Detail of ${character.name} - HarryPotterApp`,
    description: dict.detailDescription,
  };
}

export default async function CharacterDetailPage({
  params,
}: {
  params: Promise<{ lang: "es" | "en"; id: string }>;
}) {
  const { lang, id } = await params;
  const dict = await getDictionary(lang);
  const character = await getCharacterById(id);

  if (!character) {
    notFound();
  }

  return <CharacterDetail character={character} dict={dict} />;
}