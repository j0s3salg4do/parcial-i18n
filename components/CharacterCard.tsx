import Image from "next/image";
import Link from "next/link";
import { Character } from "@/lib/api";
import { getHouseBg } from "@/lib/houses";

type Props = {
  character: Character;
  lang: string;
};

export default function CharacterCard({ character, lang }: Props) {
  const bgColor = getHouseBg(character.house);
  const imageSrc =
    character.image && character.image.trim() !== ""
      ? character.image
      : "/placeholder-character.png";

  return (
    <Link href={`/${lang}/character/${character.id}`}>
      <article className="overflow-hidden rounded-md shadow-md transition hover:scale-[1.02]">
        <div className={`${bgColor} px-3 py-2 text-center text-xs font-bold text-white`}>
          {character.name}
        </div>

        <div className="relative h-[240px] w-[180px] bg-gray-200">
          <Image
            src={imageSrc}
            alt={character.name}
            fill
            className="object-cover"
            sizes="180px"
          />
        </div>
      </article>
    </Link>
  );
}