import "server-only";
import { defaultLocale, locales, type Locale } from "./config";

const dictionaries: Record<Locale, () => Promise<any>> = {
  es: () => import("./dictionaries/es.json").then((m) => m.default),
  en: () => import("./dictionaries/en.json").then((m) => m.default),
};

function normalizeLocale(lang: string): Locale {
  const base = (lang || "").toLowerCase().split("-")[0];
  return (locales as readonly string[]).includes(base) ? (base as Locale) : defaultLocale;
}

export async function getDictionary(lang: string) {
  const locale = normalizeLocale(lang);
  return dictionaries[locale]();
}