import Image from "next/image";
import Link from "next/link";

type Props = {
  lang: string;
};

export default function Header({ lang }: Props) {
  return (
    <header className="bg-[#FDB608] py-4">
      <div className="flex flex-col items-center justify-center">
        <Link href={`/${lang}`} aria-label="Go home">
          <Image
            src="https://www.clipartmax.com/png/full/71-713336_harry-potter-logo-harry-potter-logo-png.png"
            alt="Harry Potter Logo"
            width={180}
            height={60}
            priority
          />
        </Link>

        <div className="mt-3 flex gap-4 text-sm font-semibold">
          <Link href="/es">ES</Link>
          <Link href="/en">EN</Link>
        </div>
      </div>
    </header>
  );
}