import "server-only";

const dictionaries = {
  es: () => import("@/i18n/dictionaries/es.json").then((m) => m.default),
  en: () => import("@/i18n/dictionaries/en.json").then((m) => m.default),
};

export async function getDictionary(lang: "es" | "en") {
  if (lang === "en") return dictionaries.en();
  return dictionaries.es();
}