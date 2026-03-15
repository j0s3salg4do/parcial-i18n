import Image from "next/image";
import { Character } from "@/lib/api";
import { getHouseBorder } from "@/lib/houses";

type Props = {
  character: Character;
  dict: Record<string, string>;
};

export default function CharacterDetail({ character, dict }: Props) {
  const borderColor = getHouseBorder(character.house);
  const imageSrc =
    character.image && character.image.trim() !== ""
      ? character.image
      : "/placeholder-character.png";

  return (
    <section className="mx-auto flex max-w-3xl flex-col items-center px-6 py-8">
      <h1 className="mb-8 text-3xl font-bold text-[#d4a017]">{character.name}</h1>

      <article className={`grid overflow-hidden rounded-lg border-2 ${borderColor} bg-[#e0e0e0] md:grid-cols-2`}>
        <div className="flex min-h-[360px] flex-col justify-center gap-3 p-6 text-base font-semibold">
          <p><span className="font-bold">{dict.house}:</span> {character.house || dict.notAvailable}</p>
          <p><span className="font-bold">{dict.gender}:</span> {character.gender || dict.notAvailable}</p>
          <p><span className="font-bold">{dict.core}:</span> {character.wand?.core || dict.notAvailable}</p>
          <p><span className="font-bold">{dict.wood}:</span> {character.wand?.wood || dict.notAvailable}</p>
          <p>
            <span className="font-bold">{dict.length}:</span>{" "}
            {character.wand?.length ? `${character.wand.length} ${dict.cm}` : dict.notAvailable}
          </p>
        </div>

        <div className="relative min-h-[360px] w-full">
          <Image
            src={imageSrc}
            alt={character.name}
            fill
            className="object-cover"
            sizes="(max-width: 768px) 100vw, 400px"
          />
        </div>
      </article>
    </section>
  );
}