$ErrorActionPreference = "Stop"

function Ensure-Dir {
    param([string]$DirPath)

    if (-not (Test-Path -LiteralPath $DirPath)) {
        cmd /c "mkdir `"$DirPath`"" | Out-Null
    }
}

function Write-FileUtf8 {
    param(
        [string]$FilePath,
        [string]$Content
    )

    $parent = Split-Path -Parent $FilePath
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        cmd /c "mkdir `"$parent`"" | Out-Null
    }

    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText((Resolve-Path "." | Join-Path -ChildPath $FilePath), $Content, $utf8NoBom)
}

function Remove-IfExists {
    param([string]$TargetPath)

    if (Test-Path -LiteralPath $TargetPath) {
        Remove-Item -LiteralPath $TargetPath -Recurse -Force
    }
}

Write-Host "Preparando estructura del parcial..." -ForegroundColor Cyan

Ensure-Dir "app"
Ensure-Dir "app\[lang]"
Ensure-Dir "app\[lang]\character"
Ensure-Dir "app\[lang]\character\[id]"
Ensure-Dir "components"
Ensure-Dir "lib"
Ensure-Dir "i18n"
Ensure-Dir "i18n\dictionaries"
Ensure-Dir "public"

Remove-IfExists "app\[lang]\profile"

Write-FileUtf8 "lib\houses.ts" @'
export const BgColorHouses: Record<string, string> = {
  Gryffindor: "bg-[#740001]",
  Slytherin: "bg-[#1A472A]",
  Ravenclaw: "bg-[#0E1A40]",
  Hufflepuff: "bg-[#FFD800]",
  NoHouse: "bg-[#6B7280]",
};

export const BorderColorHouses: Record<string, string> = {
  Gryffindor: "border-[#740001]",
  Slytherin: "border-[#1A472A]",
  Ravenclaw: "border-[#0E1A40]",
  Hufflepuff: "border-[#FFD800]",
  NoHouse: "border-[#6B7280]",
};

export function getHouseBg(house?: string) {
  return BgColorHouses[house || ""] || BgColorHouses.NoHouse;
}

export function getHouseBorder(house?: string) {
  return BorderColorHouses[house || ""] || BorderColorHouses.NoHouse;
}
'@

Write-FileUtf8 "lib\api.ts" @'
export type Character = {
  id: string;
  name: string;
  image: string;
  house: string;
  gender: string;
  wizard: boolean;
  ancestry: string;
  species: string;
  actor: string;
  wand: {
    wood: string;
    core: string;
    length: number | null;
  };
};

const BASE_URL = "https://hp-api.onrender.com/api";

export async function getCharacters(): Promise<Character[]> {
  const res = await fetch(`${BASE_URL}/characters`, {
    next: { revalidate: 3600 },
  });

  if (!res.ok) {
    throw new Error("Error obteniendo personajes");
  }

  return res.json();
}

export async function getFirst12Characters(): Promise<Character[]> {
  const characters = await getCharacters();
  return characters.slice(0, 12);
}

export async function getCharacterById(id: string): Promise<Character | null> {
  const res = await fetch(`${BASE_URL}/character/${id}`, {
    next: { revalidate: 3600 },
  });

  if (!res.ok) {
    throw new Error("Error obteniendo personaje");
  }

  const data = await res.json();
  return data?.[0] || null;
}
'@

Write-FileUtf8 "lib\dictionaries.ts" @'
import "server-only";

const dictionaries = {
  es: () => import("@/i18n/dictionaries/es.json").then((m) => m.default),
  en: () => import("@/i18n/dictionaries/en.json").then((m) => m.default),
};

export async function getDictionary(lang: "es" | "en") {
  if (lang === "en") return dictionaries.en();
  return dictionaries.es();
}
'@

