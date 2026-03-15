import { getFirst12Characters } from "@/lib/api";
import CharacterCard from "./CharacterCard";

type Props = {
  lang: string;
};

export default async function CharacterList({ lang }: Props) {
  const characters = await getFirst12Characters();

  return (
    <section className="mx-auto grid max-w-5xl grid-cols-1 justify-items-center gap-6 px-6 pb-10 sm:grid-cols-2 lg:grid-cols-3">
      {characters.map((character) => (
        <CharacterCard key={character.id} character={character} lang={lang} />
      ))}
    </section>
  );
}