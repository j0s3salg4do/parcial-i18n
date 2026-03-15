import CharacterList from "@/components/CharacterList";
import { getDictionary } from "@/lib/dictionaries";

export default async function HomePage({
  params,
}: {
  params: Promise<{ lang: "es" | "en" }>;
}) {
  const { lang } = await params;
  const dict = await getDictionary(lang);

  return (
    <div className="mx-auto max-w-6xl py-8">
      <h1 className="text-center text-2xl font-bold text-[#d4a017]">
        {dict.homeTitle}
      </h1>

      <p className="mx-auto mb-8 mt-2 max-w-2xl text-center text-sm text-gray-700">
        {dict.homeDescription}
      </p>

      <CharacterList lang={lang} />
    </div>
  );
}