Write-FileUtf8 "i18n\dictionaries\es.json" @'
{
  "homeTitle": "Personajes de Harry Potter",
  "homeDescription": "Explora el universo mágico de Harry Potter: un listado de personajes con su casa y detalles principales.",
  "footerRights": "© 2026 Harry Potter App. Todos los derechos reservados.",
  "footerDev": "Desarrollado para: ISIS3710",
  "house": "Casa",
  "gender": "Género",
  "wand": "Varita",
  "wood": "Madera",
  "core": "Núcleo",
  "length": "Longitud",
  "cm": "cm",
  "notAvailable": "No disponible",
  "detailDescription": "Consulta información detallada del personaje."
}
'@

Write-FileUtf8 "i18n\dictionaries\en.json" @'
{
  "homeTitle": "Harry Potter Characters",
  "homeDescription": "Explore the magical universe of Harry Potter: a character list with house and main details.",
  "footerRights": "© 2026 Harry Potter App. All rights reserved.",
  "footerDev": "Developed for: ISIS3710",
  "house": "House",
  "gender": "Gender",
  "wand": "Wand",
  "wood": "Wood",
  "core": "Core",
  "length": "Length",
  "cm": "cm",
  "notAvailable": "Not available",
  "detailDescription": "Check detailed character information."
}
'@

Write-FileUtf8 "components\Header.tsx" @'
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
'@

Write-FileUtf8 "components\Footer.tsx" @'
type Props = {
  rights: string;
  dev: string;
};

export default function Footer({ rights, dev }: Props) {
  return (
    <footer className="bg-[#BBCCBB] px-4 py-3 text-xs font-semibold text-black">
      <div className="mx-auto flex max-w-6xl items-center justify-between">
        <span>{rights}</span>
        <span>{dev}</span>
      </div>
    </footer>
  );
}
'@

Write-FileUtf8 "components\CharacterCard.tsx" @'
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
'@

Write-FileUtf8 "components\CharacterList.tsx" @'
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
'@

Write-FileUtf8 "components\CharacterDetail.tsx" @'
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
'@

Write-FileUtf8 "app\[lang]\layout.tsx" @'
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
      ? "Explora el universo mágico de Harry Potter: un listado completo de personajes con su casa y detalles principales."
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
'@

Write-FileUtf8 "app\[lang]\page.tsx" @'
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
'@

Write-FileUtf8 "app\[lang]\character\[id]\page.tsx" @'
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
'@

Write-FileUtf8 "middleware.ts" @'
import { NextRequest, NextResponse } from "next/server";

const locales = ["es", "en"];
const defaultLocale = "es";

export function middleware(request: NextRequest) {
  const { pathname } = request.nextUrl;

  if (
    pathname.startsWith("/_next") ||
    pathname.startsWith("/api") ||
    pathname.includes(".")
  ) {
    return NextResponse.next();
  }

  const hasLocale = locales.some(
    (locale) => pathname === `/${locale}` || pathname.startsWith(`/${locale}/`)
  );

  if (hasLocale) {
    return NextResponse.next();
  }

  return NextResponse.redirect(new URL(`/${defaultLocale}${pathname}`, request.url));
}

export const config = {
  matcher: ["/((?!_next|api|favicon.ico).*)"],
};
'@

Write-FileUtf8 "next.config.ts" @'
import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  images: {
    remotePatterns: [
      {
        protocol: "https",
        hostname: "www.clipartmax.com",
      },
      {
        protocol: "https",
        hostname: "ik.imagekit.io",
      },
      {
        protocol: "https",
        hostname: "m.media-amazon.com",
      },
      {
        protocol: "https",
        hostname: "static.wikia.nocookie.net",
      },
    ],
  },
};

export default nextConfig;
'@

Write-FileUtf8 "public\placeholder-character.png" @'
'@

Write-Host ""
Write-Host "Listo. Script ejecutado." -ForegroundColor Green
Write-Host "Siguiente paso:" -ForegroundColor Yellow
Write-Host "1. npm install"
Write-Host "2. npm run dev"
Write-Host "3. abrir http://localhost:3000/es"
