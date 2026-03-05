export const locales = ["es", "en"] as const;
export type Locale = (typeof locales)[number];

export const defaultLocale: Locale = "es";
export const COOKIE_NAME = "NEXT_LOCALE";